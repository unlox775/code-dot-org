# Threat model: code-dot-org (Code.org / CodeAI learning platform)

> Draft for the OSS Scanner. Items marked **TODO(Dave)** are judgment calls that
> the Code.org security owner still has to make. Until they are resolved, the
> defaults written next to them apply.

## What this is

This is the monorepo behind https://studio.code.org ("dashboard") and code.org,
a free K-12 computer science and AI education platform. Most users are
**students, many of them under 13**, and their teachers. Some districts provision
accounts through SSO and rostering.

| Path | What it is | Weight for this scan |
|---|---|---|
| `dashboard/` | The Rails app: accounts, sections, curriculum, project storage, APIs, admin and levelbuilder tools. Includes the legacy Sinatra project-storage APIs mounted inside Rails (`dashboard/legacy/middleware/`) and the engines under `dashboard/engines/`. | **Primary** |
| `lib/`, `shared/` | Ruby libraries used by dashboard: config (`CDO`), DB, S3, secrets, project storage helpers, middleware. | **Primary** |
| `apps/src/`, `frontend/packages/`, `frontend/apps/` | Client JS/TS: student "labs" (App Lab, Game Lab, Web Lab, Python Lab, Music Lab, AI Lab, ...) and teacher dashboards. | **Primary** for DOM XSS, postMessage and sandbox escapes |
| `python/` | `pycdo` (called from Rails via pycall), and Python Lab's in-browser (Pyodide) support packages. | Secondary |
| `pegasus/` | Mostly retired marketing site. Only migrations, cache and rake tasks remain. | Low |
| `bin/`, `tools/`, `aws/`, `cookbooks/`, `k8s/`, `docker/` | Ops, deploy and infra tooling. Not reachable by users. | Low (see Out of scope) |

## Trust boundaries and where untrusted input enters

Treat all of the following as attacker-controlled:

1. **Any HTTP request to dashboard.** This covers anonymous visitors, signed-in students and signed-in teachers. Controllers live in `dashboard/app/controllers/` (including `api/v1/**`), and routes in `dashboard/config/routes.rb`.
2. **Student project content.** Source code, assets, files, animations and libraries are stored through `/v3/{sources,assets,files,animations,libraries}` and `/v3/channels` (`dashboard/legacy/middleware/files_api.rb`, `channels_api.rb`, helpers in `dashboard/legacy/middleware/helpers/`). That content is rendered back to:
   - the author
   - teachers, who view student work
   - anyone with a share link: `/projects/<type>/<channel>` share pages, `/c/:id`, the public gallery (`api/v1/projects/public_gallery_controller.rb`)
   - student-built HTML hosted on the codeprojects domains (Web Lab, and the Web Lab 2 / Python Lab preview via `codeprojects_preview_controller.rb` and `pyodide_sandbox_controller.rb`)
3. **Data blocks** (`datablock_storage_controller.rb`): App Lab / Game Lab key-value and table storage. Some endpoints are callable without sign-in and are rate-limited.
4. **Identity providers and rostering.** OmniAuth (Google, Microsoft, Facebook, Clever, ClassLink) via `omniauth_callbacks_controller.rb` and `dashboard/config/initializers/devise.rb`. Clever and ClassLink set `provider_ignores_state: true` because they start the flow. LTI 1.3 lives in `lti_v1_controller.rb` and `dashboard/app/controllers/lti/v1/*` (Canvas, Schoology, dynamic registration, deep linking, section sync). Clever / ClassLink / LTI roster sync creates and updates student accounts.
5. **Outbound-fetch endpoints (SSRF surface):**
   - `xhr_proxy_controller.rb`, with allowlists
   - `media_proxy_controller.rb`, `curriculum_proxy_controller.rb`, `redirect_proxy_controller.rb`
   - `/v3/images/moderate_url`
   - Python Lab's patched `requests`, which goes through the XHR proxy
6. **AI features.** `aichat_*`, `ai_*`, `openai_*` and `aidiff_*` controllers, plus jobs such as `aichat_request_chat_completion_job.rb` and `evaluate_rubric_job.rb`. These send student input to third-party LLMs and render model output back to students and teachers. In scope:
   - prompt injection that crosses a user boundary (one student's content steering what another user or a teacher sees or does)
   - leaking PII to a model provider beyond the intended design
   - model output rendered unsafely
7. **Teacher-supplied content.** Section names, rosters, student names, feedback and rubric comments, which are rendered to students.
8. **Levelbuilder / curriculum content** (`dashboard/config/scripts*`, `courses`, levels). This is authored by trusted Code.org staff. **TODO(Dave):** treat it as trusted (default: trusted; XSS that needs levelbuilder access is low severity).

## Highest-value assets and security properties

1. **Student PII and child privacy.** Data includes:
   - `users` columns: email / hashed_email, parent_email, birthday/age, name, username, gender, school, sign-in IPs, `properties`
   - `user_geos` (IP-derived location)
   - parental permission requests, authentication options (OAuth tokens)
   - AI chat logs, data-block storage, project content
   
   COPPA, FERPA and state student-privacy laws apply. Exposing a minor's PII to another user is the worst class of bug here.
2. **Account and role boundaries:**
   - Students vs. teachers vs. staff roles: `users.admin`, plus `UserPermission` (levelbuilder, project_validator, workshop_admin, facilitator, program_manager, universal_instructor, student_work_access, ...).
   - Authorization lives in `dashboard/app/models/ability.rb` (CanCanCan) and `dashboard/lib/policies/*`.
   - The key invariant: **a teacher may see and manage only students in their own sections; a student may see only their own work, or work that was explicitly shared.**
   - Section join codes, picture/word passwords for young students (`sections_controller`, `bypass_sign_in`), co-teacher invitations, account transfer, and student "takeover" / account linking all need care.
3. **Sessions and authentication.** The session cookie is `_learn_session` in a Redis session store. Also in scope: Devise password reset and confirmation, OAuth / LTI account linking, and CSRF. `ApplicationController` uses `protect_from_forgery with: :exception`, but about 30 actions are exempt (e.g. parts of `api/v1/users`, `sections_students`, `sections#update`, `transfers`, `user_levels#update`). Check that each exemption is safe.
4. **Admin impersonation:** `admin_users_controller#assume_identity`.
5. **Tokens we sign.** Javabuilder JWTs (`javabuilder_sessions_controller.rb`), AI-gateway tokens (`ai_gateway_auth_controller.rb`), LTI tokens (`dashboard/lib/lti_access_token.rb`), the JWKS at `/oauth/jwks` (`docs/jwks.md`).
6. **Isolation of student-hosted content.** Student HTML/JS must not run on a domain that holds studio.code.org cookies. See `docs/weblab-preview-domain-migration.md` and the CSP notes in `codeprojects_preview_controller.rb`.
7. **Secrets.** Production secrets come from AWS Secrets Manager (`!Secret` in `config.yml.erb`, `lib/cdo/secrets.rb`). A real secret committed to this public repo is in scope. The committed test stubs in `config/test.yml.erb`, `shared/test/fixtures/aws_credentials`, `docker/rails/adhoc.env` and `docker/developers/.env` are fake by design and should not be reported.

## In scope / out of scope

In scope: everything under `dashboard/`, `lib/`, `shared/`, `apps/src/`, `frontend/`, and `python/pycdo`.

**Out of scope** (default; **TODO(Dave)** confirm):

- **Vendored third-party code.** Report a vendored-library vulnerability only if our code makes it reachable, and report it against our usage. Vendored code includes:
  - `apps/lib/**` (Blockly, Ace, Droplet, jQuery UI, Phaser, Pyodide, ...)
  - minified bundles in `apps/static/` and `dashboard/public/`
  - the generated Clever client in `dashboard/lib/clever`
  - anything in `node_modules/` or the gem bundle
- **Infra and ops tooling.** `aws/`, `cookbooks/`, `k8s/`, `docker/`, `bin/`, `tools/` (CI, deploy, lint hooks). **TODO(Dave):** decide whether CI / GitHub workflow injection (`.github/`, `.drone.yml`) is wanted. Default: report only clear secret-exfiltration paths.
- **Test and dev-only code.** `*/test/**`, fixtures, VCR cassettes, `frontend/packages/e2e-tests`, `frontend/packages/playwright-support`, storybook, `experimental/`. `dev_controller.rb` and `test_ai_proxy_controller.rb` are in scope **only** if they are reachable in production; check the environment gating.
- `pegasus/`: low priority.
- **Student code running in the student's own browser.** App Lab, Game Lab, Python Lab (Pyodide) and Web Lab run student code in the browser by design. A student running arbitrary JS against their *own* session is not a finding. It **is** a finding when that code runs with another user's privileges, for example:
  - a shared project page executing on studio.code.org's origin with the viewer's cookies
  - escaping the codeprojects / preview sandbox
  - a postMessage handler trusting a project iframe

## How to exercise it (inside this image, offline)

The image is built by `.oss-scanner/Dockerfile`. Everything below was verified with no network on a 2 CPU / 8 GB container, as root from `/src`, with `RAILS_ENV=test` (already set). No secrets are needed: `config/test.yml.erb` stubs them all.

**What is installed:**

- Ruby 3.2.11 with every Gemfile group.
- Node 20 with yarn 4: `apps/` and `frontend/` dependencies installed, and the `frontend/packages` that `apps/` consumes already built.
- The uv venv, Python 3.12 with the dev group.
- MySQL 8.0 and Redis, with:
  - `dashboard_test` prepared the way CI prepares it (schema + test fixtures + `seed:test`, no curriculum content)
  - `pegasus_test` migrated

**Start the services first.** This takes about 1s, because the data is already in the image. Rails needs MySQL even to boot.

```bash
/src/.oss-scanner/start-services.sh            # MySQL 8 (root, no password, socket + 127.0.0.1:3306) + Redis
/src/.oss-scanner/start-services.sh --reset    # drop and re-prepare the test DBs (~2 min)
```

**Toolchain:**

```bash
bundle exec ruby -e 'puts :ok'
uv run --no-sync python -c 'import pycdo'
node --version                                       # v20.x
(cd apps && yarn --version) && (cd frontend && yarn --version)
cd dashboard && bundle exec rails runner 'p User.count'   # Rails console/runner against dashboard_test
```

**Ruby tests** (minitest; one file takes ~1-4 min on 2 CPUs):

```bash
cd /src/dashboard && bundle exec rails test test/models/ability_test.rb
cd /src/dashboard && bundle exec rails test test/controllers/api/v1/sections_students_controller_test.rb
cd /src/dashboard && bundle exec rails test test/models/user_test.rb
cd /src/dashboard && bundle exec rails test test/controllers/some_controller_test.rb -n /name_regex/
cd /src/dashboard/legacy && bundle exec ruby -Itest test/middleware/test_channels.rb   # project storage APIs
cd /src/lib && bundle exec ruby -Itest test/test_cdo.rb
```

**JS tests:**

```bash
cd /src/apps && yarn jest --maxWorkers=2 test/unit/<file-or-dir>     # Jest (apps/)
cd /src/frontend/packages/component-library && yarn test              # Vitest (frontend/ packages)
```

**Python tests:**

```bash
cd /src && uv run --no-sync pytest -q python/pycdo
```

**Writing a reproducer.** A dashboard test is the best form: a controller or integration test under `dashboard/test/` using the factories in `dashboard/test/factories/`. There is no curriculum seed data, so tests that need units, lessons or levels must create them with factories, as the existing tests do. `rails server` also works: `cd dashboard && bundle exec rails s -p 3000 -b 127.0.0.1` after `start-services.sh`, about 60s to boot. Verified: `/users/sign_in` 200, `/api/v1/users/current` 200, `/` 302. Pages render with the compiled CSS but without the webpack JS bundles, so client-side behavior has to be checked in Jest or by reading the code. Pages that need curriculum content, S3 or external services will error.

**What does not work offline in this image:**

- **No `yarn install`, `bundle install` or `uv sync` that needs new packages.** The yarn download caches were removed to save space; installed `node_modules` work.
- **No full `apps/` webpack build** (`yarn build`): too slow and memory-hungry for the value it adds here. The Jest prerequisites and the apps CSS (`apps/build/package/css`, served through `dashboard/public/blockly`) were generated with `.oss-scanner/Gruntfile.prebuild.js` (only `en_us` messages compiled). The webpack JS bundles are absent.
- **Git LFS image assets** (`*.png`, `*.jpg`, ... under `apps/static`, `dashboard/app/assets`, `dashboard/public`, ...) are LFS pointer files. Non-English locales, `apps/i18n` and test fixtures were fetched.
- **AWS (S3, Secrets Manager), Javabuilder, AI/LLM providers, Clever/Google/Microsoft OAuth and other external services are unreachable.** Code paths that call them fail or use test doubles.
- **UI/browser tests** (Cucumber/Selenium, Playwright, Karma) are not set up: no browsers are installed.

## How we rate severity

**TODO(Dave): confirm or adjust.** Suggested defaults:

- **Critical**
  - Unauthenticated access to, or modification of, other users' PII or accounts at scale (e.g. IDOR on a `users`/`sections` API, SQLi reachable without authentication, auth bypass, session forgery)
  - RCE on the server
  - Exposure of production secrets
- **High**
  - Authenticated cross-user access that crosses the student/teacher/section boundary (one teacher reads another teacher's students, a student reads another student's private project or PII)
  - Account takeover that needs a single victim click
  - Stored XSS that executes on a studio.code.org origin for other users (e.g. via a shared project, section name or feedback)
  - Post-auth SQLi
  - SSRF that reaches internal or cloud-metadata endpoints
  - Privilege escalation to teacher, levelbuilder or admin
- **Medium**
  - Reflected XSS
  - CSRF on a state-changing action with real impact
  - Stored XSS that needs an unusual victim action or is limited to the attacker's own section
  - SSRF limited to external hosts
  - Bypass of child-account / parental-consent policy (`dashboard/lib/policies/child_account*`) without PII exposure
  - Information leaks of non-PII internal data
- **Low**
  - Issues that need staff privileges (levelbuilder / admin) to exploit
  - Missing hardening headers
  - Open redirects without a chained impact
  - Rate-limit gaps
  - Self-XSS
- **DoS:** usually low. Medium if a single unauthenticated request can take down a shared resource (e.g. pathological regex, unbounded query).

Bugs affecting accounts of under-13 students should be rated one level higher when they expose PII. **TODO(Dave)**

## Report and patch preferences

**TODO(Dave): confirm.** Defaults:

- **Report contents.** One report per root cause. Group instances of the same pattern (e.g. the same missing authorization check in several actions of one controller) into one report and list the affected actions.
- **Reproducer.** Prefer a failing Rails test (minitest, `dashboard/test/...`) or a short request sequence (curl or `rails runner`) that runs inside this image. Do not use real student data.
- **Patch.** Provide a minimal patch that shows the fix, with a regression test where it is practical. It does not need to be merge-ready.

## Leave alone

**TODO(Dave):** add known-accepted risks and already-tracked issues. Defaults:

- **By design:**
  - Student code execution in the student's own browser (see Out of scope)
  - Public share links being publicly viewable
  - Clever/ClassLink `provider_ignores_state`, a documented IdP-initiated flow (report only a concrete exploit)
- **Test-environment stub secrets** (`config/test.yml.erb` and the files listed under Secrets above).
- **Dependency CVEs.** Do not report a vulnerable gem or npm version from the lockfiles unless you show it is reachable and exploitable through our code.
- **Not available offline in this image:**
  - production-only infrastructure (AWS, Secrets Manager, S3, CloudFront/WAF)
  - external services (Javabuilder, AI providers)
  
  Do not report "cannot connect" behaviour as a vulnerability.

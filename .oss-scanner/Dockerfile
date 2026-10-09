# OSS Scanner image for code-dot-org/code-dot-org.
#
# Build context: a fresh clone of this repository (including .git). The
# scanner builds this with network access, then runs the audit OFFLINE on a
# 2 CPU / 8 GB machine, so everything the audit may need is fetched here.
# See .oss-scanner/threat_model.md for what is installed and how to use it.
#
# No secrets are needed or baked in: locals.yml is a copy of the committed
# locals.yml.default and config/test.yml.erb stubs every secret in RAILS_ENV=test.

# Exact Ruby from .ruby-version, taken from the official image. Its binaries
# are built on Debian bookworm and run on Ubuntu 24.04 (newer glibc, same
# library sonames).
FROM docker.io/library/ruby:3.2.11-slim-bookworm@sha256:84140472007d27c7ec641dbc606a47ff9c0aa5f358445947b7350392fa5115e5 AS ruby

# Ubuntu 24.04 rather than Debian: it ships MySQL 8.0 (what the app targets),
# and matches the Ubuntu base of docker/ci/Dockerfile.
FROM docker.io/library/ubuntu:24.04@sha256:534baea6a22c03a63003dbc8dbe78fe34bc0d7e595d9a9dc9834884ff530eb55

ARG NODE_VERSION=20.20.2
ARG NODE_KEYS_REF=b28073028e6d6855cfb53bf7fa0137599c01f967
ARG BUNDLER_VERSION=2.5.17
ARG YARN_VERSION=4.12.0
# Same uv version as docker/build/Dockerfile, from the GitHub release with a
# pinned sha256.
ARG UV_VERSION=0.5.18
ARG UV_SHA256_X86_64=1dbaeffc5cfac769f99700c0fc8c4ef4494a339720c6bf8b79367b1acd701b46
ARG UV_SHA256_AARCH64=a511f609236b9bfc9dedfcb9867ef1d0f1dc23cc2012f9e4e38e0c184657fd31

# COREPACK_NPM_REGISTRY: corepack fetches yarn from the npm registry (where
# the JS deps come from anyway) instead of repo.yarnpkg.com.
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TZ=Etc/UTC \
    RAILS_ENV=test \
    RACK_ENV=test \
    DISABLE_SPRING=1 \
    GEM_HOME=/usr/local/bundle \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_APP_CONFIG=/usr/local/bundle \
    BUNDLE_SILENCE_ROOT_WARNING=1 \
    BUNDLE_JOBS=16 \
    PATH=/usr/local/bundle/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    COREPACK_HOME=/opt/corepack \
    COREPACK_ENABLE_DOWNLOAD_PROMPT=0 \
    COREPACK_NPM_REGISTRY=https://registry.npmjs.org \
    UV_PYTHON_PREFERENCE=only-system \
    UV_CACHE_DIR=/opt/uv/cache \
    UV_LINK_MODE=copy \
    TURBO_TELEMETRY_DISABLED=1 \
    STORYBOOK_DISABLE_TELEMETRY=1 \
    PUPPETEER_SKIP_DOWNLOAD=1 \
    PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1 \
    CYPRESS_INSTALL_BINARY=0

# System packages:
# - runtime libraries of the copied Ruby (ssl, yaml, ffi, gmp, readline)
# - mysql2 / rmagick build deps; git for git-sourced gems; compilers for
#   native gems and node-gyp
# - python3.12 + libpython3.12 for the uv venv and pycall (Rails boot)
# - mysql-server-8.0 and redis-server for the optional local services
#   (.oss-scanner/start-services.sh)
RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates curl gnupg git git-lfs build-essential pkg-config xz-utils \
      libssl-dev libyaml-dev libffi-dev libgmp-dev libreadline-dev zlib1g-dev \
      libxml2-dev libxslt1-dev \
      libmysqlclient-dev mysql-client mysql-server-8.0 redis-server \
      imagemagick libmagickwand-dev libjemalloc2 \
      python3 python3.12 python3.12-dev libpython3.12 \
      procps locales tzdata unzip \
    && rm -rf /var/lib/apt/lists/*

COPY --from=ruby /usr/local /usr/local
RUN ruby --version && ruby -ropenssl -ryaml -rfiddle -e 'puts OpenSSL::OPENSSL_LIBRARY_VERSION' \
    && gem install bundler -v "${BUNDLER_VERSION}" --no-document

# Node from nodejs.org, GPG-verified exactly as in docker/build/Dockerfile.
RUN set -eux; \
    case "$(dpkg --print-architecture)" in amd64) a=x64;; arm64) a=arm64;; *) exit 1;; esac; \
    t="node-v${NODE_VERSION}-linux-${a}.tar.gz"; cd /tmp; \
    curl -fsSLO "https://nodejs.org/dist/v${NODE_VERSION}/${t}"; \
    curl -fsSLO "https://nodejs.org/dist/v${NODE_VERSION}/SHASUMS256.txt.asc"; \
    curl -fsSLo nodejs-keyring.kbx "https://raw.githubusercontent.com/nodejs/release-keys/${NODE_KEYS_REF}/gpg/pubring.kbx"; \
    gpgv --keyring ./nodejs-keyring.kbx --output SHASUMS256.txt SHASUMS256.txt.asc; \
    grep " ${t}\$" SHASUMS256.txt | sha256sum -c -; \
    tar -xzf "${t}" -C /usr/local --strip-components=1 --no-same-owner; \
    rm -f "${t}" SHASUMS256.txt SHASUMS256.txt.asc nodejs-keyring.kbx; \
    corepack enable; node --version

RUN set -eux; \
    case "$(dpkg --print-architecture)" in \
      amd64) a=x86_64; sum="${UV_SHA256_X86_64}";; \
      arm64) a=aarch64; sum="${UV_SHA256_AARCH64}";; *) exit 1;; esac; \
    t="uv-${a}-unknown-linux-gnu.tar.gz"; cd /tmp; \
    curl -fsSLO "https://github.com/astral-sh/uv/releases/download/${UV_VERSION}/${t}"; \
    echo "${sum}  ${t}" | sha256sum -c -; \
    tar -xzf "${t}" --strip-components=1 -C /usr/local/bin; rm -f "${t}"; uv --version

# Yarn for frontend/ (apps/ vendors its own copy in apps/.yarn/releases),
# cached by corepack so `yarn` works offline.
RUN corepack install --global "yarn@${YARN_VERSION}" && yarn --version

# Scanner contract: the checkout lives at /src.
COPY . /src
WORKDIR /src

# Local config. The three overrides are what config/test.yml.erb applies to
# CI's unit-test job (CI_JOB=unit_tests); we don't set CI itself because that
# also points the DB/Redis at CI-only hostnames.
RUN cp locals.yml.default locals.yml \
    && printf '%s\n' '' '# oss-scanner: unit-test settings from config/test.yml.erb (CI_JOB=unit_tests)' \
         'optimize_rails_assets: false' 'optimize_webpack_assets: false' 'active_job_queue_adapter: :test' \
         >> locals.yml

# Git LFS. The scanner's clone has LFS *pointer files*, not content (about
# 1.5 GB of LFS objects, mostly images). Fetch only the text-like LFS paths
# that code and tests read (~525 MB): non-English locales, apps i18n and test
# fixtures, from GitHub's public LFS media endpoint at this commit, each
# verified against its pointer's sha256 (.oss-scanner/fetch-lfs.py). Images
# stay as pointers. Then `git lfs install --local` and re-read those paths'
# index entries from HEAD (which drops their recorded pointer-file sizes) and
# refresh: git then runs the LFS clean filter, which turns each file back into
# its identical pointer, so `git status` stays clean. No objects are written.
# (Not `git add`: it would touch the 3 GB pack file's mtime and so copy it into
# a new image layer. The clean filter copies every file into .git/lfs/objects;
# that duplicate is deleted.)
# Non-fatal (WARNING) because the step after it keeps Rails bootable without
# them; without the fixtures, though, most Ruby tests would fail.
ARG LFS_PATHS="dashboard/config/locales apps/i18n pegasus/cache/i18n dashboard/test/fixtures lib/test/fixtures"
RUN python3 .oss-scanner/fetch-lfs.py ${LFS_PATHS} \
    || echo "WARNING: fetch-lfs failed for some files; they stay LFS pointer files"; \
    git lfs install --local \
    && git rm -q -r --cached -- ${LFS_PATHS} && git reset -q -- ${LFS_PATHS} \
    && git update-index -q --refresh \
    && test -z "$(git status --porcelain --untracked-files=no)" \
    || echo "WARNING: git sees LFS-fetched files as changed"; \
    rm -rf .git/lfs/objects

# Any locale file that is still an LFS pointer (only if the fetch above
# failed) would stop Rails from booting: I18n loads every file under
# dashboard/config/locales and a pointer is not a hash. Replace those with an
# empty hash (they then show as modified in `git status`).
RUN grep -rlZ --include='*.yml' --include='*.yaml' --include='*.json' \
      '^version https://git-lfs.github.com/spec/v1' dashboard/config/locales \
    | xargs -0 -r sh -c 'for f; do echo "{}" > "$f"; done; echo "WARNING: stubbed $# LFS pointer locale files"' sh

# Ruby gems, all groups (staging/levelbuilder/adhoc/production add no gems of
# their own; development+test are needed for tests). The full tree is
# present, so the path-gem engines under dashboard/engines/* resolve.
RUN bundle install && bundle check

# Python venv with the dev group (pytest etc.), as `rake install` does for test.
RUN uv sync --frozen --dev && uv run --no-sync python -c 'import pycdo; print("pycdo ok")'

# JS dependencies. apps/ links frontend/packages/* via portal: and its jest
# tests import their built dist/ output, which the repo's own script builds
# (it also runs `yarn install` in frontend/). Both projects use the
# node-modules linker, so the yarn zip caches (apps/.yarn/cache and the global
# ~/.yarn/berry/cache) are not needed to run anything; dropping them in the
# same layer saves several GB. Re-installing offline is therefore not possible.
RUN cd /src/apps && yarn install --immutable && yarn cache clean --all \
    && ./script/build-frontend-dependencies.sh \
    && (cd /src/frontend && yarn cache clean --all) \
    && rm -rf /root/.yarn/berry/cache /root/.cache/node-gyp /tmp/*

# From here on the image is used offline.
ENV UV_OFFLINE=1 \
    UV_FROZEN=1

# Local MySQL 8 + Redis, with dashboard_test prepared the way CI does it
# (schema + fixtures + `seed:test`) and pegasus_test migrated, baked into
# the image so the audit starts fast. Rails needs the DB even to boot, and the
# apps/ "prebuild" outputs that Jest imports (build/locales, generated
# constants, region configs, studio routes) come from scripts that boot Rails,
# so that is generated here too, along with the compiled CSS that Rails views
# reference (.oss-scanner/Gruntfile.prebuild.js).
# Services are stopped at the end; .oss-scanner/start-services.sh restarts
# them during the audit.
# The symlink is what `rake package:apps:symlink` creates for local builds.
RUN ln -sfn ../../apps/build/package dashboard/public/blockly \
    && .oss-scanner/start-services.sh \
    && (cd apps && node -e "require('grunt').tasks(['oss-scanner-prebuild'], \
          {gruntfile: '../.oss-scanner/Gruntfile.prebuild.js', base: '.'})") \
    ; rc=$?; mysqladmin -uroot shutdown || true; redis-cli -h 127.0.0.1 shutdown nosave || true; \
    test $rc = 0 || echo "WARNING: services/prebuild failed (exit $rc): Ruby and apps Jest tests will not run"

RUN bundle exec ruby -e 'puts :ruby_ok' \
    && uv run --no-sync python -c 'import pycdo; print("py_ok")' \
    && node --version && (cd /src/apps && yarn --version) && (cd /src/frontend && yarn --version)

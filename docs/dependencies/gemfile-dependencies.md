# Gemfile Dependencies Analysis

> **⚠️ AI Generated Report**  
> This is an AI-generated dependencies analysis and report. Please verify all information before making decisions based on this analysis.

## Overview

This document provides a comprehensive analysis of all Ruby gem dependencies in the main Gemfile. Each dependency is categorized and analyzed for its necessity, usage patterns, and potential removal impact.

## Dependency Categories

### Core Ruby & Rails Framework
- [x] **rails** (~> 6.1) - Main web framework
  - **Usage**: Core web framework used throughout the application
  - **Files**: Found in 104 files across the codebase
  - **Key locations**:
    - `dashboard/config/application.rb:3` - Main application configuration
    - `dashboard/bin/rails:1` - Rails executable
    - `dashboard/config/initializers/devise.rb:3` - Devise configuration
  - **Necessity**: **CRITICAL** - Core framework, removing would break entire application
  - **Compensation if removed**: Would need to rewrite entire web application using different framework
  - **Documentation**: [Rails Guides](https://guides.rubyonrails.org/) | [GitHub](https://github.com/rails/rails)
  - **Current version**: 6.1.x | **Latest stable**: 7.1.x | **Upgrade path**: Major version upgrade with breaking changes

- [ ] **rails-controller-testing** (~> 1.0.5) - Testing utilities for Rails controllers
- [ ] **sprockets** - Asset pipeline (custom fork)
- [ ] **responders** (~> 3.0) - Rails respond_to methods

### Ruby Version Compatibility
- [ ] **thwait** - Ruby 2.7 compatibility
- [ ] **cgi** (~> 0.3.6) - CGI library for Ruby >= 2.7.7
- [ ] **sorted_set** - Ruby 3.0 compatibility
- [ ] **mutex_m** - Ruby >= 3.4 compatibility
- [ ] **abbrev** - ActiveSupport compatibility
- [ ] **drb** - ActiveSupport compatibility
- [ ] **observer** - ActiveSupport compatibility
- [ ] **syslog** - ActiveSupport compatibility

### Web Server & Middleware
- [ ] **sinatra** (2.2.3) - Lightweight web framework
- [ ] **puma** (~> 5.6) - Web server
- [ ] **puma_worker_killer** - Puma worker management
- [ ] **raindrops** - Puma monitoring
- [ ] **sd_notify** - Systemd integration
- [ ] **rack-cache** - HTTP caching
- [ ] **rack-ssl-enforcer** - SSL enforcement
- [ ] **rack-cors** (~> 2.0.1) - CORS handling

### Database & Caching
- [x] **mysql2** (>= 0.4.1) - MySQL database adapter
  - **Usage**: Primary database adapter for MySQL connections
  - **Files**: Found in 3 files across the codebase
  - **Key locations**:
    - `dashboard/config/initializers/mysql_check_index_used.rb:1` - MySQL index checking
    - `pegasus/test/fixtures/fake_dashboard.rb:1` - Test fixtures
    - `experimental/curriculum_guid_migration/phase2_test_dual_system/standalone_guid_generator.rb:1` - Migration tool
  - **Necessity**: **CRITICAL** - Primary database adapter, removing would break all database operations
  - **Compensation if removed**: Would need to migrate to different database or use different adapter
  - **Documentation**: [mysql2 GitHub](https://github.com/brianmario/mysql2) | [RubyGems](https://rubygems.org/gems/mysql2)
  - **Current version**: >= 0.4.1 | **Latest stable**: 0.5.x | **Upgrade path**: Minor version updates available

- [ ] **dalli** - Memcached client
- [ ] **dalli-elasticache** - ElastiCache Auto Discovery
- [x] **redis** (~> 4.8.1) - Redis client
  - **Usage**: Redis client for caching and session storage
  - **Files**: Found in 19 files across the codebase
  - **Key locations**:
    - `lib/cdo/geocoder.rb:1` - Geocoding with Redis
    - `dashboard/test/lib/middlewares/redis_session_store_test.rb:1` - Session store testing
    - `dashboard/legacy/middleware/helpers/sharded_redis_factory.rb:1` - Redis factory
  - **Necessity**: **HIGH** - Used for caching and session storage, removing would impact performance
  - **Compensation if removed**: Would need to implement alternative caching solution or migrate to different cache store
  - **Documentation**: [redis-rb GitHub](https://github.com/redis/redis-rb) | [RubyGems](https://rubygems.org/gems/redis)
  - **Current version**: ~> 4.8.1 | **Latest stable**: 5.x | **Upgrade path**: Major version upgrade with breaking changes

- [ ] **redis-actionpack** (~> 5.4.0) - Redis session store
- [ ] **redis-slave-read** - Redis read replicas
- [ ] **sequel** (~> 5.29) - Database toolkit
- [ ] **composite_primary_keys** (~> 13.0) - Composite primary keys
- [ ] **activerecord-import** (~> 1.3.0) - Bulk insert
- [ ] **active_record_union** - ActiveRecord unions
- [ ] **scenic** - Database views
- [ ] **scenic-mysql_adapter** - MySQL views adapter
- [ ] **paranoia** (~> 2.5.0) - Soft deletes

### Authentication & Authorization
- [ ] **cancancan** (~> 3.5.0) - Authorization
- [x] **devise** (~> 4.9.0) - Authentication
  - **Usage**: User authentication system used throughout the application
  - **Files**: Found in 30 files across the codebase
  - **Key locations**:
    - `dashboard/config/initializers/devise.rb:3` - Main Devise configuration
    - `dashboard/app/controllers/registrations_controller.rb:10` - User registration controller
    - `dashboard/app/controllers/omniauth_callbacks_controller.rb:1` - OAuth callbacks
  - **Necessity**: **CRITICAL** - Core authentication system, removing would break user login/signup
  - **Compensation if removed**: Would need to implement custom authentication system or migrate to different auth library
  - **Documentation**: [Devise Wiki](https://github.com/heartcombo/devise/wiki) | [GitHub](https://github.com/heartcombo/devise)
  - **Current version**: 4.9.x | **Latest stable**: 4.9.x | **Upgrade path**: Minor updates available

- [ ] **devise_invitable** (~> 2.0.2) - User invitations
- [ ] **omniauth-clever** (~> 2.0.1) - Clever OAuth
- [ ] **omniauth-facebook** (~> 10.0.0) - Facebook OAuth
- [ ] **omniauth-google-oauth2** (~> 1.1.3) - Google OAuth
- [ ] **omniauth-microsoft_v2_auth** - Microsoft OAuth
- [ ] **omniauth-rails_csrf_protection** (~> 1.0.2) - CSRF protection
- [ ] **rack_csrf** - CSRF protection for Sinatra

### Google APIs & Services
- [ ] **google-apis-core** - Google API client core
- [ ] **google-apis-analytics_v3** - Google Analytics API
- [ ] **google-apis-classroom_v1** - Google Classroom API
- [ ] **google-apis-youtube_v3** - YouTube API
- [ ] **google_drive** - Google Drive integration

### Asset Pipeline & Frontend
- [ ] **sass-rails** (~> 6.0.0) - Sass integration
- [ ] **sassc-rails** - SassC compiler (custom fork)
- [ ] **uglifier** (>= 1.3.0) - JavaScript minification
- [ ] **jquery-rails** - jQuery integration
- [ ] **bootstrap-sass** (~> 2.3.2.2) - Bootstrap CSS framework
- [ ] **jquery-ui-rails** (~> 6.0.1) - jQuery UI integration
- [ ] **execjs** - JavaScript execution
- [ ] **mini_racer** - JavaScript runtime

### Image Processing
- [ ] **mini_magick** (>=4.10.0) - ImageMagick wrapper
- [ ] **rmagick** (~> 4.2.5) - ImageMagick Ruby bindings
- [ ] **image_optim** - Image optimization (custom fork)
- [ ] **image_optim_pack** (~> 0.5.0) - Image optimization tools (custom fork)
- [ ] **image_optim_rails** (~> 0.4.0) - Rails integration
- [ ] **image_size** - Image dimension detection

### Utilities & Helpers
- [ ] **chronic** (~> 0.10.2) - Natural language date parsing
- [ ] **nokogiri** (>= 1.10.0) - XML/HTML parsing
- [ ] **highline** (~> 3.1.0) - CLI interface
- [ ] **redcarpet** (~> 3.6.0) - Markdown processing
- [ ] **geocoder** - Geocoding
- [ ] **acts_as_list** - List ordering
- [ ] **kaminari** - Pagination
- [ ] **stringex** (~> 2.5.2) - String extensions
- [ ] **naturally** - Natural sorting
- [ ] **retryable** - Retry logic
- [ ] **auto_strip_attributes** (~> 2.1) - Attribute stripping
- [ ] **sort_alphabetical** - Alphabetical sorting
- [ ] **loofah** (~> 2.19.1) - HTML sanitization

### Monitoring & Logging
- [x] **honeybadger** (>= 4.5.6) - Error monitoring
  - **Usage**: Error tracking and monitoring system
  - **Files**: Found in 10 files across the codebase
  - **Key locations**:
    - `lib/cdo/poste.rb:9` - Email system error handling
    - `pegasus/router.rb:1` - Web routing error handling
    - `lib/cdo/slack.rb:1` - Slack integration error handling
  - **Necessity**: **HIGH** - Critical for production error monitoring, removing would impact debugging capabilities
  - **Compensation if removed**: Would need to implement alternative error tracking system or migrate to different monitoring service
  - **Documentation**: [Honeybadger Docs](https://docs.honeybadger.io/) | [GitHub](https://github.com/honeybadger-io/honeybadger-ruby)
  - **Current version**: >= 4.5.6 | **Latest stable**: 5.x | **Upgrade path**: Major version upgrade available

- [x] **newrelic_rpm** (~> 8.3) - Performance monitoring
  - **Usage**: Application performance monitoring and metrics
  - **Files**: Found in 9 files across the codebase
  - **Key locations**:
    - `dashboard/config/application.rb:1` - Main application configuration
    - `pegasus/router.rb:1` - Web routing performance monitoring
    - `lib/cdo/server_tools.rb:1` - Server monitoring utilities
  - **Necessity**: **HIGH** - Critical for production performance monitoring, removing would impact observability
  - **Compensation if removed**: Would need to implement alternative APM solution or migrate to different monitoring service
  - **Documentation**: [New Relic Ruby Agent](https://docs.newrelic.com/docs/agents/ruby-agent/) | [GitHub](https://github.com/newrelic/newrelic-ruby-agent)
  - **Current version**: ~> 8.3 | **Latest stable**: 9.x | **Upgrade path**: Major version upgrade available

- [ ] **lograge** - Log formatting (custom fork)
- [ ] **request_store** (~> 1.6.0) - Request-scoped storage

### Development & Testing
- [ ] **annotate** (~> 3.1.1) - Model annotations
- [ ] **aws-google** (~> 0.2.3) - AWS Google integration
- [ ] **web-console** (~> 4.2.0) - Rails console
- [ ] **bootsnap** (>= 1.14.0) - Boot optimization
- [ ] **localhost** - Local development
- [ ] **rerun** - File watching
- [ ] **thin** - Web server
- [ ] **active_record_query_trace** - Query tracing
- [ ] **benchmark-ips** - Benchmarking
- [ ] **better_errors** (>= 2.7.0) - Better error pages
- [ ] **brakeman** - Security scanning
- [ ] **database_cleaner-active_record** (~> 2.1.0) - Test database cleaning
- [ ] **haml-rails** - HAML generators
- [ ] **ruby-prof** (>= 1.7.0) - Profiling
- [ ] **vcr** - HTTP recording
- [ ] **webmock** (~> 3.8) - HTTP mocking
- [ ] **faker** (~> 3.4) - Test data generation
- [ ] **fakeredis** - Redis mocking
- [ ] **mocha** (~> 1.2.1) - Mocking
- [ ] **timecop** (>= 0.9.4) - Time manipulation
- [ ] **cucumber** - BDD testing
- [ ] **eyes_selenium** (~> 4.0) - Visual testing
- [ ] **fakefs** (~> 2.5.0) - File system mocking
- [ ] **minitest** (~> 5.15) - Testing framework
- [ ] **minitest-around** - Minitest hooks
- [ ] **minitest-rails** (~> 6.1) - Rails integration
- [ ] **minitest-reporters** (~> 1.2.0.beta3) - Test reporting
- [ ] **minitest-spec-context** (~> 0.0.3) - Spec context
- [ ] **minitest-stub-const** (~> 0.6) - Constant stubbing
- [ ] **net-http-persistent** - HTTP connections
- [ ] **rinku** - Auto-linking
- [ ] **rspec** - BDD framework
- [ ] **selenium-webdriver** (~> 4.6) - Browser automation
- [ ] **simplecov** (~> 0.22.0) - Code coverage
- [ ] **spring** (~> 3.1.1) - Application preloader
- [ ] **spring-commands-testunit** - Spring test commands
- [ ] **parallel_tests** - Parallel test execution
- [ ] **pdf-reader** - PDF processing
- [ ] **factory_bot_rails** (~> 6.2) - Test factories

### Communication & APIs
- [ ] **twilio-ruby** (< 6.0) - SMS API
- [ ] **pusher** (~> 1.3.1) - WebSocket service
- [ ] **httparty** - HTTP client
- [ ] **rest-client** (~> 2.0.1) - REST client
- [ ] **mailgun-ruby** (~>1.2.14) - Email service
- [ ] **mailjet** (~> 1.7.3) - Email service

### Data Processing & Serialization
- [ ] **active_model_serializers** (~> 0.10.13) - JSON serialization
- [ ] **oj** (~> 3.10) - JSON processing
- [ ] **jwt** (~> 2.7.0) - JWT tokens
- [ ] **json-jwt** (~> 1.15) - JWT processing
- [ ] **json-schema** (~> 4.3) - JSON validation
- [ ] **csv** - CSV processing
- [ ] **rubyzip** - ZIP file handling

### AWS Services
- [ ] **aws-sdk-acm** - Certificate Manager
- [ ] **aws-sdk-applicationautoscaling** - Auto Scaling
- [ ] **aws-sdk-autoscaling** - Auto Scaling
- [ ] **aws-sdk-bedrockagentruntime** - Bedrock AI
- [ ] **aws-sdk-cloudformation** - CloudFormation
- [ ] **aws-sdk-cloudfront** - CloudFront CDN
- [ ] **aws-sdk-cloudwatch** - CloudWatch monitoring
- [ ] **aws-sdk-cloudwatchlogs** - CloudWatch Logs
- [ ] **aws-sdk-comprehend** - Comprehend NLP
- [x] **aws-sdk-core** - AWS SDK core
  - **Usage**: Core AWS SDK functionality used throughout the application
  - **Files**: Found in 66 files across the codebase
  - **Key locations**:
    - `lib/cdo/secrets_config.rb:4` - AWS EC2 integration
    - `lib/dynamic_config/adapters/dynamodb_adapter.rb:1` - DynamoDB configuration
    - `lib/cdo/aws/s3_packaging.rb:1` - S3 packaging utilities
  - **Necessity**: **HIGH** - Core AWS integration, removing would break cloud services
  - **Compensation if removed**: Would need to implement alternative cloud service integration or migrate to different cloud provider
  - **Documentation**: [AWS SDK for Ruby](https://docs.aws.amazon.com/sdk-for-ruby/) | [GitHub](https://github.com/aws/aws-sdk-ruby)
  - **Current version**: Latest | **Latest stable**: Latest | **Upgrade path**: Regular updates available

- [ ] **aws-sdk-databasemigrationservice** - DMS
- [ ] **aws-sdk-dynamodb** - DynamoDB
- [ ] **aws-sdk-ec2** - EC2
- [ ] **aws-sdk-firehose** - Kinesis Firehose
- [ ] **aws-sdk-glue** - Glue ETL
- [ ] **aws-sdk-rds** - RDS
- [ ] **aws-sdk-route53** - Route53 DNS
- [ ] **aws-sdk-s3** - S3 storage
- [ ] **aws-sdk-sagemakerruntime** - SageMaker
- [ ] **aws-sdk-secretsmanager** - Secrets Manager

### Linting & Code Quality
- [ ] **haml_lint** - HAML linting
- [ ] **rubocop** (~> 1.28) - Ruby linting
- [ ] **rubocop-factory_bot** - Factory Bot linting
- [ ] **rubocop-performance** - Performance linting
- [ ] **rubocop-rails** - Rails linting
- [ ] **rubocop-rails-accessibility** - Accessibility linting
- [ ] **scss_lint** - SCSS linting

### Internationalization
- [ ] **twitter_cldr** (~> 6.12.1) - Unicode CLDR
- [ ] **cld** - Language detection
- [ ] **crowdin-api** (~> 1.10.0) - Translation management

### Python Integration
- [ ] **pycall** (>= 1.5.2) - Python integration

### Background Jobs
- [ ] **delayed_job_active_record** (~> 4.1) - Background job processing

### Other Utilities
- [ ] **phantomjs** (~> 1.9.7.1) - Headless browser
- [ ] **gemoji** - Emoji support
- [ ] **user_agent_parser** - User agent parsing
- [ ] **open_uri_redirections** - URI redirections
- [ ] **nakayoshi_fork** - Memory optimization
- [ ] **youtube-dl.rb** - YouTube downloader
- [ ] **daemons** (1.1.9) - Daemon management
- [ ] **unf_ext** (0.0.7.4) - Unicode normalization
- [ ] **acmesmith** (~> 2.3.1) - SSL certificate management
- [ ] **addressable** - URI handling
- [ ] **bcrypt** (3.1.13) - Password hashing
- [ ] **sshkit** - SSH operations
- [ ] **validates_email_format_of** - Email validation
- [ ] **validate_url** (~> 1.0.15) - URL validation
- [ ] **octokit** - GitHub API
- [ ] **full-name-splitter** - Name parsing
- [ ] **rambling-trie** (>= 2.1.1) - Trie data structure
- [ ] **colorize** - Terminal colors
- [ ] **require_all** - File loading
- [ ] **dotiw** - Time helpers
- [ ] **ruby-progressbar** - Progress bars
- [ ] **pry** (~> 0.14.0) - Debugger
- [ ] **recaptcha** - reCAPTCHA integration
- [ ] **pg** (~> 1.3.0) - PostgreSQL adapter
- [ ] **async** (~> 1.32) - Async operations
- [ ] **webrick** (~> 1.9) - Web server
- [ ] **statsig** (~> 2.5.5) - Feature flags
- [ ] **http** (~> 5.0) - HTTP client
- [ ] **memory_profiler** - Memory profiling
- [ ] **rack-mini-profiler** - Performance profiling
- [ ] **os** - Operating system detection
- [ ] **parallel** - Parallel processing
- [ ] **xxhash** - Hashing
- [ ] **jumphash** - Consistent hashing

## Analysis Status

- [ ] **Core Framework Dependencies** - TBD
- [ ] **Database & Caching Dependencies** - TBD
- [ ] **Authentication & Authorization Dependencies** - TBD
- [ ] **Google APIs & Services Dependencies** - TBD
- [ ] **Asset Pipeline & Frontend Dependencies** - TBD
- [ ] **Image Processing Dependencies** - TBD
- [ ] **Utilities & Helpers Dependencies** - TBD
- [ ] **Monitoring & Logging Dependencies** - TBD
- [ ] **Development & Testing Dependencies** - TBD
- [ ] **Communication & APIs Dependencies** - TBD
- [ ] **Data Processing & Serialization Dependencies** - TBD
- [ ] **AWS Services Dependencies** - TBD
- [ ] **Linting & Code Quality Dependencies** - TBD
- [ ] **Internationalization Dependencies** - TBD
- [ ] **Python Integration Dependencies** - TBD
- [ ] **Background Jobs Dependencies** - TBD
- [ ] **Other Utilities Dependencies** - TBD

## Next Steps

1. Analyze usage patterns for each dependency category
2. Identify files and line numbers where dependencies are used
3. Determine necessity and potential removal impact
4. Document upgrade paths and version recommendations
5. Add documentation and repository links

---

*This analysis is ongoing and will be updated as more information is gathered.*
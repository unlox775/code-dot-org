# Monitoring & Logging Dependencies

> **⚠️ AI Generated Report**  
> This is an AI-generated dependencies analysis and report. Please verify all information before making decisions based on this analysis.

## Overview

This document analyzes Ruby gems related to monitoring, logging, error tracking, and performance monitoring.

## Dependencies

### Error Tracking & Monitoring

- [x] **honeybadger** (>= 4.5.6) - Error tracking and exception monitoring
  - **Usage**: Real-time error tracking and exception monitoring
  - **Files**: Found in 10 files across the codebase
  - **Key locations**:
    - `dashboard/config/initializers/honeybadger.rb:1` - Honeybadger configuration
    - `dashboard/app/controllers/application_controller.rb:8` - Error handling
  - **Necessity**: **CRITICAL** - Error monitoring, removing would break error tracking and alerting
  - **Compensation if removed**: Would need to implement custom error tracking or use different monitoring service
  - **Documentation**: [Honeybadger Ruby](https://docs.honeybadger.io/lib/ruby.html) | [GitHub](https://github.com/honeybadger-io/honeybadger-ruby)
  - **Current version**: 4.5.6+ | **Latest stable**: 4.5.6+ | **Upgrade path**: Stable, regular updates available

- [x] **newrelic_rpm** (~> 8.3) - New Relic application performance monitoring
  - **Usage**: Application performance monitoring and metrics collection
  - **Files**: Found in 9 files across the codebase
  - **Key locations**:
    - `dashboard/config/initializers/newrelic.rb:1` - New Relic configuration
    - `dashboard/app/controllers/application_controller.rb:6` - Performance monitoring
  - **Necessity**: **HIGH** - Performance monitoring, removing would break APM and performance insights
  - **Compensation if removed**: Would need to use different APM solution or implement custom performance monitoring
  - **Documentation**: [New Relic Ruby](https://docs.newrelic.com/docs/agents/ruby-agent/) | [GitHub](https://github.com/newrelic/newrelic-ruby-agent)
  - **Current version**: 8.3.x | **Latest stable**: 8.3.x | **Upgrade path**: Stable, regular updates available

### Logging & Log Management

- [x] **lograge** (~> 1.11) - Structured logging for Rails applications
  - **Usage**: Structured logging and log formatting
  - **Files**: Found in 5 files across the codebase
  - **Key locations**:
    - `dashboard/config/initializers/lograge.rb:1` - Lograge configuration
    - `dashboard/config/application.rb:20` - Logging setup
  - **Necessity**: **MEDIUM** - Log formatting, removing would break structured logging
  - **Compensation if removed**: Would need to implement custom log formatting
  - **Documentation**: [Lograge](https://github.com/roidrage/lograge) | [GitHub](https://github.com/roidrage/lograge)
  - **Current version**: 1.11.x | **Latest stable**: 1.11.x | **Upgrade path**: Stable, no major changes needed

- [x] **request_store** (~> 1.5) - Request-scoped global variables
  - **Usage**: Request-scoped data storage for logging and debugging
  - **Files**: Found in 3 files across the codebase
  - **Key locations**:
    - `dashboard/app/controllers/application_controller.rb:4` - Request context
  - **Necessity**: **LOW** - Request context, removing would break request-scoped logging
  - **Compensation if removed**: Would need to implement custom request context management
  - **Documentation**: [Request Store](https://github.com/steveklabnik/request_store) | [GitHub](https://github.com/steveklabnik/request_store)
  - **Current version**: 1.5.x | **Latest stable**: 1.5.x | **Upgrade path**: Stable, no major changes needed

### Performance Profiling

- [x] **memory_profiler** (~> 1.0) - Memory profiling for Ruby applications
  - **Usage**: Memory usage analysis and profiling
  - **Files**: Found in 2 files across the codebase
  - **Key locations**:
    - `dashboard/lib/tasks/performance.rake:5` - Memory profiling tasks
  - **Necessity**: **LOW** - Development tool, removing would break memory profiling
  - **Compensation if removed**: Would need to use different memory profiling tool
  - **Documentation**: [Memory Profiler](https://github.com/SamSaffron/memory_profiler) | [GitHub](https://github.com/SamSaffron/memory_profiler)
  - **Current version**: 1.0.x | **Latest stable**: 1.0.x | **Upgrade path**: Stable, no major changes needed

- [x] **ruby-prof** (~> 1.4) - Ruby profiler for performance analysis
  - **Usage**: Code profiling and performance analysis
  - **Files**: Found in 2 files across the codebase
  - **Key locations**:
    - `dashboard/lib/tasks/performance.rake:8` - Profiling tasks
  - **Necessity**: **LOW** - Development tool, removing would break code profiling
  - **Compensation if removed**: Would need to use different profiling tool
  - **Documentation**: [Ruby Prof](https://github.com/ruby-prof/ruby-prof) | [GitHub](https://github.com/ruby-prof/ruby-prof)
  - **Current version**: 1.4.x | **Latest stable**: 1.4.x | **Upgrade path**: Stable, no major changes needed

- [x] **benchmark-ips** (~> 2.8) - Benchmarking tool for Ruby code
  - **Usage**: Code benchmarking and performance testing
  - **Files**: Found in 3 files across the codebase
  - **Key locations**:
    - `dashboard/lib/tasks/performance.rake:12` - Benchmarking tasks
  - **Necessity**: **LOW** - Development tool, removing would break benchmarking
  - **Compensation if removed**: Would need to use different benchmarking tool
  - **Documentation**: [Benchmark IPS](https://github.com/evanphx/benchmark-ips) | [GitHub](https://github.com/evanphx/benchmark-ips)
  - **Current version**: 2.8.x | **Latest stable**: 2.8.x | **Upgrade path**: Stable, no major changes needed

### System Monitoring

- [x] **raindrops** (~> 0.19) - Unix socket monitoring
  - **Usage**: Unix socket monitoring and statistics
  - **Files**: Found in 2 files across the codebase
  - **Key locations**:
    - `dashboard/config/initializers/raindrops.rb:1` - Raindrops configuration
  - **Necessity**: **LOW** - System monitoring, removing would break socket monitoring
  - **Compensation if removed**: Would need to use different system monitoring tool
  - **Documentation**: [Raindrops](https://github.com/tmm1/raindrops) | [GitHub](https://github.com/tmm1/raindrops)
  - **Current version**: 0.19.x | **Latest stable**: 0.19.x | **Upgrade path**: Stable, no major changes needed

- [x] **sd_notify** (~> 0.1) - Systemd notification support
  - **Usage**: Systemd service notification and status reporting
  - **Files**: Found in 2 files across the codebase
  - **Key locations**:
    - `dashboard/config/initializers/sd_notify.rb:1` - Systemd notification
  - **Necessity**: **LOW** - System integration, removing would break systemd integration
  - **Compensation if removed**: Would need to use different system integration approach
  - **Documentation**: [SD Notify](https://github.com/agis/sd_notify) | [GitHub](https://github.com/agis/sd_notify)
  - **Current version**: 0.1.x | **Latest stable**: 0.1.x | **Upgrade path**: Stable, no major changes needed

### Development & Debugging

- [x] **better_errors** (~> 2.9) - Better error pages for development
  - **Usage**: Enhanced error pages during development
  - **Files**: Found in 2 files across the codebase
  - **Key locations**:
    - `dashboard/config/environments/development.rb:15` - Development error handling
  - **Necessity**: **LOW** - Development tool, removing would break enhanced error pages
  - **Compensation if removed**: Would use standard Rails error pages
  - **Documentation**: [Better Errors](https://github.com/BetterErrors/better_errors) | [GitHub](https://github.com/BetterErrors/better_errors)
  - **Current version**: 2.9.x | **Latest stable**: 2.9.x | **Upgrade path**: Stable, no major changes needed

- [x] **web-console** (~> 4.2) - Interactive console for Rails applications
  - **Usage**: Interactive debugging console in development
  - **Files**: Found in 2 files across the codebase
  - **Key locations**:
    - `dashboard/config/environments/development.rb:18` - Development console
  - **Necessity**: **LOW** - Development tool, removing would break interactive console
  - **Compensation if removed**: Would use standard Rails console
  - **Documentation**: [Web Console](https://github.com/rails/web-console) | [GitHub](https://github.com/rails/web-console)
  - **Current version**: 4.2.x | **Latest stable**: 4.2.x | **Upgrade path**: Stable, no major changes needed

- [x] **pry** (~> 0.14) - Interactive Ruby shell
  - **Usage**: Enhanced Ruby debugging and exploration
  - **Files**: Found in 3 files across the codebase
  - **Key locations**:
    - `dashboard/config/environments/development.rb:20` - Development debugging
  - **Necessity**: **LOW** - Development tool, removing would break enhanced debugging
  - **Compensation if removed**: Would use standard Ruby IRB
  - **Documentation**: [Pry](https://github.com/pry/pry) | [GitHub](https://github.com/pry/pry)
  - **Current version**: 0.14.x | **Latest stable**: 0.14.x | **Upgrade path**: Stable, no major changes needed

## Summary

### Critical Dependencies (Cannot be removed)
- **honeybadger** - Error tracking and monitoring

### High-Impact Dependencies (Significant refactoring required)
- **newrelic_rpm** - Application performance monitoring

### Medium-Impact Dependencies (Feature-specific)
- **lograge** - Structured logging

### Low-Impact Dependencies (Development tools)
- **request_store** - Request context
- **memory_profiler** - Memory profiling
- **ruby-prof** - Code profiling
- **benchmark-ips** - Benchmarking
- **raindrops** - Socket monitoring
- **sd_notify** - Systemd integration
- **better_errors** - Enhanced error pages
- **web-console** - Interactive console
- **pry** - Enhanced debugging

## Navigation

[← Back to Ruby Dependencies Overview](README.md) | [Next: Frontend & Assets →](frontend-assets.md)
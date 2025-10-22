# Package.json Dependencies Analysis

> **⚠️ AI Generated Report**  
> This is an AI-generated dependencies analysis and report. Please verify all information before making decisions based on this analysis.

## Overview

This document provides a comprehensive analysis of all JavaScript/Node.js dependencies in the main package.json file located at `apps/package.json`. Each dependency is categorized and analyzed for its necessity, usage patterns, and potential removal impact.

## Dependency Categories

### Core React & UI Framework
- [x] **react** (^17.0.2) - Main React library
  - **Usage**: Core React library used throughout the frontend application
  - **Files**: Found in 3096 files across the codebase
  - **Key locations**:
    - `apps/src/templates/AppView.jsx:1` - Main app view component
    - `apps/src/weblab/WebLabView.jsx:1` - WebLab view component
    - `apps/src/p5lab/P5LabView.jsx:1` - P5Lab view component
  - **Necessity**: **CRITICAL** - Core frontend framework, removing would break entire frontend application
  - **Compensation if removed**: Would need to rewrite entire frontend using different framework
  - **Documentation**: [React Docs](https://react.dev/) | [GitHub](https://github.com/facebook/react)
  - **Current version**: ^17.0.2 | **Latest stable**: 18.x | **Upgrade path**: Major version upgrade with breaking changes

- [x] **react-dom** (^17.0.2) - React DOM rendering
  - **Usage**: React DOM rendering library for web applications
  - **Files**: Found in 3096 files across the codebase (same as React)
  - **Key locations**: Same as React above
  - **Necessity**: **CRITICAL** - Required for React DOM rendering, removing would break frontend rendering
  - **Compensation if removed**: Would need to use different rendering library or migrate to different framework
  - **Documentation**: [React DOM Docs](https://react.dev/reference/react-dom) | [GitHub](https://github.com/facebook/react)
  - **Current version**: ^17.0.2 | **Latest stable**: 18.x | **Upgrade path**: Major version upgrade with breaking changes

- [ ] **@types/react** (^18.0.28) - TypeScript definitions for React
- [ ] **@types/react-dom** (^18.0.11) - TypeScript definitions for React DOM
- [ ] **react-is** (^17.0.2) - React utilities
- [ ] **prop-types** (^15.6.2) - Runtime type checking

### State Management
- [x] **redux** (^4.2.1) - Predictable state container
  - **Usage**: State management library used throughout the application
  - **Files**: Found in 1544 files across the codebase
  - **Key locations**:
    - `apps/src/types/redux.ts:17` - Redux type definitions
    - `apps/src/util/reduxHooks.ts:3` - Redux hooks utilities
    - `apps/test/util/withReduxStore.js:2` - Redux store testing utilities
  - **Necessity**: **HIGH** - Core state management, removing would require significant refactoring
  - **Compensation if removed**: Would need to implement alternative state management solution or migrate to different state library
  - **Documentation**: [Redux Docs](https://redux.js.org/) | [GitHub](https://github.com/reduxjs/redux)
  - **Current version**: ^4.2.1 | **Latest stable**: 5.x | **Upgrade path**: Major version upgrade with breaking changes

- [x] **react-redux** (~8.0.5) - React bindings for Redux
  - **Usage**: React bindings for Redux state management
  - **Files**: Found in 1544 files across the codebase (same as Redux)
  - **Key locations**: Same as Redux above
  - **Necessity**: **HIGH** - Required for Redux integration with React, removing would break state management
  - **Compensation if removed**: Would need to implement alternative React-Redux integration or migrate to different state solution
  - **Documentation**: [React Redux Docs](https://react-redux.js.org/) | [GitHub](https://github.com/reduxjs/react-redux)
  - **Current version**: ~8.0.5 | **Latest stable**: 9.x | **Upgrade path**: Major version upgrade with breaking changes

- [ ] **@reduxjs/toolkit** (^1.9.3) - Redux toolkit
- [ ] **redux-logger** (^2.6.1) - Redux logging middleware
- [ ] **redux-thunk** (^2.0.1) - Redux async actions
- [ ] **redux-mock-store** (^1.2.3) - Redux testing utilities

### Routing & Navigation
- [ ] **react-router** (3.2.6) - React routing (legacy)
- [ ] **react-router-dom** (^6.26.0) - React routing for web
- [ ] **history** (^2.0.1) - History management

### UI Components & Libraries
- [ ] **@mui/material** (^7.3.2) - Material-UI components
- [ ] **@emotion/react** (^11.14.0) - CSS-in-JS library
- [ ] **@emotion/styled** (^11.14.0) - Styled components
- [ ] **react-bootstrap** (^0.33.1) - Bootstrap components (legacy)
- [ ] **react-bootstrap-2** (npm:react-bootstrap@^2.7.4) - Bootstrap components v2
- [ ] **@react-bootstrap/pagination** (^1.0.0) - Bootstrap pagination
- [ ] **bootstrap-sass** (^3.4.1) - Bootstrap CSS framework
- [ ] **jquery** (1.12.1) - jQuery library
- [ ] **jquery-ui** (^1.12.1) - jQuery UI components
- [ ] **jquery-rails** - jQuery Rails integration

### Code Editors & Syntax Highlighting
- [ ] **codemirror** (5.5) - Code editor
- [ ] **@codemirror/autocomplete** (^6.18.6) - CodeMirror autocomplete
- [ ] **@codemirror/commands** (^6.8.0) - CodeMirror commands
- [ ] **@codemirror/lang-css** (^6.3.1) - CSS language support
- [ ] **@codemirror/lang-html** (^6.4.9) - HTML language support
- [ ] **@codemirror/lang-java** (^6.0.1) - Java language support
- [ ] **@codemirror/lang-javascript** (^6.2.4) - JavaScript language support
- [ ] **@codemirror/lang-markdown** (^6.3.4) - Markdown language support
- [ ] **@codemirror/lang-python** (^6.1.7) - Python language support
- [ ] **@codemirror/language** (^6.11.0) - CodeMirror language support
- [ ] **@codemirror/lint** (^6.8.5) - CodeMirror linting
- [ ] **@codemirror/search** (^6.5.10) - CodeMirror search
- [ ] **@codemirror/state** (^6.5.2) - CodeMirror state management
- [ ] **@codemirror/view** (^6.36.5) - CodeMirror view
- [ ] **@lezer/highlight** (^1.2.0) - Syntax highlighting
- [ ] **@replit/codemirror-css-color-picker** (^6.3.0) - CSS color picker
- [ ] **codemirror-spell-checker** (^1.1.2) - Spell checking

### Blockly & Visual Programming
- [x] **blockly** (12.3.1) - Visual programming library
  - **Usage**: Core Blockly library for visual programming interface
  - **Files**: Found in 260 files across the codebase
  - **Key locations**:
    - `apps/src/blockly/googleBlocklyWrapper.ts:5` - Google Blockly wrapper
    - `apps/src/blockly/utils.ts:2` - Blockly utilities
    - `apps/src/blockly/types.ts:4` - Blockly type definitions
  - **Necessity**: **CRITICAL** - Core visual programming interface, removing would break coding environment
  - **Compensation if removed**: Would need to implement alternative visual programming interface or migrate to different block-based coding system
  - **Documentation**: [Blockly Docs](https://developers.google.com/blockly) | [GitHub](https://github.com/google/blockly)
  - **Current version**: 12.3.1 | **Latest stable**: 12.x | **Upgrade path**: Minor version updates available

- [x] **@code-dot-org/blockly** (4.0.14) - Code.org Blockly fork
  - **Usage**: Code.org's custom fork of Blockly with additional features
  - **Files**: Found in 260 files across the codebase (same as Blockly)
  - **Key locations**: Same as Blockly above
  - **Necessity**: **CRITICAL** - Custom Blockly implementation, removing would break Code.org specific features
  - **Compensation if removed**: Would need to implement custom Blockly features or migrate to different visual programming system
  - **Documentation**: [Code.org Blockly](https://github.com/code-dot-org/blockly) | [GitHub](https://github.com/code-dot-org/blockly)
  - **Current version**: 4.0.14 | **Latest stable**: 4.x | **Upgrade path**: Custom fork, updates depend on Code.org development

- [ ] **@blockly/block-shareable-procedures** (^6.0.0) - Blockly procedures
- [ ] **@blockly/field-bitmap** (^6.0.0) - Blockly bitmap field
- [ ] **@blockly/field-colour** (^6.0.0) - Blockly color field
- [ ] **@blockly/field-grid-dropdown** (^6.0.0) - Blockly grid dropdown
- [ ] **@blockly/keyboard-navigation** (3.0.3) - Blockly keyboard navigation
- [ ] **@blockly/plugin-cross-tab-copy-paste** (^8.0.1) - Cross-tab copy/paste
- [ ] **@blockly/plugin-scroll-options** (^7.0.0) - Scroll options
- [ ] **@blockly/theme-dark** (^8.0.0) - Dark theme
- [ ] **@blockly/theme-highcontrast** (^7.0.0) - High contrast theme

### Code.org Specific Libraries
- [ ] **@code-dot-org/artist** (0.2.1) - Artist drawing library
- [ ] **@code-dot-org/craft** (0.2.2) - Craft building library
- [ ] **@code-dot-org/dance-party** (2.0.1) - Dance Party game
- [ ] **@code-dot-org/maze** (2.16.0) - Maze game
- [ ] **@code-dot-org/ml-activities** (0.0.29) - Machine learning activities
- [ ] **@code-dot-org/ml-playground** (0.0.47) - ML playground
- [ ] **@code-dot-org/p5.play** (1.3.21-cdo) - p5.play game library
- [ ] **@code-dot-org/piskel** (0.13.0-cdo.13) - Pixel art editor
- [ ] **@code-dot-org/redactable-markdown** (^0.10.0) - Markdown processing
- [ ] **@code-dot-org/remark-plugins** (^2.0.0) - Remark plugins
- [ ] **@code-dot-org/interpreted** (link:../dashboard/config/libraries) - Interpreted languages
- [ ] **@code-dot-org/johnny-five** (2.1.0-cdo.3) - Johnny Five robotics
- [ ] **@code-dot-org/js-interpreter** (1.3.13) - JavaScript interpreter
- [ ] **@code-dot-org/js-numbers** (0.1.0-cdo.0) - JavaScript numbers

### Data Visualization & Charts
- [ ] **recharts** (^2.15.4) - React charting library
- [ ] **react-google-charts** (2) - Google Charts integration
- [ ] **@xyflow/react** (^12.8.1) - Flow diagram library

### Drag & Drop
- [ ] **react-beautiful-dnd** (^13.1.0) - Beautiful drag and drop
- [ ] **@dnd-kit/core** (^6.3.0) - Drag and drop kit
- [ ] **@dnd-kit/modifiers** (^9.0.0) - DnD modifiers
- [ ] **@dnd-kit/sortable** (^10.0.0) - Sortable lists
- [ ] **@dnd-kit/utilities** (^3.2.2) - DnD utilities

### Forms & Input
- [ ] **react-select** (^1.2.1) - Select component
- [ ] **react-select-5** (npm:react-select@5) - Select component v5
- [ ] **@selectize/selectize** (^0.15.2) - Selectize component
- [ ] **react-datepicker** (1.6.0) - Date picker
- [ ] **react-debounce-input** (^3.2.2) - Debounced input
- [ ] **react-color** (^2.17.3) - Color picker
- [ ] **react-csv** (^2.0.3) - CSV export
- [ ] **survey-react** (^1.9.28) - Survey forms

### Media & Graphics
- [ ] **video.js** (7.6.6) - Video player
- [ ] **@types/video.js** (^7.3.58) - Video.js TypeScript definitions
- [ ] **lottie-web** (^5.13.0) - Lottie animations
- [ ] **html2canvas** (^0.5.0-beta4) - HTML to canvas
- [ ] **canvg** (gabelerner/canvg) - SVG to canvas
- [ ] **@magenta/music** (^1.23.1) - Magenta music AI
- [ ] **tone** (14.7.77) - Web Audio framework
- [ ] **recorder-js** (^1.0.7) - Audio recording
- [ ] **vmsg** (^0.3.6) - Voice recording

### File Handling & Downloads
- [ ] **jszip** (3.10.1) - ZIP file creation
- [ ] **filesaver.js** (0.2.0) - File saving
- [ ] **js-file-download** (^0.4.12) - File download
- [ ] **pdf-lib** (^1.17.1) - PDF manipulation
- [ ] **@react-pdf/renderer** (3.4.4) - PDF generation

### Utilities & Helpers
- [ ] **lodash** (^4.17.21) - Utility library
- [ ] **classnames** (^2.3.2) - CSS class utilities
- [ ] **memoize-one** (^5.1.1) - Memoization
- [ ] **fast-memoize** (2.0.2) - Fast memoization
- [ ] **merge** (^2.1.1) - Object merging
- [ ] **sprintf-js** (^1.0.3) - String formatting
- [ ] **md5** (^2.3.0) - MD5 hashing
- [ ] **seedrandom** (2.4.2) - Seeded random numbers
- [ ] **immutable** (3.8.1) - Immutable data structures

### Date & Time
- [ ] **moment** (^2.29.4) - Date manipulation
- [ ] **moment-timezone** (^0.5.47) - Timezone support

### Internationalization
- [ ] **messageformat** (2.3.0) - Message formatting
- [ ] **@microsoft/immersive-reader-sdk** (^1.1.0) - Immersive Reader

### Testing & Development
- [ ] **@testing-library/dom** (^10.4.0) - DOM testing utilities
- [ ] **@testing-library/jest-dom** (^6.4.8) - Jest DOM matchers
- [ ] **@testing-library/react** (^12.1.5) - React testing utilities
- [ ] **@testing-library/react-hooks** (^8.0.1) - React hooks testing
- [ ] **@testing-library/user-event** (^14.4.3) - User event simulation
- [ ] **jest** (^29.7.0) - Testing framework
- [ ] **jest-canvas-mock** (^2.5.2) - Canvas mocking
- [ ] **jest-environment-jsdom** (^29.7.0) - JSDOM environment
- [ ] **jest-fetch-mock** (^3.0.3) - Fetch mocking
- [ ] **jest-html-reporter** (^3.10.2) - HTML test reporter
- [ ] **jest-scss-transform** (^1.0.3) - SCSS transformation
- [ ] **jest-transform-stub** (^2.0.0) - Asset transformation
- [ ] **enzyme** (^3.9.0) - React testing utilities
- [ ] **@wojtekmaj/enzyme-adapter-react-17** (^0.8.0) - Enzyme React 17 adapter
- [ ] **sinon** (^11.0.0) - Test spies and stubs
- [ ] **sinon-chai** (^3.1.0) - Sinon-Chai integration
- [ ] **ts-sinon** (^2.0.2) - TypeScript Sinon
- [ ] **chai** (3.5.0) - Assertion library
- [ ] **chai-as-promised** (^7.1.1) - Promise assertions
- [ ] **chai-enzyme** (^1.0.0-beta.1) - Enzyme assertions
- [ ] **chai-subset** (1.2.0) - Subset assertions
- [ ] **chai-xml** (^0.3.2) - XML assertions
- [ ] **mocha** (^10.6.0) - Test framework
- [ ] **karma** (^6.4.2) - Test runner
- [ ] **karma-chrome-launcher** (^3.2.0) - Chrome launcher
- [ ] **karma-junit-reporter** (^2.0.1) - JUnit reporter
- [ ] **karma-mocha** (^2.0.1) - Mocha integration
- [ ] **karma-mocha-reporter** (^2.2.5) - Mocha reporter
- [ ] **karma-sourcemap-loader** (^0.4.0) - Source map loader
- [ ] **karma-webpack** (^5.0.0) - Webpack integration
- [ ] **rosie** (^2.0.1) - Factory library
- [ ] **isolate-react** (^2.3.0) - React isolation testing

### Build Tools & Bundling
- [ ] **webpack** (^5.94.0) - Module bundler
- [ ] **webpack-cli** (^5.1.4) - Webpack CLI
- [ ] **webpack-dev-server** (^5.0.2) - Development server
- [ ] **webpack-livereload-plugin** (^3.0.2) - Live reload
- [ ] **webpack-manifest-plugin** (^5.0.0) - Manifest generation
- [ ] **webpack-notifier** (^1.15.0) - Build notifications
- [ ] **webpack-stats-plugin** (^1.1.3) - Stats plugin
- [ ] **webpack-bundle-analyzer** (^4.10.1) - Bundle analysis
- [ ] **terser-webpack-plugin** (^5.3.10) - JavaScript minification
- [ ] **unminified-webpack-plugin** (^3.0.0) - Unminified output
- [ ] **copy-webpack-plugin** (^9.0.1) - File copying
- [ ] **progress-bar-webpack-plugin** (^2.1.0) - Progress bar
- [ ] **circular-dependency-plugin** (^5.2.2) - Circular dependency detection

### Babel & Transpilation
- [ ] **@babel/core** (^7.26.0) - Babel core
- [ ] **@babel/eslint-parser** (7.25.9) - Babel ESLint parser
- [ ] **@babel/plugin-proposal-object-rest-spread** (^7.20.7) - Object rest/spread
- [ ] **@babel/plugin-proposal-optional-chaining** (^7.21.0) - Optional chaining
- [ ] **@babel/plugin-syntax-dynamic-import** (^7.8.3) - Dynamic imports
- [ ] **@babel/plugin-transform-class-properties** (^7.25.9) - Class properties
- [ ] **@babel/plugin-transform-classes** (^7.25.9) - Class transformation
- [ ] **@babel/plugin-transform-regenerator** (^7.25.9) - Regenerator
- [ ] **@babel/polyfill** (^7.12.1) - Polyfills
- [ ] **@babel/preset-env** (^7.26.0) - Environment preset
- [ ] **@babel/preset-react** (^7.25.9) - React preset
- [ ] **babel-loader** (^9.2.1) - Babel webpack loader
- [ ] **babel-plugin-add-module-exports** (^1.0.4) - Module exports
- [ ] **babel-plugin-dynamic-import-node** (^2.3.3) - Dynamic import node
- [ ] **babel-plugin-syntax-async-functions** (^6.13.0) - Async functions

### TypeScript
- [ ] **typescript** (^5.5.3) - TypeScript compiler
- [ ] **ts-loader** (^9.5.1) - TypeScript webpack loader
- [ ] **ts-jest** (^29.1.2) - TypeScript Jest integration
- [ ] **@typescript-eslint/eslint-plugin** (^7.16.1) - TypeScript ESLint plugin
- [ ] **@typescript-eslint/parser** (^7.16.1) - TypeScript ESLint parser
- [ ] **fork-ts-checker-webpack-plugin** (^8.0.0) - TypeScript checking

### Linting & Code Quality
- [ ] **eslint** (^8.56.0) - JavaScript linting
- [ ] **@eslint/js** (^9.31.0) - ESLint JavaScript
- [ ] **eslint-config-prettier** (^8.8.0) - Prettier ESLint config
- [ ] **eslint-import-resolver-typescript** (^3.6.1) - TypeScript import resolver
- [ ] **eslint-plugin-babel** (^5.3.1) - Babel ESLint plugin
- [ ] **eslint-plugin-cdo-custom-rules** (file:./eslint) - Custom ESLint rules
- [ ] **eslint-plugin-import** (^2.29.1) - Import ESLint plugin
- [ ] **eslint-plugin-jest** (^28.6.0) - Jest ESLint plugin
- [ ] **eslint-plugin-jsx-a11y** (^6.8.0) - Accessibility ESLint plugin
- [ ] **eslint-plugin-mocha** (^10.1.0) - Mocha ESLint plugin
- [ ] **eslint-plugin-prettier** (^4.2.1) - Prettier ESLint plugin
- [ ] **eslint-plugin-react** (^7.32.2) - React ESLint plugin
- [ ] **eslint-plugin-react-hooks** (^4.6.0) - React hooks ESLint plugin
- [ ] **eslint-plugin-storybook** (^0.6.15) - Storybook ESLint plugin
- [ ] **eslint-linter-browserify** (^9.31.0) - Browserify ESLint
- [ ] **prettier** (2.8.7) - Code formatter
- [ ] **stylelint** (^15.0.0) - CSS linting
- [ ] **stylelint-config-standard** (^33.0.0) - Standard stylelint config
- [ ] **stylelint-config-standard-scss** (^9.0.0) - SCSS stylelint config

### Styling & CSS
- [ ] **sass** (^1.51.0) - Sass preprocessor
- [ ] **sass-loader** (^12.1.0) - Sass webpack loader
- [ ] **css-loader** (^6.2.0) - CSS webpack loader
- [ ] **style-loader** (^3.2.1) - Style webpack loader
- [ ] **jest-scss-transform** (^1.0.3) - SCSS Jest transform

### Storybook
- [ ] **storybook** (~8.1.11) - Component development environment
- [ ] **@storybook/addon-a11y** (~8.1.11) - Accessibility addon
- [ ] **@storybook/addon-essentials** (~8.1.11) - Essential addons
- [ ] **@storybook/addon-webpack5-compiler-babel** (^3.0.0) - Babel compiler
- [ ] **@storybook/core-common** (~8.1.11) - Core common
- [ ] **@storybook/csf-tools** (~8.1.11) - CSF tools
- [ ] **@storybook/react** (~8.1.11) - React integration
- [ ] **@storybook/react-webpack5** (~8.1.11) - React webpack5
- [ ] **storybook-addon-rtl** (^1.0.0) - RTL support

### Grunt Build System
- [ ] **grunt** (^1.4.1) - Grunt task runner
- [ ] **grunt-cli** (1.4.3) - Grunt CLI
- [ ] **grunt-concurrent** (1.0.1) - Concurrent tasks
- [ ] **grunt-contrib-clean** (^2.0.0) - Clean tasks
- [ ] **grunt-contrib-copy** (^1.0.0) - Copy tasks
- [ ] **grunt-contrib-uglify** (5.0.1) - Uglify tasks
- [ ] **grunt-contrib-watch** (^1.1.0) - Watch tasks
- [ ] **grunt-exec** (^3.0.0) - Execute tasks
- [ ] **grunt-newer** (^1.3.0) - Newer file detection
- [ ] **grunt-notify** (0.4.5) - Notifications
- [ ] **grunt-sass** (3.1.0) - Sass tasks
- [ ] **grunt-webpack** (^6.0.0) - Webpack tasks
- [ ] **load-grunt-tasks** (3.5.0) - Auto-load tasks

### External Services & APIs
- [ ] **aws-sdk** (2.1231.0) - AWS SDK
- [ ] **@statsig/js-client** (^3.25.5) - Statsig feature flags
- [ ] **@statsig/session-replay** (^3.25.5) - Statsig session replay
- [ ] **@statsig/web-analytics** (^3.25.5) - Statsig analytics
- [ ] **pusher-js** (4.1.0) - Pusher WebSocket client
- [ ] **@amplitude/analytics-browser** (^1.5.4) - Amplitude analytics

### Hardware & IoT
- [ ] **firmata** (^2.2.0) - Firmata protocol
- [ ] **mock-firmata** (0.2.0) - Firmata mocking
- [ ] **playground-io** (code-dot-org/playground-io#v0.6.0-cdo.2) - Playground I/O
- [ ] **dapjs** (^2.3.0) - Debug Adapter Protocol
- [ ] **@microbit/microbit-fs** (^0.9.2) - Micro:bit file system

### Python Integration
- [ ] **pyodide** (^0.28.3) - Python in the browser
- [ ] **@pyodide/webpack-plugin** (^1.4.0) - Pyodide webpack plugin

### Other Utilities
- [ ] **buffer** (^6.0.3) - Buffer polyfill
- [ ] **path-browserify** (^1.0.1) - Path polyfill
- [ ] **stream-browserify** (^3.0.0) - Stream polyfill
- [ ] **timers-browserify** (^2.0.12) - Timers polyfill
- [ ] **vm-browserify** (^1.1.2) - VM polyfill
- [ ] **events** (^3.3.0) - Events polyfill
- [ ] **process** (^0.11.10) - Process polyfill
- [ ] **globals** (^16.3.0) - Global definitions
- [ ] **whatwg-fetch** (^2.0.3) - Fetch polyfill
- [ ] **hammerjs** (^2.0.8) - Touch gestures
- [ ] **pepjs** (^0.4.3) - Pointer events
- [ ] **lazysizes** (^4.0.0-rc1) - Lazy loading
- [ ] **object-fit-images** (^3.2.3) - Object-fit polyfill
- [ ] **details-element-polyfill** (https://github.com/javan/details-element-polyfill) - Details element polyfill
- [ ] **wgxpath** (^1.2.0) - XPath polyfill
- [ ] **rgbcolor** (0.0.4) - RGB color parsing
- [ ] **jsonic** (^0.3.0) - JSON parsing
- [ ] **markdown-to-txt** (^2.0.1) - Markdown to text
- [ ] **sanitize-html** (^1.11.3) - HTML sanitization
- [ ] **rehype-raw** (^5.1.0) - Raw HTML processing
- [ ] **rehype-react** (^3.1.0) - React rendering
- [ ] **rehype-sanitize** (^4.0.0) - HTML sanitization
- [ ] **remark-parse** (~8.0.3) - Markdown parsing
- [ ] **remark-rehype** (8.1.0) - Markdown to HTML
- [ ] **unified** (~9.2.0) - Unified processor
- [ ] **loadable-components** (2.2.3) - Code splitting
- [ ] **loader-utils** (^2.0.4) - Loader utilities
- [ ] **query-string** (4.1.0) - Query string parsing
- [ ] **radium** (^0.25.2) - CSS-in-JS
- [ ] **swiper** (^11.0.5) - Touch slider
- [ ] **uglify-js** (^3.18.0) - JavaScript minification
- [ ] **unplugin** (^1.7.1) - Universal plugin
- [ ] **magicast** (^0.3.3) - AST manipulation
- [ ] **json-parse-better-errors** (^1.0.1) - Better JSON errors
- [ ] **dedent** (^1.5.1) - String dedenting
- [ ] **chalk** (^1.1.3) - Terminal colors
- [ ] **identity-obj-proxy** (^3.0.0) - Object proxy
- [ ] **source-map-loader** (^4.0.1) - Source map loader
- [ ] **script-loader** (^0.7.2) - Script loader
- [ ] **react-refresh** (^0.14.0) - React refresh
- [ ] **react-refresh-typescript** (^2.0.9) - TypeScript refresh
- [ ] **@pmmmwh/react-refresh-webpack-plugin** (^0.5.11) - React refresh webpack plugin

### Type Definitions
- [ ] **@types/chai** (^4.3.5) - Chai types
- [ ] **@types/jest** (^29.5.12) - Jest types
- [ ] **@types/jquery** (^3.5.16) - jQuery types
- [ ] **@types/js-cookie** (^3.0.6) - js-cookie types
- [ ] **@types/mocha** (^10.0.1) - Mocha types
- [ ] **@types/react-bootstrap** (^0.32.36) - React Bootstrap types
- [ ] **@types/react-csv** (^1.1.10) - React CSV types
- [ ] **@types/react-is** (^17.0.2) - React Is types
- [ ] **@types/react-router-dom** (^5.3.3) - React Router types
- [ ] **@types/react-select** (^1.2.1) - React Select types
- [ ] **@types/reactabular-table** (^8.14.6) - Reactabular types
- [ ] **@types/sinon** (^10.0.14) - Sinon types
- [ ] **@types/htmlhint** (^1.1.5) - HTMLHint types
- [ ] **@types/papaparse** (^5.3.14) - PapaParse types
- [ ] **@types/qrcode.react** (^1.0.5) - QRCode React types
- [ ] **@types/react-typist** (^2.0.6) - React Typist types
- [ ] **@types/video.js** (^7.3.58) - Video.js types
- [ ] **schema-dts** (^1.1.5) - Schema.org types

### React Components & Libraries
- [ ] **react-motion** (^0.5.2) - Animation library
- [ ] **react-onclickoutside** (~5.11.1) - Click outside detection
- [ ] **react-paginate** (^6.3.0) - Pagination component
- [ ] **react-pointable** (^1.1.1) - Pointer events
- [ ] **react-portal** (^4.2.1) - Portal component
- [ ] **react-resizable-layout** (^0.7.2) - Resizable layout
- [ ] **react-schemaorg** (^2.0.0) - Schema.org markup
- [ ] **react-sticky** (^6.0.3) - Sticky positioning
- [ ] **react-string-replace** (^1.1.1) - String replacement
- [ ] **react-tether** (^1.0.4) - Tether positioning
- [ ] **react-tooltip** (^3.2.7) - Tooltip component
- [ ] **react-transition-group** (2.9.0) - Transition animations
- [ ] **react-typist** (^2.0.5) - Typing animation
- [ ] **react-virtualized** (^9.18.5) - Virtual scrolling
- [ ] **react-virtualized-select** (^3.0.1) - Virtualized select
- [ ] **react-with-context** (^2.0.0) - Context utilities
- [ ] **react-loading-skeleton** (^3.1.0) - Loading skeletons
- [ ] **react-lazy-load** (~3.0.13) - Lazy loading
- [ ] **react-idle-timer** (^4.2.7) - Idle detection
- [ ] **react-inspector** (2.3.1) - React inspector
- [ ] **react-dom-confetti** (^0.2.0) - Confetti animation
- [ ] **react-draggable** (^4.4.6) - Draggable component
- [ ] **react-focus-on** (^3.9.4) - Focus management
- [ ] **intro.js-react** (^1.0.0) - Intro.js React wrapper
- [ ] **intro.js** (^7.2.0) - Intro.js library
- [ ] **focus-trap-react** (^10.1.1) - Focus trap
- [ ] **qrcode.react** (^0.8.0) - QR code generation
- [ ] **qtip2** (2.2.0) - Tooltip library
- [ ] **pixelmatch** (^5.2.0) - Pixel comparison
- [ ] **ml-knn** (^3.0.0) - Machine learning KNN
- [ ] **papaparse** (^5.4.1) - CSV parsing
- [ ] **js-cookie** (^2.1.2) - Cookie handling
- [ ] **jshint** (^2.13.6) - JavaScript linting
- [ ] **htmlhint** (^1.1.4) - HTML linting
- [ ] **@mapbox/search-js-react** (^1.0.0) - Mapbox search
- [ ] **@dsco_/link** (^1.1.2) - Link component
- [ ] **@excalidraw/excalidraw** (^0.17.6) - Excalidraw drawing
- [ ] **slate** (^0.81.0) - Rich text editor
- [ ] **slate-react** (^0.81.0) - Slate React components
- [ ] **reactabular-sticky** (^8.14.0) - Sticky table
- [ ] **reactabular-table** (^8.14.0) - Table component
- [ ] **reactabular-virtualized** (^8.18.0) - Virtualized table
- [ ] **sortabular** (^1.6.0) - Sortable table

## Analysis Status

- [ ] **Core React & UI Framework Dependencies** - TBD
- [ ] **State Management Dependencies** - TBD
- [ ] **Routing & Navigation Dependencies** - TBD
- [ ] **UI Components & Libraries Dependencies** - TBD
- [ ] **Code Editors & Syntax Highlighting Dependencies** - TBD
- [ ] **Blockly & Visual Programming Dependencies** - TBD
- [ ] **Code.org Specific Libraries Dependencies** - TBD
- [ ] **Data Visualization & Charts Dependencies** - TBD
- [ ] **Drag & Drop Dependencies** - TBD
- [ ] **Forms & Input Dependencies** - TBD
- [ ] **Media & Graphics Dependencies** - TBD
- [ ] **File Handling & Downloads Dependencies** - TBD
- [ ] **Utilities & Helpers Dependencies** - TBD
- [ ] **Date & Time Dependencies** - TBD
- [ ] **Internationalization Dependencies** - TBD
- [ ] **Testing & Development Dependencies** - TBD
- [ ] **Build Tools & Bundling Dependencies** - TBD
- [ ] **Babel & Transpilation Dependencies** - TBD
- [ ] **TypeScript Dependencies** - TBD
- [ ] **Linting & Code Quality Dependencies** - TBD
- [ ] **Styling & CSS Dependencies** - TBD
- [ ] **Storybook Dependencies** - TBD
- [ ] **Grunt Build System Dependencies** - TBD
- [ ] **External Services & APIs Dependencies** - TBD
- [ ] **Hardware & IoT Dependencies** - TBD
- [ ] **Python Integration Dependencies** - TBD
- [ ] **Other Utilities Dependencies** - TBD
- [ ] **Type Definitions Dependencies** - TBD
- [ ] **React Components & Libraries Dependencies** - TBD

## Next Steps

1. Analyze usage patterns for each dependency category
2. Identify files and line numbers where dependencies are used
3. Determine necessity and potential removal impact
4. Document upgrade paths and version recommendations
5. Add documentation and repository links

---

*This analysis is ongoing and will be updated as more information is gathered.*
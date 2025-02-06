
# CHANGELOG

## #1 Initial Project Setup

**Summary:** Established the initial project structure and basic configurations for both the frontend and backend services.

- Created the `CHANGELOG.md` file.
- Developed a bash script to generate a project structure based on user input for frontend, backend, or both.
- Implemented the React.js app setup with TypeScript, ESLint, Stylelint, SCSS, Tailwind, and Husky configurations.
- Added the folder structure for the frontend app.
- Configured basic testing support (initially with Jest, later replaced).

## #2 Dependency & Component Updates

**Summary:** Revised dependency installations and updated the default App component to better align with best practices.

- Installed `react`, `typescript`, `react-router-dom`, `lodash-es`, and `tailwindcss` as **dependencies**.
- Installed their respective `@types/*` packages as **devDependencies**.
- Added `classnames` as a **dependency**.
- Updated the default App component to use TypeScript and SCSS modules.

## #3 Vite & ESLint Enhancements

**Summary:** Introduced Vite configuration for SCSS modules and set up a basic ESLint configuration without import grouping.

- Created `vite.config.ts` with SCSS modules support and a custom server port.
- Generated an ESLint configuration file (`eslint.config.js`) without custom import grouping rules.
- Removed unnecessary packages from the ESLint configuration.

## #4 DevDependencies & TypeScript Fixes

**Summary:** Enhanced development dependencies and resolved TypeScript errors related to SCSS modules.

- Added Vitest (replacing Jest) and removed Jest-related dependencies.
- Installed additional devDependencies: `jiti`, `eslint-plugin-react`, and `@typescript-eslint/eslint-plugin`.
- Removed `eslint-define-config` and `eslint-plugin-import` as they were no longer needed.
- Added `src/global.d.ts` to declare SCSS modules.
- Updated `tsconfig.json` accordingly.

## #5 Husky Configuration Improvements

**Summary:** Improved Husky configuration by adopting modern practices and ensuring hook files are executable.

- Replaced deprecated Husky commands with the modern approach.
- Created pre-commit and pre-push hooks.

## #6 Testing and Configuration Updates

**Summary:** Replaced Jest with Vitest for testing and updated test configuration accordingly.

- Removed Jest and its configuration.
- Installed Vitest and updated the test script in package.json.
- Integrated Vitest configuration into `vite.config.ts` (using a JSDOM environment).
- Updated the test file to use `@testing-library/react` and `@testing-library/jest-dom`.

## #7 Vite Server Port Adjustment

**Summary:** Configured Vite to start the dev server on port 3000.

- Modified `vite.config.ts` to include a server block with `port: 3000`.

## #8 App Component Class Adjustments

**Summary:** Refactored the App component to compute its CSS classes in a dedicated variable and updated the root element's class.

- Moved the `classNames(styles.root, className)` call into a `const classes` variable placed above the return statement.
- Inserted a blank line between external imports and internal relative imports in the App component.
- Updated the root element's class from `styles.app` to `styles.root`.
- Updated the SCSS file to reflect the change.

## #9 Root Entry Point Setup

**Summary:** Added a root-level entry point to bootstrap the React application using TypeScript with JSX.

- Created `index.html` in the project root to define the mounting point and load `/index.tsx`.
- Created `index.tsx` in the project root to render the App container with an inline comment above the App import.

## #10 ESLint Import Grouping Removal

**Summary:** Removed all custom import grouping rules from the ESLint configuration and changed the file format to JavaScript.

- Converted the ESLint configuration into a plain JavaScript file (`eslint.config.js`).
- Removed the `import/order` rule and related grouping settings.
- Removed unnecessary packages (`eslint-define-config` and `eslint-plugin-import`) from the installation and configuration.

## #11 ESLint ESM & Package/TSConfig Adjustments

**Summary:** Made adjustments to use ES module syntax in the ESLint configuration and updated package.json and tsconfig.json.

- Added `"type": "module"` to `package.json`.
- Added `"types": ["node"]` to `tsconfig.json` under `compilerOptions`.
- Replaced all `require` calls in the ESLint config with ES module `import` statements.

## #12 ESLint Import Group Comments in Files

**Summary:** Added inline comments above import groups in component files, the test file, and the root entry point.

- Updated `/src/containers/App/index.tsx` to include a comment (`// Styles`) above the styles import.
- Updated `/src/containers/App/test.unit.tsx` to include a comment (`// App Component`) above the App import.
- Updated the root `index.tsx` file to include a comment (`// App Component`) above the App import.

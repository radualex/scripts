#!/bin/bash

# Function to create a React.js app
create_frontend_app() {
  local project_name=$1
  echo "Creating React.js app in $project_name-app..."
  
  # Step 6.a: Initialize npm project and add "type": "module" to package.json
  npm init -y
  jq '. + { "type": "module" }' package.json > tmp.json && mv tmp.json package.json
  
  # Step 6.b: Install dependencies and devDependencies
  npm install react react-dom typescript react-router-dom lodash-es tailwindcss classnames
  npm install \
    @types/react \
    @types/react-dom \
    @types/lodash-es \
    @types/react-router-dom \
    @types/jest \
    @vitejs/plugin-react \
    vitest \
    vite \
    eslint \
    stylelint \
    sass \
    husky \
    @testing-library/react \
    @testing-library/jest-dom \
    identity-obj-proxy \
    jsdom \
    eslint-plugin-react \
    @typescript-eslint/eslint-plugin \
    --save-dev
  
  # Step 6.c: Add configurations
  
  # Configure Vite for SCSS modules, set server port to 3000, and add Vitest configuration
  cat <<EOL > vite.config.ts
import { defineConfig } from 'vitest/config';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  css: {
    modules: {
      localsConvention: 'camelCase'
    }
  },
  server: {
    port: 3000
  },
  test: {
    globals: true,
    environment: 'jsdom',
    include: ['src/**/*/test.unit.[tj]sx']
  }
});
EOL
  
  # Generate ESLint flat config as a plain JS file (eslint.config.js) without import grouping
  cat <<'EOL' > eslint.config.js
import parser from "@typescript-eslint/parser";
import tsEslintPlugin from "@typescript-eslint/eslint-plugin";
import reactPlugin from "eslint-plugin-react";

export default [
  {
    // Configuration for TypeScript/TSX files
    files: ["**/*.{ts,tsx}"],
    languageOptions: {
      parser,
      parserOptions: {
        ecmaVersion: "latest",
        sourceType: "module",
        ecmaFeatures: {
          jsx: true
        }
      },
      globals: {
        window: "readonly",
        document: "readonly",
        navigator: "readonly"
      }
    },
    plugins: {
      react: reactPlugin,
      "@typescript-eslint": tsEslintPlugin
    }
  },
  {
    // Configuration for JavaScript files
    files: ["**/*.js"],
    languageOptions: {
      ecmaVersion: "latest",
      sourceType: "module",
      globals: {
        window: "readonly",
        document: "readonly",
        navigator: "readonly"
      }
    }
  }
];
EOL
  
  # Configure Stylelint
  cat <<EOL > .stylelintrc.json
{
  "extends": "stylelint-config-standard-scss",
  "rules": {}
}
EOL
  
  # Configure Tailwind
  cat <<EOL > tailwind.config.js
module.exports = {
  content: [
    "./src/**/*.{ts,tsx}"
  ],
  theme: {
    extend: {}
  },
  plugins: []
};
EOL
  
  # Configure TypeScript to recognize SCSS modules
  mkdir -p src
  cat <<EOL > src/global.d.ts
declare module '*.module.scss' {
  const classes: { [key: string]: string };
  export default classes;
}
EOL
  
  # Configure TypeScript
  cat <<EOL > tsconfig.json
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "ESNext",
    "lib": ["DOM", "DOM.Iterable", "ESNext"],
    "skipLibCheck": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "moduleResolution": "Node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx"
  },
  "include": ["src", "src/global.d.ts"]
}
EOL
  
  # Step 6.d: Add package.json scripts (removing the --ext flag entirely)
  jq '.scripts += {
    "start": "vite",
    "build": "vite build",
    "test": "vitest",
    "lint": "eslint .",
    "lint:fix": "eslint --fix ."
  }' package.json > tmp.json && mv tmp.json package.json
  
  # Step 6.e: Create folder structure
  mkdir -p src/{components,containers/App,helpers}
  
  # Updated App component in /src/containers/App/index.tsx with import group comments
  # External imports first, then a comment for the "Styles" group.
  cat <<EOL > src/containers/App/index.tsx
import React from 'react';
import classNames from 'classnames';

// Styles
import styles from './styles.module.scss';

interface Props extends React.ComponentProps<'div'> {}

const App: React.FunctionComponent<Props> = ({ className, ...props }) => {
  const classes = classNames(styles.root, className);

  return (
    <div className={classes} {...props}>
      Hello World
    </div>
  );
};

export default App;
EOL
  
  # Updated SCSS file to use .root instead of .app
  cat <<EOL > src/containers/App/styles.module.scss
.root {
  color: red;
}
EOL
  
  # Update test file in /src/containers/App/test.unit.tsx with an import group comment for the App component
  cat <<EOL > src/containers/App/test.unit.tsx
import React from 'react';
import '@testing-library/jest-dom';
import { render, screen } from '@testing-library/react';

// Containers
import App from '.';

it('renders App component', () => {
  render(<App />);

  expect(screen.getByText(/Hello World/i)).toBeInTheDocument();
});
EOL
  
  # Step 6.f: Configure Husky (modern approach)
  npm pkg set scripts.prepare="husky"
  npm run prepare
  
  # Create .husky directory and add hooks
  mkdir -p .husky
  cat <<EOL > .husky/pre-commit
#!/bin/sh
. "\$(dirname "\$0")/_/husky.sh"

npm run lint
EOL
  
  cat <<EOL > .husky/pre-push
#!/bin/sh
. "\$(dirname "\$0")/_/husky.sh"

npm run build && npm run test
EOL
  
  # Make hooks executable
  chmod +x .husky/pre-commit
  chmod +x .husky/pre-push
  
  # Step 6.g: Create root index.html file to bootstrap the React app
  cat <<EOL > index.html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>React App</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/index.tsx"></script>
  </body>
</html>
EOL
  
  # Step 6.h: Create root index.tsx file that renders the App container with an import group comment
  cat <<EOL > index.tsx
import React from 'react';
import ReactDOM from 'react-dom/client';

// Containers
import App from './src/containers/App';

const rootElement = document.getElementById('root');
if (rootElement) {
  const root = ReactDOM.createRoot(rootElement);
  root.render(
    <React.StrictMode>
      <App />
    </React.StrictMode>
  );
}
EOL
  
  echo "Frontend app setup complete!"
}

# Function to create a backend service
create_backend_service() {
  local project_name=$1
  echo "Creating backend service in $project_name-service..."
  mkdir -p "$project_name-service"
  echo "Backend service folder created."
}

# Main script
if [ -z "$1" ]; then
  echo "Usage: $0 <project_name>"
  exit 1
fi

name=$1

echo "Select the components to create:"
echo "1) Frontend"
echo "2) Backend"
echo "3) Both"
read -p "Enter your choice (1/2/3): " choice

case $choice in
  1)
    mkdir -p "${name}-app"
    cd "${name}-app" || exit 1
    create_frontend_app "$name"
    ;;
  2)
    create_backend_service "$name"
    ;;
  3)
    mkdir -p "$name"
    cd "$name" || exit 1
    mkdir -p "${name}-app"
    cd "${name}-app" || exit 1
    create_frontend_app "$name"
    cd ..
    create_backend_service "$name"
    ;;
  *)
    echo "Invalid choice!"
    exit 1
    ;;
esac

echo "Project setup complete!"

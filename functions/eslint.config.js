import js from "@eslint/js";
import tsPlugin from "@typescript-eslint/eslint-plugin";
import tsParser from "@typescript-eslint/parser"; // Import TypeScript parser

export default [
  {
    languageOptions: {
      parser: tsParser, // Specify parser under languageOptions
    },
    plugins: {
      "@typescript-eslint": tsPlugin, // Reference the actual TypeScript plugin object
    },
    rules: {
      quotes: ["error", "double"],
      "import/no-unresolved": 0,
      indent: ["error", 2],
      "no-console": "warn",
      "@typescript-eslint/no-var-requires": "off",
    },
  },
  {
    files: ["*.js"],
    ...js.configs.recommended, // Include recommended rules for JavaScript
  },
  {
    files: ["*.ts"],
    ...tsPlugin.configs.recommended, // Include recommended rules for TypeScript
  },
];

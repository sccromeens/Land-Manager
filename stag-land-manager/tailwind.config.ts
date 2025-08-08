import type { Config } from "tailwindcss";

const config: Config = {
  darkMode: ["class"],
  content: [
    "./app/**/*.{ts,tsx}",
    "./components/**/*.{ts,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        brand: {
          DEFAULT: "#1f6b63",
          light: "#3b978d",
          dark: "#154a44"
        }
      }
    },
  },
  plugins: [],
};
export default config;

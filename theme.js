const toggleButton = document.getElementById("theme-toggle");
const stylesheet = document.getElementById("theme-stylesheet");

const LIGHT = "light.css";
const DARK = "dark.css";

// Load saved theme
const savedTheme = localStorage.getItem("theme");
if (savedTheme) {
  stylesheet.href = savedTheme;
}

toggleButton.addEventListener("click", () => {
  const newTheme = stylesheet.href.includes("light.css")
    ? DARK
    : LIGHT;

  stylesheet.href = newTheme;
  localStorage.setItem("theme", newTheme);
});

const toggleButton = document.getElementById("theme-toggle");
const stylesheet = document.getElementById("theme-stylesheet");

const LIGHT = "/style/light.css";
const DARK = "/style/dark.css";

// Determine initial theme
let currentTheme = localStorage.getItem("theme");
if (!currentTheme) {
    currentTheme = window.matchMedia("(prefers-color-scheme: dark)").matches ? DARK : LIGHT;
}
stylesheet.href = currentTheme;


// Toggle theme function
function toggleTheme() {
    currentTheme = currentTheme === LIGHT ? DARK : LIGHT;
    stylesheet.href = currentTheme;
    localStorage.setItem("theme", currentTheme);
}

toggleButton.addEventListener("click", toggleTheme);

// Optional: update theme if system preference changes
window.matchMedia("(prefers-color-scheme: dark)").addEventListener("change", e => {
    if (!localStorage.getItem("theme")) { // Only auto-update if user hasn't manually selected
        currentTheme = e.matches ? DARK : LIGHT;
        stylesheet.href = currentTheme;
    }
});

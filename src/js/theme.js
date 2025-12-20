const toggleButton = document.getElementById("theme-toggle");
const stylesheet = document.getElementById("theme-stylesheet");

const LIGHT = "/src/style/light.css";
const DARK = "/src/style/dark.css";

// Load saved theme
const savedTheme = localStorage.getItem("theme");
if (savedTheme) {
    stylesheet.href = savedTheme;
} else {
    stylesheet.href = DARK;
}

function toggleTheme() {

    const newTheme = stylesheet.href.includes(LIGHT)
        ? DARK
        : LIGHT;
    stylesheet.href = newTheme;
    localStorage.setItem("theme", newTheme);
}

toggleButton.addEventListener("click", toggleTheme);

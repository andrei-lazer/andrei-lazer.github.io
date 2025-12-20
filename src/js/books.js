function slugify(text) {
    return text
        .toLowerCase()
        .replace(/[^a-z0-9]+/g, '-')
        .replace(/(^-|-$)/g, '');
}


async function loadBooks(path) {
    const text = await fetch(path).then(r => r.text());
    const lines = text.split('\n');

    const books = [];
    let current = null;

    const clean = v => v.replace(/^['"]|['"]$/g, '');

    for (const raw of lines) {
        const line = raw.trim();

        // New book entry, possibly with inline key/value
        if (line.startsWith('- ')) {
            current = {};
            books.push(current);

            const rest = line.slice(2).trim();
            if (rest.includes(':')) {
                const idx = rest.indexOf(':');
                const key = rest.slice(0, idx).trim();
                const value = clean(rest.slice(idx + 1).trim());
                current[key] = value;
            }
            continue;
        }

        if (!current || !line.includes(':')) continue;

        const idx = line.indexOf(':');
        const key = line.slice(0, idx).trim();
        const value = clean(line.slice(idx + 1).trim());

        current[key] = value;
    }

    return books;
}


async function init() {
    const books = await loadBooks('/books.yaml');
    const container = document.getElementById('books');

    for (const book of books) {
        const slug = slugify(`${book.title}-${book.author}`);
        const coverFile = `${slug}.jpg`;

        const div = document.createElement('div');
        div.className = 'book';

        const link = book.link ? book.link : "https://www.librarything.com/profile/rezalazer";

        div.innerHTML = `
            <a href="${link}", style="background:var(--bg-color);" target="_blank">
            <img src="covers/${coverFile}" alt="${book.title}">
            </a>
            <a href="${link}" target="_blank">
            ${book.title}
            </a>
            `;

        container.appendChild(div);
    }
}


init();

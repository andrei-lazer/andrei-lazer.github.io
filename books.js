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
                const value = rest.slice(idx + 1).trim();
                current[key] = value;
            }
            continue;
        }


        if (!current || !line.includes(':')) continue;


        const idx = line.indexOf(':');
        const key = line.slice(0, idx).trim();
        const value = line.slice(idx + 1).trim();


        current[key] = value;
    }


    return books;
}


async function init() {
    const books = await loadBooks('books.yaml');
    const container = document.getElementById('books');


    for (const book of books) {
        const slug = slugify(`${book.title}-${book.author}`);
        const coverFile = `${slug}.jpg`;


        const div = document.createElement('div');
        div.className = 'book';


        div.innerHTML = `
            <img src="covers/${coverFile}" alt="${book.title}" />
            ${book.title}
            `;


        container.appendChild(div);
    }
}


init();

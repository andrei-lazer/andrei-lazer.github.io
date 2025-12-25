export default async function() {
    const { default: books } = await import("./my_books.json", {
      with: {
        type: "json",
      },
    });

    async function fetchCover(book) {
        if (book.cover_url) {
            return {
                ...book,
                cover: book.cover_url
            };
        }
        const q = encodeURIComponent(`${book.title} ${book.author}`);
        const url = `https://openlibrary.org/search.json?q=${q}&limit=1`;

        const res = await fetch(url);
        const data = await res.json();

        const doc = data?.docs?.[0];
        if (!doc || !doc.cover_i) return { ...book, cover: null };

        return {
            ...book,
            cover: `https://covers.openlibrary.org/b/id/${doc.cover_i}-L.jpg`
        };
    }

    return Promise.all(books.map(fetchCover));
}

export default async function () {
  const { default: books } = await import("./my_books.json", {
    with: { type: "json" },
  });

  async function fetchCover(book) {
    // If cover already provided, use it
    if (book.cover_url) {
      return {
        ...book,
        cover: book.cover_url,
      };
    }

    const q = encodeURIComponent(`${book.title} ${book.author}`);
    const url = `https://openlibrary.org/search.json?q=${q}&limit=1`;

    try {
      const res = await fetch(url);

      // Check HTTP status first
      if (!res.ok) {
        console.error(
          `OpenLibrary error ${res.status} ${res.statusText} for: ${book.title}. url: ${url}`
        );
        return { ...book, cover: null };
      }

      // Read as text first so JSON parsing never crashes Eleventy
      const text = await res.text();

      let data;
      try {
        data = JSON.parse(text);
      } catch (err) {
        console.error(
          `Invalid JSON from OpenLibrary for: ${book.title}\nFirst 300 chars:\n${text.slice(
            0,
            300
          )}`
        );
        return { ...book, cover: null };
      }

      const doc = data?.docs?.[0];
      if (!doc || !doc.cover_i) {
        return { ...book, cover: null };
      }

      return {
        ...book,
        cover: `https://covers.openlibrary.org/b/id/${doc.cover_i}-L.jpg`,
      };
    } catch (err) {
      // Network failure, DNS issue, etc.
      console.error(
        `Fetch failed for "${book.title}": ${err.message}`
      );
      return { ...book, cover: null };
    }
  }

  // Important: individual failures won't break the whole build
  return Promise.all(books.map(fetchCover));
}

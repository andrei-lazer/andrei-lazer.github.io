import re
from pathlib import Path
import requests
import yaml


COVERS_DIR = Path('covers')
COVERS_DIR.mkdir(exist_ok=True)




def slugify(text: str) -> str:
    text = text.lower()
    text = re.sub(r'[^a-z0-9]+', '-', text)
    return re.sub(r'-+', '-', text).strip('-')




with open('books.yaml', 'r') as f:
    data = yaml.safe_load(f)


for book in data['books']:
    title = book['title']
    author = book['author']


    query = f"{title} {author}"
    filename = f"{slugify(title + '-' + author)}.jpg"
    out = COVERS_DIR / filename

    if out.exists():
        continue

    print(f"→ {query}")


    r = requests.get(
            'https://openlibrary.org/search.json',
            params={'q': query},
            timeout=10,
            )
    r.raise_for_status()


    docs = r.json().get('docs', [])
    cover_id = next((d['cover_i'] for d in docs if 'cover_i' in d), None)


    if not cover_id:
        print(' ✗ no cover found')
        continue


    img_url = f'https://covers.openlibrary.org/b/id/{cover_id}-L.jpg'
    img = requests.get(img_url, timeout=10)
    img.raise_for_status()


    out.write_bytes(img.content)
    print(f" ✓ saved {out}")

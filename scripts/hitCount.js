// abacus is a cool project! check it out
const BASE = 'https://abacus.jasoncameron.dev/';
const NAMESPACE = 'andreilazer.me';
const VARNAME = 'visitors'

let visitorCount;
let apiURL;

// simple attempt at only registering new hits
const visited = localStorage.getItem("visited");
if (!visited) {
    localStorage.setItem("visited", true);
    apiURL = BASE + "hit/" + NAMESPACE + "/" + VARNAME;
} else {
    apiURL = BASE + "get/" + NAMESPACE + "/" + VARNAME;
}

fetch(apiURL)
    .then(response => response.json())
    .then(data => {
        document.getElementById('visitorCount').textContent = data.value;
    })
    .catch(error => {
        console.error('Error fetching visitor count:', error);
        document.getElementById('visitorCount').textContent = 'error';
    });

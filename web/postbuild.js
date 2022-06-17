// Read the entire html file into a string and replace all the "/"
const fs = require('fs');
const path = require('path');

const html = path.join('../dist', 'index.html');
const index = fs.readFileSync(html).toString().replaceAll('"/', '"');
fs.writeFileSync(html, index);
console.log('Post build tasks finished on HTML file');

// Find '/logo.png' in the index.js and replace with 'logo.png'
const indexJs = path.join('../dist', 'index.js');
const indexJsContent = fs.readFileSync(indexJs).toString().replaceAll('"/logo.png', '"logo.png');
fs.writeFileSync(indexJs, indexJsContent);

console.log('Post build tasks finished on JS file');

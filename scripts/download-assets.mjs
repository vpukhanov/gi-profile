import { quickScraper } from '@vpukhanov/quick-scraper';
import fetch from 'node-fetch';
import fs from 'fs/promises';

const NAMECARDS_GALLERY =
  'https://genshin-impact.fandom.com/wiki/Namecards/Gallery';
const CHARACTERS_GALLERY = 'https://genshin-impact.fandom.com/wiki/Character';

async function loadNamecards() {
  const namecards = await quickScraper({
    url: NAMECARDS_GALLERY,
    options: {
      images: {
        selector: "img[data-image-key^='Namecard_Background']",
        text: false,
        listItem: true,
        customAttributes: {
          alt: true,
          'data-src': true,
        },
      },
    },
  });

  const namecardsList = [];
  for (const img of namecards.data.images.lists) {
    const { alt: name, 'data-src': scaledSrc } = img.customAttributes;

    console.log('Loading image ' + name + '...');

    const filename = name.toLowerCase().replace(/[^a-zA-Z]/g, '_');
    const src = scaledSrc.slice(0, scaledSrc.indexOf('scale-to'));

    const response = await fetch(src);
    const buffer = await response.buffer();
    await fs.writeFile('./assets/namecards/' + filename + '.png', buffer);

    namecardsList.push({ name, filename });
  }

  fs.writeFile(
    './assets/namecards.json',
    JSON.stringify(namecardsList, null, 2)
  );
}

async function loadCharacters() {
  const characters = await quickScraper({
    url: CHARACTERS_GALLERY,
    options: {
      images: {
        selector: ".article-table img[data-image-key^='Character_']",
        text: false,
        listItem: true,
        customAttributes: {
          alt: true,
          'data-src': true,
        },
      },
    },
  });

  const charactersList = [];
  for (const img of characters.data.images.lists) {
    const { alt: rawName, 'data-src': scaledSrc } = img.customAttributes;
    const name = rawName
      .replace(/^Character\s*/i, '')
      .replace(/\s*Thumb\.png$/, '');

    console.log('Loading image ' + name + '...');

    const filename = name.toLowerCase().replace(/[^a-zA-Z]/g, '_');
    const src = scaledSrc.slice(0, scaledSrc.indexOf('scale-to'));

    const response = await fetch(src);
    const buffer = await response.buffer();
    await fs.writeFile('./assets/characters/' + filename + '.png', buffer);

    charactersList.push({ name, filename });
  }

  fs.writeFile(
    './assets/characters.json',
    JSON.stringify(charactersList, null, 2)
  );
}

// loadNamecards();
loadCharacters();

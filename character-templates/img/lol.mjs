#!/usr/bin/env node

import fs from 'fs/promises';
import path from 'path';

const imagePath = process.argv[2] || './Beryl the Bio-Hacker.webp';
const numFrames = process.argv[3] || 8;
const serverUrl = `http://cloud.isekai.chat:8000/generate?num_frames=${numFrames}&chunk_strategy=interp-gt`;
const outputDir = '/tmp';
// const outputPrefix = `frame-`;
const outputPrefix = `frame-gt-`;

async function main() {
  try {
    // Read image file
    const imageData = await fs.readFile(imagePath);
    
    // Send image to server
    const response = await fetch(serverUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'image/png'
      },
      body: imageData
    });
    
    if (!response.ok) {
      throw new Error(`Server returned ${response.status}: ${await response.text()}`);
    }
    
    // Parse response JSON
    const data = await response.json();
    
    if (!data.frames || !data.num_frames) {
      throw new Error('Invalid response format from server');
    }
    
    console.log(`Received ${data.num_frames} frames from server`);
    
    // Write each frame to a file
    for (let i = 0; i < data.frames.length; i++) {
      const frameData = Buffer.from(data.frames[i], 'base64');
      const outputPath = path.join(outputDir, `${outputPrefix}${i}.webp`);
      await fs.writeFile(outputPath, frameData);
      console.log(`Saved frame ${i} to ${outputPath}`);
    }
    
    console.log('All frames saved successfully');
  } catch (error) {
    console.error('Error:', error.message);
    process.exit(1);
  }
}

main();
const statusText = document.getElementById('status-text');
const jsonOutput = document.getElementById('json-output');

let wasmInstance = null;
let currentString = "";

// Syntax highlighter function
function syntaxHighlight(jsonStr) {
  try {
    const obj = JSON.parse(jsonStr);
    const pretty = JSON.stringify(obj, null, 2);
    return pretty.replace(/("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)/g, function (match) {
      let cls = 'num';
      if (/^"/.test(match)) {
        if (/:$/.test(match)) {
          return `<span style="color:#e0e2e8">${match}</span>`;
        } else {
          cls = 'str';
        }
      } else if (/true|false/.test(match)) {
        cls = 'bool';
      } else if (/null/.test(match)) {
        cls = 'bool';
      }
      return `<span class="${cls}">${match}</span>`;
    });
  } catch (e) {
    return jsonStr; // Not valid JSON yet
  }
}

// Environment for Wasm
const importObject = {
  env: {
    output_start: () => {
      currentString = "";
    },
    output_char: (char) => {
      currentString += String.fromCharCode(char);
    },
    output_end: () => {
      jsonOutput.innerHTML = syntaxHighlight(currentString);
      statusText.innerText = "Serialization Complete";
      statusText.style.color = "#45fadc";
    }
  }
};

async function init() {
  try {
    statusText.innerText = "Loading Wasm...";
    // Try to load wasm from the MoonBit build directory
    let res = await fetch('../_build/wasm/release/build/src/src.wasm').catch(() => null);
    if (!res || !res.ok) {
        res = await fetch('../_build/wasm-gc/release/build/src/src.wasm').catch(() => null);
    }
    if (!res || !res.ok) {
        res = await fetch('../target/wasm/release/build/src/src.wasm').catch(() => null);
    }
    
    if (!res || !res.ok) {
        throw new Error("Wasm file not found. Ensure you ran `moon build --target wasm --release`");
    }
    
    const buffer = await res.arrayBuffer();
    const { instance } = await WebAssembly.instantiate(buffer, importObject);
    wasmInstance = instance;
    statusText.innerText = "Wasm Ready";
  } catch(e) {
    statusText.innerText = "Wasm Error";
    statusText.style.color = "#ff5c8d";
    console.error("Wasm Init Error:", e);
  }
}

init();

// Bind buttons
document.getElementById('btn-parse').addEventListener('click', () => {
  if(!wasmInstance) return;
  const inputStr = document.getElementById('json-input').value;
  statusText.innerText = "Parsing...";
  
  wasmInstance.exports.input_start();
  for(let i=0; i<inputStr.length; i++) {
    wasmInstance.exports.input_char(inputStr.charCodeAt(i));
  }
  wasmInstance.exports.input_parse_and_echo();
});

document.getElementById('btn-primitive').addEventListener('click', () => {
  if(!wasmInstance) return;
  statusText.innerText = "Serializing...";
  wasmInstance.exports.demo_serialize_primitive();
});

document.getElementById('btn-nested').addEventListener('click', () => {
  if(!wasmInstance) return;
  statusText.innerText = "Serializing...";
  wasmInstance.exports.demo_serialize_nested();
});

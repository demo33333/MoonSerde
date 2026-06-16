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

// Auth form toggling and processing
const authContainer = document.getElementById('auth-container');
const playgroundContainer = document.getElementById('playground-container');
const loginForm = document.getElementById('login-form');
const registerForm = document.getElementById('register-form');
const authTitle = document.getElementById('auth-title');
const authStatus = document.getElementById('auth-status');

const goToRegister = document.getElementById('go-to-register');
const goToLogin = document.getElementById('go-to-login');

const loginError = document.getElementById('login-error');
const registerError = document.getElementById('register-error');

goToRegister.addEventListener('click', (e) => {
  e.preventDefault();
  loginForm.classList.add('hidden');
  registerForm.classList.remove('hidden');
  authTitle.innerText = "Initialize Node";
  authStatus.innerText = "Registration Portal";
  registerError.style.display = 'none';
});

goToLogin.addEventListener('click', (e) => {
  e.preventDefault();
  registerForm.classList.add('hidden');
  loginForm.classList.remove('hidden');
  authTitle.innerText = "System Access";
  authStatus.innerText = "Security Portal";
  loginError.style.display = 'none';
});

// Helper for transition to Dashboard
function transitionToDashboard() {
  authContainer.classList.add('fade-out');
  setTimeout(() => {
    authContainer.classList.add('hidden');
    playgroundContainer.classList.remove('hidden');
    playgroundContainer.classList.add('fade-in');
  }, 500);
}

// Login Submit
loginForm.addEventListener('submit', (e) => {
  e.preventDefault();
  loginError.style.display = 'none';
  
  const username = document.getElementById('login-username').value.trim();
  const securityKey = document.getElementById('login-password').value;

  if (!username || !securityKey) {
    loginError.innerText = "All authentication fields are required.";
    loginError.style.display = 'block';
    return;
  }

  // Simulate loading state
  const btn = document.getElementById('btn-login-submit');
  const originalText = btn.innerHTML;
  btn.innerHTML = `<span class="dot" style="animation: pulse 1s infinite;"></span> Authenticating...`;
  btn.disabled = true;

  setTimeout(() => {
    btn.innerHTML = originalText;
    btn.disabled = false;
    transitionToDashboard();
  }, 1200);
});

// Register Submit
registerForm.addEventListener('submit', (e) => {
  e.preventDefault();
  registerError.style.display = 'none';

  const username = document.getElementById('register-username').value.trim();
  const securityKey = document.getElementById('register-password').value;
  const confirmKey = document.getElementById('register-confirm-password').value;

  if (!username || !securityKey || !confirmKey) {
    registerError.innerText = "All registration fields are required.";
    registerError.style.display = 'block';
    return;
  }

  if (securityKey.length < 6) {
    registerError.innerText = "Security Key must be at least 6 characters.";
    registerError.style.display = 'block';
    return;
  }

  if (securityKey !== confirmKey) {
    registerError.innerText = "Security Keys do not match.";
    registerError.style.display = 'block';
    return;
  }

  // Simulate loading state
  const btn = document.getElementById('btn-register-submit');
  const originalText = btn.innerHTML;
  btn.innerHTML = `<span class="dot" style="animation: pulse 1s infinite;"></span> Initializing Node...`;
  btn.disabled = true;

  setTimeout(() => {
    btn.innerHTML = originalText;
    btn.disabled = false;
    transitionToDashboard();
  }, 1200);
});

// Bind dashboard controls buttons
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

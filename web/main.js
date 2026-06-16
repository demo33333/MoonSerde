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

// Toast notification helper
function showToast(message, isError = false) {
  const toast = document.createElement('div');
  toast.className = 'toast-notification';
  if (isError) {
    toast.style.borderColor = '#ff5c8d';
    toast.style.boxShadow = '0 0 15px rgba(255, 92, 141, 0.2)';
  }
  toast.innerHTML = `<span class="user-pulse" style="background-color: ${isError ? '#ff5c8d' : 'var(--accent-cyan)'}; box-shadow: 0 0 8px ${isError ? '#ff5c8d' : 'var(--accent-cyan)'}"></span> ${message}`;
  document.body.appendChild(toast);
  setTimeout(() => {
    toast.remove();
  }, 2300);
}

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
function transitionToDashboard(username) {
  sessionStorage.setItem('active_node', username);
  document.getElementById('user-display-name').innerText = "NODE: " + username.toUpperCase();
  
  authContainer.classList.add('fade-out');
  setTimeout(() => {
    authContainer.classList.add('hidden');
    playgroundContainer.classList.remove('hidden');
    playgroundContainer.classList.add('fade-in');
    showToast(`Welcome back, agent ${username}`);
  }, 500);
}

// Check active session on page load
const activeNode = sessionStorage.getItem('active_node');
if (activeNode) {
  authContainer.classList.add('hidden');
  playgroundContainer.classList.remove('hidden');
  document.getElementById('user-display-name').innerText = "NODE: " + activeNode.toUpperCase();
}

// Disconnect Button Click
document.getElementById('btn-disconnect').addEventListener('click', () => {
  sessionStorage.removeItem('active_node');
  playgroundContainer.classList.add('fade-out');
  setTimeout(() => {
    playgroundContainer.classList.add('hidden');
    playgroundContainer.classList.remove('fade-out', 'fade-in');
    
    // Clear credentials
    loginForm.reset();
    registerForm.reset();
    
    authContainer.classList.remove('hidden', 'fade-out');
    authContainer.classList.add('fade-in');
    showToast("Terminal node disconnected");
  }, 500);
});

// Fetch mock database from localStorage
function getUsersDB() {
  const data = localStorage.getItem('serde_users');
  return data ? JSON.parse(data) : {};
}

function saveUsersDB(db) {
  localStorage.setItem('serde_users', JSON.stringify(db));
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

  const db = getUsersDB();
  if (!db[username]) {
    loginError.innerText = "Node Alias not found. Register a new terminal node.";
    loginError.style.display = 'block';
    return;
  }

  if (db[username] !== securityKey) {
    loginError.innerText = "Decryption failed. Invalid Security Key.";
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
    transitionToDashboard(username);
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

  const db = getUsersDB();
  if (db[username]) {
    registerError.innerText = "Node Alias already registered.";
    registerError.style.display = 'block';
    return;
  }

  // Save node user
  db[username] = securityKey;
  saveUsersDB(db);

  // Simulate loading state
  const btn = document.getElementById('btn-register-submit');
  const originalText = btn.innerHTML;
  btn.innerHTML = `<span class="dot" style="animation: pulse 1s infinite;"></span> Initializing Node...`;
  btn.disabled = true;

  setTimeout(() => {
    btn.innerHTML = originalText;
    btn.disabled = false;
    transitionToDashboard(username);
  }, 1200);
});

// Format JSON Input Click
document.getElementById('btn-format').addEventListener('click', () => {
  const textarea = document.getElementById('json-input');
  try {
    const val = textarea.value.trim();
    if (!val) {
      showToast("JSON Input is empty", true);
      return;
    }
    const parsedObj = JSON.parse(val);
    textarea.value = JSON.stringify(parsedObj, null, 2);
    showToast("JSON formatted successfully");
  } catch (err) {
    showToast("Invalid JSON syntax structure", true);
  }
});

// Copy Output Code Click
document.getElementById('btn-copy').addEventListener('click', () => {
  const code = document.getElementById('json-output');
  const text = code.innerText || code.textContent;
  
  if (!text || text.trim().startsWith("// Waiting")) {
    showToast("No output generated yet", true);
    return;
  }
  
  // Clean syntax highlighting content text
  const cleanText = code.innerText;
  navigator.clipboard.writeText(cleanText).then(() => {
    showToast("JSON Output copied to clipboard");
  }).catch(() => {
    showToast("Decryption error copying text", true);
  });
});

// Bind dashboard controls buttons
document.getElementById('btn-parse').addEventListener('click', () => {
  if(!wasmInstance) {
    showToast("Wasm module not loaded", true);
    return;
  }
  const inputStr = document.getElementById('json-input').value;
  statusText.innerText = "Parsing...";
  
  wasmInstance.exports.input_start();
  for(let i=0; i<inputStr.length; i++) {
    wasmInstance.exports.input_char(inputStr.charCodeAt(i));
  }
  wasmInstance.exports.input_parse_and_echo();
});

document.getElementById('btn-primitive').addEventListener('click', () => {
  if(!wasmInstance) {
    showToast("Wasm module not loaded", true);
    return;
  }
  statusText.innerText = "Serializing...";
  wasmInstance.exports.demo_serialize_primitive();
});

document.getElementById('btn-nested').addEventListener('click', () => {
  if(!wasmInstance) {
    showToast("Wasm module not loaded", true);
    return;
  }
  statusText.innerText = "Serializing...";
  wasmInstance.exports.demo_serialize_nested();
});

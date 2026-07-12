// JS FFI helpers for DOM operations
extern "js" fn get_element_value(id : String) -> String = "(id) => { const el = document.getElementById(id); return el ? el.value : ''; }"
extern "js" fn get_element_text(id : String) -> String = "(id) => { const el = document.getElementById(id); return el ? el.innerText : ''; }"
extern "js" fn set_element_value(id : String, value : String) -> Unit = "(id, val) => { const el = document.getElementById(id); if (el) el.value = val; }"
extern "js" fn set_element_text(id : String, text : String) -> Unit = "(id, txt) => { const el = document.getElementById(id); if (el) el.innerText = txt; }"
extern "js" fn set_element_html(id : String, html : String) -> Unit = "(id, html) => { const el = document.getElementById(id); if (el) el.innerHTML = html; }"
extern "js" fn add_class(id : String, className : String) -> Unit = "(id, cls) => { const el = document.getElementById(id); if (el) el.classList.add(cls); }"
extern "js" fn remove_class(id : String, className : String) -> Unit = "(id, cls) => { const el = document.getElementById(id); if (el) el.classList.remove(cls); }"
extern "js" fn add_click_listener(id : String, cb : () -> Unit) -> Unit = "(id, cb) => { const el = document.getElementById(id); if (el) el.addEventListener('click', (e) => { e.preventDefault(); cb(); }); }"
extern "js" fn add_submit_listener(id : String, cb : () -> Unit) -> Unit = "(id, cb) => { const el = document.getElementById(id); if (el) el.addEventListener('submit', (e) => { e.preventDefault(); cb(); }); }"
extern "js" fn get_session_storage(key : String) -> String = "(key) => sessionStorage.getItem(key) || ''"
extern "js" fn set_session_storage(key : String, value : String) -> Unit = "(key, val) => sessionStorage.setItem(key, val)"
extern "js" fn remove_session_storage(key : String) -> Unit = "(key) => sessionStorage.removeItem(key)"
extern "js" fn copy_to_clipboard(text : String) -> Unit = "(text) => { navigator.clipboard.writeText(text); }"

extern "js" fn disable_button(id : String, disabled : Bool) -> Unit = "(id, disabled) => { const el = document.getElementById(id); if (el) el.disabled = disabled; }"
extern "js" fn get_element_html(id : String) -> String = "(id) => { const el = document.getElementById(id); return el ? el.innerHTML : ''; }"
extern "js" fn set_element_display(id : String, display : String) -> Unit = "(id, d) => { const el = document.getElementById(id); if (el) el.style.display = d; }"
extern "js" fn set_element_text_color(id : String, color : String) -> Unit = "(id, c) => { const el = document.getElementById(id); if (el) el.style.color = c; }"

extern "js" fn to_upper_case(s : String) -> String = "(s) => s.toUpperCase()"

extern "js" fn run_after_delay(ms : Int, cb : () -> Unit) -> Unit = "(ms, cb) => setTimeout(cb, ms)"

// LocalStorage User Database Operations
extern "js" fn user_exists(username : String) -> Bool =
  #| (username) => {
  #|   const db = JSON.parse(localStorage.getItem('serde_users') || '{}');
  #|   return !!db[username];
  #| }

extern "js" fn verify_user(username : String, key : String) -> Bool =
  #| (username, key) => {
  #|   const db = JSON.parse(localStorage.getItem('serde_users') || '{}');
  #|   return db[username] === key;
  #| }

extern "js" fn register_user(username : String, key : String) -> Bool =
  #| (username, key) => {
  #|   const db = JSON.parse(localStorage.getItem('serde_users') || '{}');
  #|   if (db[username]) return false;
  #|   db[username] = key;
  #|   localStorage.setItem('serde_users', JSON.stringify(db));
  #|   return true;
  #| }

// JS helper to show toast notifications
extern "js" fn show_toast(message : String, is_error : Bool) -> Unit = 
  #| (message, isError) => {
  #|   const toast = document.createElement('div');
  #|   toast.className = 'toast-notification';
  #|   if (isError) {
  #|     toast.style.borderColor = '#ff5c8d';
  #|     toast.style.boxShadow = '0 0 15px rgba(255, 92, 141, 0.2)';
  #|   }
  #|   const color = isError ? '#ff5c8d' : '#45fadc';
  #|   toast.innerHTML = `<span class="user-pulse" style="background-color: ${color}; box-shadow: 0 0 8px ${color}"></span> ${message}`;
  #|   document.body.appendChild(toast);
  #|   setTimeout(() => {
  #|     toast.remove();
  #|   }, 2300);
  #| }

// JS helper to syntax highlight JSON string
extern "js" fn syntax_highlight(json_str : String) -> String =
  #| (jsonStr) => {
  #|   try {
  #|     const obj = JSON.parse(jsonStr);
  #|     const pretty = JSON.stringify(obj, null, 2);
  #|     return pretty.replace(/("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)/g, function (match) {
  #|       let cls = 'num';
  #|       if (/^"/.test(match)) {
  #|         if (/:$/.test(match)) {
  #|           return `<span style="color:#e0e2e8">${match}</span>`;
  #|         } else {
  #|           cls = 'str';
  #|         }
  #|       } else if (/true|false/.test(match)) {
  #|         cls = 'bool';
  #|       } else if (/null/.test(match)) {
  #|         cls = 'bool';
  #|       }
  #|       return `<span class="${cls}">${match}</span>`;
  #|     });
  #|   } catch (e) {
  #|     return jsonStr;
  #|   }
  #| }

extern "js" fn try_format_json_js(json : String) -> String =
  #| (json) => {
  #|   try {
  #|     const obj = JSON.parse(json);
  #|     return JSON.stringify(obj, null, 2);
  #|   } catch (e) {
  #|     return "__ERROR__";
  #|   }
  #| }

fn try_format_json(val : String) -> Result[String, Unit] {
  let res = try_format_json_js(val)
  if res == "__ERROR__" {
    Err(())
  } else {
    Ok(res)
  }
}

fn transition_to_dashboard(username : String) -> Unit {
  set_session_storage("active_node", username)
  set_element_text("user-display-name", "NODE: " + to_upper_case(username))
  
  add_class("auth-container", "fade-out")
  run_after_delay(500, fn() {
    add_class("auth-container", "hidden")
    remove_class("playground-container", "hidden")
    add_class("playground-container", "fade-in")
    show_toast("Welcome back, agent " + username, false)
  })
}

fn handle_disconnect() -> Unit {
  remove_session_storage("active_node")
  add_class("playground-container", "fade-out")
  run_after_delay(500, fn() {
    add_class("playground-container", "hidden")
    remove_class("playground-container", "fade-out")
    remove_class("playground-container", "fade-in")
    
    // Clear credentials
    set_element_value("login-username", "")
    set_element_value("login-password", "")
    set_element_value("register-username", "")
    set_element_value("register-password", "")
    set_element_value("register-confirm-password", "")
    
    remove_class("auth-container", "hidden")
    remove_class("auth-container", "fade-out")
    add_class("auth-container", "fade-in")
    show_toast("Terminal node disconnected", false)
  })
}

pub fn setup_frontend() -> Unit {
  // Check active session on page load
  let active_node = get_session_storage("active_node")
  if active_node != "" {
    add_class("auth-container", "hidden")
    remove_class("playground-container", "hidden")
    set_element_text("user-display-name", "NODE: " + to_upper_case(active_node))
  }
  
  // Go to Register link
  add_click_listener("go-to-register", fn() {
    add_class("login-form", "hidden")
    remove_class("register-form", "hidden")
    set_element_text("auth-title", "Initialize Node")
    set_element_text("auth-status", "Registration Portal")
    set_element_text("register-error", "")
    set_element_display("register-error", "none")
  })
  
  // Go to Login link
  add_click_listener("go-to-login", fn() {
    add_class("register-form", "hidden")
    remove_class("login-form", "hidden")
    set_element_text("auth-title", "System Access")
    set_element_text("auth-status", "Security Portal")
    set_element_text("login-error", "")
    set_element_display("login-error", "none")
  })
  
  // Disconnect button
  add_click_listener("btn-disconnect", handle_disconnect)
  
  // Login form submit
  add_submit_listener("login-form", fn() {
    set_element_text("login-error", "")
    set_element_display("login-error", "none")
    
    let username = get_element_value("login-username")
    let key = get_element_value("login-password")
    
    if username == "" || key == "" {
      set_element_text("login-error", "All authentication fields are required.")
      set_element_display("login-error", "block")
      return
    }
    
    if !user_exists(username) {
      set_element_text("login-error", "Node Alias not found. Register a new terminal node.")
      set_element_display("login-error", "block")
      return
    }
    
    if !verify_user(username, key) {
      set_element_text("login-error", "Decryption failed. Invalid Security Key.")
      set_element_display("login-error", "block")
      return
    }
    
    // Simulate loading state
    let orig = get_element_html("btn-login-submit")
    set_element_html("btn-login-submit", "<span class=\"dot\" style=\"animation: pulse 1s infinite;\"></span> Authenticating...")
    disable_button("btn-login-submit", true)
    
    run_after_delay(1200, fn() {
      set_element_html("btn-login-submit", orig)
      disable_button("btn-login-submit", false)
      transition_to_dashboard(username)
    })
  })
  
  // Register form submit
  add_submit_listener("register-form", fn() {
    set_element_text("register-error", "")
    set_element_display("register-error", "none")
    
    let username = get_element_value("register-username")
    let key = get_element_value("register-password")
    let confirm = get_element_value("register-confirm-password")
    
    if username == "" || key == "" || confirm == "" {
      set_element_text("register-error", "All registration fields are required.")
      set_element_display("register-error", "block")
      return
    }
    
    if key.length() < 6 {
      set_element_text("register-error", "Security Key must be at least 6 characters.")
      set_element_display("register-error", "block")
      return
    }
    
    if key != confirm {
      set_element_text("register-error", "Security Keys do not match.")
      set_element_display("register-error", "block")
      return
    }
    
    if user_exists(username) {
      set_element_text("register-error", "Node Alias already registered.")
      set_element_display("register-error", "block")
      return
    }
    
    let ok = register_user(username, key)
    if !ok {
      set_element_text("register-error", "Registration failed.")
      set_element_display("register-error", "block")
      return
    }
    
    let orig = get_element_html("btn-register-submit")
    set_element_html("btn-register-submit", "<span class=\"dot\" style=\"animation: pulse 1s infinite;\"></span> Initializing Node...")
    disable_button("btn-register-submit", true)
    
    run_after_delay(1200, fn() {
      set_element_html("btn-register-submit", orig)
      disable_button("btn-register-submit", false)
      transition_to_dashboard(username)
    })
  })
  
  // Format JSON Button
  add_click_listener("btn-format", fn() {
    let val = get_element_value("json-input")
    if val == "" {
      show_toast("JSON Input is empty", true)
      return
    }
    match try_format_json(val) {
      Ok(formatted) => {
        set_element_value("json-input", formatted)
        show_toast("JSON formatted successfully", false)
      }
      Err(_) => {
        show_toast("Invalid JSON syntax structure", true)
      }
    }
  })
  
  // Copy output button
  add_click_listener("btn-copy", fn() {
    let text = get_element_text("json-output")
    if text == "" || text == "// Waiting for input..." {
      show_toast("No output generated yet", true)
      return
    }
    copy_to_clipboard(text)
    show_toast("JSON Output copied to clipboard", false)
  })
  
  // Parse Button
  add_click_listener("btn-parse", fn() {
    let inputStr = get_element_value("json-input")
    set_element_text("status-text", "Parsing...")
    
    match from_json(inputStr) {
      Ok(val) => {
        let json_str = to_json(val)
        set_element_html("json-output", syntax_highlight(json_str))
        set_element_text("status-text", "Serialization Complete")
        set_element_text_color("status-text", "#45fadc")
      }
      Err(e) => {
        let err_str = "ERROR: " + e
        set_element_html("json-output", err_str)
        set_element_text("status-text", "Wasm Error")
        set_element_text_color("status-text", "#ff5c8d")
      }
    }
  })
  
  // Demo Primitive Button
  add_click_listener("btn-primitive", fn() {
    set_element_text("status-text", "Serializing...")
    let val = Serialize::to_value("Hello, MoonSerde Wasm Playground!")
    let json_str = to_json(val)
    set_element_html("json-output", syntax_highlight(json_str))
    set_element_text("status-text", "Serialization Complete")
    set_element_text_color("status-text", "#45fadc")
  })
  
  // Demo Nested Button
  add_click_listener("btn-nested", fn() {
    set_element_text("status-text", "Serializing...")
    
    let map = Map::new()
    map.set("version", StringVal("1.0"))
    map.set("data", StringVal("metrics"))
    
    let arr = ArrayVal([DoubleVal(1.5), DoubleVal(2.5), DoubleVal(3.14159)])
    
    let root = Map::new()
    root.set("metadata", ObjectVal(map))
    root.set("points", arr)
    root.set("is_valid", BoolVal(true))
    
    let val = ObjectVal(root)
    let json_str = to_json(val)
    set_element_html("json-output", syntax_highlight(json_str))
    set_element_text("status-text", "Serialization Complete")
    set_element_text_color("status-text", "#45fadc")
  })
  
  // Set status ready
  set_element_text("status-text", "Wasm Ready")
}

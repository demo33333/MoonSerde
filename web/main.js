(() => {
  function _M0DTPC16result6ResultGRP38username9moonserde3src5ValuesE3Err(param0) {
    this._0 = param0;
  }
  _M0DTPC16result6ResultGRP38username9moonserde3src5ValuesE3Err.prototype.$tag = 0;
  function _M0DTPC16result6ResultGRP38username9moonserde3src5ValuesE2Ok(param0) {
    this._0 = param0;
  }
  _M0DTPC16result6ResultGRP38username9moonserde3src5ValuesE2Ok.prototype.$tag = 1;
  function _M0DTP38username9moonserde3src5Value4Null() {}
  _M0DTP38username9moonserde3src5Value4Null.prototype.$tag = 0;
  const _M0DTP38username9moonserde3src5Value4Null__ = new _M0DTP38username9moonserde3src5Value4Null();
  function _M0DTP38username9moonserde3src5Value7BoolVal(param0) {
    this._0 = param0;
  }
  _M0DTP38username9moonserde3src5Value7BoolVal.prototype.$tag = 1;
  function _M0DTP38username9moonserde3src5Value6IntVal(param0) {
    this._0 = param0;
  }
  _M0DTP38username9moonserde3src5Value6IntVal.prototype.$tag = 2;
  function _M0DTP38username9moonserde3src5Value9DoubleVal(param0) {
    this._0 = param0;
  }
  _M0DTP38username9moonserde3src5Value9DoubleVal.prototype.$tag = 3;
  function _M0DTP38username9moonserde3src5Value9StringVal(param0) {
    this._0 = param0;
  }
  _M0DTP38username9moonserde3src5Value9StringVal.prototype.$tag = 4;
  function _M0DTP38username9moonserde3src5Value8ArrayVal(param0) {
    this._0 = param0;
  }
  _M0DTP38username9moonserde3src5Value8ArrayVal.prototype.$tag = 5;
  function _M0DTP38username9moonserde3src5Value9ObjectVal(param0) {
    this._0 = param0;
  }
  _M0DTP38username9moonserde3src5Value9ObjectVal.prototype.$tag = 6;
  function _M0TPB13StringBuilder(param0) {
    this.val = param0;
  }
  const _M0FPB12random__seed = () => {
    if (globalThis.crypto?.getRandomValues) {
      const array = new Uint32Array(1);
      globalThis.crypto.getRandomValues(array);
      return array[0] | 0; // Convert to signed 32
    } else {
      return Math.floor(Math.random() * 0x100000000) | 0; // Fallback to Math.random
    }
  };
  const _M0FPB19int__to__string__js = (x, radix) => {
    return x.toString(radix);
  };
  const _M0MPB7JSArray4push = (arr, val) => { arr.push(val); };
  class $PanicError extends Error {}
  function $panic() {
    throw new $PanicError();
  }
  function $make_array_len_and_init(a, b) {
    const arr = new Array(a);
    arr.fill(b);
    return arr;
  }
  function _M0TPB3MapGsRP38username9moonserde3src5ValueE(param0, param1, param2, param3, param4, param5, param6) {
    this.entries = param0;
    this.size = param1;
    this.capacity = param2;
    this.capacity_mask = param3;
    this.grow_at = param4;
    this.head = param5;
    this.tail = param6;
  }
  function $bound_check(arr, index) {
    if (index < 0 || index >= arr.length) throw new Error("Index out of bounds");
  }
  function _M0TPB5EntryGsRP38username9moonserde3src5ValueE(param0, param1, param2, param3, param4, param5) {
    this.prev = param0;
    this.next = param1;
    this.psl = param2;
    this.hash = param3;
    this.key = param4;
    this.value = param5;
  }
  function _M0TPB8MutLocalGsE(param0) {
    this.val = param0;
  }
  function _M0TPB8MutLocalGbE(param0) {
    this.val = param0;
  }
  function _M0DTPC16result6ResultGusE3Err(param0) {
    this._0 = param0;
  }
  _M0DTPC16result6ResultGusE3Err.prototype.$tag = 0;
  function _M0DTPC16result6ResultGusE2Ok(param0) {
    this._0 = param0;
  }
  _M0DTPC16result6ResultGusE2Ok.prototype.$tag = 1;
  function _M0DTPC16result6ResultGdsE3Err(param0) {
    this._0 = param0;
  }
  _M0DTPC16result6ResultGdsE3Err.prototype.$tag = 0;
  function _M0DTPC16result6ResultGdsE2Ok(param0) {
    this._0 = param0;
  }
  _M0DTPC16result6ResultGdsE2Ok.prototype.$tag = 1;
  function _M0DTPC16result6ResultGssE3Err(param0) {
    this._0 = param0;
  }
  _M0DTPC16result6ResultGssE3Err.prototype.$tag = 0;
  function _M0DTPC16result6ResultGssE2Ok(param0) {
    this._0 = param0;
  }
  _M0DTPC16result6ResultGssE2Ok.prototype.$tag = 1;
  function _M0TP38username9moonserde3src6Parser(param0, param1) {
    this.str = param0;
    this.pos = param1;
  }
  const _M0FP38username9moonserde3src10add__class = (id, cls) => { const el = document.getElementById(id); if (el) el.classList.add(cls); };
  const _M0FP38username9moonserde3src20add__click__listener = (id, cb) => { const el = document.getElementById(id); if (el) el.addEventListener('click', (e) => { e.preventDefault(); cb(); }); };
  const _M0FP38username9moonserde3src21add__submit__listener = (id, cb) => { const el = document.getElementById(id); if (el) el.addEventListener('submit', (e) => { e.preventDefault(); cb(); }); };
  const _M0FP38username9moonserde3src19copy__to__clipboard = (text) => { navigator.clipboard.writeText(text); };
  const _M0FP38username9moonserde3src15disable__button = (id, disabled) => { const el = document.getElementById(id); if (el) el.disabled = disabled; };
  const _M0FP38username9moonserde3src18get__element__html = (id) => { const el = document.getElementById(id); return el ? el.innerHTML : ''; };
  const _M0FP38username9moonserde3src18get__element__text = (id) => { const el = document.getElementById(id); return el ? el.innerText : ''; };
  const _M0FP38username9moonserde3src19get__element__value = (id) => { const el = document.getElementById(id); return el ? el.value : ''; };
  const _M0FP38username9moonserde3src21get__session__storage = (key) => sessionStorage.getItem(key) || '';
  const _M0FP38username9moonserde3src13remove__class = (id, cls) => { const el = document.getElementById(id); if (el) el.classList.remove(cls); };
  const _M0FP38username9moonserde3src24remove__session__storage = (key) => sessionStorage.removeItem(key);
  const _M0FP38username9moonserde3src17run__after__delay = (ms, cb) => setTimeout(cb, ms);
  const _M0FP38username9moonserde3src19set__element__value = (id, val) => { const el = document.getElementById(id); if (el) el.value = val; };
  const _M0FP38username9moonserde3src11show__toast = (message, isError) => {
     const toast = document.createElement('div');
     toast.className = 'toast-notification';
     if (isError) {
       toast.style.borderColor = '#ff5c8d';
       toast.style.boxShadow = '0 0 15px rgba(255, 92, 141, 0.2)';
     }
     const color = isError ? '#ff5c8d' : '#45fadc';
     toast.innerHTML = `<span class="user-pulse" style="background-color: ${color}; box-shadow: 0 0 8px ${color}"></span> ${message}`;
     document.body.appendChild(toast);
     setTimeout(() => {
       toast.remove();
     }, 2300);
   };
  const _M0FP38username9moonserde3src14register__user = (username, key) => {
     const db = JSON.parse(localStorage.getItem('serde_users') || '{}');
     if (db[username]) return false;
     db[username] = key;
     localStorage.setItem('serde_users', JSON.stringify(db));
     return true;
   };
  const _M0FP38username9moonserde3src21set__element__display = (id, d) => { const el = document.getElementById(id); if (el) el.style.display = d; };
  const _M0FP38username9moonserde3src18set__element__html = (id, html) => { const el = document.getElementById(id); if (el) el.innerHTML = html; };
  const _M0FP38username9moonserde3src18set__element__text = (id, txt) => { const el = document.getElementById(id); if (el) el.innerText = txt; };
  const _M0FP38username9moonserde3src25set__element__text__color = (id, c) => { const el = document.getElementById(id); if (el) el.style.color = c; };
  const _M0FP38username9moonserde3src17syntax__highlight = (jsonStr) => {
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
       return jsonStr;
     }
   };
  const _M0FP38username9moonserde3src15to__upper__case = (s) => s.toUpperCase();
  const _M0FP38username9moonserde3src21set__session__storage = (key, val) => sessionStorage.setItem(key, val);
  const _M0FP38username9moonserde3src21try__format__json__js = (json) => {
     try {
       const obj = JSON.parse(json);
       return JSON.stringify(obj, null, 2);
     } catch (e) {
       return "__ERROR__";
     }
   };
  function _M0DTPC16result6ResultGsuE3Err(param0) {
    this._0 = param0;
  }
  _M0DTPC16result6ResultGsuE3Err.prototype.$tag = 0;
  function _M0DTPC16result6ResultGsuE2Ok(param0) {
    this._0 = param0;
  }
  _M0DTPC16result6ResultGsuE2Ok.prototype.$tag = 1;
  const _M0FP38username9moonserde3src12user__exists = (username) => {
     const db = JSON.parse(localStorage.getItem('serde_users') || '{}');
     return !!db[username];
   };
  const _M0FP38username9moonserde3src12verify__user = (username, key) => {
     const db = JSON.parse(localStorage.getItem('serde_users') || '{}');
     return db[username] === key;
   };
  const _M0FPB4seed = _M0FPB12random__seed();
  const _M0MP38username9moonserde3src6Parser12parse__valueN6constrS550 = new _M0DTPC16result6ResultGRP38username9moonserde3src5ValuesE3Err("Unexpected end of input");
  const _M0MP38username9moonserde3src6Parser12parse__valueN6constrS551 = new _M0DTP38username9moonserde3src5Value7BoolVal(true);
  const _M0MP38username9moonserde3src6Parser12parse__valueN6constrS552 = new _M0DTPC16result6ResultGRP38username9moonserde3src5ValuesE2Ok(_M0MP38username9moonserde3src6Parser12parse__valueN6constrS551);
  const _M0MP38username9moonserde3src6Parser12parse__valueN6constrS553 = new _M0DTP38username9moonserde3src5Value7BoolVal(false);
  const _M0MP38username9moonserde3src6Parser12parse__valueN6constrS554 = new _M0DTPC16result6ResultGRP38username9moonserde3src5ValuesE2Ok(_M0MP38username9moonserde3src6Parser12parse__valueN6constrS553);
  const _M0FP38username9moonserde3src15setup__frontendN6constrS555 = new _M0DTP38username9moonserde3src5Value9StringVal("1.0");
  const _M0FP38username9moonserde3src15setup__frontendN6constrS556 = new _M0DTP38username9moonserde3src5Value9StringVal("metrics");
  const _M0FP38username9moonserde3src15setup__frontendN6constrS557 = new _M0DTP38username9moonserde3src5Value9DoubleVal(1.5);
  const _M0FP38username9moonserde3src15setup__frontendN6constrS558 = new _M0DTP38username9moonserde3src5Value9DoubleVal(2.5);
  const _M0FP38username9moonserde3src15setup__frontendN6constrS559 = new _M0DTP38username9moonserde3src5Value9DoubleVal(3.14159);
  const _M0FP38username9moonserde3src15setup__frontendN6constrS560 = new _M0DTP38username9moonserde3src5Value7BoolVal(true);
  function _M0FPB13consume4__acc(acc, input) {
    const _p = (acc >>> 0) + ((Math.imul(input, -1028477379) | 0) >>> 0) | 0;
    const _p$2 = 17;
    return Math.imul(_p << _p$2 | (_p >>> (32 - _p$2 | 0) | 0), 668265263) | 0;
  }
  function _M0MPB13StringBuilder21StringBuilder_2einner(size_hint) {
    return new _M0TPB13StringBuilder("");
  }
  function _M0IPB13StringBuilderPB6Logger11write__char(self, ch) {
    self.val = `${self.val}${String.fromCodePoint(ch)}`;
  }
  function _M0FPB14avalanche__acc(acc) {
    let acc$2 = acc;
    acc$2 = acc$2 ^ (acc$2 >>> 15 | 0);
    acc$2 = Math.imul(acc$2, -2048144777) | 0;
    acc$2 = acc$2 ^ (acc$2 >>> 13 | 0);
    acc$2 = Math.imul(acc$2, -1028477379) | 0;
    acc$2 = acc$2 ^ (acc$2 >>> 16 | 0);
    return acc$2;
  }
  function _M0FPB13finalize__acc(acc) {
    return _M0FPB14avalanche__acc(acc);
  }
  function _M0MPC13int3Int18to__string_2einner(self, radix) {
    return _M0FPB19int__to__string__js(self, radix);
  }
  function _M0MPC15array5Array4pushGRP38username9moonserde3src5ValueE(self, value) {
    _M0MPB7JSArray4push(self, value);
  }
  function _M0IPC14char4CharPB4Show10to__string(self) {
    return String.fromCodePoint(self);
  }
  function _M0MPC13int3Int20next__power__of__two(self) {
    if (self >= 0) {
      if (self <= 1) {
        return 1;
      }
      if (self > 1073741824) {
        return 1073741824;
      }
      return (2147483647 >> (Math.clz32(self - 1 | 0) - 1 | 0)) + 1 | 0;
    } else {
      return $panic();
    }
  }
  function _M0FPB8new__mapGsRP38username9moonserde3src5ValueE(capacity) {
    const capacity$2 = _M0MPC13int3Int20next__power__of__two(capacity);
    const _bind = capacity$2 - 1 | 0;
    const _bind$2 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
    const _bind$3 = $make_array_len_and_init(capacity$2, undefined);
    const _bind$4 = undefined;
    return new _M0TPB3MapGsRP38username9moonserde3src5ValueE(_bind$3, 0, capacity$2, _bind, _bind$2, _bind$4, -1);
  }
  function _M0MPB3Map20add__entry__to__tailGsRP38username9moonserde3src5ValueE(self, idx, entry) {
    const _bind = self.tail;
    if (_bind === -1) {
      self.head = entry;
    } else {
      const _tmp = self.entries;
      $bound_check(_tmp, _bind);
      const _p = _tmp[_bind];
      let _tmp$2;
      if (_p === undefined) {
        _tmp$2 = $panic();
      } else {
        const _p$2 = _p;
        _tmp$2 = _p$2;
      }
      _tmp$2.next = entry;
    }
    self.tail = idx;
    const _tmp = self.entries;
    $bound_check(_tmp, idx);
    _tmp[idx] = entry;
    self.size = self.size + 1 | 0;
  }
  function _M0MPB3Map10set__entryGsRP38username9moonserde3src5ValueE(self, entry, new_idx) {
    const _tmp = self.entries;
    $bound_check(_tmp, new_idx);
    _tmp[new_idx] = entry;
    const _bind = entry.next;
    if (_bind === undefined) {
      self.tail = new_idx;
      return;
    } else {
      const _Some = _bind;
      const _next = _Some;
      _next.prev = new_idx;
      return;
    }
  }
  function _M0MPB3Map10push__awayGsRP38username9moonserde3src5ValueE(self, idx, entry) {
    let _tmp = entry.psl + 1 | 0;
    let _tmp$2 = idx + 1 & self.capacity_mask;
    let _tmp$3 = entry;
    while (true) {
      const psl = _tmp;
      const idx$2 = _tmp$2;
      const entry$2 = _tmp$3;
      const _tmp$4 = self.entries;
      $bound_check(_tmp$4, idx$2);
      const _bind = _tmp$4[idx$2];
      if (_bind === undefined) {
        entry$2.psl = psl;
        _M0MPB3Map10set__entryGsRP38username9moonserde3src5ValueE(self, entry$2, idx$2);
        return;
      } else {
        const _Some = _bind;
        const _curr_entry = _Some;
        if (psl > _curr_entry.psl) {
          entry$2.psl = psl;
          _M0MPB3Map10set__entryGsRP38username9moonserde3src5ValueE(self, entry$2, idx$2);
          _tmp = _curr_entry.psl + 1 | 0;
          _tmp$2 = idx$2 + 1 & self.capacity_mask;
          _tmp$3 = _curr_entry;
          continue;
        } else {
          _tmp = psl + 1 | 0;
          _tmp$2 = idx$2 + 1 & self.capacity_mask;
          continue;
        }
      }
    }
  }
  function _M0MPB3Map20rehash__place__entryGsRP38username9moonserde3src5ValueE(self, outer) {
    const hash = outer.hash;
    let _tmp = 0;
    let _tmp$2 = hash & self.capacity_mask;
    while (true) {
      const psl = _tmp;
      const idx = _tmp$2;
      const _tmp$3 = self.entries;
      $bound_check(_tmp$3, idx);
      const _bind = _tmp$3[idx];
      if (_bind === undefined) {
        outer.psl = psl;
        outer.prev = self.tail;
        _M0MPB3Map20add__entry__to__tailGsRP38username9moonserde3src5ValueE(self, idx, outer);
        return undefined;
      } else {
        const _Some = _bind;
        const _curr = _Some;
        if (psl > _curr.psl) {
          _M0MPB3Map10push__awayGsRP38username9moonserde3src5ValueE(self, idx, _curr);
          outer.psl = psl;
          outer.prev = self.tail;
          _M0MPB3Map20add__entry__to__tailGsRP38username9moonserde3src5ValueE(self, idx, outer);
          return undefined;
        } else {
          _tmp = psl + 1 | 0;
          _tmp$2 = idx + 1 & self.capacity_mask;
          continue;
        }
      }
    }
  }
  function _M0MPB3Map4growGsRP38username9moonserde3src5ValueE(self) {
    const old_head = self.head;
    const new_capacity = self.capacity << 1;
    self.entries = $make_array_len_and_init(new_capacity, undefined);
    self.capacity = new_capacity;
    self.capacity_mask = new_capacity - 1 | 0;
    const _p = self.capacity;
    self.grow_at = (Math.imul(_p, 13) | 0) / 16 | 0;
    self.size = 0;
    self.head = undefined;
    self.tail = -1;
    let _tmp = old_head;
    while (true) {
      const x = _tmp;
      if (x === undefined) {
        return;
      } else {
        const _Some = x;
        const _e = _Some;
        const next_in_chain = _e.next;
        _e.next = undefined;
        _M0MPB3Map20rehash__place__entryGsRP38username9moonserde3src5ValueE(self, _e);
        _tmp = next_in_chain;
        continue;
      }
    }
  }
  function _M0MPB3Map15set__with__hashGsRP38username9moonserde3src5ValueE(self, key, value, hash) {
    let _tmp = 0;
    let _tmp$2 = hash & self.capacity_mask;
    while (true) {
      const psl = _tmp;
      const idx = _tmp$2;
      const _tmp$3 = self.entries;
      $bound_check(_tmp$3, idx);
      const _bind = _tmp$3[idx];
      if (_bind === undefined) {
        if (self.size >= self.grow_at) {
          _M0MPB3Map4growGsRP38username9moonserde3src5ValueE(self);
          _tmp = 0;
          _tmp$2 = hash & self.capacity_mask;
          continue;
        }
        const _bind$2 = self.tail;
        const _bind$3 = undefined;
        const entry = new _M0TPB5EntryGsRP38username9moonserde3src5ValueE(_bind$2, _bind$3, psl, hash, key, value);
        _M0MPB3Map20add__entry__to__tailGsRP38username9moonserde3src5ValueE(self, idx, entry);
        return undefined;
      } else {
        const _Some = _bind;
        const _curr_entry = _Some;
        if (_curr_entry.hash === hash && _curr_entry.key === key) {
          _curr_entry.value = value;
          return undefined;
        }
        if (psl > _curr_entry.psl) {
          if (self.size >= self.grow_at) {
            _M0MPB3Map4growGsRP38username9moonserde3src5ValueE(self);
            _tmp = 0;
            _tmp$2 = hash & self.capacity_mask;
            continue;
          }
          _M0MPB3Map10push__awayGsRP38username9moonserde3src5ValueE(self, idx, _curr_entry);
          const _bind$2 = self.tail;
          const _bind$3 = undefined;
          const entry = new _M0TPB5EntryGsRP38username9moonserde3src5ValueE(_bind$2, _bind$3, psl, hash, key, value);
          _M0MPB3Map20add__entry__to__tailGsRP38username9moonserde3src5ValueE(self, idx, entry);
          return undefined;
        }
        _tmp = psl + 1 | 0;
        _tmp$2 = idx + 1 & self.capacity_mask;
        continue;
      }
    }
  }
  function _M0MPB3Map3setGsRP38username9moonserde3src5ValueE(self, key, value) {
    _M0MPB3Map15set__with__hashGsRP38username9moonserde3src5ValueE(self, key, value, _M0IPC16string6StringPB4Hash4hash(key));
  }
  function _M0IPC16string6StringPB4Hash4hash(self) {
    let acc = (_M0FPB4seed >>> 0) + (374761393 >>> 0) | 0;
    const _bind = self.length;
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < _bind) {
        acc = (acc >>> 0) + (4 >>> 0) | 0;
        const v = self.charCodeAt(i);
        acc = _M0FPB13consume4__acc(acc, v);
        _tmp = i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    return _M0FPB13finalize__acc(acc);
  }
  function _M0MPB3Map11new_2einnerGsRP38username9moonserde3src5ValueE(capacity) {
    return _M0FPB8new__mapGsRP38username9moonserde3src5ValueE(capacity);
  }
  function _M0MPB3Map3newGsRP38username9moonserde3src5ValueE(capacity$46$opt) {
    let capacity;
    if (capacity$46$opt === undefined) {
      capacity = 8;
    } else {
      const _Some = capacity$46$opt;
      capacity = _Some;
    }
    return _M0MPB3Map11new_2einnerGsRP38username9moonserde3src5ValueE(capacity);
  }
  function _M0MPC15array5Array2atGRP38username9moonserde3src5ValueE(self, index) {
    const len = self.length;
    return index >= 0 && index < len ? self[index] : $panic();
  }
  function _M0FP38username9moonserde3src8to__json(v) {
    switch (v.$tag) {
      case 0: {
        return "null";
      }
      case 1: {
        const _BoolVal = v;
        const _b = _BoolVal._0;
        return _b ? "true" : "false";
      }
      case 2: {
        const _IntVal = v;
        const _i = _IntVal._0;
        return _M0MPC13int3Int18to__string_2einner(_i, 10);
      }
      case 3: {
        const _DoubleVal = v;
        const _d = _DoubleVal._0;
        return String(_d);
      }
      case 4: {
        const _StringVal = v;
        const _s = _StringVal._0;
        return `\\u0022${_s}\\u0022`;
      }
      case 5: {
        const _ArrayVal = v;
        const _arr = _ArrayVal._0;
        let res = "[";
        let _tmp = 0;
        while (true) {
          const i = _tmp;
          if (i < _arr.length) {
            if (i > 0) {
              res = `${res},`;
            }
            res = `${res}${_M0FP38username9moonserde3src8to__json(_M0MPC15array5Array2atGRP38username9moonserde3src5ValueE(_arr, i))}`;
            _tmp = i + 1 | 0;
            continue;
          } else {
            break;
          }
        }
        return `${res}]`;
      }
      default: {
        const _ObjectVal = v;
        const _map = _ObjectVal._0;
        const res$2 = new _M0TPB8MutLocalGsE("{");
        const first = new _M0TPB8MutLocalGbE(true);
        let _tmp$2 = _map.head;
        while (true) {
          const _p = _tmp$2;
          if (_p === undefined) {
            break;
          } else {
            const _p$2 = _p;
            const _p$3 = _p$2;
            const _p$4 = _p$3.key;
            const _p$5 = _p$3.value;
            const _p$6 = _p$3.next;
            if (!first.val) {
              res$2.val = `${res$2.val},`;
            }
            first.val = false;
            res$2.val = `${res$2.val}\\u0022${_p$4}\\u0022:${_M0FP38username9moonserde3src8to__json(_p$5)}`;
            _tmp$2 = _p$6;
            continue;
          }
        }
        return `${res$2.val}}`;
      }
    }
  }
  function _M0MP38username9moonserde3src6Parser11match__char(self, c) {
    let _tmp;
    if (self.pos < self.str.length) {
      const _tmp$2 = self.str;
      const _tmp$3 = self.pos;
      $bound_check(_tmp$2, _tmp$3);
      _tmp = _tmp$2.charCodeAt(_tmp$3) === c;
    } else {
      _tmp = false;
    }
    if (_tmp) {
      self.pos = self.pos + 1 | 0;
      return true;
    } else {
      return false;
    }
  }
  function _M0MP38username9moonserde3src6Parser12expect__char(self, c) {
    return _M0MP38username9moonserde3src6Parser11match__char(self, c) ? new _M0DTPC16result6ResultGusE2Ok(undefined) : new _M0DTPC16result6ResultGusE3Err(`Expected ${_M0IPC14char4CharPB4Show10to__string(c)} at pos ${_M0MPC13int3Int18to__string_2einner(self.pos, 10)}`);
  }
  function _M0MP38username9moonserde3src6Parser13parse__number(self) {
    let val = 0;
    let sign = 1;
    let _tmp;
    if (self.pos < self.str.length) {
      const _tmp$2 = self.str;
      const _tmp$3 = self.pos;
      $bound_check(_tmp$2, _tmp$3);
      _tmp = _tmp$2.charCodeAt(_tmp$3) === 45;
    } else {
      _tmp = false;
    }
    if (_tmp) {
      sign = -1;
      self.pos = self.pos + 1 | 0;
    }
    while (true) {
      if (self.pos < self.str.length) {
        const _tmp$2 = self.str;
        const _tmp$3 = self.pos;
        $bound_check(_tmp$2, _tmp$3);
        const c = _tmp$2.charCodeAt(_tmp$3);
        if (c >= 48 && c <= 57) {
          val = val * 10 + ((c - 48 | 0) + 0);
          self.pos = self.pos + 1 | 0;
        } else {
          break;
        }
        continue;
      } else {
        break;
      }
    }
    while (true) {
      if (self.pos < self.str.length) {
        const _tmp$2 = self.str;
        const _tmp$3 = self.pos;
        $bound_check(_tmp$2, _tmp$3);
        const c = _tmp$2.charCodeAt(_tmp$3);
        if (c === 46 || c >= 48 && c <= 57) {
          self.pos = self.pos + 1 | 0;
        } else {
          break;
        }
        continue;
      } else {
        break;
      }
    }
    return new _M0DTPC16result6ResultGdsE2Ok(val * sign);
  }
  function _M0MP38username9moonserde3src6Parser13parse__string(self) {
    const _bind = _M0MP38username9moonserde3src6Parser12expect__char(self, 34);
    if (_bind.$tag === 0) {
      const _Err = _bind;
      const _e = _Err._0;
      return new _M0DTPC16result6ResultGssE3Err(_e);
    }
    const b = _M0MPB13StringBuilder21StringBuilder_2einner(0);
    while (true) {
      if (self.pos < self.str.length) {
        const _tmp = self.str;
        const _tmp$2 = self.pos;
        $bound_check(_tmp, _tmp$2);
        const c = _tmp.charCodeAt(_tmp$2);
        if (c === 34) {
          self.pos = self.pos + 1 | 0;
          break;
        } else {
          if (c === 92) {
            self.pos = self.pos + 1 | 0;
            if (self.pos < self.str.length) {
              const _tmp$3 = self.str;
              const _tmp$4 = self.pos;
              $bound_check(_tmp$3, _tmp$4);
              const esc = _tmp$3.charCodeAt(_tmp$4);
              if (esc === 110) {
                _M0IPB13StringBuilderPB6Logger11write__char(b, 10);
              } else {
                if (esc === 34) {
                  _M0IPB13StringBuilderPB6Logger11write__char(b, 34);
                } else {
                  if (esc === 92) {
                    _M0IPB13StringBuilderPB6Logger11write__char(b, 92);
                  } else {
                    _M0IPB13StringBuilderPB6Logger11write__char(b, esc);
                  }
                }
              }
              self.pos = self.pos + 1 | 0;
            }
          } else {
            _M0IPB13StringBuilderPB6Logger11write__char(b, c);
            self.pos = self.pos + 1 | 0;
          }
        }
        continue;
      } else {
        break;
      }
    }
    return new _M0DTPC16result6ResultGssE2Ok(b.val);
  }
  function _M0MP38username9moonserde3src6Parser16skip__whitespace(self) {
    while (true) {
      if (self.pos < self.str.length) {
        const _tmp = self.str;
        const _tmp$2 = self.pos;
        $bound_check(_tmp, _tmp$2);
        const c = _tmp.charCodeAt(_tmp$2);
        if (c === 32 || (c === 10 || (c === 13 || c === 9))) {
          self.pos = self.pos + 1 | 0;
        } else {
          return;
        }
        continue;
      } else {
        return;
      }
    }
  }
  function _M0MP38username9moonserde3src6Parser12parse__value(self) {
    _M0MP38username9moonserde3src6Parser16skip__whitespace(self);
    if (self.pos >= self.str.length) {
      return _M0MP38username9moonserde3src6Parser12parse__valueN6constrS550;
    }
    const _tmp = self.str;
    const _tmp$2 = self.pos;
    $bound_check(_tmp, _tmp$2);
    const c = _tmp.charCodeAt(_tmp$2);
    if (c === 123) {
      const _bind = _M0MP38username9moonserde3src6Parser12expect__char(self, 123);
      if (_bind.$tag === 0) {
        const _Err = _bind;
        const _e = _Err._0;
        return new _M0DTPC16result6ResultGRP38username9moonserde3src5ValuesE3Err(_e);
      }
      _M0MP38username9moonserde3src6Parser16skip__whitespace(self);
      const map = _M0MPB3Map3newGsRP38username9moonserde3src5ValueE(undefined);
      if (_M0MP38username9moonserde3src6Parser11match__char(self, 125)) {
        return new _M0DTPC16result6ResultGRP38username9moonserde3src5ValuesE2Ok(new _M0DTP38username9moonserde3src5Value9ObjectVal(map));
      }
      while (true) {
        _M0MP38username9moonserde3src6Parser16skip__whitespace(self);
        const _bind$2 = _M0MP38username9moonserde3src6Parser13parse__string(self);
        let key;
        if (_bind$2.$tag === 0) {
          const _Err = _bind$2;
          const _e = _Err._0;
          return new _M0DTPC16result6ResultGRP38username9moonserde3src5ValuesE3Err(_e);
        } else {
          const _Ok = _bind$2;
          key = _Ok._0;
        }
        _M0MP38username9moonserde3src6Parser16skip__whitespace(self);
        const _bind$3 = _M0MP38username9moonserde3src6Parser12expect__char(self, 58);
        if (_bind$3.$tag === 0) {
          const _Err = _bind$3;
          const _e = _Err._0;
          return new _M0DTPC16result6ResultGRP38username9moonserde3src5ValuesE3Err(_e);
        }
        const _bind$4 = _M0MP38username9moonserde3src6Parser12parse__value(self);
        let val;
        if (_bind$4.$tag === 0) {
          const _Err = _bind$4;
          const _e = _Err._0;
          return new _M0DTPC16result6ResultGRP38username9moonserde3src5ValuesE3Err(_e);
        } else {
          const _Ok = _bind$4;
          val = _Ok._0;
        }
        _M0MPB3Map3setGsRP38username9moonserde3src5ValueE(map, key, val);
        _M0MP38username9moonserde3src6Parser16skip__whitespace(self);
        if (_M0MP38username9moonserde3src6Parser11match__char(self, 125)) {
          break;
        }
        const _bind$5 = _M0MP38username9moonserde3src6Parser12expect__char(self, 44);
        if (_bind$5.$tag === 0) {
          const _Err = _bind$5;
          const _e = _Err._0;
          return new _M0DTPC16result6ResultGRP38username9moonserde3src5ValuesE3Err(_e);
        }
        continue;
      }
      return new _M0DTPC16result6ResultGRP38username9moonserde3src5ValuesE2Ok(new _M0DTP38username9moonserde3src5Value9ObjectVal(map));
    } else {
      if (c === 91) {
        const _bind = _M0MP38username9moonserde3src6Parser12expect__char(self, 91);
        if (_bind.$tag === 0) {
          const _Err = _bind;
          const _e = _Err._0;
          return new _M0DTPC16result6ResultGRP38username9moonserde3src5ValuesE3Err(_e);
        }
        _M0MP38username9moonserde3src6Parser16skip__whitespace(self);
        const arr = [];
        if (_M0MP38username9moonserde3src6Parser11match__char(self, 93)) {
          return new _M0DTPC16result6ResultGRP38username9moonserde3src5ValuesE2Ok(new _M0DTP38username9moonserde3src5Value8ArrayVal(arr));
        }
        while (true) {
          const _bind$2 = _M0MP38username9moonserde3src6Parser12parse__value(self);
          let val;
          if (_bind$2.$tag === 0) {
            const _Err = _bind$2;
            const _e = _Err._0;
            return new _M0DTPC16result6ResultGRP38username9moonserde3src5ValuesE3Err(_e);
          } else {
            const _Ok = _bind$2;
            val = _Ok._0;
          }
          _M0MPC15array5Array4pushGRP38username9moonserde3src5ValueE(arr, val);
          _M0MP38username9moonserde3src6Parser16skip__whitespace(self);
          if (_M0MP38username9moonserde3src6Parser11match__char(self, 93)) {
            break;
          }
          const _bind$3 = _M0MP38username9moonserde3src6Parser12expect__char(self, 44);
          if (_bind$3.$tag === 0) {
            const _Err = _bind$3;
            const _e = _Err._0;
            return new _M0DTPC16result6ResultGRP38username9moonserde3src5ValuesE3Err(_e);
          }
          continue;
        }
        return new _M0DTPC16result6ResultGRP38username9moonserde3src5ValuesE2Ok(new _M0DTP38username9moonserde3src5Value8ArrayVal(arr));
      } else {
        if (c === 34) {
          const _bind = _M0MP38username9moonserde3src6Parser13parse__string(self);
          let s;
          if (_bind.$tag === 0) {
            const _Err = _bind;
            const _e = _Err._0;
            return new _M0DTPC16result6ResultGRP38username9moonserde3src5ValuesE3Err(_e);
          } else {
            const _Ok = _bind;
            s = _Ok._0;
          }
          return new _M0DTPC16result6ResultGRP38username9moonserde3src5ValuesE2Ok(new _M0DTP38username9moonserde3src5Value9StringVal(s));
        } else {
          if (c === 116) {
            const _bind = _M0MP38username9moonserde3src6Parser12expect__char(self, 116);
            if (_bind.$tag === 0) {
              const _Err = _bind;
              const _e = _Err._0;
              return new _M0DTPC16result6ResultGRP38username9moonserde3src5ValuesE3Err(_e);
            }
            const _bind$2 = _M0MP38username9moonserde3src6Parser12expect__char(self, 114);
            if (_bind$2.$tag === 0) {
              const _Err = _bind$2;
              const _e = _Err._0;
              return new _M0DTPC16result6ResultGRP38username9moonserde3src5ValuesE3Err(_e);
            }
            const _bind$3 = _M0MP38username9moonserde3src6Parser12expect__char(self, 117);
            if (_bind$3.$tag === 0) {
              const _Err = _bind$3;
              const _e = _Err._0;
              return new _M0DTPC16result6ResultGRP38username9moonserde3src5ValuesE3Err(_e);
            }
            const _bind$4 = _M0MP38username9moonserde3src6Parser12expect__char(self, 101);
            if (_bind$4.$tag === 0) {
              const _Err = _bind$4;
              const _e = _Err._0;
              return new _M0DTPC16result6ResultGRP38username9moonserde3src5ValuesE3Err(_e);
            }
            return _M0MP38username9moonserde3src6Parser12parse__valueN6constrS552;
          } else {
            if (c === 102) {
              const _bind = _M0MP38username9moonserde3src6Parser12expect__char(self, 102);
              if (_bind.$tag === 0) {
                const _Err = _bind;
                const _e = _Err._0;
                return new _M0DTPC16result6ResultGRP38username9moonserde3src5ValuesE3Err(_e);
              }
              const _bind$2 = _M0MP38username9moonserde3src6Parser12expect__char(self, 97);
              if (_bind$2.$tag === 0) {
                const _Err = _bind$2;
                const _e = _Err._0;
                return new _M0DTPC16result6ResultGRP38username9moonserde3src5ValuesE3Err(_e);
              }
              const _bind$3 = _M0MP38username9moonserde3src6Parser12expect__char(self, 108);
              if (_bind$3.$tag === 0) {
                const _Err = _bind$3;
                const _e = _Err._0;
                return new _M0DTPC16result6ResultGRP38username9moonserde3src5ValuesE3Err(_e);
              }
              const _bind$4 = _M0MP38username9moonserde3src6Parser12expect__char(self, 115);
              if (_bind$4.$tag === 0) {
                const _Err = _bind$4;
                const _e = _Err._0;
                return new _M0DTPC16result6ResultGRP38username9moonserde3src5ValuesE3Err(_e);
              }
              const _bind$5 = _M0MP38username9moonserde3src6Parser12expect__char(self, 101);
              if (_bind$5.$tag === 0) {
                const _Err = _bind$5;
                const _e = _Err._0;
                return new _M0DTPC16result6ResultGRP38username9moonserde3src5ValuesE3Err(_e);
              }
              return _M0MP38username9moonserde3src6Parser12parse__valueN6constrS554;
            } else {
              if (c === 110) {
                const _bind = _M0MP38username9moonserde3src6Parser12expect__char(self, 110);
                if (_bind.$tag === 0) {
                  const _Err = _bind;
                  const _e = _Err._0;
                  return new _M0DTPC16result6ResultGRP38username9moonserde3src5ValuesE3Err(_e);
                }
                const _bind$2 = _M0MP38username9moonserde3src6Parser12expect__char(self, 117);
                if (_bind$2.$tag === 0) {
                  const _Err = _bind$2;
                  const _e = _Err._0;
                  return new _M0DTPC16result6ResultGRP38username9moonserde3src5ValuesE3Err(_e);
                }
                const _bind$3 = _M0MP38username9moonserde3src6Parser12expect__char(self, 108);
                if (_bind$3.$tag === 0) {
                  const _Err = _bind$3;
                  const _e = _Err._0;
                  return new _M0DTPC16result6ResultGRP38username9moonserde3src5ValuesE3Err(_e);
                }
                const _bind$4 = _M0MP38username9moonserde3src6Parser12expect__char(self, 108);
                if (_bind$4.$tag === 0) {
                  const _Err = _bind$4;
                  const _e = _Err._0;
                  return new _M0DTPC16result6ResultGRP38username9moonserde3src5ValuesE3Err(_e);
                }
                return new _M0DTPC16result6ResultGRP38username9moonserde3src5ValuesE2Ok(_M0DTP38username9moonserde3src5Value4Null__);
              } else {
                const _bind = _M0MP38username9moonserde3src6Parser13parse__number(self);
                let d;
                if (_bind.$tag === 0) {
                  const _Err = _bind;
                  const _e = _Err._0;
                  return new _M0DTPC16result6ResultGRP38username9moonserde3src5ValuesE3Err(_e);
                } else {
                  const _Ok = _bind;
                  d = _Ok._0;
                }
                return new _M0DTPC16result6ResultGRP38username9moonserde3src5ValuesE2Ok(new _M0DTP38username9moonserde3src5Value9DoubleVal(d));
              }
            }
          }
        }
      }
    }
  }
  function _M0FP38username9moonserde3src10from__json(str) {
    const p = new _M0TP38username9moonserde3src6Parser(str, 0);
    return _M0MP38username9moonserde3src6Parser12parse__value(p);
  }
  function _M0FP38username9moonserde3src18handle__disconnect() {
    _M0FP38username9moonserde3src24remove__session__storage("active_node");
    _M0FP38username9moonserde3src10add__class("playground-container", "fade-out");
    _M0FP38username9moonserde3src17run__after__delay(500, () => {
      _M0FP38username9moonserde3src10add__class("playground-container", "hidden");
      _M0FP38username9moonserde3src13remove__class("playground-container", "fade-out");
      _M0FP38username9moonserde3src13remove__class("playground-container", "fade-in");
      _M0FP38username9moonserde3src19set__element__value("login-username", "");
      _M0FP38username9moonserde3src19set__element__value("login-password", "");
      _M0FP38username9moonserde3src19set__element__value("register-username", "");
      _M0FP38username9moonserde3src19set__element__value("register-password", "");
      _M0FP38username9moonserde3src19set__element__value("register-confirm-password", "");
      _M0FP38username9moonserde3src13remove__class("auth-container", "hidden");
      _M0FP38username9moonserde3src13remove__class("auth-container", "fade-out");
      _M0FP38username9moonserde3src10add__class("auth-container", "fade-in");
      _M0FP38username9moonserde3src11show__toast("Terminal node disconnected", false);
    });
  }
  function _M0FP38username9moonserde3src25transition__to__dashboard(username) {
    _M0FP38username9moonserde3src21set__session__storage("active_node", username);
    _M0FP38username9moonserde3src18set__element__text("user-display-name", `NODE: ${_M0FP38username9moonserde3src15to__upper__case(username)}`);
    _M0FP38username9moonserde3src10add__class("auth-container", "fade-out");
    _M0FP38username9moonserde3src17run__after__delay(500, () => {
      _M0FP38username9moonserde3src10add__class("auth-container", "hidden");
      _M0FP38username9moonserde3src13remove__class("playground-container", "hidden");
      _M0FP38username9moonserde3src10add__class("playground-container", "fade-in");
      _M0FP38username9moonserde3src11show__toast(`Welcome back, agent ${username}`, false);
    });
  }
  function _M0FP38username9moonserde3src17try__format__json(val) {
    const res = _M0FP38username9moonserde3src21try__format__json__js(val);
    return res === "__ERROR__" ? new _M0DTPC16result6ResultGsuE3Err(undefined) : new _M0DTPC16result6ResultGsuE2Ok(res);
  }
  function _M0FP38username9moonserde3src15setup__frontend() {
    const active_node = _M0FP38username9moonserde3src21get__session__storage("active_node");
    const _p = "";
    if (!(active_node === _p)) {
      _M0FP38username9moonserde3src10add__class("auth-container", "hidden");
      _M0FP38username9moonserde3src13remove__class("playground-container", "hidden");
      _M0FP38username9moonserde3src18set__element__text("user-display-name", `NODE: ${_M0FP38username9moonserde3src15to__upper__case(active_node)}`);
    }
    _M0FP38username9moonserde3src20add__click__listener("go-to-register", () => {
      _M0FP38username9moonserde3src10add__class("login-form", "hidden");
      _M0FP38username9moonserde3src13remove__class("register-form", "hidden");
      _M0FP38username9moonserde3src18set__element__text("auth-title", "Initialize Node");
      _M0FP38username9moonserde3src18set__element__text("auth-status", "Registration Portal");
      _M0FP38username9moonserde3src18set__element__text("register-error", "");
      _M0FP38username9moonserde3src21set__element__display("register-error", "none");
    });
    _M0FP38username9moonserde3src20add__click__listener("go-to-login", () => {
      _M0FP38username9moonserde3src10add__class("register-form", "hidden");
      _M0FP38username9moonserde3src13remove__class("login-form", "hidden");
      _M0FP38username9moonserde3src18set__element__text("auth-title", "System Access");
      _M0FP38username9moonserde3src18set__element__text("auth-status", "Security Portal");
      _M0FP38username9moonserde3src18set__element__text("login-error", "");
      _M0FP38username9moonserde3src21set__element__display("login-error", "none");
    });
    _M0FP38username9moonserde3src20add__click__listener("btn-disconnect", _M0FP38username9moonserde3src18handle__disconnect);
    _M0FP38username9moonserde3src21add__submit__listener("login-form", () => {
      _M0FP38username9moonserde3src18set__element__text("login-error", "");
      _M0FP38username9moonserde3src21set__element__display("login-error", "none");
      const username = _M0FP38username9moonserde3src19get__element__value("login-username");
      const key = _M0FP38username9moonserde3src19get__element__value("login-password");
      if (username === "" || key === "") {
        _M0FP38username9moonserde3src18set__element__text("login-error", "All authentication fields are required.");
        _M0FP38username9moonserde3src21set__element__display("login-error", "block");
        return undefined;
      }
      if (!_M0FP38username9moonserde3src12user__exists(username)) {
        _M0FP38username9moonserde3src18set__element__text("login-error", "Node Alias not found. Register a new terminal node.");
        _M0FP38username9moonserde3src21set__element__display("login-error", "block");
        return undefined;
      }
      if (!_M0FP38username9moonserde3src12verify__user(username, key)) {
        _M0FP38username9moonserde3src18set__element__text("login-error", "Decryption failed. Invalid Security Key.");
        _M0FP38username9moonserde3src21set__element__display("login-error", "block");
        return undefined;
      }
      const orig = _M0FP38username9moonserde3src18get__element__html("btn-login-submit");
      _M0FP38username9moonserde3src18set__element__html("btn-login-submit", "<span class=\"dot\" style=\"animation: pulse 1s infinite;\"></span> Authenticating...");
      _M0FP38username9moonserde3src15disable__button("btn-login-submit", true);
      _M0FP38username9moonserde3src17run__after__delay(1200, () => {
        _M0FP38username9moonserde3src18set__element__html("btn-login-submit", orig);
        _M0FP38username9moonserde3src15disable__button("btn-login-submit", false);
        _M0FP38username9moonserde3src25transition__to__dashboard(username);
      });
    });
    _M0FP38username9moonserde3src21add__submit__listener("register-form", () => {
      _M0FP38username9moonserde3src18set__element__text("register-error", "");
      _M0FP38username9moonserde3src21set__element__display("register-error", "none");
      const username = _M0FP38username9moonserde3src19get__element__value("register-username");
      const key = _M0FP38username9moonserde3src19get__element__value("register-password");
      const confirm = _M0FP38username9moonserde3src19get__element__value("register-confirm-password");
      if (username === "" || (key === "" || confirm === "")) {
        _M0FP38username9moonserde3src18set__element__text("register-error", "All registration fields are required.");
        _M0FP38username9moonserde3src21set__element__display("register-error", "block");
        return undefined;
      }
      if (key.length < 6) {
        _M0FP38username9moonserde3src18set__element__text("register-error", "Security Key must be at least 6 characters.");
        _M0FP38username9moonserde3src21set__element__display("register-error", "block");
        return undefined;
      }
      if (!(key === confirm)) {
        _M0FP38username9moonserde3src18set__element__text("register-error", "Security Keys do not match.");
        _M0FP38username9moonserde3src21set__element__display("register-error", "block");
        return undefined;
      }
      if (_M0FP38username9moonserde3src12user__exists(username)) {
        _M0FP38username9moonserde3src18set__element__text("register-error", "Node Alias already registered.");
        _M0FP38username9moonserde3src21set__element__display("register-error", "block");
        return undefined;
      }
      const ok = _M0FP38username9moonserde3src14register__user(username, key);
      if (!ok) {
        _M0FP38username9moonserde3src18set__element__text("register-error", "Registration failed.");
        _M0FP38username9moonserde3src21set__element__display("register-error", "block");
        return undefined;
      }
      const orig = _M0FP38username9moonserde3src18get__element__html("btn-register-submit");
      _M0FP38username9moonserde3src18set__element__html("btn-register-submit", "<span class=\"dot\" style=\"animation: pulse 1s infinite;\"></span> Initializing Node...");
      _M0FP38username9moonserde3src15disable__button("btn-register-submit", true);
      _M0FP38username9moonserde3src17run__after__delay(1200, () => {
        _M0FP38username9moonserde3src18set__element__html("btn-register-submit", orig);
        _M0FP38username9moonserde3src15disable__button("btn-register-submit", false);
        _M0FP38username9moonserde3src25transition__to__dashboard(username);
      });
    });
    _M0FP38username9moonserde3src20add__click__listener("btn-format", () => {
      const val = _M0FP38username9moonserde3src19get__element__value("json-input");
      if (val === "") {
        _M0FP38username9moonserde3src11show__toast("JSON Input is empty", true);
        return undefined;
      }
      const _bind = _M0FP38username9moonserde3src17try__format__json(val);
      if (_bind.$tag === 1) {
        const _Ok = _bind;
        const _formatted = _Ok._0;
        _M0FP38username9moonserde3src19set__element__value("json-input", _formatted);
        _M0FP38username9moonserde3src11show__toast("JSON formatted successfully", false);
        return;
      } else {
        _M0FP38username9moonserde3src11show__toast("Invalid JSON syntax structure", true);
        return;
      }
    });
    _M0FP38username9moonserde3src20add__click__listener("btn-copy", () => {
      const text = _M0FP38username9moonserde3src18get__element__text("json-output");
      if (text === "" || text === "// Waiting for input...") {
        _M0FP38username9moonserde3src11show__toast("No output generated yet", true);
        return undefined;
      }
      _M0FP38username9moonserde3src19copy__to__clipboard(text);
      _M0FP38username9moonserde3src11show__toast("JSON Output copied to clipboard", false);
    });
    _M0FP38username9moonserde3src20add__click__listener("btn-parse", () => {
      const inputStr = _M0FP38username9moonserde3src19get__element__value("json-input");
      _M0FP38username9moonserde3src18set__element__text("status-text", "Parsing...");
      const _bind = _M0FP38username9moonserde3src10from__json(inputStr);
      if (_bind.$tag === 1) {
        const _Ok = _bind;
        const _val = _Ok._0;
        const json_str = _M0FP38username9moonserde3src8to__json(_val);
        _M0FP38username9moonserde3src18set__element__html("json-output", _M0FP38username9moonserde3src17syntax__highlight(json_str));
        _M0FP38username9moonserde3src18set__element__text("status-text", "Serialization Complete");
        _M0FP38username9moonserde3src25set__element__text__color("status-text", "#45fadc");
        return;
      } else {
        const _Err = _bind;
        const _e = _Err._0;
        const err_str = `ERROR: ${_e}`;
        _M0FP38username9moonserde3src18set__element__html("json-output", err_str);
        _M0FP38username9moonserde3src18set__element__text("status-text", "Wasm Error");
        _M0FP38username9moonserde3src25set__element__text__color("status-text", "#ff5c8d");
        return;
      }
    });
    _M0FP38username9moonserde3src20add__click__listener("btn-primitive", () => {
      _M0FP38username9moonserde3src18set__element__text("status-text", "Serializing...");
      const _p$2 = "Hello, MoonSerde Wasm Playground!";
      const val = new _M0DTP38username9moonserde3src5Value9StringVal(_p$2);
      const json_str = _M0FP38username9moonserde3src8to__json(val);
      _M0FP38username9moonserde3src18set__element__html("json-output", _M0FP38username9moonserde3src17syntax__highlight(json_str));
      _M0FP38username9moonserde3src18set__element__text("status-text", "Serialization Complete");
      _M0FP38username9moonserde3src25set__element__text__color("status-text", "#45fadc");
    });
    _M0FP38username9moonserde3src20add__click__listener("btn-nested", () => {
      _M0FP38username9moonserde3src18set__element__text("status-text", "Serializing...");
      const map = _M0MPB3Map3newGsRP38username9moonserde3src5ValueE(undefined);
      _M0MPB3Map3setGsRP38username9moonserde3src5ValueE(map, "version", _M0FP38username9moonserde3src15setup__frontendN6constrS555);
      _M0MPB3Map3setGsRP38username9moonserde3src5ValueE(map, "data", _M0FP38username9moonserde3src15setup__frontendN6constrS556);
      const arr = new _M0DTP38username9moonserde3src5Value8ArrayVal([_M0FP38username9moonserde3src15setup__frontendN6constrS557, _M0FP38username9moonserde3src15setup__frontendN6constrS558, _M0FP38username9moonserde3src15setup__frontendN6constrS559]);
      const root = _M0MPB3Map3newGsRP38username9moonserde3src5ValueE(undefined);
      _M0MPB3Map3setGsRP38username9moonserde3src5ValueE(root, "metadata", new _M0DTP38username9moonserde3src5Value9ObjectVal(map));
      _M0MPB3Map3setGsRP38username9moonserde3src5ValueE(root, "points", arr);
      _M0MPB3Map3setGsRP38username9moonserde3src5ValueE(root, "is_valid", _M0FP38username9moonserde3src15setup__frontendN6constrS560);
      const val = new _M0DTP38username9moonserde3src5Value9ObjectVal(root);
      const json_str = _M0FP38username9moonserde3src8to__json(val);
      _M0FP38username9moonserde3src18set__element__html("json-output", _M0FP38username9moonserde3src17syntax__highlight(json_str));
      _M0FP38username9moonserde3src18set__element__text("status-text", "Serialization Complete");
      _M0FP38username9moonserde3src25set__element__text__color("status-text", "#45fadc");
    });
    _M0FP38username9moonserde3src18set__element__text("status-text", "Wasm Ready");
  }
  function _M0FP38username9moonserde3src10start__app() {
    _M0FP38username9moonserde3src15setup__frontend();
  }
  (() => {
    _M0FP38username9moonserde3src10start__app();
  })();
})();

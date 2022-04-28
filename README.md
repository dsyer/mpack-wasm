This project compiles [ludocode/mpack](https://github.com/ludocode/mpack) to a linkable WASM library. You can download a release from [GitHub](https://github.com/dsyer/mpack-wasm/releases). Or build it yourself with:

```
$ emmake make
```

Result:

```
$ ls -l mpack-wasm.tgz
-rw-r--r-- 1 dsyer dsyer 111597 Apr 28 08:35 mpack-wasm.tgz
$ tar -tzvf mpack-wasm.tgz 
drwxr-xr-x dsyer/dsyer       0 2022-04-28 08:35 include/
-rw-r--r-- dsyer/dsyer  260861 2022-04-28 08:35 include/mpack.h
drwxr-xr-x dsyer/dsyer       0 2022-04-28 08:35 lib/
-rw-r--r-- dsyer/dsyer  166000 2022-04-28 08:35 lib/libmpack.a
```

## Example Usage

Compile the example like this:

```
$ cd example
$ npm install
$ tar -xzvf ../mpack-wasm.tgz
$ emcc -Os -s EXPORTED_FUNCTIONS="[_xform]" -Wl,--no-entry -I include message.c lib/libmpack.a -o message.wasm
```

Then in Node.js:

```javascript
> var msgpack = await import('@msgpack/msgpack')
  var wasm = await WebAssembly.instantiate(fs.readFileSync('message.wasm'))
  var msg = msgpack.encode({message: "Hello World"})
  new Uint8Array(wasm.instance.exports.memory.buffer, 1, msg.length).set(msg)
> var result = wasm.instance.exports.xform(1,msg.length)
> new Uint32Array(wasm.instance.exports.memory.buffer, result, 2)
Uint32Array(2) [ 5248552, 17 ]
```

The result is a pointer to the output buffer and its length:

```javascript
> wasm.instance.exports.memory.buffer.slice(5248552, 5248552+17)
ArrayBuffer {
  [Uint8Contents]: <81 a3 6d 73 67 ab 48 65 6c 6c 6f 20 57 6f 72 6c 64>,
  byteLength: 17
}
```

We can read that according to the spec as

* 81: a map with one element
* a3: string key of length 3
* 6d 73 67: "msg"
* ab: string value of length 11
* 65 6c 6c 6f 20 57 6f 72 6c 64: "Hello World"
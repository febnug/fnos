```
 _____ _____ _____ _____
|   __|   | |     |   __|
|   __| | | |  |  |__   |
|__|  |_|___|_____|_____|  
```
A very <b><code>dumb</code></b> simple minimal operating system, written from scratch using `x86` assembly language (`8086` flavour) real mode.

---

<h3>Preview</h3>
<img src="https://raw.githubusercontent.com/febnug/fnos/main/screenshoot/2021-08-31-181458_1366x768_scrot.png"/>

<h3>How to build</h3>

```
make
```

<h3>How to run</h3>

Using <a href="https://github.com/qemu/qemu">QEMU</a> :

```
qemu-system-i386 -rtc base=localtime,clock=vm -drive format=raw,file=./fnos.img
```

<h3>How to use</h3>
Command list at <a href="https://github.com/febnug/fnos/blob/main/fnos.asm#L74:L86">fnos.asm</a> 

<h3>Credit</h3>
Tetris game taken from <a href="https://github.com/shikhin">Shikhin</a>'s repository, named as <a href="https://github.com/shikhin/tetranglix">Tetranglix</a>





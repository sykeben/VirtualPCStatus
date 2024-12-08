# VirtualPCStatus
An AutoHotkey 2.0 script to place an icon in the tray to indicate the current state of the Windows Virtual PC stack.

---

## Why?

I've been dailying Windows 7 for fun on and off and have Windows XP Mode set up so I can run Office 97 and Visual Studio 6.0 successfully under Windows XP. I don't like the idea of having a VM running in the background without any kind of indication that it's active, so I decided to take care of the problem using AutoHotKey.

## How?

Every few seconds or so, the script will check the status of 3 processes associated with Microsoft Virtual PC:

 1. `vmsal.exe` (Windows Virtual PC Application Launcher)
 2. `VMWindow.exe` (Windows Virtual PC)
 3. `vpc.exe` (Virtual PC Host Process)

It then combines these states bitwise to index into the following lookup table:

| `vmsal.exe` | `VMWindow.exe` | `vpc.exe` | Status                  |
|-------------|----------------|-----------|-------------------------|
|             |                |           | Stopped                 |
|             |                | **X**     | Backgrounded            |
|             | **X**          |           | Starting Desktop        |
|             | **X**          | **X**     | Running Desktop         |
| **X**       |                |           | Starting Application(s) |
| **X**       |                | **X**     | Running Application(s)  |
| **X**       | **X**          |           | Transitioning           |
| **X**       | **X**          | **X**     | Transitioning           |

It uses this information to update the tray icon, tray tooltip, and the timer delay (which is adjusted dynamically to make it respond nicely without wasting resources when it's not neccissary.

## Disclaimer

I only made this to solve a personal annoyance with some (very) retro software. This is totally pointless outside being an extra "blinkenlight" that might help you sometimes.

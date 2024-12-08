#Requires AutoHotkey v2.0
#SingleInstance Force

; THIS IS VERSION 2.0.1 (Version checking is coming at some point?)

; Define processes to check.
processes := ["vpc.exe", "VMWindow.exe", "vmsal.exe"]

; Define possible states.
/*
 * Note 1: Each state's index is the decimal equivalent of the process states (LSB first), plus 2.
 * Note 2: States are formatted as [ToolTip, IconFile, IconGroup, UpdateDelay].
 * Note 3: State 1 is used for an unknown/default status.
 */
states := [
    ["Unknown",                 "Unk.ico",      1, 1250],
	["Stopped",                 "Stop.ico",     1, 5000],
	["Backgrounded",            "BG.ico",       1, 5000],
	["Starting Desktop",        "BootDesk.ico", 1, 2500],
	["Running Desktop",         "RunDesk.ico",  1, 5000],
	["Starting Application(s)", "BootApp.ico",  1, 2500],
	["Running Application(s)",  "RunApp.ico",   1, 5000],
	["Transitioning",           "Trans.ico",    1, 2500],
	["Transitioning",           "Trans.ico",    1, 2500],
]

; Define change method.
change_state(new_state, update_timer) {

	; Get new information.
	new_tip    := "Virtual PC Status:`n" new_state[1]
	new_icon   := "Icons\" new_state[2]
	new_group  := new_state[3]
	new_delay  := new_state[4]
	
	; Update tray.
	A_IconTip := new_tip
	TraySetIcon new_icon, new_group, True
	
	; Update timer (if requested).
	if (update_timer) {
		SetTimer , new_delay
	}
	
}

; Define update method.
update_status() {

	; Define previous values.
	static prev_index := 1
	static prev_state := states[1]
	
	; Calculate current index.
	curr_index := 0
	Loop processes.Length {
		If (ProcessExist(processes[A_Index])) {
			curr_index |= 1 << (A_Index - 1)
		}
	}
	curr_index += 2
	
	; Update if different.
	If (prev_index != curr_index) {
	
		; Update current state.
		curr_state := states[curr_index]
		change_state curr_state, True
	
		; Refresh previous values.
		prev_index := curr_index
		prev_state := curr_state
	
	}
	
}

; Initialize.
SetWorkingDir A_ScriptDir
change_state states[1], False
SetTimer update_status, states[1][4]

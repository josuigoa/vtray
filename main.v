$if linux {
	// #define TRAY_APPINDICATOR 1
	#flag -DTRAY_APPINDICATOR=1 $(shell pkg-config --cflags appindicator3-0.1) $(shell pkg-config --libs appindicator3-0.1)
}
$if windows {
	// #define TRAY_WINAPI 1
	#flag -DTRAY_WINAPI=1
}
$if macos {
	// #define TRAY_APPKIT 1
	#flag -DTRAY_APPKIT=1 -framework Cocoa
}

#flag -I. -Wall -Wextra -std=c99
#include "tray.h"
#include "@VMODROOT/tray.c"

fn C.tray_init(TrayParams) &TrayInfo
fn C.tray_loop(&TrayInfo)
fn C.tray_run(&TrayInfo)
fn C.tray_exit(&TrayInfo)

struct TrayMenuItem {
	id   string [required] // Unique ID.
	text string [required] // Text to display.
}

// Parameters to configure the tray button.
struct TrayParams {
	items    []TrayMenuItem         [required]
	on_click fn (item TrayMenuItem)
}

// Internal Cocoa application state.
struct TrayInfo {
	app          voidptr // pointer to NSApplication
	app_delegate voidptr // pointer to AppDelegate
}

[heap]
struct MyApp {
mut:
	tray_info &TrayInfo = unsafe { nil }
}

fn (app &MyApp) on_menu_item_click(item TrayMenuItem) {
	println('click ${item.id}')
	if item.id == 'quit' {
		C.tray_exit(app.tray_info)
	}
}

fn main() {
	mut my_app := &MyApp{
		tray_info: 0
	}

	my_app.tray_info = C.tray_init(TrayParams{
		items: [TrayMenuItem{
			id: 'hello'
			text: 'Hello'
		}, TrayMenuItem{
			id: 'quit'
			text: 'Quit!'
		}]
		on_click: my_app.on_menu_item_click
	})

	//// Use this:
	// for {
	// 	C.tray_loop(my_app.tray_info)
	//  	// println("loop")
	// }

	//// Or this:
	C.tray_run(my_app.tray_info)
}
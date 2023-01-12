$if linux {
	#flag -DTRAY_APPINDICATOR=1 $(shell pkg-config --cflags appindicator3-0.1) $(shell pkg-config --libs appindicator3-0.1)
}
$if windows {
	#flag -DTRAY_WINAPI=1
}
$if macos {
	#flag -DTRAY_APPKIT=1 -framework Cocoa
}

#flag -I. -Wall -Wextra -std=c99
#include "tray.h"

struct C.tray {
	icon &u8
	menu &C.tray_menu
}

struct C.tray_menu {
pub:
	text &u8
}

fn C.tray_init(&C.tray) int
fn C.tray_loop(int) int

fn main() {
	tray := &C.tray{
		icon: 'icon.ico'.str
		menu: &C.tray_menu{
			text: 'text'.str
		}
	}
	
	C.tray_init(tray)
	for {
		print(C.tray_loop(1))
		if C.tray_loop(1) != 0 {
			break
			// printf("iteration\n");
		}
	}
}

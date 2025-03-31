//
//  AppDelegate.swift
//  TheCatApi
//
//  Created by Dmitry Khalitov on 3/30/25.
//

import Cocoa


class AppDelegate: NSObject, NSApplicationDelegate {

    var mainWindowController: MainWindowController!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        mainWindowController = MainWindowController()
        mainWindowController.showWindow(self)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Оставляем пустым или сохраняем состояние
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}

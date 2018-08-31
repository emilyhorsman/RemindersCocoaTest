//
//  AppDelegate.swift
//  RemindersCocoaTest
//
//  Created by Emily Horsman on 8/31/18.
//  Copyright © 2018 Emily Horsman. All rights reserved.
//

import Cocoa
import EventKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let eventStore = EKEventStore()

        eventStore.requestAccess(to: .reminder) { granted, error in
            guard granted else {
                print("Could not grant access.")
                NSApp.terminate(self)
                return
            }

            eventStore.requestAccess(to: .event) { granted, error in
                guard granted else {
                    print("Could not grant calendar access.")
                    NSApp.terminate(self)
                    return
                }

                self.getReminders(from: eventStore)
            }
        }
    }

    func getReminders(from eventStore: EKEventStore) {
        guard EKEventStore.authorizationStatus(for: .reminder) == .authorized else {
            print("Not authorized.")
            return
        }

        let reminder = EKReminder(eventStore: eventStore)
        reminder.title = "Foobar!"
        do {
            try eventStore.save(reminder, commit: true)
        } catch {
            print("exception :(")
            print(error)
        }

        /*guard let calendar = eventStore.defaultCalendarForNewReminders() else {
            print("Could not get default calendar for new reminders.")
            return
        }*/

        /*eventStore.fetchReminders(matching: eventStore.predicateForReminders(in: nil)) { reminders in
            print(reminders?.count)
        }*/

        /*let predicate = eventStore.predicateForReminders(in: [calendar])
        eventStore.fetchReminders(matching: predicate) { reminders in
            print(reminders?.count)
        }*/
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}


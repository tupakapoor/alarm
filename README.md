# Alarm.app
## Requirements
* The ability to add/edit/delete alarms
* The ability for the user to customize the content of the 
notification shown
* The ability for the user to specify which timezone the alarm 
should be in
* The ability to store multiple alarms
* The ability to show an alarm (local notification) to the user at 
the selected time

## Approach
I will be using a table view to display the list of alarms. There will be an "Add" button in the navigation bar, and swipe to reveal edit/delete buttons for each row in the table view. Upon edit/delete, local notifications that have already been set must be updated/removed. Each row will display the title of the alarm, as well as the time (with time zone) it should be triggered. Given more time I would use CoreData or an equivalent database, however in the interest of time I will just be serializing an array of Alarm objects to NSUserDefaults. Adding an alarm will push a new view, with inputs for the corresponding data fields of an alarm. The title will be a text field, date/time will be a date picker, and time zone will be a standard picker. Editing an alarm will come to this screen with the values pre-populated.

## Data Model
### Alarm
- NSString *title
- NSDate *time;
- NSTimeZone *timezone;

## Improvements
* Repeating alarms
* Better local storage of alarms
* Server based storage of alarms
  * iCloud for notifications across multiple devices 
  * Save to a server for alarms via push notification
* Target iPad in addition to iPhone

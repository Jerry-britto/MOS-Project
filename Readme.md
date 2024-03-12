# Notes App

## Overview

This is a simple notes app implemented using Zenity for the user interface, shell scripting for the backend, and MySQL for data storage. The app provides basic functionalities like adding, retrieving, updating, and deleting notes. It interacts with a MySQL database to store and retrieve notes.

## Features

1. **Add a Note:**
   - Users can add a new note by providing a description.
   - The note is saved in the MySQL database upon tapping "OK."

2. **Retrieve Notes:**
   - Users can retrieve all notes stored in the database.
   - Selecting the "Retrieve Notes" option displays a list of notes.

3. **Update Note:**
   - Users can update an existing note by providing the note ID and the updated content.
   - If the note ID exists, the respective note is updated; otherwise, a prompt is displayed.

4. **Delete Note:**
   - Users can delete a note by providing the note ID.
   - If the note ID exists, the respective note is deleted; otherwise, a prompt is displayed.

## Future Improvements

1. **User Management System:**
   - Implement a user authentication system to restrict access to individual users' notes.

2. **Reminder Functionality:**
   - Add a feature to set reminders for notes.
   - Display notifications for reminders.


## Contributions Welcome!

If you have any ideas for improvements or new features, feel free to open an issue or submit a pull request. Your contributions are valuable, and I appreciate your help in making this app even better!
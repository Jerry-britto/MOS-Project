MYSQL_DATABASE="notesdb"
function displayOptions(){
    option=$(zenity --list --title="Choose your option" --column="Option number" --column="Option name" \
    1 "Create a note" \
    2 "Read your notes" \
    3 "Update your note"\
    4 "Delete your note" \
    5 "Exit" \
    --height=300 --width=400)

    case $option in
    1)
        createNote
        ;;
    2)
        readNotes
        ;;
    3)
        updateNote
        ;;
    4)
        deleteNote
        ;;
    5)
        exit
        ;;
    *)
        echo "Unknown option."
        ;;
    esac
}

function insertNote(){
    note="$1"
    echo $note

     maxId=$(mysql --defaults-file=~/.my.cnf -D "$MYSQL_DATABASE" -se "SELECT MAX(noteId) FROM notes;")
    echo $maxId
    # new id
    newId=$((maxId + 1))
    echo $newId
mysql --defaults-file=~/.my.cnf -D "$MYSQL_DATABASE" <<EOF
INSERT INTO notes
VALUES ($newId, '$note');
EOF
}

function createNote(){
    echo "create note"
    user_input=$(zenity --entry --title="Add a note" --text="Enter your note " --height=200 --width=200)
    echo $user_input
    if [ -z "$user_input" ]; then
        echo "no note added"
        displayOptions
    else
        echo "You entered: $user_input"
        insertNote "$user_input"
        # echo "data inserted"

        zenity --notification --window-icon="info" --text="New note added"
        displayOptions
    fi
}

function readNotes(){
  data=$(mysql --defaults-file=~/.my.cnf -D notesdb -e "SELECT * FROM notes;")

    list_data=()
    while IFS= read -r line; do
        list_data+=("$line")
    done <<< "$data"

    zenity --list --title="Data List" --column="Data" "${list_data[@]}" --height=400 --width=400

    displayOptions
  
}

function modifyNote(){
    id=$1
    note="$2"
    echo $id
    echo $note
    data=$(mysql --defaults-file=~/.my.cnf -D notesdb -e "SELECT * FROM notes where noteId=$id;")

     if [ -z "$data" ]; then
        zenity --error --text="No data exists with noteId $id exists"
        updateNote
    else 
        echo $data
        mysql --defaults-file=~/.my.cnf -D "$MYSQL_DATABASE" <<EOF
UPDATE notes
SET note = '$note'
WHERE noteId = $id;
EOF
    fi
}

function updateNote(){
    echo "update note"
    result=$(zenity --forms \
    --title="Update your note" \
    --text="Enter note details" \
    --separator="," \
    --add-entry="Enter note id" \
    --add-entry="Enter new note")

    # Check if the user clicked "Cancel" or closed the dialog
    if [ $? -eq 1 ]; then
        echo "User canceled."
        displayOptions
    else
        field1=$(echo "$result" | cut -d ',' -f1)
        field2=$(echo "$result" | cut -d ',' -f2)

        if [ -z "$field1" ] || [ -z "$field2" ]; then
            zenity --error --text="Both fields are mandatory. Please fill in both details."
            updateNote
        else
            echo "Field 1: $field1"
            echo "Field 2: $field2"
            modifyNote "$field1" "$field2"
            zenity --notification --window-icon="info" --text="Updated note id: $field1"
            displayOptions
        fi
    fi

}

function deleteNote(){
    echo "delete note"
     user_input=$(zenity --entry --title="Delete your note" --text="Enter note id" --height=200 --width=200)

    if [ -z "$user_input" ]; then
        echo "no note added"
        displayOptions
    else
        echo "You entered: $user_input"
        removeNote "$user_input"
         zenity --notification --window-icon="info" --text="Deleted note id: $user_input"
        displayOptions
    fi
}

function removeNote(){
    id=$1
    data=$(mysql --defaults-file=~/.my.cnf -D notesdb -e "SELECT * FROM notes where noteId=$id;")
    if [ -z "$data" ]; then
        zenity --error --text="No data exists with noteId $id exists"
        deleteNote
    else
    echo $id
  mysql --defaults-file=~/.my.cnf -D "$MYSQL_DATABASE" <<EOF
DELETE FROM notes WHERE noteId = $id;
EOF
fi
}

zenity --info --text="Welcome to our notes app" --height=200 --width=400

if [ $? -eq 0 ]; then
    echo "User closed the dialog."
    # Add additional commands to close the application here
    displayOptions
else
   exit 1
fi
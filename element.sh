#!/bin/bash

# Function to search for an element
find_element() {
    # Assuming `psql` is used for querying PostgreSQL
    local query="SELECT atomic_number, name, symbol, atomic_mass, melting_point_celsius, boiling_point_celsius, type, group, period
                 FROM elements
                 JOIN properties ON elements.atomic_number = properties.atomic_number
                 WHERE atomic_number = $1 OR symbol = '$1' OR name = '$1';"

    result=$(psql -U username -d database_name -t -c "$query")

    if [ -z "$result" ]; then
        echo "I could not find that element in the database."
    else
        # Extract the fields from the result
        echo "$result" | while IFS="|" read -r atomic_number name symbol atomic_mass melting_point boiling_point type group period; do
            echo "Element Details:"
            echo "------------------"
            echo "Atomic Number: $atomic_number"
            echo "Name: $name"
            echo "Symbol: $symbol"
            echo "Atomic Mass: $atomic_mass amu"
            echo "Melting Point: $melting_point°C"
            echo "Boiling Point: $boiling_point°C"
            echo "Type: $type"
            echo "Group: $group"
            echo "Period: $period"
            echo "------------------"
        done
    fi
}

# Function to check if input is a valid number
is_number() {
    if [[ "$1" =~ ^[0-9]+$ ]]; then
        return 0 # Valid number
    else
        return 1 # Invalid number
    fi
}

# Function to handle user input
handle_input() {
    if [ -z "$1" ]; then
        echo "Please provide an element as an argument or input the element you want to search for."
        echo "You can search by Atomic Number, Name, or Symbol."
        read -p "Enter atomic number, name, or symbol: " user_input

        # Check if the input is a number
        if is_number "$user_input"; then
            find_element "$user_input"
        else
            find_element "$user_input"
        fi
    else
        find_element "$1"
    fi
}

# Adding a check for empty input
handle_input "$1"

#!/bin/bash

# Function to search for an element
find_element() {
    # Assuming `psql` is used for querying PostgreSQL
    local query="SELECT atomic_number, name, symbol, atomic_mass, melting_point_celsius, boiling_point_celsius, type
                 FROM elements
                 JOIN properties ON elements.atomic_number = properties.atomic_number
                 WHERE atomic_number = $1 OR symbol = '$1' OR name = '$1';"

    result=$(psql -U username -d database_name -t -c "$query")

    if [ -z "$result" ]; then
        echo "I could not find that element in the database."
    else
        # Extract the fields from the result
        echo "$result" | while IFS="|" read -r atomic_number name symbol atomic_mass melting_point boiling_point type; do
            echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
        done
    fi
}

# Check if an argument is provided
if [ -z "$1" ]; then
    echo "Please provide an element as an argument."
else
    find_element "$1"
fi

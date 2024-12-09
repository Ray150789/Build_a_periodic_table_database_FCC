#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]] 
then
  echo -e "Please provide an element as an argument."
else
  INPUT=$1

  # Check if input is a number (atomic number) 
  if [[ $INPUT =~ ^[0-9]+$ ]] 
  then
    ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number=$INPUT")
  else
    # Check if input is a symbol or name
    ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE symbol='$INPUT' OR name='$INPUT'")
  fi

  # Check if element is found
  if [[ -z $ELEMENT ]]
  then
    echo "I could not find that element in the database."
  else  
    echo "$ELEMENT" | while IFS="|" read ATOMIC_NUM NAME SYMBOL TYPE ATOMIC_MASS MPC BPC
    do
      echo "The element with atomic number $ATOMIC_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MPC celsius and a boiling point of $BPC celsius."
    done
  fi
fi

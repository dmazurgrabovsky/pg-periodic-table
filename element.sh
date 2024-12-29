#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t -c"

GET_ELEMENT_INFO() {
  ELEMENT=$1

  ELEMENT_AS_NUMBER=0
  #if it is a number
  if [[ "$ELEMENT" =~ ^[0-9]+$ ]]; then
    ELEMENT_AS_NUMBER=$ELEMENT
fi
  ELEMENT_INFO=$($PSQL "select 
    atomic_number, symbol, name, atomic_mass,
    melting_point_celsius, boiling_point_celsius,
    type
    from elements 
    LEFT JOIN properties USING (atomic_number)
    LEFT JOIN types USING (type_id)
    where atomic_number=$ELEMENT_AS_NUMBER OR symbol='$ELEMENT' OR name='$ELEMENT'
    " )
    if [[ -z $ELEMENT_INFO ]]
    then
      echo ""
    else
      echo "$ELEMENT_INFO" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING BAR BOILING BAR TYPE
      do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL).
 It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
      done
    fi
}

ELEMENT=$1

if [[ -z $ELEMENT ]]
then 
  echo -e "Please provide an element as an argument."
else
  ELEMENT_INFO=$(GET_ELEMENT_INFO $ELEMENT)
  if [[ -z $ELEMENT_INFO ]]
  then
    echo I could not find that element in the database.
  else
    echo $ELEMENT_INFO
  fi
fi

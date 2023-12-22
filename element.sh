#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

#  check arg $1 to see if there is an input 
if [[ -z $1 ]]
then
  echo 'Please provide an element as an argument.'
  exit
fi



# check if number, symbol, or name

num='^[0-9]+$'
if [[ $1 =~ $num ]]; then
  ELEMENT_RESPONSE=$($PSQL "SELECT * FROM elements  join properties using (atomic_number) WHERE atomic_number = $1")
elif [[ ${#1} <3 ]]; then 
  ELEMENT_RESPONSE=$($PSQL "SELECT * FROM elements join properties using (atomic_number)  WHERE symbol = '$1'")
else 
  ELEMENT_RESPONSE=$($PSQL "SELECT * FROM elements join properties using (atomic_number)  WHERE name = '$1'")
fi

if [[ -z $ELEMENT_RESPONSE ]]
then
  echo "I could not find that element in the database."
  exit
fi


echo  $ELEMENT_RESPONSE | while IFS='|' read NUMBER  SYMBOL  NAME MASS MELTING BOILING TYPE_ID
do 
  TYPE=$($PSQL "SELECT type FROM types where type_id = $TYPE_ID")
  echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  exit
done

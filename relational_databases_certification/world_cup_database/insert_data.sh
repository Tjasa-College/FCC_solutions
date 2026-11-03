#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games, teams")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
#INSERTS ALL OF THE TEAMS INTO THE TEAMS TABLE
#checks winning teams and inserts them into teams table if not in the table
if [[ $WINNER != 'winner' ]]
then
  WINNER_ID=$($PSQL "SELECT name FROM teams  WHERE name='$WINNER'")
  if [[ -z $WINNER_ID ]]
  then
    INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
    if [[ $INSERT_WINNER_RESULT = 'INSERT 0 1' ]]
    then
      echo Inserted team: $WINNER
    fi
  fi
fi
#checks opponent teams and inserts them into teams table if not in the table
if [[ $OPPONENT != 'opponent' ]]
then
  OPPONENT_ID=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
  if [[ -z $OPPONENT_ID ]]
  then
    INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
    if [[ $INSERT_OPPONENT_RESULT = 'INSERT 0 1' ]]
    then
      echo Inserted team: $OPPONENT
    fi
  fi
fi
done 

#PUT DATA INTO THE games table
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $YEAR != 'year' && $ROUND != 'round' &&  $WINNER != 'winner' && $OPPONENT != 'opponent' && $WINNER_GOALS != 'winner_goals' && $OPPONENT_GOALS != 'opponent_goals' ]]
then
  #get winner id
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  #get opponent id
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  #insert data into table
  INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  #check that inserted
  if [[ $INSERT_GAME_RESULT = 'INSERT 0 1' ]]
  then
    echo Inserted game $WINNER : $OPPONENT
  fi
fi
done
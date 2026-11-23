#!/bin/bash

echo "~~~~~ MY SALON ~~~~~"
echo ""
echo "Welcome to My Salon, how can I help you?"
echo ""

function show_services {
    psql --username=freecodecamp --dbname=salon -t -A -c "SELECT service_id || ') ' || name FROM services ORDER BY service_id;"
    echo ""
}

show_services
read SERVICE_ID_SELECTED

while true; do
    result=$(psql --username=freecodecamp --dbname=salon -t -A -c "SELECT COUNT(*) FROM services WHERE service_id = $SERVICE_ID_SELECTED;")
    if [ "$result" -eq 1 ]; then
        break
    fi
    echo "I could not find that service. What would you like today?"
    show_services
    read SERVICE_ID_SELECTED
done

service_name=$(psql --username=freecodecamp --dbname=salon -t -A -c "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED;")

echo "What's your phone number?"
read CUSTOMER_PHONE

existing_customer=$(psql --username=freecodecamp --dbname=salon -t -A -c "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE';")

if [ -z "$existing_customer" ]; then
    echo "I don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    psql --username=freecodecamp --dbname=salon -c "INSERT INTO customers (name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE');"
else
    CUSTOMER_NAME="$existing_customer"
fi

echo "What time would you like your $service_name, $CUSTOMER_NAME?"
read SERVICE_TIME

customer_id=$(psql --username=freecodecamp --dbname=salon -t -A -c "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")

psql --username=freecodecamp --dbname=salon -c "INSERT INTO appointments (customer_id, service_id, time) VALUES ($customer_id, $SERVICE_ID_SELECTED, '$SERVICE_TIME');"

echo "I have put you down for a $service_name at $SERVICE_TIME, $CUSTOMER_NAME."
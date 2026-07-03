USE ola_rides;

#1. Retrieve all successful bookings :
CREATE VIEW Successful_Bookings AS
SELECT * FROM bangaluru_ola
WHERE booking_status  = 'Success';  #--OR 
SELECT * FROM Successful_Bookings;

#2. The average ride distance for each vehicle type :
CREATE VIEW Ride_Distance_for_each_vehicle_type AS
SELECT vehicle_type, AVG(ride_distance) FROM bangaluru_ola
GROUP BY vehicle_type;
SELECT * FROM Ride_Distance_for_each_vehicle_type;

#3. Get the total rides cancelled by customers :
CREATE VIEW Total_rides_cancelled_by_customer AS
SELECT reason_for_cancelling_by_customer, COUNT(cancelled__by_customer) FROM bangaluru_ola
GROUP BY reason_for_cancelling_by_customer;
SELECT * FROM Total_rides_cancelled_by_customers;

#4. Get the total rides cancelled by drivers :
CREATE VIEW Total_rides_cancelled_by_driver AS
SELECT reason_for_cancelling_by_driver, COUNT(cancelled_rides_by_driver) FROM bangaluru_ola
GROUP BY reason_for_cancelling_by_driver;
SELECT * FROM Total_rides_cancelled_by_driver;

#5. List the top 5 customers who booked the highest number of rides :
SELECT customer_id, COUNT(booking_value) AS total_rides
FROM bangaluru_ola
GROUP BY customer_id
ORDER BY total_rides DESC LIMIT 5;    #--OR


# --Using Window Function--
CREATE VIEW Top_5_customer AS
SELECT customer_id, total_rides
FROM (
    SELECT
        customer_id,
        COUNT(*) AS total_rides,
        DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
    FROM bangaluru_ola
    GROUP BY customer_id
) t
WHERE rnk <= 5
LIMIT 5;
SELECT * FROM Top_5_customer;

#6. Find the maximum driver ratings for Prime Plus :
SELECT booking_id, vehicle_type, MAX(driver_ratings) AS highest_rated_drivers
FROM bangaluru_ola
WHERE vehicle_type = 'Prime Plus'
GROUP BY booking_id
ORDER BY highest_rated_drivers DESC LIMIT 5; 

#7. Find the minimum driver ratings for Prime Plus :
SELECT booking_id, vehicle_type, MIN(driver_ratings) AS lowest_rated_drivers
FROM bangaluru_ola
WHERE vehicle_type = 'Prime Plus'
GROUP BY booking_id
ORDER BY lowest_rated_drivers DESC LIMIT 5; 

#8. Retrieve all the rides where payment made by UPI :
SELECT * FROM bangaluru_ola
WHERE payment_method = 'UPI';

#9. Find the average rating by customer per vehivle type :
SELECT vehicle_type, AVG(customer_rating) AS avg_ratings
FROM bangaluru_ola
GROUP BY vehicle_type;

#10. Calculate the total booking value of rides completely successful :
SELECT booking_status, SUM(booking_value) AS total_booking_value
FROM bangaluru_ola
WHERE booking_status = 'Success'
GROUP BY booking_status;

#11. List all the incomplete rides along with the reason :
SELECT incomplete_rides_reason, COUNT(incomplete_rides) as total_incomplete_rides
FROM bangaluru_ola
WHERE booking_status = 'Incomplete'
GROUP BY incomplete_rides_reason;         

#12. List all the unsuccessful rides along with reason :
SELECT
    booking_status,
    CASE
        WHEN reason_for_cancelling_by_customer IS NOT NULL
        THEN reason_for_cancelling_by_customer
        ELSE reason_for_cancelling_by_driver
    END AS cancellation_reason
FROM bangaluru_ola
WHERE booking_status <> 'Success';

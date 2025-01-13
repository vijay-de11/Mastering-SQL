--write a user defined functions  which takes 2 input parameters of DATE data type. 
--The function should return no of business days between the 2 dates.
--note -> if any of the 2 input dates are falling on saturday or sunday then function should use immediate Monday 
--date for calculation
--example if we pass dates as 2022-12-18 and 2022-12-24..then it should calculate business days between 2022-12-19 and 2022-12-26
ALTER
--CREATE 
FUNCTION business_days (
    @date1 DATE,
    @date2 DATE
)
RETURNS INT
AS
BEGIN
    -- Normalize the input dates
    DECLARE @startDate DATE = CASE WHEN @date1 <= @date2 THEN @date1 ELSE @date2 END;
    DECLARE @endDate DATE = CASE WHEN @date1 > @date2 THEN @date1 ELSE @date2 END;

    -- Count the total days between the two dates
    DECLARE @totalDays INT = DATEDIFF(DAY, @startDate, @endDate) + 1;

    -- Count the weekends between the two dates
    DECLARE @weekends INT = DATEDIFF(WEEK, @startDate, @endDate) * 2;

    -- Calculate business days by subtracting weekends from total days
    RETURN @totalDays - @weekends + 1;
END;
GO
SELECT dbo.business_days('2025-01-11','2025-01-20') AS business_days;

-- It gives total no of days between 2 dates
select DATEDIFF(DAY, '2025-01-11','2025-01-20') as total_days ;

-- It gives total no of weekends between 2 dates (so to calculate total no of weekend days, we need to multiply the result * 2)
select datediff(week, '2025-01-11','2025-01-20') as weekends;
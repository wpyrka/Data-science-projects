CREATE TABLE age_ranges (
    age_range_id INT AUTO_INCREMENT PRIMARY KEY,
    age_range VARCHAR(20) NOT NULL
);

ALTER TABLE gifts_age
ADD COLUMN age_range_id INT,
ADD CONSTRAINT fk_age_range
FOREIGN KEY (age_range_id) REFERENCES age_ranges(age_range_id);

INSERT INTO age_ranges (age_range) VALUES ('18-24'), ('25-34'), ('35-44'), ('45-54'), ('55-64'), ('65+');

UPDATE gifts_age a
JOIN age_ranges ar ON a.Age BETWEEN LEFT(ar.age_range, 2) AND RIGHT(ar.age_range, 2)
SET a.age_range_id = ar.age_range_id
WHERE a.age_range_id IS NULL;
UPDATE gifts_age SET age_range_id = 6 WHERE age_range_id IS NULL AND Age = '65+';

CREATE TABLE genders (
    gender_id INT AUTO_INCREMENT PRIMARY KEY,
    gender VARCHAR(10) UNIQUE
);

INSERT INTO genders (gender) VALUES ('Male'), ('Female');

ALTER TABLE gifts_gender ADD COLUMN gender_id INT,
ADD CONSTRAINT fk_gender_id FOREIGN KEY (gender_id) REFERENCES genders(gender_id);

UPDATE gifts_gender SET gender_id = 1 WHERE gender_id IS NULL AND Gender = 'Men';

UPDATE gifts_gender SET gender_id = 2 WHERE gender_id IS NULL AND Gender = 'Women';

ALTER TABLE historical_spending ADD PRIMARY KEY (Year);

ALTER TABLE gifts_gender ADD COLUMN age_range_id INT;

ALTER TABLE gifts_gender
ADD CONSTRAINT FK_age_ranges FOREIGN KEY (age_range_id) REFERENCES age_ranges(age_range_id);

ALTER TABLE gifts_gender
ADD CONSTRAINT FK_gender FOREIGN KEY (gender_id) REFERENCES genders(gender_id);


-- Select the year with the highest average percent spending on flowers.
SELECT Year, Flowers
FROM historical_spending 
WHERE Flowers = (SELECT MAX(Flowers) FROM historical_spending);

 -- Find the most popular gift among people aged 18-24.
SELECT Age, 
    CASE
        WHEN MAX(Candy) THEN 'Candy'
        WHEN MAX(Flowers) THEN 'Flowers'
        WHEN MAX(Jewelry) THEN 'Jewelry'
        WHEN MAX(GreetingCards) THEN 'GreetingCards'
        WHEN MAX(EveningOut) THEN 'EveningOut'
        WHEN MAX(Clothing) THEN 'Clothing'
        WHEN MAX(GiftCards) THEN 'GiftCards'
    END AS MostPopularGift
FROM gifts_age
WHERE Age = '18-24';

-- Which age group buys jewelry most often? Group in descending order.
SELECT Age, Jewelry 
FROM gifts_age 
ORDER BY Jewelry DESC;

-- Find the year with the most people celebrating Valentine's Day.
SELECT Year, PercentCelebrating 
FROM historical_spending 
WHERE PercentCelebrating = (SELECT MAX(PercentCelebrating) FROM historical_spending);

-- View the amount of money spent on jewelry for each age group in 2015.
SELECT ar.age_range AS AgeRange, SUM(h.Jewelry) AS TotalJewelrySpending
FROM gifts_age ga
JOIN age_ranges ar ON ga.age_range_id = ar.age_range_id
JOIN historical_spending h ON ar.age_range = h.Year
WHERE h.Year = 2015
GROUP BY ar.age_range;

-- Compute the total amount spent in 2017.
SELECT SUM(Candy + Flowers + Jewelry + GreetingCards + EveningOut + Clothing + GiftCards) AS TotalSpending2017
FROM historical_spending
WHERE Year = 2017;

-- View average spending per person for each year.
SELECT Year, AVG(PerPerson) AS AvgPerPerson
FROM historical_spending
GROUP BY Year;

-- Retrieve the percentage of consumers within the age range of 25-34 who buy gift cards.
SELECT Giftcards 
FROM gifts_age 
WHERE Age BETWEEN 25 AND 34;

-- View the most popular gifts for each age group in 2018.
SELECT ar.age_range AgeRange, MAX(h.Candy) AS MaxCandy, MAX(h.Flowers) AS MaxFlowers, MAX(h.Jewelry) AS MaxJewelry
FROM gifts_age ga
JOIN age_ranges ar ON ga.age_range_id = ar.age_range_id
JOIN historical_spending h ON ar.age_range = h.Year
WHERE h.Year = 2018
GROUP BY ar.age_range;

-- View those age groups where 30 percent or more spend on evening out.
SELECT Age, EveningOut
FROM gifts_age
WHERE EveningOut >= 30;

-- Select the year with the highest average total spending.
SELECT Year
FROM historical_spending
ORDER BY (Candy + Flowers + Jewelry + GreetingCards + EveningOut + Clothing + GiftCards) DESC
LIMIT 1;

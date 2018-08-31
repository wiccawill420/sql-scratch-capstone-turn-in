#SQL intensive Final Project
#William Lynn
#Quiz Funnel:

## 1) 
###Question: What columns does the table have?
###Query:
SELECT * 
FROM survey 
LIMIT 10;
###Answer: question, user_id, response

## 2)
### Question: What is the number of responses for each question?
### Query:
SELECT question,
  count(*) as 'num_responses'
FROM survey
GROUP BY 1;
### Answer:
#1. What are you looking for?	500
#2. Whats your fit?				475
#3. Which shapes do you like?	380
#4. Which colors do you like?	361
#5. When was your last eye exam?	270

## 3)
### Question1: Which question(s) of the quiz have a lower completion rates?
### Answer1_a: Last eye exam question has the lowest percent of completion at 74.8%
### Answer1_b: Shapes question is next lowest completion rate at 80%
### Question2: What do you think is the reason?
### Answer2_a: People may not know or have information on the last time they had an eye exam ready
### Answer2_b: Uncertain of shapes they think will look good on them. Or just wants to start browsing styles.

# Home Try-On Funnel:
## 4)
### Question: What are the column names?
### Query:
SELECT *
FROM quiz
LIMIT 5;

SELECT *
FROM home_try_on
LIMIT 5;

SELECT *
FROM purchase
LIMIT 5;
### Answer: 
#quiz: user_id, style, fit, shape, color
#home_try_on: user_id, number_of_pairs, address
#purchase: user_id, product_id, style, model_name, color, price

## 5)
### Task: Create output as multi-joined table
### Query: 
SELECT q.user_id,
  h.user_id IS NOT NULL AS 'is_home_try_on',
  h.number_of_pairs,
  p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS h
  ON q.user_id = h.user_id
LEFT JOIN purchase AS p
  ON q.user_id = p.user_id
LIMIT 10;

## 6)
### Task1: Calculate overall conversion rates
### Query1:
-- Combine user's entries across the 3 tables into a funnel
WITH funnel AS(
  SELECT q.user_id,
    h.user_id IS NOT NULL AS 'is_home_try',
    h.number_of_pairs,
    p.user_id IS NOT NULL AS 'is_purchase'
  FROM quiz AS 'q'
  LEFT JOIN home_try_on AS h
    ON q.user_id = h.user_id
  LEFT JOIN purchase AS p
    ON h.user_id = p.user_id)

-- Show total percent of people that purchase after taking quiz
SELECT COUNT(*) AS 'total_customers',
  SUM(is_purchase) as 'total_purchase',
  ROUND(100.0 * SUM(is_purchase) / COUNT(user_id),2) as 'percent_purchase'
FROM funnel;
### Answer1: 
total_customers	total_purchase	percent_purchase
1000			495				49.5

### Task2: Compare conversion from quiz to try and try to purchase
### Query2:
-- Combine user's entries across the 3 tables into a funnel
WITH funnel AS(
  SELECT q.user_id,
    h.user_id IS NOT NULL AS 'is_home_try',
    h.number_of_pairs,
    p.user_id IS NOT NULL AS 'is_purchase'
  FROM quiz AS 'q'
  LEFT JOIN home_try_on AS h
    ON q.user_id = h.user_id
  LEFT JOIN purchase AS p
    ON h.user_id = p.user_id)

-- Show total percent of people that purchase after in-home trial
SELECT COUNT(*) AS 'total_customers',
  SUM(is_home_try) as 'total_try',
  SUM(is_purchase) as 'total_purchase',
  ROUND(100.0 * SUM(is_home_try) / COUNT(user_id),2) as 'percent_try',
  ROUND(100.0 * SUM(is_purchase) / SUM(is_home_try),2) as 'percent_purchase'
FROM funnel;
### Answer2: 
#total_customers	total_try	total_purchase	percent_try	percent_purchase
#1000			750			495				75.0		66.0

### Task3: Calculate percent of people that purchase after in-home trial 3 vs 5 frames
### Query3:
-- Combine user's entries across the 3 tables into a funnel
WITH funnel AS(
  SELECT q.user_id,
    h.user_id IS NOT NULL AS 'is_home_try',
    h.number_of_pairs,
    p.user_id IS NOT NULL AS 'is_purchase'
  FROM quiz AS 'q'
  LEFT JOIN home_try_on AS h
    ON q.user_id = h.user_id
  LEFT JOIN purchase AS p
    ON h.user_id = p.user_id)

--Grab percent of customers that purchase after the in-home trial
SELECT number_of_pairs,
  SUM(is_home_try) as 'num_tried',
  SUM(is_purchase) as 'num_purchased',
  ROUND(100.0 * SUM(is_purchase) / SUM(is_home_try),2) AS 'percent_purchase'
FROM funnel
WHERE number_of_pairs IS NOT NULL
GROUP BY 1;
### Answer3: 
#number_of_pairs	num_tried	num_purchased	percent_purchase
#3 pairs			379			201				53.03
#5 pairs			371			294				79.25

### Task4: How many responses for each quiz question? What's most popular answer for each?
### Query4:
--Count the total for each style
SELECT style,
  COUNT(*) AS 'total'
FROM quiz
GROUP BY 1;
--Count the total for each fit
SELECT fit,
  COUNT(*) AS 'total'
FROM quiz
GROUP BY 1;
--Count the total for each shape
SELECT shape,
  COUNT(*) AS 'total'
FROM quiz
GROUP BY 1;
--Count the total for each color
SELECT color,
  COUNT(*) AS 'total'
FROM quiz
GROUP BY 1;


### Answer4:
#style							total
#I'm not sure. Let's skip it.	99
#Men's Styles					432
#Women's Styles					469

#fit								total
#I'm not sure. Let's skip it.	89
#Medium							305
#Narrow							408
#Wide							198

#shape			total
#No Preference	97
#Rectangular		397
#Round			180
#Square			326

#color		total
#Black		280
#Crystal		210
#Neutral		114
#Tortoise	292
#Two-Tone	104

### Task5: How many of each product were purchased? Which were most popular
### Query5: 
--How many of each product was purchased
SELECT product_id, 
  COUNT(*) AS 'total_purchased'
FROM purchase
GROUP BY 1
ORDER BY 1;
### Answer5:
#product_id	total_purchased
#1			52
#2			43
#3			63
#4			44
#5			41
#6			50
#7			44
#8			24
#9			54
#10			62

### Task6: How much did each frame model generate? Which model of frames generated the most income for WP?
### Query6: 
--Which frame type brought in the most money
SELECT model_name,
  SUM(price) as 'total_earned'
FROM purchase
GROUP BY 1
ORDER BY 2 DESC;
### Answer6:
#model_name		total_earned
#Dawes			16050
#Lucy			12900
#Eugene Narrow	11020
#Brady			9025
#Olive			4750
#Monocle			2050

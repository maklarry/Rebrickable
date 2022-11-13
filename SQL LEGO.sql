
/*After downloading the datasets from the rebrickable website. We load the dataset into our Microsoft SQL Server.
We then attempt to answer the following questions*/
/* What is the total number of parts per theme*/
--We first create a view to store the query.

create view dbo.analytics_main as
SELECT s.set_num, s.name set_name, s.year,s.theme_id,CAST(num_parts as numeric) num_parts, t.id, t.name theme_name, 
t.parent_id , p.name parent_theme_name
FROM dbo.sets s
LEFT JOIN dbo.themes t ON s.theme_id = t.id
LEFT JOIN dbo.themes p ON t.parent_id = p.id

SELECT * FROM dbo.analytics_main;

/* What is the total number of parts per theme*/
SELECT theme_name,sum(num_parts) total_num_parts FROM dbo.analytics_main
GROUP BY theme_name
ORDER BY total_num_parts DESC

/*Total number of parts per year*/
SELECT year,sum(num_parts) total_num_parts FROM dbo.analytics_main
--WHERE parent_theme_name is not NULL
GROUP BY year
ORDER BY 2 DESC

/*How many sets were created in each century in the dataset*/
SELECT century,count(set_num) total_parts FROM dbo.analytics_main

GROUP BY century;


/*Retrieve the set_num omitting the numbers after the hyphen(-)*/
SELECT set_num,SUBSTRING(set_num,1,CHARINDEX('-',set_num)-1) set_num_no_hyphen,set_name,year,theme_id 
FROM dbo.analytics_main

/*What was the popular theme by year in terms of sets released in the 21st century*/
SELECT year,theme_name,total_set_num FROM
(SELECT year,theme_name,count(set_num)total_set_num,ROW_NUMBER() OVER(partition by year order by count(set_num) DESC) rn
FROM dbo.analytics_main
WHERE century = '21th Century' --AND parent_theme_name is not null
GROUP BY year,theme_name) d
WHERE rn =1
ORDER BY  year DESC

/*What is the most produced color of lego in terms of quantity of parts*/
SELECT color_name, sum(quantity) total_quantity FROM
(SELECT s.color_id,s.inventory_id,s.part_num,s.is_spare,CAST(s.quantity AS numeric) quantity,c.name color_name,c.rgb,
p.name part_name,t.name part_category
FROM [dbo].[inventory_parts] s
LEFT JOIN [dbo].[colors] c ON s.color_id = c.id
LEFT JOIN [dbo].[parts] p ON s.part_num = p.part_num
LEFT JOIN [dbo].[part_categories] t ON t.id = p.part_cat_id) main
GROUP BY color_name
ORDER BY 2 DESC



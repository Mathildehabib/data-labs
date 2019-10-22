use publications;

SELECT 
    title,
    ROUND(num_of_books * price / shops, 2) AS avg_revenue_per_shop,
    stor_ids
FROM
    (SELECT 
        t.title,
            SUM(qty) num_of_books,
            GROUP_CONCAT(DISTINCT stor_id) stor_ids,
            price,
            COUNT(DISTINCT stor_id) shops
    FROM
        sales s
    INNER JOIN titles t ON t.title_id = s.title_id
    GROUP BY t.title) new_table;
    
select t.title, t.price, st.stor_name
from titles as t
inner join sales s on t.title_id=s.title_id
inner join stores st on st.stor_id=s.stor_id
where t.type = 'business';



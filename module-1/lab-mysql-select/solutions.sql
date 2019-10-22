use publications;
select authors.au_id as 'Authors ID' , au_lname as 'Last Name',au_fname as 'First Name', titles.title as 'Title', publishers.pub_name as 'Publisher Name'
from authors 
inner join titleauthor 
on titleauthor.au_id = authors.au_id
inner join titles
on titles.title_id = titleauthor.title_id
inner join publishers
on publishers.pub_id = titles.pub_id;

select authors.au_id as 'Authors ID' , au_lname as 'Last Name',au_fname as 'First Name', titles.title as 'Title', publishers.pub_name, count(titles.title_id) as 'count'
from authors 
inner join titleauthor 
on titleauthor.au_id = authors.au_id
inner join titles
on titles.title_id = titleauthor.title_id
inner join publishers
on publishers.pub_id = titles.pub_id
group by authors.au_id, publishers.pub_id;


select authors.au_id as 'Authors ID' , au_lname as 'Last Name',au_fname as 'First Name', titles.title as 'Title', sum(sales.qty) as count
from authors 
inner join titleauthor 
on titleauthor.au_id = authors.au_id
inner join titles
on titles.title_id = titleauthor.title_id
inner join sales
on sales.title_id = titles.title_id
group by authors.au_id
order by count desc
limit 3;






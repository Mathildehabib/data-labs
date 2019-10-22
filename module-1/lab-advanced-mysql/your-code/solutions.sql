use publications;

select t.title, ta.title_id, ta.au_id, round((t.advance * ta.royaltyper / 100),4) advance, round((t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100),4) sales_royalty,s.qty
from titleauthor ta
inner join titles t on t.title_id = ta.title_id
inner join sales s on s.title_id=t.title_id
order by title_id, au_id;

select * 
from sales;

select sum(sales_royalty), title, title_id, au_id
from(select t.title, ta.title_id, ta.au_id, round(t.advance * ta.royaltyper / 100) advance, round((t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100),4) sales_royalty, t.royalty royalty,t.price, s.qty,ta.royaltyper
from titleauthor ta
inner join titles t on t.title_id = ta.title_id
inner join sales s on s.title_id=t.title_id)new_table
group by au_id, title_id;


select sum(sales_royalty)+advance total_profit, title, title_id, au_id
from(select t.title, ta.title_id, ta.au_id, round(t.advance * ta.royaltyper / 100) advance, round((t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100),4) sales_royalty, t.royalty royalty,t.price, s.qty,ta.royaltyper
from titleauthor ta
inner join titles t on t.title_id = ta.title_id
inner join sales s on s.title_id=t.title_id)new_table
group by au_id
order by total_profit desc
limit 3;

create temporary table if not exists new_table5
(select sum(sales_royalty) somme, title, title_id, au_id, advance
from(select t.title, ta.title_id, ta.au_id, round(t.advance * ta.royaltyper / 100) advance, round((t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100),4) sales_royalty, t.royalty royalty,t.price, s.qty,ta.royaltyper
from titleauthor ta
inner join titles t on t.title_id = ta.title_id
inner join sales s on s.title_id=t.title_id)new_table
group by title_id, au_id);


select nt.au_id, a.au_lname, a.au_fname, sum(nt.somme + nt.advance) cash
from new_table5 nt
left join authors a
on nt.au_id=a.au_id
group by au_id
order by cash desc
limit 3;


select au_id, sum(somme+sales_advance) total_profit
from
(select title_id,au_id,sum(sales_royalty) as somme, sales_advance
from
(select ta.title_id, ta.au_id, t.price*s.qty*t.royalty*ta.royaltyper/10000 as sales_royalty, t.advance*ta.royaltyper/100 as sales_advance
from titleauthor ta
inner join titles t on t.title_id=ta.title_id
inner join sales s on s.title_id=ta.title_id
order by ta.title_id, ta.au_id) new_temporary
group by title_id,au_id) second_temporary
group by au_id
order by total_profit desc;

select sum(somme+sales_advance) as total_profits, au_id 
from
(select sum(sales_royalty) as somme, title_id, au_id, sales_advance
from
(select ta.title_id, ta.au_id, t.advance * ta.royaltyper / 100 as sales_advance, (t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) as sales_royalty
from titleauthor ta
inner join titles t on t.title_id = ta.title_id
inner join sales s on s.title_id=t.title_id) new_table
group by au_id, title_id) table2
group by au_id
order by total_profits desc;



use publications;

select t.title, ta.title_id, ta.au_id, round((t.advance * ta.royaltyper / 100),2) advance, round((t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100),2) sales_royalty,s.qty
from titleauthor ta
inner join titles t on t.title_id = ta.title_id
inner join sales s on s.title_id=t.title_id;

select * 
from sales;

select sum(sales_royalty), title, title_id, au_id
from(select t.title, ta.title_id, ta.au_id, round((t.advance * ta.royaltyper / 100),2) advance, round((t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100),2) sales_royalty, t.royalty royalty,t.price, s.qty,ta.royaltyper
from titleauthor ta
inner join titles t on t.title_id = ta.title_id
inner join sales s on s.title_id=t.title_id)new_table
group by au_id, title_id;

create temporary table if not exists new_table2
(select sum(sales_royalty) somme, title, title_id, au_id, advance
from(select t.title, ta.title_id, ta.au_id, round((t.advance * ta.royaltyper / 100),2) advance, round((t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100),2) sales_royalty, t.royalty royalty,t.price, s.qty,ta.royaltyper
from titleauthor ta
inner join titles t on t.title_id = ta.title_id
inner join sales s on s.title_id=t.title_id)new_table
group by au_id, title_id);

select *
from new_table2;

select nt.au_id, a.au_lname, a.au_fname, sum(nt.somme + nt.advance) cash
from new_table2 nt
left join authors a
on nt.au_id=a.au_id
group by au_id
order by cash desc
limit 3;

create temporary table new_temp(
select ta.title_id, ta.au_id, t.price*s.qty*t.royalty*ta.royaltyper/10000 as sales_royalty, t.advance*ta.royaltyper/100 as sales_advance
from titleauthor ta
inner join titles t on t.title_id=ta.title_id
inner join sales s on s.title_id=ta.title_id
order by ta.title_id, ta.au_id);
create temporary table second_temp
(select title_id,au_id,sum(sales_royalty) as ssr, sales_advance
from
new_temp
group by title_id,au_id);
select au_id, sum(ssr+sales_advance) total_profit
from second_temp
group by au_id
order by total_profit desc;

create table most_profiting_authors(
select au_id, sum(ssr+sales_advance) total_profit
from second_temp
group by au_id
order by total_profit desc);

select * from most_profiting_authors;
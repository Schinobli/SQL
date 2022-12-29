use curso

-- criando tabela temporaria
create table #minhatemporaria
(
	campo1 varchar(80) primary key not null,
	campo2 money not null
);

-- inserindo valores
insert into #minhatemporaria
	values ('Real', 1000);
insert into #minhatemporaria
	values ('Dolar', 3000);

-- selecionando valores 
select * from #minhatemporaria

-- criando tabela temporaria através de um select
select * into #minhatemporaria2 from #minhatemporaria

-- deletando tabela temporaria
drop table #minhatemporaria
drop table #minhatemporaria2

-- criando tabela temporaria através de um select
use curso 
select nome_mun into #cidadetemp from cidades

select * from #cidadetemp
drop table #cidadetemp





-- criando tabela de dimensão de datas

create table dim_data(
id_dim_data int identity(1,1) not null primary key,
data date not null,
ano smallint not null,
mes smallint not null,
dia smallint not null,
dia_semana smallint not null,
dia_ano smallint not null,
ano_bissexto char(1) not null,
dia_util char(1) not null,
fim_semana char(1) not null,
feriado char(1) not null,
nome_feriado varchar(30) null,
nome_dia_semana varchar(15) not null,
nome_dia_semana_abrev char(3) not null,
nome_mes varchar(15) not null,
nome_mes_abrev char(3) not null,
quinzena smallint not null,
bimestre smallint not null,
trimestre smallint not null,
semestre smallint not null,
nr_semana_mes smallint not null,
nr_semana_ano smallint not null,
estacao_ano varchar(15) not null,
data_por_extenso varchar(50) not null,
evento varchar(50) null
);

-- variavéis
declare 
	@datainicial date,
	@datafinal date,
	@data date,
	@ano smallint,
	@mes smallint,
	@dia smallint,
	@diasemana smallint,
	@diautil char(1),
	@fimsemana char(1),
	@feriado char(1),
	@preferiado char(1),
	@posferiado char(1),
	@nomeferiado varchar(30),
	@nomediasemana varchar(15),
	@nomediasemanaabrev char(3),
	@nomemes varchar(15),
	@nomemesabrev char(3),
	@bimestre smallint,
	@trimestre smallint,
	@nrsemanames smallint,
	@nrsemanaano smallint,
	@estacaoano varchar(15),
	@dataporextenso varchar(50)


-- Período para qual deseja criar os dados
set @datainicial = '01/01/2012'
set @datafinal = '31/12/2030'

while @datainicial <= @datafinal
begin
set @data = @datainicial
set @ano = year(@data)
set @mes = month(@data)
set @dia = day(@data)
set @diasemana = datepart(weekday, @data)
set @nomemes = lower(datename(month, @data))
set @nomemesabrev = lower(substring(datename(month, @data), 1, 3))
set @nomediasemana = lower(datename(weekday, @data))
set @nomediasemanaabrev = lower(substring(datename(weekday, @data), 1, 3))

	/* Feriados locais/regionais e aqueles que não possuem data fixa (carnaval, páscoa e corpus cristis)
	também podem ser adicionados */

	if (@mes = 1 and @dia = 1) or (@mes = 12 and @dia = 31)
set @nomeferiado = 'confraternização universal'
	else
	if (@mes = 4 and @dia = 21)
set @nomeferiado = 'tiradentes'
	else
	if (@mes = 5 and @dia = 1)
set @nomeferiado = 'dia do trabalho'
	else
	if (@mes = 9 and @dia = 7)
set @nomeferiado = 'independência do brasil'
	else
	if (@mes = 10 and @dia = 12)
set @nomeferiado = 'nossa senhora de aparecida'
	else
	if (@mes = 11 and @dia = 2)
set @nomeferiado = 'dia de finados'
	else
	if (@mes = 11 and @dia = 15)
set @nomeferiado = 'proclamação da república'
	else
	if (@mes = 12 and @dia = 25)
set @nomeferiado = 'dia de natal'
	else set @nomeferiado = null

	if (@nomeferiado is null)
set @feriado = 'N'
	else set @feriado = 'S'
	
	if @diasemana in (1,7)
set @fimsemana = 'S'
	else set @fimsemana = 'N'

	if @fimsemana = 'S' or @feriado = 'S'
set @diautil = 'N'
	else set @diautil = 'S'

set @bimestre =
case
	when @mes in (1, 2) then 1
	when @mes in (3, 4) then 2
	when @mes in (5, 6) then 3
	when @mes in (7, 8) then 4
	when @mes in (9, 10) then 5
	else 6
end

set @trimestre =
case
	when @mes in (1, 2, 3) then 1
	when @mes in (4, 5, 6) then 2
	when @mes in (7, 8, 9) then 3
	else 4
end

set @nrsemanames =
case
	when @dia < 8 then 1
	when @dia < 15 then 2
	when @dia < 22 then 3
	when @dia < 29 then 4
	else 5
end

/* 
  Estações do ano no Brasil:
  20 Mar - outono
  21 Jun - inverno
  22 Set - primavera
  21 Dez - verao
*/

if @data between cast('23/09/'+convert(char(4), @ano) as date) and cast('20/12/'+convert(char(4), @ano) as date)
set @estacaoano = 'primavera'
else if @data between cast('21/03/'+convert(char(4), @ano) as date) and cast('20/06/'+convert(char(4), @ano) as date)
set @estacaoano = 'outono'
else if @data between cast('21/06/'+convert(char(4), @ano) as date) and cast('22/09/'+convert(char(4), @ano) as date)
set @estacaoano = 'inverno'
-- @data entre 21/12 e 20/03
else set @estacaoano = 'verão'

-- inserção dos valores
insert into dim_data
	select
		@data
	   ,@ano
	   ,@mes
	   ,@dia
	   ,@diasemana
	   ,datepart(dayofyear, @data) -- dia ano
	   ,case
			when (@ano % 4) = 0 then 'S'
			else 'N'
		end -- ano bissexto
	   ,@diautil
	   ,@fimsemana
	   ,@feriado
	   ,@nomeferiado
	   ,@nomediasemana
	   ,@nomediasemanaabrev
	   ,@nomemes
	   ,@nomemesabrev
	   ,case
			when @dia < 16 then 1
			else 2
		end -- quinzena
	   ,@bimestre
	   ,@trimestre
	   ,case
			when @mes < 7 then 1
			else 2
		end -- semestre
	   ,@nrsemanames
	   ,datepart(wk, @data) -- nrsemanaano
	   ,@estacaoano
	   ,lower(@nomediasemana + ', ' + cast(@dia as varchar) + ' de ' + @nomemes + ' de ' + cast(@ano as varchar)) -- data por extenso
	   ,null -- evento
set @datainicial = dateadd(day, 1, @datainicial)
end

-- verificação de uma data com feriado.
select
	*
from dim_data
where data = '01/05/2026'
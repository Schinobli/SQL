use curso
/*
create table produto
(
cod nvarchar(5),
nome nvarchar(20)
);
*/

-- exemplo de bulk insert
bulk insert produto
from 'C:\Users\lucas\OneDrive\Documentos\SQL Server Management Studio\carga\produto.txt'
with (
	codepage='ACP', -- OU 1252
	datafiletype='widechar',
	fieldterminator='|',
	rowterminator='\n',
	maxerrors=0,
	fire_triggers,
	firstrow=1,
	lastrow=10
);

-- Se der problema de caracteres, modificar o encolding

select
	nome
from produto;
delete from produto;

select * into clientes2 from clientes
truncate table clientes2

select * from clientes2
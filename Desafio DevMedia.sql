-- https://www.devmedia.com.br/desafio-sql/1476
-- usando base curso
use curso
-- criando tabelas 
create table clientes_desafio (
codigo int identity(1,1) not null primary key,
nome varchar (50) not null
);

create table telefones_desafio (
codigo int identity(1,1) not null primary key,
tipo char(3) not null,
fone varchar(11) not null,
codigo_cliente int not null,
foreign key (codigo_cliente) references clientes_desafio(codigo));

-- inserindo valores de clientes e telefones ficticios
insert into clientes_desafio (nome)
	values ('Pedro Antonio');
insert into clientes_desafio (nome)
	values ('Pedro José');
insert into clientes_desafio (nome)
	values ('Maria Assis');
insert into clientes_desafio (nome)
	values ('Joana de Andrade');
insert into clientes_desafio (nome)
	values ('Margarete Josivalda');

insert into telefones_desafio (tipo, fone, codigo_cliente)
	values ('RES', '4632252693', 1);
insert into telefones_desafio (tipo, fone, codigo_cliente)
	values ('CEL', '38992536581', 1);
insert into telefones_desafio (tipo, fone, codigo_cliente)
	values ('CEL', '45991147585', 3);
insert into telefones_desafio (tipo, fone, codigo_cliente)
	values ('CEL', '46992453658', 2);
insert into telefones_desafio (tipo, fone, codigo_cliente)
	values ('CEL', '55991253614', 4);
insert into telefones_desafio (tipo, fone, codigo_cliente)
	values ('FAX', '6636258457', 2);
insert into telefones_desafio (tipo, fone, codigo_cliente)
	values ('FAX', '4622456585', 3);

-- Mostrar telefones de cada pessoa 

select
	cd.nome
	,td_res.fone as residencial
   	,td_cel.fone as celular
  	,td_fax.fone as fax
from clientes_desafio cd
left join telefones_desafio td_res
	on td_res.codigo_cliente = cd.codigo
		and td_res.tipo = 'RES'
left join telefones_desafio td_cel
	on td_cel.codigo_cliente = cd.codigo
		and td_cel.tipo = 'CEL'
left join telefones_desafio td_fax
	on td_fax.codigo_cliente = cd.codigo
		and td_fax.tipo = 'FAX'
order by 1


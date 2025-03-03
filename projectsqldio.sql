-- criação do banco de dados para o cenário de E-commerce 
create database ecommerce1;
use ecommerce1;

-- criar tabela cliente
create table clients(
		idClient int auto_increment primary key,
        Fname varchar(10),
        Minit char(3),
        Lname varchar(20),
        Address varchar(255)
);

create table PF(
		idPF int auto_increment primary key,
        idClientPF int,
        CPF char(11) not null,
        constraint unique_cpf_client unique (CPF),
        constraint fk_client_pf foreign key (idClientPF) references clients(idClient)
);

alter table PF auto_increment=1;

create table PJ(
		idPJ int auto_increment primary key,
        idClientPJ int,
        CNPJ char(11) not null,
        Nomefantasia varchar(255),
        constraint unique_cnpj_client unique (CNPJ),
        constraint fk_client_pj foreign key (idClientPJ) references clients(idClient)
);

alter table PJ auto_increment=1;

alter table clients auto_increment=1;

-- desc clients;
-- criar tabela produto

-- size = dimensão do produto
create table product(
		idProduct int auto_increment primary key,
        Pname varchar(255) not null,
        classification_kids bool default false,
        category enum('Eletrônico','Vestimenta','Brinquedos','Alimentos','Móveis') not null,
        avaliação float default 0,
        size varchar(10)
);

alter table product auto_increment=1;


-- para ser continuado no desafio: termine de implementar a tabela e crie a conexão com as tabelas necessárias
-- além disso, reflita essa modificação no diagrama de esquema relacional
-- criar constraints relacionadas ao pagamento

create table payments(
    idPayment int auto_increment primary key,
    typePayment enum('Boleto','Cartão','Dois cartões'),
    limitAvailable float,
    Agency varchar (29)
);

alter table payments auto_increment=1;

create table paymentOrder(
	idPaymentOrder int,
    idPaymentPayment int,
    paymentQuantity int,
    paymentValue int,
    primary key(idPaymentOrder, idPaymentPayment),
	constraint fk_payment_order foreign key (idPaymentOrder) references orders(idOrder),
    constraint fk_payment_payment foreign key (idPaymentPayment) references payments(idPayment)
);

create table send(
	idSend int auto_increment primary key,
    Adress varchar(255),
	sendValue float default 10,
    paymentCash boolean default false,
    trackingCode char(20),
    sendStats enum("Enviado","Entregue","Aguardando")
);

alter table send auto_increment=1;

-- criar tabela pedido
-- drop table orders;
create table orders(
	idOrder int auto_increment primary key,
    idOrderPJ int,
    idOrderPF int,
    idOrderSend int,
    orderStatus enum('Cancelado','Confirmado','Em processamento') default 'Em processamento',
    orderDescription varchar(255),
    constraint fk_client_order_pf foreign key (idOrderPF) references PF(idPF),
    constraint fk_client_order_pj foreign key (idOrderPJ) references PJ(idPJ),
    constraint fk_order_send foreign key (idOrderSend) references send(idSend)
			on update cascade
);

alter table orders auto_increment=1;

desc orders;

-- criar tabela estoque
create table productStorage(
	idProdStorage int auto_increment primary key,
    storageLocation varchar(255),
    quantity int default 0
);

alter table productStorage auto_increment=1;


-- criar tabela fornecedor
create table supplier(
	idSupplier int auto_increment primary key,
    SocialName varchar(255) not null,
    CNPJ char(15) not null,
    contact char(11) not null,
    constraint unique_supplier unique (CNPJ)
);

alter table supplier auto_increment=1;

desc supplier;

-- criar tabela vendedor
create table seller(
	idSeller int auto_increment primary key,
    SocialName varchar(255) not null,
    AbstName varchar(255),
    CNPJ char(15),
    CPF char(9),
    location varchar(255),
    contact char(11) not null,
    constraint unique_cnpj_seller unique (CNPJ),
    constraint unique_cpf_seller unique (CPF)
);

alter table seller auto_increment=1;


-- tabelas de relacionamentos M:N

create table productSeller(
	idPseller int,
    idPproduct int,
    prodQuantity int default 1,
    primary key (idPseller, idPproduct),
    constraint fk_product_seller foreign key (idPseller) references seller(idSeller),
    constraint fk_product_product foreign key (idPproduct) references product(idProduct)
);

desc productSeller;

create table productOrder(
	idPOproduct int,
    idPOorder int,
    poQuantity int default 1,
    poStatus enum('Disponível', 'Sem estoque') default 'Disponível',
    primary key (idPOproduct, idPOorder),
    constraint fk_productorder_product foreign key (idPOproduct) references product(idProduct),
    constraint fk_productorder_order foreign key (idPOorder) references orders(idOrder)
);

create table storageLocation(
	idLproduct int,
    idLstorage int,
    location varchar(255) not null,
    primary key (idLproduct, idLstorage),
    constraint fk_storage_location_product foreign key (idLproduct) references product(idProduct),
    constraint fk_storage_location_storage foreign key (idLstorage) references productStorage(idProdStorage)
);

create table productSupplier(
	idPsSupplier int,
    idPsProduct int,
    quantity int not null,
    primary key (idPsSupplier, idPsProduct),
    constraint fk_product_supplier_supplier foreign key (idPsSupplier) references supplier(idSupplier),
    constraint fk_product_supplier_prodcut foreign key (idPsProduct) references product(idProduct)
);

show tables;

desc productSupplier;

show tables;

show databases;
use information_schema;
show tables;
desc referential_constraints;
select * from referential_constraints where constraint_schema = 'ecommerce';
-- inserção de dados e queries

use ecommerce;

show tables;
-- idClient, Fname, Minit, Lname, CPF, Address
insert into Clients (Fname, Minit, Lname, Address) 
	   values('Maria','M','Silva', 'rua silva de prata 29, Carangola - Cidade das flores'),
		     ('Matheus','O','Pimentel','rua alemeda 289, Centro - Cidade das flores'),
			 ('Ricardo','F','Silva','avenida alemeda vinha 1009, Centro - Cidade das flores'),
			 ('Julia','S','França','rua lareijras 861, Centro - Cidade das flores'),
			 ('Roberta','G','Assis','avenidade koller 19, Centro - Cidade das flores'),
			 ('Isabela','M','Cruz','rua alemeda das flores 28, Centro - Cidade das flores');
             
insert into Clients (Fname, Minit, Lname, Address) values ('Ana','B','Silva','rua alemeda 28, Centro - Cidade das flores');


Select * from clients;

Desc PF;

insert into PF(idClientPF, CPF) values (1,12346789121);

insert into PF(idClientPF, CPF) values
(2,98765432121),
(3,45678913451),
(4,78912345668),
(5,98745631991),
(6,65478912378);

insert into PJ(idClientPj, CNPJ) values (7, 12345678911);

SELECT * FrOM PJ;

desc product;

insert into product (Pname, classification_kids, category, avaliação, size) values
							  ('Fone de ouvido',false,'Eletrônico','4',null),
                              ('Barbie Elsa',true,'Brinquedos','3',null),
                              ('Body Carters',true,'Vestimenta','5',null),
                              ('Microfone Vedo - Youtuber',False,'Eletrônico','4',null),
                              ('Sofá retrátil',False,'Móveis','3','3x57x80'),
                              ('Farinha de arroz',False,'Alimentos','2',null),
                              ('Fire Stick Amazon',False,'Eletrônico','3',null);
delete from orders where idOrderClient in  (1,2,3,4);

desc orders;

delete from orders where idOrderPF in  (1,2,3,4);

insert into orders (idOrderPF, idOrderSend, orderStatus, orderDescription) values 
							 (1,2, default,'compra via aplicativo'),
                             (2,3,default,'compra via aplicativo'),
                             (3,4,'Confirmado',null);
                             
insert into orders (idOrderPJ, idOrderSend, orderStatus, orderDescription) values 
							 (1,5, default,'compra via aplicativo');

Select * from orders;
        
        
 desc send;                            
insert into send (Adress, sendValue, paymentCash, trackingCode, sendStats) values ("Endereço1", 10,true,11111111111111111111,"Entregue"),
("Endereço2", 11,false,11111111111111111112,"Enviado"),
("Endereço3", 14,true,11111111111111111113,"Aguardando"),
("Endereço4", 15,false,11111111111111111114,"Entregue"),
("Endereço5", 12,true,11111111111111111115,"Entregue");

desc productOrder;

insert into productOrder (idPOproduct, idPOorder, poQuantity, poStatus) values
						 (1,8,2,null),
                         (2,9,1,null),
                         (3,14,1,null);
                         
insert into productStorage (storageLocation,quantity) values 
							('Rio de Janeiro',1000),
                            ('Rio de Janeiro',500),
                            ('São Paulo',10),
                            ('São Paulo',100),
                            ('São Paulo',10),
                            ('Brasília',60);

insert into storageLocation (idLproduct, idLstorage, location) values
						 (1,2,'RJ'),
                         (2,6,'GO');

insert into supplier (SocialName, CNPJ, contact) values 
							('Almeida e filhos', 123456789123456,'21985474'),
                            ('Eletrônicos Silva',854519649143457,'21985484'),
                            ('Eletrônicos Valma', 934567893934695,'21975474');

insert into productSupplier (idPsSupplier, idPsProduct, quantity) values
						 (1,1,500),
                         (1,2,400),
                         (2,4,633),
                         (3,3,5),
                         (2,5,10);

insert into seller (SocialName, AbstName, CNPJ, CPF, location, contact) values 
						('Tech eletronics', null, 123456789456321, null, 'Rio de Janeiro', 219946287),
					    ('Botique Durgas',null,null,123456783,'Rio de Janeiro', 219567895),
						('Kids World',null,456789123654485,null,'São Paulo', 1198657484);
insert into productSeller (idPseller, idPproduct, prodQuantity) values 
						 (1,6,80),
                         (2,7,10);

Desc paymentOrder;

insert into payments (typePayment, limitAvailable) values ("Boleto", 5000),
("Cartão", 3000),
("Cartão", 2000),
("Dois Cartões", 6000),
("Boleto", 7000);

Select * from payments;
select * from orders;

insert into paymentOrder (idPaymentPayment, idPaymentOrder,PaymentQuantity, PaymentValue) values 
(6,8,1,1000),
(7,9,1,2000),
(8,10,1,3000),
(9,14,1,4000);

-- pedidos por cliente

Select * from PF;
Select * from orders;
Select count(*) quant_pedidos, fname from orders join PF on idOrderPF = idPF join Clients on idClient = idPF group by CPF;

-- vendedor é fornecedor também?

Select * from seller;
Select * from supplier;

Select * from seller S join supplier sp on idSeller = idSupplier where s.CNPJ = sp.CNPJ;

-- relação prod, supplier, storage

Desc product;
Desc productsupplier;
Desc supplier;
desc productstorage;
Desc storageLocation;

select * from storagelocation;

Select * from product join productsupplier on idProduct = idPsProduct join supplier on idSupplier = idPsSupplier
left join storageLocation on idLproduct = idProduct left join productstorage on idProdStorage = idLstorage;
;

-- fornecedor e nome de produto

Select * from product join productsupplier on idProduct = idPsProduct join supplier on idSupplier = idPsSupplier;

-- filtrando agrupando

Select category, sum(quantity) as quantidade from product join productsupplier on idProduct = idPsProduct join supplier on idSupplier = idPsSupplier 
where avaliação between 3 and 4
group by category
having quantidade >10
Order by quantidade;



--TP 04 - DML - Views & Fun��es de Oracle

-- Criar Tabelas do Exemplo

create table cliente(
 cod_cliente int constraint pk_cliente primary key,
 nome varchar(20) not null,
 morada varchar(50),
 telefone varchar(15));

create table agencia(
 cod_agencia int constraint pk_agencia primary key,
 nome varchar(20));

create table conta(
 num_conta char(10) constraint pk_conta primary key,
 cod_agencia int not null constraint fk_conta_agencia 
                      references agencia(cod_agencia),
 cod_cliente int not null constraint fk_conta_cliente 
                      references cliente(cod_cliente),
 saldo numeric(10, 2) not null);

-- Inserir dados nas tabelas 
 
insert into cliente (cod_cliente, nome) values(1, 'A1');
insert into cliente (cod_cliente, nome) values(2, 'B1');
insert into cliente (cod_cliente, nome) values(3, 'C1');

insert into agencia (cod_agencia, nome) values(1, 'AgA1');
insert into agencia (cod_agencia, nome) values(2, 'AgB1');
insert into agencia (cod_agencia, nome) values(3, 'AgC1');

insert into conta (num_conta, cod_cliente, cod_agencia, saldo) values (1, 1, 1, 12000);
insert into conta (num_conta, cod_cliente, cod_agencia, saldo) values (2, 1, 2, 8000);
insert into conta (num_conta, cod_cliente, cod_agencia, saldo) values (3, 2, 1, 1000);
insert into conta (num_conta, cod_cliente, cod_agencia, saldo) values (4, 3, 3, 16000);
insert into conta (num_conta, cod_cliente, cod_agencia, saldo) values (5, 3, 2, 10000);
insert into conta (num_conta, cod_cliente, cod_agencia, saldo) values (6, 3, 1, 500);

-- Suponhamos o seguinte conceito existente no nosso sistema:
-- Os "Super clientes" s�o aqueles cujo saldo individual de pelo menos uma das suas contas 
-- � superior ao saldo m�dio das contas do banco
-- H� interesse em ter uma tabela que indique quais s�o os "Super clientes".
-- A informa��o necess�ria � o c�digo, nome e saldo total (todas as suas contas)

-- Exemplo Solu��o--
select a.cod_cliente, a.nome, sum(b.saldo)
  from cliente a, conta b
 where a.cod_cliente = b.cod_cliente
   and a.cod_cliente in (select a.cod_cliente
                           from cliente a, conta b
                          where a.cod_cliente = b.cod_cliente
                            and b.saldo > (select avg(saldo) from conta))
 group by a.cod_cliente, a.nome;
 
-- Cria��o da view

create or replace view "Super clientes" as
select a.cod_cliente, a.nome, sum(b.saldo) saldo_total
  from cliente a, conta b
 where a.cod_cliente = b.cod_cliente
   and a.cod_cliente in (select a.cod_cliente
                          from cliente a, conta b
                          where a.cod_cliente = b.cod_cliente
                          and b.saldo > (select avg(saldo) from conta))
 group by a.cod_cliente, a.nome;

-- Para usar a View--

select * from "Super clientes";

-- O nosso modelo de dados passou a ser:
-- cliente(cod_cliente, nome, morada, telefone)
-- agencia(cod_agencia, nome)
-- conta(num_conta, cod_agencia, cod_cliente, saldo)
-- "Super clientes"(cod_cliente, nome, saldo_total)

-- � poss�vel o utilizador aceder a defini��o da view. 
-- Para o evitar podemos usar uma op��o de read only:

create view "Super clientes read only" as
select a.cod_cliente, a.nome, sum(b.saldo) saldo_total
  from cliente a, conta b
 where a.cod_cliente = b.cod_cliente
   and a.cod_cliente in (select a.cod_cliente
                          from cliente a, conta b
                          where a.cod_cliente = b.cod_cliente
                          and b.saldo > (select avg(saldo) from conta))
 group by a.cod_cliente, a.nome
 with read only;
 
 -- ***************************************
 -- Exemplo de alterar dados numa view
 
create view v_cliente as
  select cod_cliente, nome, morada from cliente;

-- Podemos inserir dados nas views

insert into v_cliente values(4, 'D1', 'Rua X');

-- Tamb�m podemos eliminar ou alterar registos...

update v_cliente set morada = 'Rua Y' 
	where cod_cliente = 4;

delete from v_cliente 
    where cod_cliente = 4;
  
-- ***********************************        
-- Exemplo de alterar dados numa view read only

create view v_cliente_read as
  select cod_cliente, nome, morada from cliente
  with read only;

-- N�o Podemos inserir dados nas views read only
insert into v_cliente_read values(4, 'D1', 'Rua X');

-- Tamb�m n�o podemos eliminar ou alterar registos...
update v_cliente_read set morada = 'Rua Y' where cod_cliente = 3;
delete from v_cliente_read where cod_cliente = 3;     

-- *************************************    
-- E se tiver v�rias tabelas e tiver informa��o agregada?

delete from "Super clientes" where cod_cliente = 3; 
-- obtemos mensagem de erro na View 

-- *************************************    
-- E se tiver v�rias tabelas e n�o tiver informa��o agregada?

create or replace view v_clienteconta as
select a.cod_cliente, a.nome, a.morada, a.telefone, b.num_conta, 
    b.cod_agencia, b.saldo
  from cliente a, conta b
 where a.cod_cliente = b.cod_cliente;
 
insert into v_clienteconta
  (cod_cliente, nome, morada, telefone, num_conta, cod_agencia, saldo)
values  (1, 'A2', 'Morada X', '22-1234567', 7, 1, 0);

-- Iremos obter Msg para a View or function 'v_clienteconta' 
-- N�o houve problema porque n�o � poss�vel inserir registos

--No entanto � poss�vel alterar parte da informa��o.

update v_clienteconta
   set cod_agencia = 3
 where cod_cliente = 1 and num_conta = 2;
 
-- � poss�vel alterar a tabela conta

update v_clienteconta
   set saldo = saldo + 10
 where cod_cliente = 1 and num_conta = 2;

-- Mas n�o � poss�vel alterar simultaneamente as tabelas cliente e conta.
update v_clienteconta
   set morada = 'xx', saldo = saldo + 10
 where cod_cliente = 1 and num_conta = 2;
-- obtemos Msg de erro  
-- View or function 'v_clienteconta' is not updatable 

-- � poss�vel apagar registos com as condi��es de join 
delete from v_clienteconta
 where cod_cliente = 3 and num_conta = 4;
delete from v_clienteconta
 where cod_cliente = 3 and cod_agencia = 1; 

--***********************
-- Fun��es de Oracle
--***********************
-- What is a DUAL Table in Oracle? 
-- This is a single row and single column dummy table provided by oracle. 
-- This is used to perform mathematical calculations without using a table. 
Select * from DUAL; 

Select 777 * 888 from Dual;

--**********************************
-- TO_CHAR (date, �format_model�) 
-- Converte uma data para uma string usando o formato especificado

select to_char(sysdate,'YYYY-MM-DD') from dual;

select TO_CHAR (3000, '$9999')from dual;

select TO_CHAR (SYSDATE, 'Day, Month YYYY')from dual;

-- *************************************
-- TO_DATE (char [, �format_model�]) 
-- Converte uma string  para um  formato de data

select to_date('2018/09/29 12:15:10', 'YYYY/MM/DD HH:MI:SS') from dual;

select TO_DATE ('01-Jun-08')from dual;

-- ****************************************
-- TO_EXTRACT
-- Permite extrair um valor a partir de uma  data ou intervalo. 
-- select EXTRACT (
-- { YEAR | MONTH | DAY | HOUR | MINUTE | SECOND }
-- | { TIMEZONE_HOUR | TIMEZONE_MINUTE }
-- | { TIMEZONE_REGION | TIMEZONE_ABBR }
-- FROM { date_value | interval_value } );

-- Exemplos Extract
SELECT EXTRACT(YEAR FROM DATE '2003-08-22') FROM dual;
-- Resultado: 2003

SELECT EXTRACT(DAY FROM DATE '2011-01-12') FROM dual;
-- Resultado: 12

SELECT EXTRACT(HOUR FROM SYSDATE) FROM dual;
-- ERROR at line 1:
-- ORA-30076: invalid extract field for extract source

SELECT EXTRACT(HOUR FROM TIMESTAMP '2012-01-12 10:11:00') FROM dual;
-- Resultado: 10

select extract(day from sysdate) as only_day from dual;
-- dia atual

select extract(month from sysdate) as only_month from dual;
-- m�s atual

select extract(year from sysdate) as only_year from dual;
-- ano atual

-- **************
-- ADD / LAST 
-- **************
Select add_months(sysdate, -1) as prev_month , sysdate, add_months (sysdate, 1) 
as next_month from dual;
-- m�s anterior - m�s atual - pr�ximo m�s para o mesmo dia

select sysdate, last_day(sysdate) as last_day_curr_month,
last_day(sysdate) + 1 as first_day_next_month from dual;
-- �ltimo dia do m�s anterior e primeiro dia do m�s seguinte

select last_day(sysdate) - sysdate as days_left from dual;
-- dias em falta para terminar o m�s

--******************************
--ABS: Absolute value of the number
SELECT ABS(12) FROM DUAL;
--ABS(12)
--output: 12

--CEIL: Integer value that is Greater than or equal to the number
SELECT CEIL(48.99) FROM DUAL;
--CEIL(48.99)
-----------
--output: 49

SELECT CEIL(48.11) FROM DUAL;
--CEIL(48.11)
-----------
--output: 49

--FLOOR: Integer value that is Less than or equal to the number
SELECT FLOOR(49.99) FROM DUAL;
--FLOOR(49.99)
------------
--output: 49

SELECT FLOOR(49.11) FROM DUAL;
--FLOOR(49.11)
------------
--output: 49

--ROUND: Rounded off value of the number 'x' up to the number 'y' decimal places
SELECT ROUND(49.11321,2) FROM DUAL;
--ROUND(49.11321,2)
-----------------
--output: 49.11

SELECT ROUND(49.11321,3) FROM DUAL;
--ROUND(49.11321,3)
-----------------
--output: 49.113

SELECT ROUND(49.11321,4) FROM DUAL;
--ROUND(49.11321,4)
-----------------
--output: 49.1132 

--Few other functions,
--POWER
SELECT POWER(4,2) FROM DUAL;
--POWER(4,2)
----------
--output: 16

--MOD
SELECT MOD(4,2) FROM DUAL;
--MOD(4,2)
---------
--output: 0

SELECT SIGN(-98) FROM DUAL;
--SIGN(-98)
---------
--output: -1
SELECT SIGN(98) FROM DUAL;
--SIGN(98)
---------
--output: 1

/*****************************
--Character String: 
*****************************/

--Function 1: UPPER Purpose : Returns the string in uppercase 
--Syntax : UPPER(�str�) 
--Example : 
SELECT UPPER('karuvachi') from Dual; 
--Output:KARUVACHI  

--Function 2: lower Purpose : Returns the string in lowercase 
--Syntax : lower(�str�) 
--Example : 
SELECT LOWER('KaRuVaChi') FROM DUAL; 
--Output:karuvachi  

--Function 3: Initcap Purpose : Returns the string with first letter in uppercase 
--and rest of the letters in lowercase 
--Syntax : Initcap(�str�) 
--Example : 
SELECT Initcap('KaRuVaChi') FROM DUAL; 
--Output:Karuvachi 

--Function 4: Concat Purpose : Concatenate two strings 
--Syntax : concat(�str1?,�str2�) 
--Example : 
SELECT CONCAT('Karu','Nand') FROM DUAL; 
--Output:KaruNand  

--Function 5: Lpad Purpose : Pad in the left side of the string for given times � 
--length of the string 
--Syntax : Lpad(�str1?,n,�str2�) 
--Example : 
SELECT Lpad('Karu',6,'?') FROM DUAL; 
--Output:??Karu  

--Function 6: Rpad Purpose : Pad in the right side of the string for given times  
--length of the string 
--Syntax : Rpad(�str1?,n,�str2�) 
--Example : 
SELECT Rpad('Karu',6,'?') FROM DUAL; 
--Output:Karu?? 

--Function 7: trim Purpose : Trim the whitespaces in both the sides of the string 
--Syntax : trim(�str�) 
-- Example : 
SELECT TRIM(' karu ') FROM DUAL; 
--Output:karu  

--Function 8: Ltrim Purpose : Trim the whitespaces in left the side of the string 
--Syntax : Ltrim(�str�) 
--Example : 
SELECT LTRIM(' karu ') FROM DUAL; 
--Output:karu�.(. dot are spaces)  

--Function 9: Rtrim
--Purpose : Trim the whitespaces in right the side of the string 
--Syntax : Rtrim(�str�) 
--Example : 
SELECT RTRIM(' karu ') FROM DUAL; 
--Output:�.karu(. dot are spaces) 

--Function 10: Length Purpose : length of the string 
--Syntax : length(�str�) 
--Example : 
SELECT LENGTH('karuvachi') FROM DUAL; 
--Output:9 

--Function 11: Instr Purpose : Find the position of the string in another string 
-- Syntax : Instr(�str1?,�str2�) 
--Example : 
SELECT INSTR('karuvachi','ka') FROM DUAL; 
--Output:1  

--Function 12: substr Purpose : get a sub string from string 
--Syntax : substr(�str�,start_pos,number_of_chars) 
--Example : 
SELECT substr('karuvachi',2,4) FROM DUAL; 
--Output: aruv





    

 

 



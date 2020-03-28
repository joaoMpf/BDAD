--**************** EXERCICIO TRIGGER TP10*************************************

-- Criar um Trigger na tabela Encomenda para gerar de forma automática a
-- fatura de cada encomenda atraves da mudança de estado de encomenda não 
-- facturada (FACTURADA = 0)para encomenda facturada (FACTURADA = 1).
-- Para cada fatura criar as respectivas linhas de factura por cada artigo
-- dessa encomenda.
-- No caso dum cliente com várias encomemdas por facturar, alterar o estado
-- de cada encomenda para FACTURADA = 1 e criar as faturas e respectivas
-- linhas de fatura. 

--****************************************************************************

--script para eliminar todas as tabelas já criadas - drop all

begin
for r in (select 'drop table ' || table_name || ' cascade constraints' cmd from user_tables) 
  loop
    execute immediate r.cmd;
  end loop;
end;
----------

--************* Criação de tabelas **************
--** CLIENTE - TIPO - MEDIDA - FORNECDOR - ARTIGO - ENCOMENDA - ENCOMENDA_ARTIGO
--** FACTURA - LINHA DE FACTURA

CREATE TABLE CLIENTE 
   (	ID_CLIENTE VARCHAR2(200) NOT NULL ENABLE, 
	NOME VARCHAR2(50) NOT NULL ENABLE, 
	MORADA VARCHAR2(200) NOT NULL ENABLE, 
	CONTRIBUINTE VARCHAR2(9) NOT NULL ENABLE
   ) ;
  ALTER TABLE CLIENTE ADD CONSTRAINT PK_CLIENTE PRIMARY KEY (ID_CLIENTE) ENABLE;

CREATE TABLE ENCOMENDA 
   (	ID_ENCOMENDA NUMBER(*,0) NOT NULL ENABLE, 
      ID_CLIENTE VARCHAR2(200) NOT NULL ENABLE,
      DATA_ENC DATE NOT NULL ENABLE,
      FACTURADA NUMBER(1,0) NOT NULL ENABLE
    ) ;
  ALTER TABLE ENCOMENDA ADD CONSTRAINT PK_ENCOMENDA PRIMARY KEY (ID_ENCOMENDA) ENABLE;
  ALTER TABLE ENCOMENDA ADD CONSTRAINT FK_ENCOMENDA_ID_CLIENTE FOREIGN KEY (ID_CLIENTE)
	  REFERENCES CLIENTE (ID_CLIENTE) ENABLE;
    
CREATE TABLE MEDIDA 
   (	COD_MEDIDA NUMBER(*,0) NOT NULL ENABLE, 
      DESCRICAO VARCHAR2(50) NOT NULL ENABLE
    ) ;
  ALTER TABLE MEDIDA ADD CONSTRAINT PK_MEDIDA PRIMARY KEY (COD_MEDIDA) ENABLE;   
  
CREATE TABLE FORNECEDOR 
   (	COD_FORNECEDOR NUMBER(*,0) NOT NULL ENABLE, 
      NOME VARCHAR2(50) NOT NULL ENABLE
    ) ;
  ALTER TABLE FORNECEDOR ADD CONSTRAINT PK_FORNECEDOR PRIMARY KEY (COD_FORNECEDOR) ENABLE;  
  
CREATE TABLE ARTIGO 
   (	COD_ARTIGO NUMBER(*,0) NOT NULL ENABLE, 
      DESCRICAO VARCHAR2(100) NOT NULL ENABLE,  
      COD_FORNECEDOR NUMBER(9,0) NOT NULL ENABLE,  
      COD_MEDIDA NUMBER(9,0) NOT NULL ENABLE,
      STOCK NUMBER (4,0) NOT NULL ENABLE,
      PRECO NUMBER(4,2) NOT NULL ENABLE, 
      TAXA_IVA NUMBER(4,2) NOT NULL ENABLE
    ) ;
  ALTER TABLE ARTIGO ADD CONSTRAINT PK_ARTIGO PRIMARY KEY (COD_ARTIGO) ENABLE;
  ALTER TABLE ARTIGO ADD UNIQUE (DESCRICAO) ENABLE;
  ALTER TABLE ARTIGO ADD CONSTRAINT FK_ARTIGO_FORNECEDOR FOREIGN KEY (COD_FORNECEDOR)
	  REFERENCES FORNECEDOR (COD_FORNECEDOR) ENABLE;
  ALTER TABLE ARTIGO ADD CONSTRAINT FK_ARTIGO_MEDIDA FOREIGN KEY (COD_MEDIDA)
	  REFERENCES MEDIDA (COD_MEDIDA) ENABLE;  
 
CREATE TABLE ENCOMENDA_ARTIGO 
   (	ID_ENCOMENDA NUMBER(*,0) NOT NULL ENABLE, 
      COD_ARTIGO NUMBER(*,0) NOT NULL ENABLE,
      QUANTIDADE INTEGER NOT NULL ENABLE
    ) ;
  ALTER TABLE ENCOMENDA_ARTIGO ADD CONSTRAINT ENCOMENDA_ARTIGO_PK PRIMARY KEY 
    (ID_ENCOMENDA, COD_ARTIGO) ENABLE;
  ALTER TABLE ENCOMENDA_ARTIGO ADD CONSTRAINT ENCOMENDA_ARTIGO_ENCOMENDA FOREIGN KEY 
    (ID_ENCOMENDA)
	  REFERENCES ENCOMENDA (ID_ENCOMENDA) ENABLE;
  ALTER TABLE ENCOMENDA_ARTIGO ADD CONSTRAINT ENCOMENDA_ARTIGO_ARTIGO FOREIGN KEY (COD_ARTIGO)
	  REFERENCES ARTIGO (COD_ARTIGO) ENABLE;
 
CREATE TABLE FACTURA 
   (	COD_FACTURA NUMBER(*,0) NOT NULL ENABLE, 
      ID_CLIENTE VARCHAR2(200) NOT NULL ENABLE, 
      ID_ENCOMENDA NUMBER(*,0) NOT NULL ENABLE,
      DATA_FACT DATE NOT NULL ENABLE,
      VALOR_SEM_IVA NUMBER NOT NULL ENABLE, 
      VALOR_IVA NUMBER NOT NULL ENABLE, 
      TOTAL NUMBER NOT NULL ENABLE
    ) ;
  ALTER TABLE FACTURA ADD CONSTRAINT FACTURA_PK PRIMARY KEY (COD_FACTURA) ENABLE;
  ALTER TABLE FACTURA ADD CONSTRAINT FK_FACTURA_CLIENTE FOREIGN KEY (ID_CLIENTE)
	  REFERENCES CLIENTE (ID_CLIENTE) ENABLE;
  ALTER TABLE FACTURA ADD CONSTRAINT FK_FACTURA_ENCOMENDA FOREIGN KEY (ID_ENCOMENDA)
	  REFERENCES ENCOMENDA (ID_ENCOMENDA) ENABLE;  
 
CREATE TABLE LINHA_FACTURA 
   (	COD_FACTURA NUMBER(*,0) NOT NULL ENABLE, 
      COD_ARTIGO NUMBER(*,0) NOT NULL ENABLE,
      QUANTIDADE INTEGER NOT NULL ENABLE,
      PRECO_UNIT NUMBER NOT NULL ENABLE, 
      TAXA_IVA NUMBER(4,2) NOT NULL ENABLE
    ) ;
  ALTER TABLE LINHA_FACTURA ADD CONSTRAINT LINHA_FACTURA_PK PRIMARY KEY 
    (COD_FACTURA, COD_ARTIGO) ENABLE;
  ALTER TABLE LINHA_FACTURA ADD CONSTRAINT FK_LINHA_FACTURA_FACTURA FOREIGN KEY (COD_FACTURA)
	  REFERENCES FACTURA (COD_FACTURA) ENABLE;
  ALTER TABLE LINHA_FACTURA ADD CONSTRAINT FK_LINHA_FACTURA_ARTIGO FOREIGN KEY (COD_ARTIGO)
	  REFERENCES ARTIGO (COD_ARTIGO) ENABLE;

------ INSERTS

INSERT INTO MEDIDA (COD_MEDIDA, DESCRICAO) VALUES ('1', 'medida 1');
INSERT INTO MEDIDA (COD_MEDIDA, DESCRICAO) VALUES ('2', 'medida 2');
INSERT INTO MEDIDA (COD_MEDIDA, DESCRICAO) VALUES ('3', 'medida 3');

INSERT INTO CLIENTE (ID_CLIENTE, NOME, MORADA, CONTRIBUINTE) 
  VALUES ('100', 'cliente 1', 'morada 1', '111111111');
INSERT INTO CLIENTE (ID_CLIENTE, NOME, MORADA, CONTRIBUINTE) 
  VALUES ('101', 'cliente 2', 'morada 2', '222222222');
INSERT INTO CLIENTE (ID_CLIENTE, NOME, MORADA, CONTRIBUINTE) VALUES 
  ('102', 'cliente 3', 'morada 3', '333333333');
INSERT INTO CLIENTE (ID_CLIENTE, NOME, MORADA, CONTRIBUINTE) VALUES 
  ('103', 'cliente 4', 'morada 4', '444444444');

INSERT INTO FORNECEDOR (COD_FORNECEDOR, NOME) VALUES ('10', 'fornecedor 1');
INSERT INTO FORNECEDOR (COD_FORNECEDOR, NOME) VALUES ('11', 'fornecedor 2');
INSERT INTO FORNECEDOR (COD_FORNECEDOR, NOME) VALUES ('12', 'fornecedor 3');

INSERT INTO ARTIGO (COD_ARTIGO, DESCRICAO, COD_FORNECEDOR, COD_MEDIDA, STOCK, PRECO, TAXA_IVA) 
  VALUES ('1000', 'artigo 1', '10', '1', '500', '10,00', '0,23');
INSERT INTO ARTIGO (COD_ARTIGO, DESCRICAO, COD_FORNECEDOR, COD_MEDIDA, STOCK, PRECO, TAXA_IVA) 
  VALUES ('1001', 'artigo 2', '11', '2', '1000', '20,00', '0,13');
INSERT INTO ARTIGO (COD_ARTIGO, DESCRICAO, COD_FORNECEDOR, COD_MEDIDA, STOCK, PRECO, TAXA_IVA) 
  VALUES ('1002', 'artigo 3', '12', '3', '100', '30,00', '0,06');

INSERT INTO ENCOMENDA (ID_ENCOMENDA, ID_CLIENTE, DATA_ENC, FACTURADA) 
  VALUES ('1000', '100', sysdate, '0');
INSERT INTO ENCOMENDA (ID_ENCOMENDA, ID_CLIENTE, DATA_ENC, FACTURADA) 
  VALUES ('2000', '101', sysdate, '0');
INSERT INTO ENCOMENDA (ID_ENCOMENDA, ID_CLIENTE, DATA_ENC, FACTURADA) 
  VALUES ('3000', '102', sysdate, '0');
INSERT INTO ENCOMENDA (ID_ENCOMENDA, ID_CLIENTE, DATA_ENC, FACTURADA) 
  VALUES ('4000', '100', sysdate, '0');
INSERT INTO ENCOMENDA (ID_ENCOMENDA, ID_CLIENTE, DATA_ENC, FACTURADA) 
  VALUES ('5000', '103', sysdate, '0');
INSERT INTO ENCOMENDA (ID_ENCOMENDA, ID_CLIENTE, DATA_ENC, FACTURADA) 
  VALUES ('6000', '103', sysdate, '0');

INSERT INTO ENCOMENDA_ARTIGO (ID_ENCOMENDA, COD_ARTIGO, QUANTIDADE) 
  VALUES ('1000', '1000', '10');
INSERT INTO ENCOMENDA_ARTIGO (ID_ENCOMENDA, COD_ARTIGO, QUANTIDADE) 
  VALUES ('1000', '1001', '5');
INSERT INTO ENCOMENDA_ARTIGO (ID_ENCOMENDA, COD_ARTIGO, QUANTIDADE) 
  VALUES ('1000', '1002', '3');
INSERT INTO ENCOMENDA_ARTIGO (ID_ENCOMENDA, COD_ARTIGO, QUANTIDADE) 
  VALUES ('2000', '1000', '100');
INSERT INTO ENCOMENDA_ARTIGO (ID_ENCOMENDA, COD_ARTIGO, QUANTIDADE) 
  VALUES ('2000', '1001', '50');
INSERT INTO ENCOMENDA_ARTIGO (ID_ENCOMENDA, COD_ARTIGO, QUANTIDADE) 
  VALUES ('3000', '1000', '200');
INSERT INTO ENCOMENDA_ARTIGO (ID_ENCOMENDA, COD_ARTIGO, QUANTIDADE) 
  VALUES ('5000', '1000', '1000');
INSERT INTO ENCOMENDA_ARTIGO (ID_ENCOMENDA, COD_ARTIGO, QUANTIDADE) 
  VALUES ('6000', '1002', '100');
  
--------TRIGGER ENCOMEMDA_FACTURA ----
-- Criar trigger na tabela encomenda para controlar estado de facturação
-- controlar o atributo FACTURADA com 0 e 1 para cada registo da tabela 
-- ENCOMENDA

CREATE OR REPLACE TRIGGER TRG_ENC_FACT 
 BEFORE UPDATE ON ENCOMENDA 
  FOR EACH ROW
  -- identificar variáveis
  declare
  ex_factura_emitida exception;
  ex_ENCOMENDA_vazia exception; 
  v_factura factura%rowtype;
  
BEGIN
  --garantir que não e possível passar uma encomenda FACTURADA a não FACTURADA.
  if (:old.FACTURADA = 1) and (:new.FACTURADA = 0) then
    raise ex_factura_emitida;
  end if;
   --Se encomenda já FACTURADA = 1, evitar gerar nova a factura.
  if (:old.FACTURADA = 1) and (:new.FACTURADA = 1) then
    raise ex_factura_emitida;
  end if;
  --Criar novo código da factura para cada ENCOMENDA
  select nvl(max(cod_factura), 0) + 1 into v_factura.cod_factura
    from factura;
 --validar se a ENCOMENDA não tem artigos na tabela ENCOMENDA_ARTIGO
  declare
    v_artigos integer;
  begin
    select count(0) into v_artigos
      from ENCOMENDA_ARTIGO
     where ID_ENCOMENDA = :new.ID_ENCOMENDA;
    if v_artigos = 0 then
      raise ex_ENCOMENDA_vazia;
    end if;
  end;
  
  -- geração de dados financeiros para a nova factura
  select sum(preco*quantidade), sum(preco*quantidade*taxa_iva) 
    into v_factura.valor_sem_iva, v_factura.valor_iva
    from ENCOMENDA_ARTIGO a, ARTIGO b
   where a.cod_ARTIGO = b.cod_ARTIGO
     and a.ID_ENCOMENDA = :new.ID_ENCOMENDA;
     
  -- inserir registo de nova factura na tabela FACTURA
  insert into factura(cod_factura, ID_CLIENTE, ID_ENCOMENDA, DATA_FACT, 
    valor_sem_iva, valor_iva, total)
  values(v_factura.cod_factura, :new.ID_CLIENTE, :new.ID_ENCOMENDA, sysdate, 
    v_factura.valor_sem_iva, v_factura.valor_iva, 
    v_factura.valor_sem_iva + v_factura.valor_iva);
  
  -- inserir novos registos de linhas de factura na tabela LINHA_FACTURA
  insert into linha_factura(cod_factura, cod_ARTIGO, quantidade, preco_unit, taxa_iva)
  select v_factura.cod_factura, b.cod_ARTIGO, quantidade, preco, taxa_iva
    from ENCOMENDA_ARTIGO a, ARTIGO b
   where a.cod_ARTIGO = b.cod_ARTIGO
     and a.ID_ENCOMENDA = :new.ID_ENCOMENDA;

  -- tratar excepções
EXCEPTION
  when ex_factura_emitida then
    raise_application_error(-20101, 'ENCOMENDA já facturada');
  when ex_ENCOMENDA_vazia then
    raise_application_error(-20002, 'ENCOMENDA sem artigos');
END;

\
-- ativar trigger--
ALTER TRIGGER TRG_ENC_FACT ENABLE;
-- ativar output para écran--
set serveroutput on;

-- Testar o Trigger PARA CADA ENCOMENDA COM VARIOS ARTIGOS EM CADA ENCOMENDA
-- ENC 1000 POSSUI 3 ARTIGOS 
-- ENC 2000 POSSUI 2 ARTIGOS 
-- ENC 3000 POSSUI 1 ARTIGO
-- ENC 4000 NÃO POSSUI NENHUM ARTIGO - DARÁ ERRO DE ENCOMENDA VAZIA
-- ENC 5000 e 6000 DO MESMO CLIENTE

select * from encomenda;
select * from encomenda_artigo;


-- TESTE 1 - ENC 1000 POSSUI 3 ARTIGOS 
UPDATE ENCOMENDA SET FACTURADA = '1' WHERE ID_ENCOMENDA='1000';
-- NOVA FACTURA COM CODIGO 1 COM 3 LINHAS DE FACTURA
select * from factura;
select * from linha_factura;

-- TESTE 2 - ENCOMENDA 2000 POSSUI 2 ARTIGOS 
UPDATE ENCOMENDA SET FACTURADA = '1' WHERE ID_ENCOMENDA='2000';
-- NOVA FACTURA COM CODIGO 2 COM 2 LINHAS DE FACTURA
select * from factura;
select * from linha_factura;

-- TESTE 3 - ENCOMENDA 3000 POSSUI 1 ARTIGO
UPDATE ENCOMENDA SET FACTURADA = '1' WHERE ID_ENCOMENDA='3000';
-- NOVA FACTURA COM CODIGO 3 COM 1 LINHA DE FATURA
select * from factura;
select * from linha_factura;

select * from encomenda;

-- TESTE 4 - ENCOMENDA 4000 NÃO POSSUI NENHUM ARTIGO - DARÁ ERRO DE ENCOMENDA VAZIA
UPDATE ENCOMENDA SET FACTURADA = '1' WHERE ID_ENCOMENDA='4000';
-- ERRO DE ENCOMENDA VAZIA SEM ARTIGOS

-- TESTE 5 - PASSAR ENCOMENDA JÁ FATURADA A NÃO FACTURADA
UPDATE ENCOMENDA SET FACTURADA = '0' WHERE ID_ENCOMENDA='1000';
-- ERRO DE ENCOMENDA JÁ FACTURADA

-- TESTE 6 - GERAR FACTURA PARA ENCOMENDA JÁ FATURADA
UPDATE ENCOMENDA SET FACTURADA = '1' WHERE ID_ENCOMENDA='1000';
-- ERRO DE ENCOMENDA JÁ FACTURADA

-- Teste ao Trigger PARA CADA CLIENTE COM VÁRIAS ENCOMENDAS NÃO FACTURADAS
-- TEDTE 7 - CLIENTE 103 POSSUI 2 ENCOMENDAS (5000 E 6000) COM 1 ARTIGO CADA ENCOMENDA
UPDATE ENCOMENDA SET FACTURADA = '1' WHERE ID_CLIENTE='103';
-- NOVAS FACTURAS 4 E 5 COM 1 LINHA DE ENCOMENDA CADA FACTURA
select * from factura;
select * from linha_factura;

--------TRIGGER ENCOMEMDA_ARTIGO ----
-- Criar trigger na tabela encomenda_artigo para controlar que a quantidade de
-- encomenda de cada artigo não ultrapassa o stock disponível e atualiza o stock
-- desse artigo

create or replace trigger VALIDA_STOCK
  before insert or update on encomenda_artigo
  for each row 
  
  declare var_stock number;
    EX_ERRO EXCEPTION;
  BEGIN 
  
     select stock 
     into var_stock 
     from Artigo 
     where Artigo.cod_Artigo = :new.cod_Artigo; 
     
  -- valida quantidade disponível em stock
     if  (var_stock - :new.quantidade) <= 0 then
        RAISE EX_ERRO;
     end if;
     
   -- atualiza stock-- 
   update artigo set stock=(var_stock - :new.quantidade)
   where artigo.cod_artigo=:new.cod_artigo;
  
  EXCEPTION
    WHEN EX_ERRO THEN
      RAISE_APPLICATION_ERROR(-20006,'não existe quantidade suficiente em stock');

  END VALIDA_STOCK;
/

-- Testar trigger com nova encomenda 7000 
INSERT INTO ENCOMENDA (ID_ENCOMENDA, ID_CLIENTE, DATA_ENC, FACTURADA) 
  VALUES ('7000', '101', sysdate, '0');
 
select * from encomenda;

select * from artigo;
-- adicionar artigo 1002 na encomenda 7000
-- com quantidade 200 e stock 100  - erro de falta de stock
INSERT INTO ENCOMENDA_ARTIGO (ID_ENCOMENDA, COD_ARTIGO, QUANTIDADE) 
  VALUES ('7000', '1002', '200');
  
-- adicionar artigo 1002 com qtd 50 e stock 100  - ok e atualiza stock para 50
INSERT INTO ENCOMENDA_ARTIGO (ID_ENCOMENDA, COD_ARTIGO, QUANTIDADE) 
  VALUES ('7000', '1002', '50');

select * from encomenda_artigo;
select * from artigo;

-- FACTURAR ENCOMENDA 7000 POSSUI 1 ARTIGO
UPDATE ENCOMENDA SET FACTURADA = '1' WHERE ID_ENCOMENDA='7000';
-- NOVA FACTURA COM CODIGO 6 COM 1 LINHA DE FATURA
select * from factura;
select * from linha_factura;


Set serveroutput on;
------------------------------------------------------------------------------------------------------------------------

/* alguns exemplos de funÁ?es */
/*
Criar uma funÁ?o que indique se um determinado m»dico existe.
*/

create or replace function func_medico_existe(p_id_medico medicos.id_medico%type) return boolean
is
  v_count int;
begin
  select count(*) into v_count
    from medicos
   where id_medico = p_id_medico;
  return v_count > 0;
end;
/
------------------------------------------------------------------------------------------------------------------------
-/*
invocando funÁ?es ......*/
-- Como um programa em PLSQL-----

declare 
ex_medico_nao_existe exception;

BEGIN
     begin 
       if not func_medico_existe(6) then
            raise ex_medico_nao_existe;
       else        
          dbms_output.put_line ('o m»dico existe');      
       end if;
     end;
    
exception
  when ex_medico_nao_existe then
    raise_application_error(-20001, 'M»dico inexistente');
end;    
--

---- Criar uma funÁ?o para fazer parte de um parametro de outra funÁ?o ou como parte de uma instruÁ?o SELECT-------

create or replace function get_nome_med (id_med medicamentos.id_medicamento%type) return varchar
is 
  m_nome varchar(100);

begin
    select nome into m_nome
    from medicamentos
    where id_medicamento= id_med;
    return (m_nome);
end;

---- invocar a funÁ?o como um parametro de outra funÁ?o;

begin
DBMS_OUTPUT.PUT_LINE(' o nome do medicamento È : '||get_nome_med(6));
END;
--------------------------------------------------------------------------------
--- Invocando como parte de um comando de SQL .....

select get_nome_med(id_medicamento), laboratorio from medicamentos;

------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------------------
/* FunÁ?o que retorna um cursor 
---  FunÁ?o que devolve os medicamentos de um Laboratorio */

create or replace function get_medicamentos_labs(p_labs medicamentos.laboratorio%type) return sys_refcursor
is
  v_rc sys_refcursor;
begin
  OPEN v_rc FOR
    SELECT  nome  FROM  medicamentos WHERE laboratorio = p_labs;
 RETURN  (v_rc);
end;
/
------------------------------------------------------------------------------------------------------------
--- Invocar uma funÁ?o que retorna um cursor ...... 

DECLARE
 l_nomes sys_refcursor;
 l_nome  medicamentos.nome%type;

BEGIN

   l_nomes:=get_medicamentos_labs ('Bayer');
    LOOP
     Fetch l_nomes into l_nome;
     EXIT WHEN l_nomes%NOTFOUND;
     dbms_output.put_line (l_nome);
  END LOOP;
END; 

------------------------------------------------------------------------------------------------------------
/*Exercicio Procedimento e funÁ?o chamada dentro do procedimento */ 

/*
Por vezes existe a necessidade de substituir um m»dico por outro nas consultas de um determinado dia.
Criar um procedimento que permita efetuar a substituiÁ?o dos mÈdico respons·vel pelas consultas, por um outro.
Deve gerar exceÁ?ees quando:
 a) O(s) m»dico(s) n?o existe(m)
 b) Um mÈdico tem mais do que 3 consultas no dia
*/

create or replace procedure proc_substituir_medico(
 p_id_medico medicos.id_medico%type,
 p_id_medico_substituto medicos.id_medico%type,
 p_dia date)
is
  v_count int;
  cursor c_medicos(pc_id_medico medicos.id_medico%type) is
    select *
      from medicos
     where id_medico = pc_id_medico;
     
  r_medico c_medicos%rowtype;
  r_substituto c_medicos%rowtype;
  
  ex_medico_nao_existe exception;
  ex_substituto_nao_existe exception;
  ex_numero_consultas_excedido exception;
begin

  --Verificar se os m…dicos existem.
  open c_medicos(p_id_medico);
  fetch c_medicos into r_medico;
  if c_medicos%notfound then
    raise ex_medico_nao_existe;
  end if;
  close c_medicos;
  
  open c_medicos(p_id_medico_substituto);
  fetch c_medicos into r_substituto;
  if c_medicos%notfound then
    raise ex_substituto_nao_existe;
  end if;
  close c_medicos;
  
  --Substituir um mÈdico pelo outro.
  --Validar o n˙mero m·ximo de consultas.
  
  select count(*) into v_count
    from consultas
   where trunc(data_hora) = p_dia
     and id_medico in (p_id_medico, p_id_medico_substituto);
  if v_count > 3 then
    raise ex_numero_consultas_excedido;
  end if;
  
  --Pode gravar.
  update consultas
     set id_medico = p_id_medico_substituto
   where id_medico = p_id_medico
     and trunc(data_hora) = p_dia;
exception
  when ex_medico_nao_existe then
    raise_application_error(-20001, 'M»dico inexistente');
  when ex_substituto_nao_existe then
    raise_application_error(-20002, 'M»dico substituto inexistente');
  when ex_numero_consultas_excedido then 
    raise_application_error(-20003, 'O n?mero m∑ximo de consultas seria excedido');
end;
/

------------------------------------------------------------------------------------------------------------
------------------------TESTAR------------------------------------------------------------------------------------
select * from consultas where trunc(data_hora) = to_date('2017-10-10', 'yyyy-mm-dd');

--Teste (ok)
begin
  proc_substituir_medico(17, 11, to_date('2017-10-10', 'yyyy-mm-dd'));
end;
/

--Teste (nok)
begin
  proc_substituir_medico(2, 3, to_date('2017-10-10', 'yyyy-mm-dd'));
end;
/

--Teste (nok)
begin
  proc_substituir_medico(2111, 3, to_date('2017-10-10', 'yyyy-mm-dd'));
end;
/


-----------------------------------------------------------------------------------------------------------------------------
/*
Alterar o procedimento por forma a utilizar a  funÁ?o que indica se um determinado m»dico existe ( primeira funÁ?o).
*/ --.
*/

create or replace procedure proc_substituir_medico(
 p_id_medico medicos.id_medico%type,
 p_id_medico_substituto medicos.id_medico%type,
 p_dia date)
is
  v_count int;

  ex_medico_nao_existe exception;
  ex_substituto_nao_existe exception;
  ex_numero_consultas_excedido exception;
begin
  --Verificar se os m»dicos existem.
  if not func_medico_existe(p_id_medico) then
    raise ex_medico_nao_existe;
  end if;
  
  if not func_medico_existe(p_id_medico_substituto) then
    raise ex_substituto_nao_existe;
  end if;
  
  --Substituir um m»dico pelo outro.
  --Validar o n?mero m∑ximo de consultas.
  select count(*) into v_count
    from consultas
   where trunc(data_hora) = p_dia
     and id_medico in (p_id_medico, p_id_medico_substituto);
  if v_count > 3 then
    raise ex_numero_consultas_excedido;
  end if;
  
  --Pode gravar.
  update consultas
     set id_medico = p_id_medico_substituto
   where id_medico = p_id_medico
     and trunc(data_hora) = p_dia;
exception
  when ex_medico_nao_existe then
    raise_application_error(-20001, 'M»dico inexistente');
  when ex_substituto_nao_existe then
    raise_application_error(-20002, 'M»dico substituto inexistente');
  when ex_numero_consultas_excedido then 
    raise_application_error(-20003, 'O n?mero m∑ximo de consultas seria excedido');
end;
/
------------------------------------------------------------------------------------------------------------------------
/*
Alterar o procedimento por forma a manter o histÛrico das alteraÁ?es executadas,
incluindo um campo de observaÁ?ess.
*/
-------------------------------------------------------------------------------------------------
--Criar a tabela para logging.
drop table logalteracoes;
create table LogAlteracoes(
 log_id int constraint pk_logalteracoes primary key,
 id_consulta int constraint fk_logalteracoes_consulta references consultas(id_consulta),
 id_medico int constraint fk_logalteracoes_medico references medicos(id_medico),
 id_substituto int constraint fk_logalteracoes_substituto references medicos(id_medico),
 data_consulta date,
 data_alteracao date,
 motivo varchar(200));

--Criar sequence para atribui¡?o do log_id.
drop sequence seq_pk_logalteracoes;
create sequence seq_pk_logalteracoes start with 1 increment by 1;

------------------------------------------------------------------------------------------------------------

create or replace procedure proc_substituir_medico(
 p_id_medico medicos.id_medico%type,
 p_id_medico_substituto medicos.id_medico%type,
 p_dia date,
 p_motivo varchar)
is
  v_count int;
  
  ex_medico_nao_existe exception;
  ex_substituto_nao_existe exception;
  ex_numero_consultas_excedido exception;
begin
  --Verificar se os m»dicos existem.
  if not func_medico_existe(p_id_medico) then
    raise ex_medico_nao_existe;
  end if;
  
  if not func_medico_existe(p_id_medico_substituto) then
    raise ex_substituto_nao_existe;
  end if;
  
  --Substituir um m»dico pelo outro.
  --Validar o n?mero m·ximo de consultas.
  select count(*) into v_count
    from consultas
   where trunc(data_hora) = p_dia
     and id_medico in (p_id_medico, p_id_medico_substituto);
  if v_count > 3 then
    raise ex_numero_consultas_excedido;
  end if;
  
  --Pode gravar.
  for r in
    (select id_consulta, data_hora
       from consultas
      where id_medico = p_id_medico
        and trunc(data_hora) = p_dia)
  loop
    insert into logalteracoes(log_id, id_consulta, id_medico, id_substituto, data_consulta, data_alteracao, motivo)
    values(seq_pk_logalteracoes.nextval, r.id_consulta, p_id_medico, p_id_medico_substituto, r.data_hora, sysdate, p_motivo);
   commit;
    update consultas
       set id_medico = p_id_medico_substituto
     where id_consulta = r.id_consulta;
  end loop;
exception
  when ex_medico_nao_existe then
    raise_application_error(-20001, 'M»dico inexistente');
  when ex_substituto_nao_existe then
    raise_application_error(-20002, 'M»dico substituto inexistente');
  when ex_numero_consultas_excedido then 
    raise_application_error(-20003, 'O n?mero m∑ximo de consultas seria excedido');
end;
/
------ TeSTAR -----------------------------------------------------------------------------

select * from logalteracoes;

select * from consultas where trunc(data_hora) = to_date('2017-10-10', 'yyyy-mm-dd');

--Teste (ok)
begin
  proc_substituir_medico(3, 6, to_date('2017-10-10', 'yyyy-mm-dd'),'Indisposto');
end;
/

--Teste (nok)
begin
  proc_substituir_medico(2111, 3, to_date('2017-10-10', 'yyyy-mm-dd'), 'Indisposto');
end;
/

------------------------------------------------------------------------------------------------------------------------
/*
Acrescentar a validaÁ?o da coerÍncia da alteraÁ?o (ex. trocar por um m»dico que n?o d· consulta nesse dia).
*/

create or replace procedure proc_substituir_medico(
 p_id_medico medicos.id_medico%type,
 p_id_medico_substituto medicos.id_medico%type,
 p_dia date,
 p_motivo varchar)
is
  v_count int;
  
  ex_medico_nao_existe exception;
  ex_substituto_nao_existe exception;
  ex_numero_consultas_excedido exception;
  ex_troca_invalida exception;
begin
  --Verificar se os m»dicos existem.
  if not func_medico_existe(p_id_medico) then
    raise ex_medico_nao_existe;
  end if;
  
  if not func_medico_existe(p_id_medico_substituto) then
    raise ex_substituto_nao_existe;
  end if;
  
  --Substituir um m»dico pelo outro.
  --Validar o n?mero m∑ximo de consultas.
  select count(*) into v_count
    from consultas
   where trunc(data_hora) = p_dia
     and id_medico in (p_id_medico, p_id_medico_substituto);
  if v_count > 3 then
    raise ex_numero_consultas_excedido;
  end if;
  
  --Pode gravar.
  declare
    v_ok boolean := false;
  begin
    for r in
      (select id_consulta, data_hora
         from consultas
        where id_medico = p_id_medico
          and trunc(data_hora) = p_dia)
    loop
      insert into logalteracoes(log_id, id_consulta, id_medico, id_substituto, data_consulta, data_alteracao, motivo)
      values(seq_pk_logalteracoes.nextval, r.id_consulta, p_id_medico, p_id_medico_substituto, r.data_hora, sysdate, p_motivo);

      update consultas
         set id_medico = p_id_medico_substituto
       where id_consulta = r.id_consulta;
      
      v_ok := true;
    end loop;
    if not v_ok then
      raise ex_troca_invalida;
    end if;
  end;
exception
  when ex_medico_nao_existe then
    raise_application_error(-20001, 'M»dico inexistente');
  when ex_substituto_nao_existe then
    raise_application_error(-20002, 'M»dico substituto inexistente');
  when ex_numero_consultas_excedido then 
    raise_application_error(-20003, 'O n?mero m∑ximo de consultas seria excedido');
  when ex_troca_invalida then 
    raise_application_error(-20004, 'O m»dico ' || p_id_medico || ' n?o d· consultas em ' || to_char(p_dia, 'yyyy-mm-dd'));
end;
/
-----

select * from consultas where trunc(data_hora) = to_date('2017-10-10', 'yyyy-mm-dd');


--Teste (nok)
begin
  proc_substituir_medico(1, 17, to_date('2017-10-10', 'yyyy-mm-dd'), 'Indisposto');
end;
/
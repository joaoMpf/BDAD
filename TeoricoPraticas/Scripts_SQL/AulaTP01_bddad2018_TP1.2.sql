drop table inscricao;
drop table ingresso;
drop table disciplina;
drop table aluno;
drop table curso;



create table curso(
codigo varchar(8) primary key,
nome varchar(100));

create table disciplina(
codigo varchar(8) primary key,
nome varchar(100));

create table aluno(
numero integer primary key,
nome varchar(100),
mediaAcesso numeric(4,2));

create table ingresso(
numAluno integer references aluno(numero),
anoLetivo char(7),
codCurso varchar(8) references curso(codigo),
constraint pkIngresso primary key (numAluno, anoLetivo));

create table inscricao(
codDisciplina varchar(8) references disciplina(codigo),
numAluno integer references aluno(numero),
anoLetivo char(7),
dataInscricao date,
notaFreq numeric(4,2),
notaExame numeric(4,2),
constraint pkInscricao primary key (codDisciplina, numAluno, anoLetivo),
constraint fkInscricaoIngresso foreign key (numAluno, anoLetivo) references ingresso(numAluno, anoLetivo));



insert into curso values('LEI', 'Licenciatura em Engenharia Informática');
insert into curso values('MEI', 'Mestrado em Engenharia Informática');
insert into curso values('LECIV', 'Licenciatura em Engenharia Civil');
insert into curso values('LEM', 'Licenciatura em Engenharia Mecânica');
insert into curso values('LEE', 'Licenciatura em Engenharia Electrotécnica e de Computadores');
insert into curso values('MEM', 'Mestrado em Engenharia Mecânica');
insert into curso values('LEQ', 'Licenciatura em Engenharia Química');
insert into curso values('MEQ', 'Mestrado em Engenharia Química');
insert into curso values('MECIM', 'Mestrado em Engenharia de Computação e Instrumentação Médica');

insert into disciplina values('BDDAD', 'Bases de Dados');
insert into disciplina values('EAPLI', 'Engenharia de Aplica;\oes');
insert into disciplina values('ESOFT', 'Engenharia de Software');
insert into disciplina values('PROAV', 'Programação Avançada');
insert into disciplina values('ESTAT', 'Estatística');
insert into disciplina values('ELEAPL', 'Eletrónica Aplicada');
insert into disciplina values('ELECT-E', 'Electromagnetismo');
insert into disciplina values('APROG', 'Programação');

insert into aluno values(1165340, 'Joaquim Silva', 14.3);
insert into aluno values(1156341, 'Jorge Dias', 12.6);
insert into aluno values(1156354, 'Ana Guedes', 14.7);
insert into aluno values(1164233, 'Isabel Antónia', 15.5);
insert into aluno values(1164643, 'Pedro Pereira', 12.2);
insert into aluno values(1165456, 'Maria Joaquina',13.2);
insert into aluno values(1156987, 'Rute Silva', 14.5);
insert into aluno values(1156458, 'Bruno Silva', 13.9);
insert into aluno values(1166730, 'António Andrade', 11.8);
insert into aluno values(1156472, 'Fernando Paiva', 12.7);
insert into aluno values(1168777, 'Fernanda Afonso', 14.0);
insert into aluno values(1168987, 'Beatriz Cunha', 13.1);
insert into aluno values(1161123, 'Carla Martins', 13.2);
insert into aluno values(1168019, 'Gustavo Correia', 13.3);

insert into ingresso values(1165340, '2017-18', 'LEI');
insert into ingresso values(1165340, '2016-17', 'LEI');
insert into ingresso values(1156341, '2016-17', 'MECIM');
insert into ingresso values(1156354, '2016-17', 'MECIM');
insert into ingresso values(1164233, '2016-17', 'LEI');
insert into ingresso values(1165456, '2017-18', 'LEI');
insert into ingresso values(1156987, '2017-18', 'MECIM');
insert into ingresso values(1156458, '2017-18', 'LECIV');
insert into ingresso values(1166730, '2017-18', 'LEI');
insert into ingresso values(1156472, '2017-18', 'LECIV');
insert into ingresso values(1168777, '2017-18', 'LEI');
insert into ingresso values(1168987, '2017-18', 'LEI');
insert into ingresso values(1161123, '2016-17', 'LEI');
insert into ingresso values(1168019, '2016-17', 'LEI');
insert into ingresso values(1164643, '2016-17', 'LEI');

insert into inscricao values('BDDAD', 1165340, '2017-18', TO_DATE('2017-09-01','YYYY-MM-DD'), 18.5, 13.4);
insert into inscricao values('ESOFT', 1165340, '2016-17', TO_DATE('2016-07-29','YYYY-MM-DD'), 14.7, 10.2);
insert into inscricao values('BDDAD', 1165340, '2016-17', TO_DATE('2016-07-29','YYYY-MM-DD'), 8.4, 5.7);
insert into inscricao values('EAPLI', 1165340, '2017-18', TO_DATE('2017-09-01','YYYY-MM-DD'), 15.1, 13.8);
insert into inscricao values('PROAV', 1156341, '2016-17', TO_DATE('2016-09-09','YYYY-MM-DD'), 15.2, 14.4);
insert into inscricao values('PROAV', 1156354, '2016-17', TO_DATE('2016-09-03','YYYY-MM-DD'), 10.9, null);
insert into inscricao values('BDDAD', 1164233, '2016-17', TO_DATE('2016-07-28','YYYY-MM-DD'), 15.1, 12.7);
insert into inscricao values('BDDAD', 1164643, '2016-17', TO_DATE('2016-09-12','YYYY-MM-DD'), 12.5, 12.0);
insert into inscricao values('BDDAD', 1165456, '2017-18', TO_DATE('2017-09-13','YYYY-MM-DD'), null, null);
insert into inscricao values('EAPLI', 1164233, '2016-17', TO_DATE('2016-07-28','YYYY-MM-DD'), 14.8, 11.3);
insert into inscricao values('EAPLI', 1164643, '2016-17', TO_DATE('2016-09-12','YYYY-MM-DD'), 16.3, 14.5);
insert into inscricao values('EAPLI', 1165456, '2017-18', TO_DATE('2017-09-12','YYYY-MM-DD'), 10.3, 12.2);
insert into inscricao values('ESOFT', 1164233, '2016-17', TO_DATE('2016-07-28','YYYY-MM-DD'), 3.4, null);
insert into inscricao values('ESOFT', 1164643, '2016-17', TO_DATE('2016-09-12','YYYY-MM-DD'), 8.3, 4.5);
insert into inscricao values('ESOFT', 1165456, '2017-18', TO_DATE('2017-09-12','YYYY-MM-DD'), 12.4, 13.1);
insert into inscricao values('PROAV', 1156987, '2017-18', TO_DATE('2017-09-13','YYYY-MM-DD'), 14.2, 16.6);
insert into inscricao values('APROG', 1156458, '2017-18', TO_DATE('2017-09-05','YYYY-MM-DD'), 12.9, 14.3);
insert into inscricao values('ESTAT', 1156458, '2017-18', TO_DATE('2017-09-15','YYYY-MM-DD'), 10.0, 9.6);
insert into inscricao values('BDDAD', 1166730, '2017-18', TO_DATE('2017-07-24','YYYY-MM-DD'), 14.4, 15.6);
insert into inscricao values('APROG', 1156472, '2017-18', TO_DATE('2017-07-25','YYYY-MM-DD'), 11.4, 15.2);
insert into inscricao values('BDDAD', 1168777, '2017-18', TO_DATE('2017-09-17','YYYY-MM-DD'), 17.9, 14.9);
insert into inscricao values('BDDAD', 1168987, '2017-18', TO_DATE('2017-09-15','YYYY-MM-DD'), 12.5, 12.4);
insert into inscricao values('BDDAD', 1161123, '2016-17', TO_DATE('2016-07-15','YYYY-MM-DD'), 13.3, 10.6);
insert into inscricao values('BDDAD', 1168019, '2016-17', TO_DATE('2016-09-23','YYYY-MM-DD'), 8.1, 6.7);



--Nome dos cursos
SELECT nome
FROM curso;

--Código e nome das disciplinas
SELECT codigo, nome FROM disciplina;

--Nome dos alunos com media de acesso superior ou igual a 14 valores
SELECT nome from aluno
WHERE mediaacesso >= 14;

--Nota do aluno 1164233 na disciplina BDDAD em 2016-17; a nota de frequência vale 60% da nota final e a nota de exame o restante
SELECT 0.6*notaFreq + 0.4*notaExame
FROM inscricao
WHERE numAluno = 1164233
AND codDisciplina = 'BDDAD'
AND anoLetivo = '2016-17';

--Nota da aluna Isabel Antónia na disciplina BDDAD em 2016-17
SELECT 0.6*notaFreq + 0.4*notaExame
FROM inscricao i, aluno a
WHERE a.nome = 'Isabel Antónia'
AND codDisciplina = 'BDDAD'
AND anoLetivo = '2016-17'
AND i.numAluno = a.numero;

--Nota da aluna Isabel Antónia na disciplina Bases de Dados em 2016-17
SELECT 0.6*notaFreq + 0.4*notaExame
FROM inscricao i, aluno a, disciplina d
WHERE a.nome = 'Isabel Antónia'
AND d.nome = 'Bases de Dados'
AND i.anoLetivo = '2016-17'
AND i.numAluno = a.numero
AND i.codDisciplina = d.codigo;

--Lista de alunos e respetivas classificações de frequència, exame e final, na disciplina Bases de Dados em 2016-17. As notas que ainda não tenham sido atribuídas a um determinado aluno devem ser indicadas com “---” 
SELECT a.nome AS "Aluno", NVL(notaFreq, '') AS "Frequência", NVL(notaExame, '') As "Exame", NVL(0.6*notaFreq + 0.4*notaExame, '') As "Nota final"
FROM inscricao i, aluno a, disciplina d
WHERE d.nome = 'Bases de Dados'
AND i.anoLetivo = '2016-17'
AND i.numAluno = a.numero
AND i.codDisciplina = d.codigo;


--Nome dos alunos por ordem alfabética

--Nome dos alunos por ordem numérica decrescente

--Maior média de acesso ao curso LEI no ano letivo 2016-17

--Maior média de acesso por curso e respetivo ano letivo

--Média das notas de frequência da disciplina de Bases de Dados em 2016-17

--Nota de frequência minima e máxima por disciplina em 2016-17

--Nome dos cursos que, em 2016-17, têm média da nota de exame superior à média das notas de frequência

--Número de alunos inscritos em cada disciplina

--Histograma das notas de frequência de todos ao alunos do curso de Licenciatura em Engenharia Informática

--Nome do aluno com maior média de acesso por curso e ano letivo ordenado por ordem crescente do ano letivo e decrescente da media de acesso




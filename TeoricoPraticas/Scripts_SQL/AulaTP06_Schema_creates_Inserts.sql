--eliminar tabelas (eventualmente) existentes
DROP TABLE codigos_postais          CASCADE CONSTRAINTS PURGE;
DROP TABLE especialidades           CASCADE CONSTRAINTS PURGE;
DROP TABLE medicamentos             CASCADE CONSTRAINTS PURGE;
DROP TABLE medicos                  CASCADE CONSTRAINTS PURGE;
DROP TABLE pacientes                CASCADE CONSTRAINTS PURGE;
DROP TABLE consultas                CASCADE CONSTRAINTS PURGE;
DROP TABLE medicamentos_receitados  CASCADE CONSTRAINTS PURGE;

--criar tabelas
CREATE TABLE especialidades(
    id_especialidade INTEGER       CONSTRAINT pk_especialidades_id_especialidade PRIMARY KEY,
    designacao       VARCHAR2(20)  CONSTRAINT nn_especialidades_designacao       NOT NULL
);
  
CREATE TABLE medicos(
    id_medico         INTEGER       CONSTRAINT pk_medicos_id_medico         PRIMARY KEY,
    id_especialidade  INTEGER       CONSTRAINT nn_medicos_id_especialidade  NOT NULL,
    id_medico_chefe   INTEGER,       
    nome              VARCHAR2(20)  CONSTRAINT nn_medicos_nome              NOT NULL,
    hospital          VARCHAR2(20),

    data_nascimento   DATE          CONSTRAINT nn_medicos_data_nascimento   NOT NULL,
    cod_postal        VARCHAR(8)
    
);
  
CREATE TABLE pacientes(
    id_paciente     INTEGER         CONSTRAINT pk_pacientes_id_paciente       PRIMARY KEY,
    nome            VARCHAR2(20)    CONSTRAINT nn_pacientes_nome              NOT NULL,
    data_nascimento DATE            CONSTRAINT nn_pacientes_data_nascimento   NOT NULL,
    cod_postal      VARCHAR(8)
);
  
CREATE TABLE consultas(
    id_consulta INTEGER       CONSTRAINT pk_consultas_id_consultas  PRIMARY KEY,
    data_hora   TIMESTAMP     CONSTRAINT nn_consultas_data_hora     NOT NULL,
    id_medico   INTEGER       CONSTRAINT nn_consultas_id_medico     NOT NULL,
    id_paciente INTEGER       CONSTRAINT nn_consultas_id_paciente   NOT NULL,
    CONSTRAINT uk_consultas_data_hora_id_medico UNIQUE (data_hora,id_medico)
);

CREATE TABLE medicamentos(
    id_medicamento   INTEGER       CONSTRAINT pk_medicamentos_id_medicamento PRIMARY KEY,
    nome             VARCHAR2(20)  CONSTRAINT nn_medicamentos_nome           NOT NULL,
    laboratorio      VARCHAR2(20)  CONSTRAINT nn_medicamentos_laboratorio    NOT NULL
);
  
CREATE TABLE medicamentos_receitados(
    id_consulta    INTEGER,
    id_medicamento INTEGER,
    CONSTRAINT pk_medicamentos_receitas_id_consulta_id_medicamento PRIMARY KEY (id_consulta, id_medicamento)
);

CREATE TABLE codigos_postais(
    cod_postal  VARCHAR(8)     CONSTRAINT pk_codigos_postais_cod_postal PRIMARY KEY
                               CONSTRAINT ck_codigos_postais_cod_postal CHECK( REGEXP_LIKE(cod_postal,'\d{4}-\d{3}') ),         
    localidade  VARCHAR2(20)   CONSTRAINT nn_codigos_postais_localidade NOT NULL    
);

-- chaves estrangeiras
  
ALTER TABLE medicos ADD CONSTRAINT fk_medicos_cod_postal       
                            FOREIGN KEY (cod_postal) REFERENCES codigos_postais (cod_postal);
ALTER TABLE medicos ADD CONSTRAINT fk_medicos_id_especialidade 
                            FOREIGN KEY (id_especialidade) REFERENCES especialidades (id_especialidade);
ALTER TABLE medicos ADD CONSTRAINT fk_medicos_id_medico_chefe       
                            FOREIGN KEY (id_medico_chefe) REFERENCES medicos (id_medico);

ALTER TABLE medicamentos_receitados ADD CONSTRAINT fk_medicamentos_receitados_id_consultas   
                                            FOREIGN KEY (id_consulta) REFERENCES consultas (id_consulta);
ALTER TABLE medicamentos_receitados ADD CONSTRAINT fk_medicamentos_receitados_id_medicamento 
                                            FOREIGN KEY (id_medicamento) REFERENCES medicamentos (id_medicamento);

ALTER TABLE pacientes ADD CONSTRAINT fk_pacientes_cod_postal FOREIGN KEY (cod_postal)  REFERENCES codigos_postais (cod_postal);

ALTER TABLE consultas ADD CONSTRAINT fk_consultas_id_medico  FOREIGN KEY (id_medico)   REFERENCES medicos (id_medico);
ALTER TABLE consultas ADD CONSTRAINT fk_consultas_paciente   FOREIGN KEY (id_paciente) REFERENCES pacientes (id_paciente);

--preencher tabelas

-- códigos postais
INSERT INTO codigos_postais VALUES ('2580-631', 'Alenquer');
INSERT INTO codigos_postais VALUES ('2720-465', 'Alverca');
INSERT INTO codigos_postais VALUES ('4600-012', 'Amarante');
INSERT INTO codigos_postais VALUES ('4750-264', 'Barcelos');
INSERT INTO codigos_postais VALUES ('2750-040', 'Cascais');
INSERT INTO codigos_postais VALUES ('4445-622', 'Ermesinde');
INSERT INTO codigos_postais VALUES ('4420-584', 'Gondomar');
INSERT INTO codigos_postais VALUES ('4420-282', 'Gondomar');
INSERT INTO codigos_postais VALUES ('1500-103', 'Lisboa');
INSERT INTO codigos_postais VALUES ('1099-052', 'Lisboa');
INSERT INTO codigos_postais VALUES ('1070-204', 'Lisboa');
INSERT INTO codigos_postais VALUES ('4470-208', 'Maia');
INSERT INTO codigos_postais VALUES ('4450-718', 'Matosinhos');
INSERT INTO codigos_postais VALUES ('4450-227', 'Matosinhos');
INSERT INTO codigos_postais VALUES ('4454-510', 'Matosinhos');
INSERT INTO codigos_postais VALUES ('2781-902', 'Oeiras');
INSERT INTO codigos_postais VALUES ('4200-197', 'Porto');
INSERT INTO codigos_postais VALUES ('4100-079', 'Porto');
INSERT INTO codigos_postais VALUES ('4100-217', 'Porto');
INSERT INTO codigos_postais VALUES ('4200-058', 'Porto');
INSERT INTO codigos_postais VALUES ('4150-706', 'Porto');
INSERT INTO codigos_postais VALUES ('4350-043', 'Porto');
INSERT INTO codigos_postais VALUES ('4050-078', 'Porto');
INSERT INTO codigos_postais VALUES ('4490-567', 'Póvoa do Varzim');
INSERT INTO codigos_postais VALUES ('4460-393', 'Senhora da Hora');
INSERT INTO codigos_postais VALUES ('4440-501', 'Valongo');
INSERT INTO codigos_postais VALUES ('4481-908', 'Vila do Conde');
INSERT INTO codigos_postais VALUES ('4400-356', 'Vila Nova de Gaia');

-- especialidades
INSERT INTO especialidades VALUES (1, 'Pediatria');        
INSERT INTO especialidades VALUES (2, 'Cardiologia');      
INSERT INTO especialidades VALUES (3, 'Oftalmologia');     
INSERT INTO especialidades VALUES (4, 'Dermatologia');     

-- pacientes
INSERT INTO pacientes VALUES (1, 'Alfredo Gama',    TO_DATE('12-08-2003','dd-mm-yyyy'), '4454-510');
INSERT INTO pacientes VALUES (2, 'Cecília Mendes',  TO_DATE('31-10-2007','dd-mm-yyyy'), '4460-393');
INSERT INTO pacientes VALUES (3, 'Carolina Santos', TO_DATE('26-05-2013','dd-mm-yyyy'), '4460-393');
INSERT INTO pacientes VALUES (4, 'Daniela Seabra',  TO_DATE('05-06-2013','dd-mm-yyyy'), '4454-510');
INSERT INTO pacientes VALUES (5, 'Laura Barbosa',   TO_DATE('07-07-2000','dd-mm-yyyy'), '2750-040');
INSERT INTO pacientes VALUES (6, 'Paulo Barbosa',   TO_DATE('13-02-1953','dd-mm-yyyy'), '4460-393');

-- mŽdicos chefe
INSERT INTO medicos VALUES (1, 2, NULL, 'Abel Santos',   'Pedro Hispano', TO_DATE('05-09-1973','dd-mm-yyyy'), '4200-197');
INSERT INTO medicos VALUES (2, 1, NULL, 'Adriana Sousa', 'Pedro Hispano', TO_DATE('23-03-1970','dd-mm-yyyy'), '4481-908');
INSERT INTO medicos VALUES (3, 4, NULL, 'Adriano Reis',  'Pedro Hispano', TO_DATE('07-07-1963','dd-mm-yyyy'), '4445-622');
INSERT INTO medicos VALUES (4, 3, NULL, 'Carla Dias',    'Pedro Hispano', TO_DATE('28-02-1960','dd-mm-yyyy'), '4460-393');

INSERT INTO medicos VALUES (5, 2, NULL, 'António Coelho',   'Santa Maria', TO_DATE('02-02-1976','dd-mm-yyyy'), '1500-103');
INSERT INTO medicos VALUES (6, 1, NULL, 'Alvaro Dunas',     'Santa Maria', TO_DATE('15-06-1970','dd-mm-yyyy'), '1099-052');
INSERT INTO medicos VALUES (7, 4, NULL, 'Manuela Silva',    'Santa Maria', TO_DATE('01-01-1958','dd-mm-yyyy'), '1070-204');
INSERT INTO medicos VALUES (8, 3, NULL, 'António Oliveira', 'Santa Maria', TO_DATE('16-04-1956','dd-mm-yyyy'), '2580-631');

INSERT INTO medicos VALUES (9,  2, NULL, 'Catarina Dolores',  'Santo António', TO_DATE('09-11-1954','dd-mm-yyyy'), '4100-079');
INSERT INTO medicos VALUES (10, 1, NULL, 'Benjamim Mateus',   'Santo António', TO_DATE('12-12-1958','dd-mm-yyyy'), '4100-217');
INSERT INTO medicos VALUES (11, 4, NULL, 'Francisco Cardoso', 'Santo António', TO_DATE('11-09-1958','dd-mm-yyyy'), '4450-718');
INSERT INTO medicos VALUES (12, 3, NULL, 'Débora Brandão',    'Santo António', TO_DATE('05-06-1961','dd-mm-yyyy'), '4420-584');

INSERT INTO medicos VALUES (13, 2, NULL, 'Amélia Silva',   'São João', TO_DATE('17-05-1968','dd-mm-yyyy'), '4150-706');
INSERT INTO medicos VALUES (15, 4, NULL, 'Marcos Marcelo', 'São João', TO_DATE('28-05-1961','dd-mm-yyyy'), '4350-043');
INSERT INTO medicos VALUES (16, 3, NULL, 'Nicolau Vieira', 'São João', TO_DATE('11-09-1968','dd-mm-yyyy'), '4600-012');
INSERT INTO medicos  VALUES (26, 2, 13, 'Angelo Rodrigo',  'São João', TO_DATE('02-02-1973','dd-mm-yyyy'), '4420-282');

-- médicos não-chefe
INSERT INTO medicos  VALUES (17, 2, 1, 'Ana Moura',       'Pedro Hispano', TO_DATE('13-08-1985','dd-mm-yyyy'), '4454-510');
INSERT INTO medicos  VALUES (18, 1, 2, 'Artur Rocha',     'Pedro Hispano', TO_DATE('25-01-1978','dd-mm-yyyy'), '4490-567');
INSERT INTO medicos  VALUES (19, 4, 3, 'Cláudia Martins', 'Pedro Hispano', TO_DATE('17-05-1968','dd-mm-yyyy'), '4400-356');

INSERT INTO medicos  VALUES (20, 2, 5, 'Carina Pinto',      'Santa Maria', TO_DATE('27-08-1980','dd-mm-yyyy'), '2750-040');
INSERT INTO medicos  VALUES (21, 4, 7, 'Nelson Vitória',    'Santa Maria', TO_DATE('03-09-1961','dd-mm-yyyy'), '2781-902');
INSERT INTO medicos  VALUES (22, 3, 8, 'Patrícia Carvalho', 'Santa Maria', TO_DATE('12-03-1980','dd-mm-yyyy'), '2720-465');

INSERT INTO medicos  VALUES (25, 3, 12, 'Mário Nascimento', 'Santo António', TO_DATE('13-03-1968','dd-mm-yyyy'), '4440-501');

--consultas
INSERT INTO consultas VALUES (1, TO_TIMESTAMP('25-09-2008 10:10', 'dd-mm-yyyy hh24:mi'), 2, 1);
INSERT INTO consultas VALUES (2, TO_TIMESTAMP('03-09-2011 14:30', 'dd-mm-yyyy hh24:mi'), 2, 1);
INSERT INTO consultas VALUES (3, TO_TIMESTAMP('12-05-2015 15:00', 'dd-mm-yyyy hh24:mi'), 2, 1);
INSERT INTO consultas VALUES (4, TO_TIMESTAMP('23-09-2018 10:30', 'dd-mm-yyyy hh24:mi'), 2, 1);

INSERT INTO consultas VALUES (5, TO_TIMESTAMP('08-03-2015 15:30', 'dd-mm-yyyy hh24:mi'), 17, 2);
INSERT INTO consultas VALUES (6, TO_TIMESTAMP('23-09-2018 15:30', 'dd-mm-yyyy hh24:mi'), 18, 2);
INSERT INTO consultas VALUES (7, TO_TIMESTAMP('28-09-2018 15:30', 'dd-mm-yyyy hh24:mi'), 19, 2);
INSERT INTO consultas VALUES (8, TO_TIMESTAMP('25-09-2018 15:30', 'dd-mm-yyyy hh24:mi'), 4, 2);
INSERT INTO consultas VALUES (9, TO_TIMESTAMP('07-10-2018 10:30', 'dd-mm-yyyy hh24:mi'), 18, 2);

INSERT INTO consultas VALUES (10, TO_TIMESTAMP('15-03-2017 16:30', 'dd-mm-yyyy hh24:mi'), 1, 3);
INSERT INTO consultas VALUES (11, TO_TIMESTAMP('10-10-2017 09:30', 'dd-mm-yyyy hh24:mi'), 17, 3);
INSERT INTO consultas VALUES (12, TO_TIMESTAMP('10-10-2017 12:30', 'dd-mm-yyyy hh24:mi'), 2, 3);
INSERT INTO consultas VALUES (13, TO_TIMESTAMP('10-10-2017 14:00', 'dd-mm-yyyy hh24:mi'), 3, 3);
INSERT INTO consultas VALUES (14, TO_TIMESTAMP('11-10-2017 10:00', 'dd-mm-yyyy hh24:mi'), 4, 3);
INSERT INTO consultas VALUES (15, TO_TIMESTAMP('12-10-2017 16:30', 'dd-mm-yyyy hh24:mi'), 19, 3);
INSERT INTO consultas VALUES (16, TO_TIMESTAMP('07-10-2018 11:30', 'dd-mm-yyyy hh24:mi'), 18, 3);
INSERT INTO consultas VALUES (17, TO_TIMESTAMP('07-10-2018 14:00', 'dd-mm-yyyy hh24:mi'), 19, 3);

INSERT INTO consultas VALUES (18, TO_TIMESTAMP('05-05-2017 16:00', 'dd-mm-yyyy hh24:mi'), 1, 4);
INSERT INTO consultas VALUES (19, TO_TIMESTAMP('09-10-2017 10:30', 'dd-mm-yyyy hh24:mi'), 1, 4);
INSERT INTO consultas VALUES (20, TO_TIMESTAMP('10-10-2017 14:30', 'dd-mm-yyyy hh24:mi'), 2, 4);
INSERT INTO consultas VALUES (21, TO_TIMESTAMP('10-10-2017 15:00', 'dd-mm-yyyy hh24:mi'), 3, 4);
INSERT INTO consultas VALUES (22, TO_TIMESTAMP('11-10-2017 11:00', 'dd-mm-yyyy hh24:mi'), 4, 4);
INSERT INTO consultas VALUES (23, TO_TIMESTAMP('13-10-2017 15:30', 'dd-mm-yyyy hh24:mi'), 19, 4);
INSERT INTO consultas VALUES (24, TO_TIMESTAMP('08-10-2018 11:30', 'dd-mm-yyyy hh24:mi'), 18, 4);

INSERT INTO consultas VALUES (25, TO_TIMESTAMP('15-03-2013 16:30', 'dd-mm-yyyy hh24:mi'), 5, 5);
INSERT INTO consultas VALUES (26, TO_TIMESTAMP('10-10-2017 09:30', 'dd-mm-yyyy hh24:mi'), 20, 5);
INSERT INTO consultas VALUES (27, TO_TIMESTAMP('15-09-2018 16:00', 'dd-mm-yyyy hh24:mi'), 5, 5);
INSERT INTO consultas VALUES (28, TO_TIMESTAMP('05-10-2018 09:00', 'dd-mm-yyyy hh24:mi'), 20, 5);
INSERT INTO consultas VALUES (29, TO_TIMESTAMP('10-10-2017 12:30', 'dd-mm-yyyy hh24:mi'), 6, 5);
INSERT INTO consultas VALUES (30, TO_TIMESTAMP('07-10-2018 11:30', 'dd-mm-yyyy hh24:mi'), 6, 5);
INSERT INTO consultas VALUES (31, TO_TIMESTAMP('01-09-2018 14:00', 'dd-mm-yyyy hh24:mi'), 7, 5);
INSERT INTO consultas VALUES (32, TO_TIMESTAMP('08-10-2017 16:30', 'dd-mm-yyyy hh24:mi'), 21, 5);
INSERT INTO consultas VALUES (34, TO_TIMESTAMP('08-08-2018 12:00', 'dd-mm-yyyy hh24:mi'), 21, 5);
INSERT INTO consultas VALUES (33, TO_TIMESTAMP('11-10-2017 10:00', 'dd-mm-yyyy hh24:mi'), 8, 5);
INSERT INTO consultas VALUES (35, TO_TIMESTAMP('05-10-2018 14:00', 'dd-mm-yyyy hh24:mi'), 22, 5);

INSERT INTO consultas VALUES (37, TO_TIMESTAMP('11-11-2009 14:30', 'dd-mm-yyyy hh24:mi'), 13, 6);
INSERT INTO consultas VALUES (38, TO_TIMESTAMP('22-08-2014 09:30', 'dd-mm-yyyy hh24:mi'), 15, 6);
INSERT INTO consultas VALUES (39, TO_TIMESTAMP('15-04-2015 14:00', 'dd-mm-yyyy hh24:mi'), 13, 6);

-- medicamentos
INSERT INTO medicamentos VALUES (1, 'Aspirina',  'Bayer');
INSERT INTO medicamentos VALUES (2, 'Voltaren',  'Novartis');
INSERT INTO medicamentos VALUES (3, 'Aspegic',   'Infarmed');
INSERT INTO medicamentos VALUES (4, 'Kompensan', 'Infarmed');
INSERT INTO medicamentos VALUES (5, 'Benuron',   'Infarmed');
INSERT INTO medicamentos VALUES (6, 'Xanax',     'Pfizer');
INSERT INTO medicamentos VALUES (7, 'Risidon',   'Infarmed');

---- medicamentos receitados
INSERT INTO medicamentos_receitados VALUES (1, 1); 
INSERT INTO medicamentos_receitados VALUES (1, 3); 
INSERT INTO medicamentos_receitados VALUES (1, 2); 
INSERT INTO medicamentos_receitados VALUES (1, 4); 

INSERT INTO medicamentos_receitados VALUES (2, 1);
INSERT INTO medicamentos_receitados VALUES (2, 4);
INSERT INTO medicamentos_receitados VALUES (2, 5); 
INSERT INTO medicamentos_receitados VALUES (2, 3);

INSERT INTO medicamentos_receitados VALUES (3, 1);
INSERT INTO medicamentos_receitados VALUES (3, 3);
INSERT INTO medicamentos_receitados VALUES (3, 5);
INSERT INTO medicamentos_receitados VALUES (3, 4);

INSERT INTO medicamentos_receitados VALUES (4, 4);
INSERT INTO medicamentos_receitados VALUES (4, 5);
INSERT INTO medicamentos_receitados VALUES (4, 7);
INSERT INTO medicamentos_receitados VALUES (4, 6);

INSERT INTO medicamentos_receitados VALUES (5, 1);
INSERT INTO medicamentos_receitados VALUES (5, 2);

INSERT INTO medicamentos_receitados VALUES (6, 1);
INSERT INTO medicamentos_receitados VALUES (9, 2);

INSERT INTO medicamentos_receitados VALUES (7, 2);
INSERT INTO medicamentos_receitados VALUES (7, 3);

INSERT INTO medicamentos_receitados VALUES (10, 4);

INSERT INTO medicamentos_receitados VALUES (12, 1);
INSERT INTO medicamentos_receitados VALUES (12, 2);
INSERT INTO medicamentos_receitados VALUES (12, 3);
INSERT INTO medicamentos_receitados VALUES (12, 4);

INSERT INTO medicamentos_receitados VALUES (16, 3);

INSERT INTO medicamentos_receitados VALUES (20, 1);
INSERT INTO medicamentos_receitados VALUES (20, 2);
INSERT INTO medicamentos_receitados VALUES (20, 3);
INSERT INTO medicamentos_receitados VALUES (20, 4);

INSERT INTO medicamentos_receitados VALUES (21, 1);
INSERT INTO medicamentos_receitados VALUES (21, 2);
INSERT INTO medicamentos_receitados VALUES (21, 3);
INSERT INTO medicamentos_receitados VALUES (21, 4);

INSERT INTO medicamentos_receitados VALUES (22, 3);
INSERT INTO medicamentos_receitados VALUES (22, 4);

INSERT INTO medicamentos_receitados VALUES (24, 2);

INSERT INTO medicamentos_receitados VALUES (25, 1);
INSERT INTO medicamentos_receitados VALUES (25, 2);
INSERT INTO medicamentos_receitados VALUES (25, 3);
INSERT INTO medicamentos_receitados VALUES (25, 4);

INSERT INTO medicamentos_receitados VALUES (29, 1);
INSERT INTO medicamentos_receitados VALUES (29, 2);


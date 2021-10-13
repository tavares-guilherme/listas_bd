CREATE TABLE Equipe(
	idequipe SERIAL NOT NULL, 
	nome VARCHAR(20) NOT NULL,
	estado CHAR(2),
	tipo VARCHAR(12),
	saldo_gols SMALLINT,
	
	CONSTRAINT equipe_pk PRIMARY KEY(idequipe),
	CONSTRAINT equipe_un UNIQUE(nome),
	CONSTRAINT equipe_ck CHECK(UPPER(tipo) IN ('AMADOR', 'PROFISSIONAL'))
);

CREATE TABLE Joga(
	idequipe1 SERIAL NOT NULL,
	idequipe2 SERIAL NOT NULL,
	classico CHAR(1),
	
	CONSTRAINT joga_pk PRIMARY KEY(idequipe1, idequipe2),
	CONSTRAINT equipe1_fk FOREIGN KEY(idequipe1) REFERENCES Equipe(idequipe) ON DELETE CASCADE,
	CONSTRAINT equipe2_fk FOREIGN KEY(idequipe2) REFERENCES Equipe(idequipe) ON DELETE CASCADE,
	CONSTRAINT equipes_ck CHECK(idequipe1 != idequipe2),
	CONSTRAINT classico_ck CHECK(UPPER(classico) IN ('S', 'N'))
);

CREATE TABLE Partida(
	idequipe1 SERIAL NOT NULL,
	idequipe2 SERIAL NOT NULL,
	data DATE NOT NULL,
	gols_equipe1 SMALLINT DEFAULT 0,
	gols_equipe2 SMALLINT DEFAULT 0,
	local VARCHAR(15),
	
	CONSTRAINT partida_pk PRIMARY KEY(idequipe1, idequipe2, data),
	CONSTRAINT equipes_fk FOREIGN KEY(idequipe1, idequipe2) REFERENCES Joga(idequipe1, idequipe2) ON DELETE CASCADE,
	CONSTRAINT placar_ck CHECK(gols_equipe1 >= 0 AND gols_equipe2 >= 0)
);

CREATE TABLE Jogador(
	rg CHAR(9) NOT NULL,
	nome VARCHAR(40) NOT NULL,
	data_nascimento DATE,
	naturalidade VARCHAR(20),
	equipe SERIAL NOT NULL,
	
	CONSTRAINT jogador_pk PRIMARY KEY(rg),
	CONSTRAINT jogador_equioe_fk FOREIGN KEY(equipe) REFERENCES Equipe(idequipe) ON DELETE CASCADE,
	CONSTRAINT jogador_un UNIQUE(nome)
);

CREATE TABLE Posicao_Jogador(
	jogador CHAR(9) NOT NULL,
	posicao VARCHAR(10) NOT NULL,
	CONSTRAINT posicao_jogador_pk PRIMARY KEY(jogador, posicao),
	CONSTRAINT posicao_jogador_fk FOREIGN KEY(jogador) REFERENCES Jogador(rg) ON DELETE CASCADE
);	
	
CREATE TABLE Diretor(
	equipe SERIAL NOT NULL,
	nome VARCHAR(20) NOT NULL,
	sobrenome VARCHAR(20) NOT NULL,
	
	CONSTRAINT diretor_pk PRIMARY KEY(equipe, nome, sobrenome),
	CONSTRAINT diretor_equipe_fk FOREIGN KEY(equipe) REFERENCES Equipe(idequipe) ON DELETE CASCADE
);	
	
CREATE TABLE Uniforme(
	equipe SERIAL NOT NULL,
	tipo  CHAR(7) NOT NULL,
	cor_principal VARCHAR(10),
	
	CONSTRAINT uniforme_pk PRIMARY KEY(equipe, tipo),
	CONSTRAINT uniforme_fk FOREIGN KEY(equipe) REFERENCES Equipe(idequipe) ON DELETE CASCADE,
   	CONSTRAINT CK_UNIFORME CHECK(UPPER(TIPO) IN('TITULAR', 'RESERVA'))
);

INSERT INTO Equipe VALUES(1, 'São Paulo', 'SP', 'PROFISSIONAL', 5);
INSERT INTO Equipe VALUES(2, 'Palmeiras', 'SP', 'PROFISSIONAL', 10);
INSERT INTO Equipe VALUES(3, 'Flamengo', 'RJ', 'PROFISSIONAL', 22);
INSERT INTO Equipe VALUES(4, 'Chapecoense', 'SC', 'PROFISSIONAL', 2);
INSERT INTO Equipe VALUES(5, 'Fluminense', 'RJ', 'PROFISSIONAL', 20);
INSERT INTO Equipe VALUES(6, 'Fortaleza', 'CE', 'PROFISSIONAL', 30);
INSERT INTO Equipe VALUES(7, 'Corinthians', 'SP', 'PROFISSIONAL', 19);
INSERT INTO Equipe VALUES(8, 'Cotia', 'SP', 'AMADOR', 2);
INSERT INTO Equipe VALUES(9, 'Boa Esperança', 'SP', 'AMADOR', 20);
INSERT INTO Equipe VALUES(10, 'Caaso', 'SP', 'AMADOR', 23);

INSERT INTO Joga VALUES(1, 2, 'S');
INSERT INTO Joga VALUES(1, 3, 'N');
INSERT INTO Joga VALUES(4, 3, 'N');
INSERT INTO Joga VALUES(5, 7, 'N');
INSERT INTO Joga VALUES(7, 1, 'S');
INSERT INTO Joga VALUES(3, 6, 'N');
INSERT INTO Joga VALUES(5, 3, 'S');
INSERT INTO Joga VALUES(6, 4, 'S');
INSERT INTO Joga VALUES(8, 9, 'N');
INSERT INTO Joga VALUES(9, 10, 'S');

INSERT INTO Partida VALUES(1, 2, '06/12/2021', 2, 2, 'Morumbi');
INSERT INTO Partida VALUES(1, 3, '10/12/2021', 0, 2, 'Morumbi');
INSERT INTO Partida VALUES(4, 3, '10/11/2021', 0, 4, 'Arena Condá');
INSERT INTO Partida VALUES(5, 7, '10/11/2021', 0, 0, 'Maracanã');
INSERT INTO Partida VALUES(7, 1, '10/09/2021', 1, 2, 'Neo Quimica');
INSERT INTO Partida VALUES(3, 6, '27/09/2021', 5, 2, 'Maracanã');
INSERT INTO Partida VALUES(5, 3, '27/09/2021', 3, 2, 'Maracanã');
INSERT INTO Partida VALUES(6, 4, '20/11/2021', 3, 2, 'Arena Castelão');
INSERT INTO Partida VALUES(8, 9, '15/07/2021', 1, 1 );
INSERT INTO Partida VALUES(9, 10, '15/06/2021', 3, 7);

INSERT INTO Jogador VALUES('123456789', 'Tiago Volpi', '20/11/1990', 'BRASIL', 1);
INSERT INTO Jogador VALUES('124526789', 'Gabriel Sara', '23/02/2000', 'BRASIL', 1);
INSERT INTO Jogador VALUES('157936691', 'Felipe Melo', '15/05/1980', 'BRASIL', 2);
INSERT INTO Jogador VALUES('399636691', 'Gabriel Barbosa', '15/05/1995', 'BRASIL', 3);
INSERT INTO Jogador VALUES('753145678', 'Andre Passos', '15/05/1998', 'ARGENTINA', 5);
INSERT INTO Jogador VALUES('559666691', 'Ronaldo Pereira', '30/08/1999', 'URUGUAI', 6);
INSERT INTO Jogador VALUES('586636691', 'Cleber Silva', '15/05/1993', 'BRASIL', 3);
INSERT INTO Jogador VALUES('996636698', 'Arboleda', '15/05/1980', 'EQUADOR', 1);
INSERT INTO Jogador VALUES('695536697', 'Reinaldo Alves', '15/05/1989', 'BRASIL', 7);
INSERT INTO Jogador VALUES('366669136', 'Bruno Oliveira', '15/06/1980', 'BRASIL', 4);
INSERT INTO Jogador VALUES('659891368', 'Fernando Oliveira', '15/05/2001', 'BRASIL', 8);

INSERT INTO Posicao_Jogador VALUES('123456789', 'GOLEIRO');
INSERT INTO Posicao_Jogador VALUES('124526789', 'MEIO CAMPO');
INSERT INTO Posicao_Jogador VALUES('157936691', 'ZAGUEIRO');
INSERT INTO Posicao_Jogador VALUES('399636691', 'ATACANTE');
INSERT INTO Posicao_Jogador VALUES('753145678', 'ZAGUEIRO');
INSERT INTO Posicao_Jogador VALUES('559666691', 'MEIO CAMPO');
INSERT INTO Posicao_Jogador VALUES('586636691', 'GOLEIRO');
INSERT INTO Posicao_Jogador VALUES('996636698', 'MEIO CAMPO');
INSERT INTO Posicao_Jogador VALUES('695536697', 'ATACANTE');
INSERT INTO Posicao_Jogador VALUES('366669136', 'ZAGUEIRO');
INSERT INTO Posicao_Jogador VALUES('659891368', 'GOLEIRO');

INSERT INTO Diretor VALUES(1, 'Rogerio', 'Tavares');
INSERT INTO Diretor VALUES(2, 'Reinaldo', 'Alves');
INSERT INTO Diretor VALUES(3, 'Marcos', 'Silva');
INSERT INTO Diretor VALUES(4, 'Regina', 'Pereira');
INSERT INTO Diretor VALUES(5, 'Bruno', 'Silva');
INSERT INTO Diretor VALUES(7, 'Emilio', 'Couto');
INSERT INTO Diretor VALUES(8, 'Severino', 'Pereira');
INSERT INTO Diretor VALUES(9, 'Leonardo', 'Oliveira');
INSERT INTO Diretor VALUES(10, 'Igor', 'Guida');

INSERT INTO Uniforme VALUES(1, 'TITULAR', 'BRANCO');
INSERT INTO Uniforme VALUES(1, 'RESERVA', 'VERMELHO');
INSERT INTO Uniforme VALUES(2, 'TITULAR', 'VERDE');
INSERT INTO Uniforme VALUES(2, 'RESERVA', 'BRANCO');
INSERT INTO Uniforme VALUES(3, 'TITULAR', 'VERMELHO');
INSERT INTO Uniforme VALUES(3, 'RESERVA', 'BRANCO');
INSERT INTO Uniforme VALUES(6, 'TITULAR', 'AZUL');
INSERT INTO Uniforme VALUES(8, 'TITULAR', 'AZUL');
INSERT INTO Uniforme VALUES(8, 'RESERVA', 'VERDE');
INSERT INTO Uniforme VALUES(10, 'TITULAR', 'AMARELO');
						   
--COMMIT;

/*DROP TABLE Uniforme;
DROP TABLE Diretor;
DROP TABLE Posicao_Jogador;
DROP TABLE Jogador;
DROP TABLE Partida;
DROP TABLE Joga;
DROP TABLE Equipe;*/

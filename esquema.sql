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
	jogador CHAR(12) NOT NULL,
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
)	

--COMMIT;

/*DROP TABLE Equipe;
DROP TABLE Joga;
DROP TABLE Partida;
DROP TABLE Jogador;
DROP TABLE Posicao_Jogador
DROP TABLE Diretor
DROP TABLE Uniforme;*/
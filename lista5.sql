CREATE SCHEMA IF NOT EXISTS public;

-- INDIVÍDUOS
CREATE TABLE IF NOT EXISTS public.individuos
(
	cpf CHAR(14) NOT NULL,
	nome VARCHAR(40) NOT NULL,
	estado CHAR(2),
	cidade VARCHAR(30),
	dataNascimento DATE,
	fichaLimpa BOOLEAN NOT NULL DEFAULT TRUE,
	tipo VARCHAR(9),
	
	CONSTRAINT individuo_pk PRIMARY KEY(cpf),
	CONSTRAINT individuo_un UNIQUE(nome),
	CONSTRAINT individuo_ck CHECK(UPPER(tipo) in ('DOADOR', 'CANDIDATO', 'EQUIPE'))
);

-- PARTIDO
CREATE TABLE IF NOT EXISTS public.partidos
(
	sigla VARCHAR(4) NOT NULL,
	nome VARCHAR(40) NOT NULL,
	Programa VARCHAR(150) NOT NULL,
	
	CONSTRAINT partido_pk PRIMARY KEY(sigla),
	CONSTRAINT partido_un UNIQUE(nome)
);

-- CANDIDATOS
CREATE TABLE IF NOT EXISTS public.candidatos
(
	cpf CHAR(14) NOT NULL,
	temVice BOOLEAN NOT NULL,
	viceCandidato VARCHAR(40) DEFAULT '-',
	sigla VARCHAR(4),
	
	CONSTRAINT candidato_pk  PRIMARY KEY(cpf),
	CONSTRAINT candidato_fk1 FOREIGN KEY(cpf) REFERENCES public.individuos(cpf) ON DELETE CASCADE,
	CONSTRAINT candidato_fk2 FOREIGN KEY(sigla) REFERENCES public.partidos(sigla) ON DELETE CASCADE
);

-- DOADORES DE CAMPANHA
CREATE TABLE IF NOT EXISTS public.doadores
(
	cpf CHAR(14) NOT NULL,
	fonte_de_renda VARCHAR(30),
	
	CONSTRAINT doador_pk PRIMARY KEY(cpf),
	CONSTRAINT doador_fk FOREIGN KEY(cpf) REFERENCES public.individuos(cpf) ON DELETE CASCADE
);

-- CARGOS
CREATE TABLE IF NOT EXISTS public.cargos
(
	idcargo SERIAL NOT NULL,
	nome VARCHAR(40) NOT NULL,
	tipoCargo VARCHAR(9) NOT NULL,
	referencia VARCHAR(30) NOT NULL,
	qtdEleitos SMALLINT DEFAULT 0,
	
	CONSTRAINT cargo_pk PRIMARY KEY(idcargo),
	CONSTRAINT cargo_un UNIQUE(nome),
	CONSTRAINT cargo_ck CHECK(UPPER(tipoCargo) IN ('CIDADE', 'ESTADO', 'FEDERACAO'))
);

-- CANDIDATURA
CREATE TABLE IF NOT EXISTS public.candidaturas
(
	idcandidatura SERIAL NOT NULL,
	candidato CHAR(14) NOT NULL,
	cargo SERIAL NOT NULL,
	ano SMALLINT NOT NULL,
	qtdVotos SMALLINT,
	
	CONSTRAINT candidatura_pk PRIMARY KEY(idcandidatura),
	CONSTRAINT candidatura_un UNIQUE(candidato, cargo, ano),
	CONSTRAINT candidatura_ck CHECK(ano < 2022 AND MOD(ano, 2) = 0),
	CONSTRAINT candidatura_fk1 FOREIGN KEY(candidato) REFERENCES public.candidatos(cpf) ON DELETE CASCADE,
	CONSTRAINT candidatura_fk2 FOREIGN KEY(cargo) REFERENCES public.cargos(idcargo) ON DELETE CASCADE	
);

-- EQUIPE DE APOIO
CREATE TABLE IF NOT EXISTS public.equipeApoio
(
	idequipe SERIAL NOT NULL,
	nome VARCHAR(40) NOT NULL,
	candidatura SERIAL NOT NULL,
	
	CONSTRAINT equipe_pk PRIMARY KEY(idequipe),
	CONSTRAINT equipe_un UNIQUE(nome),
	CONSTRAINT equipe_fk FOREIGN KEY(candidatura) REFERENCES public.candidaturas(idcandidatura)
);

-- PARTICIPANTES DA EQUIPE DE APOIO
CREATE TABLE IF NOT EXISTS public.participantesEquipe
(
	cpf CHAR(14) NOT NULL,
	ano SMALLINT NOT NULL,
	equipe SERIAL NOT NULL,
	
	CONSTRAINT part_equipe_pk  PRIMARY KEY(cpf),
	CONSTRAINT part_equipe_fk1 FOREIGN KEY(cpf) REFERENCES public.individuos(cpf) ON DELETE CASCADE,
	CONSTRAINT part_equipe_fk2 FOREIGN KEY(equipe) REFERENCES public.equipeApoio(idequipe) ON DELETE CASCADE,
	CONSTRAINT part_equipe_ck CHECK(ano < 2022 AND MOD(ano, 2) = 0)
);

-- Doação Indivíduo
CREATE TABLE IF NOT EXISTS public.doacaoIndividuo
(
	doador CHAR(14) NOT NULL,
	candidatura SERIAL NOT NULL,
	dataDoacao DATE NOT NULL,
	valor FLOAT NOT NULL,
	
	CONSTRAINT doador_candidatura_pk  PRIMARY KEY(doador, candidatura),
	CONSTRAINT doador_candidatura_fk1 FOREIGN KEY(doador) REFERENCES public.doadores(cpf) ON DELETE CASCADE,
	CONSTRAINT daodor_candidatura_fk2 FOREIGN KEY (candidatura) REFERENCES public.candidaturas(idcandidatura) ON DELETE CASCADE
);

-- EMPRESA
CREATE TABLE IF NOT EXISTS public.empresas
(
	cnpj CHAR(20) NOT NULL,
	nome VARCHAR(40) NOT NULL,
	estado CHAR(2),
	cidade VARCHAR(30),
	dataFundacao DATE,
	
	CONSTRAINT empresa_pk PRIMARY KEY(cnpj),
	CONSTRAINT empresa_un UNIQUE(nome)	
);

--DOACAOEMPRESA
CREATE TABLE IF NOT EXISTS public.doacaoEmpresa
(
	cnpj CHAR(20) NOT NULL,
	idCandidatura SERIAL NOT NULL,
	ano SMALLINT NOT NULL,
	valor FLOAT NOT NULL,
	
	CONSTRAINT doacao_empresa_pk PRIMARY KEY(cnpj, idCandidatura),
	CONSTRAINT empresa_empresa_fk1 FOREIGN KEY(cnpj) REFERENCES public.empresas(cnpj) ON DELETE CASCADE,
	CONSTRAINT empresa_empresa_fk2 FOREIGN KEY(idCandidatura) REFERENCES public.candidaturas(idcandidatura) ON DELETE CASCADE
	
);

-- PROCESSOS JUDICIAIS
CREATE TABLE IF NOT EXISTS public.processosJudiciais
(
	idprocesso SERIAL NOT NULL,
	procedente BOOLEAN DEFAULT FALSE,
	julgado BOOLEAN NOT NULL,
	dataTermino DATE,
	individuo CHAR(14) NOT NULL,
	
	CONSTRAINT processo_pk PRIMARY KEY(idprocesso),
	CONSTRAINT processo_fk FOREIGN KEY(individuo) REFERENCES public.individuos(cpf) ON DELETE CASCADE
	
);

-------- Triggers
--- Impede que candidatos ficha suja sejam candidatos
--Tratamento
CREATE OR REPLACE FUNCTION checkFichaLimpa() RETURNS trigger AS $checkFichaLimpa$
BEGIN 
	PERFORM * FROM individuos I WHERE (I.cpf = NEW.cpf AND (NOT I.fichaLimpa));
	IF FOUND THEN
		RAISE EXCEPTION 'Este candidato não pode se candidatar pois não possui ficha limpa.';
	END IF;
	RETURN NEW;
END;
$checkFichaLimpa$ LANGUAGE plpgsql;

-- Definicao do Trigger
CREATE TRIGGER checkFichaLimpa
BEFORE INSERT ON candidatos
FOR EACH ROW EXECUTE PROCEDURE checkFichaLimpa();
---------------------------------------------------------------------------
-- Garante que um candidado, é um indivíduo de tipo candidato
--Tratamento
CREATE OR REPLACE FUNCTION checkCandidato() RETURNS trigger AS $checkCandidato$
BEGIN 
	PERFORM * FROM individuos I WHERE (I.cpf = NEW.cpf AND I.tipo != 'CANDIDATO');
	IF FOUND THEN
		RAISE EXCEPTION 'Este indivíduo não é um candidato.';
	END IF;
	RETURN NEW;
END;
$checkCandidato$ LANGUAGE plpgsql;

-- Definicao do Trigger
CREATE TRIGGER checkCandidato
BEFORE INSERT ON candidatos
FOR EACH ROW EXECUTE PROCEDURE checkCandidato();
---------------------------------------------------------------------------
-- Garante que um candidado, é um indivíduo de tipo candidato
--Tratamento
CREATE OR REPLACE FUNCTION checkDoador() RETURNS trigger AS $checkDoador$
BEGIN 
	PERFORM * FROM individuos I WHERE (I.cpf = NEW.cpf AND I.tipo != 'DOADOR');
	IF FOUND THEN
		RAISE EXCEPTION 'Este indivíduo não é um doador de campanha.';
	END IF;
	RETURN NEW;
END;
$checkDoador$ LANGUAGE plpgsql;

-- Definicao do Trigger
CREATE TRIGGER checkDoador
BEFORE INSERT ON doadores
FOR EACH ROW EXECUTE PROCEDURE checkDoador();
---------------------------------------------------------------------------
-- Garante que um candidado, é um indivíduo de tipo candidato
--Tratamento
CREATE OR REPLACE FUNCTION checkParticipantesEquipe() RETURNS trigger AS $checkParticipantesEquipe$
BEGIN 
	PERFORM * FROM individuos I WHERE (I.cpf = NEW.cpf AND I.tipo != 'EQUIPE');
	IF FOUND THEN
		RAISE EXCEPTION 'Este indivíduo não é um membro de uma equipe de campanha';
	END IF;
	RETURN NEW;
END;
$checkParticipantesEquipe$ LANGUAGE plpgsql;

-- Definicao do Trigger
CREATE TRIGGER checkParticipantesEquipe
BEFORE INSERT ON participantesequipe
FOR EACH ROW EXECUTE PROCEDURE checkParticipantesEquipe();
---------------------------------------------------------------------------

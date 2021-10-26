-- Ex 5

-- Definicao da funcao check_terceirizado_fc()
CREATE OR REPLACE FUNCTION check_terceirizado_fc() RETURNS trigger AS 
	$check_terceirizado_fc$
BEGIN
	PERFORM * FROM L11_TERCEIRIZADO WHERE TCPF = NEW.PECPF;
	IF FOUND THEN
		RAISE EXCEPTION 'Este funcionário já se encontra na tabela de terceirizados';
	END IF;
	RETURN NEW;
END;
$check_terceirizado_fc$ LANGUAGE plpgsql;

-- Definicao do trigger
CREATE TRIGGER check_terceirizado_fc
BEFORE UPDATE OR INSERT ON L10_permanente
FOR EACH ROW EXECUTE PROCEDURE check_terceirizado_fc();

-- Ex 6 (Pseudo Codigo)

/*

BEGIN

    PERFORM * FROM sessao
        JOIN sala ON (nr_sala = nr_sala AND id_cinema = id_cinema_s)
        JOIN cinema ON cinema_onde_ocorre = id_cinema
    WHERE id_cinema_s <> id_cinema
    IF FOUND THEN
        RAISE EXCEPTION 'Cinema e Sala inconsistentes';
    END IF
    RETURN NEW;
END;

CREATE TRIGGER check_cinema_sala
BEFORE UPDATE OR INSERT ON sessao
EXECUTE PROCEDURE check_cinema_sala();

*/

-- Ex 7 

-- Função Para contar as Tuplas
CREATE OR REPLACE FUNCTION count_function () RETURNS integer AS $count_function$  
     BEGIN
     RETURN (SELECT COUNT(*) FROM Matricula);
END;
$count_function$ LANGUAGE plpgsql;

-- Função para exibir o número de tuplas
CREATE OR REPLACE FUNCTION count_matriculas() RETURNS trigger AS $count_matriculas$
BEGIN
	RAISE NOTICE 'Número total de matriculas: --> %', count_function();
	RETURN NULL;
END;
$count_matriculas$ LANGUAGE plpgsql;

-- Trigger antes da operação
CREATE TRIGGER count_matriculas_before
BEFORE UPDATE OR INSERT OR DELETE ON Matricula
EXECUTE PROCEDURE count_matriculas();

-- Trigger depois da operação
CREATE TRIGGER count_matriculas_after
AFTER UPDATE OR INSERT OR DELETE ON Matricula
EXECUTE PROCEDURE count_matriculas();

-- Ex 8 

-- Adiciona o Atributo 'aprovacao'
ALTER TABLE Matricula
ADD aprovacao BOOLEAN DEFAULT false;

-- Procedimento para alterar as aprovações
CREATE OR REPLACE FUNCTION set_aprovados() RETURNS void AS $set_aprovados$
BEGIN
	UPDATE Matricula SET aprovacao = true WHERE nota >= 5;
END;
$set_aprovados$ LANGUAGE plpgsql;

SELECT set_aprovados();
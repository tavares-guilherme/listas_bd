-- EX a)
SELECT DISTINCT F.f_nome FROM Catalogo C
	JOIN Pecas P ON C.p_id = P.p_id
	JOIN fornecedores F ON C.f_id = F.f_id
WHERE P.cor = 'vermelho';

-- Ex b)
SELECT DISTINCT F.f_nome FROM Catalogo C
	JOIN Pecas P ON C.p_id = P.p_id
	JOIN fornecedores F ON C.f_id = F.f_id
WHERE P.cor = 'vermelho' OR F.endereço = 'Av. São Carlos';


-- Ex c)
SELECT DISTINCT F.f_nome FROM Catalogo C
	JOIN Pecas P ON C.p_id = P.p_id
	JOIN fornecedores F ON C.f_id = F.f_id
WHERE P.cor = 'vermelho'
INTERSECT
SELECT DISTINCT F.f_nome FROM Catalogo C
	JOIN Pecas P ON C.p_id = P.p_id
	JOIN fornecedores F ON C.f_id = F.f_id
WHERE P.cor = 'verde';	

-- Ex d)
SELECT F1.f_id, F2.f_id, P.p_id FROM Pecas P
	JOIN Catalogo C1 ON C1.p_id = P.p_id 
	JOIN Catalogo C2 ON C2.p_id = P.p_id 
	JOIN fornecedores F1 ON C1.f_id = F1.f_id
	JOIN fornecedores F2 ON C2.f_id = F2.f_id
WHERE C1.preco > C2.preco;
 	
-- Ex e)
SELECT P.p_nome, P.cor, F.f_nome, C.preco FROM Catalogo C
	JOIN Pecas P ON C.p_id = P.p_id
	JOIN fornecedores F ON C.f_id = F.f_id
ORDER BY P.p_id;

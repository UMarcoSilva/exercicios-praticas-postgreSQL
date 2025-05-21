CREATE FUNCTION primeira_funcao() RETURNS INTEGER AS'
	SELECT (5-3)*2
'LANGUAGE SQL;

SELECT  primeira_funcao() AS numero;

CREATE FUNCTION somaDoisNumeros(numero1 INTEGER, numero2 INTEGER) RETURNS INTEGER AS '
	SELECT numero1 + numero2;
' LANGUAGE SQL;

SELECT somaDoisNumeros(4,2);

CREATE FUNCTION somaDoisNumerosSemNomear(INTEGER, INTEGER) RETURNS INTEGER AS '
	SELECT $1 + $2;
' LANGUAGE SQL;

SELECT somaDoisNumerosSemNomear(4,2);


CREATE TABLE a (nome VARCHAR(255) NOT NULL);

DROP FUNCTION cria_a;
CREATE OR REPLACE FUNCTION cria_a(nome VARCHAR) RETURNS VOID AS $$
	INSERT INTO a (nome) VALUES ('MARCO');
	SELECT * FROM a;
$$ LANGUAGE SQL;

SELECT cria_a('marco');








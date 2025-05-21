CREATE TABLE instrutor(
 id SERIAL PRIMARY KEY,
 nome VARCHAR(255) NOT NULL,
 salario DECIMAL(10,2)
);

INSERT INTO instrutor(nome, salario) VALUES ('Marco', 2500.50);
INSERT INTO instrutor(nome, salario) VALUES ('David Nine', 900);
INSERT INTO instrutor(nome, salario) VALUES ('Luqueta Ribeiro', 100.75);
INSERT INTO instrutor(nome, salario) VALUES ('Robert Lima', 2000);
INSERT INTO instrutor(nome, salario) VALUES ('Juliete Brito', 1000);

CREATE FUNCTION dobroSalario(instrutor) RETURNS DECIMAL AS $$
	SELECT $1.salario * 2 AS dobro;
$$ LANGUAGE SQL;

SELECT nome, dobroSalario(instrutor) FROM instrutor;

CREATE FUNCTION instrutorFalso() RETURNS instrutor AS $$
	SELECT 22, 'marco', 200::DECIMAL;
$$ LANGUAGE SQL;

SELECT * FROM instrutorFalso();

DROP FUNCTION instrutoresBemPagos;
CREATE FUNCTION instrutoresBemPagos(valorSalario DECIMAL) RETURNS SETOF instrutor AS $$
	SELECT * FROM instrutor WHERE salario > valorSalario;
$$ LANGUAGE SQL;

SELECT * FROM instrutoresBemPagos(1000);

-- Depreferência para funções sem record por boas práticas
CREATE FUNCTION instrutoresBemPagosComRecord(valorSalario DECIMAL, OUT nome VARCHAR, OUT salario DECIMAL) RETURNS SETOF record AS $$
	SELECT nome, salario FROM instrutor WHERE salario > valorSalario;
$$ LANGUAGE SQL;

SELECT * FROM instrutoresBemPagosComRecord(1000);


CREATE FUNCTION somaEProduto(IN numero1 INTEGER, IN numero2 INTEGER, OUT soma INTEGER, OUT produtos INTEGER ) AS $$
	SELECT numero1 + numero2 AS soma, numero1 * numero2 AS produto;
$$ LANGUAGE SQL;

SELECT * FROM somaEProduto(3,3);


CREATE TYPE doisValores AS (soma INTEGER, produto INTEGER);

CREATE FUNCTION somaEProdutoComType(numero1 INTEGER, numero2 INTEGER) RETURNS doisValores AS $$
	SELECT numero1 + numero2 AS soma, numero1 * numero2 AS produto;
$$ LANGUAGE SQL;

SELECT * FROM somaEProdutoComType(3,3);




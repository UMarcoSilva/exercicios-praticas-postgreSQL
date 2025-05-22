CREATE TABLE instrutor(
 id SERIAL PRIMARY KEY,
 nome VARCHAR(255) NOT NULL,
 salario DECIMAL(10,2)
);

--

CREATE FUNCTION instrutorFalsoComPlpgsql() RETURNS instrutor AS $$
	DECLARE
		retorno instrutor;
	BEGIN
		SELECT 22, 'marco', 200::DECIMAL INTO retorno;
		RETURN retorno;
	END;
$$ LANGUAGE plpgsql;

SELECT * FROM instrutorFalso();

--

DROP FUNCTION instrutoresBemPagosComPlpgSQL;
CREATE FUNCTION instrutoresBemPagosComPlpgsql(valorSalario DECIMAL) RETURNS SETOF instrutor AS $$
	BEGIN
		RETURN QUERY SELECT * FROM instrutor WHERE salario > valorSalario;
	END;
$$ LANGUAGE plpgsql;

SELECT * FROM instrutoresBemPagos(1000);

--

CREATE TYPE soma_produto AS (
    soma INTEGER,
    produto INTEGER
);

CREATE OR REPLACE FUNCTION somaEProdutoComPlpgsql(IN numero1 INTEGER, IN numero2 INTEGER) RETURNS soma_produto AS $$
	BEGIN
    	RETURN ROW(numero1 + numero2, numero1 * numero2);
	END;
$$ LANGUAGE plpgsql;

SELECT * FROM somaEProdutoComPlpgsql(3, 4);

--

CREATE OR REPLACE FUNCTION salarioOk(instrutor instrutor) RETURNS VARCHAR AS $$  
	BEGIN
		/* IF instrutor.salario > 1000 THEN
			RETURN 'Salário está bom';
		ELSE IF instrutor.salario = 1000 THEN
			RETURN 'Salário pode aumentar';
		ELSE
			RETURN 'Salário está defasado';
			END IF;	
		END IF; */
		CASE
			WHEN instrutor.salario < 1000 THEN
				RETURN 'Salario muito baixo';
			WHEN instrutor.salario >1500 THEN
				RETURN 'Salario muito bom';
			WHEN instrutor.salario = 100 THEN
				RETURN 'Salario pode aumentar';
			ELSE
				RETURN 'Salário precisa ser revisto';
			END CASE;
	END;	
$$ LANGUAGE plpgsql;

SELECT nome, salario, salarioOk(instrutor) FROM instrutor;

DROP FUNCTION tabuada;

CREATE OR REPLACE FUNCTION tabuadaComExitWhen(numero INTEGER) RETURNS SETOF VARCHAR(255) AS $$
	DECLARE
		multiplicador INTEGER DEFAULT 1;
	BEGIN
			LOOP
			RETURN NEXT numero || ' x ' || multiplicador || ' = ' || numero * multiplicador;
			multiplicador := multiplicador +1;
			EXIT WHEN multiplicador = 11;
		END LOOP;
	END;
$$ LANGUAGE plpgsql;
SELECT tabuadaComExitWhen(10);


CREATE OR REPLACE FUNCTION tabuada(numero INTEGER) RETURNS SETOF VARCHAR(255) AS $$
	DECLARE
		multiplicador INTEGER DEFAULT 1;
	BEGIN
			WHILE multiplicador <= 10 LOOP
			RETURN NEXT numero || ' x ' || multiplicador || ' = ' || numero * multiplicador;
			multiplicador := multiplicador +1;
		END LOOP;
	END;
$$ LANGUAGE plpgsql;
SELECT tabuada(10);

CREATE OR REPLACE FUNCTION tabuadaComFor(numero INTEGER) RETURNS SETOF VARCHAR(255) AS $$
	BEGIN
		FOR multiplicador IN 1..9 LOOP
			RETURN NEXT numero || ' x ' || multiplicador || ' = ' || numero * multiplicador;
		END LOOP;
	END;
$$ LANGUAGE plpgsql;

SELECT tabuadaComFor(10);

DROP FUNCTION instrutorComSalario;
CREATE OR REPLACE FUNCTION instrutorComSalario(OUT nome_instrutor VARCHAR, OUT status_salario VARCHAR) 
RETURNS SETOF record AS $$
DECLARE
	instrutor_atual instrutor;
BEGIN
	FOR instrutor_atual IN SELECT * FROM instrutor LOOP
		nome_instrutor := instrutor_atual.nome;
		status_salario := salarioOk(instrutor_atual); -- passa o registro completo

		RETURN NEXT;
	END LOOP;	
END;
$$ LANGUAGE plpgsql;

SELECT * FROM instrutorComSalario();



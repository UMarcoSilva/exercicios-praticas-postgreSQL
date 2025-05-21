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
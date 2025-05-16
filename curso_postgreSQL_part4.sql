CREATE SEQUENCE sequencia_minha;

SELECT NEXTVAL('sequencia_minha');

DROP TABLE auto;
CREATE TEMPORARY TABLE  auto(
	id INTEGER PRIMARY KEY DEFAULT NEXTVAL('sequencia_minha'),
	nome VARCHAR(30) NOT NULL
);

INSERT INTO auto(nome) VALUES ('marco');
INSERT INTO auto(id, nome) VALUES (2 ,'2marcos');
INSERT INTO auto(nome) VALUES ('thiago');

SELECT * FROM auto;

CREATE TYPE CLASSIFICACAO AS ENUM('LIVRE', '12_ANOS', '14_ANOS', '16_ANOS', '18_ANOS');
CREATE TEMPORARY TABLE filme(
	id SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL,
	classificacao CLASSIFICACAO
);

INSERT INTO filme (nome, classificacao) VALUES ('filme do marco', '12_ANOS');
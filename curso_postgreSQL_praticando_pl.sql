CREATE DATABASE alura;

CREATE TABLE aluno (
    id SERIAL PRIMARY KEY,
    primeiro_nome VARCHAR(255) NOT NULL,
    ultimo_nome VARCHAR(255) NOT NULL, 
    data_nascimento DATE NOT NULL
);

CREATE TABLE categoria (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE curso (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL, 
    categoria_id INTEGER NOT NULL REFERENCES categoria(id)
);

CREATE TABLE aluno_curso (
    aluno_id INTEGER NOT NULL REFERENCES aluno(id),
    curso_id INTEGER NOT NULL REFERENCES curso(id),
    PRIMARY KEY (aluno_id, curso_id)
);


CREATE FUNCTION cria_curso (nome_curso VARCHAR, nome_categoria VARCHAR) RETURNS void AS $$ 
	DECLARE
		id_categoria INTEGER;
	BEGIN
		SELECT id INTO id_categoria from categoria WHERE nome = nome_categoria;
		IF NOT FOUND THEN
			INSERT INTO categoria (nome) VALUES (nome_categoria) RETURNING id INTO id_categoria;
		END IF;

		INSERT INTO curso (nome, categoria_id) VALUES (nome_curso, id_categoria);
	END;
$$ LANGUAGE plpgsql;

SELECT cria_curso('Java', 'Programação');
SELECT cria_curso('C#', 'Programação');

SELECT * FROM curso;
SELECT * FROM categoria;


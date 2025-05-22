CREATE TABLE log_instrutores (
    id SERIAL PRIMARY KEY,
    informacao VARCHAR(255),
    momento_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP FUNCTION cria_instrutor;
CREATE OR REPLACE FUNCTION cria_instrutor () RETURNS TRIGGER AS $$
    DECLARE 
        media_salarial DECIMAL;
        instrutores_recebem_menos INTEGER DEFAULT 0;
        total_instrutores INTEGER DEFAULT 0;
        salario DECIMAL;
        percentual DECIMAL(10,2);
        cursor_salarios refcursor;
    BEGIN
        SELECT AVG(instrutor.salario) INTO media_salarial FROM instrutor WHERE id <> NEW.id;
            IF NEW.salario > media_salarial THEN
                INSERT INTO log_instrutores (informacao) VALUES (NEW.nome|| ' recebe acima da média');
--                 GET DIAGNOSTICS  logs_inseridos = ROW_COUNT;
--
--                 IF logs_inseridos > 1 THEN
--                     RAISE EXCEPTION 'Algo está de errado';
--                 end if;
            END IF;

--             FOR salario IN SELECT instrutor.salario FROM instrutor WHERE id <> NEW.id
            SELECT instrutores_internos(NEW.id) INTO cursor_salarios;
            LOOP
                FETCH cursor_salarios INTO salario;
                EXIT WHEN NOT FOUND;
                total_instrutores := total_instrutores + 1;
--                 RAISE NOTICE 'salario inserido: % salário do instrutor existente: %', NEW.salario, salario;

                IF NEW.salario > salario THEN
                    instrutores_recebem_menos := instrutores_recebem_menos + 1;
                END IF;
            END LOOP;

            percentual = instrutores_recebem_menos::DECIMAL / total_instrutores::DECIMAL * 100;
            ASSERT percentual > 100::DECIMAL, 'Instrutores novos não podem recer mais que  os antigos';

            INSERT INTO log_instrutores (informacao)
                VALUES (NEW.nome || ' recebe mais do que ' || percentual || '% da grade de instrutores');
        RETURN NEW;
    EXCEPTION
        WHEN undefined_column THEN
            RAISE NOTICE 'Houve algo de errado';
        RAISE EXCEPTION 'Erro complicado de resolver';
    END;
$$ LANGUAGE plpgsql;

DROP TRIGGER cria_log_instrutores ON instrutor;
CREATE  TRIGGER cria_log_instrutores BEFORE INSERT OR UPDATE ON instrutor
	FOR EACH ROW EXECUTE FUNCTION cria_instrutor();

SELECT * FROM instrutor;
SELECT cria_instrutor('marcio', 1000);
SELECT * FROM log_instrutores;


INSERT INTO instrutor (nome, salario) VALUES ('Gilmar', 600);

BEGIN;
INSERT INTO instrutor (nome, salario) VALUES ('Menezes', 800000);
ROLLBACK;


CREATE FUNCTION instrutores_internos(id_instrutor INTEGER) RETURNS refcursor AS $$
        DECLARE
            cursor_salarios refcursor;
        BEGIN
            OPEN cursor_salarios FOR SELECT instrutor.salario
                FROM instrutor
                WHERE id <>  id_instrutor
                AND salario>0;
            RETURN cursor_salarios;
        END;
$$ LANGUAGE plpgsql;

-- Bloco anônimo
DO $$
    DECLARE
        cursor_salarios refcursor;
        salario DECIMAL(10,2);
        total_instrutores INTEGER DEFAULT 0;
        instrutores_recebem_menos INTEGER DEFAULT 0;
        percentual DECIMAL(10,2);
    BEGIN
        SELECT instrutores_internos(12) INTO cursor_salarios;
            LOOP
                FETCH cursor_salarios INTO salario;
                EXIT WHEN NOT FOUND;
                total_instrutores := total_instrutores + 1;
--                 RAISE NOTICE 'salario inserido: % salário do instrutor existente: %', NEW.salario, salario;

                IF 600 > salario THEN
                    instrutores_recebem_menos := instrutores_recebem_menos + 1;
                END IF;
            END LOOP;
        percentual = instrutores_recebem_menos::DECIMAL / total_instrutores::DECIMAL * 100;
        RAISE NOTICE 'Percentual: % %%', percentual;
    end;
    $$;
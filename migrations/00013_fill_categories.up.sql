CREATE PROCEDURE FillCategories()
BEGIN
    DECLARE i                   INT;
    DECLARE j                   INT;
    DECLARE k                   INT;
    DECLARE parent_term_id      INT; 
    DECLARE child_term_id       INT; 
    DECLARE grand_child_term_id INT; 
    
    SET i = 1;
    SET j = 1;
    SET k = 1;
    WHILE i <= 25 DO
        INSERT INTO wp_terms (name, slug) VALUES (CONCAT('cat', ' ', i), CONCAT('cat-', i));
        SELECT LAST_INSERT_ID() INTO parent_term_id;
        INSERT INTO wp_term_taxonomy (term_id, taxonomy, description) VALUES (parent_term_id, 'category', '');

        SET j = 1;
        WHILE j <= 10 DO
            INSERT INTO wp_terms (name, slug) VALUES (CONCAT('cat', ' ', i, ' subcat', ' ', j), CONCAT('cat-', i, '-subcat-', j));
            SELECT LAST_INSERT_ID() INTO child_term_id;
            INSERT INTO wp_term_taxonomy (term_id, taxonomy, description, parent) VALUES (child_term_id, 'category', '', parent_term_id);

            SET k = 1;
            WHILE k <= 5 DO
                INSERT INTO wp_terms (name, slug) VALUES (CONCAT('cat', ' ', i, ' subcat', ' ', j, ' subsubcat', ' ', k), CONCAT('cat-', i, '-subcat-', j, '-subsubcat-', k));
                SELECT LAST_INSERT_ID() INTO grand_child_term_id;
                INSERT INTO wp_term_taxonomy (term_id, taxonomy, description, parent) VALUES (grand_child_term_id, 'category', '', child_term_id);
                SET k = k + 1;
            END WHILE;
            SET j = j + 1;
        END WHILE;
        SET i = i + 1;
    END WHILE;
END;

CALL FillCategories();

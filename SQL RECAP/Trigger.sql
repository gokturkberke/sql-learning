DELIMITER $$ --  Bu satır, SQL komutlarının normalde bittiği yeri gösteren noktalı virgül (;) karakterini geçici olarak $$ karakteriyle değiştirir.

CREATE TRIGGER must_be_adult
	BEFORE INSERT ON users FOR EACH ROW
    BEGIN
		IF NEW.age < 18
        THEN
			SIGNAL SQLSTATE '45000' -- '45000' genellikle geliştiricilerin kendi özel hata durumlarını belirtmek için kullandığı genel bir SQLSTATE 
				SET MESSAGE_TEXT = 'Must be an adult!';
		END IF;
	END;
$$ -- create trigger komutunun tamaminin bittigini belirtir

DELIMITER ; -- komut sonlandiriciyi tekrar varsayilan noktali virgule dondurur
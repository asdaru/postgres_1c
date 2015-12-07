# Сборка postgres 9.4 для использования с 1С

Правила использования
 * Создайте папку на сервере в которой будут располагаться базы данных. 
 * Запустите докер контейнер прописав папку и пароль к базе данных
 * Подключайтесь к базе данных из 1С используя в качестве имени пользователя: postgres и ваш пароль

```
docker run -d -p 5432:5432 -v /путь/к/папке/на/сервере/с/базой:/var/lib/postgresql/data POSTGRES_PASSWORD=пароль_для_подключения --name postgres_1c --restart=always asdaru/postgres_1c
```

Для управления базами можно войти внутрь контейнера используя
```
docker exec -t -i postgres_1c /bin/bash
```

postgres_1c - имя контейнера которое вы задали при запуске

Перед созданием новой базы надо привести строки в файле postgres.conf, раздел VERSION/PLATFORM COMPATIBILITY, вот к такому виду
```
#array_nulls = on
backslash_quote = on 
#default_with_oids = off
escape_string_warning = off
#lo_compat_privileges = off
#quote_all_identifiers = off
#sql_inheritance = on
standard_conforming_strings = off
```
Это можно сделать снаружи контейнера и перезапустить контейнер
docker stop postgres_1c && docker start postgres_1c

После соpдания базы изменения надо убрать

```
#array_nulls = on
backslash_quote = safe_encoding     # on, off, or safe_encoding
#default_with_oids = off
#escape_string_warning = off #on
#lo_compat_privileges = off
#quote_all_identifiers = off
#sql_inheritance = on
#standard_conforming_strings = off #on
#synchronize_seqscans = on
```

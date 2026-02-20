# Installation rapide Chester v12

## 1. Base de donnees (5 minutes)

```bash
# Se connecter a PostgreSQL
sudo -u postgres psql

# Creer la base si necessaire
CREATE DATABASE minetest;
CREATE USER minetest WITH PASSWORD 'votre_mot_de_passe';
GRANT ALL PRIVILEGES ON DATABASE minetest TO minetest;
\q

# Creer la table
psql -U minetest -d minetest -f sql/00_create_table.sql

# Importer les donnees (dans l'ordre)
psql -U minetest -d minetest -f sql/ethereal_complete.sql
psql -U minetest -d minetest -f sql/glooptest_complete.sql
psql -U minetest -d minetest -f sql/gloopblocks_complete.sql
psql -U minetest -d minetest -f sql/rings_complete.sql
psql -U minetest -d minetest -f sql/supercub_complete.sql

# Verifier
psql -U minetest -d minetest -c "SELECT COUNT(*) FROM chester_knowledge;"
# Devrait afficher environ 360 entrees
```

## 2. API PHP (2 minutes)

```bash
# Copier l'API
sudo cp api/chester_api.php /var/www/html/

# Editer la configuration
sudo nano /var/www/html/chester_api.php
# Modifier la ligne:
# $password = "votre_mot_de_passe";

# Tester
curl "http://localhost/chester_api.php?q=ethereal"
# Devrait retourner du JSON
```

## 3. Mod Minetest (3 minutes)

```bash
# Copier le mod
cp -r chester /chemin/vers/minetest/mods/

# Editer minetest.conf
nano minetest.conf
```

Ajouter:
```conf
secure.http_mods = chester
secure.trusted_mods = chester
```

Si l'API n'est pas sur localhost:
```conf
chester_api_url = http://votre-serveur/chester_api.php
```

## 4. Activer et tester (1 minute)

1. Demarrer Minetest
2. Activer le mod "chester" dans le monde
3. Rejoindre le jeu
4. Taper: `/chester help ethereal`

Si ca marche, Chester repond avec des infos sur Ethereal !

## Troubleshooting rapide

**Erreur "HTTP API non disponible"**
- Verifier `secure.http_mods = chester` dans minetest.conf
- Redemarrer Minetest

**Chester ne repond pas**
- Tester l'API: `curl "http://localhost/chester_api.php?q=test"`
- Verifier les logs: `tail -f ~/.minetest/debug.txt`

**Erreur base de donnees**
- Verifier connexion: `psql -U minetest -d minetest -c "SELECT 1;"`
- Verifier mot de passe dans chester_api.php

## Commandes de base

- `/chester help <mot>` - Demander de l'aide
- `/chester list` - Voir les categories
- `/spawn` - Aller au spawn
- `/giveme_chester` - Obtenir l'oeuf (admin)

## C'est tout !

Chester devrait maintenant repondre a toutes les questions sur les mods du serveur.

Pour ajouter plus de connaissances:
```sql
INSERT INTO chester_knowledge (category, keyword, content, priority) 
VALUES ('mod', 'nouveau_mod', 'Description simple', 80);
```

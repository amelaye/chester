# Chester v12 - Bot d'aide avec base PostgreSQL

Chester est un PNJ guide qui aide les joueurs en repondant à leurs questions sur les mods du serveur.

## Nouveautés v12

- **Base PostgreSQL** : Les connaissances sont stockées dans PostgreSQL
- **API PHP** : Chester interroge une API PHP pour accéder aux données
- **Extensible** : Ajoutez facilement de nouvelles connaissances via SQL
- **Performant** : Recherche indexée rapide
- **Maintenable** : Plus de gros fichiers Lua à maintenir

## Architecture

```
Chester (Lua) → HTTP → API PHP → PostgreSQL
```

## Installation

### 1. Base de données PostgreSQL

```sql
-- Créer la table
CREATE TABLE chester_knowledge (
    id SERIAL PRIMARY KEY,
    category VARCHAR(50) NOT NULL,
    keyword VARCHAR(100) NOT NULL,
    content TEXT NOT NULL,
    priority INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Index pour recherche rapide
CREATE INDEX idx_keyword ON chester_knowledge(keyword);
CREATE INDEX idx_category ON chester_knowledge(category);

-- Trigger pour updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_chester_knowledge_updated_at
    BEFORE UPDATE ON chester_knowledge
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();
```

### 2. Importer les données

Les scripts SQL fournis contiennent toutes les connaissances :

```bash
psql -U minetest -d minetest -f ethereal_complete.sql
psql -U minetest -d minetest -f glooptest_complete.sql
psql -U minetest -d minetest -f gloopblocks_complete.sql
psql -U minetest -d minetest -f rings_complete.sql
psql -U minetest -d minetest -f supercub_complete.sql
```

### 3. API PHP

Placer `chester_api.php` dans votre serveur web :

```bash
cp chester_api.php /var/www/html/
chmod 644 /var/www/html/chester_api.php
```

Editer la configuration dans le fichier :

```php
$host = "localhost";
$dbname = "minetest";
$user = "minetest";
$password = "votre_mot_de_passe";
```

Tester l'API :
```bash
curl "http://localhost:8080/chester_api.php?q=ethereal"
```

### 4. Configuration Minetest

Editer `minetest.conf` :

```conf
# Autoriser Chester à faire des requêtes HTTP
secure.http_mods = chester
secure.trusted_mods = chester

# Si vous utilisez un autre serveur/port
# chester_api_url = http://votre-serveur:8080/chester_api.php
```

### 5. Installation du mod

```bash
cd /votre/dossier/minetest/mods
cp -r chester /votre/dossier/minetest/mods/
```

Activer le mod dans le monde.

## Configuration

### Dans init.lua

Modifier l'URL de l'API si nécessaire :

```lua
local API_URL = "http://localhost:8080/chester_api.php"
```

### Position de spawn

Modifier la position de spawn de Chester :

```lua
local CHESTER_SPAWN = {x = -754, y = 1.5, z = -230}
```

## Utilisation

### Commandes joueurs

- `/chester help <mot>` - Demander de l'aide sur un sujet
  - Exemple : `/chester help ethereal`
  - Exemple : `/chester help celestial_ring`
  - Exemple : `/chester help supercub`

- `/chester list` - Voir les catégories disponibles

- `/spawn` - Se téléporter au spawn

### Commandes admin

- `/giveme_chester` - Obtenir l'œuf de spawn Chester (privilege `server`)

### Interaction PNJ

Clic droit sur Chester pour qu'il vous salue.

## Ajouter des connaissances

### Via SQL

```sql
INSERT INTO chester_knowledge (category, keyword, content, priority) VALUES
('mod_votre_mod', 'mot_cle', 'Explication simple pour enfants', 90);
```

### Via pgAdmin ou Adminer

1. Ouvrir la table `chester_knowledge`
2. Ajouter une ligne
3. Remplir : category, keyword, content, priority

### Bonnes pratiques

- **keyword** : Mot-clé en minuscules, sans espaces
- **category** : Catégorie logique (mod, mod_nom, minerai, guide)
- **content** : Texte simple compréhensible par des enfants
- **priority** : 0-100, plus élevé = plus important

## Structure des données

### Fichiers SQL fournis

1. **ethereal_complete.sql** (173 entrées)
   - Biomes Ethereal (30+)
   - Arbres (15+)
   - Système de pêche
   - Nourriture
   - Blocs spéciaux

2. **glooptest_complete.sql** (49 entrées)
   - Minerais (Kalite, Alatro, Akalin, Arol, Talinite)
   - Gemmes (Ruby, Sapphire, Emerald, Topaz, Amethyst)
   - Outils speciaux (Handsaw, Hammer)
   - Crystal Glass

3. **gloopblocks_complete.sql** (53 entrées)
   - Cement et outils
   - Evil blocks
   - Rainbow blocks
   - Formations lava+eau (Basalt, Pumice, Obsidian)
   - Pavement

4. **rings_complete.sql** (46 entrées)
   - 7 anneaux magiques
   - Crafts et utilisation
   - Effets détaillés

5. **supercub_complete.sql** (39 entrées)
   - Avion pilotable
   - Contrôles de vol
   - Carburant biofuel
   - Sécurité

## Dépendances

### Requises
- `default` (Minetest Game)
- PostgreSQL 9.5+
- PHP 7.0+ avec extension `pdo_pgsql`
- Serveur web (Apache/Nginx)

### Optionnelles
- `mobs` (mobs_redo) - Pour le PNJ Chester

## Troubleshooting

### Chester ne répond pas

1. Vérifier les logs Minetest :
```
grep Chester ~/.minetest/debug.txt
```

2. Vérifier que l'API est accessible :
```bash
curl "http://localhost:8080/chester_api.php?q=test"
```

3. Vérifier `minetest.conf` :
```
secure.http_mods = chester
```

### Erreur "HTTP API non disponible"

Ajouter dans `minetest.conf` :
```
secure.http_mods = chester
secure.trusted_mods = chester
```

Redémarrer Minetest.

### Erreur API / Base de données

1. Vérifier connexion PostgreSQL :
```bash
psql -U minetest -d minetest -c "SELECT COUNT(*) FROM chester_knowledge;"
```

2. Vérifier logs PHP :
```bash
tail -f /var/log/apache2/error.log
```

3. Tester l'API manuellement :
```bash
curl -v "http://localhost:8080/chester_api.php?q=ethereal"
```

### Chester spawn en double

Utiliser `/clearobjects` (attention, supprime TOUS les objets) ou :

```lua
/lua for _,o in ipairs(minetest.get_objects_inside_radius({x=-754,y=1,z=-230}, 50)) do if o:get_luaentity() and o:get_luaentity().name == "chester:chester_npc" then o:remove() end end
```

## Performance

### Base de données

- Index sur `keyword` et `category` pour recherche rapide
- ~400 entrées = recherche < 10ms
- Peut supporter des milliers d'entrées sans problème

### API PHP

- Cache possible avec APCu ou Redis si besoin
- Gzip compression automatique
- Timeout 5 secondes

### Minetest

- Anti-spam : 2 secondes entre requêtes par joueur
- Requêtes HTTP asynchrones (pas de lag)

## Maintenance

### Ajouter un nouveau mod

1. Analyser le mod
2. Créer script SQL avec entrées
3. Importer : `psql -f nouveau_mod.sql`
4. Tester : `/chester help nouveau_mot`

### Mettre à jour une entrée

```sql
UPDATE chester_knowledge 
SET content = 'Nouveau contenu'
WHERE keyword = 'mot_cle';
```

### Backup

```bash
pg_dump -U minetest -t chester_knowledge minetest > chester_backup.sql
```

### Restore

```bash
psql -U minetest -d minetest -f chester_backup.sql
```

## TODO / Améliorations futures

- [ ] Endpoint `/categories` dans l'API
- [ ] Recherche floue (LIKE '%keyword%')
- [ ] Suggestions si mot-clé inconnu
- [ ] Stats d'utilisation
- [ ] Interface web admin
- [ ] Support multilingue
- [ ] Intégration Ollama pour réponses naturelles
- [ ] Cache Redis
- [ ] Webhooks Discord pour logs

## Crédits

- **Chester** - Bot développé pour Amelaye in Minerland
- **Données** - Basées sur documentation officielle Minetest et analyse des mods
- **Mods couverts** - Ethereal, GloopTest, GloopBlocks, Rings, Super Cub

## Licence

Code : LGPL 3.0
Données : CC-BY-SA 4.0

## Support

Pour toute question ou problème, ouvrir une issue sur le repo ou contacter l'admin du serveur.

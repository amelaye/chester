# Chester v12 - Package complet

Bot d'aide intelligent pour serveur Minetest avec base de connaissances PostgreSQL.

## Contenu du package

```
chester_v12/
├── chester/                    # Mod Minetest
│   ├── init.lua               # Code principal
│   ├── mod.conf               # Configuration mod
│   ├── LICENSE                # Licence
│   ├── README.md              # Documentation complete
│   ├── models/                # Modele 3D du NPC
│   ├── sounds/                # Sons
│   └── textures/              # Textures
│
├── sql/                        # Scripts base de donnees
│   ├── 00_create_table.sql    # Creation table
│   ├── ethereal_complete.sql  # 173 entrees Ethereal
│   ├── glooptest_complete.sql # 49 entrees GloopTest
│   ├── gloopblocks_complete.sql # 53 entrees GloopBlocks
│   ├── rings_complete.sql     # 46 entrees Rings
│   └── supercub_complete.sql  # 39 entrees SuperCub
│
├── api/                        # API REST PHP
│   └── chester_api.php        # Endpoint HTTP
│
├── INSTALL.md                  # Guide installation rapide
├── minetest.conf.example       # Configuration exemple
└── import_database.sh          # Script d'import auto
```

## Installation rapide

```bash
# 1. Base de donnees
cd chester_v12
./import_database.sh

# 2. API
sudo cp api/chester_api.php /var/www/html/
sudo nano /var/www/html/chester_api.php  # Editer mot de passe

# 3. Mod
cp -r chester /chemin/vers/minetest/mods/

# 4. Configuration
# Ajouter dans minetest.conf:
secure.http_mods = chester
secure.trusted_mods = chester
```

Voir `INSTALL.md` pour plus de details.

## Caracteristiques

- **360+ entrees de connaissances** sur 5 mods populaires
- **Langage simple** adapte aux enfants
- **Recherche rapide** avec index PostgreSQL
- **Extensible** facilement via SQL
- **Performant** avec requetes HTTP asynchrones

## Mods couverts

1. **Ethereal NG** (173 entrees)
   - 30+ biomes
   - 15+ arbres
   - Systeme peche
   - Nourriture et plantes

2. **GloopTest** (49 entrees)
   - Minerais speciaux
   - 5 gemmes
   - Outils cristal
   - Crystal glass

3. **GloopBlocks** (53 entrees)
   - Cement et outils
   - Evil blocks
   - Rainbow blocks
   - Pavement

4. **Rings** (46 entrees)
   - 7 anneaux magiques
   - Effets et pouvoirs
   - Crafts detailles

5. **SuperCub** (39 entrees)
   - Avion pilotable
   - Controles complets
   - Guide pilotage

## Utilisation

### Joueurs

```
/chester help ethereal      - Info sur Ethereal
/chester help celestial_ring - Info sur l'anneau celeste
/chester help supercub       - Info sur l'avion
/chester list                - Categories disponibles
/spawn                       - Teleportation spawn
```

### Admin

```
/giveme_chester  - Obtenir l'oeuf de spawn Chester
```

Clic droit sur le NPC Chester pour interaction.

## Configuration requise

- Minetest 5.4+
- PostgreSQL 9.5+
- PHP 7.0+ avec pdo_pgsql
- Serveur web (Apache/Nginx)
- Mod mobs_redo (optionnel pour NPC)

## Ajouter des connaissances

```sql
INSERT INTO chester_knowledge (category, keyword, content, priority) 
VALUES (
    'mod_nouveau',
    'mot_cle',
    'Explication simple et claire pour les enfants',
    85
);
```

Ou via pgAdmin / Adminer pour interface graphique.

## Support et documentation

- **INSTALL.md** - Guide installation pas a pas
- **chester/README.md** - Documentation complete du mod
- **Logs** - `~/.minetest/debug.txt`

## Architecture

```
┌──────────┐      HTTP      ┌─────────┐      PDO      ┌────────────┐
│ Chester  │ ──────────────> │ API PHP │ ────────────> │ PostgreSQL │
│  (Lua)   │ <────────────── │  (REST) │ <──────────── │   (Base)   │
└──────────┘     JSON        └─────────┘    Resultats  └────────────┘
```

## Licence

- Code: LGPL 3.0
- Donnees: CC-BY-SA 4.0

## Auteur

Developpe pour **Amelaye in Minerland**

## Version

v12 - Fevrier 2026
- Premiere version avec PostgreSQL
- 360+ entrees de connaissances
- Langage adapte aux enfants

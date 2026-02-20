#!/bin/bash
# Script d'importation complete de la base Chester

set -e

# Configuration
DB_NAME="minetest"
DB_USER="minetest"
SQL_DIR="./sql"

echo "======================================"
echo "Chester v12 - Import base de donnees"
echo "======================================"
echo ""

# Verifier que psql est disponible
if ! command -v psql &> /dev/null; then
    echo "ERREUR: psql n'est pas installe"
    exit 1
fi

# Verifier la connexion
echo "Verification connexion PostgreSQL..."
if ! psql -U $DB_USER -d $DB_NAME -c "SELECT 1;" > /dev/null 2>&1; then
    echo "ERREUR: Impossible de se connecter a PostgreSQL"
    echo "Verifiez:"
    echo "  - PostgreSQL est demarre"
    echo "  - L'utilisateur $DB_USER existe"
    echo "  - La base $DB_NAME existe"
    echo "  - Le mot de passe est correct"
    exit 1
fi
echo "OK - Connexion reussie"
echo ""

# Creer la table
echo "Creation de la table chester_knowledge..."
psql -U $DB_USER -d $DB_NAME -f "$SQL_DIR/00_create_table.sql" > /dev/null
echo "OK - Table creee"
echo ""

# Importer les donnees
echo "Import des donnees..."

echo "  - Ethereal (173 entrees)..."
psql -U $DB_USER -d $DB_NAME -f "$SQL_DIR/ethereal_complete.sql" > /dev/null

echo "  - GloopTest (49 entrees)..."
psql -U $DB_USER -d $DB_NAME -f "$SQL_DIR/glooptest_complete.sql" > /dev/null

echo "  - GloopBlocks (53 entrees)..."
psql -U $DB_USER -d $DB_NAME -f "$SQL_DIR/gloopblocks_complete.sql" > /dev/null

echo "  - Rings (46 entrees)..."
psql -U $DB_USER -d $DB_NAME -f "$SQL_DIR/rings_complete.sql" > /dev/null

echo "  - SuperCub (39 entrees)..."
psql -U $DB_USER -d $DB_NAME -f "$SQL_DIR/supercub_complete.sql" > /dev/null

echo "OK - Import termine"
echo ""

# Statistiques
echo "Statistiques finales:"
psql -U $DB_USER -d $DB_NAME -c "
SELECT 
    category,
    COUNT(*) as nb_entrees
FROM chester_knowledge
GROUP BY category
ORDER BY category;
"

echo ""
TOTAL=$(psql -U $DB_USER -d $DB_NAME -t -c "SELECT COUNT(*) FROM chester_knowledge;")
echo "TOTAL: $TOTAL entrees dans la base"
echo ""
echo "======================================"
echo "Import termine avec succes !"
echo "======================================"
echo ""
echo "Prochaines etapes:"
echo "1. Configurer l'API PHP (api/chester_api.php)"
echo "2. Copier le mod dans Minetest"
echo "3. Configurer minetest.conf"
echo ""

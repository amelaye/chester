-- ============================================================================
-- CHESTER KNOWLEDGE BASE - TABLE CREATION
-- ============================================================================
-- Base de connaissances PostgreSQL pour Chester bot
-- ============================================================================

-- Supprimer la table si elle existe (ATTENTION: perte de donnees)
-- DROP TABLE IF EXISTS chester_knowledge CASCADE;

-- Creer la table principale
CREATE TABLE IF NOT EXISTS chester_knowledge (
    id SERIAL PRIMARY KEY,
    category VARCHAR(50) NOT NULL,
    keyword VARCHAR(100) NOT NULL,
    content TEXT NOT NULL,
    priority INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Index pour recherche rapide
CREATE INDEX IF NOT EXISTS idx_keyword ON chester_knowledge(keyword);
CREATE INDEX IF NOT EXISTS idx_category ON chester_knowledge(category);
CREATE INDEX IF NOT EXISTS idx_priority ON chester_knowledge(priority DESC);

-- Index full-text pour recherche avancee (optionnel)
CREATE INDEX IF NOT EXISTS idx_content_search ON chester_knowledge USING gin(to_tsvector('french', content));

-- Fonction pour mettre a jour updated_at automatiquement
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger pour appeler la fonction
DROP TRIGGER IF EXISTS update_chester_knowledge_updated_at ON chester_knowledge;
CREATE TRIGGER update_chester_knowledge_updated_at
    BEFORE UPDATE ON chester_knowledge
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Commentaires sur la table et les colonnes
COMMENT ON TABLE chester_knowledge IS 'Base de connaissances pour Chester bot';
COMMENT ON COLUMN chester_knowledge.category IS 'Categorie du contenu (mod, minerai, guide, etc)';
COMMENT ON COLUMN chester_knowledge.keyword IS 'Mot-cle de recherche (minuscules, sans espaces)';
COMMENT ON COLUMN chester_knowledge.content IS 'Contenu explicatif (langage simple pour enfants)';
COMMENT ON COLUMN chester_knowledge.priority IS 'Priorite 0-100 (plus eleve = plus important)';

-- Afficher les stats
SELECT 
    'Table chester_knowledge creee avec succes' as message,
    COUNT(*) as nb_entrees
FROM chester_knowledge;

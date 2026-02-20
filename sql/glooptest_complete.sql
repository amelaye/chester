INSERT INTO chester_knowledge (category, keyword, content, priority) VALUES

('mod', 'glooptest',
'GloopTest est un modpack de minerais et outils cree par GloopMaster.

Ajoute 12 nouveaux minerais, gemmes, outils speciaux, crystal glass et treasure chests.

Version 0.0.4, licence CC-BY-SA.', 100),

('mod_glooptest', 'modules',
'GloopTest contient 6 modules activables/desactivables :

Ore Module : Minerais et gemmes
OtherGen Module : Generation (treasure chests)
Parts Module : Pieces et blocs speciaux
Tech Module : Technologie
Tools Module : Outils speciaux (handsaw, hammer)
Compat Module : Compatibilite avec autres mods

Configure dans minetest.conf avec glooptest.load_[module]_module', 90),

('mod_glooptest', 'kalite',
'Le Kalite est un minerai combustible.

Proprietes : Combustible dans furnace
Drop : 2-4 Kalite Lump par ore
Utilisation : Fuel, Kalite Torch

Kalite Torch : Torche alternative craftable.', 85),

('mod_glooptest', 'alatro',
'L''Alatro est un metal pour outils.

Minerai : Alatro Ore
Drop : Alatro Lump
Cuisson : Alatro Ingot
Bloc : Alatro Block (9 lingots)

Outils craftables : Sword, Axe, Pickaxe, Handsaw, Hammer', 85),

('mod_glooptest', 'akalin',
'L''Akalin est un metal de renforcement.

Minerai : Akalin Ore
Drop : Akalin Lump
Cuisson : Akalin Ingot
Bloc : Akalin Block (9 lingots)

Utilisation principale : Renforcer crystal glass
Craft : Akalin Crystal Glass', 85),

('mod_glooptest', 'arol',
'L''Arol est un metal complet pour outils.

Minerai : Arol Ore
Drop : Arol Lump
Cuisson : Arol Ingot

Outils complets :
- Arol Pickaxe
- Arol Axe
- Arol Shovel
- Arol Sword
- Arol Handsaw
- Arol Hammer

Full toolset disponible.', 90),

('mod_glooptest', 'talinite',
'Le Talinite est un metal precieux.

Minerai : Talinite Ore
Drop : Talinite Lump
Cuisson : Talinite Ingot
Bloc : Talinite Block (9 lingots)

Utilisation : Talinite Crystal Glass
Propriete : Valeur radiation 40 (si Technic installe)', 80),

('mod_glooptest', 'desert_iron',
'Le Desert Iron est du fer du desert.

Source : Desert biomes
Utilisation : Identique a iron normal

Variante desertic du minerai de fer.', 75),

('mod_glooptest', 'desert_coal',
'Le Desert Coal est du charbon du desert.

Source : Desert biomes
Utilisation : Identique a coal normal
Propriete : Valeur radiation 16 (si Technic)

Variante desertic du charbon.', 75),

('mod_glooptest', 'ruby',
'Le Ruby (Rubis) est une gemme rouge.

Minerai : Ruby Ore
Drop : Ruby
Bloc : Ruby Block (9 rubis)
Propriete : Valeur radiation 18 (si Technic)

Gemme decorative rouge.', 80),

('mod_glooptest', 'sapphire',
'Le Sapphire (Saphir) est une gemme bleue.

Minerai : Sapphire Ore
Drop : Sapphire
Bloc : Sapphire Block (9 saphirs)
Propriete : Valeur radiation 18 (si Technic)

Gemme decorative bleue.', 80),

('mod_glooptest', 'emerald',
'L''Emerald (Emeraude) est une gemme verte.

Minerai : Emerald Ore
Drop : Emerald
Bloc : Emerald Block (9 emeraudes)
Propriete : Valeur radiation 17 (si Technic)

Gemme decorative verte.', 80),

('mod_glooptest', 'topaz',
'Le Topaz (Topaze) est une gemme jaune.

Minerai : Topaz Ore
Drop : Topaz
Bloc : Topaz Block (9 topazes)
Propriete : Valeur radiation 18 (si Technic)

Gemme decorative jaune.', 80),

('mod_glooptest', 'amethyst',
'L''Amethyst (Amethyste) est une gemme violette.

Minerai : Amethyst Ore
Drop : Amethyst
Bloc : Amethyst Block (9 amethystes)
Propriete : Valeur radiation 17 (si Technic)

Gemme decorative violette.', 80),

('mod_glooptest', 'handsaw',
'Le Handsaw (scie a main) coupe blocs "snappy".

Fonction : Casse rapidement blocs snappy (feuilles, plantes)
Niveaux : Wood, Stone, Steel, Bronze, Mese, Diamond, Alatro, Arol

Craft : Similaire aux outils normaux mais forme scie
Utilisation : Alternative aux shears pour plantes', 85),

('mod_glooptest', 'hammer',
'Le Hammer (marteau) casse blocs "bendy".

Fonction : Casse blocs bendy (tiges, bambou)
Niveaux : Wood, Stone, Steel, Bronze, Mese, Diamond, Alatro, Arol

Craft : Similaire aux outils normaux mais forme marteau
Utilisation : Outil specialise casse tiges', 85),

('mod_glooptest', 'crystal_glass',
'Le Crystal Glass est un verre cristallin.

Craft : 2x Desert Stone + 2x Glass (motif damier)
Pattern :
Desert Stone - Glass
Glass - Desert Stone

Utilisation : Base pour verres renforces
Propriete : Transparent, decoratif', 90),

('mod_glooptest', 'reinforced_crystal_glass',
'Le Reinforced Crystal Glass est du verre renforce acier.

Craft : 8x Crystal Glass + 1x Steel Ingot (centre)
Pattern : Crystal glass autour steel ingot

Propriete : Plus resistant que crystal glass
Durete : cracky=2', 85),

('mod_glooptest', 'akalin_crystal_glass',
'L''Akalin Crystal Glass est du verre renforce akalin.

Craft : 8x Crystal Glass + 1x Akalin Ingot (centre)
Pattern : Crystal glass autour akalin ingot

Propriete : Renforcement akalin
Utilisation : Heavily Reinforced Crystal Glass', 85),

('mod_glooptest', 'alatro_crystal_glass',
'L''Alatro Crystal Glass est du verre renforce alatro.

Craft : 8x Crystal Glass + 1x Alatro Ingot (centre)
Pattern : Crystal glass autour alatro ingot

Propriete : Renforcement alatro
Apparence : Texture alatro', 80),

('mod_glooptest', 'arol_crystal_glass',
'L''Arol Crystal Glass est du verre renforce arol.

Craft : 8x Crystal Glass + 1x Arol Ingot (centre)
Pattern : Crystal glass autour arol ingot

Propriete : Renforcement arol
Apparence : Texture arol', 80),

('mod_glooptest', 'talinite_crystal_glass',
'Le Talinite Crystal Glass est du verre renforce talinite.

Craft : 8x Crystal Glass + 1x Talinite Ingot (centre)
Pattern : Crystal glass autour talinite ingot

Propriete : Renforcement talinite, radiation 21
Apparence : Texture talinite', 80),

('mod_glooptest', 'heavily_reinforced_crystal_glass',
'Le Heavily Reinforced Crystal Glass est ultra-renforce.

Craft : 2x Reinforced Crystal Glass + 2x Akalin Crystal Glass
Pattern : Similaire au crystal glass (damier)

Propriete : Tres resistant
Utilisation : Construction securisee', 85),

('mod_glooptest', 'treasure_chest',
'Les Treasure Chests sont des coffres tresor generes.

Generation : Sur nouvelles parties de map
Contenu : Items aleatoires varies

Module : OtherGen Module
Activation : glooptest.load_othergen_module = true', 85),

('mod_glooptest', 'compat_technic',
'GloopTest est compatible avec Technic mod.

Integration Grinder :
- Tous lumps broyables en dust (x2)
- Alatro Lump -> Alatro Dust x2
- Kalite Lump -> Kalite Dust x2
- Arol Lump -> Arol Dust x2
- Talinite Lump -> Talinite Dust x2
- Akalin Lump -> Akalin Dust x2

Cuisson dust -> ingot fonctionne.', 90),

('mod_glooptest', 'radiation_values',
'Minerais GloopTest ont des valeurs radiation (si Technic).

Valeurs radiation :
- Akalin Ore : 20
- Alatro Ore : 20
- Arol Ore : 20
- Kalite Ore : 20
- Talinite Ore : 20
- Desert Iron : 20
- Desert Coal : 16
- Ruby Ore : 18
- Sapphire Ore : 18
- Emerald Ore : 17
- Topaz Ore : 18
- Amethyst Ore : 17

Blocs ont radiation plus elevee.', 75),

('mod_glooptest', 'alatro_tools',
'Outils en Alatro disponibles.

Liste :
- Alatro Sword
- Alatro Axe
- Alatro Pickaxe
- Alatro Handsaw
- Alatro Hammer

Craft : Alatro Ingot + Stick (patterns normaux)
Qualite : Entre steel et mese', 80),

('mod_glooptest', 'arol_tools',
'Outils en Arol disponibles (full set).

Liste complete :
- Arol Sword
- Arol Axe
- Arol Pickaxe
- Arol Shovel
- Arol Handsaw
- Arol Hammer

Craft : Arol Ingot + Stick (patterns normaux)
Qualite : Entre steel et mese', 85),

('mod_glooptest', 'kalite_torch',
'La Kalite Torch est une torche alternative.

Craft : Kalite Lump (combustible)
Lumiere : Identique torch normale

Alternative torch utilisant kalite.', 70),

('mod_glooptest', 'blocks_metal',
'Blocs de metaux GloopTest craftables.

Liste :
- Alatro Block (9 lingots)
- Akalin Block (9 lingots)
- Talinite Block (9 lingots)

Decraft : 1 bloc = 9 lingots
Utilisation : Stockage compact', 75),

('mod_glooptest', 'blocks_gems',
'Blocs de gemmes GloopTest craftables.

Liste :
- Ruby Block (9 rubis)
- Sapphire Block (9 saphirs)
- Emerald Block (9 emeraudes)
- Topaz Block (9 topazes)
- Amethyst Block (9 amethystes)

Decraft : 1 bloc = 9 gemmes
Utilisation : Decoration, stockage', 80),

('mod_glooptest', 'setting_ore_module',
'Active/desactive Ore Module.

Setting : glooptest.load_ore_module
Valeurs : true (defaut) ou false

Contenu : Tous minerais et gemmes
Configure dans minetest.conf', 75),

('mod_glooptest', 'setting_tools_module',
'Active/desactive Tools Module.

Setting : glooptest.load_tools_module
Valeurs : true (defaut) ou false

Contenu : Handsaw et Hammer
Configure dans minetest.conf', 75),

('mod_glooptest', 'setting_parts_module',
'Active/desactive Parts Module.

Setting : glooptest.load_parts_module
Valeurs : true (defaut) ou false

Contenu : Crystal Glass et variantes
Configure dans minetest.conf', 75),

('mod_glooptest', 'setting_tech_module',
'Active/desactive Tech Module.

Setting : glooptest.load_tech_module
Valeurs : true (defaut) ou false

Contenu : Technologie avancee
Configure dans minetest.conf', 70),

('mod_glooptest', 'setting_othergen_module',
'Active/desactive OtherGen Module.

Setting : glooptest.load_othergen_module
Valeurs : true (defaut) ou false

Contenu : Treasure Chests generation
Configure dans minetest.conf', 75),

('mod_glooptest', 'setting_compat_module',
'Active/desactive Compat Module.

Setting : glooptest.load_compat_module
Valeurs : true (defaut) ou false

Contenu : Aliases compatibilite GloopOres
Configure dans minetest.conf', 70),

('mod_glooptest', 'compat_gloopores',
'GloopTest remplace ancien mod GloopOres.

Aliases : Tous items gloopores: -> glooptest:
Migration : Anciens mondes compatibles

Compat Module gere transition.', 70),

('mod_glooptest', 'dependances',
'GloopTest necessite uniquement default.

Depend : default (Minetest Game)
Optionnel : technic (integration grinder/dust)

Compatible : Tous mods Minetest Game', 75),

('mod_glooptest', 'astuce_kalite_fuel',
'Astuce : Kalite est un excellent combustible.

Propriete : Drop 2-4 lumps par ore
Utilisation : Fuel dans furnace

Bon rendement pour combustible alternatif.', 80),

('mod_glooptest', 'astuce_crystal_glass_craft',
'Astuce : Crystal glass se craft avec desert stone.

Recette : 2x Desert Stone + 2x Glass (damier)
Desert Stone facile a trouver dans desert

Base pour tous verres renforces.', 85),

('mod_glooptest', 'astuce_handsaw_leaves',
'Astuce : Handsaw coupe feuilles tres rapidement.

Utilisation : Recolte rapide leaves
Alternative : Shears (mais handsaw plus rapide)

Parfait pour nettoyer arbres.', 80),

('mod_glooptest', 'astuce_hammer_bamboo',
'Astuce : Hammer casse bambou et tiges rapidement.

Utilisation : Recolte rapide bamboo, papyrus
Groupe cible : bendy

Outil specialise vegetation rigide.', 75),

('mod_glooptest', 'astuce_arol_full_set',
'Astuce : Arol est le seul metal Gloop avec full toolset.

Outils : Sword, Axe, Pickaxe, Shovel, Handsaw, Hammer
Complet : Tous outils disponibles

Metal le plus versatile de GloopTest.', 85),

('mod_glooptest', 'astuce_technic_grinding',
'Astuce : Grinder Technic double output minerais Gloop.

Process : Lump -> Grinder -> Dust x2 -> Cuisson -> Ingot x2
Rendement : x2 lingots par lump

Necessite Technic mod installe.', 90),

('mod_glooptest', 'astuce_treasure_chest',
'Astuce : Treasure Chests spawent sur nouvelles zones.

Generation : Nouvelles parties map uniquement
Exploration : Explore nouveaux territoires

Contenu aleatoire interessant.', 80),

('mod_glooptest', 'astuce_heavily_reinforced',
'Astuce : Heavily Reinforced Glass necessite 2 types verre.

Craft : Reinforced + Akalin Crystal Glass
Resultat : Verre ultra-resistant

Meilleur verre protection disponible.', 80),

('mod_glooptest', 'astuce_gem_blocks',
'Astuce : Blocs gemmes sont purement decoratifs.

Gemmes : Ruby, Sapphire, Emerald, Topaz, Amethyst
Utilisation : Decoration uniquement

Pas d''outils en gemmes.', 75),

('mod_glooptest', 'astuce_radiation_shield',
'Astuce : Crystal Glass NE protege PAS de radiation.

Radiation : Minerais Gloop sont radioactifs (si Technic)
Protection : Utiliser lead blocks (Technic)

Crystal Glass est decoratif uniquement.', 75);

INSERT INTO chester_knowledge (category, keyword, content, priority) VALUES

('mod', 'gloopblocks',
'GloopBlocks est un mod de blocs decoratifs et fonctionnels.

Ajoute cement, evil blocks, rainbow blocks, pavement, basalt, pumice et outils.

Auteur original : GloopMaster (NekoGloop)
Maintenu par : mt-mods
Licence : LGPL 3.0 code, CC-BY-SA 4.0 media', 100),

('mod_gloopblocks', 'cement',
'Le Cement est un materiau de construction.

Craft wet cement : Bucket Water + Gravel
Cuisson wet cement : Dried Cement
Decraft dried cement : Gravel

Utilisation : Outils cement, construction
Disponible : Stairs, slabs si moreblocks installe', 90),

('mod_gloopblocks', 'wet_cement',
'Le Wet Cement (ciment humide) se craft.

Craft : 1x Bucket Water + 1x Gravel
Resultat : 1x Wet Cement + Empty Bucket

Cuisson : Wet Cement -> Dried Cement (basic_materials)
Temps : Standard furnace', 85),

('mod_gloopblocks', 'dried_cement',
'Le Dried Cement vient du basic_materials mod.

Source : Cuisson Wet Cement
Utilisation : Outils cement
Decraft : Dried Cement -> Gravel

Note : GloopBlocks necessite basic_materials pour cement.', 80),

('mod_gloopblocks', 'evil_stick',
'L''Evil Stick est un baton malfaisant.

Craft : 1x Coal Lump + 1x Stick + 1x Kalite Lump (glooptest)
Resultat : 1x Evil Stick

Utilisation : Evil tools, Evil Block
Necessite : glooptest mod pour kalite', 90),

('mod_gloopblocks', 'evil_block',
'L''Evil Block est un bloc qui brille.

Craft : 4x Evil Stick (en carre)
Resultat : 1x Evil Block
Decraft : 1x Evil Block -> 4x Evil Stick

Proprietes :
- Lumiere : Petite quantite (light source)
- Disponible stairs/slabs (aussi lumineux)', 90),

('mod_gloopblocks', 'evil_tools',
'Outils en Evil disponibles.

Liste :
- Evil Pickaxe
- Evil Axe
- Evil Shovel
- Evil Sword

Craft : Evil Block (tetes) + Evil Stick (manches)
Qualite : Entre steel et diamond', 85),

('mod_gloopblocks', 'cement_tools',
'Outils en Cement disponibles.

Liste :
- Cement Pickaxe
- Cement Axe
- Cement Shovel
- Cement Sword

Craft : Dried Cement (tetes) + Stick (manches)
Qualite : Entre stone et steel', 80),

('mod_gloopblocks', 'rainbow_block',
'Le Rainbow Block est arc-en-ciel decoratif.

Craft : 1x Stone + 1x Mese Crystal + 6 dyes
Dyes : Red, Orange, Yellow, Green, Blue, Violet
Resultat : 1x Rainbow Block

Compatible : Unified Dyes et default dyes
Disposition : N''importe ou dans grid', 85),

('mod_gloopblocks', 'nyan_rainbow',
'Le Nyan Cat Rainbow est decoratif.

Craft : 3x Rainbow Block
Resultat : 1x Nyan Rainbow (arc-en-ciel horizontal)

Utilisation : Decoration Nyan Cat', 75),

('mod_gloopblocks', 'nyan_cat',
'Le Nyan Cat complet est decoratif.

Craft : 9x Rainbow Block (grille 3x3)
Resultat : 1x Nyan Cat

Pop Tart Cat arc-en-ciel complet.', 75),

('mod_gloopblocks', 'basalt',
'Le Basalt se forme eau + lave.

Formation : Flowing Lava + Standing Water = Basalt
Source : Generation automatique
Alternative : Trouve dans monde

Proprietes : Roche volcanique grise
Disponible : Stairs, slabs si moreblocks', 85),

('mod_gloopblocks', 'pumice',
'Le Pumice (pierre ponce) se forme eau + lave.

Formation : Flowing Lava + Flowing Water = Pumice
Source : Generation automatique

Proprietes : Roche volcanique legere
Disponible : Stairs, slabs si moreblocks', 85),

('mod_gloopblocks', 'obsidian_formation',
'L''Obsidian se forme avec lave statique.

Formation : Standing Lava + Water (flowing ou standing) = Obsidian
Source : Generation automatique

Note : Similaire au default Minetest mais plus precis.', 80),

('mod_gloopblocks', 'pavement',
'Le Pavement est pour routes et parkings.

Craft : 5x Wet Cement + 4x Basalt (damier 3x3)
Pattern damier :
W B W
B W B
W B W
Resultat : 5x Pavement

Alternative : 4 wet cement + 5 basalt (inverse)
Disponible : Stairs, slabs', 90),

('mod_gloopblocks', 'cobble_road',
'Le Cobble Road est lit de route en pierre.

Type : Cobblestone pour routes
Variante : Cobble Road Mossy (moussue)

Disponible : Stairs, slabs
Utilisation : Routes, chemins', 75),

('mod_gloopblocks', 'mossy_cobble',
'Cobblestone devient mossy pres de l''eau.

Transformation : Cobblestone + Water (flowing ou standing)
Resultat : Mossy Cobblestone
ABM : Automatique si eau a proximite

Aussi : Cobble Road -> Mossy Cobble Road', 85),

('mod_gloopblocks', 'oerkki_block',
'L''Oerkki Block est un bloc sombre.

Type : Bloc decoratif
Apparence : Sombre, patterns

Disponible : Stairs, slabs si moreblocks
Utilisation : Decoration gothique', 70),

('mod_gloopblocks', 'mossy_stone_brick',
'Le Mossy Stone Brick est une brique moussue.

Type : Pierre decorative moussue
Source : Craft ou generation

Disponible : Stairs, slabs si moreblocks
Utilisation : Decoration ruines', 75),

('mod_gloopblocks', 'scaffold',
'Le Scaffold est un echafaudage.

Type : Bloc climbable temporaire
Utilisation : Construction en hauteur

Proprietes : Walkable, climbable
Disponible : Basique (pas stairs/slabs)', 70),

('mod_gloopblocks', 'steel_fence',
'Le Steel Fence est une cloture en acier.

Type : Fence metallique
Craft : Standard fence pattern avec steel

Utilisation : Clotures solides
Proprietes : Connects to fences', 70),

('mod_gloopblocks', 'usesdirt_nodes',
'GloopBlocks integre nodes de UseDirt mod (abandonne).

Nodes ajoutes :
- Dirt Brick
- Dirt Cobblestone
- Dirt Stone
- Chacun avec fence et ladder

Note : UseDirt est abandonne, GloopBlocks reprend nodes.', 75),

('mod_gloopblocks', 'dirt_brick',
'Le Dirt Brick est une brique de terre.

Source : UseDirt integration
Type : Construction terre

Disponible : Fence, Ladder
Utilisation : Construction rustique', 70),

('mod_gloopblocks', 'dirt_cobblestone',
'Le Dirt Cobblestone est pierre de terre.

Source : UseDirt integration
Type : Construction terre

Disponible : Fence, Ladder
Utilisation : Construction terreuse', 70),

('mod_gloopblocks', 'dirt_stone',
'Le Dirt Stone est pierre de terre lisse.

Source : UseDirt integration
Type : Construction terre

Disponible : Fence, Ladder
Utilisation : Construction propre terre', 70),

('mod_gloopblocks', 'stick_to_wood',
'4 Sticks peuvent etre craftes en Wood.

Craft : 4x Stick (en carre)
Resultat : 1x Wood

Utile : Recuperer wood de sticks excess', 80),

('mod_gloopblocks', 'moreblocks_support',
'GloopBlocks supporte Moreblocks StairsPlus.

Si Moreblocks installe :
- Evil Block : 49 variantes (stairs, slabs, panels, etc)
- Basalt : 49 variantes
- Pumice : 49 variantes
- Pavement : 49 variantes
- Oerkki Block : 49 variantes
- Mossy Stone Brick : 49 variantes
- Cement : 49 variantes
- Cobble Road : 49 variantes

Utilise : Circular Saw (table saw)', 95),

('mod_gloopblocks', 'stairs_basic_support',
'Si Moreblocks absent, stairs basiques disponibles.

Nodes limites (pour eviter trop nodes) :
- Cement stairs/slabs
- Pavement stairs/slabs
- Cobble Road stairs/slabs

Necessite : stairs mod (default Minetest Game)', 80),

('mod_gloopblocks', 'evil_light_emission',
'Evil blocks et variantes emettent lumiere.

Lumiere :
- Evil Block : Petite quantite
- Evil Stairs : Petite quantite
- Evil Slabs : Petite quantite
- Toutes variantes Evil : Lumineux

Utilisation : Decoration lumineuse malfaisante', 85),

('mod_gloopblocks', 'dependances',
'GloopBlocks a plusieurs dependances.

Requis :
- default (Minetest Game)
- basic_materials (pour cement)

Recommandes :
- glooptest (pour evil stick kalite)
- moreblocks (pour stairs/slabs variantes)
- stairs (si moreblocks absent)

Optionnel :
- unified_dyes (dyes etendus)
- wool (pour certains crafts)', 85),

('mod_gloopblocks', 'lava_water_reactions',
'Eau + Lave creent materiaux differents.

Reactions :
1. Flowing Lava + Standing Water = Basalt
2. Flowing Lava + Flowing Water = Pumice
3. Standing Lava + Water (any) = Obsidian

Note : Si Minetest Game post-Mars 2013, desactive (conflit)', 90),

('mod_gloopblocks', 'cement_pickaxe',
'La Cement Pickaxe est une pioche en ciment.

Craft : 3x Dried Cement + 2x Stick
Pattern : Pioche standard

Qualite : Entre stone et steel
Durabilite : Moyenne', 75),

('mod_gloopblocks', 'cement_axe',
'La Cement Axe est une hache en ciment.

Craft : 3x Dried Cement + 2x Stick
Pattern : Hache standard

Qualite : Entre stone et steel
Durabilite : Moyenne', 75),

('mod_gloopblocks', 'cement_shovel',
'La Cement Shovel est une pelle en ciment.

Craft : 1x Dried Cement + 2x Stick
Pattern : Pelle standard

Qualite : Entre stone et steel
Durabilite : Moyenne', 75),

('mod_gloopblocks', 'cement_sword',
'La Cement Sword est une epee en ciment.

Craft : 2x Dried Cement + 1x Stick
Pattern : Epee standard

Qualite : Entre stone et steel
Durabilite : Moyenne', 75),

('mod_gloopblocks', 'evil_pickaxe',
'L''Evil Pickaxe est une pioche malfaisante.

Craft : 3x Evil Block + 2x Evil Stick
Pattern : Pioche standard

Qualite : Entre steel et diamond
Durabilite : Bonne
Necessite : glooptest (kalite)', 80),

('mod_gloopblocks', 'evil_axe',
'L''Evil Axe est une hache malfaisante.

Craft : 3x Evil Block + 2x Evil Stick
Pattern : Hache standard

Qualite : Entre steel et diamond
Durabilite : Bonne
Necessite : glooptest (kalite)', 80),

('mod_gloopblocks', 'evil_shovel',
'L''Evil Shovel est une pelle malfaisante.

Craft : 1x Evil Block + 2x Evil Stick
Pattern : Pelle standard

Qualite : Entre steel et diamond
Durabilite : Bonne
Necessite : glooptest (kalite)', 80),

('mod_gloopblocks', 'evil_sword',
'L''Evil Sword est une epee malfaisante.

Craft : 2x Evil Block + 1x Evil Stick
Pattern : Epee standard

Qualite : Entre steel et diamond
Durabilite : Bonne
Necessite : glooptest (kalite)', 80),

('mod_gloopblocks', 'pavement_craft_pattern',
'Le Pavement se craft en damier.

Pattern exact (5 wet cement + 4 basalt) :
W B W
B W B
W B W

OU inverse (4 wet cement + 5 basalt) :
B W B
W B W
B W B

Resultat : 5x Pavement dans les deux cas', 85),

('mod_gloopblocks', 'rainbow_dyes_needed',
'Rainbow Block necessite 6 couleurs dyes.

Couleurs requises :
- Red Dye
- Orange Dye
- Yellow Dye
- Green Dye
- Blue Dye
- Violet Dye

Plus : 1x Stone + 1x Mese Crystal
Arrangement : N''importe ou dans grid', 80),

('mod_gloopblocks', 'basic_materials_cement',
'GloopBlocks utilise cement de basic_materials.

Cement = basic_materials:cement_block
Wet Cement -> Cuisson -> Cement (basic_materials)

Important : basic_materials REQUIS pour fonctionner
Sans : Stairs/slabs cement = dummy image', 90),

('mod_gloopblocks', 'circular_saw_usage',
'Si Moreblocks installe, utilise Circular Saw.

Utilisation :
1. Craft Circular Saw (moreblocks)
2. Place Circular Saw
3. Insert node (evil block, basalt, etc)
4. Choisis forme (49 variantes)

Nodes supportes : Evil, Basalt, Pumice, Pavement, Oerkki, Mossy Stone Brick, Cement, Cobble Road', 85),

('mod_gloopblocks', 'astuce_evil_light',
'Astuce : Evil blocks eclairent sans torches.

Propriete : Evil Block emet lumiere
Utilisation : Decoration lumineuse dark

Parfait pour ambiance gothique eclairee.', 85),

('mod_gloopblocks', 'astuce_pavement_roads',
'Astuce : Pavement parfait pour routes et parkings.

Craft : Wet cement + Basalt (damier)
Resultat : 5x Pavement

Texture : Asphalte realiste
Disponible : Stairs pour bordures', 90),

('mod_gloopblocks', 'astuce_basalt_generation',
'Astuce : Basalt se forme automatiquement lave + eau.

Formation : Flowing Lava touche Standing Water
Resultat : Basalt block

Farm : Systeme eau + lave = farm basalt automatique', 85),

('mod_gloopblocks', 'astuce_mossy_cobble',
'Astuce : Cobblestone devient mossy pres eau.

ABM : Cobble + Water a proximite = Mossy Cobble
Automatique : Pas besoin craft

Utile : Decoration naturelle ruines', 80),

('mod_gloopblocks', 'astuce_stick_recovery',
'Astuce : 4 Sticks = 1 Wood.

Craft : 4x Stick en carre
Resultat : 1x Wood

Utile : Recuperer wood de tools casses (sticks excess)', 80),

('mod_gloopblocks', 'astuce_cement_gravel',
'Astuce : Dried Cement peut redevenir Gravel.

Decraft : 1x Dried Cement = 1x Gravel
Utilisation : Recuperer gravel si besoin

Reversible : Wet cement -> Dried -> Gravel', 75),

('mod_gloopblocks', 'astuce_evil_kalite',
'Astuce : Evil Stick necessite Kalite (glooptest).

Craft : Coal + Stick + Kalite Lump
Necessite : glooptest mod installe

Sans glooptest : Impossible faire evil items', 85),

('mod_gloopblocks', 'astuce_moreblocks_shapes',
'Astuce : Moreblocks donne 49 formes par bloc.

Formes : Stairs, slabs, panels, microblocks, etc
Nombre : 49 variantes par node

Attention : Limite 32767 nodes totaux Minetest', 80),

('mod_gloopblocks', 'astuce_nyan_cat',
'Astuce : Nyan Cat complet = 9 Rainbow Blocks.

Craft progression :
1. Rainbow Block (6 dyes + stone + mese)
2. 3x Rainbow = Nyan Rainbow
3. 9x Rainbow = Nyan Cat complet

Decoration : Pop Tart Cat legendaire', 75),

('mod_gloopblocks', 'astuce_pumice_vs_basalt',
'Astuce : Pumice et Basalt = formations differentes.

Basalt : Flowing Lava + Standing Water (commun)
Pumice : Flowing Lava + Flowing Water (rare)

Pumice : Plus leger, moins frequent', 75);

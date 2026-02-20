<?php
/**
 * Chester Knowledge API
 * API REST pour acceder a la base de connaissances PostgreSQL de Chester
 */

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

// Configuration base de donnees
$host = "localhost";
$port = "5432";
$dbname = "minetest";
$user = "minetest";
$password = "votre_mot_de_passe"; // MODIFIER ICI

try {
    $dsn = "pgsql:host=$host;port=$port;dbname=$dbname";
    $pdo = new PDO($dsn, $user, $password, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
    ]);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => 'Database connection failed'
    ]);
    exit;
}

// Recuperer le mot-cle
$keyword = isset($_GET['q']) ? trim($_GET['q']) : '';

if (empty($keyword)) {
    http_response_code(400);
    echo json_encode([
        'success' => false,
        'error' => 'Parameter q is required'
    ]);
    exit;
}

// Recherche exacte sur keyword
$stmt = $pdo->prepare("
    SELECT category, keyword, content, priority
    FROM chester_knowledge
    WHERE LOWER(keyword) = LOWER(:keyword)
    ORDER BY priority DESC
    LIMIT 1
");

$stmt->execute(['keyword' => $keyword]);
$result = $stmt->fetch();

// Si pas de resultat exact, recherche LIKE dans keyword et content
if (!$result) {
    $stmt = $pdo->prepare("
        SELECT category, keyword, content, priority
        FROM chester_knowledge
        WHERE LOWER(keyword) LIKE LOWER(:keyword)
           OR LOWER(content) LIKE LOWER(:search)
        ORDER BY 
            CASE WHEN LOWER(keyword) = LOWER(:keyword_exact) THEN 0 ELSE 1 END,
            priority DESC
        LIMIT 1
    ");
    
    $stmt->execute([
        'keyword' => '%' . $keyword . '%',
        'search' => '%' . $keyword . '%',
        'keyword_exact' => $keyword
    ]);
    
    $result = $stmt->fetch();
}

// Reponse
if ($result) {
    echo json_encode([
        'success' => true,
        'data' => $result
    ]);
} else {
    http_response_code(404);
    echo json_encode([
        'success' => false,
        'error' => 'Keyword not found'
    ]);
}

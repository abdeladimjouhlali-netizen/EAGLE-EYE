# Script PowerShell pour assigner automatiquement les aéroports aux utilisateurs CENTRE_RADAR

Write-Host "=== Assignation Automatique Aéroports - Centres Radar ===" -ForegroundColor Cyan
Write-Host ""

# Configuration PostgreSQL
$dbHost = "localhost"
$dbPort = "5432"
$dbName = "flightradar"
$dbUser = "postgres"
$dbPassword = "postgres"

# Assignations automatiques basées sur le code IATA
$assignments = @(
    @{username = "radar_cmn"; airportId = 1; airportName = "Casablanca (CMN)"},
    @{username = "radar_rba"; airportId = 2; airportName = "Rabat (RBA)"},
    @{username = "radar_rak"; airportId = 3; airportName = "Marrakech (RAK)"},
    @{username = "radar_tng"; airportId = 4; airportName = "Tanger (TNG)"}
)

Write-Host "Assignation automatique en cours..." -ForegroundColor Yellow
Write-Host ""

$successCount = 0
$errorCount = 0

foreach ($assignment in $assignments) {
    $username = $assignment.username
    $airportId = $assignment.airportId
    $airportName = $assignment.airportName
    
    Write-Host "Assignation: $username -> $airportName (ID: $airportId)..." -ForegroundColor White
    
    $query = @"
UPDATE users 
SET airport_id = $airportId 
WHERE username = '$username' AND role = 'CENTRE_RADAR';
"@
    
    try {
        $env:PGPASSWORD = $dbPassword
        $result = psql -h $dbHost -p $dbPort -U $dbUser -d $dbName -c $query 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  ✅ Assigné avec succès" -ForegroundColor Green
            $successCount++
        } else {
            Write-Host "  ❌ Erreur: $result" -ForegroundColor Red
            $errorCount++
        }
    } catch {
        Write-Host "  ❌ Erreur: $_" -ForegroundColor Red
        $errorCount++
    }
}

Write-Host ""
Write-Host "=== Résumé ===" -ForegroundColor Cyan
Write-Host "Succès: $successCount" -ForegroundColor Green
Write-Host "Erreurs: $errorCount" -ForegroundColor $(if ($errorCount -gt 0) { "Red" } else { "Green" })

Write-Host ""
Write-Host "Vérification des assignations..." -ForegroundColor Yellow

$queryVerify = @"
SELECT 
    u.id, 
    u.username, 
    u.role, 
    u.airport_id, 
    a.name as airport_name, 
    a.code_iata,
    a.city
FROM users u
LEFT JOIN airports a ON u.airport_id = a.id
WHERE u.role = 'CENTRE_RADAR'
ORDER BY u.id;
"@

try {
    $env:PGPASSWORD = $dbPassword
    psql -h $dbHost -p $dbPort -U $dbUser -d $dbName -c $queryVerify
} catch {
    Write-Host "Erreur lors de la vérification: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "=== Script terminé ===" -ForegroundColor Cyan
Write-Host "Vous pouvez maintenant vous reconnecter avec un compte CENTRE_RADAR." -ForegroundColor Green


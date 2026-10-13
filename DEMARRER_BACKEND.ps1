# Script pour démarrer le Backend
Write-Host "🚀 Démarrage du Backend..." -ForegroundColor Cyan

cd backend

Write-Host "📦 Compilation et démarrage..." -ForegroundColor Yellow
mvn spring-boot:run


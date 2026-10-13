# 🏗️ Plan d'Architecture Complète - PFA 2026

## 📋 Vue d'ensemble

Refonte complète du système avec architecture microservices, dashboards professionnels, et fonctionnalités aéronautiques réelles.

## 🎯 Objectifs

1. ✅ Authentification complète (JWT, 3 rôles, protection routes)
2. ✅ Dashboard ADMIN avec KPIs aéronautiques réels
3. ✅ Dashboard CENTRE RADAR avec carte radar, ATIS, autorisations ATC
4. ✅ Dashboard PILOTE amélioré
5. ✅ Architecture microservices
6. ✅ Base de données complète
7. ✅ WebSockets pour temps réel
8. ✅ Event Bus (Kafka/RabbitMQ)
9. ✅ Sécurité complète

## 🏗️ Architecture Cible

```
┌─────────────────────────────────────────────────────────────┐
│                    Frontend (React)                        │
│  - Login                                                    │
│  - Dashboard Admin                                          │
│  - Dashboard Radar                                          │
│  - Dashboard Pilote                                         │
└───────────────────────┬───────────────────────────────────┘
                        │ HTTP/REST + WebSocket
┌───────────────────────▼───────────────────────────────────┐
│              API Gateway (Port 8080)                       │
│  - Routing                                                │
│  - Authentication JWT                                     │
│  - Rate Limiting                                          │
└───────────────────────┬───────────────────────────────────┘
                        │
        ┌───────────────┼───────────────┬───────────────┐
        │               │               │               │
┌───────▼──────┐ ┌──────▼──────┐ ┌──────▼──────┐ ┌──────▼──────┐
│   Eureka     │ │   Service   │ │   Service   │ │   Service   │
│   Server     │ │   Auth      │ │   Pilote    │ │   Avion     │
│   Port:8761  │ │  Port:8081  │ │  Port:8082  │ │  Port:8083  │
└──────────────┘ └──────────────┘ └──────────────┘ └──────────────┘
                        │               │               │
┌───────────────────────▼───────────────▼───────────────▼───────┐
│                    Service Radar (Port 8084)                │
│                    Service Aéroport (Port 8085)              │
│                    Service Météo (Port 8086)                 │
└───────────────────────────────────────────────────────────────┘
                        │
┌───────────────────────▼───────────────────────────────────┐
│              Event Bus (Kafka/RabbitMQ)                    │
│  - Messages ATC                                            │
│  - Mises à jour position avion                             │
│  - Alertes météo                                           │
│  - Autorisations décollage                                 │
└───────────────────────────────────────────────────────────┘
                        │
┌───────────────────────▼───────────────────────────────────┐
│              PostgreSQL (flightradar_db)                  │
└───────────────────────────────────────────────────────────┘
```

## 📝 Phase 1 : Amélioration Authentification (Sans casser)

### 1.1 Améliorer SecurityConfig
- ✅ Ajouter protection par rôle (ADMIN, CENTRE_RADAR, PILOTE)
- ✅ Filtrer JWT sur toutes les requêtes
- ✅ Protéger routes selon rôle

### 1.2 Créer JWT Filter
- ✅ Intercepter les requêtes
- ✅ Valider le token JWT
- ✅ Extraire le rôle et l'utilisateur

### 1.3 API Gestion Comptes
- ✅ POST /api/auth/register - Créer compte (ADMIN seulement)
- ✅ GET /api/auth/users - Liste utilisateurs (ADMIN)
- ✅ PUT /api/auth/users/{id} - Modifier utilisateur (ADMIN)
- ✅ DELETE /api/auth/users/{id} - Supprimer utilisateur (ADMIN)

## 📝 Phase 2 : Base de Données Complète

### 2.1 Modèles à Créer/Modifier

**User (modifier) :**
- ✅ Ajouter `airportId` (si RADAR)
- ✅ Ajouter `pilotId` (si PILOTE)

**Pilot (modifier) :**
- ✅ Ajouter `assignedAircraftId`

**Aircraft (modifier) :**
- ✅ Ajouter `numeroVol`
- ✅ Ajouter `trajectoirePrévue` (JSON)
- ✅ Ajouter `trajectoireRéelle` (JSON)

**Nouveau : MessagesATC**
- ✅ id, avionId, radarId, piloteId, message, type, timestamp

**Nouveau : ATISData**
- ✅ id, airportId, vent, visibilité, pression, turbulence, temperature, conditions, timestamp

## 📝 Phase 3 : Dashboard ADMIN

### 3.1 KPIs Aéronautiques

**Temps Réel :**
- Nombre total d'avions en vol
- Nombre de pilotes connectés
- Trafic en temps réel par aéroport
- Statut des centres radar (charge, nombre d'avions suivis)
- Nombre de décollages / atterrissages du jour
- Retards cumulés + retards moyens par aéroport
- Alertes météo globales
- Indicateurs de sécurité

**Performance :**
- Performance ATC
- Inefficacité 3D (différence route prévue vs réelle)
- Charge trafic à 15 min / 60 min
- Capacité aéroports
- DMAN (Departure Manager) : TTOT (Target Takeoff Time)

### 3.2 Services Backend

**AdminDashboardService :**
- ✅ Calculer tous les KPIs
- ✅ Récupérer statistiques
- ✅ Analyser performance

**AdminDashboardController :**
- ✅ GET /api/admin/dashboard - Dashboard complet
- ✅ GET /api/admin/kpis - KPIs temps réel
- ✅ GET /api/admin/statistics - Statistiques

## 📝 Phase 4 : Dashboard CENTRE RADAR

### 4.1 Fonctionnalités

**Carte Radar :**
- ✅ Avions dans le secteur (carte interactive)
- ✅ Position, altitude, vitesse, cap en temps réel

**Flight Progress Strips :**
- ✅ Données ATC pour chaque avion
- ✅ Statut, route, altitude assignée

**Conflits :**
- ✅ Détection séparation aérienne
- ✅ Alertes visuelles

**Météo ATIS :**
- ✅ Vent, visibilité, pression
- ✅ Piste en service
- ✅ Conditions actuelles

**Autorisations ATC :**
- ✅ Autorisation décollage
- ✅ Autorisation atterrir
- ✅ Instructions (altitude, cap)
- ✅ Historique communications

### 4.2 Services Backend

**RadarDashboardService :**
- ✅ Récupérer avions du secteur
- ✅ Calculer conflits
- ✅ Récupérer météo ATIS
- ✅ Gérer autorisations

**RadarDashboardController :**
- ✅ GET /api/radar/dashboard - Dashboard complet
- ✅ GET /api/radar/aircraft - Avions du secteur
- ✅ GET /api/radar/conflicts - Conflits détectés
- ✅ GET /api/radar/atis - Météo ATIS
- ✅ POST /api/radar/authorize-takeoff - Autoriser décollage
- ✅ POST /api/radar/authorize-landing - Autoriser atterrissage
- ✅ POST /api/radar/send-instruction - Envoyer instruction

## 📝 Phase 5 : Dashboard PILOTE (Amélioration)

### 5.1 Fonctionnalités Ajoutées

**Trajectoire :**
- ✅ Carte avec route réelle vs prévue
- ✅ Visualisation trajectoire

**Bouton "Signaler un incident" :**
- ✅ POST /api/pilots/{username}/report-incident
- ✅ Envoyer alerte au radar

**Améliorations existantes :**
- ✅ Toutes les fonctionnalités déjà implémentées

## 📝 Phase 6 : WebSockets & Event Bus

### 6.1 WebSockets (Amélioration)

**Topics :**
- ✅ /topic/aircraft-positions - Positions avions
- ✅ /topic/atc-messages - Messages ATC
- ✅ /topic/weather-alerts - Alertes météo
- ✅ /topic/takeoff-requests - Demandes décollage

### 6.2 Event Bus (Kafka/RabbitMQ)

**Events :**
- ✅ AircraftPositionUpdated
- ✅ ATCMessageSent
- ✅ WeatherAlertTriggered
- ✅ TakeoffRequestReceived
- ✅ TakeoffAuthorized

## 📝 Phase 7 : Frontend

### 7.1 Pages à Créer

**Login :**
- ✅ Page unique avec redirection selon rôle

**Dashboard Admin :**
- ✅ KPIs avec graphiques (Chart.js)
- ✅ Statistiques en temps réel
- ✅ Tableaux de bord

**Dashboard Radar :**
- ✅ Carte radar (Leaflet)
- ✅ Flight Progress Strips
- ✅ Panneau ATIS
- ✅ Console ATC

**Dashboard Pilote :**
- ✅ Amélioration existante
- ✅ Ajout trajectoire
- ✅ Bouton signaler incident

## 🚀 Ordre d'Implémentation

1. ✅ Phase 1 : Authentification (JWT Filter, protection routes)
2. ✅ Phase 2 : Base de données (modèles, migrations)
3. ✅ Phase 3 : Dashboard ADMIN (services, contrôleurs, frontend)
4. ✅ Phase 4 : Dashboard RADAR (services, contrôleurs, frontend)
5. ✅ Phase 5 : Dashboard PILOTE (améliorations)
6. ✅ Phase 6 : WebSockets & Event Bus
7. ✅ Phase 7 : Tests & Optimisation

## 🔐 Sécurité

- ✅ JWT sur toutes les requêtes
- ✅ Protection par rôle
- ✅ Validation des tokens
- ✅ Rate limiting
- ✅ CORS configuré

## 📊 Base de Données

- ✅ Schéma complet selon spécifications
- ✅ Relations (clés étrangères)
- ✅ Index pour performance
- ✅ Migrations automatiques


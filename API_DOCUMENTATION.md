# Documentation API - Flight Radar

## Base URL
```
http://localhost:8080/api
```

## Authentification

### POST /auth/login
Connexion utilisateur

**Request Body:**
```json
{
  "username": "admin",
  "password": "admin123"
}
```

**Response:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "username": "admin",
  "role": "ADMIN"
}
```

## Avions

### GET /avions
Récupère la liste de tous les avions

**Response:**
```json
[
  {
    "id": 1,
    "numeroVol": "AT1001",
    "modele": "A320",
    "latitude": 33.3675,
    "longitude": -7.5898,
    "altitude": 0.0,
    "vitesse": 0.0,
    "direction": 0.0,
    "statut": "AU_SOL",
    "derniereMiseAJour": "2026-01-01T10:00:00"
  }
]
```

### GET /avions/{id}
Récupère les détails d'un avion

### GET /avions/numero/{numeroVol}
Recherche un avion par numéro de vol

### GET /avions/aeroport/{aeroportId}
Récupère tous les avions d'un aéroport

### PUT /avions/{id}/position
Met à jour la position d'un avion

**Request Body:**
```json
{
  "latitude": 33.5,
  "longitude": -7.6,
  "altitude": 10000.0,
  "vitesse": 850.0,
  "direction": 180.0
}
```

## Aéroports

### GET /aeroports
Récupère la liste de tous les aéroports

**Response:**
```json
[
  {
    "id": 1,
    "nom": "Casablanca",
    "codeIATA": "CMN",
    "latitude": 33.3675,
    "longitude": -7.5898,
    "nombrePistes": 2
  }
]
```

### GET /aeroports/{id}
Récupère les détails d'un aéroport

### GET /aeroports/code/{codeIATA}
Recherche un aéroport par code IATA

## Météo

### GET /meteo/aeroport/{aeroportId}
Récupère les données météorologiques actuelles d'un aéroport

**Response:**
```json
{
  "id": 1,
  "temperature": 20.5,
  "vitesseVent": 15.0,
  "directionVent": 180.0,
  "visibilite": 10.0,
  "pression": 1013.25,
  "humidite": 60,
  "conditions": "Clear",
  "ventTravers": 5.0,
  "alerteMeteo": false,
  "timestamp": "2026-01-01T10:00:00"
}
```

### GET /meteo/alertes
Récupère toutes les alertes météorologiques actives

## Communications

### GET /communications
Récupère toutes les communications

### GET /communications/avion/{avionId}
Récupère les communications d'un avion spécifique

### GET /communications/radar/{centreRadarId}
Récupère les communications d'un centre radar

### POST /communications
Crée une nouvelle communication

**Request Body:**
```json
{
  "message": "Demande d'autorisation d'atterrissage",
  "type": "VHF_AVION_RADAR",
  "avionId": 1,
  "centreRadarId": null,
  "aeroportId": null
}
```

**Types de communication:**
- `VHF_RADAR_AVION`: Communication du radar vers l'avion
- `VHF_AVION_RADAR`: Communication de l'avion vers le radar
- `VHF_RADAR_AEROPORT`: Communication du radar vers l'aéroport
- `VHF_AEROPORT_RADAR`: Communication de l'aéroport vers le radar

## Codes de statut HTTP

- `200 OK`: Requête réussie
- `401 Unauthorized`: Non authentifié
- `404 Not Found`: Ressource non trouvée
- `500 Internal Server Error`: Erreur serveur

## Notes

- Toutes les requêtes nécessitant une authentification doivent inclure le token JWT dans le header:
  ```
  Authorization: Bearer <token>
  ```

- Les positions des avions sont mises à jour automatiquement toutes les 5 secondes

- Les données météorologiques sont mises à jour toutes les 10 minutes


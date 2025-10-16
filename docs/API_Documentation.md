# API Documentation - RoadGuard

## Overview

This document provides comprehensive information about the RoadGuard API, including endpoints, request/response formats, authentication, and integration guidelines.

## Base URL

```
Production: https://api.roadguard.co.zm/v1
Staging: https://staging-api.roadguard.co.zm/v1
Development: http://localhost:3000/v1
```

## Authentication

All API requests require authentication using Bearer tokens:

```
Authorization: Bearer <your_access_token>
```

### Obtaining Access Tokens

**Endpoint:** `POST /auth/login`

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "user_password"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "token_type": "Bearer",
    "expires_in": 3600,
    "user": {
      "id": 1,
      "name": "John Doe",
      "email": "user@example.com"
    }
  }
}
```

## Endpoints

### User Management

#### Get User Profile
- **Endpoint:** `GET /user/profile`
- **Description:** Retrieve current user's profile information
- **Authentication:** Required

**Response:**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "John Doe",
    "email": "user@example.com",
    "phone": "+260123456789",
    "license_number": "DL123456789",
    "license_expiry": "2025-12-31",
    "vehicle_count": 2
  }
}
```

#### Update User Profile
- **Endpoint:** `PUT /user/profile`
- **Description:** Update user profile information
- **Authentication:** Required

**Request Body:**
```json
{
  "name": "John Doe Updated",
  "phone": "+260123456789"
}
```

### Traffic Alerts

#### Get Traffic Alerts
- **Endpoint:** `GET /traffic/alerts`
- **Description:** Retrieve real-time traffic alerts based on location
- **Authentication:** Required
- **Query Parameters:**
  - `latitude` (float, required): User's latitude
  - `longitude` (float, required): User's longitude
  - `radius` (int, optional): Search radius in kilometers (default: 10)

**Response:**
```json
{
  "success": true,
  "data": {
    "alerts": [
      {
        "id": 1,
        "type": "accident",
        "severity": "high",
        "title": "Major Accident on Lumumba Road",
        "description": "Multi-vehicle collision blocking all lanes",
        "latitude": -15.3875,
        "longitude": 28.3228,
        "created_at": "2025-10-16T09:00:00Z",
        "estimated_clearance": "2025-10-16T11:00:00Z"
      }
    ],
    "total_count": 1
  }
}
```

#### Report Traffic Incident
- **Endpoint:** `POST /traffic/report`
- **Description:** Report a traffic incident or road condition
- **Authentication:** Required

**Request Body:**
```json
{
  "type": "accident",
  "severity": "medium",
  "title": "Road Construction",
  "description": "Lane closure due to road works",
  "latitude": -15.3875,
  "longitude": 28.3228,
  "estimated_duration": "2 hours"
}
```

### License Management

#### Get License Information
- **Endpoint:** `GET /license/info`
- **Description:** Retrieve driver's license information and status
- **Authentication:** Required

**Response:**
```json
{
  "success": true,
  "data": {
    "license_number": "DL123456789",
    "issue_date": "2020-01-15",
    "expiry_date": "2025-12-31",
    "status": "active",
    "vehicle_classes": ["B", "C1"],
    "restrictions": [],
    "endorsements": ["hazardous_materials"]
  }
}
```

#### Renew License
- **Endpoint:** `POST /license/renew`
- **Description:** Initiate license renewal process
- **Authentication:** Required

**Request Body:**
```json
{
  "payment_method": "mobile_money",
  "phone_number": "+260123456789"
}
```

### Road Tax Management

#### Get Tax Status
- **Endpoint:** `GET /tax/status`
- **Description:** Retrieve road tax payment status for user's vehicles
- **Authentication:** Required

**Response:**
```json
{
  "success": true,
  "data": {
    "vehicles": [
      {
        "registration_number": "ABC123ZM",
        "tax_status": "paid",
        "expiry_date": "2025-12-31",
        "amount_paid": 1500.00,
        "payment_date": "2025-01-15"
      }
    ]
  }
}
```

#### Pay Road Tax
- **Endpoint:** `POST /tax/pay`
- **Description:** Process road tax payment
- **Authentication:** Required

**Request Body:**
```json
{
  "vehicle_registration": "ABC123ZM",
  "payment_method": "mobile_money",
  "phone_number": "+260123456789",
  "amount": 1500.00
}
```

### Emergency Services

#### Get Emergency Contacts
- **Endpoint:** `GET /emergency/contacts`
- **Description:** Retrieve emergency contact numbers and services
- **Authentication:** Not required

**Response:**
```json
{
  "success": true,
  "data": {
    "police": "+260211123456",
    "ambulance": "+260211654321",
    "fire": "+260211789012",
    "rtsa_emergency": "+260211246813"
  }
}
```

#### Send Emergency Alert
- **Endpoint:** `POST /emergency/alert`
- **Description:** Send emergency alert with location
- **Authentication:** Required

**Request Body:**
```json
{
  "type": "accident",
  "location": {
    "latitude": -15.3875,
    "longitude": 28.3228
  },
  "description": "Vehicle accident requiring immediate assistance"
}
```

## Error Handling

All API responses follow a consistent error format:

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": {
      "email": ["The email field is required."]
    }
  }
}
```

### Common Error Codes

- `AUTHENTICATION_FAILED`: Invalid or missing authentication token
- `VALIDATION_ERROR`: Invalid request data
- `NOT_FOUND`: Requested resource not found
- `RATE_LIMITED`: Too many requests from client
- `SERVER_ERROR`: Internal server error

## Rate Limiting

API requests are rate-limited to prevent abuse:
- 1000 requests per hour for authenticated users
- 100 requests per hour for unauthenticated users

## SDK and Libraries

### Flutter SDK
```dart
import 'package:roadguard_api/roadguard_api.dart';

final client = RoadGuardAPI(apiKey: 'your_api_key');
final alerts = await client.getTrafficAlerts(latitude: -15.3875, longitude: 28.3228);
```

### JavaScript SDK
```javascript
import { RoadGuardAPI } from 'roadguard-api';

const client = new RoadGuardAPI({ apiKey: 'your_api_key' });
const alerts = await client.getTrafficAlerts(-15.3875, 28.3228);
```

## Support

For API support or questions:
- Email: api-support@roadguard.co.zm
- Documentation: https://docs.roadguard.co.zm
- Status Page: https://status.roadguard.co.zm

---

*This API documentation is subject to change. Please check for updates regularly.*

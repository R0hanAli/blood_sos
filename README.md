🩸 BloodSOS

BloodSOS is a real-time emergency blood requesting and donor discovery platform designed to connect patients, blood donors, and hospitals during urgent blood requirements.

The platform combines a cross-platform Flutter mobile application with a real-time backend powered by Node.js, Express, TypeScript, Socket.io, and Firebase.

BloodSOS focuses on reducing the time required to find eligible blood donors by providing real-time emergency requests, location-based discovery, role-specific workflows, and live notifications.

🎯 Project Overview

Finding a suitable blood donor during an emergency can be difficult and time-sensitive.

BloodSOS provides a centralized platform where:

🏥 Hospitals can create emergency blood requests

🧑‍🩸 Donors can discover relevant requests

🧑‍⚕️ Patients can request blood during emergencies

📍 Location information helps identify nearby requests

⚡ Socket.io enables real-time request notifications

🔐 Firebase Authentication manages user authentication

☁️ Firebase/Firestore stores application data

📱 Flutter provides a cross-platform mobile experience

🏛️ System Architecture

graph TD
    Client[Flutter Mobile App]

    Client <-->|HTTP / REST| API[Node.js REST API]
    Client <-->|WebSockets| SocketServer[Socket.io Server]
    Client <-->|Authentication| FirebaseClient[Firebase Auth SDK]

    API <-->|Admin SDK| FirebaseAdmin[Firebase / Firestore]

    SocketServer -->|Real-Time Notifications| Client

Architecture Components

Component

Technology

Responsibility

Mobile Application

Flutter

User interface and client-side workflows

State Management

Riverpod

Application state and dependency management

Routing

GoRouter

Navigation and route management

HTTP Client

Dio

REST API communication

Local Storage

Hive

Local caching and offline fallback

Backend

Node.js + TypeScript

Server-side application logic

REST API

Express

HTTP API endpoints

Real-Time Layer

Socket.io

Live emergency request notifications

Authentication

Firebase Auth

User authentication

Database

Firebase / Firestore

User profiles and application data

Backend Firebase Access

Firebase Admin SDK

Server-side Firebase operations

👥 User Roles

BloodSOS is designed around multiple user types with role-specific workflows.

🩸 Donor

Donors can:

Create a donor account

Maintain their donor profile

Provide relevant blood information

Discover emergency blood requests

Receive real-time notifications

View request locations

Respond to suitable requests

🧑‍⚕️ Patient

Patients can:

Register and manage their profile

Create emergency blood requests

Specify required blood information

View request status

Receive relevant updates

🏥 Hospital

Hospitals can:

Register as a healthcare organization

Create emergency blood requests

Provide request information

Monitor emergency requests

Receive donor responses

Manage request-related information

🚨 Emergency Blood Requests

The core functionality of BloodSOS is its emergency request system.

A typical workflow is:

Create Blood Request
        ↓
Request Validation
        ↓
Request Published
        ↓
Location / Eligibility Matching
        ↓
Socket.io Notification
        ↓
Nearby Eligible Donors
        ↓
Donor Response
        ↓
Request Status Updated

Emergency requests can contain relevant information such as:

Blood group

Required quantity

Request urgency

Patient information

Hospital information

Request location

Contact information

Request status

⚡ Real-Time Communication

BloodSOS uses Socket.io to provide real-time communication between the backend and connected Flutter clients.

When an emergency blood request is created, the backend can notify relevant connected users without requiring the application to repeatedly refresh the request list.

Hospital / Patient
       │
       ↓
Create Emergency Request
       │
       ↓
Node.js API
       │
       ↓
Socket.io Server
       │
       ├───────────────┐
       ↓               ↓
Eligible Donor A   Eligible Donor B
       │               │
       └───────┬───────┘
               ↓
        Real-Time Alert

This real-time architecture is particularly useful for emergency scenarios where response time matters.

📍 Location & Geolocation

BloodSOS incorporates location-aware functionality to help users understand where emergency requests are located.

The application can provide:

Request locations

Geographic proximity information

Map-based request discovery

Location-aware donor discovery

Dynamic request positioning

The location system can help donors identify emergency requests that are geographically relevant to them.

🗺️ Maps & Request Discovery

Emergency requests can be presented using location-based interfaces.

A typical discovery flow:

Current User Location
        ↓
Fetch Emergency Requests
        ↓
Determine Request Locations
        ↓
Calculate / Display Proximity
        ↓
Show Relevant Requests
        ↓
Open Request Details

🔐 Authentication & Authorization

Firebase Authentication provides the client-side authentication layer.

BloodSOS supports structured registration flows for different user roles.

                 Authentication
                       │
          ┌────────────┼────────────┐
          ↓            ↓            ↓
       Donor         Patient      Hospital
          │            │            │
          ↓            ↓            ↓
     Donor Flow    Patient Flow   Hospital Flow

The backend uses the Firebase Admin SDK to perform server-side authentication and user/profile verification.

💾 Offline Caching & Fallbacks

BloodSOS uses Hive-based local storage to provide caching and fallback behavior.

This helps the application remain usable when network connectivity is temporarily unavailable or an API endpoint cannot be reached.

Flutter Application
        │
        ↓
    Network Request
        │
    ┌───┴────┐
    ↓        ↓
 Online    Offline
    │        │
    ↓        ↓
 REST API   Hive Cache
    │        │
    └───┬────┘
        ↓
    Application

Cached information can help maintain a smoother navigation experience while connectivity is restored.

🛠️ Features

🔐 Multi-Role Authentication

Donor registration

Patient registration

Hospital registration

Role-specific workflows

Firebase Authentication

Server-side profile verification

🚨 Emergency Blood Requests

Create emergency requests

Blood group requirements

Request status management

Hospital/patient request information

Real-time request distribution

⚡ Real-Time Notifications

Socket.io WebSocket communication

Live emergency request updates

Connected donor notifications

Real-time request state changes

📍 Location-Based Discovery

Request locations

Geographic proximity

Map-based request discovery

Location-aware donor workflows

💾 Offline Support

Hive-based caching

Offline navigation fallback

Cached data access

Network-aware application behavior

📱 Cross-Platform Application

Flutter provides a shared application codebase for supported platforms while maintaining a mobile-first experience.

📱 Flutter Architecture

The mobile application uses a layered structure around feature modules and shared application services.

A representative structure is:

lib/
│
├── core/
│   ├── network/
│   │   └── api_client.dart
│   │
│   ├── services/
│   │   └── ...
│   │
│   ├── routing/
│   └── utils/
│
├── features/
│   ├── authentication/
│   ├── donors/
│   ├── patients/
│   ├── hospitals/
│   ├── blood_requests/
│   ├── maps/
│   └── profile/
│
├── providers/
│   └── providers.dart
│
└── main.dart

The exact structure can evolve as additional application modules are introduced.

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

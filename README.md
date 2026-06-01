<div align="center">

# 🚗 Online Vehicle Rental Portal

<img src="https://readme-typing-svg.herokuapp.com?font=Poppins&size=28&duration=3000&pause=1000&color=0E75B6&center=true&vCenter=true&width=800&lines=Online+Vehicle+Rental+Portal;Core+Java+%7C+JDBC+%7C+Servlets+%7C+JSP;PostgreSQL+Database+Powered;MVC+Architecture+Based+Project" />

<br>

![Java](https://img.shields.io/badge/Java-17-orange?style=for-the-badge&logo=java)
![JDBC](https://img.shields.io/badge/JDBC-Database-blue?style=for-the-badge)
![Servlets](https://img.shields.io/badge/Servlets-Web_App-success?style=for-the-badge)
![JSP](https://img.shields.io/badge/JSP-Frontend-red?style=for-the-badge)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Database-336791?style=for-the-badge&logo=postgresql)
![MVC](https://img.shields.io/badge/Architecture-MVC-green?style=for-the-badge)

</div>

---

# 📖 Overview

The **Online Vehicle Rental Portal** is a web-based vehicle booking and management system developed using **Core Java, JDBC, Servlets, JSP, and PostgreSQL**.

The application allows users to browse available vehicles, book rentals online, manage bookings, and track rental history. It also provides an administrative dashboard for managing vehicles, users, and rental records efficiently.

---

# 🎯 Objectives

- Digitize vehicle rental operations.
- Simplify online vehicle booking.
- Reduce manual paperwork.
- Provide centralized rental management.
- Improve customer experience through automation.

---

# ✨ Key Features

## 👤 Customer Module

- User Registration
- Secure Login & Logout
- View Available Vehicles
- Search Vehicles
- Vehicle Booking
- Booking Cancellation
- Rental History Tracking
- Profile Management

---

## 🛠️ Admin Module

- Admin Authentication
- Add New Vehicles
- Update Vehicle Details
- Delete Vehicles
- Manage Vehicle Inventory
- View All Bookings
- Manage Customers
- Monitor Rental Activities

---

# 🏗️ Project Architecture

```text
+----------------------+
|      JSP Pages       |
|    (Presentation)    |
+----------+-----------+
           |
           v
+----------------------+
|      Servlets        |
|     (Controller)     |
+----------+-----------+
           |
           v
+----------------------+
|     Core Java        |
|   (Business Logic)   |
+----------+-----------+
           |
           v
+----------------------+
|        JDBC          |
| Database Connection  |
+----------+-----------+
           |
           v
+----------------------+
|     PostgreSQL       |
|      Database        |
+----------------------+
```

---

# 💻 Technology Stack

| Technology | Purpose |
|------------|----------|
| Core Java | Business Logic |
| JDBC | Database Connectivity |
| Servlets | Request Processing |
| JSP | Dynamic Web Pages |
| HTML | Structure |
| CSS | Styling |
| PostgreSQL | Database |
| Apache Tomcat | Application Server |

---

# 📂 Database Design

## Users Table

| Column | Type |
|----------|----------|
| user_id | INT |
| name | VARCHAR |
| email | VARCHAR |
| password | VARCHAR |
| phone | VARCHAR |

---

## Vehicles Table

| Column | Type |
|----------|----------|
| vehicle_id | INT |
| vehicle_name | VARCHAR |
| vehicle_type | VARCHAR |
| rent_per_day | DECIMAL |
| availability | VARCHAR |

---

## Bookings Table

| Column | Type |
|----------|----------|
| booking_id | INT |
| user_id | INT |
| vehicle_id | INT |
| booking_date | DATE |
| return_date | DATE |

---

## Admin Table

| Column | Type |
|----------|----------|
| admin_id | INT |
| username | VARCHAR |
| password | VARCHAR |

---

# 🔄 Application Workflow

```text
User Registration
        ↓
User Login
        ↓
Browse Vehicles
        ↓
Select Vehicle
        ↓
Book Vehicle
        ↓
Store Booking in Database
        ↓
View Booking History
```

---

# 📸 Screenshots

## 🏠 Home Page

Add Screenshot Here

---

## 🔐 Login Page

Add Screenshot Here

---

## 🚘 Vehicle Listing

Add Screenshot Here

---

## 📅 Booking Page

Add Screenshot Here

---

## 📊 Admin Dashboard

Add Screenshot Here

---

# 📈 Future Enhancements

- Online Payment Gateway
- Email Notifications
- Vehicle Tracking System
- Advanced Search Filters
- Mobile Responsive Design
- REST API Integration
- Cloud Deployment
- Report Generation

---

# 🎓 Learning Outcomes

- Java Web Application Development
- JDBC Connectivity
- MVC Architecture
- Session Management
- CRUD Operations
- PostgreSQL Database Design
- Servlet Lifecycle
- JSP Development

---

# 👨‍💻 Developer

## Jignesh Jadhav

Java Full Stack Developer

📧 Email:
jignesh.jadhav0000@gmail.com

🔗 LinkedIn:
www.linkedin.com/in/jignesh-jadhav00

💻 GitHub:
github.com/jignesh-jadhav-dev

---

<div align="center">

### ⭐ If you found this project useful, give it a Star ⭐

</div>

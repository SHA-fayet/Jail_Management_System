Jail Management System (JMS-Karagar)
A fully advanced, feature-rich Jail Management System built with Flask and MySQL. This application provides a comprehensive suite of tools for administrators and jailers to manage inmates, visitors, cells, security, and daily operations within a correctional facility.

📋 Core Features
JMS-Karagar is designed with a robust set of features to ensure efficient and secure management of a correctional facility.

🔐 Authentication & Security
Role-Based Access Control: Differentiated access levels for Admin and Jailer roles.

Session-Based Authentication: Secure login system to protect sensitive data.

Protected Routes: Unauthorized users are automatically redirected to the login page.

📊 Interactive Dashboard
At-a-Glance Analytics: Key metrics including total active inmates, released inmates, and today's visitor count.

Upcoming Release Alerts: A dedicated section for inmates scheduled for release within the next 7 days.

Visual Data Representation: A dynamic bar chart (using Chart.js) displaying monthly inmate admission trends.

👮‍♂️ Inmate & Staff Management
Full Inmate Lifecycle: Comprehensive CRUD (Create, Read, Update, Delete) operations for inmate records.

Detailed Inmate Profiles: Fields include name, photo, crime, sentence details, admission/release dates, and cell assignments.

Admin-Only User Creation: Administrators have exclusive rights to create and manage jailer accounts.

🏢 Cell & Transfer Management
Cell Monitoring: View all cells, their capacity, and current occupancy at a glance.

Inmate Assignment: Easily assign or re-assign inmates to different cells.

Complete Transfer History: Log and review every inmate transfer between cells, including reasons and dates.

🧍‍♂️ Visitor & Request System
Public-Facing Visit Request Form: An accessible portal for the public to request visits, which are then queued for approval.

Request Management: Jailers and admins can approve or reject visitor requests.

Visitor Logging: Maintain a complete history of all approved visits, linked to specific inmates.

🚨 Alerts & Notifications
Automated Alerts: System-generated alerts for critical events like upcoming releases and severe behavioral incidents.

Internal Notification System: Staff receive notifications for new visit requests and other important updates.

⚖️ Punishments & Behavior
Disciplinary Records: Log and manage punishment records for inmates, including details and dates.

🔍 Advanced Search
Faceted Search: A powerful search module to filter inmates by name, crime, status (Active/Released), cell number, or a date range for release.

🛠️ Technology Stack
Backend: Flask (Python)

Database: MySQL

Frontend: HTML, CSS, JavaScript, Bootstrap 5

Charting: Chart.js

📂 Project Structure
The project follows a modular structure to keep the code organized and maintainable.

JMS_Project/
├── app/
│   ├── models/
│   │   └── db_schema.sql
│   ├── routes/
│   │   ├── alerts.py
│   │   ├── auth.py
│   │   ├── cells.py
│   │   ├── dashboard.py
│   │   ├── inmates.py
│   │   ├── notifications.py
│   │   ├── punishments.py
│   │   ├── search.py
│   │   ├── transfers.py
│   │   ├── visit_request.py
│   │   ├── visitors.py
│   │   └── work_assignments.py
│   ├── static/
│   │   └── ... (css, images, etc.)
│   └── templates/
│       ├── base.html
│       ├── login.html
│       ├── dashboard.html
│       └── ... (all other HTML files)
├── venv/
├── __init__.py          # Initializes the Flask app and its extensions
├── config.py            # Configuration settings (database URI, secret key)
├── run.py               # Main entry point to start the application
└── jms.env              # Environment variables

🚀 Getting Started
Follow these instructions to set up and run the project on your local machine.

Prerequisites
Python 3.10+

MySQL Server

Git

Installation & Setup
Clone the repository:

git clone [https://github.com/your-username/JMS-Karagar.git](https://github.com/SHA-fayet/JMS-Karagar.git)
cd JMS-Karagar

Create and activate a virtual environment:

# For Windows
python -m venv venv
.\venv\Scripts\activate

# For macOS/Linux
python3 -m venv venv
source venv/bin/activate

Install the required packages:

pip install -r requirements.txt

(Note: You will need to create a requirements.txt file by running pip freeze > requirements.txt)

Set up the database:

Open your MySQL client (e.g., phpMyAdmin, MySQL Workbench).

Create a new database named jms.

Import the provided schema from app/models/db_schema.sql into the jms database.

Configure environment variables:

Rename the jms.env file to .env.

Add/update your database credentials and a secret key in this file:

SECRET_KEY='a_very_strong_and_random_secret_key'
MYSQL_HOST='localhost'
MYSQL_USER='your_mysql_username'
MYSQL_PASSWORD='your_mysql_password'
MYSQL_DB='jms'

Run the application:

flask run

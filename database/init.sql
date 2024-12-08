-- Database creation
CREATE DATABASE IF NOT EXISTS telemedicine_africa;
USE telemedicine_africa;

-- Users table
CREATE TABLE users (
    id VARCHAR(36) PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    role ENUM('patient', 'doctor', 'admin') NOT NULL,
    phone_number VARCHAR(20),
    is_verified BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Specialties table
CREATE TABLE specialties (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT
);

-- Hospitals table
CREATE TABLE hospitals (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address TEXT NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(255),
    type ENUM('primary', 'specialty', 'tertiary') NOT NULL
);

-- Doctors table
CREATE TABLE doctors (
    id VARCHAR(36) PRIMARY KEY,
    user_id VARCHAR(36) NOT NULL,
    specialty_id VARCHAR(36) NOT NULL,
    hospital_id VARCHAR(36) NOT NULL,
    license_number VARCHAR(50) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (specialty_id) REFERENCES specialties(id),
    FOREIGN KEY (hospital_id) REFERENCES hospitals(id)
);

-- Appointments table
CREATE TABLE appointments (
    id VARCHAR(36) PRIMARY KEY,
    patient_id VARCHAR(36) NOT NULL,
    doctor_id VARCHAR(36) NOT NULL,
    appointment_date DATETIME NOT NULL,
    status ENUM('scheduled', 'completed', 'cancelled') NOT NULL,
    meeting_room_id VARCHAR(255),
    type ENUM('video', 'in-person') NOT NULL,
    notes TEXT,
    FOREIGN KEY (patient_id) REFERENCES users(id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(id)
);

-- Audit Logs table
CREATE TABLE audit_logs (
    id VARCHAR(36) PRIMARY KEY,
    user_id VARCHAR(36),
    action VARCHAR(100) NOT NULL,
    details JSON,
    entity_type VARCHAR(50),
    entity_id VARCHAR(36),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- System Settings table
CREATE TABLE system_settings (
    key VARCHAR(100) PRIMARY KEY,
    value TEXT NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Add after existing tables
CREATE TABLE role_permissions (
    role_id VARCHAR(36) NOT NULL,
    permission VARCHAR(100) NOT NULL,
    PRIMARY KEY (role_id, permission)
);

-- Insert demo data for specialties
INSERT INTO specialties (id, name, description) VALUES
('1', 'General Medicine', 'Primary healthcare and general medical services'),
('2', 'Pediatrics', 'Medical care for children and adolescents'),
('3', 'Obstetrics & Gynecology', 'Women''s health and reproductive care'),
('4', 'Cardiology', 'Heart and cardiovascular system'),
('5', 'Orthopedics', 'Musculoskeletal system and injuries');

-- Insert demo data for hospitals in Nigeria
INSERT INTO hospitals (id, name, address, city, state, type) VALUES
('1', 'Lagos University Teaching Hospital', 'Idi-Araba', 'Lagos', 'Lagos', 'tertiary'),
('2', 'National Hospital Abuja', 'Plot 132 Central District', 'Abuja', 'FCT', 'tertiary'),
('3', 'University College Hospital', 'Queen Elizabeth Road', 'Ibadan', 'Oyo', 'tertiary'),
('4', 'Aminu Kano Teaching Hospital', 'Zaria Road', 'Kano', 'Kano', 'tertiary'),
('5', 'University of Nigeria Teaching Hospital', 'Ituku-Ozalla', 'Enugu', 'Enugu', 'tertiary');

-- Insert default system settings
INSERT INTO system_settings (key, value) VALUES
('appointmentDuration', '30'),
('workingHoursStart', '09:00'),
('workingHoursEnd', '17:00'),
('maxAppointmentsPerDay', '8'),
('emailNotifications', 'true'),
('smsNotifications', 'false'),
('maintenanceMode', 'false');

-- Insert default permissions
INSERT INTO role_permissions (role_id, permission) VALUES
('admin', 'manage_users'),
('admin', 'manage_doctors'),
('admin', 'manage_hospitals'),
('admin', 'manage_specialties'),
('admin', 'view_statistics'),
('admin', 'manage_settings'),
('doctor', 'view_patients'),
('doctor', 'manage_appointments'),
('doctor', 'view_medical_records'),
('patient', 'book_appointments'),
('patient', 'view_medical_history'); 
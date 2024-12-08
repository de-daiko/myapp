-- Database schema for TeleMed Africa

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
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Specialties table
CREATE TABLE specialties (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Hospitals table
CREATE TABLE hospitals (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address TEXT NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    type ENUM('primary', 'specialty', 'tertiary') NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Doctors table
CREATE TABLE doctors (
    id VARCHAR(36) PRIMARY KEY,
    user_id VARCHAR(36) NOT NULL,
    specialty_id VARCHAR(36) NOT NULL,
    hospital_id VARCHAR(36) NOT NULL,
    license_number VARCHAR(50) NOT NULL,
    consultation_fee DECIMAL(10,2),
    available_days VARCHAR(100),
    available_hours VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
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
    type ENUM('video', 'in-person') NOT NULL,
    status ENUM('scheduled', 'completed', 'cancelled') NOT NULL DEFAULT 'scheduled',
    meeting_room_id VARCHAR(255),
    symptoms TEXT,
    diagnosis TEXT,
    prescription TEXT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES users(id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(id)
);

-- Medical Records table
CREATE TABLE medical_records (
    id VARCHAR(36) PRIMARY KEY,
    patient_id VARCHAR(36) NOT NULL,
    doctor_id VARCHAR(36) NOT NULL,
    appointment_id VARCHAR(36),
    record_date DATETIME NOT NULL,
    diagnosis TEXT,
    prescription TEXT,
    notes TEXT,
    attachments JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES users(id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(id),
    FOREIGN KEY (appointment_id) REFERENCES appointments(id)
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

-- Role Permissions table
CREATE TABLE role_permissions (
    role_id VARCHAR(36) NOT NULL,
    permission VARCHAR(100) NOT NULL,
    PRIMARY KEY (role_id, permission)
);

-- Insert default data
INSERT INTO specialties (id, name, description) VALUES
('1', 'General Medicine', 'Primary healthcare and general medical services'),
('2', 'Pediatrics', 'Medical care for children and adolescents'),
('3', 'Obstetrics & Gynecology', 'Women''s health and reproductive care'),
('4', 'Cardiology', 'Heart and cardiovascular system'),
('5', 'Orthopedics', 'Musculoskeletal system and injuries');

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
import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { AuthProvider } from './contexts/AuthContext';
import PrivateRoute from './components/common/PrivateRoute';
import Layout from './components/common/Layout';

// Auth Components
import Login from './components/auth/Login';
import Register from './components/auth/Register';
import EmailVerification from './components/auth/EmailVerification';

// Dashboard Components
import PatientDashboard from './components/dashboard/PatientDashboard';
import DoctorDashboard from './components/dashboard/DoctorDashboard';
import Appointments from './components/dashboard/Appointments';
import VideoConsultation from './components/video/VideoConsultation';

function App() {
  return (
    <Router>
      <AuthProvider>
        <Routes>
          {/* Public Routes */}
          <Route path="/login" element={<Login />} />
          <Route path="/register" element={<Register />} />
          <Route path="/verify-email" element={<EmailVerification />} />

          {/* Protected Routes */}
          <Route element={<Layout />}>
            <Route 
              path="/patient-dashboard" 
              element={
                <PrivateRoute>
                  <PatientDashboard />
                </PrivateRoute>
              } 
            />
            <Route 
              path="/doctor-dashboard" 
              element={
                <PrivateRoute>
                  <DoctorDashboard />
                </PrivateRoute>
              } 
            />
            <Route 
              path="/appointments" 
              element={
                <PrivateRoute>
                  <Appointments />
                </PrivateRoute>
              } 
            />
            <Route 
              path="/consultation/:roomId" 
              element={
                <PrivateRoute>
                  <VideoConsultation />
                </PrivateRoute>
              } 
            />
          </Route>
        </Routes>
      </AuthProvider>
    </Router>
  );
}

export default App; 
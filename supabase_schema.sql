-- Kowairo Database Schema
-- This file contains the SQL commands to create the necessary tables in Supabase

-- Enable Row Level Security
ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

-- Create stations table
CREATE TABLE IF NOT EXISTS stations (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    address TEXT NOT NULL,
    phone TEXT,
    email TEXT,
    description TEXT,
    director_name TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    full_name TEXT NOT NULL,
    role TEXT NOT NULL CHECK (role IN ('service_admin', 'admin', 'nurse')),
    station_id UUID REFERENCES stations(id) ON DELETE CASCADE NOT NULL,
    phone TEXT,
    username TEXT UNIQUE,
    employee_id TEXT UNIQUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create patients table
CREATE TABLE IF NOT EXISTS patients (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    station_id UUID REFERENCES stations(id) ON DELETE CASCADE NOT NULL,
    patient_code TEXT NOT NULL,
    full_name TEXT NOT NULL,
    full_name_kana TEXT,
    date_of_birth DATE,
    gender TEXT CHECK (gender IN ('male', 'female')),
    phone TEXT,
    address TEXT,
    emergency_contact TEXT,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(station_id, patient_code)
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_users_station_id ON users(station_id);
CREATE INDEX IF NOT EXISTS idx_patients_station_id ON patients(station_id);
CREATE INDEX IF NOT EXISTS idx_patients_patient_code ON patients(patient_code);

-- Row Level Security Policies

-- Users can only see their own profile
CREATE POLICY "Users can view own profile" ON users
    FOR SELECT USING (auth.uid() = id);

-- Users can update their own profile
CREATE POLICY "Users can update own profile" ON users
    FOR UPDATE USING (auth.uid() = id);

-- Users can only see patients from their station
CREATE POLICY "Users can view patients from their station" ON patients
    FOR SELECT USING (
        station_id IN (
            SELECT station_id FROM users WHERE id = auth.uid()
        )
    );

-- Service admins can view all patients
CREATE POLICY "Service admins can view all patients" ON patients
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE id = auth.uid() AND role = 'service_admin'
        )
    );

-- Users can only see stations they belong to
CREATE POLICY "Users can view their station" ON stations
    FOR SELECT USING (
        id IN (
            SELECT station_id FROM users WHERE id = auth.uid()
        )
    );

-- Service admins can view all stations
CREATE POLICY "Service admins can view all stations" ON stations
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE id = auth.uid() AND role = 'service_admin'
        )
    );

-- Enable RLS on all tables
ALTER TABLE stations ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE patients ENABLE ROW LEVEL SECURITY;

-- Create updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at
CREATE TRIGGER update_stations_updated_at BEFORE UPDATE ON stations
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_patients_updated_at BEFORE UPDATE ON patients
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

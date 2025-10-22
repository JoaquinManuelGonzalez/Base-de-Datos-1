import faker
import random
import datetime

# Crear una instancia de Faker con la localización en Argentina
fake = faker.Faker('es_AR')

# Número de registros
num_patients = 1000
num_doctors = 100
num_appointments = 20000

# Listas para almacenar los datos generados
patients = []
doctors = []
appointments = []
medical_reviews = []
prescribed_medications = []
cities = ["Buenos Aires", "Rosario", "La Plata", "Mar del Plata", "Cordoba", "Mendoza", 
          "Santa Rosa", "San Juan", "Santa Fe", "Usuahia", "Tigre", "Zarate", "Rio Gallegos", "Salta"]

# Función para generar pacientes
def generate_patients(n):
    patient_id = 10000000
    for _ in range(n):
        patient_id = fake.random_int(min=patient_id+1, max=(patient_id+100))  # DNI argentino
        patient_name = fake.name().replace("'", "''")  # Escapar comillas simples
        patient_address = fake.address().replace("\n", ", ").replace("'", "''")
        patient_city = random.choice(cities)
        primary_phone = fake.phone_number()
        secondary_phone = fake.phone_number()

        patients.append({
            'patient_id': patient_id,
            'patient_name': patient_name,
            'patient_address': patient_address,
            'patient_city': patient_city,
            'primary_phone': primary_phone,
            'secondary_phone': secondary_phone
        })

# Función para generar doctores
def generate_doctors(n):
    doctor_id = 1000
    for _ in range(n):
        doctor_id = doctor_id + 1  # ID único de doctor
        doctor_name = fake.name().replace("'", "''")
        doctor_address = fake.address().replace("\n", ", ").replace("'", "''")
        doctor_city = random.choice(cities)
        doctor_specialty = random.choice(['Cardiology', 'Pediatrics', 'Dermatology', 'Neurology', 'Gynecology'])

        doctors.append({
            'doctor_id': doctor_id,
            'doctor_name': doctor_name,
            'doctor_address': doctor_address,
            'doctor_city': doctor_city,
            'doctor_specialty': doctor_specialty,
        })

# Función para generar citas médicas
def generate_appointments(n):
    for i in range(n):
        patient = random.choice(patients)  # Seleccionar un paciente aleatorio
        appointment_date = fake.date_time_this_decade().strftime('%Y-%m-%d %H:%M:%S')
        appointment_duration = random.randint(10, 80)  # Duración en minutos
        contact_phone = patient['primary_phone'] if random.random() > 0.2 else patient['secondary_phone']
        observations = "Observation number " + str(i)
        payment_card = fake.credit_card_number()

        appointments.append({
            'patient_id': patient['patient_id'],
            'appointment_date': appointment_date,
            'appointment_duration': appointment_duration,
            'contact_phone': contact_phone,
            'observations': observations,
            'payment_card': payment_card
        })

        # Generar entre 0 y 5 revisiones médicas por cita
        num_reviews = random.randint(0, 3)
        reviewing_doctors = random.sample(doctors, num_reviews)
        for reviewing_doctor in reviewing_doctors:
            medical_reviews.append({
            'patient_id': patient['patient_id'],
            'appointment_date': appointment_date,
            'doctor_id': reviewing_doctor['doctor_id']
            })

        # Generar entre 0 y 5 medicamentos recetados por cita
        num_medications = random.randint(0, 3)
        prescribed_medication_names = random.sample(['Ibuprofeno', 'Paracetamol', 'Amoxicillin', 'Clonazepam'], num_medications)
        
        for medication_name in prescribed_medication_names:
            prescribed_medications.append({
            'patient_id': patient['patient_id'],
            'appointment_date': appointment_date,
            'medication_name': medication_name
            })

# Generar los datos
generate_patients(num_patients)
generate_doctors(num_doctors)
generate_appointments(num_appointments)

print("Data generation completed")

# Guardar los datos en un archivo SQL
# Guardar los datos en archivos SQL separados
with open('insert.sql', 'w', encoding='utf-8') as sqlfile:
    sqlfile.write("INSERT INTO Patient (patient_id, patient_name, patient_address, patient_city, primary_phone, secondary_phone) VALUES\n")
    sqlfile.write(",\n".join([f"({p['patient_id']}, '{p['patient_name']}', '{p['patient_address']}', '{p['patient_city']}', '{p['primary_phone']}', '{p['secondary_phone'] or 'NULL'}')" for p in patients]))
    sqlfile.write(";\n")

    sqlfile.write("INSERT INTO Doctor (doctor_id, doctor_name, doctor_address, doctor_city, doctor_specialty) VALUES\n")
    sqlfile.write(",\n".join([f"({d['doctor_id']}, '{d['doctor_name']}', '{d['doctor_address']}', '{d['doctor_city']}', '{d['doctor_specialty']}')" for d in doctors]))
    sqlfile.write(";\n")

    sqlfile.write("INSERT INTO Appointment (patient_id, appointment_date, appointment_duration, contact_phone, observations, payment_card) VALUES\n")
    sqlfile.write(",\n".join([f"({a['patient_id']}, '{a['appointment_date']}', {a['appointment_duration']}, '{a['contact_phone']}', '{a['observations']}', '{a['payment_card']}')" for a in appointments]))
    sqlfile.write(";\n")

    sqlfile.write("INSERT INTO MedicalReview (patient_id, appointment_date, doctor_id) VALUES\n")
    sqlfile.write(",\n".join([f"({r['patient_id']}, '{r['appointment_date']}', '{r['doctor_id']}')" for r in medical_reviews]))
    sqlfile.write(";\n")

    sqlfile.write("INSERT INTO PrescribedMedication (patient_id, appointment_date, medication_name) VALUES\n")
    sqlfile.write(",\n".join([f"({m['patient_id']}, '{m['appointment_date']}', '{m['medication_name']}')" for m in prescribed_medications]))
    sqlfile.write(";\n")

print("Saved to SQL file.")
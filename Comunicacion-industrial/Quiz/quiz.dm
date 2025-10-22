# 🔹 Resumen Técnico – PLC Siemens S7-1200

## 🧠 Controlador Principal
**Modelo:** Siemens SIMATIC S7-1200 CPU 1214C DC/DC/DC  
**Referencia:** 6ES7 214-1BG40-0XB0

**Características principales:**
- Alimentación: 24 VDC  
- Entradas digitales (DI): 14 (24 VDC)  
- Salidas digitales (DO): 10 (24 VDC, tipo transistor)  
- Entradas analógicas (AI): 2 (0–10 VDC, resolución 10 bits)  
- Salidas analógicas (AO): 2 (0–20 mA o 0–10 V)  
- Memoria de programa: 100 KB  
- Memoria de datos: 50 KB  
- Reloj en tiempo real incorporado  
- Velocidad de procesamiento: 0.08 µs/instrucción bit  
- Interfaz de comunicación: **PROFINET (Ethernet)**  
- Compatible con TIA Portal para programación y diagnóstico  

---

## 🔌 Módulos y Periféricos Conectados

### **1. PM 1207 – Power Module**
- Fuente de alimentación de 24 VDC para CPU y módulos.  
- Entrada: 120/230 VAC  
- Salida: 24 VDC / 2.5 A  

### **2. CM 1241 – Módulo de Comunicación (RS422/RS485)**
- Comunicación serial RS-422/RS-485.  
- Protocolos soportados:
  - **Modbus RTU (Master/Slave)**
  - Comunicación libre (Freeport).  

### **3. SM 1231 – Módulo de Entradas Analógicas (AI)**
- 4 canales analógicos (0–10 V o 0–20 mA).  
- Resolución: 13 bits.  

### **4. SM 1232 – Módulo de Salidas Analógicas (AQ)**
- 2 salidas analógicas (0–10 V o 0–20 mA).  
- Resolución: 12 bits.  

### **5. SB 1232 AQ – Tarjeta Analógica Adicional**
- Módulo compacto directamente en la CPU.  
- 1 salida analógica (0–10 V o 0–20 mA).  

### **6. Scalance XB005 – Switch Ethernet Industrial**
- Switch no gestionable (unmanaged).  
- 5 puertos RJ45 (10/100 Mbit/s).  
- Permite conexión entre CPU, HMI, PC y otros dispositivos **PROFINET**.  

### **7. KTP700 Basic – Panel HMI**
- Pantalla táctil de 7" (resolución 800×480).  
- Comunicación por **PROFINET / Ethernet**.  
- Alimentación: 24 VDC / 0.44 A máx.  
- Soporta alarmas, variables, gráficos e interfaz con el PLC.  

---

## 🌐 Protocolos y Comunicaciones Soportadas

| Tipo | Protocolo | Descripción |
|------|------------|-------------|
| **Ethernet Industrial** | **PROFINET** | Comunicación entre PLCs, HMIs y variadores Siemens. |
| **Ethernet TCP/IP** | **Modbus TCP**, comunicación con PC u otros dispositivos. |
| **Serial (RS-485/RS-422)** | **Modbus RTU**, **Freeport** (protocolo libre). |
| **Comunicación HMI** | **Siemens HMI Runtime** vía PROFINET. |
| **Programación / Diagnóstico** | Comunicación con **TIA Portal** mediante Ethernet. |

---

## ⚙️ Resumen General del Hardware

| Módulo | Función | Referencia |
|--------|----------|------------|
| PM 1207 | Fuente 24 VDC | 6EP1332-1SH43 |
| CM 1241 | Comunicación RS-422/485 | 6ES7241-1CH32-0XB0 |
| CPU 1214C DC/DC/DC | Control principal | 6ES7214-1BG40-0XB0 |
| SM 1231 AI | Entradas analógicas | 6ES7231-4HF32-0XB0 |
| SM 1232 AQ | Salidas analógicas | 6ES7232-4HA30-0XB0 |
| SB 1232 AQ | Tarjeta analógica adicional | 6ES7232-4HA30-0XB0 |
| Scalance XB005 | Switch Ethernet industrial | 6GK5005-0BA00-1AB2 |
| KTP700 Basic | HMI táctil | 6AV2 123-2GB03-0AX0 |

---

## ⚡ Alimentaciones
- **Tensión principal:** 24 VDC  
- **Corriente total estimada:** ~2.5 A (dependiendo de las cargas de E/S)  
- **Bus interno de comunicación** entre módulos por el conector trasero (backplane bus).

---

## 📘 Referencias de Consulta
- Siemens S7-1200 System Manual  
- Siemens TIA Portal V17 Help  
- Fichas técnicas oficiales de Siemens Industry Online Support

---


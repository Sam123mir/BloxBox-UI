# 📦 BloxBox UI Framework - Documentación Técnica (v1.00.0)

Bienvenido a la documentación oficial de **BloxBox UI**, el framework de interfaz más avanzado, modular y estético para el ecosistema de Roblox.

---

## 🚀 Guía de Inicio Rápido

### Acceso a la API
No necesitas descargar ningún archivo. BloxBox UI se carga directamente desde nuestro servidor de GitHub para asegurar que siempre tengas la última versión estable.

Copia este código en tu executor:
```lua
local BloxBox = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sam123mir/BloxBox-UI/master/Loader.lua"))()
local UI = BloxBox.new()
```

### Tu primera ventana
```lua
local Window = UI:CreateWindow({
    Title = "BloxBox Pro",
    Size = UDim2.fromOffset(580, 420)
})
```

---

## 🎨 Personalización y Estética Elite

BloxBox UI permite un control total sobre la identidad visual de tu script.

### Sistema de Temas
Puedes cambiar el color de acento dinámicamente:
```lua
UI:SetAccent(Color3.fromRGB(255, 100, 0)) -- Cambia switches, sliders y botones activos
```

### Animaciones de Introducción
Es imperativo para el branding mostrar la intro de BloxBox:
```lua
UI:ShowIntro() -- Ejecuta la splash screen animada de v1.00.0
```

---

## 🛠 Referencia de Componentes Avanzados

### 📑 Tabs (Pestañas)
Las pestañas en BloxBox son inteligentes; gestionan su propia visibilidad y optimizan el renderizado.
- `Window:CreateTab(name: string)`

### 🔘 Botones con Escala Dinámica
Los botones no solo cambian de color, sino que reaccionan físicamente a la presión.
```lua
Tab:CreateButton({
    Name = "Acción Rápida",
    Callback = function() print("Click!") end
})
```

### 🎚 Sliders de Precisión
Admiten valores flotantes y personalización de decimales.
```lua
Tab:CreateSlider({
    Name = "Sensibilidad",
    Min = 0.1,
    Max = 1.0,
    Decimals = 2,
    Callback = function(v) end
})
```

---

## 📂 Galería de Imágenes (Showcase)

> [!NOTE]
> Aquí se mostrarán las capturas de pantalla de la UI en acción para demostrar el nivel de acabado 'Elite'.

| Vista General | Notificaciones | Intro Animada |
| :--- | :--- | :--- |
| ![Preview](https://via.placeholder.com/300x200?text=Preview+BloxBox) | ![Notify](https://via.placeholder.com/300x200?text=Notification+System) | ![Intro](https://via.placeholder.com/300x200?text=Splash+Screen) |

---

## 💾 Gestión de Datos y Perfiles
BloxBox UI incluye un `StateManager` dedicado que permite sincronizar la UI con archivos de configuración locales.
- `UI:SaveConfig("MiAjuste")`
- `UI:LoadConfig("MiAjuste")`

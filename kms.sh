#!/bin/bash

# Actualizar paquetes
apt update

# Instalar dependencias
apt install -y git build-essential

# Descargar el software KMS
git clone https://github.com/Wind4/vlmcsd.git

# Compilar y configurar el software KMS
cd vlmcsd
make
make install

# Configurar el servicio KMS
tee /etc/systemd/system/vlmcsd.service <<EOF
[Unit]
Description=vlmcsd KMS Emulator
After=network.target

[Service]
User=root
Group=root
Type=simple
ExecStart=/usr/local/bin/vlmcsd

[Install]
WantedBy=multi-user.target
EOF

# Iniciar el servicio KMS
systemctl daemon-reload
systemctl enable vlmcsd
systemctl start vlmcsd

# Verificar el estado del servicio KMS
systemctl status vlmcsd

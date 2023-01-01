#!/bin/bash


sleep 45

sudo apt update

sudo apt install -y  apache2 
sudo install php libapache2-mod-php  
sudo apt -y install php8.1
sudo apt -y install php-mysqli

sudo apt install -y mysql-server
sudo apt install -y unzip 

sudo systemctl start apache2 
sudo systemctl start mysql-server         

sudo systemctl enable apache2
sudo systemctl enable mysql-server


 cd ~ 
unzip RDS-php-lab.zip
cd RDS-php-lab
sudo cp  -r includes index.html index.php /var/www/html  
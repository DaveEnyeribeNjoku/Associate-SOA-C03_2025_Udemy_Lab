# Objectif atteint se connecter sur notre instance Ec2 par SSH avec une VM Ubuntu se trouvant en dehors de notre VPC avec une clef RSA.

# Pré-requis : 
# VM Ubuntu dans VirtualBox(mode Bridge)
# Instance ip publique : 51.44.168.103
# Instance ip privée : 172.31.15.213
# Clé : SOA-C03_key.pem 


# IP locale de ta VM (mode Bridge) accées à internet ##vérifier##
ip a | grep 192.168
# → 192.168.1.47 (ou celle que tu vois)

# 1. Client + serveur SSH installés
sudo apt install openssh-client openssh-server -y

# 2. Statut du service SSH (le plus important)
sudo systemctl status ssh          # ou sshd selon la distro
# → doit afficher "active (running)" en vert

# 3. Version d’OpenSSH installée
sshd -V                            # (avec deux d minuscules)

# 4. Vérifier si le port 22 est bien à l’écoute
sudo ss -tuln | grep :22
# ou
sudo netstat -tuln | grep :22

# 5.reboot service ssh si nécessaire
Sudo systemctl restart ssh

# 6. Copie de ta clé rsa (SOA-C03_key.pem) AWS depuis pc perso Windows → VM Ubuntu (copie colle ou récupére là avec le lecteur dvd)

# 7. Vérifie que nous somme bien dans le répertoir ou se situe la clé et a l'autorisation de s'éxécuter: en 400
chmod 700 SOA-C03_key.pem   # <-- Donne les bonnes permissions au fichier SOA-C03_key.pem   

 pwd         # <-- vérifier mon emplacement

cd /home/hiruma + ls -L    # <-- lister les éléments du répertoire ou je me trouve


# 8. se connecter à l'instance Ec2 sur l'utilisateur par defaut (ec2-user) avec l'aide de son ip publique.
ssh -i SOA-C03_key.pem  ec2-user@51.44.168.103



# 9. une fois connecter à l'instance en ssh on peut lancer les maj et vérif l'OS etc...
sudo yum update -y         # → Installe toutes les mises à jour de sécurité et de paquets disponibles
cat /etc/os-release        # → Afficher la version exacte et le nom du système d’exploitation
df -h                      # → Voir l’espace disque utilisé et disponible sur tous les volumes
free -h                    # → Voir la consommation mémoire vive (RAM) et swap

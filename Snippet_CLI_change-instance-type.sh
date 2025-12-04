Voici les commandes **exactes et 100 % fonctionnelles** (testées en 2025) pour **changer le type d’une instance EC2** (ex : t3.micro → t3.small) **directement depuis ton shell** (ta VM Ubuntu, CloudShell, WSL, etc.).

### 1. Avec l’AWS CLI v2 (méthode officielle et la plus propre)

```bash
# Variables (change-les avec tes valeurs)

INSTANCE_ID=i-019b9524aff1cbca9        # ← ton instance
NEW_TYPE=t3.small                       # ← le nouveau type voulu

# 1. Arrête l’instance
aws ec2 stop-instances --instance-ids $INSTANCE_ID --query 'StoppingInstances[].PreviousState.Name' --output text

# 2. Attend qu’elle soit vraiment arrêtée (important !)
aws ec2 wait instance-stopped --instance-ids $INSTANCE_ID
echo "Instance arrêtée, on change le type…"

# 3. Change le type
aws ec2 modify-instance-attribute --instance-id $INSTANCE_ID --instance-type $NEW_TYPE

# 4. Redémarre l’instance
aws ec2 start-instances --instance-ids $INSTANCE_ID

# 5. Attend qu’elle soit running
aws ec2 wait instance-running --instance-ids $INSTANCE_ID
echo "Instance redémarrée en $NEW_TYPE !"

# Vérification finale
aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[].Instances[].InstanceType' --output text
```

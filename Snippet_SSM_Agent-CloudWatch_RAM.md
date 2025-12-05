##### AWS CloudWatch est un service de surveillance qui collecte et suit les métriques de vos ressources AWS, y compris les instances EC2. Cependant,
      par défaut, CloudWatch ne propose pas de métriques natives pour l'utilisation de la RAM (mémoire physique) et la collecte des logs sur les instances EC2.


#Voici un mini-script ultra-simple que tu peux lancer directement dans ton terminal (ou via AWS CLI)
pour installer le CloudWatch Agent via SSM et activer uniquement la surveillance de la RAM sur une instance EC2 (Linux)


# 1. Installe l'agent (si pas déjà fait)
aws ssm send-command \
  --instance-ids "i-0abcd1234efgh5678" \
  --document-name "AWS-ConfigureAWSPackage" \
  --parameters '{"action":"Install","name":"AmazonCloudWatchAgent"}' \
  --comment "Install CW Agent"

# 2. Active la surveillance RAM uniquement (config minimale stockée dans SSM Parameter Store)
aws ssm send-command \
  --instance-ids "i-0abcd1234efgh5678" \
  --document-name "AmazonCloudWatch-ManageAgent" \
  --parameters '{
    "action": "configure",
    "optionalConfigurationSource": "inline",
    "optionalConfigurationValue": "{
      \"agent\": {
        \"run_as_user\": \"cwagent\"
      },
      \"metrics\": {
        \"namespace\": \"CWAgent\",
        \"metrics_collected\": {
          \"mem\": {
            \"measurement\": [\"mem_used_percent\", \"mem_available_percent\"],
            \"metrics_collection_interval\": 60
          }
        }
      }
    }"
  }' \
  --comment "Enable RAM monitoring only"



# C’est tout !
# En moins de 2 minutes l’agent est installé et tu verras apparaître dans CloudWatch → Métriques → CWAgent :

# * mem_used_percent
# * mem_available_percent



### Bonus : Voir TOUTES les métriques disponibles sur une instance en 1 commande (super pratique)

# Liste toutes les métriques CloudWatch existantes pour ton instance
aws cloudwatch list-metrics \
  --namespace AWS/EC2 \
  --dimensions Name=InstanceId,Value=i-0abcd1234efgh5678

# Et pour les métriques de l'agent (RAM, disque, etc.)
aws cloudwatch list-metrics --namespace CWAgent --dimensions Name=InstanceId,Value=i-0abcd1234efgh5678

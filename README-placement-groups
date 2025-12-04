# AWS EC2 Placement Groups – Exemples prêts à l’emploi

Snippets AWS CLI pour créer des placement groups et lancer des instances dedans.  
À adapter avec tes propres valeurs (région, subnet, clé SSH, AMI, etc.).

## 1. Créer un Cluster Placement Group (faible latence)

```bash

aws ec2 create-placement-group \
    --group-name hpc-cluster-2025 \
    --strategy cluster \
    --region eu-west-3


2. Créer un Spread Placement Group (haute disponibilité)
aws ec2 create-placement-group \
    --group-name prod-spread-critical \
    --strategy spread \
    --region eu-west-3


3. Créer un Partition Placement Group (ex: Cassandra, HBase)
aws ec2 create-placement-group \
    --group-name bigdata-partition \
    --strategy partition \
    --partition-count 8 \
    --region eu-west-3


4. Lancer une instance dans un Cluster Placement Group
aws ec2 run-instances \
    --image-id ami-0abcdef1234567890 \
    --instance-type c6gn.8xlarge \
    --key-name MaCleSSH \
    --subnet-id subnet-0123456789abcdef0 \
    --security-group-ids sg-0123456789abcdef0 \
    --count 1 \
    --placement GroupName=hpc-cluster-2025,AvailabilityZone=eu-west-3a \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=hpc-node-01},{Key=Role,Value=compute}]' \
    --associate-public-ip-address \
    --region eu-west-3

5. Vérifier les instances dans le placement group
aws ec2 describe-instances \
    --filters "Name=placement-group-name,Values=hpc-cluster-2025" \
    --query "Reservations[*].Instances[*].[InstanceId,State.Name,Placement.{GroupName:GroupName,AvailabilityZone:AvailabilityZone}]" \
    --output table \
    --region eu-west-3

!!!Attention – Limitation importante!!!
Impossible d’ajouter ou déplacer une instance déjà lancée dans un Cluster Placement Group.
Seuls les groupes spread et partition permettent une modification (quand l’instance est arrêtée).

6. Exemple autorisé (uniquement spread/partition) :
aws ec2 modify-instance-placement \
    --instance-id i-1234567890abcdef0 \
    --placement GroupName=nouveau-spread-group

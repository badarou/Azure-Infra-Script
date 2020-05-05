#Script Shell

group=azure-load-balance-RG
az group create -g $group -l westeurope
username=demouser
password="demo@pass123"

az network vnet delete
  -n vm-vnet \
  -g $group \
  -l westeurope
  --address-prefixes '192.168.0.0/16' \
  --subnet-name subnet \
  --subnet-prefixes '192.168.1.0/24'\

az vm availability-set delete \
  -n vm-as \
  -l westeurope \
  -g $group

for NUM in 1 2 3
do
  az vm delete \
    -n vm-eu-0$NUM \
    -g $group \
    -l westeurope
    --image win2019Datacenter \
    --admin-username $username \
    --admin-password $password \
    --vnet-name vm-vnet \
    --subnet subnet \
    --public-ip-address "" \
    --avaibility-set vm-as \
    --nsg vm-nsg
done

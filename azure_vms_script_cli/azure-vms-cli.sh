
#Script Shell

# Variable  de groupe de ressource Azure

group=APPLICATION-GATEWAY-RG
location=westeurope

# Creation du groupe de ressource Azure

az group create --name $group --location $location

# Variable login utilisateur VM Azure

username=demouser
password="demo@password123"

# Creation  du reseau virtuel Azure

az network vnet create \
  --name vm-vnet \
  --resource-group $group \
  --address-prefixes '192.168.0.0/16' \
  --subnet-name subnet \
  --subnet-prefixes '192.168.1.0/24'\

# Creation des VMs Azure

for NUM in 1 2
do
  az vm create \
    --resource-group $group \
    --name VM-AG-0$NUM \
    --image Win2019Datacenter \
    --admin-username $username \
    --admin-password $password \
    --vnet-name vm-vnet \
    --subnet subnet \
    --public-ip-address "" \
    --nsg vm-nsg
done

# Ouverture du port 80 sur les VMs

for NUM in 1 2
do
  az vm open-port --port 80 --resource-group $group --name VM-AG-0$NUM
done

# Installation des services IIS sur chaque VMs Azure

for NUM in 1 2
do
  az vm extension set \
    --publisher Microsoft.Compute \
    --version 1.8 \
    --name CustomScriptExtension-IIS \
    --vm-name VM-AG-0$NUM
    --resource-group $group \
    --setting '{"commandToExecute":"powershell Add-windowsFeature Web-server; powershell Add-Content -Path \"C:\\inetpub\\wwwroot\\Default.htm\" -Value $($env:computername)"}'
done

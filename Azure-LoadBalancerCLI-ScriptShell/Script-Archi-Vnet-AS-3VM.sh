#Script Shell

group=azure-load-balance-introduction
az group create -g $group -l westeurope
username=demouser
password="demo@pass123"

az network vnet create
  -n vm-vnet \
  -g $group \
  -l westeurope
  --address-prefixes '192.168.0.0/16' \
  --subnet-name subnet \
  --subnet-prefixes '192.168.1.0/24'\

az vm availability-set create \
  -n vm-as \
  -l westeurope \
  -g $group

for NUM in 1 2 3
do
  az vm create \
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

for NUM in 1 2 3
do
  az vm open-port -g $group --name vm-eu-0$NUM --port 80
done

for NUM in 1 2 3
do
  az vm extension set \
    --name CustomScriptExtension-IIS \
    --vm-name vm-eu-0$NUM
    -g $group \
    --publisher Microsoft.Compute \
    --version 1.8 \
    --setting '{"commandToExecute":"powershell Add-windowsFeature Web-server; powershell Add-Content -Path \"C:\\inetpub\\wwwroot\\Default.htm\" -Value $($env:computername)"}'
done
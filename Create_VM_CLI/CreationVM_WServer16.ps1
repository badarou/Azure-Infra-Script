
# Connection au provider (Initiate)

Az login

# Variables

$SubID='SubID'
$RGName='Infra-AzureVM-RG'
$location='westeurope'
$VMName='virtualazure-VM'
$ImageName='win2016datacenter'
$AdminName='demouser'
$AdminPassword='demo@user123'


# Connection à la souscription

az account set --subscription $SubID

# Création du ressource groupe

az group create --name $RGName --location $location


# Création de la machine virtual windows server

az vm create --resource-group $RGName --name $VMName --image $ImageName --admin-username $AdminName --admin-password $AdminPassword


# Traffic web : Ouverture du port 80 sur la VM

az vm open-port --port 80 --resource-group $RGName --name $VMName


# Connexion à la VM Bureau à distance

# mstsc /v:publicIpAddress


# Installer le serveur web IIS dans la VM

#  Install-WindowsFeature -name Web-Server -IncludeManagementTools

# Supprimer ressource Group

az group delete --name $RGName
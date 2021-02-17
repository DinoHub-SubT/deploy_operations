##
# VM Region
# -- list of Azure regions: https://azure.microsoft.com/en-us/global-infrastructure/locations/
##
export TF_VAR_region="eastus"

##
# Create the Basestation VM's
##
export TF_VAR_basestation_create_vm=true
# Basesation: create a GPU or CPU VM
#   - set true:   when choosing to create a GPU VM instance (such as 'Standard_NC6')
#   - set false:  when choosing to create a CPU only VM instance (such as 'Standard_F8s_v2')
# -- note: your VM instaces types are defined by `basestation_cpu_vm_instance` and `basestation_gpu_vm_instance`
export TF_VAR_basestation_enable_gpu=false

##
# Create the UGV VMs
#   - set to 'true' to create the VMs
#   - set to 'false' not create the VMs or to have the VMs destroyed
##
export TF_VAR_ugv1_create_vm=true
export TF_VAR_ugv2_create_vm=false
export TF_VAR_ugv3_create_vm=false

##
# Create the UAV VMs
#   - set to 'true' to create the VMs
#   - set to 'false' not create the VMs or to have the VMs destroyed
##
export TF_VAR_uav1_create_vm=true
export TF_VAR_uav2_create_vm=false
export TF_VAR_uav3_create_vm=false
export TF_VAR_uav4_create_vm=false

##
# Create the perception VMs
#   - set to 'true' to create the VMs
#   - set to 'false' not create the VMs or to have the VMs destroyed
##
export TF_VAR_perception1_create_vm=false

##
# VM disk sizes (in GB)
##
export TF_VAR_basestation_disk_size=100
export TF_VAR_ugv_disk_size=64
export TF_VAR_uav_disk_size=64
export TF_VAR_perception_disk_size=100

##
# VM instance types
# -- instance types can be found here: https://azure.microsoft.com/en-ca/pricing/details/virtual-machines/linux/
# -- to list SubT instance type limits (for East US region): az vm list-usage --location "East US" -o table
##
export TF_VAR_basestation_cpu_vm_instance="Standard_F8s_v2"
export TF_VAR_basestation_gpu_vm_instance="Standard_NC6"
export TF_VAR_ugv_vm_instance="Standard_F16s_v2"
export TF_VAR_uav_vm_instance="Standard_F16s_v2"
export TF_VAR_perception_vm_instance="Standard_NC6"

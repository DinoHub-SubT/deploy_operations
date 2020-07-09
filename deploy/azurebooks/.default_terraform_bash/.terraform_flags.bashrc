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
# Create the UGV VM's
##
export TF_VAR_ugv1_create_vm=true
export TF_VAR_ugv2_create_vm=false
export TF_VAR_ugv3_create_vm=false

##
# Create the UAV VM's
##
export TF_VAR_uav1_create_vm=true
export TF_VAR_uav2_create_vm=false
export TF_VAR_uav3_create_vm=false
export TF_VAR_uav4_create_vm=false

##
# Whether or not to create perception
##
export TF_VAR_perception1_create_vm=false
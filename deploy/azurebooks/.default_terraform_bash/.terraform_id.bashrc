##
# Various Identification Variables
# - When adding the string values, please remove the {} brackets in the below examples.
##
export TF_VAR_subscription_id=
export TF_VAR_tenant_id=
export TF_VAR_azure_username="{put your azure username here (what Kat gave you to login)}"
export TF_VAR_azure_resource_name_prefix="{Put your prefix here.. usually your andrew ID but doesn't have to be}"
# to get the 'TF_VAR_azure_vpn_cert', please run the following:
#   openssl x509 -in ~/.ssh/azure/vpn/caCert.pem -outform der | base64 -w0 ; echo
export TF_VAR_azure_vpn_cert="{Put vpn certificate here}"

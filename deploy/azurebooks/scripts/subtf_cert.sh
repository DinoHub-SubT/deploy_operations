#!/usr/bin/env bash
eval "$(cat $(dirname "${BASH_SOURCE[0]}")/header.sh)"
if chk_flag --help $@; then
    title "$(basename $0).sh [ flags ]: Creates the vpn ca and user certifcations for creating an Azure VPN connection."
    text "Flags:"
    text "    -c : Create new vpn root & client certificates."
    text "    -s : Show the contents of an existing vpn client certificate."
    exit 0
fi

# utils
newline() { echo -e "\n"; }
exit_success() { newline; exit 0; }
exit_failure() { exit 1; }
pushd () { command pushd "$@" > /dev/null; }
popd () { command popd "$@" > /dev/null; }

# //////////////////////////////////////////////////////////////////////////////
# Create the Root & User Certificates

title == Creating the VPN Root \& User Certificates ==

# vpn ca certs directory
vpn_cert_dir="$HOME/.ssh/azure/vpn"

# setup client username & password for user certificate
client_username="$TF_VAR_azure_username"
client_password="password"

if ! chk_flag -s $@; then

  # remove any previously created files
  if [ -d "$vpn_cert_dir" ]; then
    rm $vpn_cert_dir/caCert.pem
    rm $vpn_cert_dir/caKey.pem
    rm $vpn_cert_dir/${client_username}Cert.pem
    rm $vpn_cert_dir/${client_username}Key.pem
    rm $vpn_cert_dir/${client_username}.p12
  fi

  # create the vpn ca certs directory
  mkdir -p $vpn_cert_dir
  pushd $vpn_cert_dir

  ### Create the Root CA cert

  ipsec pki --gen --outform pem > caKey.pem
  if last_command_failed; then
    error failed to create caKey.pem. Please see readme and install "strongswan" correctly.
  fi

  ipsec pki --self --in caKey.pem --dn "CN=VPN CA" --ca --outform pem > caCert.pem
  if last_command_failed; then
    error failed to create caCert.pem. Please notify the maintainer.
  fi

  # creation done.
  text Created the root ca certificate.

  ### Create the user certificate

  # generate the user private key
  ipsec pki --gen --outform pem > "${client_username}Key.pem"
  if last_command_failed; then
    error failed to create user Key.pem. Please notify the maintainer.
  fi

  # generate the user public key
  ipsec pki --pub --in "${client_username}Key.pem" | ipsec pki \
    --issue \
    --cacert caCert.pem \
    --cakey caKey.pem \
    --dn "CN=${client_username}" \
    --san "${client_username}" \
    --flag clientAuth \
    --outform pem > "${client_username}Cert.pem"

  if last_command_failed; then
    error failed to create user Cert.pem. Please notify the maintainer.
  fi

  # generate the p12 bunder
  openssl pkcs12 \
    -in "${client_username}Cert.pem" \
    -inkey "${client_username}Key.pem" \
    -certfile caCert.pem \
    -export \
    -out "${client_username}.p12" \
    -password "pass:${client_password}"

  if last_command_failed; then
    error failed to create p12 bunder. Please notify the maintainer.
  fi

  # creation done.
  text Created the user certificate.

  popd
fi

# show the contents of vpn client certificate
if ! chk_flag -c $@; then
  if [ ! -f $vpn_cert_dir/caCert.pem ]; then
    error File does not exist. Please create the vpn client certificate, before showing contents.
    exit_failure
  fi

  pushd $vpn_cert_dir
  text Please copy the below output to the "'~/.terraform_id.bashrc'" setup file, for the variable "'TF_VAR_azure_vpn_cert'". \\n
  openssl x509 -in caCert.pem -outform der | base64 -w0 ; echo
  if last_command_failed; then
    error failed to show client vpn key. Please see readme and install "strongswan" correctly.
  fi

fi

# cleanup & exit
exit_success

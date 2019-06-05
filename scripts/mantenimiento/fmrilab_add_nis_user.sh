#!/bin/bash

# Last modification: June 26, 2012
# Luis Concha


print_help()
{
  echo "`basename $0` <login> <\"full Name\">"
}


if [ $# -lt 1 ] 
then
	echo " ERROR: Need more arguments..."
	print_help
	exit 1
fi


user_login=$1
user_name=$2



# Checar si soy sudo
if [ ! $(id -u) -eq 0 ]; then
	echo "Only sudo can do this"
	exit 2
fi

useradd -g fmriuser \
  --base-dir /home/inb \
  --create-home \
  --comment "$user_name" \
  --shell /bin/bash \
  $user_login
passwd $user_login

# quitar el shadowing, que no se lleva bien con el NIS
pwunconv
grpunconv

# Poner archivos vacios para gshadow y shadow, para que el chroot de fslview no se queje
touch /etc/shadow
touch /etc/gshadow


# Actualizar el NIS
make -C /var/yp


# Activar la configuracion del laboratorio
echo "source \$FMRILAB_CONFIGFILE" >> /home/inb/${user_login}/.bashrc


echo "Finished creating user $user_login and updated NIS"

#Incluir al usuario en cluster (funciona solo en talairach)
#qconf -au $user_login arusers
#qconf -au $user_login users


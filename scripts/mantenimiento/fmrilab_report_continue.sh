#!/bin/bash
Errors=""
# Usar directorio como lock de doble ejecución, es mejor por que es una selección atómica.
if ! mkdir /datos/talairach/continuecheck.lock 2>/dev/null
	then 
		antiguedad=$(( $(date +%s) - $(stat -c %Y /datos/talairach/continuecheck.lock)));
                if (($antiguedad > 3600))
		then
#		echo "Existe un script en ejecución por mas de una hora"
		Errors="$Errors Existe un script en funcion hace (( $antiguedad/60)) minutos "
		/home/inb/soporte/fmrilab-scripts/mantenimiento/./fmrilab_aviso_correo.sh -c nekrum@gmail.com -m "$Errors" -e "[Reporte continuo por mas de una hora]"
		exit 1
		fi
#		echo "Existe un script  en ejecución recientemente"
		exit 1 
fi
# echo "Ejecutando...."
trap "rmdir /datos/talairach/continuecheck.lock ; exit" SIGHUP SIGINT SIGTERM

for i in  $(awk  '{print $1}' /home/inb/cluster/configuracion/hosts) ; do 
########## Checa si la conexión es adecuada  
#	echo "Haciendo ping a $i "	
	ping -c 2 -q $i	2>&1 >/dev/null
	if [  $? -ne 0 ];then  Errors="$Errors No se encontro $i,"; 
#		echo "No se encontro $i" 
        	continue
	fi
########## Probar cada directorio 
	for h in $(ssh $i "find  /datos/*/ -maxdepth 0 -type d"); do
		if [[ $i == "fourier" && $(echo $h | grep "/datos/fourier2") ]] || [[ $(echo $h | grep  "/datos/lost+found/") || $(echo $h | awk -F/ '{print $3}') == $i ]]; then continue; fi
		mPoint=$h
############### Es necesario que el usuario tenga garantizado el acceso ssh sin contraseña (soporte lo tiene)
#		echo "Comprobando punto de montaje $mPoint en $i"
		fSystem=`ssh $i stat -f -L -c %T $mPoint`
		if [[ ! "$fSystem" == "nfs" ]]; then 
		Errors="$Errors $i $mPoint,"  
#		echo "$mPoint no esta montado en $i"
		 fi
	done 
########## Probamos /home/inb, cuando no es talairach talairach
	if [[ ! $i == "talairach" ]]
		then
		mPoint=/home/inb
############### Necesita acceso ssh sin contraseña
#		echo "Comprobando home en $i "
		fSystem=`ssh $i stat -f -L -c %T $mPoint`
		if [[ ! "$fSystem" == "nfs" ]]
		then
		Errors="$Errors $i $mPoint," 
#		echo "Error en el montado de home en $i"
		fi
        else
        	 if [[ $(qstat -u "*"   | grep Eqw | wc -l) > 0 ]]; then Errors="$Errors Trabajos con errores en el cluster" ;  fi
	fi
done
########## And spit out some results
if [ ! -z "$Errors" ]
	then
#	echo "THERE ARE MOUNTING ERRORS:"
#	echo "$Errors"
	if [ ! -f /datos/talairach/notificacion  ]
		then
#			echo "creando archivo persistente de notificacion"
			touch /datos/talairach/notificacion
			/home/inb/soporte/fmrilab-scripts/mantenimiento/./fmrilab_aviso_correo.sh -c nekrum@gmail.com -m "$Errors" -e "[Errores en el Cluster]"
		else
			antiguedad=$(( $(date +%s) - $(stat -c %Y /datos/talairach/notificacion))); 
			if (($antiguedad > 3600))
				then 
					
					/home/inb/soporte/fmrilab-scripts/mantenimiento/./fmrilab_aviso_correo.sh -c nekrum@gmail.com -m "$Errors" -e "[Errores en el Cluster]"
#					echo "Borrando de archivo persistente de notificacion "
					rm /datos/talairach/notificacion
#					echo "Creando nuevo archivo persistente"
					touch /datos/talairach/notificacion
#				else 
#				echo "Chequeo reciente realizado no se envia notificacion"
 			fi 
	fi
else

	if [  -f /datos/talairach/notificacion ]
	then 
	rm /datos/talairach/notificacion
	fi
	  
fi
rmdir /datos/talairach/continuecheck.lock


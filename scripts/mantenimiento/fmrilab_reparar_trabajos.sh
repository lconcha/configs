#!/bin/bash
Errors=""
traberr=$(qstat -u '*' | awk '/Eqw/ {print $1}')
for i in $traberr 
do 
	razon=$(qstat -j $i | grep "error reason")
	if ( echo $razon | grep "error: can't chdir to" );then
	Errors="$Errors, The $i job, can not change directory, possible permission conflict "
        [ equipo, usuario ]=$(awk -F/  '{ print $3, print $4} '$razon )
	ssh $equipo sudo chmod -R g+wr /datos/$equipo/$usuario
	else
	Errors=$(qstat -j $i | grep "error reason")
	fi
	qdel $i
	qresub $i
done


/home/inb/soporte/fmrilab-scripts/mantenimiento/./fmrilab_aviso_correo.sh -c nekrum@gmail.com -m "$Errors" -e "[Errores en el Cluster]"

	
	
	

1. Instalar físicamente disco mediante SATA

2. Entrar como `soporte` y abrir aplicación Disks.
⋅⋅2. Crear la partición del disco, si es necesario.
⋅⋅2. Copiar el UUID de la partición.

3. Editar `/etc/fstab` y agregar mediante la UUID el disco, apuntando hacia `/datos/HOSTNAME?` donde `?` es el número de disco que estamos poniendo.

4. Montar el disco
⋅⋅4. mount /datos/HOSTNAME?

5. Arreglar permisos.
⋅⋅5. `chgrp fmriuser /datos/HOSTNAME?`
⋅⋅5. `chmod g+rwX /datos/HOSTNAME?`
⋅⋅5. `chown soporte /datos/HOSTNAME?`

6. Exportar el disco editando `/etc/exports`

7. Reiniciar servidor NFS en HOST
⋅⋅7. `service nfs-kernel-server restart`

8. Editar el archivo maestro de fmrilab_auto.misc y agregar la nueva línea.

9. En el resto de las máquinas ejecutar como root `./fmrilab_fix_misc.sh`

10. En sesamo agregar nuevo destino de backups. 
⋅⋅10. Entrar como `admin` a `sesamo` e ir a carpeta `/volume1/fmrilab/backup`.
⋅⋅10. Editar archivo `listOfDestinations=/volume1/fmrilab/backup/datos_backup_locations.txt`

---


---

<p>1 de agosto de 2018<br>
lconcha<br>
Disponible en:<br>
<a href="https://github.com/lconcha/configs/blob/master/client_18-04.md">https://github.com/lconcha/configs/blob/master/client_18-04.md</a></p>
<h1 id="instalación">Instalación</h1>
<p>Iniciamos con una PC con dos discos duros, uno chico (120GB) y uno grande (&gt;750GB). En este caso el chico es <code>sdb</code> y el grande es <code>sda</code>. Se instala ubuntu desktop 18.04 (full instalation, no minimal, y se dan permisos para third-party codecs). La instalación y el sistema operativo se hacen en inglés.</p>
<h2 id="particiones">Particiones</h2>
<p>Cuando pregunta dónde instalar ubuntu, le decimos “something else” y ajustamos nuestras particiones de acuerdo a:</p>
<pre><code>/dev/sdb1	efi				536MB
/dev/sdb2	ext4	/		40GB (esta particion siempre asi)
/dev/sdb3 	ext4	/tmp	75GB (esta puede cambiar, ser mas grande; es lo que sobre del disco)
/dev/sdb4   swap			15GB (esta siempre asi)
/dev/sda1	ext4	/datos	750GB
</code></pre>
<p>El bootloader queda en <code>sdb</code> (o equivalente en cada máquina) porque es el SSD en este caso…</p>
<p>La particion en   <code>/tmp</code> debe ser suficientemente grande, digamos 75GB. Si no, ponerla en el otro disco. Esta partición es importante porque muchos trabajos del tipo de <span class="katex--inline"><span class="katex"><span class="katex-mathml"><math><semantics><mrow><mi>f</mi><mi>s</mi><mi>l</mi></mrow><annotation encoding="application/x-tex">fsl</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="strut" style="height: 0.69444em;"></span><span class="strut bottom" style="height: 0.88888em; vertical-align: -0.19444em;"></span><span class="base"><span class="mord mathit" style="margin-right: 0.10764em;">f</span><span class="mord mathit">s</span><span class="mord mathit" style="margin-right: 0.01968em;">l</span></span></span></span></span> y <span class="katex--inline"><span class="katex"><span class="katex-mathml"><math><semantics><mrow><mi>m</mi><mi>r</mi><mi>t</mi><mi>r</mi><mi>i</mi><mi>x</mi></mrow><annotation encoding="application/x-tex">mrtrix</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="strut" style="height: 0.65952em;"></span><span class="strut bottom" style="height: 0.65952em; vertical-align: 0em;"></span><span class="base"><span class="mord mathit">m</span><span class="mord mathit" style="margin-right: 0.02778em;">r</span><span class="mord mathit">t</span><span class="mord mathit" style="margin-right: 0.02778em;">r</span><span class="mord mathit">i</span><span class="mord mathit">x</span></span></span></span></span> ocupan muchos datos temporales que quedan en <code>/tmp</code> y,  si son muchos, puede llenar completamente el disco duro si la partición <code>/</code>y <code>/tmp</code> comparten la misma unidad física.</p>
<p>El nombre del primer usuario es <code>soporte_$hostname</code> y el password sigue la nomenclatura conocida. En caso de que solo contemos con un disco duro, entonces debe haber particiones distintas para <code>/</code> <strong>(40GB siempre)</strong>, <code>/tmp</code>, <code>/datos</code>(si es necesario) y swap.</p>
<p>El nombre del primer usuario es <code>soporte_$hostname</code> y el password sigue la nomenclatura conocida.</p>
<h2 id="root">root</h2>
<p>Habilitamos la cuenta de root porque si no vamos a tener problemas de UID con el usuario lconcha que vive en el servidor (el default del primer usuario es UID=1000, y lconcha en el servidor es también 1000). Con el usuario root vamos a poder instalar todo. Esto será particularmente útil justo antes de instalar el NIS. <strong>El password de root deberá ser el mismo que el que usemos para soporte_HOSTNAME.</strong></p>
<pre><code>sudo passwd root
sudo passwd -u root
</code></pre>
<h1 id="red">Red</h1>
<p>Ir a <code>settings</code>, después a <code>network</code> y en <code>wired</code> dar al ícono de configuración. En la pestaña <code>IPv4</code>. Cambiamos a manual.</p>
<p>Address: 172.24.<em>.</em> (según computadora)<br>
Netmask: 255.255.255.224<br>
Gateway: 172.24.80.126 (cambia en cada laboratorio)<br>
Cambiar el DNS de Automatic a OFF y escribir los nuestros:<br>
DNS: 132.248.10.2,132.248.204.1,208.67.222.222</p>
<p>Poner <code>apply</code> y luego apagar y prender el ethernet device.<br>
<code>ip address</code> nos debería indicar bien nuestra dirección IP</p>
<h1 id="driver-tarjeta-de-video">Driver tarjeta de video</h1>
<p>Casi todas las computadoras tienen tarjeta Nvidia, pero también puede ser AMD/ATI o Intel. Para saber cuál es, podemos abrir la PC y ver la tarjeta, o desde una terminal:</p>
<pre><code>lspci | grep VGA
</code></pre>
<p>Si regresa algo como <code>VGA compatible controller: NVIDIA Corporation</code>, entonces sí tenemos una Nvidia.</p>
<p>Si regresa algo como <code>VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI]</code>,  en ese caso no se debe seguir este paso. Me falta saber cómo instalar la aceleración de AMD.</p>
<p>La configuración para Nvidia (y supongo que para ATI también) es gráfica. Se agregan los <strong>drivers de la <em>tarjeta de video</em></strong> a través de la interface gráfica que se consigue presionando la tecla Meta (la del ícono del Windows), y escribir <code>software</code> , abrimos el programa y vamos a la pestaña <code>additional drivers</code> Seleccionamos el correspondiente a la tarjeta de video (Algo así como <code>Nvidia binary driver (proprietary), versión 390</code>, o el número más alto que aparezca. No utilizar el driver <code>nouveau</code>. No lo sé aún, pero supongo que para ATI ha de ser igual.</p>
<h1 id="reboot">Reboot</h1>
<p>Una vez que reinicie la máquina, nos saludará la interface gráfica llamada <code>gdm</code>, donde podemos escribir nuestro nombre de usuario. Para fines de configuración, no la vamos a utilizar, porque vamos a hacer login de texto con el usuario <code>root</code>. Para ello:<br>
<strong>presionamos simultáneamente <code>Ctrl+Alt+F3</code> y hacemos login como root</strong>.</p>
<h1 id="hosts">Hosts</h1>
<p>Tengo un script que ayuda a configurar los hosts.<br>
De aquí en adelante se asume que <strong>hicimos login (de texto) como root.</strong></p>
<pre><code>scp -r soporte@172.24.80.102:/home/inb/soporte/configs .
cd configs
./fmrilab_fix_hosts_file.sh
</code></pre>
<p>Probamos con un <code>ping tesla</code>, que nos debe funcionar.</p>
<p><strong>Nota:</strong> La carpeta <code>configs</code> tiene varios scripts que vamos ir usando a lo largo de esta instalación.</p>
<h1 id="verbose-boot">verbose boot</h1>
<p>Para facilitar detección de errores, hagamos que el boot sea feo pero informativo</p>
<pre><code>nano /etc/default/grub
</code></pre>
<p>modificamos la línea que contiene <code>GRUB_CMDLINE_LINUX_DEFAULT</code> a que lea:<br>
<code>GRUB_CMDLINE_LINUX_DEFAULT=""</code></p>
<p>Y hacemos update a grub</p>
<pre><code>update-grub
</code></pre>
<h1 id="nfs-y-autofs">NFS y autofs</h1>
<p>Para que más adelante veamos <code>/home/inb</code>es importante que primero pongamos el NFS. <em>Antes poníamos <code>/home/inb</code> a través del fstab, pero resulta en muchos problemas de timeout que se van si utilizamos los homes a través de autofs</em></p>
<p>Corremos un script para ello:</p>
<pre><code>./fmrilab_fix_misc.sh
</code></pre>
<p><strong>Ojo</strong> El script también instalará <code>cachefilesd</code> para agilizar (en teoría) el acceso de los homes montados mediante nfs. Para ello, la ruta montada indicada en<code>auto.home</code> tiene 	 la opción <code>fsc</code>.</p>
<h1 id="nis">NIS</h1>
<p>Y para evitar problemas próximos, agregamos a <code>soporte</code> como sudoer</p>
<pre><code>visudo
</code></pre>
<p>agregar:</p>
<pre><code>soporte ALL=(ALL:ALL) ALL
</code></pre>
<p>Corremos el script</p>
<pre><code>./fmrilab_config_nis.sh
</code></pre>
<p>Preguntará por un dominio, el cual es <code>fmrilab</code></p>
<p><strong>OJO</strong> El password de <code>soporte</code>, al ser designado por el NIS, es el mismo de siempre.</p>
<p><strong>OJO2</strong> El script <code>fmrilab_config_nis.sh</code> contiene un paso muy interesante (latoso de encontrar solución) que elimina un problema de incompatibilidad entre <code>systemd.login</code> y <code>NIS</code>.  Para leer al respecto, vale la pena checar <a href="https://wiki.archlinux.org/index.php/NIS#.2Fetc.2Fpam.d.2Fpasswd">este link</a>, y la versión <em>ubuntizada</em> en <a href="https://askubuntu.com/questions/1031022/using-nis-client-in-ubuntu-18-04-crashes-both-gnome-and-unity">este otro link</a>.</p>
<p><strong>Ojo3:</strong> Dado que <code>/home</code> de la máquina ha sido <em>cubierto</em> por <code>/home</code> indicado por <code>autofs</code>, el HOME del primer usuario de la máquina se va a desaparecer (no borrar, pero inaccesible porque hay una capa de autofs sobre /home).  Además, el UID del primero usuario normalmente es 1000, que colisiona con el UID del usuario <code>lconcha</code>en el servidor NIS, por lo que si alguna vez de usa el usuario soporte_HOSTNAME, es posible que pida el password de lconcha, lo cual está mal. Para evitar problemas, el script de arriba va a cambiar el home del primer usuario a una carpeta adentro de <code>/localhome</code>  , y va a cambiar el UID del primer usuario (soporte_HOSTNAME) a 5000. Podemos asegurarnos que este paso corrió, utilizando <code>id soporte_HOSTNAME</code>, y veremos que UID=5000.</p>
<h1 id="nfs">NFS</h1>
<p><strong>Este paso no puede ser automatizado</strong> porque depende de cuántos discos duros tiene la máquina.</p>
<p>Instalamos lo necesario</p>
<pre><code>apt install nfs-kernel-server
</code></pre>
<p>Editamos <code>/etc/exports</code> y agregamos</p>
<pre><code>/datos/NEWHOSTNAME @fmrilab_hosts(rw,no_subtree_check,sync)
</code></pre>
<p>Si tenemos más discos duros que exportar, serán <code>/datos/NEWHOSTNAME2</code>, <code>/datos/NEWHOSTNAME3</code>, etc, y cada uno de ellos debe estar en <code>/etc/exports</code>, cada uno como una línea, con las mismas opciones a partir de @fmrilab_hosts…</p>
<p>Donde <code>NEWHOSTNAME</code>es el nombre que le hemos dado a este cliente.</p>
<p>Y reiniciamos el servidor NFS</p>
<pre><code>/etc/init.d/nfs-kernel-server restart
</code></pre>
<h1 id="configurar-software">Configurar software</h1>
<p>El software está centralizado. Algunas librerías y dependencias cambiaron entre ubuntu 14.04 y 18.04. Para arreglarlo, corremos el script</p>
<pre><code>./fmrilab_softwareconfig.sh
</code></pre>
<p>Esto instala también varios programas que queremos que estén en la propia máquina (no centralizados, como fsl, mrtrix o freesurfer), por ejemplo: rstudio, google-chrome, chromium-browser, x2go, sshfs, inkscape, keepass, htop, tree, curl. Además se aprovecha para instalar (en un solo paso), los programas que se requieren para que mrtrix, fsl y freesurfer corran bien (tcsh, libmng, libgtkglext1, etc).</p>
<h1 id="reboot-1">reboot</h1>
<p>Antes de hacerlo, es buen momento para un</p>
<pre><code>apt update
apt upgrade
</code></pre>
<h1 id="sge">SGE</h1>
<p>Todas las computadoras, excepto <code>tesla</code>, son nodos <code>submit</code> y <code>exec</code> dentro del cluster <code>fmrilab</code>. Configuremos una nueva computadora así. Para configurarla, hay que hacer ciertos pasos en la nueva computadora, a la que llamaremos <code>NEWHOST</code> (nombres comunes en el laboratorio son purcell, ernst, rhesus, arwen, etc. El servidor es <code>tesla</code>.</p>
<h2 id="login-en-newhost">Login en <code>NEWHOST</code></h2>
<p>Primero, hacemos login como <code>root</code> para instalar lo necesario en <code>NEWHOST</code></p>
<pre><code>apt install gridengine-exec gridengine-client
</code></pre>
<p>Este comando nos preguntará el <code>CELL name</code>, y ahí pondremos <code>fmrilab</code></p>
<h2 id="login-en-tesla">Login en <code>tesla</code></h2>
<p>Ahora hacemos login somo <code>soporte</code> en <code>tesla</code> para agregar el nodo como exec y submit.</p>
<pre><code>qconf -mq all.q
</code></pre>
<p>Esto abrirá un editor de texto con la configuración de la cola <code>all.q</code>. Agregar el host (<code>NEWHOST</code>, usando el nombre que le dimos) a la lista de hosts. (si el editor es vi, recuerda que presionar <code>i</code> nos permitirá editar, y para salir y grabar presionamos <code>ESC</code> y escribimos: <code>wq</code>).</p>
<p>Agregamos el NEWHOST al grupo de hosts</p>
<pre><code>qconf -mhgrp @allhosts
</code></pre>
<p>Agregamos NEWHOST como submit host</p>
<pre><code>qconf -as NEWHOSTNAME
</code></pre>
<p>Agregamos NEWHOST como exec host</p>
<pre><code>qconf -ae NEWHOSTNAME
</code></pre>
<p>Es opcional, pero a mí me gusta cambiar el número máximo de slots para correr jobs de cada nuevo exec host. En general, la fórmula para número de slots es <code>nslots = nprocesadores - 1</code>. Para saber cuántos procesadores tenemos, podemos usar <code>nproc</code>.</p>
<pre><code>qconf -aattr queue slots “[NEWHOSTNAME.inb.unam.mx=7]" all.q
</code></pre>
<h2 id="login-en-newhost-1">Login en <code>NEWHOST</code></h2>
<p>reconfigurar SGE para que ya lo reconozca el servidor.</p>
<pre><code>sudo dpkg-reconfigure gridengine-exec
</code></pre>
<p>Ya debería ser posible ver el nuevo host usando</p>
<pre><code>qstat -f
</code></pre>
<p>Si no está bien configurado, aparecerá el NEWHOST como <code>N/A</code>.</p>
<p>Probamos el cluster enviando un trabajo muy sencillo:</p>
<pre><code>fsl_sub -N prueba hostname
</code></pre>
<p>Nos debe regresar en la terminal un número, que es nuestro <em>ticket</em> en la cola del cluster.  Si hacemos <code>qstat</code> lo veremos en la lista. Cuando desaparece, es que corrió. Si no vemos output de <code>qstat</code>, algo anda mal.</p>
<p>Al final, debe haber dos archivos nuevo llamado <code>prueba.o?????</code> y <code>prueba.e?????</code>. Los <code>?</code> indican números y son iguales al ticket que recibimos. Si hacemos <code>cat prueba.o?????</code> veremos el nombre del host donde corrió nuestra prueba, indicando que todo está bien.</p>


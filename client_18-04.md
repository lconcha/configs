---


---

<p>Julio 16, 2018, lconcha</p>
<h1 id="instalación">Instalación</h1>
<p>Iniciamos con una PC con dos discos duros, uno chico (120GB) y uno grande (&gt;750GB). En este caso el chico es <code>sdb</code> y el grande es <code>sda</code>. Se instala ubuntu desktop 18.04 (full instalation, no minimal, y se dan permisos para third-party codecs). La instalación y el sistema operativo se hacen en inglés.</p>
<h2 id="particiones">Particiones</h2>
<p>Cuando pregunta dónde instalar ubuntu, le decimos “something else” y ajustamos nuestras particiones de acuerdo a:</p>
<pre><code>/dev/sdb1	efi				536MB
/dev/sdb2	ext4	/		60GB (esta particion siempre asi)
/dev/sdb3 	ext4	/tmp	75GB (esta puede cambiar, ser mas grande)
/dev/sdb4   swap			25GB (esta siempre asi)
/dev/sda1	ext4	/datos	750GB
</code></pre>
<p>El bootloader queda en <code>sdb</code> (o equivalente en cada máquina) porque es el SSD en este caso…</p>
<p>La particion en   <code>tmp</code> debe ser suficientemente grande, digamos 75GB. Si no, ponerla en el otro disco. Esta partición es importante porque muchos trabajos del tipo de <span class="katex--inline"><span class="katex"><span class="katex-mathml"><math><semantics><mrow><mi>f</mi><mi>s</mi><mi>l</mi></mrow><annotation encoding="application/x-tex">fsl</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="strut" style="height: 0.69444em;"></span><span class="strut bottom" style="height: 0.88888em; vertical-align: -0.19444em;"></span><span class="base"><span class="mord mathit" style="margin-right: 0.10764em;">f</span><span class="mord mathit">s</span><span class="mord mathit" style="margin-right: 0.01968em;">l</span></span></span></span></span> y <span class="katex--inline"><span class="katex"><span class="katex-mathml"><math><semantics><mrow><mi>m</mi><mi>r</mi><mi>t</mi><mi>r</mi><mi>i</mi><mi>x</mi></mrow><annotation encoding="application/x-tex">mrtrix</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="strut" style="height: 0.65952em;"></span><span class="strut bottom" style="height: 0.65952em; vertical-align: 0em;"></span><span class="base"><span class="mord mathit">m</span><span class="mord mathit" style="margin-right: 0.02778em;">r</span><span class="mord mathit">t</span><span class="mord mathit" style="margin-right: 0.02778em;">r</span><span class="mord mathit">i</span><span class="mord mathit">x</span></span></span></span></span> ocupan muchos datos temporales que quedan en <code>/tmp</code> y,  si son muchos, puede llenar completamente el disco duro si la partición <code>/</code>y <code>/tmp</code> comparten la misma unidad física.</p>
<p>El nombre del primer usuario es <code>soporte_$hostname</code> y el password sigue la nomenclatura conocida.n caso de que solo contemos con un disco duro, entonces debe haber particiones distintas para <code>/</code> (60GB siempre), <code>/tmp</code>, <code>/datos</code>(si es necesario) y swap.</p>
<p>El nombre del primer usuario es <code>soporte_$hostname</code> y el password sigue la nomenclatura conocida.</p>
<p>Es útil en este momento configurar los <strong>drivers de la <em>tarjeta de video</em></strong> a través de la interface gráfica que se consigue mediante <code>software</code> , <code>additional drivers</code></p>
<h2 id="root">root</h2>
<p>Habilitamos la cuenta de root porque si no vamos a tener problemas de UID con el usuario lconcha que vive en el servidor (el default del primer usuario es UID=1000, y lconcha en el servidor es también 1000). Con el usuario root vamos a poder instalar todo. Esto será particularmente útil justo antes de instalar el NIS.</p>
<blockquote>
<p>sudo passwd root<br>
sudo passwd -u root</p>
</blockquote>
<h1 id="red">Red</h1>
<p>Ir a <code>settings</code>, después a <code>network</code> y en <code>wired</code> dar al ícono de configuración. En la pestaña <code>IPv4</code>. Cambiamos a manual.</p>
<pre><code>	Address: 172.24.*.* (según computadora)
	Netmask: 255.255.255.224
	Gateway: 172.24.80.126 (cambia en cada laboratorio)
</code></pre>
<p>Cambiar el DNS de Automatic a OFF y escribir los nuestros:</p>
<pre><code>	DNS: 132.248.10.2,132.248.204.1,208.67.222.222	
</code></pre>
<p>Poner <code>apply</code> y luego apagar y prender el ethernet device.<br>
<code>ip address</code> nos debería indicar bien nuestra dirección IP</p>
<h2 id="hosts">hosts</h2>
<p>Tengo un script que ayuda a configurar los hosts.<br>
De aquí en adelante hay que <strong>convertirnos en root.</strong></p>
<blockquote>
<p>su<br>
cd<br>
scp -r <a href="mailto:soporte@172.28.80.102">soporte@172.28.80.102</a>:/home/inb/soporte/configs .<br>
cd configs<br>
./fmrilab_fix_hosts_file.sh</p>
</blockquote>
<p>Probamos con un <code>ping tesla</code>, que nos debe funcionar.</p>
<p><strong>Nota:</strong> La carpeta <code>configs</code> tiene varios scripts que vamos ir usando a lo largo de esta instalación.</p>
<h1 id="verbose-boot">verbose boot</h1>
<p>Para facilitar detección de errores, hagamos que el boot sea feo pero informativo</p>
<blockquote>
<p>nano /etc/default/grub</p>
</blockquote>
<p>modificamos la línea que contiene <code>GRUB_CMDLINE_LINUX_DEFAULT</code> a que lea:</p>
<blockquote>
<p>GRUB_CMDLINE_LINUX_DEFAULT=""</p>
</blockquote>
<p>Y hacemos update a grub</p>
<blockquote>
<p>update-grub</p>
</blockquote>
<h1 id="nfs-y-autofs">NFS y autofs</h1>
<p>Para que más adelante veamos <code>/home/inb</code>es importante que primero pongamos el NFS. <em>Antes poníamos <code>/home/inb</code> a través del fstab, pero resulta en muchos problemas de timeout que se van si utilizamos los homes a través de autofs</em></p>
<p>Corremos un script para ello:</p>
<blockquote>
<p>./fmrilab_fix_misc.sh</p>
</blockquote>
<p><strong>Ojo:</strong> Dado que /home de la máquina va a ser cubierto por /home indicado por autofs, el HOME del primer usuario de la máquina se va a desaparecer (no borrar, pero inaccesible porque hay una capa de autofs sobre /home). Para evitar problemas, el script de arriba va a cambiar el home del primer usuario a una carpeta adentro de <code>/localhome</code></p>
<p><strong>Ojo2</strong> El script también instalará <code>cachefilesd</code> para agilizar (en teoría) el acceso de los homes montados mediante nfs. Para ello, la ruta montada indicada en<code>auto.home</code> tiene 	 la opción <code>fsc</code>.</p>
<h1 id="nis">NIS</h1>
<p>Y para evitar problemas próximos, agregamos a <code>soporte</code> como sudoer</p>
<blockquote>
<p>visudo</p>
</blockquote>
<p>agregar:</p>
<blockquote>
<p>soporte ALL=(ALL:ALL) ALL</p>
</blockquote>
<p>Corremos el script</p>
<blockquote>
<p>./fmrilab_config_nis.sh</p>
</blockquote>
<p>Preguntará por un dominio, el cual es <code>fmrilab</code></p>
<p><strong>OJO</strong> El password de <code>soporte</code>, al ser designado por el NIS, es el mismo de siempre.</p>
<p><strong>OJO2</strong> El script <code>fmrilab_config_nis.sh</code> contiene un paso muy interesante (latoso de encontrar solución) que elimina un problema de incompatibilidad entre <code>systemd.login</code> y <code>NIS</code>.  Para leer al respecto, vale la pena checar <a href="https://wiki.archlinux.org/index.php/NIS#.2Fetc.2Fpam.d.2Fpasswd">este link</a>, y la versión <em>ubuntizada</em> en <a href="https://askubuntu.com/questions/1031022/using-nis-client-in-ubuntu-18-04-crashes-both-gnome-and-unity">este otro link</a>.</p>
<h1 id="nfs">NFS</h1>
<p>Instalamos lo necesario</p>
<blockquote>
<p>apt install nfs-kernel-server</p>
</blockquote>
<p>Editamos <code>/etc/exports</code> y agregamos</p>
<blockquote>
<p>/datos/NEWHOSTNAME @fmrilab_hosts(rw,no_subtree_check,sync)</p>
</blockquote>
<p>Donde <code>NEWHOSTNAME</code>es el nombre que le hemos dado a este cliente.</p>
<p>Y reiniciamos el servidor NFS</p>
<blockquote>
<p>/etc/init.d/nfs-kernel-server restart</p>
</blockquote>
<h1 id="nvidia-driver">Nvidia driver</h1>
<p>Idealmente se debe poner el driver mediante la interface gráfica desde el inicio de la instalación de ubuntu, pero si se nos olvidó, se puede ahora.</p>
<blockquote>
<p>sudo ubuntu-driver devices</p>
</blockquote>
<p>Revisasr cuál es el driver que podemos usar, y nos dice qué paquete pasar a <code>apt</code>, por ejemplo:</p>
<blockquote>
<p>apt install nvidia-driver-390</p>
</blockquote>
<h1 id="configurar-software">Configurar software</h1>
<p>El software está centralizado. Algunas librerías y dependencias cambiaron entre ubuntu 14.04 y 18.04. Para arreglarlo, corremos el script</p>
<blockquote>
<p>./fmrilab_softwareconfig.sh</p>
</blockquote>
<h1 id="reboot">reboot</h1>
<p>Antes de hacerlo, es buen momento para un</p>
<blockquote>
<p>apt update<br>
apt upgrade</p>
</blockquote>


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
<p>La particion en   <code>tmp</code> debe ser suficientemente grande, digamos 75GB. Si no, ponerla en el otro disco. Esta partición es importante porque muchos trabajos del tipo de <span class="katex--inline"><span class="katex"><span class="katex-mathml"><math><semantics><mrow><mi>f</mi><mi>s</mi><mi>l</mi></mrow><annotation encoding="application/x-tex">fsl</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="strut" style="height: 0.69444em;"></span><span class="strut bottom" style="height: 0.88888em; vertical-align: -0.19444em;"></span><span class="base"><span style="margin-right: 0.10764em;" class="mord mathit">f</span><span class="mord mathit">s</span><span style="margin-right: 0.01968em;" class="mord mathit">l</span></span></span></span></span> y <span class="katex--inline"><span class="katex"><span class="katex-mathml"><math><semantics><mrow><mi>m</mi><mi>r</mi><mi>t</mi><mi>r</mi><mi>i</mi><mi>x</mi></mrow><annotation encoding="application/x-tex">mrtrix</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="strut" style="height: 0.65952em;"></span><span class="strut bottom" style="height: 0.65952em; vertical-align: 0em;"></span><span class="base"><span class="mord mathit">m</span><span style="margin-right: 0.02778em;" class="mord mathit">r</span><span class="mord mathit">t</span><span style="margin-right: 0.02778em;" class="mord mathit">r</span><span class="mord mathit">i</span><span class="mord mathit">x</span></span></span></span></span> ocupan muchos datos temporales que quedan en <code>/tmp</code> y,  si son muchos, puede llenar completamente el disco duro si la partición <code>/</code>y <code>/tmp</code> comparten la misma unidad física.</p>
<p>En caso de que solo contemos con un disco duro, entonces debe haber particiones distintas para <code>/</code> (60GB siempre), <code>/tmp</code>, <code>/datos</code>(si es necesario) y swap.</p>
<p>El nombre del primer usuario es <code>soporte_$hostname</code> y el password sigue la nomenclatura conocida.</p>
<h1 id="red">Red</h1>
<p>Ir a <code>settings</code>, después a <code>network</code> y en <code>wired</code> dar al ícono de configuración. En la pestaña <code>IPv4</code>. Cambiamos a manual.</p>
<pre><code>	Address: 172.24.*.* (según computadora)
	Netmask: 255.255.255.224
	Gateway: 172.24.80.126 (cambia en cada laboratorio)
</code></pre>
<p>Cambiar el DNS de Automatic a OFF y escribir los nuestros:</p>
<pre><code>	DNS: 132....,208.67.22...	
</code></pre>
<p>Poner <code>apply</code> y luego apagar y prender el ethernet device.<br>
<code>ip address</code> nos debería indicar bien nuestra dirección IP</p>
<h2 id="hosts">hosts</h2>
<p>Tengo un script que ayuda a configurar los hosts.</p>
<blockquote>
<p>cd<br>
scp -r <a href="mailto:soporte@172.28.80.102">soporte@172.28.80.102</a>:/home/inb/soporte/configs .<br>
cd configs<br>
./fmrilab_fix_hosts_file.sh</p>
</blockquote>
<p>Probamos con un <code>ping tesla</code>, que nos debe funcionar.</p>
<p><strong>Nota:</strong> La carpeta <code>configs</code> tiene varios scripts que vamos ir usando a lo largo de esta instalación.</p>
<h1 id="autofs">autofs</h1>
<p>Normalmente haríamos un <code>apt install autofs</code>y luego configuraríamos <code>/etc/auto.master</code>y <code>/etc/auto.misc</code> pero mejor corremos un script para ello:</p>
<blockquote>
<p>./fmrilab_fix_misc.sh</p>
</blockquote>
<p>Como todavía no existe el nis, esto todavía no funciona, pero es normal.</p>
<h1 id="nfs">NFS</h1>
<p>Para que más adelante veamos <code>/home/inb</code>es importante que primero pongamos el NFS y arreglemos <code>fstab</code></p>
<blockquote>
<p>sudo apt-get install rpcbind nfs-common<br>
sudo su<br>
fmrilab_fix_fstab.sh<br>
exit<br>
sudo mount -av</p>
</blockquote>
<h1 id="nis">NIS</h1>
<p>Primero instalar lo necesario</p>
<blockquote>
<p>sudo apt install nis portmap<br>
Preguntará por un dominio, el cual es <code>fmrilab</code><br>
Ahora, con los scripts que hemos copiado a la carpeta <code>configs</code><br>
sudo su<br>
./fmrilab_config_nis.sh</p>
</blockquote>
<p>Y para evitar problemas próximos, agregamos a <code>soporte</code> como sudoer</p>
<blockquote>
<p>sudo visudo</p>
</blockquote>
<p>agregar:</p>
<blockquote>
<p>soporte ALL=(ALL:ALL) ALL</p>
</blockquote>
<h1 id="nfs-1">NFS</h1>
<p>Instalamos lo necesario</p>
<blockquote>
<p>sudo apt install nfs-kernel-server</p>
</blockquote>
<p>Editamos <code>/etc/exports</code> y agregamos</p>
<blockquote>
<p>/datos/NEWHOSTNAME @fmrilab_hosts(rw,no_subtree_check,sync)</p>
</blockquote>
<p>Donde <code>NEWHOSTNAME</code>es el nombre que le hemos dado a este cliente.</p>
<p>Y reiniciamos el servidor NFS</p>
<blockquote>
<p>sudo service nfs-kernel-server restart</p>
</blockquote>
<h1 id="nvidia-driver">Nvidia driver</h1>
<blockquote>
<p>sudo ubuntu-driver devices</p>
</blockquote>
<p>Revisasr cuál es el driver que podemos usar, y nos dice qué paquete pasar a <code>apt</code>, por ejemplo:</p>
<blockquote>
<p>sudo apt install nvidia-driver-390</p>
</blockquote>
<h1 id="reboot">reboot</h1>
<p>Antes de hacerlo, es buen momento para un</p>
<blockquote>
<p>sudo apt update<br>
sudo apt upgrade</p>
</blockquote>


From: MOHAMMED FIRDOSH NASIM <firdosh.nasim@gmail.com>
Subject: RHEL 6: Missing /dev/mpath directory
Date: Fri, 6 May 2011 22:43:04 +0530
Message-ID: <BANLkTimUvQu8zhLSyxiO3TP-uVV9Z4NEvQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2022808203136164214=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============2022808203136164214==
Content-Type: multipart/alternative; boundary=bcaec53f943b5969a304a29e9a08

--bcaec53f943b5969a304a29e9a08
Content-Type: text/plain; charset=ISO-8859-1

Hi,
Apologies, as I am not sure whether my query fits into this mailing list. If
not, then please direct me to the correct mailing list.

I have configured RHEL 6 X86_64 host and have enabled multipath. As per the
DM Multipath documentation at "
http://docs.redhat.com/docs/en-US/Red_Hat_Enterprise_Linux/6/html/DM_Multipath/mpath_devices.html#multipath_device_id",


"When new devices are brought under the control of DM-Multipath, the new
devices may be seen in three different places under the /dev directory:
/dev/mapper/mpath*n*, /dev/mpath/mpath*n*, and /dev/dm-*n*. "

In my host I am seeing the devices only as /dev/dm-n and /dev/mapper/mpathx
symlink to /dev/dm-n. I am not seeing directory /dev/mpath.
---------------------------- screen dump start ---------------------------
[root@sped10 ~]# cat /etc/issue
Red Hat Enterprise Linux Server release 6.0 (Santiago)
Kernel \r on an \m

[root@sped10 ~]# uname -a
Linux sped10 2.6.32-71.el6.x86_64 #1 SMP Wed Sep 1 01:33:01 EDT 2010 x86_64
x86_64 x86_64 GNU/Linux
[root@sped10 ~]# ls -l /dev/mapper/ | grep mpath
lrwxrwxrwx. 1 root root      7 May  6 22:34 mpatha -> ../dm-7
lrwxrwxrwx. 1 root root      7 May  6 22:34 mpathb -> ../dm-8
lrwxrwxrwx. 1 root root      8 May  6 22:34 mpathc -> ../dm-13
lrwxrwxrwx. 1 root root      7 May  6 22:34 mpathd -> ../dm-6
lrwxrwxrwx. 1 root root      7 May  6 22:34 mpathe -> ../dm-4
lrwxrwxrwx. 1 root root      8 May  6 22:34 mpathf -> ../dm-10
lrwxrwxrwx. 1 root root      7 May  6 22:34 mpathg -> ../dm-5
lrwxrwxrwx. 1 root root      8 May  6 22:34 mpathh -> ../dm-12
lrwxrwxrwx. 1 root root      7 May  6 22:34 mpathi -> ../dm-9
lrwxrwxrwx. 1 root root      8 May  6 22:34 mpathj -> ../dm-11
lrwxrwxrwx. 1 root root      7 May  6 22:34 mpathk -> ../dm-2
lrwxrwxrwx. 1 root root      7 May  6 22:34 mpathl -> ../dm-3
lrwxrwxrwx. 1 root root      8 May  6 22:34 mpathlp1 -> ../dm-16
lrwxrwxrwx. 1 root root      8 May  6 22:34 mpathm -> ../dm-15
lrwxrwxrwx. 1 root root      8 May  6 22:34 mpathmp1 -> ../dm-20
lrwxrwxrwx. 1 root root      8 May  6 22:34 mpathmp2 -> ../dm-21
lrwxrwxrwx. 1 root root      8 May  6 22:34 mpathmp3 -> ../dm-22
lrwxrwxrwx. 1 root root      8 May  6 22:34 mpathn -> ../dm-14
lrwxrwxrwx. 1 root root      8 May  6 22:34 mpathnp1 -> ../dm-17
lrwxrwxrwx. 1 root root      8 May  6 22:34 mpathnp2 -> ../dm-18
lrwxrwxrwx. 1 root root      8 May  6 22:34 mpathnp3 -> ../dm-19
[root@sped10 ~]# ls /dev/mpath
ls: cannot access /dev/mpath: No such file or directory
[root@sped10 ~]#

---------------------------- screen dump end   ---------------------------

Am I missing something in configuring multipath? Please assist in this
regard.

Thanks and Regards,
Mohammed Firdosh Nasim.

--bcaec53f943b5969a304a29e9a08
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,<br>Apologies, as I am not sure whether my query fits into this mailing =
list. If not, then please direct me to the correct mailing list.<br><br>I h=
ave configured RHEL 6 X86_64 host and have enabled multipath. As per the DM=
 Multipath documentation at &quot;<a href=3D"http://docs.redhat.com/docs/en=
-US/Red_Hat_Enterprise_Linux/6/html/DM_Multipath/mpath_devices.html#multipa=
th_device_id">http://docs.redhat.com/docs/en-US/Red_Hat_Enterprise_Linux/6/=
html/DM_Multipath/mpath_devices.html#multipath_device_id</a>&quot;,=A0 <br>
<br>&quot;When new devices are brought under the control of DM-Multipath, t=
he new devices may be seen in three different places under the <code class=
=3D"literal">/dev</code> directory: <code class=3D"filename">/dev/mapper/mp=
ath</code><em class=3D"parameter"><code>n</code></em>, <code class=3D"filen=
ame">/dev/mpath/mpath</code><em class=3D"parameter"><code>n</code></em>, an=
d <code class=3D"filename">/dev/dm-</code><em class=3D"parameter"><code>n</=
code></em>.
		&quot;<br><br>In my host I am seeing the devices only as /dev/dm-n and /d=
ev/mapper/mpathx symlink to /dev/dm-n. I am not seeing directory /dev/mpath=
.<br>---------------------------- screen dump start -----------------------=
----<br>
[root@sped10 ~]# cat /etc/issue<br>Red Hat Enterprise Linux Server release =
6.0 (Santiago)<br>Kernel \r on an \m<br><br>[root@sped10 ~]# uname -a<br>Li=
nux sped10 2.6.32-71.el6.x86_64 #1 SMP Wed Sep 1 01:33:01 EDT 2010 x86_64 x=
86_64 x86_64 GNU/Linux<br>
[root@sped10 ~]# ls -l /dev/mapper/ | grep mpath<br>lrwxrwxrwx. 1 root root=
=A0=A0=A0=A0=A0 7 May=A0 6 22:34 mpatha -&gt; ../dm-7<br>lrwxrwxrwx. 1 root=
 root=A0=A0=A0=A0=A0 7 May=A0 6 22:34 mpathb -&gt; ../dm-8<br>lrwxrwxrwx. 1=
 root root=A0=A0=A0=A0=A0 8 May=A0 6 22:34 mpathc -&gt; ../dm-13<br>
lrwxrwxrwx. 1 root root=A0=A0=A0=A0=A0 7 May=A0 6 22:34 mpathd -&gt; ../dm-=
6<br>lrwxrwxrwx. 1 root root=A0=A0=A0=A0=A0 7 May=A0 6 22:34 mpathe -&gt; .=
./dm-4<br>lrwxrwxrwx. 1 root root=A0=A0=A0=A0=A0 8 May=A0 6 22:34 mpathf -&=
gt; ../dm-10<br>lrwxrwxrwx. 1 root root=A0=A0=A0=A0=A0 7 May=A0 6 22:34 mpa=
thg -&gt; ../dm-5<br>
lrwxrwxrwx. 1 root root=A0=A0=A0=A0=A0 8 May=A0 6 22:34 mpathh -&gt; ../dm-=
12<br>lrwxrwxrwx. 1 root root=A0=A0=A0=A0=A0 7 May=A0 6 22:34 mpathi -&gt; =
../dm-9<br>lrwxrwxrwx. 1 root root=A0=A0=A0=A0=A0 8 May=A0 6 22:34 mpathj -=
&gt; ../dm-11<br>lrwxrwxrwx. 1 root root=A0=A0=A0=A0=A0 7 May=A0 6 22:34 mp=
athk -&gt; ../dm-2<br>
lrwxrwxrwx. 1 root root=A0=A0=A0=A0=A0 7 May=A0 6 22:34 mpathl -&gt; ../dm-=
3<br>lrwxrwxrwx. 1 root root=A0=A0=A0=A0=A0 8 May=A0 6 22:34 mpathlp1 -&gt;=
 ../dm-16<br>lrwxrwxrwx. 1 root root=A0=A0=A0=A0=A0 8 May=A0 6 22:34 mpathm=
 -&gt; ../dm-15<br>lrwxrwxrwx. 1 root root=A0=A0=A0=A0=A0 8 May=A0 6 22:34 =
mpathmp1 -&gt; ../dm-20<br>
lrwxrwxrwx. 1 root root=A0=A0=A0=A0=A0 8 May=A0 6 22:34 mpathmp2 -&gt; ../d=
m-21<br>lrwxrwxrwx. 1 root root=A0=A0=A0=A0=A0 8 May=A0 6 22:34 mpathmp3 -&=
gt; ../dm-22<br>lrwxrwxrwx. 1 root root=A0=A0=A0=A0=A0 8 May=A0 6 22:34 mpa=
thn -&gt; ../dm-14<br>lrwxrwxrwx. 1 root root=A0=A0=A0=A0=A0 8 May=A0 6 22:=
34 mpathnp1 -&gt; ../dm-17<br>
lrwxrwxrwx. 1 root root=A0=A0=A0=A0=A0 8 May=A0 6 22:34 mpathnp2 -&gt; ../d=
m-18<br>lrwxrwxrwx. 1 root root=A0=A0=A0=A0=A0 8 May=A0 6 22:34 mpathnp3 -&=
gt; ../dm-19<br>[root@sped10 ~]# ls /dev/mpath<br>ls: cannot access /dev/mp=
ath: No such file or directory<br>
[root@sped10 ~]#<br><br>---------------------------- screen dump end =A0 --=
-------------------------<br><br>Am I missing something in configuring mult=
ipath? Please assist in this regard.<br><br>Thanks and Regards,<br>Mohammed=
 Firdosh Nasim. <br>
<br>

--bcaec53f943b5969a304a29e9a08--


--===============2022808203136164214==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2022808203136164214==--

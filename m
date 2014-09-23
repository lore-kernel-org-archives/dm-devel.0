From: Ali Poursamadi <ali@firstperson.is>
Subject: DM-Multipath limiting IO to 127.000 MB/Sec
Date: Mon, 22 Sep 2014 17:30:16 -0700
Message-ID: <CAAPTtDr2K8eb0H+iBVoKGOyK25uOVz2DD9p9gdZcW2rVUg=BpA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1644887542089361658=="
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

--===============1644887542089361658==
Content-Type: multipart/alternative; boundary=001a11c2b6cee9326f0503b0abc3

--001a11c2b6cee9326f0503b0abc3
Content-Type: text/plain; charset=UTF-8

Hi Gurus,

I'm experiencing an issue with DM-Multipath on Centos 6.5.
DD reads 2.5 times faster when reading from a device directly compared to
Multipath-ed device.
I'm using device-mapper-multipath-0.4.9-72.el6_5.2.x86_64.
Apparently Multipath is limiting throughput to 127.000 MB/s even though
the underlying device is capable of more throughput which to me it looks
like a software imposed limit.

[root@JS2 ~]# multipath -l mpathaf
mpathaf (--------) dm-89 Rorke,G4S-16L-4F8
size=7.3T features='0' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=0 status=active
  |- 0:0:0:1  sdb  8:16   active undef running
  |- 0:0:10:2 sdbb 67:80  active undef running
  |- 1:0:11:1 sddl 71:48  active undef running
  `- 1:0:12:2 sddp 71:112 active undef running

[root@JS2 ~]#dd if=/dev/sddl of=/dev/null bs=128k count=32000 skip=14000
32000+0 records in
32000+0 records out
4194304000 bytes (4.2 GB) copied, 11.8166 s, 355 MB/s

[root@JS2 ~]# dd if=/dev/dm-89 of=/dev/null bs=128k count=32000 skip=84000
# skipping 2GB array cache data
32000+0 records in
32000+0 records out
4194304000 bytes (4.2 GB) copied, 31.4959 s, 133 MB/s


This is on a machine connected over 2x8Gb/s links to a fiber switch and
then to an HDX4 disk array, exporting the volume to 2 of it's 4 8Gbps fiber
ports .

Multipath.conf looks like this :

defaults {
        user_friendly_names yes
}

devices {

        device { # normal HDX4 Disk arrays
                vendor "Rorke"
                product "G4S-16L-4F8"
                path_grouping_policy multibus
                }

}

blacklist {
#blacklisting almost everything
        devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
        devnode "^hd[a-z][0-9]*"
}


Any help/pointer/information is highly appreciated.

Thanks.
Ali Poursamadi

--001a11c2b6cee9326f0503b0abc3
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><span style=3D"font-family:arial,sans-serif;font-size:13px=
">Hi Gurus,</span><div style=3D"font-family:arial,sans-serif;font-size:13px=
"><br></div><div style=3D"font-family:arial,sans-serif;font-size:13px">I&#3=
9;m experiencing an issue with DM-Multipath on Centos 6.5.</div><div style=
=3D"font-family:arial,sans-serif;font-size:13px">DD reads 2.5 times faster =
when reading from a device directly compared to Multipath-ed device.</div><=
div style=3D"font-family:arial,sans-serif;font-size:13px"><div>I&#39;m usin=
g=C2=A0<span style=3D"font-size:small">device-mapper-multipath-0.4.9-72.el6=
_5.2.x86_64.</span><br></div><div><span style=3D"font-size:small">Apparentl=
y Multipath is limiting throughput to 127.000 MB/s even though the=C2=A0und=
erlying=C2=A0device is capable of more throughput which to me it looks like=
 a software imposed limit.=C2=A0</span><br></div><div><font face=3D"arial, =
sans-serif"><br></font></div><div><span style=3D"font-family:&#39;courier n=
ew&#39;,monospace">[root@JS2 ~]# multipath -l mpathaf</span><br></div></div=
><div style=3D"font-family:arial,sans-serif;font-size:13px"><div><font face=
=3D"courier new, monospace">mpathaf (--------) dm-89 Rorke,G4S-16L-4F8</fon=
t></div><div><font face=3D"courier new, monospace">size=3D7.3T features=3D&=
#39;0&#39; hwhandler=3D&#39;0&#39; wp=3Drw</font></div><div><font face=3D"c=
ourier new, monospace">`-+- policy=3D&#39;round-robin 0&#39; prio=3D0 statu=
s=3Dactive</font></div><div><font face=3D"courier new, monospace">=C2=A0 |-=
 0:0:0:1 =C2=A0sdb =C2=A08:16 =C2=A0 active undef running</font></div><div>=
<font face=3D"courier new, monospace">=C2=A0 |- 0:0:10:2 sdbb 67:80 =C2=A0a=
ctive undef running</font></div><div><font face=3D"courier new, monospace">=
=C2=A0 |- 1:0:11:1 sddl 71:48 =C2=A0active undef running</font></div><div><=
font face=3D"courier new, monospace">=C2=A0 `- 1:0:12:2 sddp 71:112 active =
undef running</font></div></div><div style=3D"font-family:arial,sans-serif;=
font-size:13px"><font face=3D"courier new, monospace"><br></font></div><div=
 style=3D"font-family:arial,sans-serif;font-size:13px"><div><font face=3D"c=
ourier new, monospace">[root@JS2 ~]#dd if=3D/dev/sddl of=3D/dev/null bs=3D1=
28k count=3D32000 skip=3D14000</font></div><div><font face=3D"courier new, =
monospace">32000+0 records in</font></div><div><font face=3D"courier new, m=
onospace">32000+0 records out</font></div><div><font face=3D"courier new, m=
onospace"><a href=3D"tel:4194304000" value=3D"+14194304000" target=3D"_blan=
k">4194304000</a>=C2=A0bytes (4.2 GB) copied, 11.8166 s, 355 MB/s</font></d=
iv></div><div style=3D"font-family:arial,sans-serif;font-size:13px"><br></d=
iv><div style=3D"font-family:arial,sans-serif;font-size:13px"><div><font fa=
ce=3D"courier new, monospace">[root@JS2 ~]# dd if=3D/dev/dm-89 of=3D/dev/nu=
ll bs=3D128k count=3D32000 skip=3D84000 # skipping 2GB array cache data=C2=
=A0</font></div><div><font face=3D"courier new, monospace">32000+0 records =
in</font></div><div><font face=3D"courier new, monospace">32000+0 records o=
ut</font></div><div><font face=3D"courier new, monospace"><a href=3D"tel:41=
94304000" value=3D"+14194304000" target=3D"_blank">4194304000</a>=C2=A0byte=
s (4.2 GB) copied, 31.4959 s, 133 MB/s</font></div></div><div style=3D"font=
-family:arial,sans-serif;font-size:13px"><br></div><div style=3D"font-famil=
y:arial,sans-serif;font-size:13px"><br></div><div style=3D"font-family:aria=
l,sans-serif;font-size:13px">This is on a machine connected over 2x8Gb/s li=
nks to a fiber switch and then to an HDX4 disk array, exporting the volume =
to 2 of it&#39;s 4 8Gbps fiber ports .=C2=A0</div><div style=3D"font-family=
:arial,sans-serif;font-size:13px"><br></div><div style=3D"font-family:arial=
,sans-serif;font-size:13px">Multipath.conf looks like this :=C2=A0</div><di=
v style=3D"font-family:arial,sans-serif;font-size:13px"><div><br></div><div=
><font face=3D"courier new, monospace">defaults {</font></div><div><font fa=
ce=3D"courier new, monospace">=C2=A0 =C2=A0 =C2=A0 =C2=A0<span style=3D"whi=
te-space:pre-wrap">	</span>user_friendly_names yes</font></div><div><font f=
ace=3D"courier new, monospace">}</font></div><div><font face=3D"courier new=
, monospace">=C2=A0</font></div><div><font face=3D"courier new, monospace">=
devices {</font></div><div><font face=3D"courier new, monospace"><br></font=
></div><div><font face=3D"courier new, monospace">=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 device { # normal HDX4 Disk arrays</font></div><div><font face=3D"couri=
er new, monospace">=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
vendor &quot;Rorke&quot;</font></div><div><font face=3D"courier new, monosp=
ace">=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 product &quot;=
G4S-16L-4F8&quot;</font></div><div><font face=3D"courier new, monospace">=
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 path_grouping_polic=
y multibus</font></div><div><font face=3D"courier new, monospace">=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }</font></div><div><font f=
ace=3D"courier new, monospace"><br></font></div><div><font face=3D"courier =
new, monospace">}</font></div><div><font face=3D"courier new, monospace">=
=C2=A0</font></div><div><font face=3D"courier new, monospace">blacklist {</=
font></div><div><font face=3D"courier new, monospace"><span style=3D"white-=
space:pre-wrap">	</span>#blacklisting almost everything</font></div><div><f=
ont face=3D"courier new, monospace">=C2=A0 =C2=A0 =C2=A0 =C2=A0 devnode &qu=
ot;^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*&quot;</font></div><div><font f=
ace=3D"courier new, monospace">=C2=A0 =C2=A0 =C2=A0 =C2=A0 devnode &quot;^h=
d[a-z][0-9]*&quot;</font></div><div><font face=3D"courier new, monospace">}=
<br></font></div></div><div style=3D"font-family:arial,sans-serif;font-size=
:13px"><br></div><div style=3D"font-family:arial,sans-serif;font-size:13px"=
><br></div><div style><font face=3D"arial, sans-serif">Any help/pointer/inf=
ormation is highly appreciated.=C2=A0</font></div><div style><font face=3D"=
arial, sans-serif"><br></font></div><div style><font face=3D"arial, sans-se=
rif">Thanks.</font></div><div style><font face=3D"arial, sans-serif">Ali Po=
ursamadi</font></div><div style><font face=3D"arial, sans-serif"><br><br></=
font></div><div style><font face=3D"arial, sans-serif"><br></font></div><di=
v style><font face=3D"arial, sans-serif"><br></font></div><div style><font =
face=3D"arial, sans-serif"><br></font></div></div>

--001a11c2b6cee9326f0503b0abc3--


--===============1644887542089361658==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1644887542089361658==--

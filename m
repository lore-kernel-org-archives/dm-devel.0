From: =?UTF-8?B?w5Z6a2FuIEfDtmtzdQ==?= <ozkangksu@gmail.com>
Subject: Re: device-mapper: ioctl: ioctl interface mismatch:
 kernel(4.37.0), user(4.39.0), cmd(16)
Date: Wed, 19 Sep 2018 18:30:46 +0300
Message-ID: <CAPUHmCodFP=PFK8DqrV_Qz_cgT6uaRXUihhTaPhjJpJ=bSCy-A@mail.gmail.com>
References: <CAPUHmCpwJ7jX-d6PHdmOWQC47zOBkT1-c6o2DH4xS9_Uq13vBA@mail.gmail.com>
	<09dfe022-a4a1-3fec-f998-ecfb0a477e44@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3665582189618393823=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <09dfe022-a4a1-3fec-f998-ecfb0a477e44@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: zkabelac@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============3665582189618393823==
Content-Type: multipart/alternative; boundary="000000000000cf623305763b17f4"

--000000000000cf623305763b17f4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello.

After your mail I tried something;
I just curious what will happen when I downgrade multipath-tools package
and the rest was latest.
lvm2 2.02.181-1
device-mapper 2.02.181-1

I just downgrade to: multipath-tools 0.7.6-1
Everything works great. I didnt saw any problem.
I was thinking the problem related to device-mapper but now its seems
something else.


This is compile process from Arch-linux AUR repository:
https://paste.ubuntu.com/p/zV58g56gVT/
If I'm not mistaken this is the log you want. If its not then tell me where
should I look for the log you want?

[root@SMDEV2  service]# ldd /usr/bin/multipathd
linux-vdso.so.1 (0x00007fffea4fe000)
libmultipath.so.0 =3D> /usr/lib/libmultipath.so.0 (0x00007f729711e000)
libmpathpersist.so.0 =3D> /usr/lib/libmpathpersist.so.0 (0x00007f7297114000=
)
libmpathcmd.so.0 =3D> /usr/lib/libmpathcmd.so.0 (0x00007f729710f000)
libudev.so.1 =3D> /usr/lib/libudev.so.1 (0x00007f72970ef000)
libdl.so.2 =3D> /usr/lib/libdl.so.2 (0x00007f72970ea000)
liburcu.so.6 =3D> /usr/lib/liburcu.so.6 (0x00007f7296ee2000)
libpthread.so.0 =3D> /usr/lib/libpthread.so.0 (0x00007f7296ebf000)
libdevmapper.so.1.02 =3D> /usr/lib/libdevmapper.so.1.02 (0x00007f7296c69000=
)
libreadline.so.7 =3D> /usr/lib/libreadline.so.7 (0x00007f7296a1c000)
libsystemd.so.0 =3D> /usr/lib/libsystemd.so.0 (0x00007f7296990000)
libc.so.6 =3D> /usr/lib/libc.so.6 (0x00007f72967cc000)
libaio.so.1 =3D> /usr/lib/libaio.so.1 (0x00007f72965ca000)
/lib64/ld-linux-x86-64.so.2 =3D> /usr/lib64/ld-linux-x86-64.so.2
(0x00007f72971b5000)
liburcu-common.so.6 =3D> /usr/lib/liburcu-common.so.6 (0x00007f72963c3000)
libm.so.6 =3D> /usr/lib/libm.so.6 (0x00007f729623e000)
libncursesw.so.6 =3D> /usr/lib/libncursesw.so.6 (0x00007f7295fd1000)
librt.so.1 =3D> /usr/lib/librt.so.1 (0x00007f7295fc7000)
liblzma.so.5 =3D> /usr/lib/liblzma.so.5 (0x00007f7295da1000)
liblz4.so.1 =3D> /usr/lib/liblz4.so.1 (0x00007f7295b84000)
libgcrypt.so.20 =3D> /usr/lib/libgcrypt.so.20 (0x00007f7295866000)
libgpg-error.so.0 =3D> /usr/lib/libgpg-error.so.0 (0x00007f7295646000)

I did not tried to compile from GIT by myself. But my knowledge the aur
package also takes the code from your git repository
If you need anything else just ask me please.



Zdenek Kabelac <zkabelac@redhat.com>, 19 Eyl 2018 =C3=87ar, 15:52 tarihinde=
 =C5=9Funu
yazd=C4=B1:

> Dne 19.9.2018 v 12:35 =C3=96zkan G=C3=B6ksu napsal(a):
> > Hello.
> > I just upgraded my Kernel to: 4.14.70-1-lts | device-mapper 2.02.181-1 =
|
> > multipath-tools 0.7.7-1
> > After that multipathd started to giving the log: // device-mapper:
> ioctl:
> > ioctl interface mismatch: kernel(4.37.0), user(4.39.0), cmd(16)
> > It was working great on my ex kernel "4.14.30-1-lts" with |
> device-mapper
> > 2.02.177-5 | multipath-tools 0.7.6-1
> > Also I tried multipath git version but nothing change.
> >
> > I think the problem related to device-mapper and my device mapper Build
> Date:
> > 2018-08-01 19:05 UTC =3D
> > https://www.archlinux.org/packages/core/x86_64/device-mapper/
> > Do I need to compile device mapper git version or what should I do?
> >
>
> Hi
>
> Can you pastebin how is your package linked while being compiled (gcc log=
)
> and
> how is then used runtime  (ldd) ?
>
> It seems the code was linked with different .so library then it's using i=
n
> runtime.
>
> libdm  is supposed to handle all kernel versions.
>
>
> Regards
>
> Zdenek
>
>

--000000000000cf623305763b17f4
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div di=
r=3D"ltr">Hello.=C2=A0<div><br></div><div>After your mail I tried something=
;<br><div>I just curious what will happen when I downgrade multipath-tools =
package and the rest was latest.=C2=A0</div><div>lvm2 2.02.181-1</div><div>=
device-mapper 2.02.181-1</div><div><br></div><div>I just downgrade to: mult=
ipath-tools 0.7.6-1</div><div>Everything works great. I didnt saw any probl=
em.=C2=A0</div><div>I was thinking the problem related to device-mapper but=
 now its seems something else.=C2=A0<br></div></div><div><br></div><div><br=
></div><div>This is compile process from Arch-linux AUR repository: <font c=
olor=3D"#0000ff"><a href=3D"https://paste.ubuntu.com/p/zV58g56gVT/">https:/=
/paste.ubuntu.com/p/zV58g56gVT/</a></font><br>If I&#39;m not mistaken this =
is the log you want. If its not then tell me where should I look for the lo=
g you want?</div><div><br><div>[root@SMDEV2=C2=A0 service]# ldd /usr/bin/mu=
ltipathd</div><div><span style=3D"white-space:pre">	</span>linux-vdso.so.1 =
(0x00007fffea4fe000)</div><div><span style=3D"white-space:pre">	</span>libm=
ultipath.so.0 =3D&gt; /usr/lib/libmultipath.so.0 (0x00007f729711e000)</div>=
<div><span style=3D"white-space:pre">	</span>libmpathpersist.so.0 =3D&gt; /=
usr/lib/libmpathpersist.so.0 (0x00007f7297114000)</div><div><span style=3D"=
white-space:pre">	</span>libmpathcmd.so.0 =3D&gt; /usr/lib/libmpathcmd.so.0=
 (0x00007f729710f000)</div><div><span style=3D"white-space:pre">	</span>lib=
udev.so.1 =3D&gt; /usr/lib/libudev.so.1 (0x00007f72970ef000)</div><div><spa=
n style=3D"white-space:pre">	</span>libdl.so.2 =3D&gt; /usr/lib/libdl.so.2 =
(0x00007f72970ea000)</div><div><span style=3D"white-space:pre">	</span>libu=
rcu.so.6 =3D&gt; /usr/lib/liburcu.so.6 (0x00007f7296ee2000)</div><div><span=
 style=3D"white-space:pre">	</span>libpthread.so.0 =3D&gt; /usr/lib/libpthr=
ead.so.0 (0x00007f7296ebf000)</div><div><span style=3D"white-space:pre">	</=
span>libdevmapper.so.1.02 =3D&gt; /usr/lib/libdevmapper.so.1.02 (0x00007f72=
96c69000)</div><div><span style=3D"white-space:pre">	</span>libreadline.so.=
7 =3D&gt; /usr/lib/libreadline.so.7 (0x00007f7296a1c000)</div><div><span st=
yle=3D"white-space:pre">	</span>libsystemd.so.0 =3D&gt; /usr/lib/libsystemd=
.so.0 (0x00007f7296990000)</div><div><span style=3D"white-space:pre">	</spa=
n>libc.so.6 =3D&gt; /usr/lib/libc.so.6 (0x00007f72967cc000)</div><div><span=
 style=3D"white-space:pre">	</span>libaio.so.1 =3D&gt; /usr/lib/libaio.so.1=
 (0x00007f72965ca000)</div><div><span style=3D"white-space:pre">	</span>/li=
b64/ld-linux-x86-64.so.2 =3D&gt; /usr/lib64/ld-linux-x86-64.so.2 (0x00007f7=
2971b5000)</div><div><span style=3D"white-space:pre">	</span>liburcu-common=
.so.6 =3D&gt; /usr/lib/liburcu-common.so.6 (0x00007f72963c3000)</div><div><=
span style=3D"white-space:pre">	</span>libm.so.6 =3D&gt; /usr/lib/libm.so.6=
 (0x00007f729623e000)</div><div><span style=3D"white-space:pre">	</span>lib=
ncursesw.so.6 =3D&gt; /usr/lib/libncursesw.so.6 (0x00007f7295fd1000)</div><=
div><span style=3D"white-space:pre">	</span>librt.so.1 =3D&gt; /usr/lib/lib=
rt.so.1 (0x00007f7295fc7000)</div><div><span style=3D"white-space:pre">	</s=
pan>liblzma.so.5 =3D&gt; /usr/lib/liblzma.so.5 (0x00007f7295da1000)</div><d=
iv><span style=3D"white-space:pre">	</span>liblz4.so.1 =3D&gt; /usr/lib/lib=
lz4.so.1 (0x00007f7295b84000)</div><div><span style=3D"white-space:pre">	</=
span>libgcrypt.so.20 =3D&gt; /usr/lib/libgcrypt.so.20 (0x00007f7295866000)<=
/div><div><span style=3D"white-space:pre">	</span>libgpg-error.so.0 =3D&gt;=
 /usr/lib/libgpg-error.so.0 (0x00007f7295646000)</div></div><div><br></div>=
<div>I did not tried to compile from GIT by myself. But my knowledge the au=
r package also takes the code from your git repository=C2=A0<br>If you need=
 anything else just ask me please.=C2=A0<br><br><br></div></div></div><br><=
div class=3D"gmail_quote"><div dir=3D"ltr">Zdenek Kabelac &lt;<a href=3D"ma=
ilto:zkabelac@redhat.com">zkabelac@redhat.com</a>&gt;, 19 Eyl 2018 =C3=87ar=
, 15:52 tarihinde =C5=9Funu yazd=C4=B1:<br></div><blockquote class=3D"gmail=
_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204=
,204);padding-left:1ex">Dne 19.9.2018 v 12:35 =C3=96zkan G=C3=B6ksu napsal(=
a):<br>
&gt; Hello.<br>
&gt; I just upgraded my Kernel to: 4.14.70-1-lts | device-mapper 2.02.181-1=
 | <br>
&gt; multipath-tools 0.7.7-1<br>
&gt; After that multipathd started to giving the log: // device-mapper: ioc=
tl: <br>
&gt; ioctl interface mismatch: kernel(4.37.0), user(4.39.0), cmd(16)<br>
&gt; It was working great on my ex kernel &quot;4.14.30-1-lts&quot; with | =
device-mapper <br>
&gt; 2.02.177-5 | multipath-tools 0.7.6-1<br>
&gt; Also I tried multipath git version but nothing change.<br>
&gt; <br>
&gt; I think the problem related to device-mapper and my device mapper Buil=
d Date: <br>
&gt; 2018-08-01 19:05 UTC =3D <br>
&gt; <a href=3D"https://www.archlinux.org/packages/core/x86_64/device-mappe=
r/" rel=3D"noreferrer" target=3D"_blank">https://www.archlinux.org/packages=
/core/x86_64/device-mapper/</a><br>
&gt; Do I need to compile device mapper git version or what should I do?<br=
>
&gt; <br>
<br>
Hi<br>
<br>
Can you pastebin how is your package linked while being compiled (gcc log) =
and<br>
how is then used runtime=C2=A0 (ldd) ?<br>
<br>
It seems the code was linked with different .so library then it&#39;s using=
 in <br>
runtime.<br>
<br>
libdm=C2=A0 is supposed to handle all kernel versions.<br>
<br>
<br>
Regards<br>
<br>
Zdenek<br>
<br>
</blockquote></div></div></div></div>

--000000000000cf623305763b17f4--


--===============3665582189618393823==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3665582189618393823==--

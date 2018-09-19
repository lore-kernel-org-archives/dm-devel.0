From: =?UTF-8?B?w5Z6a2FuIEfDtmtzdQ==?= <ozkangksu@gmail.com>
Subject: device-mapper: ioctl: ioctl interface mismatch:
 kernel(4.37.0), user(4.39.0), cmd(16)
Date: Wed, 19 Sep 2018 13:35:53 +0300
Message-ID: <CAPUHmCpwJ7jX-d6PHdmOWQC47zOBkT1-c6o2DH4xS9_Uq13vBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8882070040046518812=="
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

--===============8882070040046518812==
Content-Type: multipart/alternative; boundary="0000000000002f3c7e057636f9c9"

--0000000000002f3c7e057636f9c9
Content-Type: text/plain; charset="UTF-8"

Hello.
I just upgraded my Kernel to: 4.14.70-1-lts | device-mapper 2.02.181-1 |
multipath-tools 0.7.7-1
After that multipathd started to giving the log: // device-mapper: ioctl:
ioctl interface mismatch: kernel(4.37.0), user(4.39.0), cmd(16)
It was working great on my ex kernel "4.14.30-1-lts" with | device-mapper
2.02.177-5 | multipath-tools 0.7.6-1
Also I tried multipath git version but nothing change.

I think the problem related to device-mapper and my device mapper Build
Date: 2018-08-01 19:05 UTC =
https://www.archlinux.org/packages/core/x86_64/device-mapper/
Do I need to compile device mapper git version or what should I do?

--0000000000002f3c7e057636f9c9
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div cl=
ass=3D"gmail-linestyle1 gmail-colourline" style=3D"font-family:Consolas,&qu=
ot;Lucida Console&quot;,monospace;padding-left:7px;word-wrap:break-word;col=
or:rgb(0,0,0);font-size:12.8px">Hello. <br><span style=3D"font-size:12.8px"=
>I just upgraded my Kernel to: 4.14.70-1-lts | device-mapper 2.02.181-1 | m=
ultipath-tools 0.7.7-1</span><br></div><div class=3D"gmail-linestyle2 gmail=
-colourline" style=3D"font-family:Consolas,&quot;Lucida Console&quot;,monos=
pace;padding-left:7px;word-wrap:break-word;color:rgb(0,0,0);font-size:12.8p=
x"><span style=3D"font-size:12.8px">After that multipathd started to giving=
 the log:=C2=A0</span><span style=3D"font-size:12.8px">// device-mapper: io=
ctl: ioctl interface mismatch: kernel(4.37.0), user(4.39.0), cmd(16)</span>=
<br></div><div class=3D"gmail-linestyle2 gmail-colourline" style=3D"font-fa=
mily:Consolas,&quot;Lucida Console&quot;,monospace;padding-left:7px;word-wr=
ap:break-word;color:rgb(0,0,0);font-size:12.8px"><span style=3D"font-size:1=
2.8px">It was working great on my ex kernel &quot;4.14.30-1-lts&quot; with =
| device-mapper 2.02.177-5 | multipath-tools 0.7.6-1</span><br></div><div c=
lass=3D"gmail-linestyle2 gmail-colourline" style=3D"font-family:Consolas,&q=
uot;Lucida Console&quot;,monospace;padding-left:7px;word-wrap:break-word;co=
lor:rgb(0,0,0);font-size:12.8px"><span style=3D"font-size:12.8px">Also I tr=
ied multipath git version but nothing change.</span><br></div><div class=3D=
"gmail-linestyle1 gmail-colourline" style=3D"font-family:Consolas,&quot;Luc=
ida Console&quot;,monospace;padding-left:7px;word-wrap:break-word;color:rgb=
(0,0,0);font-size:12.8px"><br></div><div class=3D"gmail-linestyle1 gmail-co=
lourline" style=3D"font-family:Consolas,&quot;Lucida Console&quot;,monospac=
e;padding-left:7px;word-wrap:break-word;color:rgb(0,0,0);font-size:12.8px">=
I think the problem related to device-mapper and my device mapper Build Dat=
e:	2018-08-01 19:05 UTC =3D=C2=A0<a href=3D"https://www.archlinux.org/packa=
ges/core/x86_64/device-mapper/" target=3D"_blank" rel=3D"noopener">https://=
www.archlinux.org/packages/core/x86_64/device-mapper/</a></div><div class=
=3D"gmail-linestyle2 gmail-colourline" style=3D"font-family:Consolas,&quot;=
Lucida Console&quot;,monospace;padding-left:7px;word-wrap:break-word;color:=
rgb(0,0,0);font-size:12.8px">Do I need to compile device mapper git version=
 or what should I do?</div></div></div></div></div>

--0000000000002f3c7e057636f9c9--


--===============8882070040046518812==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8882070040046518812==--

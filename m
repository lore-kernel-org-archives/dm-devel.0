From: Leonardo Santos <heiligerstein@gmail.com>
Subject: Balanced Striping
Date: Tue, 18 Feb 2014 16:34:21 -0300
Message-ID: <CAEZ+n-gM_5w-HYrTC6h3ZrtS2EJuykiA1bym0p2jgOQnzO64Zw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8204967306152533551=="
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

--===============8204967306152533551==
Content-Type: multipart/alternative; boundary=bcaec51f969fdeb6d304f2b35bea

--bcaec51f969fdeb6d304f2b35bea
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I'm trying to make a experimental balance striping between SSD and HDD
based on some performance parameter (latency or throughput) gotten on the
fly.

I realized that when I increase the number of operations for SSD (e.g. 3x1,
SSDxHDD) it doesn't give me the better of both.

My HDD read sequentially at ~100MB/s and my SSD at ~400MB/s. My hope is
throughput to be the sum of SSD and HDD, but this its not true for my tests=
.

For instance, when I put operations in 1x1:
SSD =3D ~100MB/s
HDD =3D ~100MB/s

When I put 3x1:
SSD =3D ~150MB/s
HDD =3D ~50MB/s (why its not 100MB/s?)

For me its not parallel, but only distributes the operations in a
proportional way.

Questions:
- Why isn't throughput equal to HDD + SSD in normal mode (1x1)?
- Why HDD reduces proportionally?
- Its not parallel? Where can I change it to make this parallel?

I using this in my research and changed dm-stripe.c.

Thanks a lot!

*Leonardo Ant=F4nio dos Santos*

--bcaec51f969fdeb6d304f2b35bea
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div style=3D"font-family:arial,sans-serif;font-size:13px"=
>I&#39;m trying to make a experimental balance striping between SSD and HDD=
 based on some performance parameter (latency or throughput) gotten on the =
fly.</div>

<div style=3D"font-family:arial,sans-serif;font-size:13px"><br></div><div s=
tyle=3D"font-family:arial,sans-serif;font-size:13px">I realized that when I=
 increase the number of operations for SSD (e.g. 3x1, SSDxHDD) it doesn&#39=
;t give me the better of both.</div>

<div style=3D"font-family:arial,sans-serif;font-size:13px"><br></div><div s=
tyle=3D"font-family:arial,sans-serif;font-size:13px">My HDD read sequential=
ly at ~100MB/s and my SSD at ~400MB/s. My hope is throughput to be the sum =
of SSD and HDD, but this its not true for my tests.</div>

<div style=3D"font-family:arial,sans-serif;font-size:13px"><br></div><div s=
tyle=3D"font-family:arial,sans-serif;font-size:13px">For instance, when I p=
ut operations in 1x1:</div><div style=3D"font-family:arial,sans-serif;font-=
size:13px">

SSD =3D ~100MB/s</div><div style=3D"font-family:arial,sans-serif;font-size:=
13px">HDD =3D ~100MB/s<br></div><div style=3D"font-family:arial,sans-serif;=
font-size:13px"><br></div><div style=3D"font-family:arial,sans-serif;font-s=
ize:13px">

<div>When I put 3x1:</div><div>SSD =3D ~150MB/s</div><div>HDD =3D ~50MB/s (=
why its not 100MB/s?)<br></div></div><div style=3D"font-family:arial,sans-s=
erif;font-size:13px"><br></div><div style=3D"font-family:arial,sans-serif;f=
ont-size:13px">

For me its not parallel, but only distributes the operations in a proportio=
nal way.<br></div><div style=3D"font-family:arial,sans-serif;font-size:13px=
"><br></div><div style=3D"font-family:arial,sans-serif;font-size:13px">Ques=
tions:</div>

<div style=3D"font-family:arial,sans-serif;font-size:13px">- Why isn&#39;t =
throughput equal to HDD + SSD in normal mode (1x1)?</div><div style=3D"font=
-family:arial,sans-serif;font-size:13px">- Why HDD reduces proportionally?<=
br>

</div><div style=3D"font-family:arial,sans-serif;font-size:13px">- Its not =
parallel? Where can I change it to make this parallel?<br></div><div style=
=3D"font-family:arial,sans-serif;font-size:13px"><br></div><div style=3D"fo=
nt-family:arial,sans-serif;font-size:13px">

I using this in my research and changed dm-stripe.c.</div><div style=3D"fon=
t-family:arial,sans-serif;font-size:13px"><br></div><div style=3D"font-fami=
ly:arial,sans-serif;font-size:13px">Thanks a lot!</div><div style=3D"font-f=
amily:arial,sans-serif;font-size:13px">

<br></div><div style=3D"font-family:arial,sans-serif;font-size:13px"><b>Leo=
nardo Ant=F4nio dos Santos</b></div></div>

--bcaec51f969fdeb6d304f2b35bea--


--===============8204967306152533551==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8204967306152533551==--

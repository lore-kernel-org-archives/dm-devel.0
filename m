From: Doug Dumitru <doug@easyco.com>
Subject: DM limits setup
Date: Wed, 31 Dec 2014 14:10:52 -0800
Message-ID: <CAFx4rwQudUhVH4rgJYb+uHPe17PKJHYQRsxbUpwr5h_1r2B8+w@mail.gmail.com>
Reply-To: doug@easyco.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1690833669165451836=="
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

--===============1690833669165451836==
Content-Type: multipart/alternative; boundary=f46d043c7edc7d296b050b8a6143

--f46d043c7edc7d296b050b8a6143
Content-Type: text/plain; charset=UTF-8

Hello all,

I have a test dm target module that I use to validate storage subsystems
for data accuracy.  It basically builds weak hashes for every sector of a
device when written, and validates these hashes when the sector is read
back.  Ugly memory usage, but it is just a test tool.

I can deploy this with an iterator target and it will take on the limits of
the device underneath, or I can skip the iterator target and get limits at
2048 sectors.  What I would like to do is set the limit manually.  I know
this is "really bad program design", but again, this is a test tool and not
anything for production use.

Can anyone point me at an example of where the limits are setup explicitly.

Thanks in advance.

Doug Dumitru

--f46d043c7edc7d296b050b8a6143
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif;font-size:small">Hello all,<br><br>I have a test dm targ=
et module that I use to validate storage subsystems for data accuracy.=C2=
=A0 It basically builds weak hashes for every sector of a device when writt=
en, and validates these hashes when the sector is read back.=C2=A0 Ugly mem=
ory usage, but it is just a test tool.<br><br></div><div class=3D"gmail_def=
ault" style=3D"font-family:arial,helvetica,sans-serif;font-size:small">I ca=
n deploy this with an iterator target and it will take on the limits of the=
 device underneath, or I can skip the iterator target and get limits at 204=
8 sectors.=C2=A0 What I would like to do is set the limit manually.=C2=A0 I=
 know this is &quot;really bad program design&quot;, but again, this is a t=
est tool and not anything for production use.<br><br></div><div class=3D"gm=
ail_default" style=3D"font-family:arial,helvetica,sans-serif;font-size:smal=
l">Can anyone point me at an example of where the limits are setup explicit=
ly.<br><br></div><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif;font-size:small">Thanks in advance.<br><br>Doug Dumitru<=
br clear=3D"all"></div><br></div>

--f46d043c7edc7d296b050b8a6143--


--===============1690833669165451836==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1690833669165451836==--

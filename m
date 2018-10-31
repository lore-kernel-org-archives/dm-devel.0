From: Drew Hastings <dhastings@crucialwebhost.com>
Subject: multipath target and non-request-stackable devices
Date: Wed, 31 Oct 2018 02:32:45 -0700
Message-ID: <CAN-y+EKcNSQL5_eFD1iuJeyUfk7UApgWWA_Vj72TKQN7-a_kVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8302101924194078878=="
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

--===============8302101924194078878==
Content-Type: multipart/alternative; boundary="000000000000b47606057982fc0f"

--000000000000b47606057982fc0f
Content-Type: text/plain; charset="UTF-8"

Firstly, thanks for the hard work you guys are doing on the dm drivers.

I'm curious to know if I correctly understand the limitations of the
multipath target. I'm using kernel 4.19.0-rc5

When attempting to create a device from two NVMEs connected over nvme_rdma
/ nvmf, I get the following message:

[43012.002418] device-mapper: table: table load rejected: including
non-request-stackable devices
[43012.004067] device-mapper: table: unable to determine table type

Here's an example request that will fail:

dmsetup create test_path --table "0 1562824368 multipath 0 0 2 1
round-robin 0 1 1 /dev/nvme1n1 1 round-robin 0 1 1 /dev/nvme2n1 1"

This will work:

dmsetup create test_path --table "0 1562824368 multipath 0 0 2 1
round-robin 0 1 1 /dev/sdc 1 round-robin 0 1 1 /dev/sdb 1"

After looking at dm-table.c, it seems like this may be an issue of these
underlying devices not being compatible with the multipath driver. I had
noticed this same error when trying "non-physical" devices in other tests,
such as trying to multipath other virtual devices.

Is there anything that can be done to do the (relatively "basic") multipath
that detects IO errors and switches to the other device? It seems like
fundamentally multipath's error detection works in the same way raid1
implements IO error detection of the underlying devices, so why is it that
multipath seems to have this limitation but raid1 does not?

Is md-multipath.c still in use? It seems like it might not have this same
restriction on the underlying device.

Thank you so much for your time!

--000000000000b47606057982fc0f
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div di=
r=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr">Firstly, thanks for the hard wo=
rk you guys are doing on the dm drivers.<div><br></div><div>I&#39;m curious=
 to know if I correctly understand the limitations of the multipath target.=
 I&#39;m using kernel=C2=A04.19.0-rc5</div><div><br></div><div>When attempt=
ing to create a device from two NVMEs connected over nvme_rdma / nvmf, I ge=
t the following message:<br><br><div>[43012.002418] device-mapper: table: t=
able load rejected: including non-request-stackable devices</div><div>[4301=
2.004067] device-mapper: table: unable to determine table type</div></div><=
div><br></div><div>Here&#39;s an example request that will fail:</div><div>=
<br></div><div>dmsetup create test_path --table &quot;0 1562824368 multipat=
h 0 0 2 1 round-robin 0 1 1 /dev/nvme1n1 1 round-robin 0 1 1 /dev/nvme2n1 1=
&quot;<br></div><div><br></div><div>This will work:</div><div><br></div><di=
v>dmsetup create test_path=C2=A0--table &quot;0 1562824368 multipath 0 0 2 =
1 round-robin 0 1 1 /dev/sdc 1 round-robin 0 1 1 /dev/sdb 1&quot;<br></div>=
<div><br></div><div>After looking at=C2=A0dm-table.c, it seems like this ma=
y be an issue of these underlying devices not being compatible with the mul=
tipath driver. I had noticed this same error when trying &quot;non-physical=
&quot; devices in other tests, such as trying to multipath other virtual de=
vices.</div><div><br></div><div>Is there anything that can be done to do th=
e (relatively &quot;basic&quot;) multipath that detects IO errors and switc=
hes to the other device? It seems like fundamentally multipath&#39;s error =
detection works in the same way raid1 implements IO error detection of the =
underlying devices, so why is it that multipath seems to have this limitati=
on but raid1 does not?</div><div><br></div><div>Is=C2=A0md-multipath.c stil=
l in use? It seems like it might not have this same restriction on the unde=
rlying device.</div><div><br></div><div>Thank you so much for your time!</d=
iv></div></div></div></div></div></div></div>

--000000000000b47606057982fc0f--


--===============8302101924194078878==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8302101924194078878==--

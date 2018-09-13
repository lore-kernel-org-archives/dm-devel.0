From: =?UTF-8?B?w5Z6a2FuIEfDtmtzdQ==?= <ozkangksu@gmail.com>
Subject: Dealing with constantly failing paths
Date: Thu, 13 Sep 2018 12:42:54 +0300
Message-ID: <CAPUHmCoLAEAvJ-4Ftnf+jjDANS=EgXVcA=7dQ0NdFuJbsBzwDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7141433694331018360=="
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

--===============7141433694331018360==
Content-Type: multipart/alternative; boundary="0000000000009f7b4b0575bd8807"

--0000000000009f7b4b0575bd8807
Content-Type: text/plain; charset="UTF-8"

Hello.
I'm sorry to have e-mailed you here but I did not really find the answer.

When a disk starts to die slowly multipath starts to Failing & Reinstating
paths and this keeps forever.. (I'm using LSI-3008HBA card with SAS-JBOD
not FC-Network)
Because kernel do not echo to offline faulted disk. This is causing
terrible problems to me.

I'm using: multipath-tools 0.7.4-1
Linux DEV2 4.14.67-1-lts #1


Dmesg;
    Sep 13 11:20:17 DEV2 kernel: sd 0:0:190:0: attempting task abort!
scmd(ffff88110e632948)
    Sep 13 11:20:17 DEV2 kernel: sd 0:0:190:0: [sdft] tag#3 CDB: opcode=0x0
00 00 00 00 00 00
    Sep 13 11:20:17 DEV2 kernel: scsi target0:0:190: handle(0x0037),
sas_address(0x5000c50093d4e7c6), phy(38)
    Sep 13 11:20:17 DEV2 kernel: scsi target0:0:190:
enclosure_logical_id(0x500304800929ec7f), slot(37)
    Sep 13 11:20:17 DEV2 kernel: scsi target0:0:190: enclosure
level(0x0001),connector name(1   )
    Sep 13 11:20:17 DEV2 kernel: sd 0:0:190:0: task abort: SUCCESS
scmd(ffff88110e632948)
    Sep 13 11:20:18 DEV2 kernel: device-mapper: multipath: Failing path
130:240.
    Sep 13 11:25:34 DEV2 kernel: device-mapper: multipath: Reinstating path
130:240.
Full dmesg example: https://paste.ubuntu.com/p/H9NMWxNfgD/

As you can see kernel aborted the mission and after that multipath failed.
So I want to get rid of this problem via telling Multipath "do not
Reinstate the path".
This method will keep dead the zombie disk.
If I dont kick the disk out its causing HBA reset and I'm losing all disk
in my pool and ZFS pool suspending.

I'm not saying this problem related to multipathd, I'm just thinking this
will save me.

So how can I tell the multipath do not Reinstate X times failed path?
Thank you.

--0000000000009f7b4b0575bd8807
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div di=
r=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div>Hello.=C2=A0</div><div>I&#=
39;m sorry to have e-mailed you here but I did not really find the answer.<=
/div><div><br></div><div>When a disk starts to die slowly multipath starts =
to Failing &amp; Reinstating paths and this keeps forever.. (I&#39;m using =
LSI-3008HBA card with SAS-JBOD not FC-Network)</div><div>Because kernel do =
not echo to offline faulted disk. This is causing terrible problems to me.<=
/div><div><br></div><div><div>I&#39;m using: multipath-tools 0.7.4-1</div><=
/div><div>Linux DEV2 4.14.67-1-lts #1=C2=A0<br></div><div><br></div><div><b=
r></div><div>Dmesg;</div><div>=C2=A0 =C2=A0 Sep 13 11:20:17 DEV2 kernel: sd=
 0:0:190:0: attempting task abort! scmd(ffff88110e632948)<br></div><div>=C2=
=A0 =C2=A0 Sep 13 11:20:17 DEV2 kernel: sd 0:0:190:0: [sdft] tag#3 CDB: opc=
ode=3D0x0 00 00 00 00 00 00</div><div>=C2=A0 =C2=A0 Sep 13 11:20:17 DEV2 ke=
rnel: scsi target0:0:190: handle(0x0037), sas_address(0x5000c50093d4e7c6), =
phy(38)</div><div>=C2=A0 =C2=A0 Sep 13 11:20:17 DEV2 kernel: scsi target0:0=
:190: enclosure_logical_id(0x500304800929ec7f), slot(37)</div><div>=C2=A0 =
=C2=A0 Sep 13 11:20:17 DEV2 kernel: scsi target0:0:190: enclosure level(0x0=
001),connector name(1=C2=A0 =C2=A0)</div><div>=C2=A0 =C2=A0 Sep 13 11:20:17=
 DEV2 kernel: sd 0:0:190:0: task abort: SUCCESS scmd(ffff88110e632948)</div=
><div>=C2=A0 =C2=A0 Sep 13 11:20:18 DEV2 kernel: device-mapper: multipath: =
Failing path 130:240.</div><div>=C2=A0 =C2=A0 Sep 13 11:25:34 DEV2 kernel: =
device-mapper: multipath: Reinstating path 130:240.</div><div>Full dmesg ex=
ample:=C2=A0<a href=3D"https://paste.ubuntu.com/p/H9NMWxNfgD/">https://past=
e.ubuntu.com/p/H9NMWxNfgD/</a></div><div>=C2=A0</div><div>As you can see ke=
rnel aborted the mission and after that multipath failed.</div><div>So I wa=
nt to get rid of this problem via telling Multipath &quot;do not Reinstate =
the path&quot;.=C2=A0=C2=A0</div><div>This method will keep dead the zombie=
 disk.</div><div>If I dont kick the disk out its causing HBA reset and I&#3=
9;m losing all disk in my pool and ZFS pool suspending.</div><div><br></div=
><div>I&#39;m not saying this problem related to multipathd, I&#39;m just t=
hinking this will save me.</div><div><br></div><div>So how can I tell the m=
ultipath do not Reinstate X times failed path?</div><div>Thank you.</div></=
div></div></div></div></div></div></div>

--0000000000009f7b4b0575bd8807--


--===============7141433694331018360==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7141433694331018360==--

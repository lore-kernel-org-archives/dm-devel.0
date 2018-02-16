From: <ivanov.maxim@gmail.com>
Subject: kworker spins on iSCSI session logout with multipath
	running
Date: Fri, 16 Feb 2018 13:48:59 +0000
Message-ID: <5a86e14c.0d8bdf0a.7f29.fce8@mx.google.com>
References: <CALQ-8CJgbRqZxRK2ZAxVfZgq+8Tohbj7XL+Cpk9Mr=nP-vk_6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6602825021501964760=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CALQ-8CJgbRqZxRK2ZAxVfZgq+8Tohbj7XL+Cpk9Mr=nP-vk_6Q@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============6602825021501964760==
Content-Type: multipart/alternative;
	boundary="_271B2D83-AD35-42F6-9921-B8250BBAEA75_"

--_271B2D83-AD35-42F6-9921-B8250BBAEA75_
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Hello All,

I am investigating strange behaviour described here
https://github.com/coreos/bugs/issues/2357 and would like to ask for
help/advice to diagnose it further.

It all boils down to kworker spinning 100% of CPU per iSCSI portal,
when logging out from iSCSI sessions. It happens only if multipathd is
running or had run and created multipath devices. No problem occur if
I mask multipathd, reboot, wait for all scsi devices to be discovered
and attempt to logout.

  1. start server, login to all iscsi portals, no need to mount anything
  2. logout from all or one session. logging out from one sometimes
work, but more often does not. Logging out from all simultaneously
triggers problem 100% of the time.
  3. every iSCSI session we had befor makes kworker to spin. In my
case there are 4 portals to NetApp.  `l > /proc/sysrq-trigger` shows
following stack traces per kworker spinning:

[19806.968333] Call Trace:
[19806.968347]  scsi_remove_device+0x19/0x60 [scsi_mod]
[19806.968354]  scsi_remove_target+0x167/0x1b0 [scsi_mod]
[19806.968355]  iscsi_free_session+0x383/0x430 [scsi_transport_iscsi]
[19806.968366]  process_one_work+0x144/0x350
[19806.968367]  worker_thread+0x4d/0x3e0
[19806.968369]  kthread+0xfc/0x130
[19806.968370]  ? rescuer_thread+0x310/0x310
[19806.968371]  ? kthread_park+0x60/0x60
[19806.968372]  ? do_syscall_64+0xe9/0x1c0
[19806.968374]  ret_from_fork+0x35/0x40



  4. if I do `multipath -F; for d in $(iscsiadm -m session -P3 |awk
'/scsi disk/ {print $4}'); do echo 1 > /sys/block/$d/device/delete;
done` before logging out, it works just fine
  5. it is reproducible 100% of the time, so I you want me to collect
some data, I can run commands for you :)

Any help is greatly appreciated.


Software versions:
Kernel version is 4.14.16-coreos (CoreOS 1632.2.1)
iscsid version 2.0-873
multipath-tools 0.6.4
no iSCSI offloading

Quick check shows that problem occurred between 4.13.16 and 4.14.0-rc8

--_271B2D83-AD35-42F6-9921-B8250BBAEA75_
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="utf-8"

<html xmlns:o=3D"urn:schemas-microsoft-com:office:office" xmlns:w=3D"urn:sc=
hemas-microsoft-com:office:word" xmlns:m=3D"http://schemas.microsoft.com/of=
fice/2004/12/omml" xmlns=3D"http://www.w3.org/TR/REC-html40"><head><meta ht=
tp-equiv=3DContent-Type content=3D"text/html; charset=3Dutf-8"><meta name=
=3DGenerator content=3D"Microsoft Word 15 (filtered medium)"><style><!--
/* Font Definitions */
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri",sans-serif;}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:#954F72;
	text-decoration:underline;}
.MsoChpDefault
	{mso-style-type:export-only;}
@page WordSection1
	{size:612.0pt 792.0pt;
	margin:72.0pt 72.0pt 72.0pt 72.0pt;}
div.WordSection1
	{page:WordSection1;}
--></style></head><body lang=3DEN-GB link=3Dblue vlink=3D"#954F72"><div cla=
ss=3DWordSection1><p class=3DMsoNormal>Hello All,</p><p class=3DMsoNormal><=
o:p>&nbsp;</o:p></p><p class=3DMsoNormal>I am investigating strange behavio=
ur described here</p><p class=3DMsoNormal>https://github.com/coreos/bugs/is=
sues/2357 and would like to ask for</p><p class=3DMsoNormal>help/advice to =
diagnose it further.</p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=
=3DMsoNormal>It all boils down to kworker spinning 100% of CPU per iSCSI po=
rtal,</p><p class=3DMsoNormal>when logging out from iSCSI sessions. It happ=
ens only if multipathd is</p><p class=3DMsoNormal>running or had run and cr=
eated multipath devices. No problem occur if</p><p class=3DMsoNormal>I mask=
 multipathd, reboot, wait for all scsi devices to be discovered</p><p class=
=3DMsoNormal>and attempt to logout.</p><p class=3DMsoNormal><o:p>&nbsp;</o:=
p></p><p class=3DMsoNormal>=C2=A0 1. start server, login to all iscsi porta=
ls, no need to mount anything</p><p class=3DMsoNormal>=C2=A0 2. logout from=
 all or one session. logging out from one sometimes</p><p class=3DMsoNormal=
>work, but more often does not. Logging out from all simultaneously</p><p c=
lass=3DMsoNormal>triggers problem 100% of the time.</p><p class=3DMsoNormal=
>=C2=A0 3. every iSCSI session we had befor makes kworker to spin. In my</p=
><p class=3DMsoNormal>case there are 4 portals to NetApp.=C2=A0 `l &gt; /pr=
oc/sysrq-trigger` shows</p><p class=3DMsoNormal>following stack traces per =
kworker spinning:</p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DM=
soNormal>[19806.968333] Call Trace:</p><p class=3DMsoNormal>[19806.968347]=
=C2=A0 scsi_remove_device+0x19/0x60 [scsi_mod]</p><p class=3DMsoNormal>[198=
06.968354]=C2=A0 scsi_remove_target+0x167/0x1b0 [scsi_mod]</p><p class=3DMs=
oNormal>[19806.968355]=C2=A0 iscsi_free_session+0x383/0x430 [scsi_transport=
_iscsi]</p><p class=3DMsoNormal>[19806.968366]=C2=A0 process_one_work+0x144=
/0x350</p><p class=3DMsoNormal>[19806.968367]=C2=A0 worker_thread+0x4d/0x3e=
0</p><p class=3DMsoNormal>[19806.968369]=C2=A0 kthread+0xfc/0x130</p><p cla=
ss=3DMsoNormal>[19806.968370]=C2=A0 ? rescuer_thread+0x310/0x310</p><p clas=
s=3DMsoNormal>[19806.968371]=C2=A0 ? kthread_park+0x60/0x60</p><p class=3DM=
soNormal>[19806.968372]=C2=A0 ? do_syscall_64+0xe9/0x1c0</p><p class=3DMsoN=
ormal>[19806.968374]=C2=A0 ret_from_fork+0x35/0x40</p><p class=3DMsoNormal>=
<o:p>&nbsp;</o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DM=
soNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNormal>=C2=A0 4. if I do `multi=
path -F; for d in $(iscsiadm -m session -P3 |awk</p><p class=3DMsoNormal>'/=
scsi disk/ {print $4}'); do echo 1 &gt; /sys/block/$d/device/delete;</p><p =
class=3DMsoNormal>done` before logging out, it works just fine</p><p class=
=3DMsoNormal>=C2=A0 5. it is reproducible 100% of the time, so I you want m=
e to collect</p><p class=3DMsoNormal>some data, I can run commands for you =
:)</p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNormal>Any he=
lp is greatly appreciated.</p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNormal>Software versio=
ns:</p><p class=3DMsoNormal>Kernel version is 4.14.16-coreos (CoreOS 1632.2=
.1)</p><p class=3DMsoNormal>iscsid version 2.0-873</p><p class=3DMsoNormal>=
multipath-tools 0.6.4</p><p class=3DMsoNormal>no iSCSI offloading</p><p cla=
ss=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNormal>Quick check shows =
that problem occurred between 4.13.16 and 4.14.0-rc8</p></div></body></html=
>=

--_271B2D83-AD35-42F6-9921-B8250BBAEA75_--


--===============6602825021501964760==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6602825021501964760==--

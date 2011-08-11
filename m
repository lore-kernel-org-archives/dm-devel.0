From: <Yanqing_Liu@Dell.com>
Subject: Kernel panic with kmpathd
Date: Thu, 11 Aug 2011 11:07:15 -0500
Message-ID: <DB6E482E89290547898851B8CC9D81103859C5CC@AUSX7MCPS302.AMER.DELL.COM>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8355499164394724078=="
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
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

--===============8355499164394724078==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_DB6E482E89290547898851B8CC9D81103859C5CCAUSX7MCPS302AME_"

--_000_DB6E482E89290547898851B8CC9D81103859C5CCAUSX7MCPS302AME_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hello,

In running IO and failover/failback testing with Dell MD3600f, we ran into =
a kernel panic (NULL pointer dereference) with process kmpathd. Here is the=
 captured serial output for this.

It will usually lead to host panic or hang.

Any idea what caused this problem?


14:23:01:757  /dev/ttyS0>
14:23:01:757  /dev/ttyS0>end_request: I/O error, dev sdf, sector 2922776
14:23:01:761  /dev/ttyS0>
14:23:01:801  /dev/ttyS0>end_request: I/O error, dev sdf, sector 2919704
14:23:01:801  /dev/ttyS0>
14:23:01:825  /dev/ttyS0>end_request: I/O error, dev sdf, sector 2893056
14:23:01:829  /dev/ttyS0>
14:23:01:861  /dev/ttyS0>end_request: I/O error, dev sdf, sector 2921752
14:23:01:865  /dev/ttyS0>
14:23:02:013  /dev/ttyS0>end_request: I/O error, dev sdf, sector 2924832
14:23:02:017  /dev/ttyS0>
14:23:22:081  /dev/ttyS0>device-mapper: multipath: Failing path 65:32.
14:23:22:085  /dev/ttyS0>
14:23:43:877  /dev/ttyS0>Unable to handle kernel NULL pointer dereference a=
t 0000000000000008 RIP:
14:23:43:885  /dev/ttyS0>
14:23:43:885  /dev/ttyS0> [<ffffffff8004d77e>] run_workqueue+0x69/0xf6
14:23:43:889  /dev/ttyS0>
14:23:43:889  /dev/ttyS0>PGD 2011cd067 PUD 1f051d067 PMD 0
14:23:43:889  /dev/ttyS0>
14:23:43:889  /dev/ttyS0>Oops: 0002 [1] SMP
14:23:43:893  /dev/ttyS0>
14:23:43:893  /dev/ttyS0>last sysfs file: /devices/pci0000:00/0000:00:07.0/=
0000:06:00.1/host4/rport-4:0-0/targ
14:23:43:901  /dev/ttyS0>et4:0:0/4:0:0:10/timeout
14:23:43:901  /dev/ttyS0>
14:23:43:901  /dev/ttyS0>CPU 9
14:23:43:905  /dev/ttyS0>
14:23:43:905  /dev/ttyS0>Modules linked in: autofs4 hidp nls_utf8 cifs rfco=
mm l2cap bluetooth lockd sunrpc be2iscsi ib_iser rdma_cm ib
14:23:43:913  /dev/ttyS0>_cm iw_cm ib_sa ib_mad ib_addr iscsi_tcp bnx2i cni=
c ipv6 xfrm_nalgo crypto_api uio cxgb3i iw_cxgb3 ib_core cxg
14:23:43:921  /dev/ttyS0>b3 8021q libiscsi_tcp libiscsi2 scsi_transport_isc=
si2 scsi_transport_iscsi loop dm_round_robin s
14:23:43:933  /dev/ttyS0>csi_dh_rdac(U) dm_multipath scsi_dh video backligh=
t sbs power_meter hwmon i2c_ec i2c_core dell_wmi wmi b
14:23:43:941  /dev/ttyS0>utton battery asus_acpi acpi_memhotplug ac parport=
_pc lp parport sr_mod cdrom tpm_tis tpm i7core_edac edac
14:23:43:949  /dev/ttyS0>_mc tpm_bios serio_raw sg(U) bnx2 pcspkr dm_raid45=
 dm_message dm_region_hash dm_mem_cache dm_snapsho
14:23:43:957  /dev/ttyS0>t dm_zero dm_mirror dm_log dm_mod qla2xxx scsi_tra=
nsport_fc ata_piix libata shpchp megaraid_sas sd_mod s
14:23:43:969  /dev/ttyS0>csi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd
14:23:43:973  /dev/ttyS0>
14:23:43:973  /dev/ttyS0>Pid: 4429, comm: kmpathd/9 Tainted: G      2.6.18-=
238.el5 #1
14:23:43:977  /dev/ttyS0>
14:23:43:977  /dev/ttyS0>RIP: 0010:[<ffffffff8004d77e>]  [<ffffffff8004d77e=
>] run_workqueue+0x69/0xf6
14:23:43:985  /dev/ttyS0>
14:23:43:985  /dev/ttyS0>RSP: 0018:ffff81062b4c5e40  EFLAGS: 00010006
14:23:43:989  /dev/ttyS0>
14:23:43:989  /dev/ttyS0>RAX: 0000000000000000 RBX: ffff81062e588ea0 RCX: 0=
000000000000000
14:23:43:993  /dev/ttyS0>
14:23:43:993  /dev/ttyS0>RDX: 0000000000000000 RSI: 0000000000000246 RDI: f=
fff81032f972140
14:23:44:001  /dev/ttyS0>
14:23:44:001  /dev/ttyS0>RBP: ffff81062e588ea8 R08: ffff81032f972190 R09: 0=
00000000052ac18
14:23:44:005  /dev/ttyS0>
14:23:44:005  /dev/ttyS0>R10: 0000000000000000 R11: ffff810085c03af0 R12: f=
fff81032f972140
14:23:44:009  /dev/ttyS0>
14:23:44:009  /dev/ttyS0>R13: 0000000000000246 R14: 0000000000000000 R15: 0=
000000000000000
14:23:44:017  /dev/ttyS0>
14:23:44:017  /dev/ttyS0>FS:  0000000000000000(0000) GS:ffff81032fdd2840(00=
00) knlGS:0000000000000000
14:23:44:025  /dev/ttyS0>
14:23:44:025  /dev/ttyS0>CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
14:23:44:029  /dev/ttyS0>
14:23:44:029  /dev/ttyS0>CR2: 0000000000000008 CR3: 00000001d98a3000 CR4: 0=
0000000000006e0
14:23:44:033  /dev/ttyS0>
14:23:44:033  /dev/ttyS0>Process kmpathd/9 (pid: 4429, threadinfo ffff81062=
b4c4000, task ffff81032d2300c0)
14:23:44:063  /dev/ttyS0>
14:23:44:063  /dev/ttyS0>Stack:  ffff81062b4c5e80 ffff81032f972140 ffffffff=
80049ff6 ffff81062b435da8
14:23:44:065  /dev/ttyS0>
14:23:44:065  /dev/ttyS0> 0000000000000282 ffff81062b435d98 ffffffff800a269=
c ffffffff8004a0e6
14:23:44:065  /dev/ttyS0>
14:23:44:065  /dev/ttyS0> 0000000000000000 ffff81032d2300c0 ffffffff8008e40=
a 0000000000100100
14:23:44:065  /dev/ttyS0>
14:23:44:065  /dev/ttyS0>Call Trace:
14:23:44:065  /dev/ttyS0>
14:23:44:065  /dev/ttyS0> [<ffffffff80049ff6>] worker_thread+0x0/0x122
14:23:44:065  /dev/ttyS0>
14:23:44:065  /dev/ttyS0> [<ffffffff800a269c>] keventd_create_kthread+0x0/0=
xc4
14:23:44:071  /dev/ttyS0>
14:23:44:071  /dev/ttyS0> [<ffffffff8004a0e6>] worker_thread+0xf0/0x122
14:23:44:073  /dev/ttyS0>
14:23:44:073  /dev/ttyS0> [<ffffffff8008e40a>] default_wake_function+0x0/0x=
e
14:23:44:077  /dev/ttyS0>
14:23:44:077  /dev/ttyS0> [<ffffffff800a269c>] keventd_create_kthread+0x0/0=
xc4
14:23:44:085  /dev/ttyS0>
14:23:44:085  /dev/ttyS0> [<ffffffff80032974>] kthread+0xfe/0x132
14:23:44:089  /dev/ttyS0>
14:23:44:089  /dev/ttyS0> [<ffffffff8005dfb1>] child_rip+0xa/0x11
14:23:44:089  /dev/ttyS0>
14:23:44:089  /dev/ttyS0> [<ffffffff800a269c>] keventd_create_kthread+0x0/0=
xc4
14:23:44:097  /dev/ttyS0>
14:23:44:097  /dev/ttyS0> [<ffffffff80032876>] kthread+0x0/0x132
14:23:44:101  /dev/ttyS0>
14:23:44:101  /dev/ttyS0> [<ffffffff8005dfa7>] child_rip+0x0/0x11
14:23:44:101  /dev/ttyS0>
14:23:44:101  /dev/ttyS0>
14:23:44:101  /dev/ttyS0>
14:23:44:101  /dev/ttyS0>
14:23:44:105  /dev/ttyS0>
14:23:44:105  /dev/ttyS0>Code: 48 89 42 08 48 89 10 48 89 6d 08 48 89 6d 00=
 e8 76 73 01 00
14:23:44:109  /dev/ttyS0>
14:23:44:109  /dev/ttyS0>RIP  [<ffffffff8004d77e>] run_workqueue+0x69/0xf6
14:23:44:113  /dev/ttyS0>
14:23:44:113  /dev/ttyS0> RSP <ffff81062b4c5e40>
14:23:44:117  /dev/ttyS0>

Thanks,
Yanqing

--_000_DB6E482E89290547898851B8CC9D81103859C5CCAUSX7MCPS302AME_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40"><head><meta http-equiv=3DContent-Type content=
=3D"text/html; charset=3Dus-ascii"><meta name=3DGenerator content=3D"Micros=
oft Word 14 (filtered medium)"><style><!--
/* Font Definitions */
@font-face
	{font-family:SimSun;
	panose-1:2 1 6 0 3 1 1 1 1 1;}
@font-face
	{font-family:SimSun;
	panose-1:2 1 6 0 3 1 1 1 1 1;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:Consolas;
	panose-1:2 11 6 9 2 2 4 3 2 4;}
@font-face
	{font-family:"\@SimSun";
	panose-1:2 1 6 0 3 1 1 1 1 1;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:purple;
	text-decoration:underline;}
p.MsoPlainText, li.MsoPlainText, div.MsoPlainText
	{mso-style-priority:99;
	mso-style-link:"Plain Text Char";
	margin:0in;
	margin-bottom:.0001pt;
	font-size:10.5pt;
	font-family:Consolas;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
span.PlainTextChar
	{mso-style-name:"Plain Text Char";
	mso-style-priority:99;
	mso-style-link:"Plain Text";
	font-family:Consolas;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-family:"Calibri","sans-serif";}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]--></head><body lang=3DEN-US link=3Dblue vli=
nk=3Dpurple><div class=3DWordSection1><p class=3DMsoNormal>Hello,<o:p></o:p=
></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNormal>In runn=
ing IO and failover/failback testing with Dell MD3600f, we ran into a kerne=
l panic (NULL pointer dereference) with process kmpathd. Here is the captur=
ed serial output for this.<o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</=
o:p></p><p class=3DMsoNormal>It will usually lead to host panic or hang.<o:=
p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNormal>=
Any idea what caused this problem?<o:p></o:p></p><p class=3DMsoNormal><o:p>=
&nbsp;</o:p></p><p class=3DMsoPlainText><span style=3D'font-family:"Courier=
 New"'>14:23:01:757&nbsp; /dev/ttyS0&gt;<br>14:23:01:757&nbsp; /dev/ttyS0&g=
t;end_request: I/O error, dev sdf, sector 2922776<br>14:23:01:761&nbsp; /de=
v/ttyS0&gt;<br>14:23:01:801&nbsp; /dev/ttyS0&gt;end_request: I/O error, dev=
 sdf, sector 2919704<br>14:23:01:801&nbsp; /dev/ttyS0&gt;<br>14:23:01:825&n=
bsp; /dev/ttyS0&gt;end_request: I/O error, dev sdf, sector 2893056<br>14:23=
:01:829&nbsp; /dev/ttyS0&gt;<br>14:23:01:861&nbsp; /dev/ttyS0&gt;end_reques=
t: I/O error, dev sdf, sector 2921752<br>14:23:01:865&nbsp; /dev/ttyS0&gt;<=
br>14:23:02:013&nbsp; /dev/ttyS0&gt;end_request: I/O error, dev sdf, sector=
 2924832<br>14:23:02:017&nbsp; /dev/ttyS0&gt;<br>14:23:22:081&nbsp; /dev/tt=
yS0&gt;device-mapper: multipath: Failing path 65:32.<br>14:23:22:085&nbsp; =
/dev/ttyS0&gt;<br>14:23:43:877&nbsp; /dev/ttyS0&gt;Unable to handle kernel =
NULL pointer dereference at 0000000000000008 RIP: <br>14:23:43:885&nbsp; /d=
ev/ttyS0&gt;<br>14:23:43:885&nbsp; /dev/ttyS0&gt; [&lt;ffffffff8004d77e&gt;=
] run_workqueue+0x69/0xf6<br>14:23:43:889&nbsp; /dev/ttyS0&gt;<br>14:23:43:=
889&nbsp; /dev/ttyS0&gt;PGD 2011cd067 PUD 1f051d067 PMD 0 <br>14:23:43:889&=
nbsp; /dev/ttyS0&gt;<br>14:23:43:889&nbsp; /dev/ttyS0&gt;Oops: 0002 [1] SMP=
 <br>14:23:43:893&nbsp; /dev/ttyS0&gt;<br>14:23:43:893&nbsp; /dev/ttyS0&gt;=
last sysfs file: /devices/pci0000:00/0000:00:07.0/0000:06:00.1/host4/rport-=
4:0-0/targ<br>14:23:43:901&nbsp; /dev/ttyS0&gt;et4:0:0/4:0:0:10/timeout<br>=
14:23:43:901&nbsp; /dev/ttyS0&gt;<br>14:23:43:901&nbsp; /dev/ttyS0&gt;CPU 9=
 <br>14:23:43:905&nbsp; /dev/ttyS0&gt;<br>14:23:43:905&nbsp; /dev/ttyS0&gt;=
Modules linked in: autofs4 hidp nls_utf8 cifs rfcomm l2cap bluetooth lockd =
sunrpc be2iscsi ib_iser rdma_cm ib<br>14:23:43:913&nbsp; /dev/ttyS0&gt;_cm =
iw_cm ib_sa ib_mad ib_addr iscsi_tcp bnx2i cnic ipv6 xfrm_nalgo crypto_api =
uio cxgb3i iw_cxgb3 ib_core cxg<br>14:23:43:921&nbsp; /dev/ttyS0&gt;b3 8021=
q libiscsi_tcp libiscsi2 scsi_transport_iscsi2 scsi_transport_iscsi loop dm=
_round_robin s<br>14:23:43:933&nbsp; /dev/ttyS0&gt;csi_dh_rdac(U) dm_multip=
ath scsi_dh video backlight sbs power_meter hwmon i2c_ec i2c_core dell_wmi =
wmi b<br>14:23:43:941&nbsp; /dev/ttyS0&gt;utton battery asus_acpi acpi_memh=
otplug ac parport_pc lp parport sr_mod cdrom tpm_tis tpm i7core_edac edac<b=
r>14:23:43:949&nbsp; /dev/ttyS0&gt;_mc tpm_bios serio_raw sg(U) bnx2 pcspkr=
 dm_raid45 dm_message dm_region_hash dm_mem_cache dm_snapsho<br>14:23:43:95=
7&nbsp; /dev/ttyS0&gt;t dm_zero dm_mirror dm_log dm_mod qla2xxx scsi_transp=
ort_fc ata_piix libata shpchp megaraid_sas sd_mod s<br>14:23:43:969&nbsp; /=
dev/ttyS0&gt;csi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd<br>14:23:43:973&nb=
sp; /dev/ttyS0&gt;<br>14:23:43:973&nbsp; /dev/ttyS0&gt;Pid: 4429, comm: kmp=
athd/9 Tainted: G&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2.6.18-238.el5 #1<br>14:23:=
43:977&nbsp; /dev/ttyS0&gt;<br>14:23:43:977&nbsp; /dev/ttyS0&gt;RIP: 0010:[=
&lt;ffffffff8004d77e&gt;]&nbsp; [&lt;ffffffff8004d77e&gt;] run_workqueue+0x=
69/0xf6<br>14:23:43:985&nbsp; /dev/ttyS0&gt;<br>14:23:43:985&nbsp; /dev/tty=
S0&gt;RSP: 0018:ffff81062b4c5e40&nbsp; EFLAGS: 00010006<br>14:23:43:989&nbs=
p; /dev/ttyS0&gt;<br>14:23:43:989&nbsp; /dev/ttyS0&gt;RAX: 0000000000000000=
 RBX: ffff81062e588ea0 RCX: 0000000000000000<br>14:23:43:993&nbsp; /dev/tty=
S0&gt;<br>14:23:43:993&nbsp; /dev/ttyS0&gt;RDX: 0000000000000000 RSI: 00000=
00000000246 RDI: ffff81032f972140<br>14:23:44:001&nbsp; /dev/ttyS0&gt;<br>1=
4:23:44:001&nbsp; /dev/ttyS0&gt;RBP: ffff81062e588ea8 R08: ffff81032f972190=
 R09: 000000000052ac18<br>14:23:44:005&nbsp; /dev/ttyS0&gt;<br>14:23:44:005=
&nbsp; /dev/ttyS0&gt;R10: 0000000000000000 R11: ffff810085c03af0 R12: ffff8=
1032f972140<br>14:23:44:009&nbsp; /dev/ttyS0&gt;<br>14:23:44:009&nbsp; /dev=
/ttyS0&gt;R13: 0000000000000246 R14: 0000000000000000 R15: 0000000000000000=
<br>14:23:44:017&nbsp; /dev/ttyS0&gt;<br>14:23:44:017&nbsp; /dev/ttyS0&gt;F=
S:&nbsp; 0000000000000000(0000) GS:ffff81032fdd2840(0000) knlGS:00000000000=
00000<br>14:23:44:025&nbsp; /dev/ttyS0&gt;<br>14:23:44:025&nbsp; /dev/ttyS0=
&gt;CS:&nbsp; 0010 DS: 0018 ES: 0018 CR0: 000000008005003b<br>14:23:44:029&=
nbsp; /dev/ttyS0&gt;<br>14:23:44:029&nbsp; /dev/ttyS0&gt;CR2: 0000000000000=
008 CR3: 00000001d98a3000 CR4: 00000000000006e0<br>14:23:44:033&nbsp; /dev/=
ttyS0&gt;<br>14:23:44:033&nbsp; /dev/ttyS0&gt;Process kmpathd/9 (pid: 4429,=
 threadinfo ffff81062b4c4000, task ffff81032d2300c0)<br>14:23:44:063&nbsp; =
/dev/ttyS0&gt;<br>14:23:44:063&nbsp; /dev/ttyS0&gt;Stack:&nbsp; ffff81062b4=
c5e80 ffff81032f972140 ffffffff80049ff6 ffff81062b435da8<br>14:23:44:065&nb=
sp; /dev/ttyS0&gt;<br>14:23:44:065&nbsp; /dev/ttyS0&gt; 0000000000000282 ff=
ff81062b435d98 ffffffff800a269c ffffffff8004a0e6<br>14:23:44:065&nbsp; /dev=
/ttyS0&gt;<br>14:23:44:065&nbsp; /dev/ttyS0&gt; 0000000000000000 ffff81032d=
2300c0 ffffffff8008e40a 0000000000100100<br>14:23:44:065 &nbsp;/dev/ttyS0&g=
t;<br>14:23:44:065&nbsp; /dev/ttyS0&gt;Call Trace:<br>14:23:44:065&nbsp; /d=
ev/ttyS0&gt;<br>14:23:44:065&nbsp; /dev/ttyS0&gt; [&lt;ffffffff80049ff6&gt;=
] worker_thread+0x0/0x122<br>14:23:44:065&nbsp; /dev/ttyS0&gt;<br>14:23:44:=
065&nbsp; /dev/ttyS0&gt; [&lt;ffffffff800a269c&gt;] keventd_create_kthread+=
0x0/0xc4<br>14:23:44:071&nbsp; /dev/ttyS0&gt;<br>14:23:44:071&nbsp; /dev/tt=
yS0&gt; [&lt;ffffffff8004a0e6&gt;] worker_thread+0xf0/0x122<br>14:23:44:073=
&nbsp; /dev/ttyS0&gt;<br>14:23:44:073&nbsp; /dev/ttyS0&gt; [&lt;ffffffff800=
8e40a&gt;] default_wake_function+0x0/0xe<br>14:23:44:077&nbsp; /dev/ttyS0&g=
t;<br>14:23:44:077&nbsp; /dev/ttyS0&gt; [&lt;ffffffff800a269c&gt;] keventd_=
create_kthread+0x0/0xc4<br>14:23:44:085&nbsp; /dev/ttyS0&gt;<br>14:23:44:08=
5&nbsp; /dev/ttyS0&gt; [&lt;ffffffff80032974&gt;] kthread+0xfe/0x132<br>14:=
23:44:089&nbsp; /dev/ttyS0&gt;<br>14:23:44:089&nbsp; /dev/ttyS0&gt; [&lt;ff=
ffffff8005dfb1&gt;] child_rip+0xa/0x11<br>14:23:44:089&nbsp; /dev/ttyS0&gt;=
<br>14:23:44:089&nbsp; /dev/ttyS0&gt; [&lt;ffffffff800a269c&gt;] keventd_cr=
eate_kthread+0x0/0xc4<br>14:23:44:097&nbsp; /dev/ttyS0&gt;<br>14:23:44:097&=
nbsp; /dev/ttyS0&gt; [&lt;ffffffff80032876&gt;] kthread+0x0/0x132<br>14:23:=
44:101&nbsp; /dev/ttyS0&gt;<br>14:23:44:101&nbsp; /dev/ttyS0&gt; [&lt;fffff=
fff8005dfa7&gt;] child_rip+0x0/0x11<br>14:23:44:101&nbsp; /dev/ttyS0&gt;<br=
>14:23:44:101&nbsp; /dev/ttyS0&gt;<br>14:23:44:101&nbsp; /dev/ttyS0&gt;<br>=
14:23:44:101&nbsp; /dev/ttyS0&gt;<br>14:23:44:105&nbsp; /dev/ttyS0&gt;<br>1=
4:23:44:105&nbsp; /dev/ttyS0&gt;Code: 48 89 42 08 48 89 10 48 89 6d 08 48 8=
9 6d 00 e8 76 73 01 00 <br>14:23:44:109&nbsp; /dev/ttyS0&gt;<br>14:23:44:10=
9&nbsp; /dev/ttyS0&gt;RIP&nbsp; [&lt;ffffffff8004d77e&gt;] run_workqueue+0x=
69/0xf6<br>14:23:44:113&nbsp; /dev/ttyS0&gt;<br>14:23:44:113&nbsp; /dev/tty=
S0&gt; RSP &lt;ffff81062b4c5e40&gt;<br>14:23:44:117&nbsp; /dev/ttyS0&gt;</s=
pan><o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMso=
Normal>Thanks,<o:p></o:p></p><p class=3DMsoNormal>Yanqing<o:p></o:p></p></d=
iv></body></html>=

--_000_DB6E482E89290547898851B8CC9D81103859C5CCAUSX7MCPS302AME_--


--===============8355499164394724078==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8355499164394724078==--

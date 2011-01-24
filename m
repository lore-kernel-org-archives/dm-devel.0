From: <Menny_Hamburger@Dell.com>
Subject: Re: multipath - reference count on pgpath
Date: Mon, 24 Jan 2011 15:58:24 +0000
Message-ID: <D8C50530D6022F40A817A35C40CC06A7064B3085D5@DUBX7MCDUB01.EMEA.DELL.COM>
References: <D8C50530D6022F40A817A35C40CC06A7064B2CD9F2@DUBX7MCDUB01.EMEA.DELL.COM>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3994307789018710389=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <D8C50530D6022F40A817A35C40CC06A7064B2CD9F2@DUBX7MCDUB01.EMEA.DELL.COM>
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

--===============3994307789018710389==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_D8C50530D6022F40A817A35C40CC06A7064B3085D5DUBX7MCDUB01E_"

--_000_D8C50530D6022F40A817A35C40CC06A7064B3085D5DUBX7MCDUB01E_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

Patch was premature so I am re-posting my initial question:
This panic occurs quite frequently when multipathd is restarted (either aft=
er devices are added or removed) and at the same time some other script doe=
s udevtrigger, udevsettle.
I have fixed our configuration/monitoring scripts to avoid this panic, howe=
ver this only hides the problem and does not solve it.
I would appreciate any input on this issue.

Thanks,
Menny

From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On B=
ehalf Of Hamburger, Menny
Sent: 23 January, 2011 11:23
To: dm-devel@redhat.com
Subject: [dm-devel] multipath - reference count on pgpath

Hi,

We are using multipath over ISCSI storage that uses the RDAC hardware handl=
er (RHEL5.5)
When we have two running scripts doing the following:

1)      Configure new LUNs mapping file

udevsettle

multipathd restart

udevtrigger

udevsettle

2)      udevtrigger

udevsettle





We get the kernel panic below.

Although I know that the usage here is problematic (I already modified the =
scripts), the kernel should protect itself from situations like this.

2011 Jan 20 02:53:08 172.19.58.130 NOTICE: Unable to handle kernel paging r=
equest
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: at 0000000100000010 RIP:
2011 Jan 20 02:53:08 node0 INFO: kernel: sd 350:0:0:0: rdac: array MD3200i-=
c7-d7, ctlr 1, MODE_SELECT completed
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: [<ffffffff881b713f>] :dm_multipa=
th:pg_init_done+0x2f/0x1c0
2011 Jan 20 02:53:08 node0 ALERT: kernel: Unable to handle kernel paging re=
quest at 0000000100000010 RIP:
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: PGD 0
2011 Jan 20 02:53:08 node0 ALERT: kernel: [<ffffffff881b713f>] :dm_multipat=
h:pg_init_done+0x2f/0x1c0
2011 Jan 20 02:53:08 172.19.58.130 NOTICE:
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: Oops: 0000 [1]
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: SMP
2011 Jan 20 02:53:08 172.19.58.130 NOTICE:
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: last sysfs file: /devices/platfo=
rm/host353/session76/target353:0:0/353:0:0:0/rev
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: CPU 3
2011 Jan 20 02:53:08 172.19.58.130 NOTICE:
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: Modules linked in:
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: iscsi_tcp(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: libiscsi_tcp(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: libiscsi2(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: scsi_transport_iscsi2(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: scsi_transport_iscsi(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: ipmi_si(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: dell_rbu(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: scsi_dh_rdac(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: dm_rdac(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: dm_queue_depth(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: dm_round_robin(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: xt_tcpudp(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: ipt_SYSRQ(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: netconsole(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: iptable_filter(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: ip_tables(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: vfat(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: fat(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: usb_storage(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: mptctl(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: exa_ioctls(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: nfs(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: lockd(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: nfs_acl(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: x_tables(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: sunrpc(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: ipmi_devintf(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: ipmi_msghandler(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: bonding1(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: bonding(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: ipv6(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: xfrm_nalgo(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: crypto_api(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: dm_mirror(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: dm_log(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: dm_multipath(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: scsi_dh(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: dm_mod(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: video(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: hwmon(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: backlight(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: sbs(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: i2c_ec(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: i2c_core(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: button(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: battery(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: asus_acpi(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: ac(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: sr_mod(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: cdrom(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: joydev(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: sg(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: bnx2(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: pcspkr(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: ata_piix(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: libata(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: mptsas(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: mptscsih(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: mptbase(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: scsi_transport_sas(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: sd_mod(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: scsi_mod(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: ext3(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: jbd(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: uhci_hcd(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: ohci_hcd(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: ehci_hcd(U)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE:
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: Pid: 23040, comm: kmpath_rdacd T=
ainted: G      2.6.18-164sys #1
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: RIP: 0010:[<ffffffff881b713f>]
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: [<ffffffff881b713f>] :dm_multipa=
th:pg_init_done+0x2f/0x1c0
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: RSP: 0018:ffff810081e71d40  EFLA=
GS: 00010293
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: RAX: ffffffff881b7110 RBX: ffff8=
1004c488780 RCX: ffff810080721c00
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: RDX: ffff81004c488780 RSI: 00000=
00000000000 RDI: ffff810071521ea0
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: RBP: 0000000000000000 R08: 00000=
00000000000 R09: 0000000000000000
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: R10: 0000000000000000 R11: fffff=
fff80087ee0 R12: ffff810080721c00
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: R13: ffff810087a247d8 R14: 00000=
00100000000 R15: ffff810071521e80
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: FS:  0000000000000000(0000) GS:f=
fff810107f5da40(0000) knlGS:0000000000000000
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: CS:  0010 DS: 0018 ES: 0018 CR0:=
 000000008005003b
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: CR2: 0000000100000010 CR3: 00000=
000592df000 CR4: 00000000000006e0
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: Process kmpath_rdacd (pid: 23040=
, threadinfo ffff810081e70000, task ffff81008a0f5080)
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: Stack:
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: 0000000000000282
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: ffff81004c488780
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: ffff81006c14fc00
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: ffff810080721c00
2011 Jan 20 02:53:08 172.19.58.130 NOTICE:
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: ffff810087a247d8
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: 0000000000000000
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: ffff81006c14fc62
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: ffffffff883bcdf7
2011 Jan 20 02:53:08 172.19.58.130 NOTICE:
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: 0000000010008040
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: ffff81008c7f65c0
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: ffff810081e71e70
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: ffff810081e71dd0
2011 Jan 20 02:53:08 172.19.58.130 NOTICE:
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: Call Trace:
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: [<ffffffff883bcdf7>] :scsi_dh_rd=
ac:send_mode_select+0x477/0x4b0
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: [<ffffffff80032183>] __wake_up+0=
x43/0x70
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: [<ffffffff883bc980>] :scsi_dh_rd=
ac:send_mode_select+0x0/0x4b0
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: [<ffffffff800561a3>] run_workque=
ue+0xb3/0x110
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: [<ffffffff80052180>] worker_thre=
ad+0x0/0x150
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: [<ffffffff800b33b0>] keventd_cre=
ate_kthread+0x0/0xa0
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: [<ffffffff80052291>] worker_thre=
ad+0x111/0x150
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: [<ffffffff8009ca00>] default_wak=
e_function+0x0/0x10
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: [<ffffffff80052180>] worker_thre=
ad+0x0/0x150
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: [<ffffffff800373c9>] kthread+0xd=
9/0x120
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: [<ffffffff80068fb1>] child_rip+0=
xa/0x11
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: [<ffffffff800b33b0>] keventd_cre=
ate_kthread+0x0/0xa0
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: [<ffffffff800372f0>] kthread+0x0=
/0x120
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: [<ffffffff80068fa7>] child_rip+0=
x0/0x11
2011 Jan 20 02:53:08 172.19.58.130 NOTICE:
2011 Jan 20 02:53:08 172.19.58.130 NOTICE:
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: Code:
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: 49
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: 8b
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: 5e
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: 10
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: 77
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: 7b
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: 89
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: f0
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: ff
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: 24
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: c5
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: a8
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: 8c
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: 1b
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: 88
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: c7
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: 44
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: 24
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: 04
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: 00
2011 Jan 20 02:53:08 172.19.58.130 NOTICE:
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: RIP
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: [<ffffffff881b713f>] :dm_multipa=
th:pg_init_done+0x2f/0x1c0
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: RSP <ffff810081e71d40>
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: CR2: 0000000100000010
2011 Jan 20 02:53:08 172.19.58.130 NOTICE:
2011 Jan 20 02:53:08 172.19.58.130 EMERG: Kernel panic - not syncing: Fatal=
 exception
2011 Jan 20 02:53:08 172.19.58.130 NOTICE:
2011 Jan 20 02:53:08 172.19.58.130 EMERG: Rebooting in 1 seconds..

Seems that the pgpath is deleted in dm-mpath while send_mode_select is in p=
rogress and when it calls pg_init_done we get an OOPs.
I wonder if a reference count on pgpath will do the trick here.

Menny Hamburger
Engineer
Dell | IDC
office +972 97698789,  fax +972 97698889
Dell IDC. 4 Hacharoshet St, Raanana 43657, Israel


--_000_D8C50530D6022F40A817A35C40CC06A7064B3085D5DUBX7MCDUB01E_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:x=3D"urn:schemas-microsoft-com:office:excel" xmlns:p=3D"urn:schemas-m=
icrosoft-com:office:powerpoint" xmlns:a=3D"urn:schemas-microsoft-com:office=
:access" xmlns:dt=3D"uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:s=3D"=
uuid:BDC6E3F0-6DA3-11d1-A2A3-00AA00C14882" xmlns:rs=3D"urn:schemas-microsof=
t-com:rowset" xmlns:z=3D"#RowsetSchema" xmlns:b=3D"urn:schemas-microsoft-co=
m:office:publisher" xmlns:ss=3D"urn:schemas-microsoft-com:office:spreadshee=
t" xmlns:c=3D"urn:schemas-microsoft-com:office:component:spreadsheet" xmlns=
:odc=3D"urn:schemas-microsoft-com:office:odc" xmlns:oa=3D"urn:schemas-micro=
soft-com:office:activation" xmlns:html=3D"http://www.w3.org/TR/REC-html40" =
xmlns:q=3D"http://schemas.xmlsoap.org/soap/envelope/" xmlns:rtc=3D"http://m=
icrosoft.com/officenet/conferencing" xmlns:D=3D"DAV:" xmlns:Repl=3D"http://=
schemas.microsoft.com/repl/" xmlns:mt=3D"http://schemas.microsoft.com/share=
point/soap/meetings/" xmlns:x2=3D"http://schemas.microsoft.com/office/excel=
/2003/xml" xmlns:ppda=3D"http://www.passport.com/NameSpace.xsd" xmlns:ois=
=3D"http://schemas.microsoft.com/sharepoint/soap/ois/" xmlns:dir=3D"http://=
schemas.microsoft.com/sharepoint/soap/directory/" xmlns:ds=3D"http://www.w3=
.org/2000/09/xmldsig#" xmlns:dsp=3D"http://schemas.microsoft.com/sharepoint=
/dsp" xmlns:udc=3D"http://schemas.microsoft.com/data/udc" xmlns:xsd=3D"http=
://www.w3.org/2001/XMLSchema" xmlns:sub=3D"http://schemas.microsoft.com/sha=
repoint/soap/2002/1/alerts/" xmlns:ec=3D"http://www.w3.org/2001/04/xmlenc#"=
 xmlns:sp=3D"http://schemas.microsoft.com/sharepoint/" xmlns:sps=3D"http://=
schemas.microsoft.com/sharepoint/soap/" xmlns:xsi=3D"http://www.w3.org/2001=
/XMLSchema-instance" xmlns:udcs=3D"http://schemas.microsoft.com/data/udc/so=
ap" xmlns:udcxf=3D"http://schemas.microsoft.com/data/udc/xmlfile" xmlns:udc=
p2p=3D"http://schemas.microsoft.com/data/udc/parttopart" xmlns:wf=3D"http:/=
/schemas.microsoft.com/sharepoint/soap/workflow/" xmlns:dsss=3D"http://sche=
mas.microsoft.com/office/2006/digsig-setup" xmlns:dssi=3D"http://schemas.mi=
crosoft.com/office/2006/digsig" xmlns:mdssi=3D"http://schemas.openxmlformat=
s.org/package/2006/digital-signature" xmlns:mver=3D"http://schemas.openxmlf=
ormats.org/markup-compatibility/2006" xmlns:m=3D"http://schemas.microsoft.c=
om/office/2004/12/omml" xmlns:mrels=3D"http://schemas.openxmlformats.org/pa=
ckage/2006/relationships" xmlns:spwp=3D"http://microsoft.com/sharepoint/web=
partpages" xmlns:ex12t=3D"http://schemas.microsoft.com/exchange/services/20=
06/types" xmlns:ex12m=3D"http://schemas.microsoft.com/exchange/services/200=
6/messages" xmlns:pptsl=3D"http://schemas.microsoft.com/sharepoint/soap/Sli=
deLibrary/" xmlns:spsl=3D"http://microsoft.com/webservices/SharePointPortal=
Server/PublishedLinksService" xmlns:Z=3D"urn:schemas-microsoft-com:" xmlns:=
st=3D"&#1;" xmlns=3D"http://www.w3.org/TR/REC-html40"><head><meta http-equi=
v=3DContent-Type content=3D"text/html; charset=3Dus-ascii"><meta name=3DGen=
erator content=3D"Microsoft Word 12 (filtered medium)"><style><!--
/* Font Definitions */
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:Tahoma;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
@font-face
	{font-family:"Trebuchet MS";
	panose-1:2 11 6 3 2 2 2 2 2 4;}
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
p.MsoListParagraph, li.MsoListParagraph, div.MsoListParagraph
	{mso-style-priority:34;
	margin-top:0in;
	margin-right:0in;
	margin-bottom:0in;
	margin-left:.5in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
span.EmailStyle18
	{mso-style-type:personal;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
span.EmailStyle19
	{mso-style-type:personal-reply;
	font-family:"Calibri","sans-serif";
	color:#1F497D;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-size:10.0pt;}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
/* List Definitions */
@list l0
	{mso-list-id:160581969;
	mso-list-type:hybrid;
	mso-list-template-ids:620035206 67698705 67698713 67698715 67698703 676987=
13 67698715 67698703 67698713 67698715;}
@list l0:level1
	{mso-level-text:"%1\)";
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;}
@list l0:level2
	{mso-level-tab-stop:1.0in;
	mso-level-number-position:left;
	text-indent:-.25in;}
@list l0:level3
	{mso-level-tab-stop:1.5in;
	mso-level-number-position:left;
	text-indent:-.25in;}
@list l0:level4
	{mso-level-tab-stop:2.0in;
	mso-level-number-position:left;
	text-indent:-.25in;}
@list l0:level5
	{mso-level-tab-stop:2.5in;
	mso-level-number-position:left;
	text-indent:-.25in;}
@list l0:level6
	{mso-level-tab-stop:3.0in;
	mso-level-number-position:left;
	text-indent:-.25in;}
@list l0:level7
	{mso-level-tab-stop:3.5in;
	mso-level-number-position:left;
	text-indent:-.25in;}
@list l0:level8
	{mso-level-tab-stop:4.0in;
	mso-level-number-position:left;
	text-indent:-.25in;}
@list l0:level9
	{mso-level-tab-stop:4.5in;
	mso-level-number-position:left;
	text-indent:-.25in;}
ol
	{margin-bottom:0in;}
ul
	{margin-bottom:0in;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]--></head><body lang=3DEN-US link=3Dblue vli=
nk=3Dpurple><div class=3DWordSection1><p class=3DMsoNormal><span style=3D'c=
olor:#1F497D'>Hi,<o:p></o:p></span></p><p class=3DMsoNormal><span style=3D'=
color:#1F497D'><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal><span style=
=3D'color:#1F497D'>Patch was premature so I am re-posting my initial questi=
on:<o:p></o:p></span></p><p class=3DMsoNormal><span style=3D'color:#1F497D'=
>This panic occurs quite frequently when multipathd is restarted (either af=
ter devices are added or removed) and at the same time some other script do=
es udevtrigger, udevsettle.<o:p></o:p></span></p><p class=3DMsoNormal><span=
 style=3D'color:#1F497D'>I have fixed our configuration/monitoring scripts =
to avoid this panic, however this only hides the problem and does not solve=
 it.<o:p></o:p></span></p><p class=3DMsoNormal><span style=3D'color:#1F497D=
'>I would appreciate any input on this issue.<o:p></o:p></span></p><p class=
=3DMsoNormal><span style=3D'color:#1F497D'><o:p>&nbsp;</o:p></span></p><p c=
lass=3DMsoNormal><span style=3D'color:#1F497D'>Thanks,<o:p></o:p></span></p=
><p class=3DMsoNormal><span style=3D'color:#1F497D'>Menny<o:p></o:p></span>=
</p><p class=3DMsoNormal><span style=3D'color:#1F497D'><o:p>&nbsp;</o:p></s=
pan></p><div><div style=3D'border:none;border-top:solid #B5C4DF 1.0pt;paddi=
ng:3.0pt 0in 0in 0in'><p class=3DMsoNormal><b><span style=3D'font-size:10.0=
pt;font-family:"Tahoma","sans-serif"'>From:</span></b><span style=3D'font-s=
ize:10.0pt;font-family:"Tahoma","sans-serif"'> dm-devel-bounces@redhat.com =
[mailto:dm-devel-bounces@redhat.com] <b>On Behalf Of </b>Hamburger, Menny<b=
r><b>Sent:</b> 23 January, 2011 11:23<br><b>To:</b> dm-devel@redhat.com<br>=
<b>Subject:</b> [dm-devel] multipath - reference count on pgpath<o:p></o:p>=
</span></p></div></div><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=
=3DMsoNormal>Hi,<o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p=
 class=3DMsoNormal>We are using multipath over ISCSI storage that uses the =
RDAC hardware handler (RHEL5.5)<o:p></o:p></p><p class=3DMsoNormal>When we =
have two running scripts doing the following:<o:p></o:p></p><p class=3DMsoL=
istParagraph style=3D'text-indent:-.25in;mso-list:l0 level1 lfo2'><![if !su=
pportLists]><span style=3D'mso-list:Ignore'>1)<span style=3D'font:7.0pt "Ti=
mes New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span><![endif]><spa=
n dir=3DLTR></span>Configure new LUNs mapping file<o:p></o:p></p><p class=
=3DMsoListParagraph>udevsettle<o:p></o:p></p><p class=3DMsoListParagraph>mu=
ltipathd restart<o:p></o:p></p><p class=3DMsoListParagraph>udevtrigger <o:p=
></o:p></p><p class=3DMsoListParagraph>udevsettle<o:p></o:p></p><p class=3D=
MsoListParagraph style=3D'text-indent:-.25in;mso-list:l0 level1 lfo2'><![if=
 !supportLists]><span style=3D'mso-list:Ignore'>2)<span style=3D'font:7.0pt=
 "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span><![endif]>=
<span dir=3DLTR></span>udevtrigger <o:p></o:p></p><p class=3DMsoListParagra=
ph>udevsettle<o:p></o:p></p><p class=3DMsoListParagraph><o:p>&nbsp;</o:p></=
p><p class=3DMsoListParagraph style=3D'margin-left:0in'><o:p>&nbsp;</o:p></=
p><p class=3DMsoListParagraph style=3D'margin-left:0in'>We get the kernel p=
anic below.<o:p></o:p></p><p class=3DMsoListParagraph style=3D'margin-left:=
0in'>Although I know that the usage here is problematic (I already modified=
 the scripts), the kernel should protect itself from situations like this.<=
o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNorma=
l>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: Unable to handle kernel paging=
 request<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.=
130 NOTICE: at 0000000100000010 RIP: <o:p></o:p></p><p class=3DMsoNormal>20=
11 Jan 20 02:53:08 node0 INFO: kernel: sd 350:0:0:0: rdac: array MD3200i-c7=
-d7, ctlr 1, MODE_SELECT completed<o:p></o:p></p><p class=3DMsoNormal>2011 =
Jan 20 02:53:08 172.19.58.130 NOTICE: [&lt;ffffffff881b713f&gt;] :dm_multip=
ath:pg_init_done+0x2f/0x1c0<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 =
02:53:08 node0 ALERT: kernel: Unable to handle kernel paging request at 000=
0000100000010 RIP: <o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08=
 172.19.58.130 NOTICE: PGD 0 <o:p></o:p></p><p class=3DMsoNormal>2011 Jan 2=
0 02:53:08 node0 ALERT: kernel: [&lt;ffffffff881b713f&gt;] :dm_multipath:pg=
_init_done+0x2f/0x1c0<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:=
08 172.19.58.130 NOTICE: <o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02=
:53:08 172.19.58.130 NOTICE: Oops: 0000 [1] <o:p></o:p></p><p class=3DMsoNo=
rmal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: SMP <o:p></o:p></p><p class=
=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: <o:p></o:p></p><p c=
lass=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: last sysfs file=
: /devices/platform/host353/session76/target353:0:0/353:0:0:0/rev<o:p></o:p=
></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: CPU 3 =
<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTI=
CE: <o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 =
NOTICE: Modules linked in:<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 0=
2:53:08 172.19.58.130 NOTICE: iscsi_tcp(U)<o:p></o:p></p><p class=3DMsoNorm=
al>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: libiscsi_tcp(U)<o:p></o:p></p=
><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: libiscsi2(=
U)<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NO=
TICE: scsi_transport_iscsi2(U)<o:p></o:p></p><p class=3DMsoNormal>2011 Jan =
20 02:53:08 172.19.58.130 NOTICE: scsi_transport_iscsi(U)<o:p></o:p></p><p =
class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: ipmi_si(U)<o:p=
></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: =
dell_rbu(U)<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.=
58.130 NOTICE: scsi_dh_rdac(U)<o:p></o:p></p><p class=3DMsoNormal>2011 Jan =
20 02:53:08 172.19.58.130 NOTICE: dm_rdac(U)<o:p></o:p></p><p class=3DMsoNo=
rmal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: dm_queue_depth(U)<o:p></o:p=
></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: dm_rou=
nd_robin(U)<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.=
58.130 NOTICE: xt_tcpudp(U)<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 =
02:53:08 172.19.58.130 NOTICE: ipt_SYSRQ(U)<o:p></o:p></p><p class=3DMsoNor=
mal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: netconsole(U)<o:p></o:p></p>=
<p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: iptable_fil=
ter(U)<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.13=
0 NOTICE: ip_tables(U)<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53=
:08 172.19.58.130 NOTICE: vfat(U)<o:p></o:p></p><p class=3DMsoNormal>2011 J=
an 20 02:53:08 172.19.58.130 NOTICE: fat(U)<o:p></o:p></p><p class=3DMsoNor=
mal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: usb_storage(U)<o:p></o:p></p=
><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: mptctl(U)<=
o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTIC=
E: exa_ioctls(U)<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 17=
2.19.58.130 NOTICE: nfs(U)<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 0=
2:53:08 172.19.58.130 NOTICE: lockd(U)<o:p></o:p></p><p class=3DMsoNormal>2=
011 Jan 20 02:53:08 172.19.58.130 NOTICE: nfs_acl(U)<o:p></o:p></p><p class=
=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: x_tables(U)<o:p></o=
:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: sunr=
pc(U)<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130=
 NOTICE: ipmi_devintf(U)<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:=
53:08 172.19.58.130 NOTICE: ipmi_msghandler(U)<o:p></o:p></p><p class=3DMso=
Normal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: bonding1(U)<o:p></o:p></p=
><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: bonding(U)=
<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTI=
CE: ipv6(U)<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.=
58.130 NOTICE: xfrm_nalgo(U)<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20=
 02:53:08 172.19.58.130 NOTICE: crypto_api(U)<o:p></o:p></p><p class=3DMsoN=
ormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: dm_mirror(U)<o:p></o:p></p=
><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: dm_log(U)<=
o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTIC=
E: dm_multipath(U)<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 =
172.19.58.130 NOTICE: scsi_dh(U)<o:p></o:p></p><p class=3DMsoNormal>2011 Ja=
n 20 02:53:08 172.19.58.130 NOTICE: dm_mod(U)<o:p></o:p></p><p class=3DMsoN=
ormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: video(U)<o:p></o:p></p><p =
class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: hwmon(U)<o:p><=
/o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: ba=
cklight(U)<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.5=
8.130 NOTICE: sbs(U)<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:0=
8 172.19.58.130 NOTICE: i2c_ec(U)<o:p></o:p></p><p class=3DMsoNormal>2011 J=
an 20 02:53:08 172.19.58.130 NOTICE: i2c_core(U)<o:p></o:p></p><p class=3DM=
soNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: button(U)<o:p></o:p></p=
><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: battery(U)=
<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTI=
CE: asus_acpi(U)<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 17=
2.19.58.130 NOTICE: ac(U)<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02=
:53:08 172.19.58.130 NOTICE: sr_mod(U)<o:p></o:p></p><p class=3DMsoNormal>2=
011 Jan 20 02:53:08 172.19.58.130 NOTICE: cdrom(U)<o:p></o:p></p><p class=
=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: joydev(U)<o:p></o:p=
></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: sg(U)<=
o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTIC=
E: bnx2(U)<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.5=
8.130 NOTICE: pcspkr(U)<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:5=
3:08 172.19.58.130 NOTICE: ata_piix(U)<o:p></o:p></p><p class=3DMsoNormal>2=
011 Jan 20 02:53:08 172.19.58.130 NOTICE: libata(U)<o:p></o:p></p><p class=
=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: mptsas(U)<o:p></o:p=
></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: mptscs=
ih(U)<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130=
 NOTICE: mptbase(U)<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08=
 172.19.58.130 NOTICE: scsi_transport_sas(U)<o:p></o:p></p><p class=3DMsoNo=
rmal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: sd_mod(U)<o:p></o:p></p><p =
class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: scsi_mod(U)<o:=
p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE:=
 ext3(U)<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.=
130 NOTICE: jbd(U)<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 =
172.19.58.130 NOTICE: uhci_hcd(U)<o:p></o:p></p><p class=3DMsoNormal>2011 J=
an 20 02:53:08 172.19.58.130 NOTICE: ohci_hcd(U)<o:p></o:p></p><p class=3DM=
soNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: ehci_hcd(U)<o:p></o:p><=
/p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: <o:p></o=
:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: Pid:=
 23040, comm: kmpath_rdacd Tainted: G&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2.6.18-=
164sys #1<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58=
.130 NOTICE: RIP: 0010:[&lt;ffffffff881b713f&gt;] <o:p></o:p></p><p class=
=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: [&lt;ffffffff881b71=
3f&gt;] :dm_multipath:pg_init_done+0x2f/0x1c0<o:p></o:p></p><p class=3DMsoN=
ormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: RSP: 0018:ffff810081e71d40=
&nbsp; EFLAGS: 00010293<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:5=
3:08 172.19.58.130 NOTICE: RAX: ffffffff881b7110 RBX: ffff81004c488780 RCX:=
 ffff810080721c00<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 1=
72.19.58.130 NOTICE: RDX: ffff81004c488780 RSI: 0000000000000000 RDI: ffff8=
10071521ea0<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.=
58.130 NOTICE: RBP: 0000000000000000 R08: 0000000000000000 R09: 00000000000=
00000<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130=
 NOTICE: R10: 0000000000000000 R11: ffffffff80087ee0 R12: ffff810080721c00<=
o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTIC=
E: R13: ffff810087a247d8 R14: 0000000100000000 R15: ffff810071521e80<o:p></=
o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: FS:=
&nbsp; 0000000000000000(0000) GS:ffff810107f5da40(0000) knlGS:0000000000000=
000<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 N=
OTICE: CS:&nbsp; 0010 DS: 0018 ES: 0018 CR0: 000000008005003b<o:p></o:p></p=
><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: CR2: 00000=
00100000010 CR3: 00000000592df000 CR4: 00000000000006e0<o:p></o:p></p><p cl=
ass=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: Process kmpath_r=
dacd (pid: 23040, threadinfo ffff810081e70000, task ffff81008a0f5080)<o:p><=
/o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: St=
ack: <o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130=
 NOTICE: 0000000000000282<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02=
:53:08 172.19.58.130 NOTICE: ffff81004c488780<o:p></o:p></p><p class=3DMsoN=
ormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: ffff81006c14fc00<o:p></o:p=
></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: ffff81=
0080721c00<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.5=
8.130 NOTICE: <o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.=
19.58.130 NOTICE: ffff810087a247d8<o:p></o:p></p><p class=3DMsoNormal>2011 =
Jan 20 02:53:08 172.19.58.130 NOTICE: 0000000000000000<o:p></o:p></p><p cla=
ss=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: ffff81006c14fc62<=
o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTIC=
E: ffffffff883bcdf7<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08=
 172.19.58.130 NOTICE: <o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:5=
3:08 172.19.58.130 NOTICE: 0000000010008040<o:p></o:p></p><p class=3DMsoNor=
mal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: ffff81008c7f65c0<o:p></o:p><=
/p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: ffff8100=
81e71e70<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.=
130 NOTICE: ffff810081e71dd0<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20=
 02:53:08 172.19.58.130 NOTICE: <o:p></o:p></p><p class=3DMsoNormal>2011 Ja=
n 20 02:53:08 172.19.58.130 NOTICE: Call Trace:<o:p></o:p></p><p class=3DMs=
oNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: [&lt;ffffffff883bcdf7&gt=
;] :scsi_dh_rdac:send_mode_select+0x477/0x4b0<o:p></o:p></p><p class=3DMsoN=
ormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: [&lt;ffffffff80032183&gt;]=
 __wake_up+0x43/0x70<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:0=
8 172.19.58.130 NOTICE: [&lt;ffffffff883bc980&gt;] :scsi_dh_rdac:send_mode_=
select+0x0/0x4b0<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 17=
2.19.58.130 NOTICE: [&lt;ffffffff800561a3&gt;] run_workqueue+0xb3/0x110<o:p=
></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: =
[&lt;ffffffff80052180&gt;] worker_thread+0x0/0x150<o:p></o:p></p><p class=
=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: [&lt;ffffffff800b33=
b0&gt;] keventd_create_kthread+0x0/0xa0<o:p></o:p></p><p class=3DMsoNormal>=
2011 Jan 20 02:53:08 172.19.58.130 NOTICE: [&lt;ffffffff80052291&gt;] worke=
r_thread+0x111/0x150<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:0=
8 172.19.58.130 NOTICE: [&lt;ffffffff8009ca00&gt;] default_wake_function+0x=
0/0x10<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.13=
0 NOTICE: [&lt;ffffffff80052180&gt;] worker_thread+0x0/0x150<o:p></o:p></p>=
<p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: [&lt;ffffff=
ff800373c9&gt;] kthread+0xd9/0x120<o:p></o:p></p><p class=3DMsoNormal>2011 =
Jan 20 02:53:08 172.19.58.130 NOTICE: [&lt;ffffffff80068fb1&gt;] child_rip+=
0xa/0x11<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.=
130 NOTICE: [&lt;ffffffff800b33b0&gt;] keventd_create_kthread+0x0/0xa0<o:p>=
</o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: [=
&lt;ffffffff800372f0&gt;] kthread+0x0/0x120<o:p></o:p></p><p class=3DMsoNor=
mal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: [&lt;ffffffff80068fa7&gt;] c=
hild_rip+0x0/0x11<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 1=
72.19.58.130 NOTICE: <o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:=
08 172.19.58.130 NOTICE: <o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02=
:53:08 172.19.58.130 NOTICE: Code: <o:p></o:p></p><p class=3DMsoNormal>2011=
 Jan 20 02:53:08 172.19.58.130 NOTICE: 49 <o:p></o:p></p><p class=3DMsoNorm=
al>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: 8b <o:p></o:p></p><p class=3D=
MsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: 5e <o:p></o:p></p><p c=
lass=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: 10 <o:p></o:p><=
/p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: 77 <o:p>=
</o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: 7=
b <o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NO=
TICE: 89 <o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58=
.130 NOTICE: f0 <o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 17=
2.19.58.130 NOTICE: ff <o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:5=
3:08 172.19.58.130 NOTICE: 24 <o:p></o:p></p><p class=3DMsoNormal>2011 Jan =
20 02:53:08 172.19.58.130 NOTICE: c5 <o:p></o:p></p><p class=3DMsoNormal>20=
11 Jan 20 02:53:08 172.19.58.130 NOTICE: a8 <o:p></o:p></p><p class=3DMsoNo=
rmal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: 8c <o:p></o:p></p><p class=
=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: 1b <o:p></o:p></p><=
p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: 88 <o:p></o:=
p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: c7 <o=
:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE=
: 44 <o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130=
 NOTICE: 24 <o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19=
.58.130 NOTICE: 04 <o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08=
 172.19.58.130 NOTICE: 00 <o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 0=
2:53:08 172.19.58.130 NOTICE: <o:p></o:p></p><p class=3DMsoNormal>2011 Jan =
20 02:53:08 172.19.58.130 NOTICE: RIP <o:p></o:p></p><p class=3DMsoNormal>2=
011 Jan 20 02:53:08 172.19.58.130 NOTICE: [&lt;ffffffff881b713f&gt;] :dm_mu=
ltipath:pg_init_done+0x2f/0x1c0<o:p></o:p></p><p class=3DMsoNormal>2011 Jan=
 20 02:53:08 172.19.58.130 NOTICE: RSP &lt;ffff810081e71d40&gt;<o:p></o:p><=
/p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: CR2: 000=
0000100000010<o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.1=
9.58.130 NOTICE: <o:p></o:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 1=
72.19.58.130 EMERG: Kernel panic - not syncing: Fatal exception<o:p></o:p><=
/p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 NOTICE: <o:p></o=
:p></p><p class=3DMsoNormal>2011 Jan 20 02:53:08 172.19.58.130 EMERG: Reboo=
ting in 1 seconds..<o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p=
><p class=3DMsoNormal>Seems that the pgpath is deleted in dm-mpath while se=
nd_mode_select is in progress and when it calls pg_init_done we get an OOPs=
.<o:p></o:p></p><p class=3DMsoNormal>I wonder if a reference count on pgpat=
h will do the trick here.<o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o=
:p></p><p class=3DMsoNormal><b><span style=3D'font-size:10.0pt;font-family:=
"Trebuchet MS","sans-serif";color:#444444'>Menny Hamburger</span></b><span =
style=3D'font-size:8.0pt;font-family:"Trebuchet MS","sans-serif";color:#444=
444'><o:p></o:p></span></p><p class=3DMsoNormal><span style=3D'font-size:8.=
0pt;font-family:"Trebuchet MS","sans-serif";color:#444444'>Engineer<o:p></o=
:p></span></p><p class=3DMsoNormal><b><span style=3D'font-size:8.0pt;font-f=
amily:"Trebuchet MS","sans-serif";color:#0085C3'>Dell</span></b><span style=
=3D'font-size:8.0pt;font-family:"Trebuchet MS","sans-serif";color:#444444'>=
 | IDC<b><o:p></o:p></b></span></p><p class=3DMsoNormal><b><span style=3D'f=
ont-size:8.0pt;font-family:"Trebuchet MS","sans-serif";color:#444444'>offic=
e </span></b><span style=3D'font-size:8.0pt;font-family:"Trebuchet MS","san=
s-serif";color:#444444'>+972 97698789<b>,&nbsp; fax </b>+972 97698889<b><o:=
p></o:p></b></span></p><p class=3DMsoNormal><span style=3D'font-size:8.0pt;=
font-family:"Trebuchet MS","sans-serif";color:#444444'>Dell IDC. 4 Hacharos=
het St, Raanana 43657, Israel</span><span style=3D'color:#1F497D'><o:p></o:=
p></span></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p></div></body></html>=

--_000_D8C50530D6022F40A817A35C40CC06A7064B3085D5DUBX7MCDUB01E_--


--===============3994307789018710389==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3994307789018710389==--

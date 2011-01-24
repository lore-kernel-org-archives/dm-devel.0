From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: Re: multipath - reference count on pgpath
Date: Mon, 24 Jan 2011 15:40:12 -0700
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF4F570127C@cosmail01.lsi.com>
References: <D8C50530D6022F40A817A35C40CC06A7064B2CD9F2@DUBX7MCDUB01.EMEA.DELL.COM>
	<D8C50530D6022F40A817A35C40CC06A7064B3085D5@DUBX7MCDUB01.EMEA.DELL.COM>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5563560159835707054=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <D8C50530D6022F40A817A35C40CC06A7064B3085D5@DUBX7MCDUB01.EMEA.DELL.COM>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============5563560159835707054==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_E463DF2B2E584B4A82673F53D62C2EF4F570127Ccosmail01lsicom_"

--_000_E463DF2B2E584B4A82673F53D62C2EF4F570127Ccosmail01lsicom_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

This problem may be fixed by this commit..
http://git.kernel.org/linus/2bded7bd7e8b12a913b0b58167a48220560e1514

Please check..

________________________________
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On B=
ehalf Of Menny_Hamburger@dell.com
Sent: Monday, January 24, 2011 9:58 AM
To: dm-devel@redhat.com
Subject: Re: [dm-devel] multipath - reference count on pgpath

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

1)   Configure new LUNs mapping file

udevsettle

multipathd restart

udevtrigger

udevsettle

2)   udevtrigger

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


--_000_E463DF2B2E584B4A82673F53D62C2EF4F570127Ccosmail01lsicom_
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
p2p=3D"http://schemas.microsoft.com/data/udc/parttopart" xmlns:st=3D"&#1;" =
xmlns:st1=3D"urn:schemas-microsoft-com:office:smarttags" xmlns=3D"http://ww=
w.w3.org/TR/REC-html40"
xmlns:ns0=3D"http://schemas.microsoft.com/sharepoint/soap/workflow/"
xmlns:ns1=3D"http://schemas.microsoft.com/office/2006/digsig-setup"
xmlns:ns2=3D"http://schemas.microsoft.com/office/2006/digsig"
xmlns:ns3=3D"http://schemas.openxmlformats.org/package/2006/digital-signatu=
re"
xmlns:ns4=3D"http://schemas.openxmlformats.org/markup-compatibility/2006"
xmlns:ns5=3D"http://schemas.microsoft.com/office/2004/12/omml"
xmlns:ns6=3D"http://schemas.openxmlformats.org/package/2006/relationships"
xmlns:ns7=3D"http://microsoft.com/sharepoint/webpartpages"
xmlns:ns8=3D"http://schemas.microsoft.com/exchange/services/2006/types"
xmlns:ns9=3D"http://schemas.microsoft.com/exchange/services/2006/messages"
xmlns:ns10=3D"http://schemas.microsoft.com/sharepoint/soap/SlideLibrary/"
xmlns:ns11=3D"http://microsoft.com/webservices/SharePointPortalServer/Publi=
shedLinksService"
xmlns:ns12=3D"urn:schemas-microsoft-com:">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; charset=3Dus-ascii">
<meta name=3DGenerator content=3D"Microsoft Word 11 (filtered medium)">
<!--[if !mso]>
<style>
v\:* {behavior:url(#default#VML);}
o\:* {behavior:url(#default#VML);}
w\:* {behavior:url(#default#VML);}
.shape {behavior:url(#default#VML);}
</style>
<![endif]--><o:SmartTagType
 namespaceuri=3D"urn:schemas-microsoft-com:office:smarttags" name=3D"Postal=
Code"/>
<o:SmartTagType namespaceuri=3D"urn:schemas-microsoft-com:office:smarttags"
 name=3D"country-region"/>
<o:SmartTagType namespaceuri=3D"urn:schemas-microsoft-com:office:smarttags"
 name=3D"City"/>
<o:SmartTagType namespaceuri=3D"urn:schemas-microsoft-com:office:smarttags"
 name=3D"place"/>
<o:SmartTagType namespaceuri=3D"urn:schemas-microsoft-com:office:smarttags"
 name=3D"PersonName"/>
<!--[if !mso]>
<style>
st1\:*{behavior:url(#default#ieooui) }
</style>
<![endif]-->
<style>
<!--a:link
	{mso-style-priority:99;}
span.MSOHYPERLINK
	{mso-style-priority:99;}
a:visited
	{mso-style-priority:99;}
span.MSOHYPERLINKFOLLOWED
	{mso-style-priority:99;}
p.MSOLISTPARAGRAPH
	{mso-style-priority:34;}
li.MSOLISTPARAGRAPH
	{mso-style-priority:34;}
div.MSOLISTPARAGRAPH
	{mso-style-priority:34;}

 /* Font Definitions */
 @font-face
	{font-family:Tahoma;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
@font-face
	{font-family:Monaco;
	panose-1:0 0 0 0 0 0 0 0 0 0;}
@font-face
	{font-family:"Trebuchet MS";
	panose-1:2 11 6 3 2 2 2 2 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:Calibri;}
a:link, span.MsoHyperlink
	{color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{color:purple;
	text-decoration:underline;}
p.msolistparagraph, li.msolistparagraph, div.msolistparagraph
	{margin-top:0in;
	margin-right:0in;
	margin-bottom:0in;
	margin-left:.5in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:Calibri;}
span.EmailStyle18
	{mso-style-type:personal;
	font-family:Calibri;
	color:windowtext;}
span.EmailStyle19
	{mso-style-type:personal;
	font-family:Calibri;
	color:#1F497D;}
span.EmailStyle20
	{mso-style-type:personal-reply;
	font-family:Arial;
	color:navy;}
@page Section1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.Section1
	{page:Section1;}
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
-->
</style>
<!--[if gte mso 9]><xml>
 <o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
 <o:shapelayout v:ext=3D"edit">
  <o:idmap v:ext=3D"edit" data=3D"1" />
 </o:shapelayout></xml><![endif]-->
</head>

<body lang=3DEN-US link=3Dblue vlink=3Dpurple>

<div class=3DSection1>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>This problem may be fixed by this comm=
it..<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dblack face=3DMonaco><span style=
=3D'font-size:
10.0pt;font-family:Monaco;color:black'><a
href=3D"http://git.kernel.org/linus/2bded7bd7e8b12a913b0b58167a48220560e151=
4"
title=3D"http://git.kernel.org/linus/2bded7bd7e8b12a913b0b58167a48220560e15=
14"><font
size=3D2 color=3D"#069d06"><span style=3D'font-size:11.0pt;color:#069D06;te=
xt-decoration:
none'>http://git.kernel.org/linus/2bded7bd7e8b12a913b0b58167a48220560e1514<=
/span></font></a></span></font><font
size=3D2 color=3Dnavy face=3DArial><span style=3D'font-size:10.0pt;font-fam=
ily:Arial;
color:navy'><o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>Please check..<o:p></o:p></span></font=
></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'><o:p>&nbsp;</o:p></span></font></p>

<div style=3D'border:none;border-left:solid blue 1.5pt;padding:0in 0in 0in =
4.0pt'>

<div>

<div class=3DMsoNormal align=3Dcenter style=3D'text-align:center'><font siz=
e=3D3
face=3D"Times New Roman"><span style=3D'font-size:12.0pt;font-family:"Times=
 New Roman"'>

<hr size=3D2 width=3D"100%" align=3Dcenter tabindex=3D-1>

</span></font></div>

<p class=3DMsoNormal><b><font size=3D2 face=3DTahoma><span style=3D'font-si=
ze:10.0pt;
font-family:Tahoma;font-weight:bold'>From:</span></font></b><font size=3D2
face=3DTahoma><span style=3D'font-size:10.0pt;font-family:Tahoma'>
dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] <b><span
style=3D'font-weight:bold'>On Behalf Of </span></b>Menny_Hamburger@dell.com=
<br>
<b><span style=3D'font-weight:bold'>Sent:</span></b> Monday, January 24, 20=
11
9:58 AM<br>
<b><span style=3D'font-weight:bold'>To:</span></b> <st1:PersonName w:st=3D"=
on">dm-devel@redhat.com</st1:PersonName><br>
<b><span style=3D'font-weight:bold'>Subject:</span></b> Re: [dm-devel] mult=
ipath
- reference count on pgpath</span></font><font size=3D3 face=3D"Times New R=
oman"><span
style=3D'font-size:12.0pt;font-family:"Times New Roman"'><o:p></o:p></span>=
</font></p>

</div>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3D"#1f497d" face=3DCalibri><span
style=3D'font-size:11.0pt;color:#1F497D'>Hi,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3D"#1f497d" face=3DCalibri><span
style=3D'font-size:11.0pt;color:#1F497D'><o:p>&nbsp;</o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 color=3D"#1f497d" face=3DCalibri><span
style=3D'font-size:11.0pt;color:#1F497D'>Patch was premature so I am re-pos=
ting
my initial question:<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3D"#1f497d" face=3DCalibri><span
style=3D'font-size:11.0pt;color:#1F497D'>This panic occurs quite frequently=
 when
multipathd is restarted (either after devices are added or removed) and at =
the
same time some other script does udevtrigger, udevsettle.<o:p></o:p></span>=
</font></p>

<p class=3DMsoNormal><font size=3D2 color=3D"#1f497d" face=3DCalibri><span
style=3D'font-size:11.0pt;color:#1F497D'>I have fixed our
configuration/monitoring scripts to avoid this panic, however this only hid=
es
the problem and does not solve it.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3D"#1f497d" face=3DCalibri><span
style=3D'font-size:11.0pt;color:#1F497D'>I would appreciate any input on th=
is
issue.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3D"#1f497d" face=3DCalibri><span
style=3D'font-size:11.0pt;color:#1F497D'><o:p>&nbsp;</o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 color=3D"#1f497d" face=3DCalibri><span
style=3D'font-size:11.0pt;color:#1F497D'>Thanks,<o:p></o:p></span></font></=
p>

<p class=3DMsoNormal><font size=3D2 color=3D"#1f497d" face=3DCalibri><span
style=3D'font-size:11.0pt;color:#1F497D'>Menny<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3D"#1f497d" face=3DCalibri><span
style=3D'font-size:11.0pt;color:#1F497D'><o:p>&nbsp;</o:p></span></font></p=
>

<div>

<div style=3D'border:none;border-top:solid #B5C4DF 1.0pt;padding:3.0pt 0in =
0in 0in'>

<p class=3DMsoNormal><b><font size=3D2 face=3DTahoma><span style=3D'font-si=
ze:10.0pt;
font-family:Tahoma;font-weight:bold'>From:</span></font></b><font size=3D2
face=3DTahoma><span style=3D'font-size:10.0pt;font-family:Tahoma'>
dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] <b><span
style=3D'font-weight:bold'>On Behalf Of </span></b>Hamburger, Menny<br>
<b><span style=3D'font-weight:bold'>Sent:</span></b> 23 January, 2011 11:23=
<br>
<b><span style=3D'font-weight:bold'>To:</span></b> <st1:PersonName w:st=3D"=
on">dm-devel@redhat.com</st1:PersonName><br>
<b><span style=3D'font-weight:bold'>Subject:</span></b> [dm-devel] multipat=
h -
reference count on pgpath<o:p></o:p></span></font></p>

</div>

</div>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>Hi,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>We
are using multipath over ISCSI storage that uses the RDAC hardware handler
(RHEL5.5)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>When
we have two running scripts doing the following:<o:p></o:p></span></font></=
p>

<p class=3Dmsolistparagraph style=3D'text-indent:-.25in;mso-list:l0 level1 =
lfo2'><![if !supportLists]><font
size=3D2 face=3DCalibri><span style=3D'font-size:11.0pt'><span style=3D'mso=
-list:Ignore'>1)<font
size=3D1 face=3D"Times New Roman"><span style=3D'font:7.0pt "Times New Roma=
n"'>&nbsp;&nbsp;
</span></font></span></span></font><![endif]>Configure new LUNs mapping fil=
e<o:p></o:p></p>

<p class=3Dmsolistparagraph><font size=3D2 face=3DCalibri><span style=3D'fo=
nt-size:
11.0pt'>udevsettle<o:p></o:p></span></font></p>

<p class=3Dmsolistparagraph><font size=3D2 face=3DCalibri><span style=3D'fo=
nt-size:
11.0pt'>multipathd restart<o:p></o:p></span></font></p>

<p class=3Dmsolistparagraph><font size=3D2 face=3DCalibri><span style=3D'fo=
nt-size:
11.0pt'>udevtrigger <o:p></o:p></span></font></p>

<p class=3Dmsolistparagraph><font size=3D2 face=3DCalibri><span style=3D'fo=
nt-size:
11.0pt'>udevsettle<o:p></o:p></span></font></p>

<p class=3Dmsolistparagraph style=3D'text-indent:-.25in;mso-list:l0 level1 =
lfo2'><![if !supportLists]><font
size=3D2 face=3DCalibri><span style=3D'font-size:11.0pt'><span style=3D'mso=
-list:Ignore'>2)<font
size=3D1 face=3D"Times New Roman"><span style=3D'font:7.0pt "Times New Roma=
n"'>&nbsp;&nbsp;
</span></font></span></span></font><![endif]>udevtrigger <o:p></o:p></p>

<p class=3Dmsolistparagraph><font size=3D2 face=3DCalibri><span style=3D'fo=
nt-size:
11.0pt'>udevsettle<o:p></o:p></span></font></p>

<p class=3Dmsolistparagraph><font size=3D2 face=3DCalibri><span style=3D'fo=
nt-size:
11.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3Dmsolistparagraph style=3D'margin-left:0in'><font size=3D2 face=
=3DCalibri><span
style=3D'font-size:11.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3Dmsolistparagraph style=3D'margin-left:0in'><font size=3D2 face=
=3DCalibri><span
style=3D'font-size:11.0pt'>We get the kernel panic below.<o:p></o:p></span>=
</font></p>

<p class=3Dmsolistparagraph style=3D'margin-left:0in'><font size=3D2 face=
=3DCalibri><span
style=3D'font-size:11.0pt'>Although I know that the usage here is problemat=
ic (I
already modified the scripts), the kernel should protect itself from situat=
ions
like this.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: Unable to handle kernel paging reques=
t<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: at 0000000100000010 RIP: <o:p></o:p><=
/span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 node0 INFO: kernel: sd 350:0:0:0: rdac: array MD3200i-c7-d7=
,
ctlr 1, MODE_SELECT completed<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: [&lt;ffffffff881b713f&gt;] :dm_multip=
ath:pg_init_done+0x2f/0x1c0<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 node0 ALERT: kernel: Unable to handle kernel paging request=
 at
0000000100000010 RIP: <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: PGD 0 <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 node0 ALERT: kernel: [&lt;ffffffff881b713f&gt;] :dm_multipa=
th:pg_init_done+0x2f/0x1c0<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: Oops: 0000 [1] <o:p></o:p></span></fo=
nt></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: SMP <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: last sysfs file:
/devices/platform/host353/session76/target353:0:0/353:0:0:0/rev<o:p></o:p><=
/span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: CPU 3 <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: Modules linked in:<o:p></o:p></span><=
/font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: iscsi_tcp(U)<o:p></o:p></span></font>=
</p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: libiscsi_tcp(U)<o:p></o:p></span></fo=
nt></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: libiscsi2(U)<o:p></o:p></span></font>=
</p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: scsi_transport_iscsi2(U)<o:p></o:p></=
span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: scsi_transport_iscsi(U)<o:p></o:p></s=
pan></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: ipmi_si(U)<o:p></o:p></span></font></=
p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: dell_rbu(U)<o:p></o:p></span></font><=
/p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: scsi_dh_rdac(U)<o:p></o:p></span></fo=
nt></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: dm_rdac(U)<o:p></o:p></span></font></=
p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: dm_queue_depth(U)<o:p></o:p></span></=
font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: dm_round_robin(U)<o:p></o:p></span></=
font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: xt_tcpudp(U)<o:p></o:p></span></font>=
</p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: ipt_SYSRQ(U)<o:p></o:p></span></font>=
</p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: netconsole(U)<o:p></o:p></span></font=
></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: iptable_filter(U)<o:p></o:p></span></=
font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: ip_tables(U)<o:p></o:p></span></font>=
</p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: vfat(U)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: fat(U)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: usb_storage(U)<o:p></o:p></span></fon=
t></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: mptctl(U)<o:p></o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: exa_ioctls(U)<o:p></o:p></span></font=
></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: nfs(U)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: lockd(U)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: nfs_acl(U)<o:p></o:p></span></font></=
p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: x_tables(U)<o:p></o:p></span></font><=
/p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: sunrpc(U)<o:p></o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: ipmi_devintf(U)<o:p></o:p></span></fo=
nt></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: ipmi_msghandler(U)<o:p></o:p></span><=
/font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: bonding1(U)<o:p></o:p></span></font><=
/p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: bonding(U)<o:p></o:p></span></font></=
p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: ipv6(U)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: xfrm_nalgo(U)<o:p></o:p></span></font=
></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: crypto_api(U)<o:p></o:p></span></font=
></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: dm_mirror(U)<o:p></o:p></span></font>=
</p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: dm_log(U)<o:p></o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: dm_multipath(U)<o:p></o:p></span></fo=
nt></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: scsi_dh(U)<o:p></o:p></span></font></=
p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: dm_mod(U)<o:p></o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: video(U)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: hwmon(U)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: backlight(U)<o:p></o:p></span></font>=
</p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: sbs(U)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: i2c_ec(U)<o:p></o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: i2c_core(U)<o:p></o:p></span></font><=
/p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: button(U)<o:p></o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: battery(U)<o:p></o:p></span></font></=
p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: asus_acpi(U)<o:p></o:p></span></font>=
</p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: ac(U)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: sr_mod(U)<o:p></o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: cdrom(U)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: joydev(U)<o:p></o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: sg(U)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: bnx2(U)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: pcspkr(U)<o:p></o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: ata_piix(U)<o:p></o:p></span></font><=
/p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: libata(U)<o:p></o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: mptsas(U)<o:p></o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: mptscsih(U)<o:p></o:p></span></font><=
/p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: mptbase(U)<o:p></o:p></span></font></=
p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: scsi_transport_sas(U)<o:p></o:p></spa=
n></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: sd_mod(U)<o:p></o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: scsi_mod(U)<o:p></o:p></span></font><=
/p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: ext3(U)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: jbd(U)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: uhci_hcd(U)<o:p></o:p></span></font><=
/p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: ohci_hcd(U)<o:p></o:p></span></font><=
/p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: ehci_hcd(U)<o:p></o:p></span></font><=
/p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: Pid: 23040, comm: kmpath_rdacd Tainte=
d:
G&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2.6.18-164sys #1<o:p></o:p></span></font></=
p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: RIP: 0010:[&lt;ffffffff881b713f&gt;] =
<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: [&lt;ffffffff881b713f&gt;]
:dm_multipath:pg_init_done+0x2f/0x1c0<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: RSP: 0018:ffff810081e71d40&nbsp; EFLA=
GS:
00010293<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: RAX: ffffffff881b7110 RBX:
ffff81004c488780 RCX: ffff810080721c00<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: RDX: ffff81004c488780 RSI:
0000000000000000 RDI: ffff810071521ea0<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: RBP: 0000000000000000 R08:
0000000000000000 R09: 0000000000000000<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: R10: 0000000000000000 R11:
ffffffff80087ee0 R12: ffff810080721c00<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: R13: ffff810087a247d8 R14:
0000000100000000 R15: ffff810071521e80<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: FS:&nbsp; 0000000000000000(0000)
GS:ffff810107f5da40(0000) knlGS:0000000000000000<o:p></o:p></span></font></=
p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: CS:&nbsp; 0010 DS: 0018 ES: 0018 CR0:
000000008005003b<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: CR2: 0000000100000010 CR3:
00000000592df000 CR4: 00000000000006e0<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: Process kmpath_rdacd (pid: 23040,
threadinfo ffff810081e70000, task ffff81008a0f5080)<o:p></o:p></span></font=
></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: Stack: <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: 0000000000000282<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: ffff81004c488780<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: ffff81006c14fc00<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: ffff810080721c00<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: ffff810087a247d8<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: 0000000000000000<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: ffff81006c14fc62<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: ffffffff883bcdf7<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: 0000000010008040<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: ffff81008c7f65c0<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: ffff810081e71e70<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: ffff810081e71dd0<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: Call Trace:<o:p></o:p></span></font><=
/p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: [&lt;ffffffff883bcdf7&gt;]
:scsi_dh_rdac:send_mode_select+0x477/0x4b0<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: [&lt;ffffffff80032183&gt;]
__wake_up+0x43/0x70<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: [&lt;ffffffff883bc980&gt;]
:scsi_dh_rdac:send_mode_select+0x0/0x4b0<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: [&lt;ffffffff800561a3&gt;]
run_workqueue+0xb3/0x110<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: [&lt;ffffffff80052180&gt;] worker_thr=
ead+0x0/0x150<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: [&lt;ffffffff800b33b0&gt;]
keventd_create_kthread+0x0/0xa0<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: [&lt;ffffffff80052291&gt;]
worker_thread+0x111/0x150<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: [&lt;ffffffff8009ca00&gt;]
default_wake_function+0x0/0x10<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: [&lt;ffffffff80052180&gt;]
worker_thread+0x0/0x150<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: [&lt;ffffffff800373c9&gt;]
kthread+0xd9/0x120<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: [&lt;ffffffff80068fb1&gt;]
child_rip+0xa/0x11<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: [&lt;ffffffff800b33b0&gt;]
keventd_create_kthread+0x0/0xa0<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: [&lt;ffffffff800372f0&gt;]
kthread+0x0/0x120<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: [&lt;ffffffff80068fa7&gt;]
child_rip+0x0/0x11<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: Code: <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: 49 <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: 8b <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: 5e <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: 10 <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: 77 <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: 7b <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: 89 <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: f0 <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: ff <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: 24 <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: c5 <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: a8 <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: 8c <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: 1b <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: 88 <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: c7 <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: 44 <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: 24 <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: 04 <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: 00 <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: RIP <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: [&lt;ffffffff881b713f&gt;]
:dm_multipath:pg_init_done+0x2f/0x1c0<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: RSP &lt;ffff810081e71d40&gt;<o:p></o:=
p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: CR2: 0000000100000010<o:p></o:p></spa=
n></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 EMERG: Kernel panic - not syncing: Fatal
exception<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 NOTICE: <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>2011
Jan 20 02:53:08 172.19.58.130 EMERG: Rebooting in 1 seconds..<o:p></o:p></s=
pan></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>Seems
that the pgpath is deleted in dm-mpath while send_mode_select is in progres=
s
and when it calls pg_init_done we get an OOPs.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>I
wonder if a reference count on pgpath will do the trick here.<o:p></o:p></s=
pan></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><st1:PersonName w:st=3D"on"><b><font size=3D2 color=3D=
"#444444"
 face=3D"Trebuchet MS"><span style=3D'font-size:10.0pt;font-family:"Trebuch=
et MS";
 color:#444444;font-weight:bold'>Menny Hamburger</span></font></b></st1:Per=
sonName><font
size=3D1 color=3D"#444444" face=3D"Trebuchet MS"><span style=3D'font-size:8=
.0pt;
font-family:"Trebuchet MS";color:#444444'><o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 color=3D"#444444" face=3D"Trebuchet MS"=
><span
style=3D'font-size:8.0pt;font-family:"Trebuchet MS";color:#444444'>Engineer=
<o:p></o:p></span></font></p>

<p class=3DMsoNormal><b><font size=3D1 color=3D"#0085c3" face=3D"Trebuchet =
MS"><span
style=3D'font-size:8.0pt;font-family:"Trebuchet MS";color:#0085C3;font-weig=
ht:
bold'>Dell</span></font></b><font size=3D1 color=3D"#444444" face=3D"Trebuc=
het MS"><span
style=3D'font-size:8.0pt;font-family:"Trebuchet MS";color:#444444'> | IDC<b=
><span
style=3D'font-weight:bold'><o:p></o:p></span></b></span></font></p>

<p class=3DMsoNormal><b><font size=3D1 color=3D"#444444" face=3D"Trebuchet =
MS"><span
style=3D'font-size:8.0pt;font-family:"Trebuchet MS";color:#444444;font-weig=
ht:
bold'>office </span></font></b><font size=3D1 color=3D"#444444" face=3D"Tre=
buchet MS"><span
style=3D'font-size:8.0pt;font-family:"Trebuchet MS";color:#444444'>+972 976=
98789<b><span
style=3D'font-weight:bold'>,&nbsp; fax </span></b>+972 97698889<b><span
style=3D'font-weight:bold'><o:p></o:p></span></b></span></font></p>

<p class=3DMsoNormal><font size=3D1 color=3D"#444444" face=3D"Trebuchet MS"=
><span
style=3D'font-size:8.0pt;font-family:"Trebuchet MS";color:#444444'>Dell IDC=
. <st1:place
w:st=3D"on">4 Hacharoshet St, <st1:City w:st=3D"on">Raanana</st1:City> <st1=
:PostalCode
 w:st=3D"on">43657</st1:PostalCode>, <st1:country-region w:st=3D"on">Israel=
</st1:country-region></st1:place></span></font><font
color=3D"#1f497d"><span style=3D'color:#1F497D'><o:p></o:p></span></font></=
p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'><o:p>&nbsp;</o:p></span></font></p>

</div>

</div>

</body>

</html>

--_000_E463DF2B2E584B4A82673F53D62C2EF4F570127Ccosmail01lsicom_--


--===============5563560159835707054==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5563560159835707054==--

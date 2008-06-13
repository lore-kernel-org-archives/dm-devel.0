From: "Gianluca Cecchi" <gianluca.cecchi@gmail.com>
Subject: two paths remain failed on DS6800 after code upgrade
Date: Fri, 13 Jun 2008 12:14:15 +0200
Message-ID: <561c252c0806130314x2924a027n1fbd74c29178e5c8@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0601009843=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

--===============0601009843==
Content-Type: multipart/alternative;
	boundary="----=_Part_34754_21527725.1213352055322"

------=_Part_34754_21527725.1213352055322
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,
I have a test server connected to an IBM DS6800 storage.
It is a blade bl480c with two qlogic hbas, connected to 2 fc-switches.
RH EL 4.6 x86_64 installed (kernel 2.6.9-67.ELsmp)
device-mapper-1.02.21-1.el4
device-mapper-multipath-0.4.5-27.RHEL4

In boot messages I have for the hbas:
qla2400 0000:0c:00.0: Found an ISP2432, irq 185, iobase 0xffffff000001c000
QLogic Fibre Channel HBA Driver: 8.01.07-d4
QLogic QMH2462 - SBUS to 2Gb FC, Dual Channel
ISP2432: PCIe (2.5Gb/s x4) @ 0000:0c:00.0 hdma+, host#=0, fw=4.00.150 [IP]
Vendor: IBM       Model: 1750500           Rev: .155
Type:   Direct-Access                      ANSI SCSI revision: 05

On the storage I have access to two luns, so that in total I get 8 paths and
disks from sda to sdh.
In multipath I'm using default os install config for ds6800 (storage
1750500)
so it should be:
#      device {
#               vendor                  "IBM"
#               product                 "1750500"
#               path_grouping_policy    group_by_prio
#               getuid_callout          "/sbin/scsi_id -g -u -s"
#               prio_callout            "/sbin/mpath_prio_alua %d"
#               features                "1 queue_if_no_path"
#               path_checker            tur
#       }

In normal operation the command "multipath -ll" gives:

[root@test-rhel-p ~]# multipath -ll

*mpath1 (3600507630efe05800000000000001700)*

[size=20 GB][features="1 queue_if_no_path"][hwhandler="0"]

\_ round-robin 0 [prio=100]*[active]*                                     **

*     \_ 0:0:1:1 sdd 8:48  [active][ready]*

*     \_ 1:0:1:1 sdh 8:112 [active][ready]*

\_ round-robin 0 [prio=20][enabled]

     \_ 0:0:0:1 sdb 8:16  [active][ready]

     \_ 1:0:0:1 sdf 8:80  [active][ready]



*mpath0 (3600507630efe05800000000000001600)*

[size=20 GB][features="1 queue_if_no_path"][hwhandler="0"]

\_ round-robin 0 [prio=100]*[active] *

*     \_ 0:0:0:0 sda 8:0   [active][ready]*

*     \_ 1:0:0:0 sde 8:64  [active][ready]*

\_ round-robin 0 [prio=20][enabled]

     \_ 0:0:1:0 sdc 8:32  [active][ready]

     \_ 1:0:1:0 sdg 8:96  [active][ready]

We had a code update for the storage, and so I wanted to test the multipath
behaviour.
It was made in concurrent mode.
I get a first path-change whithout problems, probably when fisrt controller
was updated.

mpath1:

\_ round-robin 0 [enabled]

     *\_ 0:0:0:1 sdb 8:16  [failed]*

*     \_ 1:0:0:1 sdf 8:80  [failed]*
and
mpath0:

\_ round-robin 0 [enabled]

*     \_ 0:0:0:0 sda 8:0   [failed]*

*     \_ 1:0:0:0 sde 8:64  [failed]*
while the other two path group remained active.
At the end of upgrade, probably with the second controller update, I get the
situation below.
while other servers with windows and Linux (using sdd) came back with all
paths, this server retains two paths in failed state:

[root@test-rhel-p RPMS]# multipath -l

mpath1 (3600507630efe05800000000000001700)

[size=20 GB][features="1 queue_if_no_path"][hwhandler="0"]

\_ round-robin 0 [enabled]

* \_ 0:0:1:1 sdd 8:48  [failed][faulty]*

 \_ 1:0:1:1 sdh 8:112 [active]

\_ round-robin 0 [enabled]

 \_ 0:0:0:1 sdb 8:16  [active]

 \_ 1:0:0:1 sdf 8:80  [active]



mpath0 (3600507630efe05800000000000001600)

[size=20 GB][features="1 queue_if_no_path"][hwhandler="0"]

\_ round-robin 0 [active]

 \_ 0:0:0:0 sda 8:0   [active]

 \_ 1:0:0:0 sde 8:64  [active]

\_ round-robin 0 [enabled]

* \_ 0:0:1:0 sdc 8:32  [failed][faulty]*

 \_ 1:0:1:0 sdg 8:96  [active]

with messages every 5 seconds of type:

error calling out /sbin/mpath_prio_alua /dev/sdc
error calling out /sbin/mpath_prio_alua /dev/sdd

Other information:
[root@test-rhel-p ]# sg_inq /dev/sdc
sg_inq: error opening file: /dev/sdc: No such device or address

[root@test-rhel-p RPMS]# ll /dev/sdc
brw-rw----  1 root disk 8, 32 Jun 11 19:03 /dev/sdc

[root@test-rhel-p RPMS]# sg_inq /dev/sda
standard INQUIRY:
  PQual=0  Device_type=0  RMB=0  version=0x05  [SPC-3]
  [AERC=0]  [TrmTsk=0]  NormACA=1  HiSUP=1  Resp_data_format=2
  SCCS=0  ACC=0  TGPS=1  3PC=0  Protect=0  BQue=0
  EncServ=0  MultiP=1 (VS=0)  [MChngr=0]  [ACKREQQ=0]  Addr16=0
  [RelAdr=0]  WBus16=0  Sync=0  Linked=0  [TranDis=0]  CmdQue=1
  Clocking=0x0  QAS=0  IUS=0
    length=164 (0xa4)   Peripheral device type: disk
 Vendor identification: IBM
 Product identification: 1750500
 Product revision level: .441
 Unit serial number: 68778501600

Any help to get up the paths?
Could it help a scsi rescan? What should be the correct command in this
case?
The system is operational and without interruption on disk acces for the
users, but I don't understand why the paths don't come up again...

Thanks in advance for help or suggestions.
Gianluca

------=_Part_34754_21527725.1213352055322
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,<br>I have a test server connected to an IBM DS6800 storage.<br>It is a blade bl480c with two qlogic hbas, connected to 2 fc-switches.<br>RH EL 4.6 x86_64 installed (kernel 2.6.9-67.ELsmp)<br>device-mapper-1.02.21-1.el4<br>
device-mapper-multipath-0.4.5-27.RHEL4<br><br>In boot messages I have for the hbas:<br>qla2400 0000:0c:00.0: Found an ISP2432, irq 185, iobase 0xffffff000001c000<br>QLogic Fibre Channel HBA Driver: 8.01.07-d4<br>QLogic QMH2462 - SBUS to 2Gb FC, Dual Channel<br>
ISP2432: PCIe (2.5Gb/s x4) @ 0000:0c:00.0 hdma+, host#=0, fw=4.00.150 [IP]<br>Vendor: IBM&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: 1750500&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: .155<br>Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 05<br><br>On the storage I have access to two luns, so that in total I get 8 paths and disks from sda to sdh.<br>
 In multipath I&#39;m using default os install config for ds6800 (storage 1750500)<br>so it should be:<br>#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; device {<br>#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; vendor&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;IBM&quot;<br>#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; product&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;1750500&quot;<br>
#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; path_grouping_policy&nbsp;&nbsp;&nbsp; group_by_prio<br>#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; getuid_callout&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;/sbin/scsi_id -g -u -s&quot;<br>#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; prio_callout&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;/sbin/mpath_prio_alua %d&quot;<br>#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; features&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;1 queue_if_no_path&quot;<br>
#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; path_checker&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; tur<br>#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<br><br>In normal operation the command &quot;multipath -ll&quot; gives:<br>

<p class="MsoNormal"><span style="font-size: 9pt; line-height: 115%;" lang="EN-US">[root@test-rhel-p ~]# multipath -ll</span></p>

<p class="MsoNormal"><b style=""><span style="font-size: 9pt; line-height: 115%;" lang="EN-US">mpath1
(3600507630efe05800000000000001700)</span></b></p>

<p class="MsoNormal"><span style="font-size: 9pt; line-height: 115%;" lang="EN-US">[size=20 GB][features=&quot;1
queue_if_no_path&quot;][hwhandler=&quot;0&quot;]</span></p>

<p class="MsoNormal"><span style="font-size: 9pt; line-height: 115%;" lang="EN-US">\_ round-robin 0 [prio=100]<b style="">[active]</b><span style="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><b style=""></b></span></p>


<p class="MsoNormal"><b style=""><span style="font-size: 9pt; line-height: 115%;" lang="EN-US"><span style="">&nbsp;</span><span style="">&nbsp;&nbsp;&nbsp; </span>\_
0:0:1:1 sdd 8:48<span style="">&nbsp; </span>[active][ready]</span></b></p>

<p class="MsoNormal"><b style=""><span style="font-size: 9pt; line-height: 115%;" lang="EN-US"><span style="">&nbsp;</span><span style="">&nbsp;&nbsp;&nbsp; </span>\_
1:0:1:1 sdh 8:112 [active][ready]</span></b></p>

<p class="MsoNormal"><span style="font-size: 9pt; line-height: 115%;" lang="EN-US">\_ round-robin 0 [prio=20][enabled]<span style="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span></p>

<p class="MsoNormal"><span style="font-size: 9pt; line-height: 115%;" lang="EN-US"><span style="">&nbsp;</span><span style="">&nbsp;&nbsp;&nbsp; </span>\_ 0:0:0:1 sdb 8:16<span style="">&nbsp; </span>[active][ready]</span></p>

<p class="MsoNormal"><span style="font-size: 9pt; line-height: 115%;" lang="EN-US"><span style="">&nbsp;</span><span style="">&nbsp;&nbsp;&nbsp; </span>\_ 1:0:0:1 sdf 8:80<span style="">&nbsp; </span>[active][ready]</span></p>

<p class="MsoNormal"><span style="font-size: 9pt; line-height: 115%;" lang="EN-US">&nbsp;</span></p>

<p class="MsoNormal"><b style=""><span style="font-size: 9pt; line-height: 115%;" lang="EN-US">mpath0
(3600507630efe05800000000000001600)</span></b></p>

<p class="MsoNormal"><span style="font-size: 9pt; line-height: 115%;" lang="EN-US">[size=20 GB][features=&quot;1
queue_if_no_path&quot;][hwhandler=&quot;0&quot;]</span></p>

<p class="MsoNormal"><span style="font-size: 9pt; line-height: 115%;" lang="EN-US">\_ round-robin 0 [prio=100]<b style="">[active] </b><span style="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span></p>

<p class="MsoNormal"><b style=""><span style="font-size: 9pt; line-height: 115%;" lang="EN-US"><span style="">&nbsp;</span><span style="">&nbsp;&nbsp;&nbsp; </span>\_
0:0:0:0 sda 8:0<span style="">&nbsp;&nbsp; </span>[active][ready]</span></b></p>

<p class="MsoNormal"><b style=""><span style="font-size: 9pt; line-height: 115%;" lang="EN-US"><span style="">&nbsp;&nbsp;&nbsp; </span><span style="">&nbsp;</span>\_
1:0:0:0 sde 8:64<span style="">&nbsp; </span>[active][ready]</span></b></p>

<p class="MsoNormal"><span style="font-size: 9pt; line-height: 115%;" lang="EN-US">\_ round-robin 0 [prio=20][enabled] <span style="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span></p>

<p class="MsoNormal"><span style="font-size: 9pt; line-height: 115%;" lang="EN-US"><span style="">&nbsp;</span><span style="">&nbsp;&nbsp;&nbsp; </span>\_ 0:0:1:0 sdc 8:32<span style="">&nbsp; </span>[active][ready]</span></p>

<p class="MsoNormal"><span style="font-size: 9pt; line-height: 115%;" lang="EN-US"><span style="">&nbsp;</span><span style="">&nbsp;&nbsp;&nbsp; </span>\_ 1:0:1:0 sdg 8:96<span style="">&nbsp; </span>[active][ready]</span></p>

<br>We had a code update for the storage, and so I wanted to test the multipath behaviour.<br>It was made in concurrent mode.<br>I get a first path-change whithout problems, probably when fisrt controller was updated.<br>


<p class="MsoNormal"><span style="font-size: 9pt; line-height: 115%;" lang="EN-US">mpath1:<br></span></p><p class="MsoNormal"><span style="font-size: 9pt; line-height: 115%;" lang="EN-US">\_ round-robin 0 [enabled]</span></p>


<p class="MsoNormal"><span style="font-size: 9pt; line-height: 115%;" lang="EN-US"><span style="">&nbsp;</span><span style="">&nbsp;&nbsp;&nbsp; </span><b style="">\_
0:0:0:1 sdb 8:16<span style="">&nbsp; </span>[failed]</b></span></p>

<p class="MsoNormal"><b style=""><span style="font-size: 9pt; line-height: 115%;" lang="EN-US"><span style="">&nbsp;&nbsp;&nbsp;&nbsp; </span>\_ 1:0:0:1 sdf 8:80<span style="">&nbsp; </span>[failed]</span></b></p>

and<br>mpath0:<br>

<p class="MsoNormal"><span style="font-size: 9pt; line-height: 115%;" lang="EN-US">\_ round-robin 0 [enabled]</span></p>

<p class="MsoNormal"><b style=""><span style="font-size: 9pt; line-height: 115%;" lang="EN-US"><span style="">&nbsp;&nbsp;&nbsp;&nbsp; </span>\_ 0:0:0:0 sda 8:0<span style="">&nbsp;&nbsp; </span>[failed]</span></b></p>

<p class="MsoNormal"><b style=""><span style="font-size: 9pt; line-height: 115%;" lang="EN-US"><span style="">&nbsp;&nbsp;&nbsp;&nbsp; </span>\_ 1:0:0:0 sde 8:64<span style="">&nbsp; </span>[failed]</span></b></p>

while the other two path group remained active.<br>At the end of upgrade, probably with the second controller update, I get the situation below.<br>while other servers with windows and Linux (using sdd) came back with all paths, this server retains two paths in failed state:<br>
<br>

<p class="MsoNormal" style="margin-bottom: 6pt;"><span style="font-size: 9pt; line-height: 115%;" lang="EN-US">[root@test-rhel-p
RPMS]# multipath -l</span></p>

<p class="MsoNormal" style="margin-bottom: 6pt;"><span style="font-size: 9pt; line-height: 115%;" lang="EN-US">mpath1
(3600507630efe05800000000000001700)</span></p>

<p class="MsoNormal" style="margin-bottom: 6pt;"><span style="font-size: 9pt; line-height: 115%;" lang="EN-US">[size=20
GB][features=&quot;1 queue_if_no_path&quot;][hwhandler=&quot;0&quot;]</span></p>

<p class="MsoNormal" style="margin-bottom: 6pt;"><span style="font-size: 9pt; line-height: 115%;" lang="EN-US">\_ round-robin
0 [enabled]</span></p>

<p class="MsoNormal" style="margin-bottom: 6pt;"><span style="font-size: 9pt; line-height: 115%;" lang="EN-US"><b><span style="">&nbsp;</span>\_ 0:0:1:1 sdd 8:48<span style="">&nbsp; </span>[failed][faulty]</b></span></p>

<p class="MsoNormal" style="margin-bottom: 6pt;"><span style="font-size: 9pt; line-height: 115%;" lang="EN-US"><span style="">&nbsp;</span>\_ 1:0:1:1 sdh 8:112 [active]</span></p>

<p class="MsoNormal" style="margin-bottom: 6pt;"><span style="font-size: 9pt; line-height: 115%;" lang="EN-US">\_ round-robin
0 [enabled]</span></p>

<p class="MsoNormal" style="margin-bottom: 6pt;"><span style="font-size: 9pt; line-height: 115%;" lang="EN-US"><span style="">&nbsp;</span>\_ 0:0:0:1 sdb 8:16<span style="">&nbsp; </span>[active]</span></p>

<p class="MsoNormal" style="margin-bottom: 6pt;"><span style="font-size: 9pt; line-height: 115%;" lang="EN-US"><span style="">&nbsp;</span>\_ 1:0:0:1 sdf 8:80<span style="">&nbsp; </span>[active]</span></p>

<p class="MsoNormal" style="margin-bottom: 6pt;"><span style="font-size: 9pt; line-height: 115%;" lang="EN-US">&nbsp;</span></p>

<p class="MsoNormal" style="margin-bottom: 6pt;"><span style="font-size: 9pt; line-height: 115%;" lang="EN-US">mpath0
(3600507630efe05800000000000001600)</span></p>

<p class="MsoNormal" style="margin-bottom: 6pt;"><span style="font-size: 9pt; line-height: 115%;" lang="EN-US">[size=20
GB][features=&quot;1 queue_if_no_path&quot;][hwhandler=&quot;0&quot;]</span></p>

<p class="MsoNormal" style="margin-bottom: 6pt;"><span style="font-size: 9pt; line-height: 115%;" lang="EN-US">\_ round-robin
0 [active]</span></p>

<p class="MsoNormal" style="margin-bottom: 6pt;"><span style="font-size: 9pt; line-height: 115%;" lang="EN-US"><span style="">&nbsp;</span>\_ 0:0:0:0 sda 8:0<span style="">&nbsp;&nbsp; </span>[active]</span></p>

<p class="MsoNormal" style="margin-bottom: 6pt;"><span style="font-size: 9pt; line-height: 115%;" lang="EN-US"><span style="">&nbsp;</span>\_ 1:0:0:0 sde 8:64<span style="">&nbsp; </span>[active]</span></p>

<p class="MsoNormal" style="margin-bottom: 6pt;"><span style="font-size: 9pt; line-height: 115%;" lang="EN-US">\_ round-robin
0 [enabled]</span></p>

<p class="MsoNormal" style="margin-bottom: 6pt;"><span style="font-size: 9pt; line-height: 115%;" lang="EN-US"><b><span style="">&nbsp;</span>\_ 0:0:1:0 sdc 8:32<span style="">&nbsp; </span>[failed][faulty]</b></span></p>

<p class="MsoNormal" style="margin-bottom: 6pt;"><span style="font-size: 9pt; line-height: 115%;" lang="EN-US"><span style="">&nbsp;</span>\_ 1:0:1:0 sdg 8:96<span style="">&nbsp; </span>[active]</span></p>

<br>with messages every 5 seconds of type:<br><br>error calling out /sbin/mpath_prio_alua /dev/sdc<br>error calling out /sbin/mpath_prio_alua /dev/sdd<br><br>Other information:<br>[root@test-rhel-p ]# sg_inq /dev/sdc<br>
sg_inq: error opening file: /dev/sdc: No such device or address<br><br>[root@test-rhel-p RPMS]# ll /dev/sdc<br>brw-rw----&nbsp; 1 root disk 8, 32 Jun 11 19:03 /dev/sdc<br><br>[root@test-rhel-p RPMS]# sg_inq /dev/sda<br>standard INQUIRY:<br>
&nbsp; PQual=0&nbsp; Device_type=0&nbsp; RMB=0&nbsp; version=0x05&nbsp; [SPC-3]<br>&nbsp; [AERC=0]&nbsp; [TrmTsk=0]&nbsp; NormACA=1&nbsp; HiSUP=1&nbsp; Resp_data_format=2<br>&nbsp; SCCS=0&nbsp; ACC=0&nbsp; TGPS=1&nbsp; 3PC=0&nbsp; Protect=0&nbsp; BQue=0<br>&nbsp; EncServ=0&nbsp; MultiP=1 (VS=0)&nbsp; [MChngr=0]&nbsp; [ACKREQQ=0]&nbsp; Addr16=0<br>
&nbsp; [RelAdr=0]&nbsp; WBus16=0&nbsp; Sync=0&nbsp; Linked=0&nbsp; [TranDis=0]&nbsp; CmdQue=1<br>&nbsp; Clocking=0x0&nbsp; QAS=0&nbsp; IUS=0<br>&nbsp;&nbsp;&nbsp; length=164 (0xa4)&nbsp;&nbsp; Peripheral device type: disk<br>&nbsp;Vendor identification: IBM<br>&nbsp;Product identification: 1750500<br>
&nbsp;Product revision level: .441<br>&nbsp;Unit serial number: 68778501600<br><br>Any help to get up the paths?<br>Could it help a scsi rescan? What should be the correct command in this case?<br>The system is operational and without interruption on disk acces for the users, but I don&#39;t understand why the paths don&#39;t come up again...<br>
<br>Thanks in advance for help or suggestions.<br>Gianluca<br><br><br>

------=_Part_34754_21527725.1213352055322--


--===============0601009843==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0601009843==--

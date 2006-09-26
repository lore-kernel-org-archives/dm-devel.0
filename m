From: Butler <tears.the@gmail.com>
Subject: Help! multipath of iscsi device doesn't work!
Date: Tue, 26 Sep 2006 14:50:22 +0800
Message-ID: <607ab8450609252350q2911cbeby9dadbf36dbdd654a@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1665119321=="
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

--===============1665119321==
Content-Type: multipart/alternative;
	boundary="----=_Part_457_2964960.1159253422805"

------=_Part_457_2964960.1159253422805
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Dear all,

I tried to use dm-multipath to access a iscsi-target (IET) with open-iscsi.
However, I have no luck to make it work.

I connect to the same target with 2 NIC and connect with open-iscsi as 2
devices (/dev/sdb & /dev/sdc).

$ /sbin/scsi_id -g -u -s /block/sda
1ATA_____ST3120813AS_________________________________________3LS09TWT
$ /sbin/scsi_id -g -u -s /block/sdb
14945540000000000325f3000000000000000000000000000
$/sbin/scsi_id -g -u -s /block/sdc
14945540000000000325f3000000000000000000000000000

where sda is internal SATA disk,
sdb & sdc are iscsi devices of the same target thru 2 NIC.

When I start multpathd, I found the following error message :
   Sep 25 17:03:34 liverpool multipathd: error calling out /sbin/scsi_id -g
-u -s /block/sdb

Then I tried to use "multipath -v2"  but nothing happen.

Please help! Thanks a lot!

open-iscsi version : v1.1-619
linux : 2.6.17-1.2142_FC4smp


Full log message:

Sep 25 16:39:31 liverpool kernel: device-mapper: dm-multipath version
1.0.4loaded
Sep 25 16:39:43 liverpool kernel: device-mapper: dm-round-robin version
1.0.0 loaded

Sep 25 17:01:23 liverpool kernel: scsi8 : iSCSI Initiator over TCP/IP,
v1.1-619
Sep 25 17:01:24 liverpool kernel:   Vendor: IET       Model:
VIRTUAL-DISK      Rev: 0
Sep 25 17:01:24 liverpool kernel:   Type:
Direct-Access                      ANSI SCSI revision: 04
Sep 25 17:01:24 liverpool kernel: SCSI device sdb: 12582912 512-byte hdwr
sectors (6442 MB)
Sep 25 17:01:24 liverpool kernel: sdb: Write Protect is off
Sep 25 17:01:24 liverpool kernel: SCSI device sdb: drive cache: write back
Sep 25 17:01:24 liverpool kernel: SCSI device sdb: 12582912 512-byte hdwr
sectors (6442 MB)
Sep 25 17:01:24 liverpool kernel: sdb: Write Protect is off
Sep 25 17:01:24 liverpool kernel: SCSI device sdb: drive cache: write back
Sep 25 17:01:24 liverpool kernel:  sdb: sdb1
Sep 25 17:01:24 liverpool kernel: sd 8:0:0:0: Attached scsi disk sdb
Sep 25 17:01:24 liverpool iscsid: connection4:0 is operational now
Sep 25 17:01:24 liverpool scsi.agent[4618]: disk at
/devices/platform/host8/session4/target8:0:0/8:0:0:0
Sep 25 17:01:31 liverpool kernel: scsi9 : iSCSI Initiator over TCP/IP,
v1.1-619
Sep 25 17:01:32 liverpool iscsid: picking unique OUI for the same target
node name iqn.2006-09.com.myhost:storage.vg2-sn-abcde
Sep 25 17:01:32 liverpool kernel:   Vendor: IET       Model:
VIRTUAL-DISK      Rev: 0
Sep 25 17:01:32 liverpool kernel:   Type:
Direct-Access                      ANSI SCSI revision: 04
Sep 25 17:01:32 liverpool kernel: SCSI device sdc: 12582912 512-byte hdwr
sectors (6442 MB)
Sep 25 17:01:32 liverpool kernel: sdc: Write Protect is off
Sep 25 17:01:32 liverpool kernel: SCSI device sdc: drive cache: write back
Sep 25 17:01:32 liverpool kernel: SCSI device sdc: 12582912 512-byte hdwr
sectors (6442 MB)
Sep 25 17:01:32 liverpool kernel: sdc: Write Protect is off
Sep 25 17:01:32 liverpool kernel: SCSI device sdc: drive cache: write back
Sep 25 17:01:32 liverpool kernel:  sdc: sdc1
Sep 25 17:01:32 liverpool kernel: sd 9:0:0:0: Attached scsi disk sdc
Sep 25 17:01:33 liverpool scsi.agent[4693]: disk at
/devices/platform/host9/session5/target9:0:0/9:0:0:0
Sep 25 17:01:33 liverpool iscsid: connection5:0 is operational now

Sep 25 17:03:34 liverpool multipathd: --------start up--------
Sep 25 17:03:34 liverpool multipathd: read /etc/multipath.conf
Sep 25 17:03:34 liverpool multipathd: ramfs maxsize is 100706
Sep 25 17:03:34 liverpool multipathd: start DM events thread
Sep 25 17:03:34 liverpool multipathd: initial reconfigure multipath maps
Sep 25 17:03:34 liverpool multipathd: path checkers start up
Sep 25 17:03:34 liverpool multipathd: refresh devmaps list
Sep 25 17:03:34 liverpool multipathd: refresh paths list
Sep 25 17:03:34 liverpool multipathd: dm-0 blacklisted
Sep 25 17:03:34 liverpool multipathd: fd0 blacklisted
Sep 25 17:03:34 liverpool multipathd: path hda not found in pathvec
Sep 25 17:03:34 liverpool multipathd: ===== path hda =====
Sep 25 17:03:34 liverpool multipathd: md0 blacklisted
Sep 25 17:03:34 liverpool multipathd: ram0 blacklisted
Sep 25 17:03:34 liverpool multipathd: ram10 blacklisted
Sep 25 17:03:34 liverpool multipathd: ram11 blacklisted
Sep 25 17:03:34 liverpool multipathd: ram12 blacklisted
Sep 25 17:03:34 liverpool multipathd: ram13 blacklisted
Sep 25 17:03:34 liverpool multipathd: ram14 blacklisted
Sep 25 17:03:34 liverpool multipathd: ram15 blacklisted
Sep 25 17:03:34 liverpool multipathd: ram1 blacklisted
Sep 25 17:03:34 liverpool multipathd: ram2 blacklisted
Sep 25 17:03:34 liverpool multipathd: ram3 blacklisted
Sep 25 17:03:34 liverpool multipathd: ram4 blacklisted
Sep 25 17:03:34 liverpool multipathd: ram5 blacklisted
Sep 25 17:03:34 liverpool multipathd: ram6 blacklisted
Sep 25 17:03:34 liverpool multipathd: ram7 blacklisted
Sep 25 17:03:34 liverpool multipathd: ram8 blacklisted
Sep 25 17:03:34 liverpool multipathd: ram9 blacklisted
Sep 25 17:03:34 liverpool multipathd: path sda not found in pathvec
Sep 25 17:03:34 liverpool multipathd: ===== path sda =====
Sep 25 17:03:34 liverpool multipathd: vendor = ATA
Sep 25 17:03:34 liverpool multipathd: product = ST3120813AS
Sep 25 17:03:34 liverpool multipathd: rev = 2AAA
Sep 25 17:03:34 liverpool multipathd: dev_t = 8:0
Sep 25 17:03:34 liverpool multipathd: size = 234441648
Sep 25 17:03:34 liverpool multipathd: h:b:t:l = 1:0:0:0
Sep 25 17:03:34 liverpool multipathd: tgt_node_name =
Sep 25 17:03:34 liverpool multipathd: serial =             3LS09TWT
Sep 25 17:03:34 liverpool multipathd: path checker = readsector0 (internal
default)
Sep 25 17:03:34 liverpool multipathd: state = 2
Sep 25 17:03:34 liverpool multipathd: getprio = (null) (internal default)
Sep 25 17:03:34 liverpool multipathd: prio = 1
Sep 25 17:03:34 liverpool multipathd: getuid = /sbin/scsi_id -g -u -s
/block/%n (internal default)
Sep 25 17:03:34 liverpool multipathd: error calling out /sbin/scsi_id -g -u
-s /block/sda
Sep 25 17:03:34 liverpool multipathd: uid =  (callout)
Sep 25 17:03:34 liverpool multipathd: path sdb not found in pathvec
Sep 25 17:03:34 liverpool multipathd: ===== path sdb =====
Sep 25 17:03:34 liverpool multipathd: vendor = IET
Sep 25 17:03:34 liverpool multipathd: product = VIRTUAL-DISK
Sep 25 17:03:34 liverpool multipathd: rev = 0
Sep 25 17:03:34 liverpool multipathd: dev_t = 8:16
Sep 25 17:03:34 liverpool multipathd: size = 12582912
Sep 25 17:03:34 liverpool multipathd: h:b:t:l = 8:0:0:0
Sep 25 17:03:34 liverpool multipathd: tgt_node_name =
Sep 25 17:03:34 liverpool multipathd: serial =
Sep 25 17:03:34 liverpool multipathd: path checker = readsector0 (internal
default)
Sep 25 17:03:34 liverpool multipathd: state = 2
Sep 25 17:03:34 liverpool multipathd: getprio = (null) (internal default)
Sep 25 17:03:34 liverpool multipathd: prio = 1
Sep 25 17:03:34 liverpool multipathd: getuid = /sbin/scsi_id -g -u -s
/block/%n (internal default)
Sep 25 17:03:34 liverpool multipathd: error calling out /sbin/scsi_id -g -u
-s /block/sdb
Sep 25 17:03:34 liverpool multipathd: uid =  (callout)
Sep 25 17:03:34 liverpool multipathd: path sdc not found in pathvec
Sep 25 17:03:34 liverpool multipathd: ===== path sdc =====
Sep 25 17:03:34 liverpool multipathd: vendor = IET
Sep 25 17:03:34 liverpool multipathd: product = VIRTUAL-DISK
Sep 25 17:03:34 liverpool multipathd: rev = 0
Sep 25 17:03:34 liverpool multipathd: dev_t = 8:32
Sep 25 17:03:34 liverpool multipathd: size = 12582912
Sep 25 17:03:35 liverpool multipathd: h:b:t:l = 9:0:0:0
Sep 25 17:03:35 liverpool multipathd: tgt_node_name =
Sep 25 17:03:35 liverpool multipathd: state = 2
Sep 25 17:03:35 liverpool multipathd: prio = 1
Sep 25 17:03:44 liverpool multipathd: ===== path hda =====
Sep 25 17:03:44 liverpool multipathd: path checker = readsector0 (internal
default)
Sep 25 17:03:44 liverpool multipathd: : no usable fd
Sep 25 17:03:44 liverpool multipathd: reconfigure  multipath
Sep 25 17:03:44 liverpool multipathd: refresh devmaps list
Sep 25 17:03:44 liverpool multipathd: refresh paths list
Sep 25 17:03:44 liverpool multipathd: dm-0 blacklisted
Sep 25 17:03:44 liverpool multipathd: fd0 blacklisted
Sep 25 17:03:44 liverpool multipathd: ===== path hda =====
Sep 25 17:03:44 liverpool multipathd: md0 blacklisted
Sep 25 17:03:44 liverpool multipathd: ram0 blacklisted
Sep 25 17:03:44 liverpool multipathd: ram10 blacklisted
Sep 25 17:03:44 liverpool multipathd: ram11 blacklisted
Sep 25 17:03:44 liverpool multipathd: ram12 blacklisted
Sep 25 17:03:44 liverpool multipathd: ram13 blacklisted
Sep 25 17:03:44 liverpool multipathd: ram14 blacklisted
Sep 25 17:03:44 liverpool multipathd: ram15 blacklisted
Sep 25 17:03:44 liverpool multipathd: ram1 blacklisted
Sep 25 17:03:44 liverpool multipathd: ram2 blacklisted
Sep 25 17:03:44 liverpool multipathd: ram3 blacklisted
Sep 25 17:03:44 liverpool multipathd: ram4 blacklisted
Sep 25 17:03:44 liverpool multipathd: ram5 blacklisted
Sep 25 17:03:44 liverpool multipathd: ram6 blacklisted
Sep 25 17:03:44 liverpool multipathd: ram7 blacklisted
Sep 25 17:03:44 liverpool multipathd: ram8 blacklisted
Sep 25 17:03:44 liverpool multipathd: ram9 blacklisted
Sep 25 17:03:44 liverpool multipathd: ===== path sda =====
Sep 25 17:03:44 liverpool multipathd: path checker = readsector0 (internal
default)
Sep 25 17:03:44 liverpool multipathd: ===== path sdb =====
Sep 25 17:03:44 liverpool multipathd: path checker = readsector0 (internal
default)
Sep 25 17:03:44 liverpool multipathd: ===== path sdc =====
Sep 25 17:03:44 liverpool multipathd: path checker = readsector0 (internal
default)
Sep 25 17:03:44 liverpool multipathd: start up event loops
Sep 25 17:03:44 liverpool multipathd: 0 pending event(s)

-- 
Butler

------=_Part_457_2964960.1159253422805
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div>Dear all,<br><br>I tried to use dm-multipath to access a iscsi-target (IET) with open-iscsi. However, I have no luck to make it work.<br><br>I connect to the same target with 2 NIC and connect with open-iscsi as 2 devices (/dev/sdb &amp; /dev/sdc). 
<br><br><font face="courier new,monospace">$ /sbin/scsi_id -g -u -s /block/sda<br>1ATA_____ST3120813AS_________________________________________3LS09TWT<br></font><span style="FONT-FAMILY: courier new,monospace"><font face="courier new,monospace">
$</font> /sbin/scsi_id -g -u -s /block/sdb</span><br style="FONT-FAMILY: courier new,monospace"><span style="FONT-FAMILY: courier new,monospace">14945540000000000325f3000000000000000000000000000</span><br style="FONT-FAMILY: courier new,monospace">
<span style="FONT-FAMILY: courier new,monospace">$/sbin/scsi_id -g -u -s /block/sdc</span><br style="FONT-FAMILY: courier new,monospace"><span style="FONT-FAMILY: courier new,monospace">14945540000000000325f3000000000000000000000000000
</span><br style="FONT-FAMILY: courier new,monospace"><br>where sda is internal SATA disk, </div>
<div>sdb &amp; sdc are iscsi devices of the same target&nbsp;thru 2 NIC.<br><br>When I start multpathd, I found the following error message : <br><span style="FONT-FAMILY: courier new,monospace">&nbsp;&nbsp; Sep 25 17:03:34 liverpool multipathd: error calling out /sbin/scsi_id -g -u -s /block/sdb
</span><br><br>Then I tried to use &quot;multipath -v2&quot;&nbsp; but nothing happen. <br><br>Please help! Thanks a lot!<br><br>open-iscsi version : <span style="FONT-FAMILY: courier new,monospace">v1.1-619<br>linux : 2.6.17-1.2142_FC4smp
<br></span><br><br>Full log message:<br><br><span style="FONT-FAMILY: courier new,monospace">Sep 25 16:39:31 liverpool kernel: device-mapper: dm-multipath version 1.0.4 loaded<br>Sep 25 16:39:43 liverpool kernel: device-mapper: dm-round-robin version 
1.0.0 loaded<br><br>Sep 25 17:01:23 liverpool kernel: scsi8 : iSCSI Initiator over TCP/IP, v1.1-619<br>Sep 25 17:01:24 liverpool kernel:&nbsp;&nbsp; Vendor: IET&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: VIRTUAL-DISK&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0<br>Sep 25 17:01:24 liverpool kernel:&nbsp;&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 04
<br>Sep 25 17:01:24 liverpool kernel: SCSI device sdb: 12582912 512-byte hdwr sectors (6442 MB) <br>Sep 25 17:01:24 liverpool kernel: sdb: Write Protect is off<br>Sep 25 17:01:24 liverpool kernel: SCSI device sdb: drive cache: write back
<br>Sep 25 17:01:24 liverpool kernel: SCSI device sdb: 12582912 512-byte hdwr sectors (6442 MB) <br>Sep 25 17:01:24 liverpool kernel: sdb: Write Protect is off<br>Sep 25 17:01:24 liverpool kernel: SCSI device sdb: drive cache: write back
<br>Sep 25 17:01:24 liverpool kernel:&nbsp; sdb: sdb1<br>Sep 25 17:01:24 liverpool kernel: sd 8:0:0:0: Attached scsi disk sdb <br>Sep 25 17:01:24 liverpool iscsid: connection4:0 is operational now<br>Sep 25 17:01:24 liverpool 
scsi.agent[4618]: disk at /devices/platform/host8/session4/target8:0:0/8:0:0:0<br>Sep 25 17:01:31 liverpool kernel: scsi9 : iSCSI Initiator over TCP/IP, v1.1-619<br>Sep 25 17:01:32 liverpool iscsid: picking unique OUI for the same target node name 
iqn.2006-09.com.myhost:storage.vg2-sn-abcde<br>Sep 25 17:01:32 liverpool kernel:&nbsp;&nbsp; Vendor: IET&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: VIRTUAL-DISK&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0 <br>Sep 25 17:01:32 liverpool kernel:&nbsp;&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 04
<br>Sep 25 17:01:32 liverpool kernel: SCSI device sdc: 12582912 512-byte hdwr sectors (6442 MB)<br>Sep 25 17:01:32 liverpool kernel: sdc: Write Protect is off <br>Sep 25 17:01:32 liverpool kernel: SCSI device sdc: drive cache: write back
<br>Sep 25 17:01:32 liverpool kernel: SCSI device sdc: 12582912 512-byte hdwr sectors (6442 MB)<br>Sep 25 17:01:32 liverpool kernel: sdc: Write Protect is off <br>Sep 25 17:01:32 liverpool kernel: SCSI device sdc: drive cache: write back
<br>Sep 25 17:01:32 liverpool kernel:&nbsp; sdc: sdc1<br>Sep 25 17:01:32 liverpool kernel: sd 9:0:0:0: Attached scsi disk sdc<br>Sep 25 17:01:33 liverpool scsi.agent[4693]: disk at /devices/platform/host9/session5/target9:0:0/9:0:0:0
<br>Sep 25 17:01:33 liverpool iscsid: connection5:0 is operational now<br><br>Sep 25 17:03:34 liverpool multipathd: --------start up--------<br>Sep 25 17:03:34 liverpool multipathd: read /etc/multipath.conf<br>Sep 25 17:03:34 liverpool multipathd: ramfs maxsize is 100706
<br>Sep 25 17:03:34 liverpool multipathd: start DM events thread<br>Sep 25 17:03:34 liverpool multipathd: initial reconfigure multipath maps <br>Sep 25 17:03:34 liverpool multipathd: path checkers start up<br>Sep 25 17:03:34 liverpool multipathd: refresh devmaps list
<br>Sep 25 17:03:34 liverpool multipathd: refresh paths list<br>Sep 25 17:03:34 liverpool multipathd: dm-0 blacklisted <br>Sep 25 17:03:34 liverpool multipathd: fd0 blacklisted<br>Sep 25 17:03:34 liverpool multipathd: path hda not found in pathvec
<br>Sep 25 17:03:34 liverpool multipathd: ===== path hda =====<br>Sep 25 17:03:34 liverpool multipathd: md0 blacklisted <br>Sep 25 17:03:34 liverpool multipathd: ram0 blacklisted<br>Sep 25 17:03:34 liverpool multipathd: ram10 blacklisted
<br>Sep 25 17:03:34 liverpool multipathd: ram11 blacklisted<br>Sep 25 17:03:34 liverpool multipathd: ram12 blacklisted <br>Sep 25 17:03:34 liverpool multipathd: ram13 blacklisted<br>Sep 25 17:03:34 liverpool multipathd: ram14 blacklisted
<br>Sep 25 17:03:34 liverpool multipathd: ram15 blacklisted<br>Sep 25 17:03:34 liverpool multipathd: ram1 blacklisted <br>Sep 25 17:03:34 liverpool multipathd: ram2 blacklisted<br>Sep 25 17:03:34 liverpool multipathd: ram3 blacklisted
<br>Sep 25 17:03:34 liverpool multipathd: ram4 blacklisted<br>Sep 25 17:03:34 liverpool multipathd: ram5 blacklisted <br>Sep 25 17:03:34 liverpool multipathd: ram6 blacklisted<br>Sep 25 17:03:34 liverpool multipathd: ram7 blacklisted
<br>Sep 25 17:03:34 liverpool multipathd: ram8 blacklisted<br>Sep 25 17:03:34 liverpool multipathd: ram9 blacklisted <br>Sep 25 17:03:34 liverpool multipathd: path sda not found in pathvec<br>Sep 25 17:03:34 liverpool multipathd: ===== path sda =====
<br>Sep 25 17:03:34 liverpool multipathd: vendor = ATA<br>Sep 25 17:03:34 liverpool multipathd: product = ST3120813AS <br>Sep 25 17:03:34 liverpool multipathd: rev = 2AAA<br>Sep 25 17:03:34 liverpool multipathd: dev_t = 8:0
<br>Sep 25 17:03:34 liverpool multipathd: size = 234441648<br>Sep 25 17:03:34 liverpool multipathd: h:b:t:l = 1:0:0:0 <br>Sep 25 17:03:34 liverpool multipathd: tgt_node_name =<br>Sep 25 17:03:34 liverpool multipathd: serial =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3LS09TWT
<br>Sep 25 17:03:34 liverpool multipathd: path checker = readsector0 (internal default)<br>Sep 25 17:03:34 liverpool multipathd: state = 2 <br>Sep 25 17:03:34 liverpool multipathd: getprio = (null) (internal default)<br>Sep 25 17:03:34 liverpool multipathd: prio = 1
<br>Sep 25 17:03:34 liverpool multipathd: getuid = /sbin/scsi_id -g -u -s /block/%n (internal default) <br>Sep 25 17:03:34 liverpool multipathd: error calling out /sbin/scsi_id -g -u -s /block/sda<br>Sep 25 17:03:34 liverpool multipathd: uid =&nbsp; (callout)
<br>Sep 25 17:03:34 liverpool multipathd: path sdb not found in pathvec <br>Sep 25 17:03:34 liverpool multipathd: ===== path sdb =====<br>Sep 25 17:03:34 liverpool multipathd: vendor = IET<br>Sep 25 17:03:34 liverpool multipathd: product = VIRTUAL-DISK
<br>Sep 25 17:03:34 liverpool multipathd: rev = 0 <br>Sep 25 17:03:34 liverpool multipathd: dev_t = 8:16<br>Sep 25 17:03:34 liverpool multipathd: size = 12582912<br>Sep 25 17:03:34 liverpool multipathd: h:b:t:l = 8:0:0:0<br>
Sep 25 17:03:34 liverpool multipathd: tgt_node_name = <br>Sep 25 17:03:34 liverpool multipathd: serial =<br>Sep 25 17:03:34 liverpool multipathd: path checker = readsector0 (internal default)<br>Sep 25 17:03:34 liverpool multipathd: state = 2
<br>Sep 25 17:03:34 liverpool multipathd: getprio = (null) (internal default) <br>Sep 25 17:03:34 liverpool multipathd: prio = 1<br>Sep 25 17:03:34 liverpool multipathd: getuid = /sbin/scsi_id -g -u -s /block/%n (internal default)
<br>Sep 25 17:03:34 liverpool multipathd: error calling out /sbin/scsi_id -g -u -s /block/sdb <br>Sep 25 17:03:34 liverpool multipathd: uid =&nbsp; (callout)<br>Sep 25 17:03:34 liverpool multipathd: path sdc not found in pathvec
<br>Sep 25 17:03:34 liverpool multipathd: ===== path sdc =====<br>Sep 25 17:03:34 liverpool multipathd: vendor = IET <br>Sep 25 17:03:34 liverpool multipathd: product = VIRTUAL-DISK<br>Sep 25 17:03:34 liverpool multipathd: rev = 0
<br>Sep 25 17:03:34 liverpool multipathd: dev_t = 8:32<br>Sep 25 17:03:34 liverpool multipathd: size = 12582912 <br>Sep 25 17:03:35 liverpool multipathd: h:b:t:l = 9:0:0:0<br>Sep 25 17:03:35 liverpool multipathd: tgt_node_name =
<br>Sep 25 17:03:35 liverpool multipathd: state = 2<br>Sep 25 17:03:35 liverpool multipathd: prio = 1<br>Sep 25 17:03:44 liverpool multipathd: ===== path hda =====<br>Sep 25 17:03:44 liverpool multipathd: path checker = readsector0 (internal default)
<br>Sep 25 17:03:44 liverpool multipathd: : no usable fd<br>Sep 25 17:03:44 liverpool multipathd: reconfigure&nbsp; multipath <br>Sep 25 17:03:44 liverpool multipathd: refresh devmaps list<br>Sep 25 17:03:44 liverpool multipathd: refresh paths list
<br>Sep 25 17:03:44 liverpool multipathd: dm-0 blacklisted<br>Sep 25 17:03:44 liverpool multipathd: fd0 blacklisted <br>Sep 25 17:03:44 liverpool multipathd: ===== path hda =====<br>Sep 25 17:03:44 liverpool multipathd: md0 blacklisted
<br>Sep 25 17:03:44 liverpool multipathd: ram0 blacklisted<br>Sep 25 17:03:44 liverpool multipathd: ram10 blacklisted <br>Sep 25 17:03:44 liverpool multipathd: ram11 blacklisted<br>Sep 25 17:03:44 liverpool multipathd: ram12 blacklisted
<br>Sep 25 17:03:44 liverpool multipathd: ram13 blacklisted<br>Sep 25 17:03:44 liverpool multipathd: ram14 blacklisted <br>Sep 25 17:03:44 liverpool multipathd: ram15 blacklisted<br>Sep 25 17:03:44 liverpool multipathd: ram1 blacklisted
<br>Sep 25 17:03:44 liverpool multipathd: ram2 blacklisted<br>Sep 25 17:03:44 liverpool multipathd: ram3 blacklisted <br>Sep 25 17:03:44 liverpool multipathd: ram4 blacklisted<br>Sep 25 17:03:44 liverpool multipathd: ram5 blacklisted
<br>Sep 25 17:03:44 liverpool multipathd: ram6 blacklisted<br>Sep 25 17:03:44 liverpool multipathd: ram7 blacklisted <br>Sep 25 17:03:44 liverpool multipathd: ram8 blacklisted<br>Sep 25 17:03:44 liverpool multipathd: ram9 blacklisted
<br>Sep 25 17:03:44 liverpool multipathd: ===== path sda =====<br>Sep 25 17:03:44 liverpool multipathd: path checker = readsector0 (internal default) <br>Sep 25 17:03:44 liverpool multipathd: ===== path sdb =====<br>Sep 25 17:03:44 liverpool multipathd: path checker = readsector0 (internal default)
<br>Sep 25 17:03:44 liverpool multipathd: ===== path sdc =====<br>Sep 25 17:03:44 liverpool multipathd: path checker = readsector0 (internal default) <br>Sep 25 17:03:44 liverpool multipathd: start up event loops<br>Sep 25 17:03:44 liverpool multipathd: 0 pending event(s)
<br></span><br>-- <br>Butler </div>

------=_Part_457_2964960.1159253422805--


--===============1665119321==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1665119321==--

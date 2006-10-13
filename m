From: Frederic TEMPORELLI <frederic.temporelli@ext.bull.net>
Subject: multipath tools - 'fail to get path uid' on LUN 0 when
	failback
Date: Fri, 13 Oct 2006 15:54:17 +0200
Message-ID: <452F9A89.6080702@ext.bull.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020200050508020801060908"
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

This is a multi-part message in MIME format.
--------------020200050508020801060908
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed

Hello,


I'm running kernel 2.6.18 + multipath-tools 0.4.7.

Using Emulex HBA (kernel driver 8.1.9) and DDN S2A8500 disk array, multipathd 
generates a 'fail to get path uid' error when failback from link down failure. 
This only happen for LUN0 of the target. All the other LUNs are nicely detected 
and dm are updated for these other LUNs.

attached is the multipathd log (multipathd -d -v4) and the system syslog.
=> I'm thinking that multipathd can't open the /dev/sdX related to LUN0 as soon 
as the the scsi event is received. multipathd processing is delayed (until open 
error is fired) then the other LUNs are processed (with sd that can be opened).
Following such issue, LUN0 can be put back in multipath configuration by running 
by hand multipath command (but we lose the advantage of the multipathd 
monitoring...)

Did anyone get such issue ? any idea to solve it ?
(may be a way to add a delay between event and scsi_id detection ?)

Thanks for your help.

-- 
Frederic TEMPORELLI

--------------020200050508020801060908
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
 name="syslog.log"
Content-Disposition: inline;
 filename="syslog.log"

Oct 13 15:18:17 s_kernel@iotiger3 kernel: lpfc 0000:06:02.1: 1:1305 Link Down Event x4 received Data: x4 x20 x0
Oct 13 15:18:27 s_kernel@iotiger3 kernel: lpfc 0000:06:02.1: 1:0203 Nodev timeout on WWPN 23:0:0:1:ff:3:2:a8 NPort xef Data: x8 x7 x0
Oct 13 15:18:32 s_kernel@iotiger3 kernel: rport-5:0-0: blocked FC remote port time out: removing target and saving binding
Oct 13 15:19:14 s_kernel@iotiger3 kernel: lpfc 0000:06:02.1: 1:1303 Link Up Event x5 received Data: x5 x1 x8 x2
Oct 13 15:19:14 s_kernel@iotiger3 kernel: Vendor: DDN       Model: S2A 8500          Rev: 5.24
Oct 13 15:19:14 s_kernel@iotiger3 kernel: Type:   Direct-Access                      ANSI SCSI revision: 03
Oct 13 15:19:14 s_kernel@iotiger3 kernel: SCSI device sdf: 2048000 512-byte hdwr sectors (1049 MB)
Oct 13 15:19:14 s_kernel@iotiger3 kernel: sdf: Write Protect is off
Oct 13 15:19:14 s_kernel@iotiger3 kernel: sdf: Mode Sense: a7 00 10 08
Oct 13 15:19:14 s_kernel@iotiger3 kernel: SCSI device sdf: drive cache: write through w/ FUA
Oct 13 15:19:14 s_kernel@iotiger3 kernel: SCSI device sdf: 2048000 512-byte hdwr sectors (1049 MB)
Oct 13 15:19:14 s_kernel@iotiger3 kernel: sdf: Write Protect is off
Oct 13 15:19:14 s_kernel@iotiger3 kernel: sdf: Mode Sense: a7 00 10 08
Oct 13 15:19:14 s_kernel@iotiger3 kernel: SCSI device sdf: drive cache: write through w/ FUA
Oct 13 15:19:14 s_kernel@iotiger3 kernel: sdf: unknown partition table
Oct 13 15:19:14 s_kernel@iotiger3 kernel: sd 5:0:0:0: Attached scsi disk sdf
Oct 13 15:19:14 s_kernel@iotiger3 kernel: sd 5:0:0:0: Attached scsi generic sg6 type 0
Oct 13 15:19:14 s_kernel@iotiger3 kernel: Vendor: DDN       Model: S2A 8500          Rev: 5.24
Oct 13 15:19:14 s_kernel@iotiger3 kernel: Type:   Direct-Access                      ANSI SCSI revision: 03
Oct 13 15:19:14 s_kernel@iotiger3 kernel: SCSI device sdg: 571416576 512-byte hdwr sectors (292565 MB)
Oct 13 15:19:14 s_kernel@iotiger3 kernel: sdg: Write Protect is off
Oct 13 15:19:14 s_kernel@iotiger3 kernel: sdg: Mode Sense: a7 00 10 08
Oct 13 15:19:14 s_kernel@iotiger3 kernel: SCSI device sdg: drive cache: write through w/ FUA
Oct 13 15:19:14 s_kernel@iotiger3 kernel: SCSI device sdg: 571416576 512-byte hdwr sectors (292565 MB)
Oct 13 15:19:14 s_kernel@iotiger3 kernel: sdg: Write Protect is off
Oct 13 15:19:14 s_kernel@iotiger3 kernel: sdg: Mode Sense: a7 00 10 08
Oct 13 15:19:14 s_kernel@iotiger3 kernel: SCSI device sdg: drive cache: write through w/ FUA
Oct 13 15:19:14 s_kernel@iotiger3 kernel: sdg: unknown partition table
Oct 13 15:19:14 s_kernel@iotiger3 kernel: sd 5:0:0:1: Attached scsi disk sdg
Oct 13 15:19:14 s_kernel@iotiger3 kernel: sd 5:0:0:1: Attached scsi generic sg7 type 0
Oct 13 15:19:14 s_kernel@iotiger3 kernel: Vendor: DDN       Model: S2A 8500          Rev: 5.24
Oct 13 15:19:14 s_kernel@iotiger3 kernel: Type:   Direct-Access                      ANSI SCSI revision: 03
Oct 13 15:19:14 s_kernel@iotiger3 kernel: SCSI device sdh: 2048000 512-byte hdwr sectors (1049 MB)
Oct 13 15:19:14 s_kernel@iotiger3 kernel: sdh: Write Protect is off
Oct 13 15:19:14 s_kernel@iotiger3 kernel: sdh: Mode Sense: a7 00 10 08
Oct 13 15:19:14 s_kernel@iotiger3 kernel: SCSI device sdh: drive cache: write through w/ FUA
Oct 13 15:19:14 s_kernel@iotiger3 kernel: SCSI device sdh: 2048000 512-byte hdwr sectors (1049 MB)
Oct 13 15:19:14 s_kernel@iotiger3 kernel: sdh: Write Protect is off
Oct 13 15:19:14 s_kernel@iotiger3 kernel: sdh: Mode Sense: a7 00 10 08
Oct 13 15:19:14 s_kernel@iotiger3 kernel: SCSI device sdh: drive cache: write through w/ FUA
Oct 13 15:19:14 s_kernel@iotiger3 kernel: sdh: unknown partition table
Oct 13 15:19:14 s_kernel@iotiger3 kernel: sd 5:0:0:2: Attached scsi disk sdh
Oct 13 15:19:14 s_kernel@iotiger3 kernel: sd 5:0:0:2: Attached scsi generic sg8 type 0
Oct 13 15:19:14 s_kernel@iotiger3 kernel: Vendor: DDN       Model: S2A 8500          Rev: 5.24
Oct 13 15:19:14 s_kernel@iotiger3 kernel: Type:   Direct-Access                      ANSI SCSI revision: 03
Oct 13 15:19:14 s_kernel@iotiger3 kernel: SCSI device sdi: 571416576 512-byte hdwr sectors (292565 MB)
Oct 13 15:19:14 s_kernel@iotiger3 kernel: sdi: Write Protect is off
Oct 13 15:19:14 s_kernel@iotiger3 kernel: sdi: Mode Sense: a7 00 10 08
Oct 13 15:19:14 s_kernel@iotiger3 kernel: SCSI device sdi: drive cache: write through w/ FUA
Oct 13 15:19:14 s_kernel@iotiger3 kernel: SCSI device sdi: 571416576 512-byte hdwr sectors (292565 MB)
Oct 13 15:19:14 s_kernel@iotiger3 kernel: sdi: Write Protect is off
Oct 13 15:19:14 s_kernel@iotiger3 kernel: sdi: Mode Sense: a7 00 10 08
Oct 13 15:19:14 s_kernel@iotiger3 kernel: SCSI device sdi: drive cache: write through w/ FUA
Oct 13 15:19:14 s_kernel@iotiger3 kernel: sdi: unknown partition table
Oct 13 15:19:14 s_kernel@iotiger3 kernel: sd 5:0:0:3: Attached scsi disk sdi
Oct 13 15:19:14 s_kernel@iotiger3 kernel: sd 5:0:0:3: Attached scsi generic sg9 type 0
Oct 13 15:19:14 s_sys@iotiger3 scsi.agent[14745]: disk at /devices/pci0000:05/0000:05:1d.0/0000:06:02.1/host5/rport-5:0-0/target5:0:0/5:0:0:3
Oct 13 15:19:14 s_sys@iotiger3 scsi.agent[14757]: disk at /devices/pci0000:05/0000:05:1d.0/0000:06:02.1/host5/rport-5:0-0/target5:0:0/5:0:0:2
Oct 13 15:19:14 s_sys@iotiger3 scsi.agent[14716]: disk at /devices/pci0000:05/0000:05:1d.0/0000:06:02.1/host5/rport-5:0-0/target5:0:0/5:0:0:1
Oct 13 15:19:14 s_sys@iotiger3 scsi.agent[14734]: disk at /devices/pci0000:05/0000:05:1d.0/0000:06:02.1/host5/rport-5:0-0/target5:0:0/5:0:0:0

--------------020200050508020801060908
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
 name="multipathd.log"
Content-Disposition: inline;
 filename="multipathd.log"

Oct 13 15:18:43 | sdb: directio checker reports path is up
Oct 13 15:18:43 | 8:16: delay next check 80s
Oct 13 15:18:43 | path prio refresh
Oct 13 15:18:43 | sdb: mask = 0x8
Oct 13 15:18:43 | sdb: prio = 1
Oct 13 15:18:43 | sdc: directio checker reports path is up
Oct 13 15:18:43 | 8:32: delay next check 80s
Oct 13 15:18:43 | path prio refresh
Oct 13 15:18:43 | sdc: mask = 0x8
Oct 13 15:18:43 | sdc: prio = 1
Oct 13 15:18:43 | sdd: directio checker reports path is up
Oct 13 15:18:43 | 8:48: delay next check 80s
Oct 13 15:18:43 | path prio refresh
Oct 13 15:18:43 | sdd: mask = 0x8
Oct 13 15:18:43 | sdd: prio = 1
Oct 13 15:18:43 | sde: directio checker reports path is up
Oct 13 15:18:43 | 8:64: delay next check 80s
Oct 13 15:18:43 | path prio refresh
Oct 13 15:18:43 | sde: mask = 0x8
Oct 13 15:18:43 | sde: prio = 1
Oct 13 15:18:44 | tick
Oct 13 15:18:45 | tick
Oct 13 15:18:45 | map garbage collection
Oct 13 15:18:46 | tick
Oct 13 15:18:47 | tick
Oct 13 15:18:48 | tick
Oct 13 15:18:49 | tick
Oct 13 15:18:50 | tick
Oct 13 15:18:51 | tick
Oct 13 15:18:51 | map garbage collection
Oct 13 15:18:52 | tick
Oct 13 15:18:53 | tick
Oct 13 15:18:54 | tick
Oct 13 15:18:55 | tick
Oct 13 15:18:56 | tick
Oct 13 15:18:57 | tick
Oct 13 15:18:57 | map garbage collection
Oct 13 15:18:58 | tick
Oct 13 15:18:59 | tick
Oct 13 15:19:00 | tick
Oct 13 15:19:01 | tick
Oct 13 15:19:02 | tick
Oct 13 15:19:03 | tick
Oct 13 15:19:03 | map garbage collection
Oct 13 15:19:04 | tick
Oct 13 15:19:05 | tick
Oct 13 15:19:06 | tick
Oct 13 15:19:07 | tick
Oct 13 15:19:08 | tick
Oct 13 15:19:09 | tick
Oct 13 15:19:09 | map garbage collection
Oct 13 15:19:10 | tick
Oct 13 15:19:11 | tick
Oct 13 15:19:12 | tick
Oct 13 15:19:13 | tick
Oct 13 15:19:14 | uevent 'add' from '/class/fc_transport/target5:0:0'
Oct 13 15:19:14 | ACTION=add
Oct 13 15:19:14 | DEVPATH=/class/fc_transport/target5:0:0
Oct 13 15:19:14 | SUBSYSTEM=fc_transport
Oct 13 15:19:14 | SEQNUM=1294
Oct 13 15:19:14 | PHYSDEVPATH=/devices/pci0000:05/0000:05:1d.0/0000:06:02.1/host5/rport-5:0-0/target5:0:0
Oct 13 15:19:14 | discard event on /class/fc_transport/target5:0:0
Oct 13 15:19:14 | uevent 'add' from '/devices/pci0000:05/0000:05:1d.0/0000:06:02.1/host5/rport-5:0-0/target5:0:0/5:0:0:0'Oct 13 15:19:14 | ACTION=add
Oct 13 15:19:14 | DEVPATH=/devices/pci0000:05/0000:05:1d.0/0000:06:02.1/host5/rport-5:0-0/target5:0:0/5:0:0:0
Oct 13 15:19:14 | SUBSYSTEM=scsi
Oct 13 15:19:14 | SEQNUM=1295
Oct 13 15:19:14 | PHYSDEVBUS=scsi
Oct 13 15:19:14 | discard event on /devices/pci0000:05/0000:05:1d.0/0000:06:02.1/host5/rport-5:0-0/target5:0:0/5:0:0:0
Oct 13 15:19:14 | uevent 'add' from '/class/scsi_disk/5:0:0:0'
Oct 13 15:19:14 | ACTION=add
Oct 13 15:19:14 | DEVPATH=/class/scsi_disk/5:0:0:0
Oct 13 15:19:14 | SUBSYSTEM=scsi_disk
Oct 13 15:19:14 | SEQNUM=1296
Oct 13 15:19:14 | PHYSDEVPATH=/devices/pci0000:05/0000:05:1d.0/0000:06:02.1/host5/rport-5:0-0/target5:0:0/5:0:0:0
Oct 13 15:19:14 | PHYSDEVBUS=scsi
Oct 13 15:19:14 | PHYSDEVDRIVER=sd
Oct 13 15:19:14 | discard event on /class/scsi_disk/5:0:0:0
Oct 13 15:19:14 | uevent 'add' from '/block/sdf'
Oct 13 15:19:14 | ACTION=add
Oct 13 15:19:14 | DEVPATH=/block/sdf
Oct 13 15:19:14 | SUBSYSTEM=block
Oct 13 15:19:14 | SEQNUM=1297
Oct 13 15:19:14 | MINOR=80
Oct 13 15:19:14 | MAJOR=8
Oct 13 15:19:14 | PHYSDEVPATH=/devices/pci0000:05/0000:05:1d.0/0000:06:02.1/host5/rport-5:0-0/target5:0:0/5:0:0:0
Oct 13 15:19:14 | PHYSDEVBUS=scsi
Oct 13 15:19:14 | PHYSDEVDRIVER=sd
Oct 13 15:19:14 | sdf: add path (uevent)
Oct 13 15:19:14 | sdf: not found in pathvec
Oct 13 15:19:14 | sdf: mask = 0x1f
Oct 13 15:19:14 | sdf: bus = 1
Oct 13 15:19:14 | sdf: dev_t = 8:80
Oct 13 15:19:14 | sdf: size = 2048000
Oct 13 15:19:14 | uevent 'add' from '/class/scsi_device/5:0:0:0'
Oct 13 15:19:14 | ACTION=add
Oct 13 15:19:14 | DEVPATH=/class/scsi_device/5:0:0:0
Oct 13 15:19:14 | SUBSYSTEM=scsi_device
Oct 13 15:19:14 | SEQNUM=1298
Oct 13 15:19:14 | PHYSDEVPATH=/devices/pci0000:05/0000:05:1d.0/0000:06:02.1/host5/rport-5:0-0/target5:0:0/5:0:0:0
Oct 13 15:19:14 | PHYSDEVBUS=scsi
Oct 13 15:19:14 | PHYSDEVDRIVER=sd
Oct 13 15:19:14 | uevent 'add' from '/class/scsi_generic/sg6'
Oct 13 15:19:14 | ACTION=add
Oct 13 15:19:14 | DEVPATH=/class/scsi_generic/sg6
Oct 13 15:19:14 | SUBSYSTEM=scsi_generic
Oct 13 15:19:14 | SEQNUM=1299
Oct 13 15:19:14 | PHYSDEVPATH=/devices/pci0000:05/0000:05:1d.0/0000:06:02.1/host5/rport-5:0-0/target5:0:0/5:0:0:0
Oct 13 15:19:14 | PHYSDEVBUS=scsi
Oct 13 15:19:14 | PHYSDEVDRIVER=sd
Oct 13 15:19:14 | MAJOR=21
Oct 13 15:19:14 | MINOR=6
Oct 13 15:19:14 | uevent 'add' from '/devices/pci0000:05/0000:05:1d.0/0000:06:02.1/host5/rport-5:0-0/target5:0:0/5:0:0:1'Oct 13 15:19:14 | ACTION=add
Oct 13 15:19:14 | DEVPATH=/devices/pci0000:05/0000:05:1d.0/0000:06:02.1/host5/rport-5:0-0/target5:0:0/5:0:0:1
Oct 13 15:19:14 | SUBSYSTEM=scsi
Oct 13 15:19:14 | SEQNUM=1300
Oct 13 15:19:14 | PHYSDEVBUS=scsi
Oct 13 15:19:14 | uevent 'add' from '/class/scsi_disk/5:0:0:1'
Oct 13 15:19:14 | ACTION=add
Oct 13 15:19:14 | DEVPATH=/class/scsi_disk/5:0:0:1
Oct 13 15:19:14 | SUBSYSTEM=scsi_disk
Oct 13 15:19:14 | SEQNUM=1301
Oct 13 15:19:14 | PHYSDEVPATH=/devices/pci0000:05/0000:05:1d.0/0000:06:02.1/host5/rport-5:0-0/target5:0:0/5:0:0:1
Oct 13 15:19:14 | PHYSDEVBUS=scsi
Oct 13 15:19:14 | PHYSDEVDRIVER=sd
Oct 13 15:19:14 | uevent 'add' from '/block/sdg'
Oct 13 15:19:14 | ACTION=add
Oct 13 15:19:14 | DEVPATH=/block/sdg
Oct 13 15:19:14 | SUBSYSTEM=block
Oct 13 15:19:14 | SEQNUM=1302
Oct 13 15:19:14 | MINOR=96
Oct 13 15:19:14 | MAJOR=8
Oct 13 15:19:14 | PHYSDEVPATH=/devices/pci0000:05/0000:05:1d.0/0000:06:02.1/host5/rport-5:0-0/target5:0:0/5:0:0:1
Oct 13 15:19:14 | PHYSDEVBUS=scsi
Oct 13 15:19:14 | PHYSDEVDRIVER=sd
Oct 13 15:19:14 | uevent 'add' from '/class/scsi_device/5:0:0:1'
Oct 13 15:19:14 | ACTION=add
Oct 13 15:19:14 | DEVPATH=/class/scsi_device/5:0:0:1
Oct 13 15:19:14 | SUBSYSTEM=scsi_device
Oct 13 15:19:14 | SEQNUM=1303
Oct 13 15:19:14 | PHYSDEVPATH=/devices/pci0000:05/0000:05:1d.0/0000:06:02.1/host5/rport-5:0-0/target5:0:0/5:0:0:1
Oct 13 15:19:14 | PHYSDEVBUS=scsi
Oct 13 15:19:14 | PHYSDEVDRIVER=sd
Oct 13 15:19:14 | uevent 'add' from '/class/scsi_generic/sg7'
Oct 13 15:19:14 | ACTION=add
Oct 13 15:19:14 | DEVPATH=/class/scsi_generic/sg7
Oct 13 15:19:14 | SUBSYSTEM=scsi_generic
Oct 13 15:19:14 | SEQNUM=1304
Oct 13 15:19:14 | PHYSDEVPATH=/devices/pci0000:05/0000:05:1d.0/0000:06:02.1/host5/rport-5:0-0/target5:0:0/5:0:0:1
Oct 13 15:19:14 | PHYSDEVBUS=scsi
Oct 13 15:19:14 | PHYSDEVDRIVER=sd
Oct 13 15:19:14 | MAJOR=21
Oct 13 15:19:14 | MINOR=7
Oct 13 15:19:14 | uevent 'add' from '/devices/pci0000:05/0000:05:1d.0/0000:06:02.1/host5/rport-5:0-0/target5:0:0/5:0:0:2'Oct 13 15:19:14 | ACTION=add
Oct 13 15:19:14 | DEVPATH=/devices/pci0000:05/0000:05:1d.0/0000:06:02.1/host5/rport-5:0-0/target5:0:0/5:0:0:2
Oct 13 15:19:14 | SUBSYSTEM=scsi
Oct 13 15:19:14 | SEQNUM=1305
Oct 13 15:19:14 | PHYSDEVBUS=scsi
Oct 13 15:19:14 | uevent 'add' from '/class/scsi_disk/5:0:0:2'
Oct 13 15:19:14 | ACTION=add
Oct 13 15:19:14 | DEVPATH=/class/scsi_disk/5:0:0:2
Oct 13 15:19:14 | SUBSYSTEM=scsi_disk
Oct 13 15:19:14 | SEQNUM=1306
Oct 13 15:19:14 | PHYSDEVPATH=/devices/pci0000:05/0000:05:1d.0/0000:06:02.1/host5/rport-5:0-0/target5:0:0/5:0:0:2
Oct 13 15:19:14 | PHYSDEVBUS=scsi
Oct 13 15:19:14 | PHYSDEVDRIVER=sd
Oct 13 15:19:14 | uevent 'add' from '/block/sdh'
Oct 13 15:19:14 | ACTION=add
Oct 13 15:19:14 | DEVPATH=/block/sdh
Oct 13 15:19:14 | SUBSYSTEM=block
Oct 13 15:19:14 | SEQNUM=1307
Oct 13 15:19:14 | MINOR=112
Oct 13 15:19:14 | MAJOR=8
Oct 13 15:19:14 | PHYSDEVPATH=/devices/pci0000:05/0000:05:1d.0/0000:06:02.1/host5/rport-5:0-0/target5:0:0/5:0:0:2
Oct 13 15:19:14 | PHYSDEVBUS=scsi
Oct 13 15:19:14 | PHYSDEVDRIVER=sd
Oct 13 15:19:14 | uevent 'add' from '/class/scsi_device/5:0:0:2'
Oct 13 15:19:14 | ACTION=add
Oct 13 15:19:14 | DEVPATH=/class/scsi_device/5:0:0:2
Oct 13 15:19:14 | SUBSYSTEM=scsi_device
Oct 13 15:19:14 | SEQNUM=1308
Oct 13 15:19:14 | PHYSDEVPATH=/devices/pci0000:05/0000:05:1d.0/0000:06:02.1/host5/rport-5:0-0/target5:0:0/5:0:0:2
Oct 13 15:19:14 | PHYSDEVBUS=scsi
Oct 13 15:19:14 | PHYSDEVDRIVER=sd
Oct 13 15:19:14 | uevent 'add' from '/class/scsi_generic/sg8'
Oct 13 15:19:14 | ACTION=add
Oct 13 15:19:14 | DEVPATH=/class/scsi_generic/sg8
Oct 13 15:19:14 | SUBSYSTEM=scsi_generic
Oct 13 15:19:14 | SEQNUM=1309
Oct 13 15:19:14 | PHYSDEVPATH=/devices/pci0000:05/0000:05:1d.0/0000:06:02.1/host5/rport-5:0-0/target5:0:0/5:0:0:2
Oct 13 15:19:14 | PHYSDEVBUS=scsi
Oct 13 15:19:14 | PHYSDEVDRIVER=sd
Oct 13 15:19:14 | MAJOR=21
Oct 13 15:19:14 | MINOR=8
Oct 13 15:19:14 | uevent 'add' from '/devices/pci0000:05/0000:05:1d.0/0000:06:02.1/host5/rport-5:0-0/target5:0:0/5:0:0:3'Oct 13 15:19:14 | ACTION=add
Oct 13 15:19:14 | DEVPATH=/devices/pci0000:05/0000:05:1d.0/0000:06:02.1/host5/rport-5:0-0/target5:0:0/5:0:0:3
Oct 13 15:19:14 | SUBSYSTEM=scsi
Oct 13 15:19:14 | SEQNUM=1310
Oct 13 15:19:14 | PHYSDEVBUS=scsi
Oct 13 15:19:14 | uevent 'add' from '/class/scsi_disk/5:0:0:3'
Oct 13 15:19:14 | ACTION=add
Oct 13 15:19:14 | DEVPATH=/class/scsi_disk/5:0:0:3
Oct 13 15:19:14 | SUBSYSTEM=scsi_disk
Oct 13 15:19:14 | SEQNUM=1311
Oct 13 15:19:14 | PHYSDEVPATH=/devices/pci0000:05/0000:05:1d.0/0000:06:02.1/host5/rport-5:0-0/target5:0:0/5:0:0:3
Oct 13 15:19:14 | PHYSDEVBUS=scsi
Oct 13 15:19:14 | PHYSDEVDRIVER=sd
Oct 13 15:19:14 | uevent 'add' from '/block/sdi'
Oct 13 15:19:14 | ACTION=add
Oct 13 15:19:14 | DEVPATH=/block/sdi
Oct 13 15:19:14 | SUBSYSTEM=block
Oct 13 15:19:14 | SEQNUM=1312
Oct 13 15:19:14 | MINOR=128
Oct 13 15:19:14 | MAJOR=8
Oct 13 15:19:14 | PHYSDEVPATH=/devices/pci0000:05/0000:05:1d.0/0000:06:02.1/host5/rport-5:0-0/target5:0:0/5:0:0:3
Oct 13 15:19:14 | PHYSDEVBUS=scsi
Oct 13 15:19:14 | PHYSDEVDRIVER=sd
Oct 13 15:19:14 | uevent 'add' from '/class/scsi_device/5:0:0:3'
Oct 13 15:19:14 | ACTION=add
Oct 13 15:19:14 | DEVPATH=/class/scsi_device/5:0:0:3
Oct 13 15:19:14 | SUBSYSTEM=scsi_device
Oct 13 15:19:14 | SEQNUM=1313
Oct 13 15:19:14 | PHYSDEVPATH=/devices/pci0000:05/0000:05:1d.0/0000:06:02.1/host5/rport-5:0-0/target5:0:0/5:0:0:3
Oct 13 15:19:14 | PHYSDEVBUS=scsi
Oct 13 15:19:14 | PHYSDEVDRIVER=sd
Oct 13 15:19:14 | uevent 'add' from '/class/scsi_generic/sg9'
Oct 13 15:19:14 | ACTION=add
Oct 13 15:19:14 | DEVPATH=/class/scsi_generic/sg9
Oct 13 15:19:14 | SUBSYSTEM=scsi_generic
Oct 13 15:19:14 | SEQNUM=1314
Oct 13 15:19:14 | PHYSDEVPATH=/devices/pci0000:05/0000:05:1d.0/0000:06:02.1/host5/rport-5:0-0/target5:0:0/5:0:0:3
Oct 13 15:19:14 | PHYSDEVBUS=scsi
Oct 13 15:19:14 | PHYSDEVDRIVER=sd
Oct 13 15:19:14 | MAJOR=21
Oct 13 15:19:14 | MINOR=9
Oct 13 15:19:14 | sdf: vendor = DDN
Oct 13 15:19:14 | sdf: product = S2A 8500
Oct 13 15:19:14 | sdf: rev = 5.24
Oct 13 15:19:14 | sdf: h:b:t:l = 5:0:0:0
Oct 13 15:19:14 | sdf: tgt_node_name = 0x20000001ff0302a8
Oct 13 15:19:19 | failed to open /dev/sdf
Oct 13 15:19:19 | sdf: failed to get path uid
Oct 13 15:19:19 | uevent trigger error
Oct 13 15:19:19 | Oct 13 15:19:19 | tick
discard event on /class/scsi_device/5:0:0:0
Oct 13 15:19:19 | discard event on /class/scsi_generic/sg6
Oct 13 15:19:19 | discard event on /devices/pci0000:05/0000:05:1d.0/0000:06:02.1/host5/rport-5:0-0/target5:0:0/5:0:0:1
Oct 13 15:19:19 | discard event on /class/scsi_disk/5:0:0:1
Oct 13 15:19:19 | sdg: add path (uevent)
Oct 13 15:19:19 | sdg: not found in pathvec
Oct 13 15:19:19 | sdg: mask = 0x1f
Oct 13 15:19:19 | sdg: bus = 1
Oct 13 15:19:19 | sdg: dev_t = 8:96
Oct 13 15:19:19 | sdg: size = 571416576
Oct 13 15:19:19 | sdg: vendor = DDN
Oct 13 15:19:19 | sdg: product = S2A 8500
Oct 13 15:19:19 | sdg: rev = 5.24
Oct 13 15:19:19 | sdg: h:b:t:l = 5:0:0:1
Oct 13 15:19:19 | sdg: tgt_node_name = 0x20000001ff0302a8
Oct 13 15:19:20 | sdg: serial = 03E0FE360D00
Oct 13 15:19:20 | sdg: path checker = directio (controller setting)
Oct 13 15:19:20 | sdg: state = 2
Oct 13 15:19:20 | sdg: getprio = NULL (internal default)
Oct 13 15:19:20 | sdg: prio = 1
Oct 13 15:19:20 | sdg: getuid = /sbin/scsi_id -g -u -s /block/%n (controller setting)
Oct 13 15:19:20 | sdg: uid = 360001ff02002110103e0fe36220f0d00 (callout)
Oct 13 15:19:20 | 8:32: not found in pathvec
Oct 13 15:19:20 | sdc: ownership set to 360001ff02002110103e0fe36220f0d00
Oct 13 15:19:20 | sdc: mask = 0xc
Oct 13 15:19:20 | sdc: state = 2
Oct 13 15:19:20 | sdc: prio = 1
Oct 13 15:19:20 | sdg: ownership set to 360001ff02002110103e0fe36220f0d00
Oct 13 15:19:20 | sdg: not found in pathvec
Oct 13 15:19:20 | sdg: mask = 0xc
Oct 13 15:19:20 | sdg: state = 2
Oct 13 15:19:20 | sdg: prio = 1
Oct 13 15:19:20 | 360001ff02002110103e0fe36220f0d00: pgfailback = -2 (config file default)
Oct 13 15:19:20 | 360001ff02002110103e0fe36220f0d00: pgpolicy = multibus (controller setting)
Oct 13 15:19:20 | 360001ff02002110103e0fe36220f0d00: selector = round-robin 0 (controller setting)
Oct 13 15:19:20 | 360001ff02002110103e0fe36220f0d00: features = 0 (controller setting)
Oct 13 15:19:20 | 360001ff02002110103e0fe36220f0d00: hwhandler = 0 (controller setting)
Oct 13 15:19:20 | 360001ff02002110103e0fe36220f0d00: rr_weight = 1 (controller setting)
Oct 13 15:19:20 | 360001ff02002110103e0fe36220f0d00: minio = 1000 (controller setting)
Oct 13 15:19:20 | 360001ff02002110103e0fe36220f0d00: no_path_retry = -1 (config file default)
Oct 13 15:19:20 | 360001ff02002110103e0fe36220f0d00: load table [0 571416576 multipath 0 0 1 1 round-robin 0 2 1 8:32 1000 8:96 1000]
Oct 13 15:19:20 | 360001ff02002110103e0fe36220f0d00: discover
Oct 13 15:19:20 | *word = 0, len = 1
Oct 13 15:19:20 | *word = 0, len = 1
Oct 13 15:19:20 | *word = 1, len = 1
Oct 13 15:19:20 | *word = 1, len = 1
Oct 13 15:19:20 | *word = 2, len = 1
Oct 13 15:19:20 | *word = 1, len = 1
Oct 13 15:19:20 | *word = 8:32, len = 4
Oct 13 15:19:20 | *word = 1000, len = 4
Oct 13 15:19:20 | *word = 8:96, len = 4
Oct 13 15:19:20 | *word = 1000, len = 4
Oct 13 15:19:20 | *word = 1, len = 1
Oct 13 15:19:20 | *word = 0, len = 1
Oct 13 15:19:20 | *word = 1, len = 1
Oct 13 15:19:20 | *word = E, len = 1
Oct 13 15:19:20 | *word = 2, len = 1
Oct 13 15:19:20 | *word = 0, len = 1
Oct 13 15:19:20 | *word = A, len = 1
Oct 13 15:19:20 | *word = 0, len = 1
Oct 13 15:19:20 | *word = A, len = 1
Oct 13 15:19:20 | *word = 0, len = 1
Oct 13 15:19:20 | 360001ff02002110103e0fe36220f0d00: rr_weight = 1 (controller setting)
Oct 13 15:19:20 | 360001ff02002110103e0fe36220f0d00: pgfailback = -2 (config file default)
Oct 13 15:19:20 | 360001ff02002110103e0fe36220f0d00: no_path_retry = -1 (config file default)
Oct 13 15:19:20 | sdg path added to devmap 360001ff02002110103e0fe36220f0d00
Oct 13 15:19:20 | discard event on /class/scsi_device/5:0:0:1
Oct 13 15:19:20 | discard event on /class/scsi_generic/sg7
Oct 13 15:19:20 | discard event on /devices/pci0000:05/0000:05:1d.0/0000:06:02.1/host5/rport-5:0-0/target5:0:0/5:0:0:2
Oct 13 15:19:20 | discard event on /class/scsi_disk/5:0:0:2
Oct 13 15:19:20 | sdh: add path (uevent)
Oct 13 15:19:20 | sdh: not found in pathvec
Oct 13 15:19:20 | sdh: mask = 0x1f
Oct 13 15:19:20 | sdh: bus = 1
Oct 13 15:19:20 | sdh: dev_t = 8:112
Oct 13 15:19:20 | sdh: size = 2048000
Oct 13 15:19:20 | sdh: vendor = DDN
Oct 13 15:19:20 | sdh: product = S2A 8500
Oct 13 15:19:20 | sdh: rev = 5.24
Oct 13 15:19:20 | sdh: h:b:t:l = 5:0:0:2
Oct 13 15:19:20 | sdh: tgt_node_name = 0x20000001ff0302a8
Oct 13 15:19:20 | sdh: serial = 03E0FE380E00
Oct 13 15:19:20 | sdh: path checker = directio (controller setting)
Oct 13 15:19:20 | sdh: state = 2
Oct 13 15:19:20 | sdh: getprio = NULL (internal default)
Oct 13 15:19:20 | sdh: prio = 1
Oct 13 15:19:20 | sdh: getuid = /sbin/scsi_id -g -u -s /block/%n (controller setting)
Oct 13 15:19:20 | sdh: uid = 360001ff02002110103e0fe38001f0e00 (callout)
Oct 13 15:19:20 | 8:48: not found in pathvec
Oct 13 15:19:20 | sdd: ownership set to 360001ff02002110103e0fe38001f0e00
Oct 13 15:19:20 | sdd: mask = 0xc
Oct 13 15:19:20 | sdd: state = 2
Oct 13 15:19:20 | sdd: prio = 1
Oct 13 15:19:20 | sdh: ownership set to 360001ff02002110103e0fe38001f0e00
Oct 13 15:19:20 | sdh: not found in pathvec
Oct 13 15:19:20 | sdh: mask = 0xc
Oct 13 15:19:20 | sdh: state = 2
Oct 13 15:19:20 | sdh: prio = 1
Oct 13 15:19:20 | 360001ff02002110103e0fe38001f0e00: pgfailback = -2 (config file default)
Oct 13 15:19:20 | 360001ff02002110103e0fe38001f0e00: pgpolicy = multibus (controller setting)
Oct 13 15:19:20 | 360001ff02002110103e0fe38001f0e00: selector = round-robin 0 (controller setting)
Oct 13 15:19:20 | 360001ff02002110103e0fe38001f0e00: features = 0 (controller setting)
Oct 13 15:19:20 | 360001ff02002110103e0fe38001f0e00: hwhandler = 0 (controller setting)
Oct 13 15:19:20 | 360001ff02002110103e0fe38001f0e00: rr_weight = 1 (controller setting)
Oct 13 15:19:20 | 360001ff02002110103e0fe38001f0e00: minio = 1000 (controller setting)
Oct 13 15:19:20 | 360001ff02002110103e0fe38001f0e00: no_path_retry = -1 (config file default)
Oct 13 15:19:20 | 360001ff02002110103e0fe38001f0e00: load table [0 2048000 multipath 0 0 1 1 round-robin 0 2 1 8:48 1000 8:112 1000]
Oct 13 15:19:20 | 360001ff02002110103e0fe38001f0e00: discover
Oct 13 15:19:20 | *word = 0, len = 1
Oct 13 15:19:20 | *word = 0, len = 1
Oct 13 15:19:20 | *word = 1, len = 1
Oct 13 15:19:20 | *word = 1, len = 1
Oct 13 15:19:20 | *word = 2, len = 1
Oct 13 15:19:20 | *word = 1, len = 1
Oct 13 15:19:20 | *word = 8:48, len = 4
Oct 13 15:19:20 | *word = 1000, len = 4
Oct 13 15:19:20 | *word = 8:112, len = 5
Oct 13 15:19:20 | *word = 1000, len = 4
Oct 13 15:19:20 | *word = 1, len = 1
Oct 13 15:19:20 | *word = 0, len = 1
Oct 13 15:19:20 | *word = 1, len = 1
Oct 13 15:19:20 | *word = E, len = 1
Oct 13 15:19:20 | *word = 2, len = 1
Oct 13 15:19:20 | *word = 0, len = 1
Oct 13 15:19:20 | *word = A, len = 1
Oct 13 15:19:20 | *word = 0, len = 1
Oct 13 15:19:20 | *word = A, len = 1
Oct 13 15:19:20 | *word = 0, len = 1
Oct 13 15:19:20 | 360001ff02002110103e0fe38001f0e00: rr_weight = 1 (controller setting)
Oct 13 15:19:20 | 360001ff02002110103e0fe38001f0e00: pgfailback = -2 (config file default)
Oct 13 15:19:20 | 360001ff02002110103e0fe38001f0e00: no_path_retry = -1 (config file default)
Oct 13 15:19:20 | sdh path added to devmap 360001ff02002110103e0fe38001f0e00
Oct 13 15:19:20 | discard event on /class/scsi_device/5:0:0:2
Oct 13 15:19:20 | discard event on /class/scsi_generic/sg8
Oct 13 15:19:20 | discard event on /devices/pci0000:05/0000:05:1d.0/0000:06:02.1/host5/rport-5:0-0/target5:0:0/5:0:0:3
Oct 13 15:19:20 | discard event on /class/scsi_disk/5:0:0:3
Oct 13 15:19:20 | sdi: add path (uevent)
Oct 13 15:19:20 | sdi: not found in pathvec
Oct 13 15:19:20 | sdi: mask = 0x1f
Oct 13 15:19:20 | sdi: bus = 1
Oct 13 15:19:20 | sdi: dev_t = 8:128
Oct 13 15:19:20 | sdi: size = 571416576
Oct 13 15:19:20 | sdi: vendor = DDN
Oct 13 15:19:20 | sdi: product = S2A 8500
Oct 13 15:19:20 | sdi: rev = 5.24
Oct 13 15:19:20 | sdi: h:b:t:l = 5:0:0:3
Oct 13 15:19:20 | sdi: tgt_node_name = 0x20000001ff0302a8
Oct 13 15:19:20 | sdi: serial = 03E0FE3A0F00
Oct 13 15:19:20 | sdi: path checker = directio (controller setting)
Oct 13 15:19:20 | sdi: state = 2
Oct 13 15:19:20 | sdi: getprio = NULL (internal default)
Oct 13 15:19:20 | sdi: prio = 1
Oct 13 15:19:20 | sdi: getuid = /sbin/scsi_id -g -u -s /block/%n (controller setting)
Oct 13 15:19:20 | sdi: uid = 360001ff02002110103e0fe3a220f0f00 (callout)
Oct 13 15:19:20 | 8:64: not found in pathvec
Oct 13 15:19:20 | sde: ownership set to 360001ff02002110103e0fe3a220f0f00
Oct 13 15:19:20 | sde: mask = 0xc
Oct 13 15:19:20 | sde: state = 2
Oct 13 15:19:20 | sde: prio = 1
Oct 13 15:19:20 | sdi: ownership set to 360001ff02002110103e0fe3a220f0f00
Oct 13 15:19:20 | sdi: not found in pathvec
Oct 13 15:19:20 | sdi: mask = 0xc
Oct 13 15:19:20 | sdi: state = 2
Oct 13 15:19:20 | sdi: prio = 1
Oct 13 15:19:20 | 360001ff02002110103e0fe3a220f0f00: pgfailback = -2 (config file default)
Oct 13 15:19:20 | 360001ff02002110103e0fe3a220f0f00: pgpolicy = multibus (controller setting)
Oct 13 15:19:20 | 360001ff02002110103e0fe3a220f0f00: selector = round-robin 0 (controller setting)
Oct 13 15:19:20 | 360001ff02002110103e0fe3a220f0f00: features = 0 (controller setting)
Oct 13 15:19:20 | 360001ff02002110103e0fe3a220f0f00: hwhandler = 0 (controller setting)
Oct 13 15:19:20 | 360001ff02002110103e0fe3a220f0f00: rr_weight = 1 (controller setting)
Oct 13 15:19:20 | 360001ff02002110103e0fe3a220f0f00: minio = 1000 (controller setting)
Oct 13 15:19:20 | 360001ff02002110103e0fe3a220f0f00: no_path_retry = -1 (config file default)
Oct 13 15:19:20 | 360001ff02002110103e0fe3a220f0f00: load table [0 571416576 multipath 0 0 1 1 round-robin 0 2 1 8:64 1000 8:128 1000]
Oct 13 15:19:20 | 360001ff02002110103e0fe3a220f0f00: discover
Oct 13 15:19:20 | *word = 0, len = 1
Oct 13 15:19:20 | *word = 0, len = 1
Oct 13 15:19:20 | *word = 1, len = 1
Oct 13 15:19:20 | *word = 1, len = 1
Oct 13 15:19:20 | *word = 2, len = 1
Oct 13 15:19:20 | *word = 1, len = 1
Oct 13 15:19:20 | *word = 8:64, len = 4
Oct 13 15:19:20 | *word = 1000, len = 4
Oct 13 15:19:20 | *word = 8:128, len = 5
Oct 13 15:19:20 | *word = 1000, len = 4
Oct 13 15:19:20 | *word = 1, len = 1
Oct 13 15:19:20 | *word = 0, len = 1
Oct 13 15:19:20 | *word = 1, len = 1
Oct 13 15:19:20 | *word = E, len = 1
Oct 13 15:19:20 | *word = 2, len = 1
Oct 13 15:19:20 | *word = 0, len = 1
Oct 13 15:19:20 | *word = A, len = 1
Oct 13 15:19:20 | *word = 0, len = 1
Oct 13 15:19:20 | *word = A, len = 1
Oct 13 15:19:20 | *word = 0, len = 1
Oct 13 15:19:20 | 360001ff02002110103e0fe3a220f0f00: rr_weight = 1 (controller setting)
Oct 13 15:19:20 | 360001ff02002110103e0fe3a220f0f00: pgfailback = -2 (config file default)
Oct 13 15:19:20 | 360001ff02002110103e0fe3a220f0f00: no_path_retry = -1 (config file default)
Oct 13 15:19:20 | sdi path added to devmap 360001ff02002110103e0fe3a220f0f00
Oct 13 15:19:20 | discard event on /class/scsi_device/5:0:0:3
Oct 13 15:19:20 | discard event on /class/scsi_generic/sg9
Oct 13 15:19:20 | tick
Oct 13 15:19:20 | sdg: directio checker reports path is up
Oct 13 15:19:20 | 8:96: delay next check 40s
Oct 13 15:19:20 | path prio refresh
Oct 13 15:19:20 | sdg: mask = 0x8
Oct 13 15:19:20 | sdg: prio = 1
Oct 13 15:19:20 | sdh: directio checker reports path is up
Oct 13 15:19:20 | 8:112: delay next check 40s
Oct 13 15:19:20 | path prio refresh
Oct 13 15:19:20 | sdh: mask = 0x8
Oct 13 15:19:20 | sdh: prio = 1
Oct 13 15:19:20 | sdi: directio checker reports path is up
Oct 13 15:19:20 | 8:128: delay next check 40s
Oct 13 15:19:20 | path prio refresh
Oct 13 15:19:20 | sdi: mask = 0x8
Oct 13 15:19:20 | sdi: prio = 1
Oct 13 15:19:20 | map garbage collection
Oct 13 15:19:21 | tick
Oct 13 15:19:22 | tick
Oct 13 15:19:23 | tick
Oct 13 15:19:24 | tick
Oct 13 15:19:25 | unlink pidfile
Oct 13 15:19:25 | 360001ff02002110103e0fe34001f0c00: stop event checker thread
Oct 13 15:19:25 | sdb: orphaned
Oct 13 15:19:25 | 360001ff02002110103e0fe36220f0d00: stop event checker thread
Oct 13 15:19:25 | sdc: orphaned
Oct 13 15:19:25 | sdg: orphaned
Oct 13 15:19:25 | 360001ff02002110103e0fe38001f0e00: stop event checker thread
Oct 13 15:19:25 | sdd: orphaned
Oct 13 15:19:25 | sdh: orphaned
Oct 13 15:19:25 | 360001ff02002110103e0fe3a220f0f00: stop event checker thread
Oct 13 15:19:25 | sde: orphaned
Oct 13 15:19:25 | SIGUSR1 received
Oct 13 15:19:25 | SIGUSR1 received
Oct 13 15:19:25 | SIGUSR1 received
Oct 13 15:19:25 | SIGUSR1 received
Oct 13 15:19:25 | sdi: orphaned


--------------020200050508020801060908
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------020200050508020801060908--

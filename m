From: <Menny_Hamburger@Dell.com>
Subject: [PATCH]: scsi_dh_rdac: fix BUG_ON in get_rdac_data from
 within send_mode_select
Date: Sun, 30 Jan 2011 09:22:04 +0000
Message-ID: <D8C50530D6022F40A817A35C40CC06A7064B3773D8@DUBX7MCDUB01.EMEA.DELL.COM>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7077016974588869068=="
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

--===============7077016974588869068==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_D8C50530D6022F40A817A35C40CC06A7064B3773D8DUBX7MCDUB01E_"

--_000_D8C50530D6022F40A817A35C40CC06A7064B3773D8DUBX7MCDUB01E_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

We are running with multipath over MD3xxx ISCSI storage (RDAC).
Our test scripts perform a series of multipathd restarts, udevtrigger and u=
devsettle calls, during which we logout of the storage.
Sometimes we get the following panic:

2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-11: add map (uevent)
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: lun5: event checker started
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-11: add map (uevent)
2011 Jan 26 22:27:01 node0 MAJOR: multipathd: dm-11: devmap already registe=
red
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-11: add map (uevent)
2011 Jan 26 22:27:01 node0 MAJOR: multipathd: dm-11: devmap already registe=
red
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-11: add map (uevent)
2011 Jan 26 22:27:01 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:01 node0 MAJOR: multipathd: dm-11: devmap already registe=
red
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-0: add map (uevent)
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: mpath0: event checker starte=
d
2011 Jan 26 22:27:01 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-1: add map (uevent)
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: mpath1: event checker starte=
d
2011 Jan 26 22:27:01 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-2: add map (uevent)
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: mpath2: event checker starte=
d
2011 Jan 26 22:27:01 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-3: add map (uevent)
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: mpath3: event checker starte=
d
2011 Jan 26 22:27:01 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-4: add map (uevent)
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: mpath4: event checker starte=
d
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: lun5: event checker exit
2011 Jan 26 22:27:01 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-5: add map (uevent)
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: mpath6: event checker starte=
d
2011 Jan 26 22:27:01 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-6: add map (uevent)
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: mpath7: event checker starte=
d
2011 Jan 26 22:27:01 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-7: add map (uevent)
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: mpath8: event checker starte=
d
2011 Jan 26 22:27:01 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-8: add map (uevent)
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: mpath9: event checker starte=
d
2011 Jan 26 22:27:01 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-9: add map (uevent)
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: mpath10: event checker start=
ed
2011 Jan 26 22:27:01 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-10: add map (uevent)
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: mpath11: event checker start=
ed
2011 Jan 26 22:27:02 node0 INFO: kernel: sd 194:0:0:4: rdac: array MD3200i-=
c7-d7, ctlr 0, queueing MODE_SELECT command
2011 Jan 26 22:27:02 node0 DEBUG: hba_loader:iscsi_logout:1130: Started
2011 Jan 26 22:27:02 node0 DEBUG: hba_loader:iscsi_logout:1130: iscsi_luns_=
num=3D1 logout_iqn=3D
2011 Jan 26 22:27:02 node0 DEBUG: hba_loader:iscsi_logout:1130: Performing =
logout of all iSCSI nodes
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 194:0:0:0: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 194:0:0:1: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 196:0:0:0: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 194:0:0:2: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 194:0:0:3: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 196:0:0:1: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 194:0:0:4: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 196:0:0:2: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 194:0:0:5: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 195:0:0:0: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: multipathd: sdb: remove path (uevent)
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 196:0:0:3: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 195:0:0:1: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 196:0:0:4: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 195:0:0:2: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 195:0:0:3: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 196:0:0:5: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 195:0:0:4: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 196:0:0:6: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 195:0:0:5: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 195:0:0:6: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 196:0:0:7: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 195:0:0:7: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 196:0:0:8: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 195:0:0:8: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 195:0:0:9: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 196:0:0:9: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 194:0:0:6: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 196:0:0:10: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 194:0:0:7: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 194:0:0:8: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 196:0:0:11: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 194:0:0:9: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 194:0:0:10: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 194:0:0:11: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 193:0:0:0: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 195:0:0:10: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 193:0:0:1: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 193:0:0:2: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 193:0:0:3: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 193:0:0:4: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 193:0:0:5: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 193:0:0:6: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 193:0:0:7: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 193:0:0:8: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 193:0:0:9: rdac Dettached
2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 193:0:0:10: rdac Dettached
2011 Jan 26 22:27:02 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:02 node0 MAJOR: kernel: device-mapper: table: 253:7: mult=
ipath: unknown path selector type
2011 Jan 26 22:27:02 node0 WARNING: kernel: device-mapper: ioctl: error add=
ing target to table
2011 Jan 26 22:27:02 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:02 node0 MAJOR: kernel: device-mapper: table: 253:7: mult=
ipath: unknown path selector type
2011 Jan 26 22:27:02 node0 WARNING: kernel: device-mapper: ioctl: error add=
ing target to table
2011 Jan 26 22:27:02 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:02 node0 MAJOR: kernel: device-mapper: table: 253:8: mult=
ipath: unknown path selector type
2011 Jan 26 22:27:02 node0 WARNING: kernel: device-mapper: ioctl: error add=
ing target to table
2011 Jan 26 22:27:02 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:02 node0 MAJOR: multipathd: mpath8: failed in domap for r=
emoval of path sdb
2011 Jan 26 22:27:02 node0 MAJOR: multipathd: uevent trigger error
2011 Jan 26 22:27:02 node0 NOTICE: multipathd: sdd: remove path (uevent)
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:8: mult=
ipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error add=
ing target to table
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:7: mult=
ipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error add=
ing target to table
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:7: mult=
ipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error add=
ing target to table
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:9: mult=
ipath: unknown path selector type
2011 Jan 26 22:27:02 node0 MAJOR: multipathd: mpath9: failed in domap for r=
emoval of path sdd
2011 Jan 26 22:27:02 node0 MAJOR: multipathd: uevent trigger error
2011 Jan 26 22:27:02 node0 NOTICE: multipathd: sdh: remove path (uevent)
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath8: failed in domap for r=
emoval of path sdh
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent trigger error
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error add=
ing target to table
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdf: remove path (uevent)
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:9: mult=
ipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error add=
ing target to table
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath10: failed in domap for =
removal of path sdf
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent trigger error
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdo: remove path (uevent)
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:8: mult=
ipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error add=
ing target to table
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:8: mult=
ipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error add=
ing target to table
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath9: failed in domap for r=
emoval of path sdo
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent trigger error
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdj: remove path (uevent)
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:10: mul=
tipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error add=
ing target to table
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: scsi 194:0:0:8: rejecting I/O to =
dead device
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: multipath: Faili=
ng path 65:112.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: scsi 195:0:0:8: rejecting I/O to =
dead device
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: multipath: Faili=
ng path 65:160.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: multipath: Cannot =
failover device because scsi_dh_rdac was not loaded.
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: multipath: Faili=
ng path 66:208.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: multipath: Cannot =
failover device because scsi_dh_rdac was not loaded.
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: multipath: Faili=
ng path 66:224.
2011 Jan 26 22:27:03 node0 WARNING: kernel: printk: 46 messages suppressed.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: Buffer I/O error on device dm-0, =
logical block 0
2011 Jan 26 22:27:03 node0 MAJOR: kernel: Buffer I/O error on device dm-0, =
logical block 1
2011 Jan 26 22:27:03 node0 MAJOR: kernel: Buffer I/O error on device dm-0, =
logical block 2
2011 Jan 26 22:27:03 node0 MAJOR: kernel: Buffer I/O error on device dm-0, =
logical block 3
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:10: mul=
tipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error add=
ing target to table
2011 Jan 26 22:27:03 node0 MAJOR: kernel: Buffer I/O error on device dm-0, =
logical block 0
2011 Jan 26 22:27:03 node0 MAJOR: kernel: Buffer I/O error on device dm-0, =
logical block 70778879
2011 Jan 26 22:27:03 node0 MAJOR: kernel: Buffer I/O error on device dm-0, =
logical block 70778879
2011 Jan 26 22:27:03 node0 MAJOR: kernel: Buffer I/O error on device dm-0, =
logical block 0
2011 Jan 26 22:27:03 node0 MAJOR: kernel: Buffer I/O error on device dm-0, =
logical block 0
2011 Jan 26 22:27:03 node0 MAJOR: kernel: Buffer I/O error on device dm-0, =
logical block 3
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath11: failed in domap for =
removal of path sdj
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent trigger error
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdl: remove path (uevent)
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:3: mult=
ipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error add=
ing target to table
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:3: mult=
ipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error add=
ing target to table
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath3: failed in domap for r=
emoval of path sdl
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent trigger error
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: 65:160: mark as failed
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: mpath0: remaining active pat=
hs: 3
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: 65:112: mark as failed
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: mpath0: remaining active pat=
hs: 2
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: 66:208: mark as failed
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: mpath0: remaining active pat=
hs: 1
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: 66:224: mark as failed
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: mpath0: remaining active pat=
hs: 0
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdt: remove path (uevent)
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:9: mult=
ipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error add=
ing target to table
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:9: mult=
ipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error add=
ing target to table
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath10: failed in domap for =
removal of path sdt
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent trigger error
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdn: remove path (uevent)
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:4: mult=
ipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error add=
ing target to table
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:4: mult=
ipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error add=
ing target to table
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath4: failed in domap for r=
emoval of path sdn
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent trigger error
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdy: remove path (uevent)
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:10: mul=
tipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error add=
ing target to table
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:10: mul=
tipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error add=
ing target to table
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath11: failed in domap for =
removal of path sdy
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent trigger error
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdc: remove path (uevent)
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:7: mult=
ipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error add=
ing target to table
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:7: mult=
ipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error add=
ing target to table
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath8: failed in domap for r=
emoval of path sdc
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent trigger error
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sde: remove path (uevent)
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:8: mult=
ipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error add=
ing target to table
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:8: mult=
ipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error add=
ing target to table
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath9: failed in domap for r=
emoval of path sde
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent trigger error
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdaf: remove path (uevent)
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:3: mult=
ipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error add=
ing target to table
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:3: mult=
ipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error add=
ing target to table
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath3: failed in domap for r=
emoval of path sdaf
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent trigger error
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdg: remove path (uevent)
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:9: mult=
ipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error add=
ing target to table
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:9: mult=
ipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error add=
ing target to table
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath10: failed in domap for =
removal of path sdg
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:4: mult=
ipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error add=
ing target to table
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:4: mult=
ipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error add=
ing target to table
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent trigger error
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdah: remove path (uevent)
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath4: failed in domap for r=
emoval of path sdah
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent trigger error
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdk: remove path (uevent)
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:10: mul=
tipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error add=
ing target to table
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:10: mul=
tipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error add=
ing target to table
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath11: failed in domap for =
removal of path sdk
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:3: mult=
ipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error add=
ing target to table
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:3: mult=
ipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error add=
ing target to table
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent trigger error
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdm: remove path (uevent)
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath3: failed in domap for r=
emoval of path sdm
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent trigger error
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdan: remove path (uevent)
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:5: mult=
ipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error add=
ing target to table
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:5: mult=
ipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error add=
ing target to table
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath6: failed in domap for r=
emoval of path sdan
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent trigger error
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdq: remove path (uevent)
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:4: mult=
ipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error add=
ing target to table
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:4: mult=
ipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error add=
ing target to table
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath4: failed in domap for r=
emoval of path sdq
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:6: mult=
ipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error add=
ing target to table
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:6: mult=
ipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error add=
ing target to table
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent trigger error
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdap: remove path (uevent)
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath7: failed in domap for r=
emoval of path sdap
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent trigger error
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sds: remove path (uevent)
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:5: mult=
ipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error add=
ing target to table
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:5: mult=
ipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error add=
ing target to table
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath6: failed in domap for r=
emoval of path sds
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent trigger error
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdw: remove path (uevent)
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:6: mult=
ipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error add=
ing target to table
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using sc=
si_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: ----------- [cut here ] --------=
- [please bite here ] ---------
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: Kernel BUG at drivers/scsi/devic=
e_handler/scsi_dh_rdac.c:252
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: invalid opcode: 0000 [1]
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: SMP
2011 Jan 26 22:27:03 172.19.59.130 NOTICE:
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: last sysfs file: /class/iscsi_se=
ssion/session9/ifacename
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: CPU 2
2011 Jan 26 22:27:03 172.19.59.130 NOTICE:
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: Modules linked in:
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: iscsi_tcp(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: libiscsi_tcp(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: libiscsi2(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: scsi_transport_iscsi2(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: scsi_transport_iscsi(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: ipmi_si(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: scsi_dh_rdac(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: dm_rdac(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: dm_queue_depth(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: netconsole(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: dm_round_robin(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: mptctl(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: dell_rbu(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: exa_ioctls(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: nfs(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: lockd(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: nfs_acl(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: xt_tcpudp(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: iptable_filter(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: ip_tables(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: ipt_SYSRQ(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: x_tables(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: sunrpc(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: ipmi_devintf(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: ipmi_msghandler(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: bonding1(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: bonding(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: ipv6(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: xfrm_nalgo(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: crypto_api(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: dm_mirror(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: dm_log(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: dm_multipath(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: scsi_dh(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: dm_mod(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: video(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: hwmon(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: backlight(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: sbs(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: i2c_ec(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: i2c_core(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: button(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: battery(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: asus_acpi(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: ac(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: joydev(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: sr_mod(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: cdrom(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: bnx2(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: sg(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: pcspkr(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: ata_piix(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: libata(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: mptsas(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: mptscsih(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: mptbase(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: scsi_transport_sas(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: sd_mod(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: scsi_mod(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: ext3(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: jbd(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: uhci_hcd(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: ohci_hcd(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: ehci_hcd(U)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE:
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: Pid: 12912, comm: kmpath_rdacd T=
ainted: G      2.6.18-164sys #1
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: RIP: 0010:[<ffffffff8838dc4f>]
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: [<ffffffff8838dc4f>] :scsi_dh_rd=
ac:send_mode_select+0x2cf/0x4b0
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: device-mapper: table: 253:6: mul=
tipath: unknown path selector type
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: device-mapper: ioctl: error addi=
ng target to table
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: RSP: 0018:ffff810086959d80  EFLA=
GS: 00010246
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: RAX: 0000000000000000 RBX: 00000=
000fffffffb RCX: 0000000000000000
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: RDX: 0000000000000800 RSI: 00000=
00000000286 RDI: ffff810055e2d800
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: RBP: ffff81005a647216 R08: fffff=
fff80370b58 R09: 0000000000000001
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: R10: 0000000000000046 R11: fffff=
fff8004c200 R12: 0000000000000000
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: R13: 0000000000000000 R14: ffff8=
102352bc000 R15: ffff8102352bc062
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: FS:  0000000000000000(0000) GS:f=
fff810107eda340(0000) knlGS:0000000000000000
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: CS:  0010 DS: 0018 ES: 0018 CR0:=
 000000008005003b
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: CR2: 00002ae8ff6760a0 CR3: 00000=
0023487c000 CR4: 00000000000006e0
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: Process kmpath_rdacd (pid: 12912=
, threadinfo ffff810086958000, task ffff810092a54140)
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: Stack:
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: 0000000010008040
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: ffff81005b23a5c0
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: ffff810086959e70
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: ffff810086959dd0
2011 Jan 26 22:27:03 172.19.59.130 NOTICE:
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: ffff810001004498
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: ffff810055e2d800
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: ffff81005a647208
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: ffff81004d3226f0
2011 Jan 26 22:27:03 172.19.59.130 NOTICE:
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: 0000000380438420
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: 0000000000000001
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: ffff81023a498d80
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: ffff81023a498d80
2011 Jan 26 22:27:03 172.19.59.130 NOTICE:
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: Call Trace:
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: [<ffffffff8838d980>] :scsi_dh_rd=
ac:send_mode_select+0x0/0x4b0
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: [<ffffffff800561a3>] run_workque=
ue+0xb3/0x110
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: [<ffffffff80052180>] worker_thre=
ad+0x0/0x150
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: [<ffffffff800b33b0>] keventd_cre=
ate_kthread+0x0/0xa0
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: [<ffffffff80052291>] worker_thre=
ad+0x111/0x150
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: [<ffffffff8009ca00>] default_wak=
e_function+0x0/0x10
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: [<ffffffff80052180>] worker_thre=
ad+0x0/0x150
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: [<ffffffff800373c9>] kthread+0xd=
9/0x120
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: [<ffffffff80068fb1>] child_rip+0=
xa/0x11
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: [<ffffffff800b33b0>] keventd_cre=
ate_kthread+0x0/0xa0
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: [<ffffffff800372f0>] kthread+0x0=
/0x120
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: [<ffffffff80068fa7>] child_rip+0=
x0/0x11
2011 Jan 26 22:27:03 172.19.59.130 NOTICE:
2011 Jan 26 22:27:03 172.19.59.130 NOTICE:
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: Code:
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: 0f
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: 0b
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: 68
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: 98
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: e1
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: 38
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: 88
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: c2
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: fc
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: 00
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: 0f
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: 1f
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: 80
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: 00
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: 00
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: 00
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: 00
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: 48
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: 8d
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: 54
2011 Jan 26 22:27:03 172.19.59.130 NOTICE:
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: RIP
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: [<ffffffff8838dc4f>] :scsi_dh_rd=
ac:send_mode_select+0x2cf/0x4b0
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: RSP <ffff810086959d80>
2011 Jan 26 22:27:03 172.19.59.130 NOTICE:
2011 Jan 26 22:27:03 172.19.59.130 EMERG: Kernel panic - not syncing: Fatal=
 exception
2011 Jan 26 22:27:03 172.19.59.130 NOTICE:
2011 Jan 26 22:27:03 172.19.59.130 EMERG: Rebooting in 1 seconds..


This panic comes from get_rdac_data, which is called from within the send_m=
ode_select code.
My analysis picked up the following problem:
The RDAC detach code nullifies the scsi_dh_data before flushing the mode se=
lect workqueue, and as result a pending send_mode_select will BUG_ON in get=
_rdac_data.
The following patch (tested over RHEL54) flushes the workqueue before setti=
ng scsi_dh_data to NULL:

diff -r -U 2 a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/de=
vice_handler/scsi_dh_rdac.c
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c        2011-01-30 11:02:31=
.271426000 +0200
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c        2011-01-30 11:02:31=
.327069000 +0200
@@ -853,8 +853,22 @@
        spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
        scsi_dh_data =3D retrieve_scsi_dh_data(sdev);
-       store_scsi_dh_data(sdev, NULL);
        spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);

        h =3D (struct rdac_dh_data *) scsi_dh_data->buf;
+       if (h->ctlr) {
+               int flush;
+
+               spin_lock(&h->ctlr->ms_lock);
+               flush =3D (h->ctlr->ms_sdev =3D=3D sdev);
+               spin_unlock(&h->ctlr->ms_lock);
+
+               if (flush)
+                       flush_workqueue(kmpath_rdacd);
+       }
+
+       spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
+       store_scsi_dh_data(sdev, NULL);
+       spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
+
        if (h->ctlr)
                kref_put(&h->ctlr->kref, release_controller);



The patch ensures that we run flush only when detaching the device the "own=
s" the send_mode_select (ms_sdev).

Menny




--_000_D8C50530D6022F40A817A35C40CC06A7064B3773D8DUBX7MCDUB01E_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; charset=3Dus-ascii">
<meta name=3DGenerator content=3D"Microsoft Word 12 (filtered medium)">
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:"Cambria Math";
	panose-1:0 0 0 0 0 0 0 0 0 0;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
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
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;}
@page Section1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.Section1
	{page:Section1;}
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

<p class=3DMsoNormal>Hi,<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>We are running with multipath over MD3xxx ISCSI storag=
e
(RDAC).<o:p></o:p></p>

<p class=3DMsoNormal>Our test scripts perform a series of multipathd restar=
ts,
udevtrigger and udevsettle calls, during which we logout of the storage.<o:=
p></o:p></p>

<p class=3DMsoNormal>Sometimes we get the following panic<span style=3D'fon=
t-size:
12.0pt;font-family:"Times New Roman","serif"'>:<o:p></o:p></span></p>

<p class=3DMsoNormal><span style=3D'font-size:12.0pt;font-family:"Times New=
 Roman","serif"'><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-11: =
add
map (uevent)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:01 node0 NOTICE: multipathd: lun5: e=
vent
checker started<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-11: =
add
map (uevent)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:01 node0 MAJOR: multipathd: dm-11: d=
evmap
already registered<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-11: =
add
map (uevent)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:01 node0 MAJOR: multipathd: dm-11: d=
evmap
already registered<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-11: =
add
map (uevent)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:01 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:01 node0 MAJOR: multipathd: dm-11: d=
evmap
already registered<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-0: a=
dd map
(uevent)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:01 node0 NOTICE: multipathd: mpath0:=
 event
checker started<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:01 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-1: a=
dd map
(uevent)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:01 node0 NOTICE: multipathd: mpath1:=
 event
checker started<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:01 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-2: a=
dd map
(uevent)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:01 node0 NOTICE: multipathd: mpath2:=
 event
checker started<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:01 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-3: a=
dd map
(uevent)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:01 node0 NOTICE: multipathd: mpath3:=
 event
checker started<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:01 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-4: a=
dd map
(uevent)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:01 node0 NOTICE: multipathd: mpath4:=
 event
checker started<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:01 node0 NOTICE: multipathd: lun5: e=
vent
checker exit<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:01 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-5: a=
dd map
(uevent)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:01 node0 NOTICE: multipathd: mpath6:=
 event
checker started<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:01 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-6: a=
dd map
(uevent)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:01 node0 NOTICE: multipathd: mpath7:=
 event
checker started<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:01 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-7: a=
dd map
(uevent)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:01 node0 NOTICE: multipathd: mpath8:=
 event
checker started<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:01 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-8: a=
dd map
(uevent)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:01 node0 NOTICE: multipathd: mpath9:=
 event
checker started<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:01 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-9: a=
dd map
(uevent)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:01 node0 NOTICE: multipathd: mpath10=
:
event checker started<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:01 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-10: =
add
map (uevent)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:01 node0 NOTICE: multipathd: mpath11=
:
event checker started<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 INFO: kernel: sd 194:0:0:4:=
 rdac:
array MD3200i-c7-d7, ctlr 0, queueing MODE_SELECT command<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 DEBUG:
hba_loader:iscsi_logout:1130: Started<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 DEBUG:
hba_loader:iscsi_logout:1130: iscsi_luns_num=3D1 logout_iqn=3D<o:p></o:p></=
p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 DEBUG:
hba_loader:iscsi_logout:1130: Performing logout of all iSCSI nodes<o:p></o:=
p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 194:0:=
0:0:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 194:0:=
0:1:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 196:0:=
0:0:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 194:0:=
0:2:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 194:0:=
0:3:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 196:0:=
0:1:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 194:0:=
0:4:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 196:0:=
0:2:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 194:0:=
0:5:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 195:0:=
0:0:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: multipathd: sdb: re=
move
path (uevent)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 196:0:=
0:3:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 195:0:=
0:1:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 196:0:=
0:4:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 195:0:=
0:2:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 195:0:=
0:3:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 196:0:=
0:5:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 195:0:=
0:4:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 196:0:=
0:6:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 195:0:=
0:5:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 195:0:=
0:6:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 196:0:=
0:7:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 195:0:=
0:7:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 196:0:=
0:8:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 195:0:=
0:8:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 195:0:=
0:9:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 196:0:=
0:9:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 194:0:=
0:6:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 196:0:=
0:10:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 194:0:=
0:7:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 194:0:=
0:8:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 196:0:=
0:11:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 194:0:=
0:9:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 194:0:=
0:10:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 194:0:=
0:11:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 193:0:=
0:0:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 195:0:=
0:10:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 193:0:=
0:1:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 193:0:=
0:2:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 193:0:=
0:3:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 193:0:=
0:4:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 193:0:=
0:5:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 193:0:=
0:6:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 193:0:=
0:7:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 193:0:=
0:8:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 193:0:=
0:9:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: kernel: scsi 193:0:=
0:10:
rdac Dettached<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 INFO: kernel: device-mapper=
: multipath:
Using scsi_dh module scsi_dh_rdac for failover/failback and device manageme=
nt.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 MAJOR: kernel: device-mappe=
r:
table: 253:7: multipath: unknown path selector type<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 WARNING: kernel: device-map=
per: ioctl:
error adding target to table<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 MAJOR: kernel: device-mappe=
r:
table: 253:7: multipath: unknown path selector type<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 WARNING: kernel: device-map=
per:
ioctl: error adding target to table<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 MAJOR: kernel: device-mappe=
r:
table: 253:8: multipath: unknown path selector type<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 WARNING: kernel: device-map=
per:
ioctl: error adding target to table<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 MAJOR: multipathd: mpath8: =
failed
in domap for removal of path sdb<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 MAJOR: multipathd: uevent t=
rigger
error<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: multipathd: sdd: re=
move
path (uevent)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mappe=
r:
table: 253:8: multipath: unknown path selector type<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: device-map=
per:
ioctl: error adding target to table<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mappe=
r:
table: 253:7: multipath: unknown path selector type<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: device-map=
per:
ioctl: error adding target to table<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mappe=
r:
table: 253:7: multipath: unknown path selector type<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: device-map=
per:
ioctl: error adding target to table<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mappe=
r:
table: 253:9: multipath: unknown path selector type<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 MAJOR: multipathd: mpath9: =
failed
in domap for removal of path sdd<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 MAJOR: multipathd: uevent t=
rigger
error<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:02 node0 NOTICE: multipathd: sdh: re=
move
path (uevent)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath8: =
failed
in domap for removal of path sdh<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent t=
rigger
error<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: device-map=
per:
ioctl: error adding target to table<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdf: re=
move
path (uevent)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mappe=
r:
table: 253:9: multipath: unknown path selector type<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: device-map=
per:
ioctl: error adding target to table<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath10:
failed in domap for removal of path sdf<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent t=
rigger
error<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdo: re=
move
path (uevent)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mappe=
r:
table: 253:8: multipath: unknown path selector type<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: device-map=
per:
ioctl: error adding target to table<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mappe=
r:
table: 253:8: multipath: unknown path selector type<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: device-map=
per:
ioctl: error adding target to table<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath9: =
failed
in domap for removal of path sdo<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent t=
rigger
error<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdj: re=
move
path (uevent)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mappe=
r:
table: 253:10: multipath: unknown path selector type<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: device-map=
per:
ioctl: error adding target to table<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: scsi 194:0:0=
:8:
rejecting I/O to dead device<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: device-map=
per:
multipath: Failing path 65:112.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: scsi 195:0:0=
:8:
rejecting I/O to dead device<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: device-map=
per:
multipath: Failing path 65:160.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mappe=
r:
multipath: Cannot failover device because scsi_dh_rdac was not loaded.<o:p>=
</o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: device-map=
per:
multipath: Failing path 66:208.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mappe=
r:
multipath: Cannot failover device because scsi_dh_rdac was not loaded.<o:p>=
</o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: device-map=
per:
multipath: Failing path 66:224.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: printk: 46
messages suppressed.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: Buffer I/O e=
rror on
device dm-0, logical block 0<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: Buffer I/O e=
rror
on device dm-0, logical block 1<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: Buffer I/O e=
rror
on device dm-0, logical block 2<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: Buffer I/O e=
rror
on device dm-0, logical block 3<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mappe=
r:
table: 253:10: multipath: unknown path selector type<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: device-map=
per:
ioctl: error adding target to table<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: Buffer I/O e=
rror
on device dm-0, logical block 0<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: Buffer I/O e=
rror
on device dm-0, logical block 70778879<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: Buffer I/O e=
rror
on device dm-0, logical block 70778879<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: Buffer I/O e=
rror
on device dm-0, logical block 0<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: Buffer I/O e=
rror
on device dm-0, logical block 0<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: Buffer I/O e=
rror
on device dm-0, logical block 3<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath11:
failed in domap for removal of path sdj<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent t=
rigger
error<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdl: re=
move
path (uevent)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mappe=
r:
table: 253:3: multipath: unknown path selector type<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: device-map=
per:
ioctl: error adding target to table<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mappe=
r:
table: 253:3: multipath: unknown path selector type<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: device-map=
per:
ioctl: error adding target to table<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath3: =
failed
in domap for removal of path sdl<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent t=
rigger
error<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 NOTICE: multipathd: 65:160:=
 mark
as failed<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 NOTICE: multipathd: mpath0:
remaining active paths: 3<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 NOTICE: multipathd: 65:112:=
 mark
as failed<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 NOTICE: multipathd: mpath0:
remaining active paths: 2<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 NOTICE: multipathd: 66:208:=
 mark
as failed<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 NOTICE: multipathd: mpath0:
remaining active paths: 1<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 NOTICE: multipathd: 66:224:=
 mark
as failed<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 NOTICE: multipathd: mpath0:
remaining active paths: 0<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdt: re=
move
path (uevent)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mappe=
r:
table: 253:9: multipath: unknown path selector type<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: device-map=
per:
ioctl: error adding target to table<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mappe=
r:
table: 253:9: multipath: unknown path selector type<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: device-map=
per:
ioctl: error adding target to table<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath10:
failed in domap for removal of path sdt<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent t=
rigger
error<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdn: re=
move
path (uevent)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mappe=
r:
table: 253:4: multipath: unknown path selector type<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: device-map=
per:
ioctl: error adding target to table<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mappe=
r:
table: 253:4: multipath: unknown path selector type<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: device-map=
per:
ioctl: error adding target to table<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath4: =
failed
in domap for removal of path sdn<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent t=
rigger
error<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdy: re=
move
path (uevent)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mappe=
r:
table: 253:10: multipath: unknown path selector type<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: device-map=
per:
ioctl: error adding target to table<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mappe=
r:
table: 253:10: multipath: unknown path selector type<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: device-map=
per:
ioctl: error adding target to table<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath11:
failed in domap for removal of path sdy<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent t=
rigger
error<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdc: re=
move
path (uevent)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mappe=
r:
table: 253:7: multipath: unknown path selector type<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: device-map=
per:
ioctl: error adding target to table<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mappe=
r:
table: 253:7: multipath: unknown path selector type<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: device-map=
per:
ioctl: error adding target to table<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath8: =
failed
in domap for removal of path sdc<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent t=
rigger
error<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sde: re=
move
path (uevent)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mappe=
r:
table: 253:8: multipath: unknown path selector type<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: device-map=
per:
ioctl: error adding target to table<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mappe=
r:
table: 253:8: multipath: unknown path selector type<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: device-map=
per:
ioctl: error adding target to table<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath9: =
failed
in domap for removal of path sde<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent t=
rigger
error<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdaf: r=
emove
path (uevent)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mappe=
r:
table: 253:3: multipath: unknown path selector type<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: device-map=
per:
ioctl: error adding target to table<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mappe=
r:
table: 253:3: multipath: unknown path selector type<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: device-map=
per:
ioctl: error adding target to table<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath3: =
failed
in domap for removal of path sdaf<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent t=
rigger
error<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdg: re=
move
path (uevent)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mappe=
r:
table: 253:9: multipath: unknown path selector type<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: device-map=
per:
ioctl: error adding target to table<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mappe=
r:
table: 253:9: multipath: unknown path selector type<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: device-map=
per:
ioctl: error adding target to table<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath10:
failed in domap for removal of path sdg<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mappe=
r:
table: 253:4: multipath: unknown path selector type<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: device-map=
per:
ioctl: error adding target to table<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mappe=
r:
table: 253:4: multipath: unknown path selector type<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: device-map=
per:
ioctl: error adding target to table<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent t=
rigger
error<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdah: r=
emove
path (uevent)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath4: =
failed
in domap for removal of path sdah<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent t=
rigger
error<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdk: re=
move
path (uevent)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mappe=
r:
table: 253:10: multipath: unknown path selector type<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: device-map=
per:
ioctl: error adding target to table<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mappe=
r:
table: 253:10: multipath: unknown path selector type<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: device-map=
per:
ioctl: error adding target to table<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath11:
failed in domap for removal of path sdk<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mappe=
r:
table: 253:3: multipath: unknown path selector type<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: device-map=
per:
ioctl: error adding target to table<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper=
: multipath:
Using scsi_dh module scsi_dh_rdac for failover/failback and device manageme=
nt.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mappe=
r:
table: 253:3: multipath: unknown path selector type<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: device-map=
per:
ioctl: error adding target to table<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent t=
rigger
error<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdm: re=
move
path (uevent)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath3: =
failed
in domap for removal of path sdm<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent t=
rigger
error<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdan: r=
emove
path (uevent)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mappe=
r:
table: 253:5: multipath: unknown path selector type<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: device-map=
per:
ioctl: error adding target to table<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mappe=
r:
table: 253:5: multipath: unknown path selector type<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: device-map=
per:
ioctl: error adding target to table<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath6: =
failed
in domap for removal of path sdan<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent t=
rigger
error<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdq: re=
move
path (uevent)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mappe=
r:
table: 253:4: multipath: unknown path selector type<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: device-map=
per:
ioctl: error adding target to table<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mappe=
r:
table: 253:4: multipath: unknown path selector type<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: device-map=
per:
ioctl: error adding target to table<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath4: =
failed
in domap for removal of path sdq<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mappe=
r:
table: 253:6: multipath: unknown path selector type<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: device-map=
per:
ioctl: error adding target to table<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mappe=
r:
table: 253:6: multipath: unknown path selector type<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: device-map=
per:
ioctl: error adding target to table<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent t=
rigger
error<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdap: r=
emove
path (uevent)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath7: =
failed
in domap for removal of path sdap<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent t=
rigger
error<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sds: re=
move
path (uevent)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mappe=
r:
table: 253:5: multipath: unknown path selector type<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: device-map=
per:
ioctl: error adding target to table<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mappe=
r:
table: 253:5: multipath: unknown path selector type<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: device-map=
per:
ioctl: error adding target to table<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath6: =
failed
in domap for removal of path sds<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent t=
rigger
error<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdw: re=
move
path (uevent)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mappe=
r:
table: 253:6: multipath: unknown path selector type<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 WARNING: kernel: device-map=
per:
ioctl: error adding target to table<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper=
:
multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and devi=
ce
management.<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: -----------=
 [cut
here ] --------- [please bite here ] ---------<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: Kernel BUG =
at
drivers/scsi/device_handler/scsi_dh_rdac.c:252<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: invalid opc=
ode:
0000 [1] <o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: SMP <o:p></=
o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: <o:p></o:p>=
</p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: last sysfs =
file:
/class/iscsi_session/session9/ifacename<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: CPU 2 <o:p>=
</o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: <o:p></o:p>=
</p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: Modules lin=
ked
in:<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: iscsi_tcp(U=
)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: libiscsi_tc=
p(U)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: libiscsi2(U=
)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE:
scsi_transport_iscsi2(U)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE:
scsi_transport_iscsi(U)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: ipmi_si(U)<=
o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: scsi_dh_rda=
c(U)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: dm_rdac(U)<=
o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: dm_queue_de=
pth(U)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: netconsole(=
U)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: dm_round_ro=
bin(U)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: mptctl(U)<o=
:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: dell_rbu(U)=
<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: exa_ioctls(=
U)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: nfs(U)<o:p>=
</o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: lockd(U)<o:=
p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: nfs_acl(U)<=
o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: xt_tcpudp(U=
)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: iptable_fil=
ter(U)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: ip_tables(U=
)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: ipt_SYSRQ(U=
)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: x_tables(U)=
<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: sunrpc(U)<o=
:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: ipmi_devint=
f(U)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE:
ipmi_msghandler(U)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: bonding1(U)=
<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: bonding(U)<=
o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: ipv6(U)<o:p=
></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: xfrm_nalgo(=
U)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: crypto_api(=
U)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: dm_mirror(U=
)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: dm_log(U)<o=
:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: dm_multipat=
h(U)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: scsi_dh(U)<=
o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: dm_mod(U)<o=
:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: video(U)<o:=
p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: hwmon(U)<o:=
p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: backlight(U=
)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: sbs(U)<o:p>=
</o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: i2c_ec(U)<o=
:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: i2c_core(U)=
<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: button(U)<o=
:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: battery(U)<=
o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: asus_acpi(U=
)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: ac(U)<o:p><=
/o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: joydev(U)<o=
:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: sr_mod(U)<o=
:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: cdrom(U)<o:=
p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: bnx2(U)<o:p=
></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: sg(U)<o:p><=
/o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: pcspkr(U)<o=
:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: ata_piix(U)=
<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: libata(U)<o=
:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: mptsas(U)<o=
:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: mptscsih(U)=
<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: mptbase(U)<=
o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE:
scsi_transport_sas(U)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: sd_mod(U)<o=
:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: scsi_mod(U)=
<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: ext3(U)<o:p=
></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: jbd(U)<o:p>=
</o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: uhci_hcd(U)=
<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: ohci_hcd(U)=
<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: ehci_hcd(U)=
<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: <o:p></o:p>=
</p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: Pid: 12912,=
 comm:
kmpath_rdacd Tainted: G&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2.6.18-164sys #1<o:p>=
</o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: RIP:
0010:[&lt;ffffffff8838dc4f&gt;] <o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE:
[&lt;ffffffff8838dc4f&gt;] :scsi_dh_rdac:send_mode_select+0x2cf/0x4b0<o:p><=
/o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: device-mapp=
er:
table: 253:6: multipath: unknown path selector type<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: device-mapp=
er:
ioctl: error adding target to table<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: RSP:
0018:ffff810086959d80&nbsp; EFLAGS: 00010246<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: RAX:
0000000000000000 RBX: 00000000fffffffb RCX: 0000000000000000<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: RDX:
0000000000000800 RSI: 0000000000000286 RDI: ffff810055e2d800<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: RBP:
ffff81005a647216 R08: ffffffff80370b58 R09: 0000000000000001<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: R10:
0000000000000046 R11: ffffffff8004c200 R12: 0000000000000000<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: R13:
0000000000000000 R14: ffff8102352bc000 R15: ffff8102352bc062<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: FS:&nbsp;
0000000000000000(0000) GS:ffff810107eda340(0000) knlGS:0000000000000000<o:p=
></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: CS:&nbsp; 0=
010
DS: 0018 ES: 0018 CR0: 000000008005003b<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: CR2:
00002ae8ff6760a0 CR3: 000000023487c000 CR4: 00000000000006e0<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: Process
kmpath_rdacd (pid: 12912, threadinfo ffff810086958000, task ffff810092a5414=
0)<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: Stack: <o:p=
></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: 00000000100=
08040<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: ffff81005b2=
3a5c0<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: ffff8100869=
59e70<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: ffff8100869=
59dd0<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: <o:p></o:p>=
</p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: ffff8100010=
04498<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: ffff810055e=
2d800<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: ffff81005a6=
47208<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: ffff81004d3=
226f0<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: <o:p></o:p>=
</p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: 00000003804=
38420<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: 00000000000=
00001<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: ffff81023a4=
98d80<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: ffff81023a4=
98d80<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: <o:p></o:p>=
</p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: Call Trace:=
<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE:
[&lt;ffffffff8838d980&gt;] :scsi_dh_rdac:send_mode_select+0x0/0x4b0<o:p></o=
:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE:
[&lt;ffffffff800561a3&gt;] run_workqueue+0xb3/0x110<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE:
[&lt;ffffffff80052180&gt;] worker_thread+0x0/0x150<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE:
[&lt;ffffffff800b33b0&gt;] keventd_create_kthread+0x0/0xa0<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE:
[&lt;ffffffff80052291&gt;] worker_thread+0x111/0x150<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE:
[&lt;ffffffff8009ca00&gt;] default_wake_function+0x0/0x10<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE:
[&lt;ffffffff80052180&gt;] worker_thread+0x0/0x150<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE:
[&lt;ffffffff800373c9&gt;] kthread+0xd9/0x120<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE:
[&lt;ffffffff80068fb1&gt;] child_rip+0xa/0x11<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE:
[&lt;ffffffff800b33b0&gt;] keventd_create_kthread+0x0/0xa0<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE:
[&lt;ffffffff800372f0&gt;] kthread+0x0/0x120<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE:
[&lt;ffffffff80068fa7&gt;] child_rip+0x0/0x11<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: <o:p></o:p>=
</p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: <o:p></o:p>=
</p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: Code: <o:p>=
</o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: 0f <o:p></o=
:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: 0b <o:p></o=
:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: 68 <o:p></o=
:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: 98 <o:p></o=
:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: e1 <o:p></o=
:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: 38 <o:p></o=
:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: 88 <o:p></o=
:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: c2 <o:p></o=
:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: fc <o:p></o=
:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: 00 <o:p></o=
:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: 0f <o:p></o=
:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: 1f <o:p></o=
:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: 80 <o:p></o=
:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: 00 <o:p></o=
:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: 00 <o:p></o=
:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: 00 <o:p></o=
:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: 00 <o:p></o=
:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: 48 <o:p></o=
:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: 8d <o:p></o=
:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: 54 <o:p></o=
:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: <o:p></o:p>=
</p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: RIP <o:p></=
o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE:
[&lt;ffffffff8838dc4f&gt;] :scsi_dh_rdac:send_mode_select+0x2cf/0x4b0<o:p><=
/o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: RSP
&lt;ffff810086959d80&gt;<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: <o:p></o:p>=
</p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 EMERG: Kernel panic=
 - not
syncing: Fatal exception<o:p></o:p></p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 NOTICE: <o:p></o:p>=
</p>

<p class=3DMsoNormal>2011 Jan 26 22:27:03 172.19.59.130 EMERG: Rebooting in=
 1
seconds..<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>This panic comes from get_rdac_data, which is called f=
rom
within the send_mode_select code.<o:p></o:p></p>

<p class=3DMsoNormal>My analysis picked up the following problem:<o:p></o:p=
></p>

<p class=3DMsoNormal>The RDAC detach code nullifies the scsi_dh_data before
flushing the mode select workqueue, and as result a pending send_mode_selec=
t will
BUG_ON in get_rdac_data.<o:p></o:p></p>

<p class=3DMsoNormal>The following patch (tested over RHEL54) flushes the
workqueue before setting scsi_dh_data to NULL:<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>diff -r -U 2 a/drivers/scsi/device_handler/scsi_dh_rda=
c.c
b/drivers/scsi/device_handler/scsi_dh_rdac.c<o:p></o:p></p>

<p class=3DMsoNormal>---
a/drivers/scsi/device_handler/scsi_dh_rdac.c&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;
2011-01-30 11:02:31.271426000 +0200<o:p></o:p></p>

<p class=3DMsoNormal>+++
b/drivers/scsi/device_handler/scsi_dh_rdac.c&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;
2011-01-30 11:02:31.327069000 +0200<o:p></o:p></p>

<p class=3DMsoNormal>@@ -853,8 +853,22 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
spin_lock_irqsave(sdev-&gt;request_queue-&gt;queue_lock, flags);<o:p></o:p>=
</p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; scsi_dh_dat=
a =3D
retrieve_scsi_dh_data(sdev);<o:p></o:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
store_scsi_dh_data(sdev, NULL);<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
spin_unlock_irqrestore(sdev-&gt;request_queue-&gt;queue_lock, flags);<o:p><=
/o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; h =3D (stru=
ct
rdac_dh_data *) scsi_dh_data-&gt;buf;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (h-&gt;ctlr) =
{<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
int flush;<o:p></o:p></p>

<p class=3DMsoNormal>+<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
spin_lock(&amp;h-&gt;ctlr-&gt;ms_lock);<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
flush =3D (h-&gt;ctlr-&gt;ms_sdev =3D=3D sdev);<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
spin_unlock(&amp;h-&gt;ctlr-&gt;ms_lock);<o:p></o:p></p>

<p class=3DMsoNormal>+<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
if (flush)<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;
flush_workqueue(kmpath_rdacd);<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<o:p></o:p></p>

<p class=3DMsoNormal>+<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
spin_lock_irqsave(sdev-&gt;request_queue-&gt;queue_lock, flags);<o:p></o:p>=
</p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
store_scsi_dh_data(sdev, NULL);<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
spin_unlock_irqrestore(sdev-&gt;request_queue-&gt;queue_lock, flags);<o:p><=
/o:p></p>

<p class=3DMsoNormal>+<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (h-&gt;c=
tlr)<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
kref_put(&amp;h-&gt;ctlr-&gt;kref, release_controller);<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>The patch ensures that we run flush only when detachin=
g the
device the &#8220;owns&#8221; the send_mode_select (ms_sdev).<o:p></o:p></p=
>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>Menny<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

</div>

</body>

</html>

--_000_D8C50530D6022F40A817A35C40CC06A7064B3773D8DUBX7MCDUB01E_--


--===============7077016974588869068==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7077016974588869068==--

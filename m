From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: Re: [PATCH]: scsi_dh_rdac: fix BUG_ON in get_rdac_data
 from within send_mode_select
Date: Mon, 31 Jan 2011 13:38:50 -0700
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF4FF372CBD@cosmail01.lsi.com>
References: <D8C50530D6022F40A817A35C40CC06A7064B3773D8@DUBX7MCDUB01.EMEA.DELL.COM>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <D8C50530D6022F40A817A35C40CC06A7064B3773D8@DUBX7MCDUB01.EMEA.DELL.COM>
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
Cc: "Menny_Hamburger@dell.com" <Menny_Hamburger@dell.com>
List-Id: dm-devel.ids

Menny,

 I attempted to fix this bug while ego. There were some review comments. I needed to update these patches. But, I did not get chance to update it yet. Please take a look at these patches. I will try to update these patches sometime this week.

http://marc.info/?l=linux-scsi&m=128055289415827&w=4
http://marc.info/?l=linux-scsi&m=128035832331808&w=4
http://marc.info/?l=dm-devel&m=128035824431685&w=4
http://marc.info/?l=linux-scsi&m=128035797031319&w=4
http://marc.info/?l=linux-scsi&m=128035798931356&w=4
http://marc.info/?l=linux-scsi&m=128035824431684&w=4
http://marc.info/?l=linux-scsi&m=128035800631394&w=4
http://marc.info/?l=linux-scsi&m=128035828031770&w=4


As per my understating this problem happens during the combination of path removal and mode select submission.  Did you try to check the device status (offline/del/cancel- which is your earlier patch) in scsi_dh_activate?  That might help a little bit here.

Thanks
Babu

________________________________________
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On Behalf Of Menny_Hamburger@dell.com
Sent: Sunday, January 30, 2011 3:22 AM
To: dm-devel@redhat.com
Subject: [dm-devel] [PATCH]: scsi_dh_rdac: fix BUG_ON in get_rdac_data from within send_mode_select

Hi,

We are running with multipath over MD3xxx ISCSI storage (RDAC).
Our test scripts perform a series of multipathd restarts, udevtrigger and udevsettle calls, during which we logout of the storage.
Sometimes we get the following panic:

2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-11: add map (uevent)
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: lun5: event checker started
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-11: add map (uevent)
2011 Jan 26 22:27:01 node0 MAJOR: multipathd: dm-11: devmap already registered
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-11: add map (uevent)
2011 Jan 26 22:27:01 node0 MAJOR: multipathd: dm-11: devmap already registered
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-11: add map (uevent)
2011 Jan 26 22:27:01 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:01 node0 MAJOR: multipathd: dm-11: devmap already registered
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-0: add map (uevent)
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: mpath0: event checker started
2011 Jan 26 22:27:01 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-1: add map (uevent)
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: mpath1: event checker started
2011 Jan 26 22:27:01 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-2: add map (uevent)
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: mpath2: event checker started
2011 Jan 26 22:27:01 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-3: add map (uevent)
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: mpath3: event checker started
2011 Jan 26 22:27:01 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-4: add map (uevent)
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: mpath4: event checker started
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: lun5: event checker exit
2011 Jan 26 22:27:01 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-5: add map (uevent)
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: mpath6: event checker started
2011 Jan 26 22:27:01 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-6: add map (uevent)
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: mpath7: event checker started
2011 Jan 26 22:27:01 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-7: add map (uevent)
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: mpath8: event checker started
2011 Jan 26 22:27:01 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-8: add map (uevent)
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: mpath9: event checker started
2011 Jan 26 22:27:01 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-9: add map (uevent)
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: mpath10: event checker started
2011 Jan 26 22:27:01 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: dm-10: add map (uevent)
2011 Jan 26 22:27:01 node0 NOTICE: multipathd: mpath11: event checker started
2011 Jan 26 22:27:02 node0 INFO: kernel: sd 194:0:0:4: rdac: array MD3200i-c7-d7, ctlr 0, queueing MODE_SELECT command
2011 Jan 26 22:27:02 node0 DEBUG: hba_loader:iscsi_logout:1130: Started
2011 Jan 26 22:27:02 node0 DEBUG: hba_loader:iscsi_logout:1130: iscsi_luns_num=1 logout_iqn=
2011 Jan 26 22:27:02 node0 DEBUG: hba_loader:iscsi_logout:1130: Performing logout of all iSCSI nodes
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
2011 Jan 26 22:27:02 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:02 node0 MAJOR: kernel: device-mapper: table: 253:7: multipath: unknown path selector type
2011 Jan 26 22:27:02 node0 WARNING: kernel: device-mapper: ioctl: error adding target to table
2011 Jan 26 22:27:02 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:02 node0 MAJOR: kernel: device-mapper: table: 253:7: multipath: unknown path selector type
2011 Jan 26 22:27:02 node0 WARNING: kernel: device-mapper: ioctl: error adding target to table
2011 Jan 26 22:27:02 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:02 node0 MAJOR: kernel: device-mapper: table: 253:8: multipath: unknown path selector type
2011 Jan 26 22:27:02 node0 WARNING: kernel: device-mapper: ioctl: error adding target to table
2011 Jan 26 22:27:02 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:02 node0 MAJOR: multipathd: mpath8: failed in domap for removal of path sdb
2011 Jan 26 22:27:02 node0 MAJOR: multipathd: uevent trigger error
2011 Jan 26 22:27:02 node0 NOTICE: multipathd: sdd: remove path (uevent)
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:8: multipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error adding target to table
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:7: multipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error adding target to table
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:7: multipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error adding target to table
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:9: multipath: unknown path selector type
2011 Jan 26 22:27:02 node0 MAJOR: multipathd: mpath9: failed in domap for removal of path sdd
2011 Jan 26 22:27:02 node0 MAJOR: multipathd: uevent trigger error
2011 Jan 26 22:27:02 node0 NOTICE: multipathd: sdh: remove path (uevent)
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath8: failed in domap for removal of path sdh
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent trigger error
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error adding target to table
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdf: remove path (uevent)
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:9: multipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error adding target to table
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath10: failed in domap for removal of path sdf
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent trigger error
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdo: remove path (uevent)
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:8: multipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error adding target to table
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:8: multipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error adding target to table
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath9: failed in domap for removal of path sdo
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent trigger error
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdj: remove path (uevent)
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:10: multipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error adding target to table
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: scsi 194:0:0:8: rejecting I/O to dead device
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: multipath: Failing path 65:112.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: scsi 195:0:0:8: rejecting I/O to dead device
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: multipath: Failing path 65:160.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: multipath: Cannot failover device because scsi_dh_rdac was not loaded.
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: multipath: Failing path 66:208.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: multipath: Cannot failover device because scsi_dh_rdac was not loaded.
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: multipath: Failing path 66:224.
2011 Jan 26 22:27:03 node0 WARNING: kernel: printk: 46 messages suppressed.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: Buffer I/O error on device dm-0, logical block 0
2011 Jan 26 22:27:03 node0 MAJOR: kernel: Buffer I/O error on device dm-0, logical block 1
2011 Jan 26 22:27:03 node0 MAJOR: kernel: Buffer I/O error on device dm-0, logical block 2
2011 Jan 26 22:27:03 node0 MAJOR: kernel: Buffer I/O error on device dm-0, logical block 3
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:10: multipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error adding target to table
2011 Jan 26 22:27:03 node0 MAJOR: kernel: Buffer I/O error on device dm-0, logical block 0
2011 Jan 26 22:27:03 node0 MAJOR: kernel: Buffer I/O error on device dm-0, logical block 70778879
2011 Jan 26 22:27:03 node0 MAJOR: kernel: Buffer I/O error on device dm-0, logical block 70778879
2011 Jan 26 22:27:03 node0 MAJOR: kernel: Buffer I/O error on device dm-0, logical block 0
2011 Jan 26 22:27:03 node0 MAJOR: kernel: Buffer I/O error on device dm-0, logical block 0
2011 Jan 26 22:27:03 node0 MAJOR: kernel: Buffer I/O error on device dm-0, logical block 3
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath11: failed in domap for removal of path sdj
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent trigger error
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdl: remove path (uevent)
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:3: multipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error adding target to table
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:3: multipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error adding target to table
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath3: failed in domap for removal of path sdl
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent trigger error
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: 65:160: mark as failed
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: mpath0: remaining active paths: 3
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: 65:112: mark as failed
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: mpath0: remaining active paths: 2
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: 66:208: mark as failed
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: mpath0: remaining active paths: 1
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: 66:224: mark as failed
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: mpath0: remaining active paths: 0
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdt: remove path (uevent)
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:9: multipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error adding target to table
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:9: multipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error adding target to table
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath10: failed in domap for removal of path sdt
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent trigger error
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdn: remove path (uevent)
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:4: multipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error adding target to table
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:4: multipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error adding target to table
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath4: failed in domap for removal of path sdn
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent trigger error
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdy: remove path (uevent)
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:10: multipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error adding target to table
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:10: multipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error adding target to table
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath11: failed in domap for removal of path sdy
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent trigger error
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdc: remove path (uevent)
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:7: multipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error adding target to table
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:7: multipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error adding target to table
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath8: failed in domap for removal of path sdc
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent trigger error
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sde: remove path (uevent)
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:8: multipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error adding target to table
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:8: multipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error adding target to table
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath9: failed in domap for removal of path sde
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent trigger error
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdaf: remove path (uevent)
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:3: multipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error adding target to table
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:3: multipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error adding target to table
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath3: failed in domap for removal of path sdaf
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent trigger error
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdg: remove path (uevent)
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:9: multipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error adding target to table
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:9: multipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error adding target to table
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath10: failed in domap for removal of path sdg
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:4: multipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error adding target to table
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:4: multipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error adding target to table
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent trigger error
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdah: remove path (uevent)
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath4: failed in domap for removal of path sdah
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent trigger error
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdk: remove path (uevent)
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:10: multipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error adding target to table
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:10: multipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error adding target to table
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath11: failed in domap for removal of path sdk
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:3: multipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error adding target to table
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:3: multipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error adding target to table
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent trigger error
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdm: remove path (uevent)
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath3: failed in domap for removal of path sdm
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent trigger error
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdan: remove path (uevent)
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:5: multipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error adding target to table
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:5: multipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error adding target to table
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath6: failed in domap for removal of path sdan
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent trigger error
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdq: remove path (uevent)
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:4: multipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error adding target to table
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:4: multipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error adding target to table
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath4: failed in domap for removal of path sdq
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:6: multipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error adding target to table
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:6: multipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error adding target to table
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent trigger error
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdap: remove path (uevent)
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath7: failed in domap for removal of path sdap
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent trigger error
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sds: remove path (uevent)
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:5: multipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error adding target to table
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:5: multipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error adding target to table
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: mpath6: failed in domap for removal of path sds
2011 Jan 26 22:27:03 node0 MAJOR: multipathd: uevent trigger error
2011 Jan 26 22:27:03 node0 NOTICE: multipathd: sdw: remove path (uevent)
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 node0 MAJOR: kernel: device-mapper: table: 253:6: multipath: unknown path selector type
2011 Jan 26 22:27:03 node0 WARNING: kernel: device-mapper: ioctl: error adding target to table
2011 Jan 26 22:27:03 node0 INFO: kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: ----------- [cut here ] --------- [please bite here ] ---------
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: Kernel BUG at drivers/scsi/device_handler/scsi_dh_rdac.c:252
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: invalid opcode: 0000 [1]
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: SMP
2011 Jan 26 22:27:03 172.19.59.130 NOTICE:
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: last sysfs file: /class/iscsi_session/session9/ifacename
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
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: Pid: 12912, comm: kmpath_rdacd Tainted: G      2.6.18-164sys #1
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: RIP: 0010:[<ffffffff8838dc4f>]
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: [<ffffffff8838dc4f>] :scsi_dh_rdac:send_mode_select+0x2cf/0x4b0
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: device-mapper: table: 253:6: multipath: unknown path selector type
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: device-mapper: ioctl: error adding target to table
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: RSP: 0018:ffff810086959d80  EFLAGS: 00010246
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: RAX: 0000000000000000 RBX: 00000000fffffffb RCX: 0000000000000000
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: RDX: 0000000000000800 RSI: 0000000000000286 RDI: ffff810055e2d800
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: RBP: ffff81005a647216 R08: ffffffff80370b58 R09: 0000000000000001
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: R10: 0000000000000046 R11: ffffffff8004c200 R12: 0000000000000000
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: R13: 0000000000000000 R14: ffff8102352bc000 R15: ffff8102352bc062
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: FS:  0000000000000000(0000) GS:ffff810107eda340(0000) knlGS:0000000000000000
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: CR2: 00002ae8ff6760a0 CR3: 000000023487c000 CR4: 00000000000006e0
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: Process kmpath_rdacd (pid: 12912, threadinfo ffff810086958000, task ffff810092a54140)
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
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: [<ffffffff8838d980>] :scsi_dh_rdac:send_mode_select+0x0/0x4b0
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: [<ffffffff800561a3>] run_workqueue+0xb3/0x110
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: [<ffffffff80052180>] worker_thread+0x0/0x150
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: [<ffffffff800b33b0>] keventd_create_kthread+0x0/0xa0
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: [<ffffffff80052291>] worker_thread+0x111/0x150
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: [<ffffffff8009ca00>] default_wake_function+0x0/0x10
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: [<ffffffff80052180>] worker_thread+0x0/0x150
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: [<ffffffff800373c9>] kthread+0xd9/0x120
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: [<ffffffff80068fb1>] child_rip+0xa/0x11
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: [<ffffffff800b33b0>] keventd_create_kthread+0x0/0xa0
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: [<ffffffff800372f0>] kthread+0x0/0x120
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: [<ffffffff80068fa7>] child_rip+0x0/0x11
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
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: [<ffffffff8838dc4f>] :scsi_dh_rdac:send_mode_select+0x2cf/0x4b0
2011 Jan 26 22:27:03 172.19.59.130 NOTICE: RSP <ffff810086959d80>
2011 Jan 26 22:27:03 172.19.59.130 NOTICE:
2011 Jan 26 22:27:03 172.19.59.130 EMERG: Kernel panic - not syncing: Fatal exception
2011 Jan 26 22:27:03 172.19.59.130 NOTICE:
2011 Jan 26 22:27:03 172.19.59.130 EMERG: Rebooting in 1 seconds..


This panic comes from get_rdac_data, which is called from within the send_mode_select code.
My analysis picked up the following problem:
The RDAC detach code nullifies the scsi_dh_data before flushing the mode select workqueue, and as result a pending send_mode_select will BUG_ON in get_rdac_data.
The following patch (tested over RHEL54) flushes the workqueue before setting scsi_dh_data to NULL:

diff -r -U 2 a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c        2011-01-30 11:02:31.271426000 +0200
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c        2011-01-30 11:02:31.327069000 +0200
@@ -853,8 +853,22 @@
        spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
        scsi_dh_data = retrieve_scsi_dh_data(sdev);
-       store_scsi_dh_data(sdev, NULL);
        spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);

        h = (struct rdac_dh_data *) scsi_dh_data->buf;
+       if (h->ctlr) {
+               int flush;
+
+               spin_lock(&h->ctlr->ms_lock);
+               flush = (h->ctlr->ms_sdev == sdev);
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



The patch ensures that we run flush only when detaching the device the "owns" the send_mode_select (ms_sdev).

Menny

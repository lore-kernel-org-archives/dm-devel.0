From: Marcus White <roastedseaweed.k@gmail.com>
Subject: Devicemapper issues.
Date: Sun, 17 Apr 2016 21:03:15 -0700
Message-ID: <CALAJOd2_yEE=dK-sjLYuzG8jyGOs7No7iJ-cEU54z-b4sr1WOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
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

Hello,
I was having some issues on devicemapper and had a question about it.
Would appreciate any help. Running RH 6.7

The storage is ALUA compliant, active standby, implicit only.
Following is the conf file:

defaults {
        polling_interval        10
        path_selector                "round-robin 0"
        path_grouping_policy    group_by_prio
        prio                    alua
        path_checker            readsector0
        rr_min_io_rq            10
        max_fds                 8192
        rr_weight               priorities
        failback                immediate
       no_path_retry           fail
}

What I see in the logs is that DM doesnt seem to recognize the standby
paths and sends IO to the standby path, eventually marking them
failed..What doesnt make sense is why the DM is marking these paths
failed exactly. Looks like multipath sees the paths correctly..



multipath output:
--------------------
multipath -ll
mpathg (36000eb3f455ccd8b000000000000004b) dm-3 TEST,VDISK
size=1000G features='0' hwhandler='0' wp=rw
|-+- policy='round-robin 0' prio=81 status=enabled
| |- 5:0:1:1 sdd 8:48 active ready  running
| |- 4:0:0:1 sdf 8:80 active ready  running
| `- 4:0:1:1 sde 8:64 active ready  running
`-+- policy='round-robin 0' prio=50 status=enabled
  `- 5:0:0:1 sdc 8:32 active ready  running



multipath -v3: The right number of standby and active paths reported..
--------------
Apr 17 21:24:53 | sde: not found in pathvec
Apr 17 21:24:53 | sde: mask = 0x3f
Apr 17 21:24:53 | sde: dev_t = 8:64
Apr 17 21:24:53 | sde: size = 2097152000
Apr 17 21:24:53 | sde: subsystem = scsi
Apr 17 21:24:53 | sde: vendor = TEST
Apr 17 21:24:53 | sde: product = VDISK
Apr 17 21:24:53 | sde: rev = d000
Apr 17 21:24:53 | sde: h:b:t:l = 4:0:1:1
Apr 17 21:24:53 | sde: tgt_node_name = 0xxxxxxxxxxxx
Apr 17 21:24:53 | sde: serial = f455ccd8b9491041a82f42d40de8ad09000000000000004b
Apr 17 21:24:53 | sde: get_state
Apr 17 21:24:53 | sde: path checker = tur (config file default)
Apr 17 21:24:53 | sde: checker timeout = 30000 ms (sysfs setting)
Apr 17 21:24:53 | sde: state = running
Apr 17 21:24:53 | sde: state = 3
Apr 17 21:24:53 | sde: getuid = /lib/udev/scsi_id --whitelisted
--device=/dev/%n (config file default)
Apr 17 21:24:53 | sde: uid = 36000eb3f455ccd8b000000000000004b (callout)
Apr 17 21:24:53 | sde: state = running
Apr 17 21:24:53 | sde: detect_prio = 1 (config file default)
Apr 17 21:24:53 | sde: prio = alua (config file default)
Apr 17 21:24:53 | reported target port group is 1
Apr 17 21:24:53 | aas = 82 [standby] [preferred]
Apr 17 21:24:53 | sde: alua prio = 81

logs
--------
Apr 15 15:50:20 serv1 kernel: device-mapper: table: 253:3: multipath:
error getting device
Apr 15 15:50:20 serv1 kernel: device-mapper: ioctl: error adding target to table
Apr 15 15:54:21 serv1 kernel: device-mapper: table: 253:3: multipath:
error getting device
Apr 15 15:54:21 serv1 kernel: device-mapper: ioctl: error adding target to table
Apr 15 15:54:28 serv1 kernel: device-mapper: table: 253:3: multipath:
error getting device
Apr 15 15:54:28 serv1 kernel: device-mapper: ioctl: error adding target to table
Apr 15 15:54:30 serv1 kernel: device-mapper: table: 253:3: multipath:
error getting device
Apr 15 15:54:30 serv1 kernel: device-mapper: ioctl: error adding target to table

Apr 15 15:54:58 serv1 kernel: scsi 5:0:0:1: Direct-Access     V_DISK
     d000 PQ: 0 ANSI: 6
Apr 15 15:54:58 serv1 kernel: sd 5:0:0:1: Attached scsi generic sg8 type 0
Apr 15 15:54:58 serv1 kernel: sd 5:0:0:1: Parameters changed
Apr 15 15:54:58 serv1 kernel: sd 5:0:0:1: [sdc] Spinning up disk...
Apr 15 15:54:58 serv1 kernel: scsi 5:0:1:1: Direct-Access     V_DISK
     d000 PQ: 0 ANSI: 6
Apr 15 15:54:58 serv1 kernel: sd 5:0:1:1: Attached scsi generic sg9 type 0
Apr 15 15:54:58 serv1 kernel: sd 5:0:1:1: Parameters changed
Apr 15 15:54:58 serv1 kernel: sd 5:0:1:1: [sdd] 2097152000 512-byte
logical blocks: (1.07 TB/1000 GiB)
Apr 15 15:54:58 serv1 kernel: scsi 4:0:1:1: Direct-Access     V_DISK
     d000 PQ: 0 ANSI: 6
Apr 15 15:54:58 serv1 kernel: sd 5:0:1:1: [sdd] Write Protect is off
Apr 15 15:54:58 serv1 kernel: sd 4:0:1:1: Attached scsi generic sg10 type 0
Apr 15 15:54:58 serv1 kernel: sd 5:0:1:1: [sdd] Write cache: disabled,
read cache: disabled, doesn't support DPO or FUA
Apr 15 15:54:58 serv1 kernel: sd 4:0:1:1: Parameters changed
Apr 15 15:54:58 serv1 kernel: scsi 4:0:0:1: Direct-Access     V_DISK
     d000 PQ: 0 ANSI: 6
Apr 15 15:54:58 serv1 kernel: sd 4:0:0:1: Attached scsi generic sg11 type 0
Apr 15 15:54:58 serv1 kernel: sd 4:0:0:1: Parameters changed
Apr 15 15:54:58 serv1 kernel: sd 4:0:0:1: [sdf] 2097152000 512-byte
logical blocks: (1.07 TB/1000 GiB)
Apr 15 15:54:58 serv1 kernel: sdd:
Apr 15 15:54:58 serv1 kernel: sd 5:0:1:1: [sdd]  Result:
hostbyte=DID_OK driverbyte=DRIVER_SENSE
Apr 15 15:54:58 serv1 kernel: sd 5:0:1:1: [sdd]  Sense Key : Not Ready [current]
Apr 15 15:54:58 serv1 kernel: sd 5:0:1:1: [sdd]  Add. Sense: Logical
unit not accessible, target port in standby state
Apr 15 15:54:58 serv1 kernel: sd 5:0:1:1: [sdd] CDB: Read(10): 28 00
00 00 00 00 00 00 08 00
Apr 15 15:54:58 serv1 kernel: end_request: I/O error, dev sdd, sector 0
Apr 15 15:54:58 serv1 kernel: Buffer I/O error on device sdd, logical block 0
Apr 15 15:54:58 serv1 kernel: sd 4:0:1:1: [sde] 2097152000 512-byte
logical blocks: (1.07 TB/1000 GiB)
Apr 15 15:54:58 serv1 kernel: sd 4:0:0:1: [sdf] Write Protect is off
Apr 15 15:54:58 serv1 kernel: sd 4:0:0:1: [sdf] Write cache: disabled,
read cache: disabled, doesn't support DPO or FUA
Apr 15 15:54:58 serv1 kernel: sd 5:0:1:1: [sdd]  Result:
hostbyte=DID_OK driverbyte=DRIVER_SENSE
Apr 15 15:54:58 serv1 kernel: sd 5:0:1:1: [sdd]  Sense Key : Not Ready [current]
Apr 15 15:54:58 serv1 kernel: sd 5:0:1:1: [sdd]  Add. Sense: Logical
unit not accessible, target port in standby state
Apr 15 15:54:58 serv1 kernel: sd 5:0:1:1: [sdd] CDB: Read(10): 28 00
00 00 00 00 00 00 08 00
Apr 15 15:54:58 serv1 kernel: end_request: I/O error, dev sdd, sector 0
Apr 15 15:54:58 serv1 kernel: Buffer I/O error on device sdd, logical block 0
Apr 15 15:54:58 serv1 kernel: sd 4:0:1:1: [sde] Write Protect is off
Apr 15 15:54:58 serv1 kernel: sd 5:0:1:1: [sdd]  Result:
hostbyte=DID_OK driverbyte=DRIVER_SENSE
Apr 15 15:54:58 serv1 kernel: sd 5:0:1:1: [sdd]  Sense Key : Not Ready [current]
Apr 15 15:54:58 serv1 kernel: sd 5:0:1:1: [sdd]  Add. Sense: Logical
unit not accessible, target port in standby state
Apr 15 15:54:58 serv1 kernel: sd 5:0:1:1: [sdd] CDB: Read(10): 28 00
00 00 00 00 00 00 08 00
Apr 15 15:54:58 serv1 kernel: end_request: I/O error, dev sdd, sector 0
Apr 15 15:54:58 serv1 kernel: Buffer I/O error on device sdd, logical block 0
Apr 15 15:54:58 serv1 kernel: sd 5:0:1:1: [sdd]  Result:
hostbyte=DID_OK driverbyte=DRIVER_SENSE
Apr 15 15:54:58 serv1 kernel: sd 5:0:1:1: [sdd]  Sense Key : Not Ready [current]
Apr 15 15:54:58 serv1 kernel: sd 5:0:1:1: [sdd]  Add. Sense: Logical
unit not accessible, target port in standby state
Apr 15 15:54:58 serv1 kernel: sd 5:0:1:1: [sdd] CDB: Read(10): 28 00
00 00 00 00 00 00 08 00
Apr 15 15:54:58 serv1 kernel: end_request: I/O error, dev sdd, sector 0
Apr 15 15:54:58 serv1 kernel: Buffer I/O error on device sdd, logical block 0
Apr 15 15:54:58 serv1 kernel: sd 4:0:1:1: [sde] Write cache: disabled,
read cache: disabled, doesn't support DPO or FUA
Apr 15 15:54:58 serv1 kernel: sd 5:0:1:1: [sdd]  Result:
hostbyte=DID_OK driverbyte=DRIVER_SENSE
Apr 15 15:54:58 serv1 kernel: sd 5:0:1:1: [sdd]  Sense Key : Not Ready [current]
Apr 15 15:54:58 serv1 kernel: sd 5:0:1:1: [sdd]  Add. Sense: Logical
unit not accessible, target port in standby state
Apr 15 15:54:58 serv1 kernel: sd 5:0:1:1: [sdd] CDB: Read(10): 28 00
00 00 00 00 00 00 08 00
Apr 15 15:54:58 serv1 kernel: end_request: I/O error, dev sdd, sector 0
Apr 15 15:54:58 serv1 kernel: Buffer I/O error on device sdd, logical block 0
Apr 15 15:54:58 serv1 kernel: sd 5:0:1:1: [sdd]  Result:
hostbyte=DID_OK driverbyte=DRIVER_SENSE
Apr 15 15:54:58 serv1 kernel: sd 5:0:1:1: [sdd]  Sense Key : Not Ready [current]
Apr 15 15:54:58 serv1 kernel: sd 5:0:1:1: [sdd]  Add. Sense: Logical
unit not accessible, target port in standby state
Apr 15 15:54:58 serv1 kernel: sd 5:0:1:1: [sdd] CDB: Read(10): 28 00
00 00 00 00 00 00 08 00
Apr 15 15:54:58 serv1 kernel: end_request: I/O error, dev sdd, sector 0
Apr 15 15:54:58 serv1 kernel: sdf:

Apr 15 15:54:58 serv1 multipathd: sdd: add path (uevent)
Apr 15 15:54:58 serv1 kernel: device-mapper: multipath: Failing path 8:80.
Apr 15 15:54:58 serv1 multipathd: mpathg: load table [0 2097152000
multipath 0 0 1 1 round-robin 0 2 1 8:80 2430 8:48 2430]
Apr 15 15:54:58 serv1 multipathd: sdd [8:48]: path added to devmap mpathg
Apr 15 15:54:58 serv1 multipathd: sde: add path (uevent)
Apr 15 15:54:58 serv1 kernel: device-mapper: multipath: Failing path 8:80.
Apr 15 15:54:58 serv1 kernel: device-mapper: multipath: Failing path 8:48.
Apr 15 15:54:58 serv1 multipathd: mpathg: load table [0 2097152000
multipath 0 0 1 1 round-robin 0 3 1 8:80 2430 8:48 2430 8:64 2430]
Apr 15 15:54:58 serv1 multipathd: sde [8:64]: path added to devmap mpathg
Apr 15 15:54:58 serv1 kernel: device-mapper: multipath: Failing path 8:80.
Apr 15 15:54:58 serv1 kernel: device-mapper: multipath: Failing path 8:48.
Apr 15 15:54:58 serv1 kernel: device-mapper: multipath: Failing path 8:64.
Apr 15 15:54:58 serv1 multipathd: mpathg: sdf - readsector0 checker
reports path is down
Apr 15 15:54:58 serv1 multipathd: mpathg: sdd - readsector0 checker
reports path is down
Apr 15 15:54:58 serv1 multipathd: mpathg: sde - readsector0 checker
reports path is down
Apr 15 15:54:59 serv1 kernel: .
Apr 15 15:54:59 serv1 kernel: sd 5:0:0:1: Parameters changedready
Apr 15 15:54:59 serv1 kernel: sd 5:0:0:1: [sdc] 2097152000 512-byte
logical blocks: (1.07 TB/1000 GiB)
Apr 15 15:54:59 serv1 kernel: sd 5:0:0:1: [sdc] Write Protect is off
Apr 15 15:54:59 serv1 kernel: sd 5:0:0:1: [sdc] Write cache: disabled,
read cache: disabled, doesn't support DPO or FUA
Apr 15 15:54:59 serv1 kernel: sdc: sdc1 sdc2
Apr 15 15:54:59 serv1 kernel: sd 5:0:0:1: [sdc] Attached SCSI disk
Apr 15 15:54:59 serv1 multipathd: sdc: add path (uevent)
Apr 15 15:54:59 serv1 multipathd: mpathg: load table [0 2097152000
multipath 0 0 2 2 round-robin 0 3 1 8:80 2430 8:48 2430 8:64 2430
round-robin 0 1 1 8:32 1500]
Apr 15 15:54:59 serv1 multipathd: sdc [8:32]: path added to devmap mpathg
Apr 15 15:54:59 serv1 kernel: device-mapper: multipath: Failing path 8:80.
Apr 15 15:54:59 serv1 kernel: device-mapper: multipath: Failing path 8:48.
Apr 15 15:54:59 serv1 kernel: device-mapper: multipath: Failing path 8:64.
Apr 15 15:55:00 serv1 kernel: sd 5:0:0:1: Warning! Received an
indication that the LUN assignments on this target have changed. The
Linux SCSI layer does not automatically remap LUN assignments.
Apr 15 15:55:03 serv1 kernel: sd 4:0:0:1: Warning! Received an
indication that the LUN assignments on this target have changed. The
Linux SCSI layer does not automatically remap LUN assignments.
Apr 15 15:55:03 serv1 multipathd: mpathg: sdf - readsector0 checker
reports path is down
Apr 15 15:55:03 serv1 multipathd: mpathg: sdd - readsector0 checker
reports path is down
Apr 15 15:55:03 serv1 kernel: sd 5:0:1:1: Warning! Received an
indication that the LUN assignments on this target have changed. The
Linux SCSI layer does not automatically remap LUN assignments.
Apr 15 15:55:03 serv1 kernel: sd 4:0:1:1: Warning! Received an
indication that the LUN assignments on this target have changed. The
Linux SCSI layer does not automatically remap LUN assignments.
Apr 15 15:55:03 serv1 multipathd: mpathg: sde - readsector0 checker
reports path is down
Apr 15 15:55:03 serv1 kernel: __ratelimit: 801 callbacks suppressed
Apr 15 15:55:03 serv1 kernel: sd 4:0:0:1: [sdf]  Result:
hostbyte=DID_OK driverbyte=DRIVER_SENSE
Apr 15 15:55:03 serv1 kernel: sd 4:0:0:1: [sdf]  Sense Key : Not Ready [current]
Apr 15 15:55:03 serv1 kernel: sd 4:0:0:1: [sdf]  Add. Sense: Logical
unit not accessible, target port in standby state
Apr 15 15:55:03 serv1 kernel: sd 4:0:0:1: [sdf] CDB: Read(10): 28 00
7c ff ff 80 00 00 08 00

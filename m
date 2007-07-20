From: Trevor Astrope <astrope@tabbweb.com>
Subject: Problem with Multipath on Hitachi DF600F
Date: Fri, 20 Jul 2007 14:03:36 -0400 (EDT)
Message-ID: <Pine.LNX.4.61.0707201341270.2191@jimi.tabbweb.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
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

Hello,

We have a DF600F connected via 2 paths to a rhel5 server running 
device-mapper-multipath 0.4.7 from Red Hat. We are using pp_hds_modular 
v1.14 instead of mpath_prio_hds_modular that came with the package, as it 
is only v1.12.

When we disconnect a cable to an hba, the devices are all marked as faulty 
and the other path is used and it recovers when the cable is reconnected. 
However, on Tuesday the technician from Hitachi came to perform a 
microcode update. He first took controller 0 on the DF600F offline. 
multipath -ll reported the devices on that path as faulty and as active 
when the controller was back online. He then repeated the process with 
controller 1 and multipath also reported the devices on that path as 
faulty and then active when it was back online. But the postgresql vacuum 
I was running during this time crashed with i/o errors and the filesystem 
on the lvm2 volume was mounted in read-only mode.

Below are the logs. The devices sdb, sdc, sdd and sde are on the 
controller 0 path and the devices sdf, sdg, sdh and sdi are on the 
controller 1 path. Any ideas why the multipathing
didn't work?

Jul 17 09:25:53 rhel5 multipathd: 1HITACHI_D60052410003: load table [0 348200960 multipath 0 0 2 1 round-robin 0 1 1 8:48 1000 round-robin 0 1 1 8:112 1000] 
Jul 17 09:25:53 rhel5 kernel: device-mapper: multipath: Failing path 8:16.
Jul 17 09:25:53 rhel5 multipathd: 1HITACHI_D60052410004: load table [0 348205056 multipath 0 0 2 1 round-robin 0 1 1 8:128 1000 round-robin 0 1 1 8:64 1000] 
Jul 17 09:25:53 rhel5 multipathd: 1HITACHI_D60052410001: event checker started 
Jul 17 09:25:53 rhel5 multipathd: 1HITACHI_D60052410002: event checker started 
Jul 17 09:25:53 rhel5 multipathd: 1HITACHI_D60052410003: event checker started 
Jul 17 09:25:53 rhel5 multipathd: 1HITACHI_D60052410004: event checker started 
Jul 17 09:25:53 rhel5 multipathd: path checkers start up 
Jul 17 09:25:53 rhel5 multipathd: sdb: readsector0 checker reports path is down 
Jul 17 09:25:53 rhel5 multipathd: checker failed path 8:16 in map 1HITACHI_D60052410001 
Jul 17 09:25:53 rhel5 multipathd: 1HITACHI_D60052410001: remaining active paths: 1 
Jul 17 09:25:53 rhel5 multipathd: sdc: readsector0 checker reports path is down 
Jul 17 09:25:53 rhel5 kernel: device-mapper: multipath: Failing path 8:32.
Jul 17 09:25:53 rhel5 multipathd: checker failed path 8:32 in map 1HITACHI_D60052410002 
Jul 17 09:25:53 rhel5 kernel: device-mapper: multipath: Failing path 8:48.
Jul 17 09:25:53 rhel5 multipathd: 1HITACHI_D60052410002: remaining active paths: 1 
Jul 17 09:25:53 rhel5 kernel: device-mapper: multipath: Failing path 8:64.
Jul 17 09:25:53 rhel5 multipathd: sdd: readsector0 checker reports path is down 
Jul 17 09:25:53 rhel5 multipathd: checker failed path 8:48 in map 1HITACHI_D60052410003 
Jul 17 09:25:53 rhel5 multipathd: 1HITACHI_D60052410003: remaining active paths: 1 
Jul 17 09:25:53 rhel5 multipathd: sde: readsector0 checker reports path is down 
Jul 17 09:25:53 rhel5 multipathd: checker failed path 8:64 in map 1HITACHI_D60052410004 
Jul 17 09:25:53 rhel5 multipathd: 1HITACHI_D60052410004: remaining active paths: 1 
Jul 17 09:25:58 rhel5 multipathd: sdb: readsector0 checker reports path is up 
Jul 17 09:25:58 rhel5 multipathd: 8:16: reinstated 
Jul 17 09:25:58 rhel5 multipathd: 1HITACHI_D60052410001: remaining active paths: 2 
Jul 17 09:25:58 rhel5 multipathd: sdc: readsector0 checker reports path is up 
Jul 17 09:25:58 rhel5 multipathd: 8:32: reinstated 
Jul 17 09:25:58 rhel5 multipathd: 1HITACHI_D60052410002: remaining active paths: 2 
Jul 17 09:25:58 rhel5 multipathd: sdd: readsector0 checker reports path is up 
Jul 17 09:25:58 rhel5 multipathd: 8:48: reinstated 
Jul 17 09:25:58 rhel5 multipathd: 1HITACHI_D60052410003: remaining active paths: 2 
Jul 17 09:25:58 rhel5 multipathd: sde: readsector0 checker reports path is up 
Jul 17 09:25:58 rhel5 multipathd: 8:64: reinstated 
Jul 17 09:25:58 rhel5 multipathd: 1HITACHI_D60052410004: remaining active paths: 2 
Jul 17 09:26:34 rhel5 kernel: lpfc 0000:04:00.0: 0:1305 Link Down Event x2 received Data: x2 x20 x0
Jul 17 09:26:35 rhel5 kernel: lpfc 0000:04:00.0: 0:1303 Link Up Event x3 received Data: x3 x1 x4 x1
Jul 17 09:27:04 rhel5 kernel:  rport-1:0-0: blocked FC remote port time out: saving binding
Jul 17 09:27:04 rhel5 kernel: lpfc 0000:04:00.0: 0:0203 Devloss timeout on WWPN 50:6:e:80:0:43:b8:91 NPort xe8 Data: x8 x7 x1
Jul 17 09:27:04 rhel5 kernel: device-mapper: multipath: Failing path 8:16.
Jul 17 09:27:04 rhel5 multipathd: sdb: readsector0 checker reports path is down 
Jul 17 09:27:04 rhel5 multipathd: checker failed path 8:16 in map 1HITACHI_D60052410001 
Jul 17 09:27:04 rhel5 multipathd: 1HITACHI_D60052410001: remaining active paths: 1 
Jul 17 09:27:04 rhel5 multipathd: sdc: readsector0 checker reports path is down 
Jul 17 09:27:04 rhel5 multipathd: checker failed path 8:32 in map 1HITACHI_D60052410002 
Jul 17 09:27:04 rhel5 kernel: device-mapper: multipath: Failing path 8:32.
Jul 17 09:27:04 rhel5 multipathd: 1HITACHI_D60052410002: remaining active paths: 1 
Jul 17 09:27:04 rhel5 multipathd: sdd: readsector0 checker reports path is down 
Jul 17 09:27:04 rhel5 multipathd: checker failed path 8:48 in map 1HITACHI_D60052410003 
Jul 17 09:27:04 rhel5 kernel: device-mapper: multipath: Failing path 8:48.
Jul 17 09:27:04 rhel5 multipathd: 1HITACHI_D60052410003: remaining active paths: 1 
Jul 17 09:27:04 rhel5 kernel: device-mapper: multipath: Failing path 8:64.
Jul 17 09:27:09 rhel5 multipathd: sde: readsector0 checker reports path is down 
Jul 17 09:27:09 rhel5 multipathd: checker failed path 8:64 in map 1HITACHI_D60052410004 
Jul 17 09:27:09 rhel5 multipathd: 1HITACHI_D60052410004: remaining active paths: 1 
Jul 17 09:27:09 rhel5 multipathd: sdb: readsector0 checker reports path is down 
Jul 17 09:27:09 rhel5 multipathd: sdc: readsector0 checker reports path is down 
Jul 17 09:27:09 rhel5 multipathd: sdd: readsector0 checker reports path is down 
Jul 17 09:27:09 rhel5 multipathd: sde: readsector0 checker reports path is down 
Jul 17 09:27:14 rhel5 multipathd: sdb: readsector0 checker reports path is down 
Jul 17 09:27:14 rhel5 multipathd: sdc: readsector0 checker reports path is down 
Jul 17 09:27:14 rhel5 multipathd: sdd: readsector0 checker reports path is down 
Jul 17 09:27:14 rhel5 multipathd: sde: readsector0 checker reports path is down 
Jul 17 09:27:18 rhel5 kernel: lpfc 0000:04:00.0: 0:1305 Link Down Event x4 received Data: x4 x20 x0
Jul 17 09:27:19 rhel5 multipathd: sdb: readsector0 checker reports path is down 
Jul 17 09:27:19 rhel5 multipathd: sdc: readsector0 checker reports path is down 
Jul 17 09:27:19 rhel5 multipathd: sdd: readsector0 checker reports path is down 
Jul 17 09:27:19 rhel5 multipathd: sde: readsector0 checker reports path is down 
Jul 17 09:27:24 rhel5 multipathd: sdb: readsector0 checker reports path is down 
Jul 17 09:27:24 rhel5 multipathd: sdc: readsector0 checker reports path is down 
Jul 17 09:27:24 rhel5 multipathd: sdd: readsector0 checker reports path is down 
Jul 17 09:27:24 rhel5 multipathd: sde: readsector0 checker reports path is down 
Jul 17 09:27:29 rhel5 multipathd: sdb: readsector0 checker reports path is down 
Jul 17 09:27:29 rhel5 multipathd: sdc: readsector0 checker reports path is down 
Jul 17 09:27:29 rhel5 multipathd: sdd: readsector0 checker reports path is down 
Jul 17 09:27:29 rhel5 multipathd: sde: readsector0 checker reports path is down 
Jul 17 09:27:34 rhel5 multipathd: sdb: readsector0 checker reports path is down 
Jul 17 09:27:34 rhel5 multipathd: sdc: readsector0 checker reports path is down 
Jul 17 09:27:34 rhel5 multipathd: sdd: readsector0 checker reports path is down 
Jul 17 09:27:34 rhel5 multipathd: sde: readsector0 checker reports path is down 
Jul 17 09:27:39 rhel5 multipathd: sdb: readsector0 checker reports path is down 
Jul 17 09:27:39 rhel5 multipathd: sdc: readsector0 checker reports path is down 
Jul 17 09:27:39 rhel5 multipathd: sdd: readsector0 checker reports path is down 
Jul 17 09:27:39 rhel5 multipathd: sde: readsector0 checker reports path is down 
Jul 17 09:27:43 rhel5 kernel: lpfc 0000:04:00.0: 0:1303 Link Up Event x5 received Data: x5 x1 x4 x1
Jul 17 09:27:44 rhel5 multipathd: sdb: readsector0 checker reports path is down 
Jul 17 09:27:49 rhel5 multipathd: sdc: readsector0 checker reports path is down 
Jul 17 09:27:49 rhel5 multipathd: sdd: readsector0 checker reports path is down 
Jul 17 09:27:49 rhel5 multipathd: sde: readsector0 checker reports path is down 
Jul 17 09:27:49 rhel5 multipathd: sdb: readsector0 checker reports path is down 
Jul 17 09:27:49 rhel5 multipathd: sdc: readsector0 checker reports path is down 
Jul 17 09:27:49 rhel5 multipathd: sdd: readsector0 checker reports path is down 
Jul 17 09:27:49 rhel5 multipathd: sde: readsector0 checker reports path is down 
Jul 17 09:27:54 rhel5 multipathd: sdb: readsector0 checker reports path is down 
Jul 17 09:27:59 rhel5 multipathd: sdc: readsector0 checker reports path is down 
Jul 17 09:27:59 rhel5 multipathd: sdd: readsector0 checker reports path is down 
Jul 17 09:27:59 rhel5 multipathd: sde: readsector0 checker reports path is down 
Jul 17 09:27:59 rhel5 multipathd: sdb: readsector0 checker reports path is down 
Jul 17 09:27:59 rhel5 multipathd: sdc: readsector0 checker reports path is down 
Jul 17 09:27:59 rhel5 multipathd: sdd: readsector0 checker reports path is down 
Jul 17 09:27:59 rhel5 multipathd: sde: readsector0 checker reports path is down 
Jul 17 09:28:04 rhel5 kernel: lpfc 0000:04:00.0: 0:1305 Link Down Event x6 received Data: x6 x20 x0
Jul 17 09:28:04 rhel5 multipathd: sdb: readsector0 checker reports path is down 
Jul 17 09:28:04 rhel5 kernel: lpfc 0000:04:00.0: 0:1303 Link Up Event x7 received Data: x7 x1 x4 x1
Jul 17 09:28:07 rhel5 kernel: lpfc 0000:04:00.0: 0:1305 Link Down Event x8 received Data: x8 x20 x0
Jul 17 09:28:08 rhel5 kernel: lpfc 0000:04:00.0: 0:1303 Link Up Event x9 received Data: x9 x1 x8 x1
Jul 17 09:28:08 rhel5 kernel: lpfc 0000:04:00.0: 0:1305 Link Down Event xa received Data: xa x20 x0
Jul 17 09:28:09 rhel5 multipathd: sdc: readsector0 checker reports path is down 
Jul 17 09:28:09 rhel5 multipathd: sdd: readsector0 checker reports path is down 
Jul 17 09:28:09 rhel5 multipathd: sde: readsector0 checker reports path is down 
Jul 17 09:28:09 rhel5 multipathd: sdb: readsector0 checker reports path is down 
Jul 17 09:28:09 rhel5 multipathd: sdc: readsector0 checker reports path is down 
Jul 17 09:28:09 rhel5 multipathd: sdd: readsector0 checker reports path is down 
Jul 17 09:28:09 rhel5 multipathd: sde: readsector0 checker reports path is down 
Jul 17 09:28:10 rhel5 kernel: lpfc 0000:04:00.0: 0:1303 Link Up Event xb received Data: xb x1 x4 x1
Jul 17 09:28:14 rhel5 multipathd: sdb: readsector0 checker reports path is down 
Jul 17 09:28:19 rhel5 multipathd: sdc: readsector0 checker reports path is down 
Jul 17 09:28:19 rhel5 multipathd: sdd: readsector0 checker reports path is down 
Jul 17 09:28:19 rhel5 multipathd: sde: readsector0 checker reports path is down 
Jul 17 09:28:19 rhel5 multipathd: sdb: readsector0 checker reports path is down 
Jul 17 09:28:19 rhel5 multipathd: sdc: readsector0 checker reports path is down 
Jul 17 09:28:19 rhel5 multipathd: sdd: readsector0 checker reports path is down 
Jul 17 09:28:19 rhel5 multipathd: sde: readsector0 checker reports path is down 
Jul 17 09:28:24 rhel5 multipathd: sdb: readsector0 checker reports path is down 
Jul 17 09:28:24 rhel5 multipathd: sdc: readsector0 checker reports path is down 
Jul 17 09:28:24 rhel5 multipathd: sdd: readsector0 checker reports path is down 
Jul 17 09:28:24 rhel5 multipathd: sde: readsector0 checker reports path is down 
Jul 17 09:28:24 rhel5 multipathd: sdh: readsector0 checker reports path is down 
Jul 17 09:28:24 rhel5 multipathd: checker failed path 8:112 in map 1HITACHI_D60052410003 
Jul 17 09:28:24 rhel5 multipathd: 1HITACHI_D60052410003: remaining active paths: 0 
Jul 17 09:28:24 rhel5 kernel: device-mapper: multipath: Failing path 8:112.
Jul 17 09:28:24 rhel5 kernel: device-mapper: multipath: Failing path 8:128.
Jul 17 09:28:24 rhel5 multipathd: sdi: readsector0 checker reports path is down 
Jul 17 09:28:24 rhel5 multipathd: checker failed path 8:128 in map 1HITACHI_D60052410004 
Jul 17 09:28:24 rhel5 multipathd: 1HITACHI_D60052410004: remaining active paths: 0 
Jul 17 09:28:24 rhel5 kernel: lpfc 0000:04:00.0: 0:1305 Link Down Event xc received Data: xc x20 x0
Jul 17 09:28:29 rhel5 multipathd: sdb: readsector0 checker reports path is down 
Jul 17 09:28:29 rhel5 multipathd: sdc: readsector0 checker reports path is down 
Jul 17 09:28:29 rhel5 multipathd: sdd: readsector0 checker reports path is down 
Jul 17 09:28:29 rhel5 multipathd: sde: readsector0 checker reports path is down 
Jul 17 09:28:29 rhel5 multipathd: sdh: readsector0 checker reports path is up 
Jul 17 09:28:29 rhel5 multipathd: 8:112: reinstated 
Jul 17 09:28:29 rhel5 multipathd: 1HITACHI_D60052410003: remaining active paths: 1 
Jul 17 09:28:29 rhel5 multipathd: sdi: readsector0 checker reports path is up 
Jul 17 09:28:29 rhel5 multipathd: 8:128: reinstated 
Jul 17 09:28:29 rhel5 multipathd: 1HITACHI_D60052410004: remaining active paths: 1 
Jul 17 09:28:34 rhel5 multipathd: sdb: readsector0 checker reports path is down 
Jul 17 09:28:39 rhel5 multipathd: sdc: readsector0 checker reports path is down 
Jul 17 09:28:39 rhel5 multipathd: sdd: readsector0 checker reports path is down 
Jul 17 09:28:39 rhel5 multipathd: sde: readsector0 checker reports path is down 
Jul 17 09:28:39 rhel5 multipathd: sdb: readsector0 checker reports path is down 
Jul 17 09:28:39 rhel5 multipathd: sdc: readsector0 checker reports path is down 
Jul 17 09:28:39 rhel5 multipathd: sdd: readsector0 checker reports path is down 
Jul 17 09:28:39 rhel5 multipathd: sde: readsector0 checker reports path is down 
Jul 17 09:28:44 rhel5 multipathd: sdb: readsector0 checker reports path is down 
Jul 17 09:28:44 rhel5 multipathd: sdc: readsector0 checker reports path is down 
Jul 17 09:28:44 rhel5 multipathd: sdd: readsector0 checker reports path is down 
Jul 17 09:28:44 rhel5 multipathd: sde: readsector0 checker reports path is down 
Jul 17 09:28:49 rhel5 multipathd: sdb: readsector0 checker reports path is down 
Jul 17 09:28:49 rhel5 multipathd: sdc: readsector0 checker reports path is down 
Jul 17 09:28:49 rhel5 multipathd: sdd: readsector0 checker reports path is down 
Jul 17 09:28:49 rhel5 multipathd: sde: readsector0 checker reports path is down 
Jul 17 09:28:54 rhel5 multipathd: sdb: readsector0 checker reports path is down 
Jul 17 09:28:54 rhel5 multipathd: sdc: readsector0 checker reports path is down 
Jul 17 09:28:54 rhel5 multipathd: sdd: readsector0 checker reports path is down 
Jul 17 09:28:54 rhel5 multipathd: sde: readsector0 checker reports path is down 
Jul 17 09:28:59 rhel5 multipathd: sdb: readsector0 checker reports path is down 
Jul 17 09:28:59 rhel5 multipathd: sdc: readsector0 checker reports path is down 
Jul 17 09:28:59 rhel5 multipathd: sdd: readsector0 checker reports path is down 
Jul 17 09:28:59 rhel5 multipathd: sde: readsector0 checker reports path is down 
Jul 17 09:29:04 rhel5 multipathd: sdb: readsector0 checker reports path is down 
Jul 17 09:29:04 rhel5 multipathd: sdc: readsector0 checker reports path is down 
Jul 17 09:29:04 rhel5 multipathd: sdd: readsector0 checker reports path is down 
Jul 17 09:29:04 rhel5 multipathd: sde: readsector0 checker reports path is down 
Jul 17 09:29:09 rhel5 kernel: lpfc 0000:04:00.0: 0:1303 Link Up Event xd received Data: xd x1 x8 x2
Jul 17 09:29:09 rhel5 multipathd: sdb: readsector0 checker reports path is down 
Jul 17 09:29:10 rhel5 multipathd: sdc: readsector0 checker reports path is down 
Jul 17 09:29:10 rhel5 multipathd: sdd: readsector0 checker reports path is down 
Jul 17 09:29:10 rhel5 multipathd: sde: readsector0 checker reports path is down 
Jul 17 09:29:15 rhel5 multipathd: sdb: readsector0 checker reports path is up 
Jul 17 09:29:15 rhel5 multipathd: 8:16: reinstated 
Jul 17 09:29:15 rhel5 multipathd: 1HITACHI_D60052410001: remaining active paths: 2 
Jul 17 09:29:15 rhel5 multipathd: sdc: readsector0 checker reports path is up 
Jul 17 09:29:15 rhel5 multipathd: 8:32: reinstated 
Jul 17 09:29:15 rhel5 multipathd: 1HITACHI_D60052410002: remaining active paths: 2 
Jul 17 09:29:15 rhel5 multipathd: sdd: readsector0 checker reports path is up 
Jul 17 09:29:15 rhel5 multipathd: 8:48: reinstated 
Jul 17 09:29:15 rhel5 multipathd: 1HITACHI_D60052410003: remaining active paths: 2 
Jul 17 09:29:15 rhel5 multipathd: sde: readsector0 checker reports path is up 
Jul 17 09:29:15 rhel5 multipathd: 8:64: reinstated 
Jul 17 09:29:15 rhel5 multipathd: 1HITACHI_D60052410004: remaining active paths: 2 
Jul 17 09:32:39 rhel5 kernel: lpfc 0000:05:00.0: 1:1305 Link Down Event x2 received Data: x2 x20 x0
Jul 17 09:32:41 rhel5 kernel: lpfc 0000:05:00.0: 1:1303 Link Up Event x3 received Data: x3 x1 x4 x1
Jul 17 09:33:09 rhel5 kernel:  rport-2:0-0: blocked FC remote port time out: saving binding
Jul 17 09:33:09 rhel5 kernel: sd 2:0:0:1: SCSI error: return code = 0x00010000
Jul 17 09:33:09 rhel5 kernel: end_request: I/O error, dev sdf, sector 65184640
Jul 17 09:33:09 rhel5 kernel: lpfc 0000:05:00.0: 1:0203 Devloss timeout on WWPN 50:6:e:80:0:43:b8:93 NPort xe2 Data: x8 x7 x1
Jul 17 09:33:09 rhel5 kernel: sd 2:0:0:1: SCSI error: return code = 0x00010000
Jul 17 09:33:09 rhel5 kernel: end_request: I/O error, dev sdf, sector 65920
Jul 17 09:33:09 rhel5 kernel: sd 2:0:0:1: SCSI error: return code = 0x00010000
Jul 17 09:33:09 rhel5 multipathd: sdf: readsector0 checker reports path is down 
Jul 17 09:33:09 rhel5 kernel: end_request: I/O error, dev sdf, sector 21410968
Jul 17 09:33:09 rhel5 kernel: sd 2:0:0:1: SCSI error: return code = 0x00010000
Jul 17 09:33:09 rhel5 kernel: end_request: I/O error, dev sdf, sector 18297136
Jul 17 09:33:09 rhel5 multipathd: checker failed path 8:80 in map 1HITACHI_D60052410001 
Jul 17 09:33:09 rhel5 kernel: Buffer I/O error on device dm-0, logical block 4574198
Jul 17 09:33:09 rhel5 multipathd: 1HITACHI_D60052410001: remaining active paths: 1 
Jul 17 09:33:09 rhel5 kernel: lost page write due to I/O error on dm-0
Jul 17 09:33:10 rhel5 kernel: sd 2:0:0:1: SCSI error: return code = 0x00010000
Jul 17 09:33:10 rhel5 kernel: end_request: I/O error, dev sdf, sector 18300736
Jul 17 09:33:10 rhel5 kernel: Buffer I/O error on device dm-0, logical block 4575096
Jul 17 09:33:10 rhel5 kernel: lost page write due to I/O error on dm-0
Jul 17 09:33:10 rhel5 kernel: Buffer I/O error on device dm-0, logical block 4575097
Jul 17 09:33:10 rhel5 kernel: lost page write due to I/O error on dm-0
Jul 17 09:33:10 rhel5 kernel: Buffer I/O error on device dm-0, logical block 4575098
Jul 17 09:33:10 rhel5 kernel: lost page write due to I/O error on dm-0
Jul 17 09:33:10 rhel5 kernel: sd 2:0:0:1: SCSI error: return code = 0x00010000
Jul 17 09:33:10 rhel5 kernel: end_request: I/O error, dev sdf, sector 18300928
Jul 17 09:33:10 rhel5 kernel: Buffer I/O error on device dm-0, logical block 4575152
Jul 17 09:33:10 rhel5 kernel: lost page write due to I/O error on dm-0
Jul 17 09:33:10 rhel5 kernel: Buffer I/O error on device dm-0, logical block 4575153
Jul 17 09:33:10 rhel5 kernel: lost page write due to I/O error on dm-0
Jul 17 09:33:10 rhel5 kernel: device-mapper: multipath: Failing path 8:80.
Jul 17 09:33:10 rhel5 kernel: sd 2:0:0:1: SCSI error: return code = 0x00010000
Jul 17 09:33:10 rhel5 kernel: end_request: I/O error, dev sdf, sector 18301184
Jul 17 09:33:10 rhel5 kernel: Buffer I/O error on device dm-0, logical block 4575216
Jul 17 09:33:10 rhel5 kernel: lost page write due to I/O error on dm-0
Jul 17 09:33:10 rhel5 kernel: Buffer I/O error on device dm-0, logical block 4575217
Jul 17 09:33:10 rhel5 kernel: lost page write due to I/O error on dm-0
Jul 17 09:33:10 rhel5 kernel: Buffer I/O error on device dm-0, logical block 4575218
Jul 17 09:33:10 rhel5 kernel: lost page write due to I/O error on dm-0
Jul 17 09:33:10 rhel5 kernel: Buffer I/O error on device dm-0, logical block 4575219
Jul 17 09:33:10 rhel5 kernel: lost page write due to I/O error on dm-0
Jul 17 09:33:10 rhel5 kernel: sd 2:0:0:2: SCSI error: return code = 0x00010000
Jul 17 09:33:10 rhel5 kernel: end_request: I/O error, dev sdg, sector 66008
Jul 17 09:33:10 rhel5 kernel: sd 2:0:0:2: SCSI error: return code = 0x00010000
Jul 17 09:33:10 rhel5 kernel: end_request: I/O error, dev sdg, sector 18300672
Jul 17 09:33:10 rhel5 kernel: sd 2:0:0:2: SCSI error: return code = 0x00010000
Jul 17 09:33:10 rhel5 kernel: end_request: I/O error, dev sdg, sector 18300824
Jul 17 09:33:10 rhel5 kernel: sd 2:0:0:2: SCSI error: return code = 0x00010000
Jul 17 09:33:10 rhel5 kernel: end_request: I/O error, dev sdg, sector 18300896
Jul 17 09:33:10 rhel5 kernel: sd 2:0:0:1: SCSI error: return code = 0x00010000
Jul 17 09:33:10 rhel5 kernel: end_request: I/O error, dev sdf, sector 66008
Jul 17 09:33:10 rhel5 kernel: sd 2:0:0:2: SCSI error: return code = 0x00010000
Jul 17 09:33:10 rhel5 kernel: end_request: I/O error, dev sdg, sector 18300936
Jul 17 09:33:10 rhel5 kernel: Aborting journal on device dm-0.
Jul 17 09:33:10 rhel5 kernel: sd 2:0:0:2: SCSI error: return code = 0x00010000
Jul 17 09:33:10 rhel5 kernel: end_request: I/O error, dev sdg, sector 18301184
Jul 17 09:33:10 rhel5 kernel: sd 2:0:0:2: SCSI error: return code = 0x00010000
Jul 17 09:33:10 rhel5 kernel: end_request: I/O error, dev sdg, sector 18301360
Jul 17 09:33:10 rhel5 kernel: sd 2:0:0:2: SCSI error: return code = 0x00010000
Jul 17 09:33:10 rhel5 kernel: end_request: I/O error, dev sdg, sector 18301520
Jul 17 09:33:10 rhel5 kernel: sd 2:0:0:2: SCSI error: return code = 0x00010000
Jul 17 09:33:10 rhel5 kernel: end_request: I/O error, dev sdg, sector 18334080
Jul 17 09:33:10 rhel5 kernel: sd 2:0:0:4: SCSI error: return code = 0x00010000
Jul 17 09:33:10 rhel5 kernel: end_request: I/O error, dev sdi, sector 19444000
Jul 17 09:33:10 rhel5 kernel: sd 2:0:0:2: SCSI error: return code = 0x00010000
Jul 17 09:33:10 rhel5 kernel: end_request: I/O error, dev sdg, sector 21411072
Jul 17 09:33:10 rhel5 kernel: sd 2:0:0:2: SCSI error: return code = 0x00010000
Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdg, sector 65184640
Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:4: SCSI error: return code = 0x00010000
Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdi, sector 19449856
Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:3: SCSI error: return code = 0x00010000
Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdh, sector 19450272
Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:1: SCSI error: return code = 0x00010000
Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdf, sector 65184592
Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:2: SCSI error: return code = 0x00010000
Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdg, sector 65184512
Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:4: SCSI error: return code = 0x00010000
Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdi, sector 19450368
Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:3: SCSI error: return code = 0x00010000
Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdh, sector 19449760
Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:1: SCSI error: return code = 0x00010000
Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdf, sector 65184464
Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:2: SCSI error: return code = 0x00010000
Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdg, sector 21411096
Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:2: SCSI error: return code = 0x00010000
Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdg, sector 21411096
Jul 17 09:33:11 rhel5 kernel: device-mapper: multipath: Failing path 8:96.
Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:2: SCSI error: return code = 0x00010000
Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdg, sector 21411096
Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:2: SCSI error: return code = 0x00010000
Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdg, sector 21411096
Jul 17 09:33:11 rhel5 kernel: device-mapper: multipath: Failing path 8:112.
Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:2: SCSI error: return code = 0x00010000
Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdg, sector 21411096
Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:2: SCSI error: return code = 0x00010000
Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdg, sector 21411096
Jul 17 09:33:11 rhel5 kernel: device-mapper: multipath: Failing path 8:128.
Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:2: SCSI error: return code = 0x00010000
Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdg, sector 21411096
Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:2: SCSI error: return code = 0x00010000
Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdg, sector 21411096
Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:2: SCSI error: return code = 0x00010000
Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdg, sector 21411096
Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:2: SCSI error: return code = 0x00010000
Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdg, sector 21411096
Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:2: SCSI error: return code = 0x00010000
Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdg, sector 21411096
Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:2: SCSI error: return code = 0x00010000
Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdg, sector 21411096
Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:2: SCSI error: return code = 0x00010000
Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdg, sector 21411096
Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:2: SCSI error: return code = 0x00010000
Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdg, sector 21411096
Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:2: SCSI error: return code = 0x00010000
Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdg, sector 21411096
Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:2: SCSI error: return code = 0x00010000
Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdg, sector 21411096
Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:2: SCSI error: return code = 0x00010000
Jul 17 09:33:11 rhel5 kernel: end_request: I/O error, dev sdg, sector 21411096
Jul 17 09:33:11 rhel5 kernel: sd 2:0:0:2: SCSI error: return code = 0x00010000
Jul 17 09:33:12 rhel5 kernel: end_request: I/O error, dev sdg, sector 21411096
Jul 17 09:33:12 rhel5 kernel: sd 2:0:0:2: SCSI error: return code = 0x00010000
Jul 17 09:33:12 rhel5 kernel: end_request: I/O error, dev sdg, sector 21411096
Jul 17 09:33:12 rhel5 kernel: sd 2:0:0:2: SCSI error: return code = 0x00010000
Jul 17 09:33:12 rhel5 kernel: end_request: I/O error, dev sdg, sector 21411096
Jul 17 09:33:12 rhel5 kernel: sd 2:0:0:2: SCSI error: return code = 0x00010000
Jul 17 09:33:12 rhel5 kernel: end_request: I/O error, dev sdg, sector 21411096
Jul 17 09:33:12 rhel5 kernel: sd 2:0:0:2: SCSI error: return code = 0x00010000
Jul 17 09:33:12 rhel5 kernel: end_request: I/O error, dev sdg, sector 21411096
Jul 17 09:33:12 rhel5 kernel: sd 2:0:0:2: SCSI error: return code = 0x00010000
Jul 17 09:33:12 rhel5 kernel: end_request: I/O error, dev sdg, sector 21411096
Jul 17 09:33:12 rhel5 kernel: sd 2:0:0:2: SCSI error: return code = 0x00010000
Jul 17 09:33:12 rhel5 kernel: end_request: I/O error, dev sdg, sector 21411096
Jul 17 09:33:12 rhel5 kernel: sd 2:0:0:2: SCSI error: return code = 0x00010000
Jul 17 09:33:12 rhel5 kernel: end_request: I/O error, dev sdg, sector 21411096
Jul 17 09:33:12 rhel5 kernel: sd 2:0:0:2: SCSI error: return code = 0x00010000
Jul 17 09:33:12 rhel5 kernel: end_request: I/O error, dev sdg, sector 21411096
Jul 17 09:33:12 rhel5 kernel: sd 2:0:0:2: SCSI error: return code = 0x00010000
Jul 17 09:33:12 rhel5 kernel: end_request: I/O error, dev sdg, sector 21411096
Jul 17 09:33:12 rhel5 kernel: sd 2:0:0:2: SCSI error: return code = 0x00010000
Jul 17 09:33:12 rhel5 kernel: end_request: I/O error, dev sdg, sector 21411096
Jul 17 09:33:12 rhel5 kernel: sd 2:0:0:2: SCSI error: return code = 0x00010000
Jul 17 09:33:12 rhel5 kernel: end_request: I/O error, dev sdg, sector 21411096
Jul 17 09:33:12 rhel5 kernel: sd 2:0:0:2: SCSI error: return code = 0x00010000
Jul 17 09:33:12 rhel5 kernel: end_request: I/O error, dev sdg, sector 21411096
Jul 17 09:33:12 rhel5 kernel: sd 2:0:0:2: SCSI error: return code = 0x00010000
Jul 17 09:33:12 rhel5 kernel: end_request: I/O error, dev sdg, sector 21411096
Jul 17 09:33:12 rhel5 kernel: ext3_abort called.
Jul 17 09:33:12 rhel5 kernel: EXT3-fs error (device dm-0): ext3_journal_start_sb: Detected aborted journal
Jul 17 09:33:12 rhel5 kernel: Remounting filesystem read-only

The scsi and i/o errors repeat until the machine was rebooted when all was 
fine again.

Here is the contents of /etc/multipath.conf:

# This is an example configuration file for device mapper multipath.
# For a complete list of the default configuration values, see
# /usr/share/doc/device-mapper-multipath-0.4.5/multipath.conf.defaults
# For a list of configuration options with descriptions, see
# /usr/share/doc/device-mapper-multipath-0.4.5/multipath.conf.annotated


# Blacklist all devices by default. Remove this to enable multipathing
# on the default devices. 
blacklist {
         devnode "sda"
}

## By default, devices with vendor = "IBM" and product = "S/390.*" are
## blacklisted. To enable mulitpathing on these devies, uncomment the
## following lines.
#blacklist_exceptions {
#	device {
#		vendor	"IBM"
#		product	"S/390.*"
#	}
#}

## Use user friendly names, instead of using WWIDs as names.
defaults {
 	#user_friendly_names yes
}

devices {
 	device {
 		vendor                  "HITACHI"
 		product                 "DF.*"
 		path_grouping_policy    group_by_prio
 		prio_callout            "/sbin/pp_hds_modular %d"
 		path_checker            readsector0
 		getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
 		failback                immediate
 		}
 	}



Any help is appreciated.

Thanks,

Trevor

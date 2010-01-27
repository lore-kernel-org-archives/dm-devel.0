From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: Trouble with StorageTek 2530 (SAS) and RDAC
Date: Tue, 26 Jan 2010 18:23:18 -0800
Message-ID: <1264558998.27583.131.camel@chandra-ubuntu>
References: <4B5F6825.6070906@srce.hr>
Reply-To: sekharan@us.ibm.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4B5F6825.6070906@srce.hr>
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


On Tue, 2010-01-26 at 23:09 +0100, Jakov Sosic wrote:
> Hi!
> 
> I have contacted list almost a half a year ago about this storage. I
> still haven't figured out how to set it up... I have 3 nodes connected
> to it, and 2 volumes shared across all 3 nodes. I'm using CentOS 5.4.
> Here is my multipath.conf:
> 
> 
> defaults {
> 	udev_dir		/dev
> 	polling_interval 	10
> 	selector		"round-robin 0"
> 	path_grouping_policy	multibus
> 	getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
> 	prio_callout		/bin/true
> 	path_checker		readsector0
> 	rr_min_io		100
> 	max_fds			8192
> 	rr_weight		priorities
> 	failback		immediate
> 	no_path_retry		fail
> }
> blacklist {
> 	devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
> 	devnode "^hd[a-z]"
> 	devnode "^sda"
> }
> multipaths {
> 	multipath {
> 		wwid			3600a0b80003abc5c000011504b52f919
> 		alias			sas-qd
> 	}
> 	multipath {
> 		wwid			3600a0b80002fcd1800001a374b52fa1e
> 		alias			sas-data
> 	}
> }
> 
> devices {
> 	device {
> 		vendor			"SUN"
> 		product			"LCSM100_S"
> 		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
> 		prio_callout            "/sbin/mpath_prio_rdac /dev/%n"
> 		features		"0"
> 		hardware_handler	"1 rdac"
> 		path_grouping_policy	group_by_prio
> 		failback		immediate
> 		path_checker		rdac
> 		rr_weight		uniform
> 		no_path_retry		300
> 		rr_min_io		1000
> 	}
> }
> 
> 
> And here is multipath -ll:
> # multipath -ll sas-data
> sas-data (3600a0b80002fcd1800001a374b52fa1e) dm-1 SUN,LCSM100_S
> [size=2.7T][features=1 queue_if_no_path][hwhandler=1 rdac][rw]
> \_ round-robin 0 [prio=100][enabled]
>  \_ 1:0:3:1  sde 8:64  [active][ready]
> \_ round-robin 0 [prio=0][enabled]
>  \_ 1:0:0:1  sdc 8:32  [active][ghost]
> 
> 
> On that volume, I have set up CLVM, and I have created one logical
> clustered volume. If I try to format it with ext3, here is what I finish
> with:
> 
> 
> Jan 26 23:00:43 node01 kernel: mptbase: ioc1: LogInfo(0x31140000):
> Originator={PL}, Code={IO Executed}, SubCode(0x0000)
> Jan 26 23:00:43 node01 kernel: sd 1:0:1:1: SCSI error: return code =
> 0x00010000
> Jan 26 23:00:43 node01 kernel: end_request: I/O error, dev sde, sector
> 1360267648

Is the message got from the same node as where you got the multipath -ll
o/p from ?

From these messages it looks like sde is 1:0:1:1, but from the multipath
-ll o/p it looks like it is 1:0:3:1.

> Jan 26 23:00:43 node01 kernel: device-mapper: multipath: Failing path 8:64.
> Jan 26 23:00:43 node01 kernel: sd 1:0:1:1: SCSI error: return code =
> 0x00010000

This return code means that the host is returning DID_NO_CONNECT. which
means that the host is not able to connect to the end point.

I would suggest you to go step-by-step.
1. Try to access both the paths of a lun (in all nodes).
   one should succeed and other should fail.
2. Try to access the multipath device and see if all is good.
3. Create a LVM on a single node (not clusters) and see if that works.
4. Create a clustered LVM on top of all the Active (non-ghost) sd 
   devices and see if it works.

When you send the results include o/p "dmsetup table" and "dmsetup ls"


> Jan 26 23:00:43 node01 kernel: end_request: I/O error, dev sde, sector
> 1360269696
> Jan 26 23:00:43 node01 kernel: sd 1:0:1:1: SCSI error: return code =
> 0x00010000
> Jan 26 23:00:43 node01 kernel: end_request: I/O error, dev sde, sector
> 1360527744
> Jan 26 23:00:43 node01 kernel: sd 1:0:1:1: SCSI error: return code =
> 0x00010000
> Jan 26 23:00:43 node01 kernel: end_request: I/O error, dev sde, sector
> 1360528768
> Jan 26 23:00:43 node01 kernel: sd 1:0:1:1: SCSI error: return code =
> 0x00010000
> Jan 26 23:00:43 node01 kernel: end_request: I/O error, dev sde, sector
> 1360529792
> Jan 26 23:00:43 node01 kernel: sd 1:0:1:1: SCSI error: return code =
> 0x00010000
> Jan 26 23:00:43 node01 multipathd: 8:64: mark as failed
> Jan 26 23:00:43 node01 kernel: end_request: I/O error, dev sde, sector
> 1360530816
> Jan 26 23:00:44 node01 multipathd: sas-data: remaining active paths: 1
> Jan 26 23:00:44 node01 kernel: sd 1:0:1:1: SCSI error: return code =
> 0x00010000
> Jan 26 23:00:44 node01 multipathd: dm-1: add map (uevent)
> Jan 26 23:00:44 node01 kernel: end_request: I/O error, dev sde, sector
> 1360531840
> Jan 26 23:00:44 node01 multipathd: dm-1: devmap already registered
> Jan 26 23:00:44 node01 kernel: sd 1:0:1:1: SCSI error: return code =
> 0x00010000
> Jan 26 23:00:44 node01 multipathd: sdd: remove path (uevent)
> Jan 26 23:00:44 node01 kernel: end_request: I/O error, dev sde, sector
> 1360789888
> Jan 26 23:00:44 node01 kernel: sd 1:0:1:1: SCSI error: return code =
> 0x00010000
> Jan 26 23:00:44 node01 kernel: end_request: I/O error, dev sde, sector
> 1360790912
> .
> .
> .
> lot of similar messages
> .
> .
> .
> 
> Jan 26 23:00:50 node01 kernel: sd 1:0:1:1: SCSI error: return code =
> 0x00010000
> Jan 26 23:00:50 node01 kernel: end_request: I/O error, dev sde, sector
> 1358694784
> Jan 26 23:00:50 node01 kernel: mptsas: ioc1: removing ssp device,
> channel 0, id 4, phy 7
> Jan 26 23:00:50 node01 kernel: scsi 1:0:1:0: rdac Dettached
> Jan 26 23:00:50 node01 kernel: scsi 1:0:1:1: rdac Dettached
> Jan 26 23:00:50 node01 kernel: sd 1:0:0:1: queueing MODE_SELECT command.
> Jan 26 23:00:50 node01 kernel: device-mapper: multipath: Using scsi_dh
> module scsi_dh_rdac for failover/failback and device management.
> Jan 26 23:00:51 node01 kernel: sd 1:0:0:0: rdac Dettached
> Jan 26 23:00:51 node01 multipathd: sas-qd: load table [0 204800
> multipath 0 1 rdac 1 1 round-robin 0 1 1 8:16 1000]
> Jan 26 23:00:51 node01 multipathd: sde: remove path (uevent)
> Jan 26 23:00:51 node01 kernel: device-mapper: multipath: Using scsi_dh
> module scsi_dh_rdac for failover/failback and device management.
> Jan 26 23:00:52 node01 kernel: sd 1:0:0:1: rdac Dettached
> Jan 26 23:00:52 node01 multipathd: sas-data: load table [0 5855165440
> multipath 0 1 rdac 1 1 round-robin 0 1 1 8:32 1000]
> Jan 26 23:00:52 node01 multipathd: dm-0: add map (uevent)
> Jan 26 23:00:52 node01 multipathd: dm-0: devmap already registered
> Jan 26 23:00:52 node01 multipathd: dm-1: add map (uevent)
> Jan 26 23:00:52 node01 multipathd: dm-1: devmap already registered
> Jan 26 23:00:52 node01 kernel: device-mapper: multipath: Cannot failover
> device because scsi_dh_rdac was not loaded.
> 
> 
> Any ideas?
> 
> 

From: Jakov Sosic <jakov.sosic@srce.hr>
Subject: Re: Trouble with StorageTek 2530 (SAS) and RDAC
Date: Fri, 29 Jan 2010 01:24:09 +0100
Message-ID: <4B622AA9.3060502@srce.hr>
References: <4B5F6825.6070906@srce.hr>
	<1264558998.27583.131.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1264558998.27583.131.camel@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@us.ibm.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 01/27/2010 03:23 AM, Chandra Seetharaman wrote:

> This return code means that the host is returning DID_NO_CONNECT. which
> means that the host is not able to connect to the end point.
> 
> I would suggest you to go step-by-step.
> 1. Try to access both the paths of a lun (in all nodes).
>    one should succeed and other should fail.
> 2. Try to access the multipath device and see if all is good.
> 3. Create a LVM on a single node (not clusters) and see if that works.
> 4. Create a clustered LVM on top of all the Active (non-ghost) sd 
>    devices and see if it works.
> 
> When you send the results include o/p "dmsetup table" and "dmsetup ls"


Thank you! I've solved the multipath problems with new kernel I built
with my device added to scsi_dh_rdac.c! I've added the "SUN"
"LCMS100_S", just as few months back Charlie Brady suggested to me! That
was the solution for the multipath problems.

Now multipath is able to do it's own part. But, after the failover,
secondary path works for just a bit, and then hangs... When I disconnect
active SAS cable from the server, multipath and scsi_dh_rdac do their
thing, but if I have active read/write processes (like copying one file
over on the volume mounted from storage to the exact same partition for
example), everything hangs few seconds after multipath failover.



Very strange behaviour indeed. This is what happens now:

Jan 28 20:26:12 node01 kernel: mptbase: ioc1: LogInfo(0x31140000):
Originator={PL}, Code={IO Executed}, SubCode(0x0000)
Jan 28 20:26:12 node01 kernel: mptbase: ioc1: LogInfo(0x31140000):
Originator={PL}, Code={IO Executed}, SubCode(0x0000)
Jan 28 20:26:12 node01 kernel: sd 1:0:0:1: SCSI error: return code =
0x00010000
Jan 28 20:26:12 node01 kernel: end_request: I/O error, dev sdc, sector
7012168
Jan 28 20:26:12 node01 kernel: device-mapper: multipath: Failing path 8:32.
Jan 28 20:26:12 node01 kernel: sd 1:0:0:1: SCSI error: return code =
0x00010000
Jan 28 20:26:12 node01 kernel: end_request: I/O error, dev sdc, sector
7012424

So, multipath activated... Lots of similar scsi I/O error messages
follow, and in between I see this:

Jan 28 20:26:12 node01 multipathd: dm-1: add map (uevent)
Jan 28 20:26:12 node01 multipathd: dm-1: devmap already registered
Jan 28 20:26:12 node01 multipathd: 8:32: mark as failed
Jan 28 20:26:12 node01 multipathd: sas-data: remaining active paths: 1
Jan 28 20:26:12 node01 multipathd: sdb: remove path (uevent)


and then

Jan 28 20:26:13 node01 kernel: mptbase: ioc1: LogInfo(0x31140000):
Originator={PL}, Code={IO Executed}, SubCode(0x0000)
Jan 28 20:26:13 node01 last message repeated 61 times



Jan 28 20:26:18 node01 multipathd: sas-qd: load table [0 204800
multipath 0 1 rdac 1 1 round-robin 0 1 1 8:80 3000]
Jan 28 20:26:18 node01 multipathd: sdc: remove path (uevent)
Jan 28 20:26:18 node01 multipathd: sas-data: load table [0 3774873600
multipath 0 1 rdac 1 1 round-robin 0 1 1 8:96 1000]
Jan 28 20:26:18 node01 multipathd: sdd: remove path (uevent)
Jan 28 20:26:18 node01 kernel: mptsas: ioc1: removing ssp device,
channel 0, id 1, phy 3
Jan 28 20:26:18 node01 multipathd: sas-os: load table [0 2080291840
multipath 0 1 rdac 1 1 round-robin 0 1 1 8:112 3000]
Jan 28 20:26:18 node01 multipathd: sde: remove path (uevent)
Jan 28 20:26:18 node01 kernel: scsi 1:0:0:0: rdac Dettached
Jan 28 20:26:19 node01 multipathd: sde: spurious uevent, path not in pathvec
Jan 28 20:26:19 node01 kernel: scsi 1:0:0:1: rdac Dettached
Jan 28 20:26:19 node01 multipathd: uevent trigger error
Jan 28 20:26:19 node01 kernel: scsi 1:0:0:2: rdac Dettached
Jan 28 20:26:19 node01 multipathd: dm-0: add map (uevent)
Jan 28 20:26:19 node01 kernel: sd 1:0:3:1: queueing MODE_SELECT command.
Jan 28 20:26:19 node01 multipathd: dm-0: devmap already registered
Jan 28 20:26:19 node01 kernel: device-mapper: multipath: Using scsi_dh
module scsi_dh_rdac for failover/failback and device management.
Jan 28 20:26:19 node01 multipathd: dm-1: add map (uevent)
Jan 28 20:26:19 node01 multipathd: dm-1: devmap already registered
Jan 28 20:26:19 node01 multipathd: dm-2: add map (uevent)
Jan 28 20:26:19 node01 kernel: scsi 1:0:0:1: rejecting I/O to dead device
Jan 28 20:26:19 node01 multipathd: dm-2: devmap already registered
Jan 28 20:26:19 node01 kernel: device-mapper: multipath: Using scsi_dh
module scsi_dh_rdac for failover/failback and device management.
Jan 28 20:26:19 node01 kernel: device-mapper: multipath: Using scsi_dh
module scsi_dh_rdac for failover/failback and device management.
Jan 28 20:26:20 node01 multipathd: 8:96: reinstated
Jan 28 20:27:08 node01 multipathd: dm-1: add map (uevent)
Jan 28 20:27:08 node01 multipathd: dm-1: devmap already registered
Jan 28 20:27:08 node01 kernel: mptbase: ioc1: LogInfo(0x31140000):
Originator={PL}, Code={IO Executed}, SubCode(0x0000)
Jan 28 20:27:08 node01 kernel: sd 1:0:3:1: SCSI error: return code =
0x00010000
Jan 28 20:27:08 node01 kernel: end_request: I/O error, dev sdg, sector
29045144
Jan 28 20:27:08 node01 kernel: device-mapper: multipath: Failing path 8:96.
Jan 28 20:27:08 node01 kernel: sd 1:0:3:1: SCSI error: return code =
0x00010000
Jan 28 20:27:08 node01 kernel: end_request: I/O error, dev sdg, sector
29089224
Jan 28 20:27:08 node01 kernel: sd 1:0:3:1: SCSI error: return code =
0x00010000
Jan 28 20:27:08 node01 kernel: end_request: I/O error, dev sdg, sector
29090248
Jan 28 20:27:08 node01 kernel: sd 1:0:3:1: SCSI error: return code =
0x00010000
Jan 28 20:27:08 node01 kernel: end_request: I/O error, dev sdg, sector
29091272
Jan 28 20:27:08 node01 multipathd: 8:96: mark as failed
Jan 28 20:27:08 node01 kernel: sd 1:0:3:1: SCSI error: return code =
0x00010000
Jan 28 20:27:08 node01 multipathd: sas-data: Entering recovery mode:
max_retries=300
Jan 28 20:27:08 node01 kernel: end_request: I/O error, dev sdg, sector
29092296
Jan 28 20:27:08 node01 multipathd: sas-data: remaining active paths: 0
Jan 28 20:27:08 node01 kernel: sd 1:0:3:1: SCSI error: return code =
0x00010000
Jan 28 20:27:08 node01 multipathd: sdf: remove path (uevent)
Jan 28 20:27:08 node01 kernel: end_request: I/O error, dev sdg, sector
29093320
Jan 28 20:27:08 node01 multipathd: sas-qd: stop event checker thread
Jan 28 20:27:08 node01 kernel: sd 1:0:3:1: SCSI error: return code =
0x00010000
Jan 28 20:27:08 node01 multipathd: sdg: remove path (uevent)
Jan 28 20:27:08 node01 kernel: end_request: I/O error, dev sdg, sector
29094344
Jan 28 20:27:08 node01 multipathd: sas-data: map in use
Jan 28 20:27:08 node01 kernel: sd 1:0:3:1: SCSI error: return code =
0x00010000
Jan 28 20:27:08 node01 multipathd: sas-data: can't flush
Jan 28 20:27:08 node01 kernel: end_request: I/O error, dev sdg, sector
29095368
Jan 28 20:27:08 node01 multipathd: sdh: remove path (uevent)
Jan 28 20:27:08 node01 kernel: sd 1:0:3:1: SCSI error: return code =
0x00010000
Jan 28 20:27:08 node01 multipathd: sas-os: stop event checker thread
Jan 28 20:27:08 node01 kernel: end_request: I/O error, dev sdg, sector
29096400
Jan 28 20:27:08 node01 multipathd: sdi: remove path (uevent)
Jan 28 20:27:08 node01 kernel: mptbase: ioc1: LogInfo(0x31140000):
Originator={PL}, Code={IO Executed}, SubCode(0x0000)
Jan 28 20:27:08 node01 multipathd: sdi: spurious uevent, path not in pathvec
Jan 28 20:27:08 node01 kernel: mptbase: ioc1: LogInfo(0x31140000):
Originator={PL}, Code={IO Executed}, SubCode(0x0000)
Jan 28 20:27:08 node01 multipathd: uevent trigger error
Jan 28 20:27:08 node01 kernel: mptbase: ioc1: LogInfo(0x31140000):
Originator={PL}, Code={IO Executed}, SubCode(0x0000)
Jan 28 20:27:08 node01 last message repeated 60 times
Jan 28 20:27:08 node01 kernel: sd 1:0:3:1: SCSI error: return code =
0x00010000
Jan 28 20:27:08 node01 kernel: end_request: I/O error, dev sdg, sector
29097424
Jan 28 20:27:08 node01 kernel: sd 1:0:3:1: SCSI error: return code =
0x00010000


lots of SCSI errors...


Jan 28 20:27:14 node01 kernel: mptsas: ioc1: removing ssp device,
channel 0, id 4, phy 7
Jan 28 20:27:14 node01 kernel: scsi 1:0:3:0: rdac Dettached
Jan 28 20:27:14 node01 kernel: scsi 1:0:3:1: rdac Dettached
Jan 28 20:27:14 node01 kernel: scsi 1:0:3:2: rdac Dettached
Jan 28 20:27:14 node01 kernel: scsi 1:0:3:1: rejecting I/O to dead device
Jan 28 20:28:18 node01 kernel: scsi 1:0:3:1: rejecting I/O to dead device
Jan 28 20:28:18 node01 multipathd: sdg: rdac checker reports path is down
Jan 28 20:29:29 node01 kernel: scsi 1:0:3:1: rejecting I/O to dead device
Jan 28 20:29:29 node01 multipathd: sdg: rdac checker reports path is down
Jan 28 20:30:40 node01 kernel: scsi 1:0:3:1: rejecting I/O to dead device
Jan 28 20:30:40 node01 multipathd: sdg: rdac checker reports path is down


And that's it... all path's lost. Node is still alive, I can access it,
read from it, write to it, but commands like "multipath -ll" just hang
forever... And if I try to restart the server, it hangs too.

I do use CLVM partition, but I'm willing to try going on raw SAS volume,
if you think that would be solution.

And about your suggestions:

1. Try to access both the paths of a lun (in all nodes).
   one should succeed and other should fail.
This works OK. No problems noticed.

2. Try to access the multipath device and see if all is good.
This works too, if I don't disconnect one of the two cables :)

3. Create a LVM on a single node (not clusters) and see if that works.
4. Create a clustered LVM on top of all the Active (non-ghost) sd
   devices and see if it works.
3 & 4 I did not try.


Problem is that after I get errors, I loose all the volumes from the
nodes. It is ok to loose one path, but on secondary path, I get
something like

#   # # # (failed)(failed)

in multipath -ll output... Also, all other volumes are simply lost,
there are no devices present. It seems to me like the controller itself,
or maybe mptsas driver goes berzerk in the process.


Any ideas? :)

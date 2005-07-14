From: Sebastian Kayser <mls@skayser.de>
Subject: multipath with QLA2342, path recovery lacks device nodes
Date: Thu, 14 Jul 2005 19:52:29 +0200
Message-ID: <20050714175229.GA1337@planet.home>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Hi fellow "multipathers",

i am currently testing dm and its multipath target to address failover
for a SAN volume over a dual port fibre channel HBA (QLogic 2342).
Platform is debian sarge with a vanilla 2.6.12 kernel and

device-mapper:      1.01.03
multipath-tools:    0.4.5
udev:               0.056-3
qla2xxx:            8.00.02b5-k

My multipath.conf is empty besides alias definitions.  Map creation via
'mulitpath' works alright. 2 volumes each seen twice because of the dual
HBA.

/var/log/daemon.log:
Jul 14 12:16:51 sarge-fc1 multipathd: sanvol1: event checker started
Jul 14 12:16:51 sarge-fc1 multipathd: add sanvol1 devmap
Jul 14 12:16:51 sarge-fc1 multipathd: sanvol2: event checker started
Jul 14 12:16:51 sarge-fc1 multipathd: add sanvol2 devmap
Jul 14 12:16:52 sarge-fc1 multipathd: 8:0: readsector0 checker reports
path is up
Jul 14 12:16:52 sarge-fc1 multipathd: 8:0: reinstated
Jul 14 12:16:52 sarge-fc1 multipathd: 8:16: readsector0 checker reports
path is up
Jul 14 12:16:52 sarge-fc1 multipathd: 8:16: reinstated
Jul 14 12:16:52 sarge-fc1 multipathd: 8:32: readsector0 checker reports
path is up
Jul 14 12:16:52 sarge-fc1 multipathd: 8:32: reinstated
Jul 14 12:16:52 sarge-fc1 multipathd: 8:48: readsector0 checker reports
path is up
Jul 14 12:16:52 sarge-fc1 multipathd: 8:48: reinstated

Now when i unplug one of the FC connections on the HBA multipathd fails
the unplugged path with a strange error (uevent trigger error) but the
maps get updated and IOs toward the dm-devices keep going.

/var/log/daemon.log:
Jul 14 12:21:57 sarge-fc1 multipathd: 8:32: readsector0 checker reports
path is down
Jul 14 12:21:57 sarge-fc1 multipathd: checker failed path 8:32 in map
sanvol1
Jul 14 12:21:57 sarge-fc1 multipathd: devmap event (2) on sanvol1
Jul 14 12:21:57 sarge-fc1 multipathd: 8:48: readsector0 checker reports
path is down
Jul 14 12:21:57 sarge-fc1 multipathd: checker failed path 8:48 in map
sanvol2
Jul 14 12:21:57 sarge-fc1 multipathd: uevent trigger error
Jul 14 12:21:57 sarge-fc1 multipathd: remove sdc path checker
Jul 14 12:21:57 sarge-fc1 multipathd: uevent trigger error
Jul 14 12:21:57 sarge-fc1 multipathd: 8:32: mark as failed
Jul 14 12:21:57 sarge-fc1 multipathd: devmap event (2) on sanvol2
Jul 14 12:21:57 sarge-fc1 multipathd: remove sdd path checker

/var/log/messages:
Jul 14 12:21:22 sarge-fc1 kernel: qla2300 0000:00:11.1: LOOP DOWN
detected.
Jul 14 12:21:57 sarge-fc1 kernel: device-mapper: dm-multipath: Failing
path 8:32.
Jul 14 12:21:57 sarge-fc1 kernel: Synchronizing SCSI cache for disk sdc:
Jul 14 12:21:57 sarge-fc1 kernel: FAILED
Jul 14 12:21:57 sarge-fc1 kernel:   status = 0, message = 00, host = 1,
driver = 00
Jul 14 12:21:57 sarge-fc1 kernel:   <3> rport-3:0-1: blocked FC remote
port time out: removing target
Jul 14 12:21:57 sarge-fc1 kernel: device-mapper: dm-multipath: Failing
path 8:48.
Jul 14 12:21:57 sarge-fc1 kernel: Synchronizing SCSI cache for disk sdd:
Jul 14 12:21:57 sarge-fc1 kernel: FAILED
Jul 14 12:21:57 sarge-fc1 kernel:   status = 0, message = 00, host = 1,
driver = 00
Jul 14 12:24:13 sarge-fc1 kernel:   <6>qla2300 0000:00:11.1: LIP reset
occured (f7f7).

The thing that keeps me puzzled is that udev removes the physical
devices which represent the failed paths and does not recreate them even
when i replug the FC connection. 

/var/log/daemon.log:
Jul 14 12:21:57 sarge-fc1 udev[3478]: removing device node '/dev/sdc1'
Jul 14 12:21:57 sarge-fc1 udev[3484]: removing device node '/dev/sdd1'
Jul 14 12:21:57 sarge-fc1 udev[3498]: removing device node '/dev/sdc'
Jul 14 12:21:57 sarge-fc1 udev[3524]: removing device node '/dev/sdd'

All i get on replug is

/var/log/messages:
Jul 14 12:24:14 sarge-fc1 kernel: qla2300 0000:00:11.1: LIP occured (f7f7).
Jul 14 12:24:14 sarge-fc1 kernel: qla2300 0000:00:11.1: LIP reset
occured (f7f7).
Jul 14 12:24:14 sarge-fc1 kernel: qla2300 0000:00:11.1: LOOP UP detected
(2 Gbps).

but no logs from udev or multipathd.

multipathd will never be able to reinstate such a failed path without
the underlying physical device, will it?!  Currently my failed paths
keep being marked failed

sanvol2 (1DataCoreVVol02-Cluster)
[size=60 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [active]
  \_ 2:0:1:0 sdb  8:16    [active]
\_ round-robin 0 [enabled]
  \_ #:#:#:#      8:48    [failed]

sanvol1 (1DataCoreVVol01-Cluster)
[size=50 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [active]
  \_ 2:0:0:0 sda  8:0     [active]
\_ round-robin 0 [enabled]
  \_ #:#:#:#      8:32    [failed]

Questions:
1) Is it normal operation for udev to remove devices nodes of failed
paths?
2) What about the uevent trigger errors upon path failure? Can someone
enlighten me on that?
3) If the observed udev operation is alright, how are the physical paths
considered to reappear. Is the driver missing any renotification or kind
of that?!

Hope some of you can put me on the right track. 

Regards,

Sebastian

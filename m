From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: release 0.4.4 ?
Date: Wed, 20 Apr 2005 23:38:39 +0200
Message-ID: <1114033119.24817.161.camel@zezette>
References: <1113731446.24817.4.camel@zezette>
	<1113953571.24817.97.camel@zezette>
	<20050420133116.GW29071@marowsky-bree.de>
	<1114006824.24817.108.camel@zezette>
	<20050420201249.GS29071@marowsky-bree.de>
	<1114029597.24817.138.camel@zezette>
	<20050420205139.GU29071@marowsky-bree.de>
	<1114030896.24817.145.camel@zezette>
	<20050420211000.GW29071@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050420211000.GW29071@marowsky-bree.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On mer, 2005-04-20 at 23:10 +0200, Lars Marowsky-Bree wrote:
> On 2005-04-20T23:01:36, christophe varoqui <christophe.varoqui@free.fr> wrote:
> 
> > Don't forget the binaries caching in a ramfs.
> > If you don't restart the daemon, it may still use a WIP multipath
> > version as a callout.
> > 
> > I'll try and reproduce this at OSDL.
> 
> I've most certainly restarted the daemon. To make sure the kernel didn't
> get stuck somewhere (it's sometimes a bit annoying to be debugging
> user-space and the kernel at the same time ;-) I also rebooted the node,
> which I guess should count as a restart ;-)
> 
I can't reproduce that at OSDL :

* no config file
* IBM 3542 (tur/group_by_serial/no hwh/no feature)
* mp-tools 0.4.4-pre17

==== Phase 1 : a running dd, all is fine ====
[root@cl039 block]# jobs
[1]+  Running                 dd
if=/dev/mapper/3600a0b80000b596a000003113d9c5381 of=/dev/null &  (wd: ~)

[root@cl039 block]# multipath -l 3600a0b80000b596a000003113d9c5381
3600a0b80000b596a000003113d9c5381
[size=33 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [active][first]
  \_ 2:0:3:9 sdan 66:112  [ready ][active]
  \_ 3:0:1:9 sdbh 67:176  [ready ][active]
\_ round-robin 0 [enabled]
  \_ 3:0:3:9 sdcb 68:240  [ready ][active]
  \_ 2:0:1:9 sdt  65:48   [ready ][active]

==== Phase 2 : entropy ====
[root@cl039 device]# echo 1>/sys/block/sdbh/device/delete

Apr 20 14:34:08 cl039 kernel: Synchronizing SCSI cache for disk sdbh:
Apr 20 14:34:08 cl039 kernel: scsi3 (1:9): rejecting I/O to dead device
Apr 20 14:34:08 cl039 multipathd: devmap event (2) on
3600a0b80000b596a000003113d9c5381
Apr 20 14:34:08 cl039 multipathd: mark 67:176 as failed
Apr 20 14:34:10 cl039 kernel: scsi3 (1:9): rejecting I/O to dead device
Apr 20 14:34:10 cl039 multipathd: 67:176: tur checker reports path is up
Apr 20 14:34:11 cl039 multipathd: devmap event (3) on
3600a0b80000b596a000003113d9c5381
Apr 20 14:34:11 cl039 multipathd: mark 67:176 as failed
Apr 20 14:34:16 cl039 kernel: scsi3 (1:9): rejecting I/O to dead device
Apr 20 14:34:16 cl039 multipathd: 67:176: tur checker reports path is up
Apr 20 14:34:17 cl039 multipathd: devmap event (4) on
3600a0b80000b596a000003113d9c5381
Apr 20 14:34:22 cl039 kernel: scsi3 (1:9): rejecting I/O to dead device
Apr 20 14:34:54 cl039 last message repeated 6 times
Apr 20 14:35:52 cl039 last message repeated 11 times

### note the kernel seems to be slow reaping down the device, which
causes some up/down cycles ###

[root@cl039 device]# multipath -l 3600a0b80000b596a000003113d9c5381
3600a0b80000b596a000003113d9c5381
[size=33 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [enabled]
  \_ 2:0:3:9 sdan 66:112  [ready ][active]
  \_ 0:0:0:0      67:176  [undef ][active]
\_ round-robin 0 [active][first]
  \_ 3:0:3:9 sdcb 68:240  [ready ][active]
  \_ 2:0:1:9 sdt  65:48   [ready ][active]

### note multipath go execed by multipathd and choose *not* to reload
the map, leaving the dead device in place, in case it comes up again ###

### also note the active PG switched to the one with most valid path
(all path prio == 1) ###

==== Pahe 3 : restore ====

[root@cl039 root]# echo "scsi add-single-device 3 0 1 9">/proc/scsi/scsi

Apr 20 14:35:56 cl039 kernel:   Vendor: IBM       Model: 3542
Rev: 0401
Apr 20 14:35:57 cl039 kernel:   Type:   Direct-Access
ANSI SCSI revision: 03
Apr 20 14:35:57 cl039 kernel: qla2200 0000:03:05.0: scsi(3:0:1:9):
Enabled tagged queuing, queue depth 16.
Apr 20 14:35:57 cl039 kernel: SCSI device sdcc: 71014400 512-byte hdwr
sectors (36359 MB)
Apr 20 14:35:57 cl039 kernel: SCSI device sdcc: drive cache: write back
Apr 20 14:35:57 cl039 kernel:  sdcc:<3>scsi3 (1:9): rejecting I/O to
dead device
Apr 20 14:35:58 cl039 multipathd: 68:240: tur checker reports path is
down
Apr 20 14:35:58 cl039 multipathd: 65:48: tur checker reports path is
down
Apr 20 14:35:58 cl039 kernel:  unknown partition table
Apr 20 14:35:58 cl039 kernel: Attached scsi disk sdcc at scsi3, channel
0, id 1, lun 9
Apr 20 14:35:58 cl039 kernel: Attached scsi generic sg59 at scsi3,
channel 0, id 1, lun 9,  type 0

Apr 20 14:36:03 cl039 kernel: scsi3 (1:9): rejecting I/O to dead device
Apr 20 14:36:04 cl039 multipathd: 68:240: tur checker reports path is up
Apr 20 14:36:04 cl039 multipathd: devmap event (5) on
3600a0b80000b596a000003113d9c5381
Apr 20 14:36:04 cl039 multipathd: 65:48: tur checker reports path is up

[root@cl039 root]# multipath -l 3600a0b80000b596a000003113d9c5381
3600a0b80000b596a000003113d9c5381
[size=33 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [active][first]
  \_ 2:0:3:9 sdan 66:112  [ready ][active]
  \_ 3:0:1:9 sdcc 69:0    [ready ][active]
\_ round-robin 0 [enabled]
  \_ 3:0:3:9 sdcb 68:240  [ready ][active]
  \_ 2:0:1:9 sdt  65:48   [ready ][active]

### multipath got execed by multipathd, and juged opportune to reload a
map, removing the dead device and adding the new renamed one ###

==== end ====

It all seems sane to me.

Regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>

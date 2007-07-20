From: Hannes Reinecke <hare@suse.de>
Subject: Re: multipath-tools causes path to come back as different
	block device
Date: Fri, 20 Jul 2007 09:24:15 +0200
Message-ID: <46A0631F.4030404@suse.de>
References: <469FEBBB.5040507@csupomona.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <469FEBBB.5040507@csupomona.edu>
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

Brian De Wolf wrote:
> Hello again,
>=20
> I've been testing multipath-tool's rdac capability with a qla2xxx HBA a=
nd an IBM
> DS4800 some more and I've hit another stumbling block.  When I test unp=
lugging
> one of the HBA ports and plugging it back in with multipath running, it=
 seems to
> cause bad things to happen.  Here is what the syslog looks like (note: =
 sdb is a
> path, sdd is initially unused, and sde is the second path):
>=20
> Jul 19 14:30:35 jimbo kernel: qla2xxx 0000:02:01.1: LOOP DOWN detected =
(2).
> Jul 19 14:30:41 jimbo kernel: rport-4:0-0: blocked FC remote port time =
out:
> removing target and saving binding
> Jul 19 14:30:41 jimbo kernel: sd 4:0:0:0: [sde] Synchronizing SCSI cach=
e
> Jul 19 14:30:41 jimbo kernel: sd 4:0:0:0: [sde] Result: hostbyte=3D0x01
> driverbyte=3D0x00
> Jul 19 14:30:48 jimbo multipathd: sde: rdac checker reports path is dow=
n
> Jul 19 14:30:48 jimbo multipathd: checker failed path 8:64 in map test
> Jul 19 14:30:48 jimbo kernel: scsi 4:0:0:0: rejecting I/O to dead devic=
e
> Jul 19 14:30:48 jimbo kernel: device-mapper: multipath: Failing path 8:=
64.
> Jul 19 14:30:48 jimbo multipathd: test: remaining active paths: 1
> Jul 19 14:30:48 jimbo multipathd: test: switch to path group #2
> Jul 19 14:30:52 jimbo kernel: qla2xxx 0000:02:01.1: LIP reset occured (=
f700).
> Jul 19 14:30:52 jimbo kernel: qla2xxx 0000:02:01.1: LIP occured (f700).
> Jul 19 14:30:52 jimbo kernel: qla2xxx 0000:02:01.1: LIP reset occured (=
f7f7).
> Jul 19 14:30:53 jimbo kernel: scsi 4:0:0:0: rejecting I/O to dead devic=
e
> Jul 19 14:30:53 jimbo multipathd: sde: rdac checker reports path is dow=
n
> Jul 19 14:30:53 jimbo kernel: qla2xxx 0000:02:01.1: LOOP UP detected (4=
 Gbps).
> Jul 19 14:30:53 jimbo kernel: scsi 4:0:0:0: Direct-Access     IBM      =
1815
>  FAStT  0914 PQ: 0 ANSI: 3
> Jul 19 14:30:53 jimbo kernel: sd 4:0:0:0: [sdd] 6291456 512-byte hardwa=
re
> sectors (3221 MB)
> Jul 19 14:30:53 jimbo kernel: sd 4:0:0:0: [sdd] Write Protect is off
> Jul 19 14:30:53 jimbo kernel: sd 4:0:0:0: [sdd] Mode Sense: 77 00 10 08
> Jul 19 14:30:53 jimbo kernel: sd 4:0:0:0: [sdd] Write cache: enabled, r=
ead
> cache: enabled, supports DPO and FUA
> Jul 19 14:30:53 jimbo kernel: sd 4:0:0:0: [sdd] 6291456 512-byte hardwa=
re
> sectors (3221 MB)
> Jul 19 14:30:53 jimbo kernel: sd 4:0:0:0: [sdd] Write Protect is off
> Jul 19 14:30:53 jimbo kernel: sd 4:0:0:0: [sdd] Mode Sense: 77 00 10 08
> Jul 19 14:30:53 jimbo kernel: sd 4:0:0:0: [sdd] Write cache: enabled, r=
ead
> cache: enabled, supports DPO and FUA
> Jul 19 14:30:53 jimbo kernel: sdd: sdd1
> Jul 19 14:30:53 jimbo kernel: sd 4:0:0:0: [sdd] Attached SCSI disk
> Jul 19 14:30:53 jimbo kernel: scsi 4:0:0:0: Direct-Access     IBM      =
1815
>  FAStT  0914 PQ: 0 ANSI: 3
> Jul 19 14:30:53 jimbo kernel: kobject_add failed for 4:0:0:0 with -EEXI=
ST, don't
> try to register things with the same name in the same directory.
> Jul 19 14:30:53 jimbo kernel:
> Jul 19 14:30:53 jimbo kernel: Call Trace:
> Jul 19 14:30:53 jimbo kernel: [<ffffffff802e1d9b>] kobject_shadow_add+0=
x187/0x191
> Jul 19 14:30:53 jimbo kernel: [<ffffffff8033a495>] device_add+0xa1/0x59=
d
> Jul 19 14:30:53 jimbo kernel: [<ffffffff803638e8>] scsi_sysfs_add_sdev+=
0x2e/0x24a
> Jul 19 14:30:53 jimbo kernel: [<ffffffff80361f18>]
> scsi_probe_and_add_lun+0x6ff/0x80f
> Jul 19 14:30:53 jimbo kernel: [<ffffffff803612c8>] scsi_alloc_sdev+0x19=
5/0x1ea
> Jul 19 14:30:53 jimbo kernel: [<ffffffff80362580>] __scsi_scan_target+0=
x3e9/0x549
> Jul 19 14:30:53 jimbo kernel: [<ffffffff80416d83>] thread_return+0x0/0x=
e2
> Jul 19 14:30:53 jimbo kernel: [<ffffffff80362777>] scsi_scan_target+0x9=
7/0xbc
> Jul 19 14:30:53 jimbo kernel: [<ffffffff88003668>]
> :scsi_transport_fc:fc_scsi_scan_rport+0x59/0x79
> Jul 19 14:30:53 jimbo kernel: [<ffffffff8800360f>]
> :scsi_transport_fc:fc_scsi_scan_rport+0x0/0x79
> Jul 19 14:30:53 jimbo kernel: [<ffffffff802379c4>] run_workqueue+0x84/0=
x105
> Jul 19 14:30:53 jimbo kernel: [<ffffffff80237a45>] worker_thread+0x0/0x=
f4
> Jul 19 14:30:53 jimbo kernel: [<ffffffff80237b2f>] worker_thread+0xea/0=
xf4
> Jul 19 14:30:53 jimbo kernel: [<ffffffff8023addd>] autoremove_wake_func=
tion+0x0/0x2e
> Jul 19 14:30:53 jimbo kernel: [<ffffffff8023addd>] autoremove_wake_func=
tion+0x0/0x2e
> Jul 19 14:30:53 jimbo kernel: [<ffffffff8023a888>] kthread+0x3d/0x63
> Jul 19 14:30:53 jimbo kernel: [<ffffffff8020a338>] child_rip+0xa/0x12
> Jul 19 14:30:53 jimbo kernel: [<ffffffff8023a84b>] kthread+0x0/0x63
> Jul 19 14:30:53 jimbo kernel: [<ffffffff8020a32e>] child_rip+0x0/0x12
> Jul 19 14:30:53 jimbo kernel:
> Jul 19 14:30:53 jimbo kernel: error 1
> Jul 19 14:30:53 jimbo kernel: scsi 4:0:0:0: Unexpected response from lu=
n 0 while
> scanning, scan aborted
> Jul 19 14:30:53 jimbo scsi.agent[8613]: disk at
> /devices/pci0000:00/0000:00:02.0/0000:02:01.1/host4/rport-4:0-0/target4=
:0:0/4:0:0:0
> Jul 19 14:30:53 jimbo multipathd: sdd: add path (uevent)
> Jul 19 14:30:53 jimbo kernel: scsi 4:0:0:0: rejecting I/O to dead devic=
e
> Jul 19 14:30:53 jimbo multipathd: sde: checker msg is "rdac checker rep=
orts path
> is down"
> Jul 19 14:30:53 jimbo kernel: device-mapper: multipath rdac: using RDAC=
 command
> with timeout 15000
> Jul 19 14:30:53 jimbo kernel: device-mapper: table: 254:6: multipath: e=
rror
> getting device
> Jul 19 14:30:53 jimbo kernel: device-mapper: ioctl: error adding target=
 to table
> Jul 19 14:30:53 jimbo multipathd: test: failed in domap for addition of=
 new path sdd
> Jul 19 14:30:53 jimbo multipathd: test: uev_add_path sleep
> ...
>=20
>>From here, the last 5 lines get repeated until I 'kill -9' the multipat=
hd
> process.  I'm not too keen on kernel internals (though playing with mul=
tipathing
> is bringing me up to speed pretty quick), but I'm wondering if multipat=
hd is
> causing the call trace by not letting /dev/sde disappear so that the HB=
A's scsi
> device can grab that name again.  I noticed this via lsof:
> multipath 8390     root    5r      BLK               8,64              =
22254
> /dev/sde (deleted)
> multipath 8390     root    6r      BLK               8,16              =
 1100
> /dev/sdb
> multipath 8390     root   10r      BLK               8,48              =
23647
> /dev/sdd
>=20
> When multipathd is running, unplugging and plugging in one of the ports=
 causes
> it to grab the next sd* device name.  As this is repeated, the number o=
f deleted
> block devices multipathd holds on to grows, along with the number of un=
happy
> rdac checkers.  As I said before, it takes a 'kill -9' to stop multipat=
hd, and
> subsequent plugging ins choose sd* names that were previously used but =
were held
> onto as (deleted) by multipathd.
>=20
> However, this behavior is not seen when multipathd is not running.  Whe=
n the
> port is unplugged, the /dev/sd* device disappears, and when it is plugg=
ed back
> in, it takes the same name it had before (I assume it's just taking the=
 lowest
> name, and its old name has been freed) cleanly, with no call traces or =
anything.
>=20
> Any ideas on how to correct this behavior?
>=20
Hmm. multipathd really should react to the 'remove' events for sdX.
Checking ...

Looks as if it does. And it even is supposed to stop the path checker.

Care to run multipathd with full debugging (ie -v 4) and post the output?
My guess is that somehow the path checker is not stopped and the fd is ke=
pt
open, so that the device is not released properly.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)

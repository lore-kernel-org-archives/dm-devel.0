From: "Sebastian Reitenbach" <sebastia@l00-bugdead-prods.de>
Subject: Re: problem with multipathd,
	not all paths added to adisk on boot
Date: Mon, 10 Nov 2008 12:13:15 -0000
Message-ID: <20081110121315.710CC13327@asdf.l00-bugdead-prods.de>
Reply-To: Sebastian Reitenbach <sebastia@l00-bugdead-prods.de>,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
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
To: andmike@linux.vnet.ibm.com, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,

Sebastian Reitenbach <sebastia@l00-bugdead-prods.de>,device-mapper 
development <dm-devel@redhat.com> wrote: 
> Hi,
> 
> Mike Anderson <andmike@linux.vnet.ibm.com> wrote: 
> > Sebastian Reitenbach <sebastia@l00-bugdead-prods.de> wrote:
> > > /dev/sdb in group vm-store, on 1:0:0:0 is not listed, however, lsscsi
> > > has the disk in the list:
> > > [1:0:0:0]    disk    IBM      1814      FAStT  0916  /dev/sdb
> > > 
> > > for the disk that is not added to the group, I see sth like this 
> > > in /var/log/messages:
> > > Nov  6 12:32:36 srv24 kernel: end_request: I/O error, dev sdb, sector 
0
> > > Nov  6 12:32:39 srv24 kernel: end_request: I/O error, dev sdb, sector 
0
> > > Nov  6 12:32:39 srv24 kernel: end_request: I/O error, dev sdb, sector 
8
> > > Nov  6 12:32:42 srv24 kernel: end_request: I/O error, dev sdb, sector 
0
> > > Nov  6 12:32:42 srv24 multipathd: sdb: add path (uevent)
> > > Nov  6 12:32:42 srv24 multipathd: sdb: spurious uevent, path already 
in 
> > > pathvec
> > > Nov  6 12:32:42 srv24 multipathd: sdb: failed to get path uid
> > > Nov  6 12:32:45 srv24 kernel: end_request: I/O error, dev sdb, sector 
0
> > > 
> > 
> > What does running "/sbin/scsi_id -g -u -s /block/sdb" return when you 
are
> > in this failing mode?
> /sbin/scsi_id -g -u -s /block/sdb
> 3600a0b800048b3fe00000431490e90ce
> 
> 
> > 
> > If scsi_id fails what does "sg_inq -v /dev/sdb" and
> > "cat /sys/block/sdb/device/state" return?
> It doesn't fail, but anyways:
> sg_inq -v /dev/sdb
>     inquiry cdb: 12 00 00 00 24 00
> standard INQUIRY:
>     inquiry cdb: 12 00 00 00 4a 00
>   PQual=0  Device_type=0  RMB=0  version=0x05  [SPC-3]
>   [AERC=0]  [TrmTsk=0]  NormACA=1  HiSUP=1  Resp_data_format=2
>   SCCS=0  ACC=0  TGPS=0  3PC=0  Protect=0  BQue=0
>   EncServ=1  MultiP=0  [MChngr=0]  [ACKREQQ=0]  Addr16=0
>   [RelAdr=0]  WBus16=1  Sync=1  Linked=0  [TranDis=0]  CmdQue=1
>   Clocking=0x0  QAS=0  IUS=0
>     length=74 (0x4a)   Peripheral device type: disk
>  Vendor identification: IBM
>  Product identification: 1814      FAStT
>  Product revision level: 0916
>     inquiry cdb: 12 01 00 00 fc 00
>     inquiry: requested 252 bytes but  got 21 bytes
>     inquiry cdb: 12 01 80 00 fc 00
>     inquiry: requested 252 bytes but  got 20 bytes
>  Unit serial number: SG83955342
> 
> cat /sys/block/sdb/device/state
> running
> 
I added some more verbosity when starting up multipathd. Then before the 
error message regarding the path is already in the pathvec, I see the 
following:
...
Nov 10 13:42:08 srv24 kernel: qla2xxx 0000:13:00.0: scsi(1:0:1:2): Mid-layer 
underflow detected (1000 of 1000 bytes)...returning error status.
Nov 10 13:42:09 srv24 kernel: qla2xxx 0000:13:00.0: scsi(1:0:0:0): Mid-layer 
underflow detected (1000 of 1000 bytes)...returning error status.
Nov 10 13:42:09 srv24 kernel: qla2xxx 0000:13:00.0: scsi(1:0:1:2): Mid-layer 
underflow detected (1000 of 1000 bytes)...returning error status.
Nov 10 13:42:09 srv24 kernel: qla2xxx 0000:13:00.0: scsi(1:0:0:0): Mid-layer 
underflow detected (1000 of 1000 bytes)...returning error status.
Nov 10 13:42:09 srv24 kernel: qla2xxx 0000:13:00.0: scsi(1:0:1:2): Mid-layer 
underflow detected (1000 of 1000 bytes)...returning error status.
Nov 10 13:42:10 srv24 kernel: qla2xxx 0000:13:00.0: scsi(1:0:0:0): Mid-layer 
underflow detected (1000 of 1000 bytes)...returning error status.
Nov 10 13:42:10 srv24 kernel: end_request: I/O error, dev sdb, sector 0
Nov 10 13:42:10 srv24 kernel: printk: 5 messages suppressed.
Nov 10 13:42:10 srv24 kernel: Buffer I/O error on device sdb, logical block 
0
Nov 10 13:42:10 srv24 multipathd: uevent 'add' from '/block/sdb'
Nov 10 13:42:10 srv24 multipathd: UDEV_LOG=3
Nov 10 13:42:10 srv24 multipathd: ACTION=add
Nov 10 13:42:10 srv24 multipathd: DEVPATH=/block/sdb
Nov 10 13:42:10 srv24 multipathd: SUBSYSTEM=block
Nov 10 13:42:10 srv24 multipathd: SEQNUM=1278
Nov 10 13:42:10 srv24 multipathd: MINOR=16
Nov 10 13:42:10 srv24 multipathd: MAJOR=8
Nov 10 13:42:10 srv24 multipathd: 
PHYSDEVPATH=/devices/pci0000:00/0000:00:02.0/0000:10:00.0/0000:11:00.0/0000:13:00.0/host1/rport-1:0-0/target1:0:0/1:0:0:0


Nov 10 13:42:10 srv24 multipathd: PHYSDEVBUS=scsi
Nov 10 13:42:10 srv24 multipathd: PHYSDEVDRIVER=sd
Nov 10 13:42:10 srv24 kernel: qla2xxx 0000:13:00.0: scsi(1:0:1:2): Mid-layer 
underflow detected (1000 of 1000 bytes)...returning error status.
Nov 10 13:42:10 srv24 multipathd: UDEVD_EVENT=1
Nov 10 13:42:10 srv24 multipathd: ID_VENDOR=IBM
Nov 10 13:42:10 srv24 multipathd: ID_MODEL=1814_FAStT
Nov 10 13:42:10 srv24 multipathd: ID_REVISION=0916
Nov 10 13:42:10 srv24 multipathd: 
ID_SERIAL=3600a0b800048b3fe00000431490e90ce
Nov 10 13:42:10 srv24 multipathd: ID_TYPE=disk
Nov 10 13:42:10 srv24 multipathd: ID_BUS=scsi
Nov 10 13:42:10 srv24 multipathd: 
ID_PATH=pci-0000:13:00.0-fc-0x200400a0b848b3ff:0x0000000000000000
Nov 10 13:42:10 srv24 multipathd: DEVNAME=/dev/sdb
Nov 10 13:42:10 srv24 multipathd: 
DEVLINKS=/dev/disk/by-id/scsi-3600a0b800048b3fe00000431490e90ce
/dev/disk/by-path/pci-0000:13:00.0-fc-0x200400a0b848b3ff:0x0000
Nov 10 13:42:10 srv24 multipathd: sdb: add path (uevent)
Nov 10 13:42:10 srv24 multipathd: sdb: spurious uevent, path already in 
pathvec
Nov 10 13:42:10 srv24 multipathd: sdb: failed to get path uid
Nov 10 13:42:10 srv24 kernel: qla2xxx 0000:13:00.0: scsi(1:0:0:0): Mid-layer 
underflow detected (1000 of 1000 bytes)...returning error status.
Nov 10 13:42:10 srv24 kernel: qla2xxx 0000:13:00.0: scsi(1:0:0:0): Mid-layer 
underflow detected (3000 of 3000 bytes)...returning error status.
Nov 10 13:42:10 srv24 kernel: qla2xxx 0000:13:00.0: scsi(1:0:1:2): Mid-layer 
underflow detected (1000 of 1000 bytes)...returning error status.
Nov 10 13:42:11 srv24 kernel: qla2xxx 0000:13:00.0: scsi(1:0:0:0): Mid-layer 
underflow detected (1000 of 1000 bytes)...returning error status.
...

I also recognized, when I just restart multipathd after above error, then 
sdb is immediately added to the path.

I also tried combinations of other qla2xxx parameters to raise some timeout 
values..., e.g.:
options qla2xxx qlport_down_retry=5 ql2xlogintimeout=30 
ql2xloginretrycount=5 ql2xplogiabsentdevice=1 ql2xfdmienable=1 
ql2xmaxqdepth=64 ql2xextended_error_logging=1 ql2xqfullrampup=180
but that did not produced any observable difference.

so still no real solution, any idea what could block multipathd to add sdb 
to the path on first startup?

kind regards
Sebastian

From: "Sebastian Reitenbach" <sebastia@l00-bugdead-prods.de>
Subject: Re: problem with multipathd,
	not all paths added to adisk on boot
Date: Thu, 06 Nov 2008 20:33:43 -0000
Message-ID: <20081106203344.6DA561336A@smtp.l00-bugdead-prods.de>
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
To: dm-devel@redhat.com, andmike@linux.vnet.ibm.com
List-Id: dm-devel.ids

Hi,

Mike Anderson <andmike@linux.vnet.ibm.com> wrote: 
> Sebastian Reitenbach <sebastia@l00-bugdead-prods.de> wrote:
> > /dev/sdb in group vm-store, on 1:0:0:0 is not listed, however, lsscsi
> > has the disk in the list:
> > [1:0:0:0]    disk    IBM      1814      FAStT  0916  /dev/sdb
> > 
> > for the disk that is not added to the group, I see sth like this 
> > in /var/log/messages:
> > Nov  6 12:32:36 srv24 kernel: end_request: I/O error, dev sdb, sector 0
> > Nov  6 12:32:39 srv24 kernel: end_request: I/O error, dev sdb, sector 0
> > Nov  6 12:32:39 srv24 kernel: end_request: I/O error, dev sdb, sector 8
> > Nov  6 12:32:42 srv24 kernel: end_request: I/O error, dev sdb, sector 0
> > Nov  6 12:32:42 srv24 multipathd: sdb: add path (uevent)
> > Nov  6 12:32:42 srv24 multipathd: sdb: spurious uevent, path already in 
> > pathvec
> > Nov  6 12:32:42 srv24 multipathd: sdb: failed to get path uid
> > Nov  6 12:32:45 srv24 kernel: end_request: I/O error, dev sdb, sector 0
> > 
> 
> What does running "/sbin/scsi_id -g -u -s /block/sdb" return when you are
> in this failing mode?
/sbin/scsi_id -g -u -s /block/sdb
3600a0b800048b3fe00000431490e90ce


> 
> If scsi_id fails what does "sg_inq -v /dev/sdb" and
> "cat /sys/block/sdb/device/state" return?
It doesn't fail, but anyways:
sg_inq -v /dev/sdb
    inquiry cdb: 12 00 00 00 24 00
standard INQUIRY:
    inquiry cdb: 12 00 00 00 4a 00
  PQual=0  Device_type=0  RMB=0  version=0x05  [SPC-3]
  [AERC=0]  [TrmTsk=0]  NormACA=1  HiSUP=1  Resp_data_format=2
  SCCS=0  ACC=0  TGPS=0  3PC=0  Protect=0  BQue=0
  EncServ=1  MultiP=0  [MChngr=0]  [ACKREQQ=0]  Addr16=0
  [RelAdr=0]  WBus16=1  Sync=1  Linked=0  [TranDis=0]  CmdQue=1
  Clocking=0x0  QAS=0  IUS=0
    length=74 (0x4a)   Peripheral device type: disk
 Vendor identification: IBM
 Product identification: 1814      FAStT
 Product revision level: 0916
    inquiry cdb: 12 01 00 00 fc 00
    inquiry: requested 252 bytes but  got 21 bytes
    inquiry cdb: 12 01 80 00 fc 00
    inquiry: requested 252 bytes but  got 20 bytes
 Unit serial number: SG83955342

cat /sys/block/sdb/device/state
running

thanks
Sebastian

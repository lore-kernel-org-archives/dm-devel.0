From: Liuhua Wang <lwang@suse.com>
Subject: Re: pvmove/mirror target mirroring data between two
 devices with different sector size
Date: Fri, 1 Apr 2016 14:13:37 +0800
Message-ID: <20160401061337.GA13334@wlh-host.lab.bej.apac.novell.com>
References: <56F94727020000A000058AA7@prv3-mh.provo.novell.com>
	<8737r7tn35.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <8737r7tn35.fsf@notabene.neil.brown.name>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: NeilBrown <neilb@suse.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Neil,
Hi Coly,

Thank you for your reply.
> >
> > I have a question that I think maybe you can give me some idea.
> >
> > I have two devices with different sector size: 512B and 4096B.
> >
> > - SOURCE DEVICE (mdos lvm partiton)
> > #parted /dev/sdb
> > Model: ATA SATADOM-SL 3ME (scsi)
> > Disk /dev/sdb: 32.0GB
> > Sector size (logical/physical): 512B/512B
> > Partition Table: msdos
> > (In `parted` Sector size are both got from IOCTL(BLKSSZGET))
> >
> > - TARGET DEVICE (WHOLE DISK)
> > #parted /dev/sdc
> > Error: /dev/sdd: unrecognised disk label
> > Model: ATA HUH728080ALN600 (scsi)
> > Disk /dev/sdd: 8002GB
> > Sector size (logical/physical): 4096B/4096B
> > Partition Table: unknown
> >
> > I want to move data from one device to the other using lvm command
> > `pvmove`, but after pvmove, file system cannot mount.
> 
> This seems to raise questions that you could easily answer:
> 1/ what filesystem.  What error when mounting?
XFS

after `pvmove` (from 512B sector sized zfcp device to 4096 sector sized dasd device)
and umounted, it cannot be mounted.

#umount /mnt
#mount /dev/vg/lv /mnt
mount: mount /dev/mapper/vg-lv on /mnt failed: Function not implemented

/var/log/messges:
-------------------------
 kernel: end_request: I/O error, dev dasdb, sector 514284
 kernel: (dm-4): metadata I/O error: block 0x7d02c ("xlog_iodone") error 5 numblks 64
 kernel: (dm-4): xfs_do_force_shutdown(0x2) called from line 1174 of file ../fs/xfs/xfs_log.c.  Return address = 0x000003ff806f1d46
 kernel: (dm-4): Log I/O Error Detected.  Shutting down filesystem
 kernel: XFS (dm-4): Please umount the filesystem and rectify the problem(s)
 kernel: XFS (dm-4): Unable to update superblock counters. Freespace may not be correct on next mount.
 kernel: XFS (dm-4): xfs_log_force: error 5 returned.

 kernel: XFS (dm-4): device supports 4096 byte sectors (not 512)
--------------------------
Seems that filesystem are not correctly recoganized by mount.

But when I then `pvmove` back (from 4096 sector size dasd device to 512 sector size zfcp device)
It can be mounted successfully.


> 2/ Is the data exactly the same after the move. e.g does
>   sh1sum of the old and new device report the same content?
>   If not, what about sha1sum of the first 10Gig? The first Gig?
>   100K? 16K? 1K? ...
>   i.e. if there is a difference, where is the first difference?
Only the first 64K which belongs to lvm2 metadata area are different.
(I wrote file to fs with dd if=/dev/zero of=/mnt/file)
But pvmove between two same devices will cause different lvmeta data
which is expected.


I did more tests and found that if I add "-s size=4096" that is,
`mkfs.xfs -s size=4096 /dev/vg/lv ` then there is no problem after `pvmove`.
(the default is 512B)

So I think the root reason is that fs with sector size 512 cannot support 
device with sector size 4096. right?


Best,
Liuhua
> >
> > So my question is whether pvmove support moving date between devices with different sector size
> > or same question: mirror target support mirroring data between two devices with different sector size?
> >
> > Thank you in advance.
> >
> > Best regards,
> > Liuhua



-- 
---
Liuhua Wang

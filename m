From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: Fix alignment stacking on partitioned devices
Date: Tue, 22 Dec 2009 16:42:52 -0500
Message-ID: <20091222214250.GA28497@redhat.com>
References: <yq1aaxg7n84.fsf@sermon.lab.mkp.net>
	<20091218173322.GA4163@redhat.com>
	<yq14onk5iaa.fsf@sermon.lab.mkp.net>
	<20091221195204.GA28703@redhat.com>
	<yq1r5qn4orc.fsf@sermon.lab.mkp.net>
	<20091222143240.GA9154@redhat.com>
	<yq1my1a52k4.fsf@sermon.lab.mkp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <yq1my1a52k4.fsf@sermon.lab.mkp.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>, jens.axboe@oracle.com
List-Id: dm-devel.ids

Martin,

Apologies for the long mail here...

On Tue, Dec 22 2009 at 12:41pm -0500,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> Mike,
> 
> Mike> OK, so is MD somehow getting things wrong?  (You originally said
> Mike> that with the new stacking function MD resulted in an error but DM
> Mike> did not).
> 
> MD is passing in absolute offsets and got the right result in both
> cases.
> 
> 
> Mike> "start" isn't a relative offset.  
> 
> It's relative to the beginning of the partition (block_device), not
> relative to the beginning of the disk (request_queue).

Ah, thanks for clarifying!  No idea why I thought "start" was relative
to the beginning of the disk (request_queue).

> My beef here is that DM created a device like this:
> 
> [root@10 ~]# pvs -o +pe_start
>   PV         VG   Fmt  Attr PSize   PFree   1st PE 
>   /dev/sde1  foo  lvm2 a-   508.00M 256.00M 192.00K
>   /dev/sde2  foo  lvm2 a-   512.00M 260.00M 192.00K
> [root@10 ~]# dmsetup table
> foo-bar: 0 1032192 striped 2 32 8:66 384 8:65 384
> 
> /dev/sde  has an alignment_offset of 3584
> /dev/sde1 has an alignment_offset of 0
> /dev/sde2 has an alignment_offset of 1024

I'm seeing the following (when I use the scsi_debug from below):
# cat /sys/block/sdb/alignment_offset 
3584
# cat /sys/block/sdb/sdb1/alignment_offset 
512
# cat /sys/block/sdb/sdb2/alignment_offset 
512
 
> dm_set_device_limits() calls blk_stack_limits() with a byte offset of
> 196608 for both sde1 and sde2.  And that offset is checked for alignment
> with the queue's limits which has an alignment_offset of 3584.
> 
> The two PVs are misaligned but that information is lost because you use
> blk_stack_limits() with partition-relative offsets.  My patch was an
> attempt to fix that.

Coming full circle, your patch makes sense.  Sorry about giving you the
run around!  But I have new concerns (at the very end below) about the
new blk_stack_limits(); I also need to review your patch further
(relative to virtual device stacking: does get_start_sect(bdev) always
work?).

> Test case:
> 
> # modprobe scsi_debug dev_size_mb=1024 num_parts=2 lowest_aligned=7 physblk_exp=3
> # pvcreate /dev/sde1
> # pvcreate /dev/sde2
> # vgcreate foo /dev/sde1 /dev/sde2
> # lvcreate -I 16 -i 2 -L 500M -n bar foo

Here I'm just showing that I verified what you were seeing above.  With
an updated LVM but the older blk_stack_limits() the same test gives me:

# pvs -o +pe_start
  PV         VG   Fmt  Attr PSize   PFree   1st PE 
  /dev/sdb1       lvm2 --    99.48m  99.48m 192.50k
  /dev/sdb2       lvm2 --   100.50m 100.50m 192.50k
# vgcreate foo /dev/sdb1 /dev/sdb2
# lvcreate -I 16 -i 2 -L100M -n bar foo
# dmsetup table foo-bar
0 212992 striped 2 32 8:18 385 8:17 385

device-mapper: table: 253:1: target device sdb2 is misaligned: physical_block_size=4096, logical_block_size=512, alignment_offset=3584, start=197120
device-mapper: table: 253:1: target device sdb1 is misaligned: physical_block_size=4096, logical_block_size=512, alignment_offset=3584, start=197120

If I disable LVM's alignment_offset detection (runs the same as your
older LVM) I get:
# pvcreate --config 'devices {data_alignment_offset_detection=0}' /dev/sdb1
# pvcreate --config 'devices {data_alignment_offset_detection=0}' /dev/sdb2
# pvs -o +pe_start
  PV         VG   Fmt  Attr PSize   PFree   1st PE 
  /dev/sdb1       lvm2 --    99.48m  99.48m 192.00k
  /dev/sdb2       lvm2 --   100.50m 100.50m 192.00k
...
# dmsetup table foo-bar
0 212992 striped 2 32 8:18 384 8:17 384

device-mapper: table: 253:1: target device sdb2 is misaligned: physical_block_size=4096, logical_block_size=512, alignment_offset=3584, start=196608
device-mapper: table: 253:1: target device sdb1 is misaligned: physical_block_size=4096, logical_block_size=512, alignment_offset=3584, start=196608


Now if I apply your patch to add the partition offset -- which makes the
offset that DM passes to blk_stack_limits() absolute:

The old blk_stack_limits(), using LVM2 w/
data_alignment_offset_detection=1 shows this aligned case as
"misaligned":
device-mapper: table: 253:1: target device sdb2 is misaligned: physical_block_size=4096, logical_block_size=512, alignment_offset=3584, start=104530432
device-mapper: table: 253:1: target device sdb1 is misaligned: physical_block_size=4096, logical_block_size=512, alignment_offset=3584, start=213504

The new blk_stack_limits() "works" (believes the device is aligned).
But if I use pvcreate w/ data_alignment_offset_detection=0 it
_incorrectly_ believes the device is aligned.

Why does the new blk_stack_limits() think the misaligned offset is
aligned?  I added some debugging to dm_set_device_limits() to see the
following:

1) MISALIGNED-case: LVM2 with data_alignment_offset_detection=0:
device-mapper: table: 254:1: target device sdb2 call to blk_stack_limits(): physical_block_size=4096, logical_block_size=512, alignment_offset=3584, start=104529920
device-mapper: table: 254:1: target device sdb1 call to blk_stack_limits(): physical_block_size=4096, logical_block_size=512, alignment_offset=3584, start=212992

This is not properly aligned relative to physical_block_size=4096, sdb's
alignment_offset=3584 and each partitions' alignment_offset=512:

>>> 104529920%4096
0
>>> 212992%4096
0

2) ALIGNED-case: LVM2 with data_alignment_offset_detection=1:
device-mapper: table: 254:1: target device sdb2 call to blk_stack_limits(): physical_block_size=4096, logical_block_size=512, alignment_offset=3584, start=104530432
device-mapper: table: 254:1: target device sdb1 call to blk_stack_limits(): physical_block_size=4096, logical_block_size=512, alignment_offset=3584, start=213504

In this 2nd case, LVM2 is correctly adding the alignment_offset (512)
for each partitioned device.  Each data "start" includes the
alignment_offset of 512.  So the device is properly aligned:

>>> 104530432%4096
512
>>> 213504%4096
512


I'll dig into blk_stack_limits() to see if I can make sense of this.
And in the end; what, if anything, is DM doing wrong?

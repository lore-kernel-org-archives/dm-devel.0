From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: Fix alignment stacking on partitioned devices
Date: Tue, 22 Dec 2009 17:13:53 -0500
Message-ID: <20091222221352.GA16299@redhat.com>
References: <yq1aaxg7n84.fsf@sermon.lab.mkp.net>
	<20091218173322.GA4163@redhat.com>
	<yq14onk5iaa.fsf@sermon.lab.mkp.net>
	<20091221195204.GA28703@redhat.com>
	<yq1r5qn4orc.fsf@sermon.lab.mkp.net>
	<20091222143240.GA9154@redhat.com>
	<yq1my1a52k4.fsf@sermon.lab.mkp.net>
	<20091222214250.GA28497@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091222214250.GA28497@redhat.com>
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

On Tue, Dec 22 2009 at  4:42pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> Martin,
> 
> Apologies for the long mail here...
> 
> On Tue, Dec 22 2009 at 12:41pm -0500,
> Martin K. Petersen <martin.petersen@oracle.com> wrote:
> 
> > >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> > 
> > Mike,
> > 
> > Mike> OK, so is MD somehow getting things wrong?  (You originally said
> > Mike> that with the new stacking function MD resulted in an error but DM
> > Mike> did not).
> > 
> > MD is passing in absolute offsets and got the right result in both
> > cases.
> > 
> > 
> > Mike> "start" isn't a relative offset.  
> > 
> > It's relative to the beginning of the partition (block_device), not
> > relative to the beginning of the disk (request_queue).
> 
> Ah, thanks for clarifying!  No idea why I thought "start" was relative
> to the beginning of the disk (request_queue).
> 
> > My beef here is that DM created a device like this:
> > 
> > [root@10 ~]# pvs -o +pe_start
> >   PV         VG   Fmt  Attr PSize   PFree   1st PE 
> >   /dev/sde1  foo  lvm2 a-   508.00M 256.00M 192.00K
> >   /dev/sde2  foo  lvm2 a-   512.00M 260.00M 192.00K
> > [root@10 ~]# dmsetup table
> > foo-bar: 0 1032192 striped 2 32 8:66 384 8:65 384
> > 
> > /dev/sde  has an alignment_offset of 3584
> > /dev/sde1 has an alignment_offset of 0
> > /dev/sde2 has an alignment_offset of 1024
> 
> I'm seeing the following (when I use the scsi_debug from below):
> # cat /sys/block/sdb/alignment_offset 
> 3584
> # cat /sys/block/sdb/sdb1/alignment_offset 
> 512
> # cat /sys/block/sdb/sdb2/alignment_offset 
> 512

Bleh, I used dev_size_mb=200 to get the above alignment_offsets.

> > # modprobe scsi_debug dev_size_mb=1024 num_parts=2 lowest_aligned=7 physblk_exp=3

If I increase to dev_size_mb=500 I get:
sdb1 alignment_offset=0
sdb2 alignment_offset=512

If I increase to dev_size_mb=1000 I also get:
sdb1 alignment_offset=0
sdb2 alignment_offset=1024

Anyway, this doesn't change the fact that the new blk_stack_limits()
isn't detecting the offset that DM provides as misaligned (in the legacy
LVM case, data_alignment_offset_detection=0).

In an earlier mail you said:
dm_set_device_limits() calls blk_stack_limits() with a byte offset of
196608 for both sde1 and sde2.  And that offset is checked for alignment
with the queue's limits which has an alignment_offset of 3584.

Applying that to this example that I shared:

> The new blk_stack_limits() "works" (believes the device is aligned).
> But if I use pvcreate w/ data_alignment_offset_detection=0 it
> _incorrectly_ believes the device is aligned.
> 
> Why does the new blk_stack_limits() think the misaligned offset is
> aligned?  I added some debugging to dm_set_device_limits() to see the
> following:
> 
> 1) MISALIGNED-case: LVM2 with data_alignment_offset_detection=0:
> device-mapper: table: 254:1: target device sdb2 call to blk_stack_limits(): physical_block_size=4096, logical_block_size=512, alignment_offset=3584, start=104529920
> device-mapper: table: 254:1: target device sdb1 call to blk_stack_limits(): physical_block_size=4096, logical_block_size=512, alignment_offset=3584, start=212992
> 
> This is not properly aligned relative to physical_block_size=4096, sdb's
> alignment_offset=3584 and each partitions' alignment_offset=512:
> 
> >>> 104529920%4096
> 0
> >>> 212992%4096
> 0

dm_set_device_limits() calls blk_stack_limits() with a byte offset of
212992 for sdb1 and 104529920 for sdb2.  And those offsets are checked
for alignment with the queue's limits which has an alignment_offset of
3584.

/me now goes to look at the new blk_stack_limits()

From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [2.6.31-rc1] device-mapper: target device sda6 is
	misaligned
Date: Thu, 25 Jun 2009 14:23:03 -0400
Message-ID: <20090625182302.GA23113@redhat.com>
References: <200906250904.57149.elendil@planet.nl>
	<200906251840.07617.elendil@planet.nl>
	<20090625172041.GA22891@redhat.com>
	<200906251953.34253.elendil@planet.nl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200906251953.34253.elendil@planet.nl>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Frans Pop <elendil@planet.nl>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, martin.petersen@oracle.com
List-Id: dm-devel.ids

On Thu, Jun 25 2009 at  1:53pm -0400,
Frans Pop <elendil@planet.nl> wrote:

> On Thursday 25 June 2009, Mike Snitzer wrote:
> > > I'm afraid those files don't exist on my systems (none of them: arm,
> > > s390 and x86_64 notebook). Some kernel config option I'm missing
> > > maybe?
> >
> > You should definitely have the topology attributes in the associated
> > device's sysfs tree.
> 
> Ah, sorry. I'd switched back to .30 for the arm system because of this.
> (And on the s390 box I looked for sda instead of dasdb; duh!)
> 
> Here are the values for arm:
> 
> $ cat /sys/block/sda/sda6/alignment_offset
> 0
> $ cat /sys/block/sda/queue/physical_block_size
> 512
> $ cat /sys/block/sda/queue/logical_block_size
> 512
> 
> And here's the lot for the s390 emulator:
> 
> # grep . /sys/block/dasdb/dasdb*/alignment_offset
> /sys/block/dasdb/dasdb1/alignment_offset:0
> /sys/block/dasdb/dasdb2/alignment_offset:0
> # grep . /sys/block/dasdb/queue/physical_block_size
> 4096
> # grep . /sys/block/dasdb/queue/logical_block_size
> 4096
> 
> # pvs -o +pe_start
>   PV          VG     Fmt  Attr PSize   PFree 1st PE
>   /dev/dasdb1 mordor lvm2 a-   388.00M    0  192.00K
>   /dev/dasdb2 mordor lvm2 a-   388.00M    0  192.00K
> # dmsetup ls
> mordor-home     (254, 0)
> # dmsetup table
> mordor-home: 0 794624 linear 94:5 384
> mordor-home: 794624 794624 linear 94:6 384


OK, I found a really stupid bug.  I was passing the data start offset
(pe_start) through to blk_stack_limits() in terms of sectors rather than
bytes.  The following should silence your warnings:

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 4899ebe..2cba557 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -495,7 +495,7 @@ int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
 		return 0;
 	}
 
-	if (blk_stack_limits(limits, &q->limits, start) < 0)
+	if (blk_stack_limits(limits, &q->limits, start << 9) < 0)
 		DMWARN("%s: target device %s is misaligned",
 		       dm_device_name(ti->table->md), bdevname(bdev, b));
 

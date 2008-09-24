From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 2/2] dm: Add support for data integrity to DM
Date: Wed, 24 Sep 2008 12:23:38 -0400 (EDT)
Message-ID: <20080924.122338.78703707.k-ueda@ct.jp.nec.com>
References: <20080920211433.9e1a6872.akpm@linux-foundation.org>
	<1222195272-18674-3-git-send-email-martin.petersen@oracle.com>
	<20080923.152942.41629825.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080923.152942.41629825.k-ueda@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: martin.petersen@oracle.com
Cc: k-ueda@ct.jp.nec.com, dm-devel@redhat.com, agk@sourceware.org, linux-kernel@vger.kernel.org, jens.axboe@oracle.com
List-Id: dm-devel.ids

Hi Martin,

On Tue, 23 Sep 2008 15:29:42 -0400 (EDT), Kiyoshi Ueda wrote:
> On Tue, 23 Sep 2008 14:41:12 -0400, "Martin K. Petersen" wrote:
> > If all subdevices support the same protection format the DM device is
> > flagged as capable.
> > 
> > Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> > ---
> >  drivers/md/dm-table.c         |   35 ++++++++++++++++++++++++++++++++++-
> >  drivers/md/dm.c               |   24 ++++++++++++++++++++++--
> >  drivers/md/dm.h               |    2 +-
> >  include/linux/device-mapper.h |    1 +
> >  4 files changed, 58 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> > index 61f4414..7290a90 100644
> > --- a/drivers/md/dm-table.c
> > +++ b/drivers/md/dm-table.c
> > @@ -841,8 +841,12 @@ struct dm_target *dm_table_find_target(struct dm_table *t, sector_t sector)
> >  	return &t->targets[(KEYS_PER_NODE * n) + k];
> >  }
> >  
> > -void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q)
> > +void dm_table_set_restrictions(struct dm_table *t, struct mapped_device *md)
> >  {
> > +	struct request_queue *q = dm_queue(md);
> > +	struct list_head *devices = dm_table_get_devices(t);
> > +	struct dm_dev *prev, *cur;
> > +
> >  	/*
> >  	 * Make sure we obey the optimistic sub devices
> >  	 * restrictions.
> > @@ -861,6 +865,35 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q)
> >  	else
> >  		queue_flag_set_unlocked(QUEUE_FLAG_CLUSTER, q);
> >  
> > +	/*
> > +	 * Run through all devices to ensure they have matching
> > +	 * integrity profile
> > +	 */
> > +	cur = prev = NULL;
> > +
> > +	list_for_each_entry(cur, devices, list) {
> > +
> > +		if (prev && blk_integrity_compare(prev->bdev, cur->bdev) < 0) {
> > +			printk(KERN_ERR "%s: %s %s Integrity mismatch!\n",
> > +			       __func__, prev->bdev->bd_disk->disk_name,
> > +			       cur->bdev->bd_disk->disk_name);
> > +			return;
> > +		}
> > +		prev = cur;
> > +	}
> > +
> > +	/* Register dm device as being integrity capable */
> > +	if (prev && bdev_get_integrity(prev->bdev)) {
> > +		struct gendisk *disk = dm_disk(md);
> > +
> > +		if (blk_integrity_register(dm_disk(md),
> > +					   bdev_get_integrity(prev->bdev)))
> > +			printk(KERN_ERR "%s: %s Could not register integrity!\n",
> > +			       __func__, disk->disk_name);
> > +		else
> > +			printk(KERN_INFO "Enabling data integrity on %s\n",
> > +			       disk->disk_name);
> > +	}
> >  }
> <snip>
> > @@ -1200,7 +1216,6 @@ static void __set_size(struct mapped_device *md, sector_t size)
> >  
> >  static int __bind(struct mapped_device *md, struct dm_table *t)
> >  {
> > -	struct request_queue *q = md->queue;
> >  	sector_t size;
> >  
> >  	size = dm_table_get_size(t);
> > @@ -1221,7 +1236,7 @@ static int __bind(struct mapped_device *md, struct dm_table *t)
> >  
> >  	write_lock(&md->map_lock);
> >  	md->map = t;
> > -	dm_table_set_restrictions(t, q);
> > +	dm_table_set_restrictions(t, md);
> >  	write_unlock(&md->map_lock);
> >  
> >  	return 0;
> 
> Creating another function (e.g. dm_table_set_integrity(t, md)) may
> be better, since then you wouldn't need dm_queue() nor need to change
> the function interface of dm_table_set_restrictions() I think.

Or you can also get md from t->md or q->queuedata, if you don't mind
to pass q as an argument of the function which sets integrity feature.
(I thought you mind that, since the integrity feature is set to
 md (md->disk), not q.)

Thanks,
Kiyoshi Ueda

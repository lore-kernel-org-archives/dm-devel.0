From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] DM data integrity support
Date: Tue, 21 Oct 2008 13:59:51 +0100
Message-ID: <20081021125951.GD2810@agk.fab.redhat.com>
References: <yq1k5c7mg7v.fsf@sermon.lab.mkp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <yq1k5c7mg7v.fsf@sermon.lab.mkp.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

On Fri, Oct 17, 2008 at 10:47:00AM -0400, Martin K. Petersen wrote:
> Add support for data integrity to DM.
> If all subdevices support the same protection format the DM device is
> flagged as capable.
 
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> +void dm_table_set_integrity(struct dm_table *t, struct mapped_device *md)

md looks superfluous here - I've replaced it with t->md.

I've also moved the function inside dm_table_set_restrictions as they fit
together logically and both suffer from the same flaw when properties of
a subdevice get changed and manual intervention is needed for propagation back
up the tree.

> +	list_for_each_entry(cur, devices, list) {
> +		if (prev &&
> +		    blk_integrity_compare(prev->dm_dev.bdev->bd_disk,
> +					  cur->dm_dev.bdev->bd_disk) < 0) {
> +			printk(KERN_ERR "%s: %s %s integrity mismatch!\n",
> +			       __func__, prev->dm_dev.bdev->bd_disk->disk_name,
> +			       cur->dm_dev.bdev->bd_disk->disk_name);

That message adds nothing to the preceding one that blk_integrity_compare()
would have issued - the one bit of data it could add, namely the name of
the mapped device, isn't there, so I've added it.  I've also reduced it to
KERN_WARN, and I'm a bit concerned about those messages issued by
blk_integrity_compare() too i.e. any message like that will generate support
requests asking what it means and how to fix the problem and eliminate the
messages, but won't they sometimes be unavoidable and expected?

> +	/* Register dm device as being integrity capable */
> +	if (blk_integrity_register(dm_disk(md),
> +				   bdev_get_integrity(prev->dm_dev.bdev)))
> +		printk(KERN_ERR "%s: %s Could not register integrity!\n",
> +		       __func__, dm_disk(md)->disk_name);
> +	else
> +		printk(KERN_INFO "Enabling data integrity on %s\n",
> +		       dm_disk(md)->disk_name);

Superfluous?  Changing to DMDEBUG: if you don't get the error message and the
mapped_device is not its own endpoint for I/O, you can assume it did this.  

> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -669,6 +669,13 @@ static struct bio *split_bvec(struct bio
>  	clone->bi_size = to_bytes(len);
>  	clone->bi_io_vec->bv_offset = offset;
>  	clone->bi_io_vec->bv_len = clone->bi_size;
> +	clone->bi_flags |= 1 << BIO_CLONED;

I've separated that into its own patch - it's nothing to do with blk_integrity,
and if it has unforseen side-effects we need people to be able to bisect to it.

> @@ -1226,6 +1242,7 @@ static int __bind(struct mapped_device *
>  	write_lock(&md->map_lock);
>  	md->map = t;
>  	dm_table_set_restrictions(t, q);
> +	dm_table_set_integrity(t, md);

I moved that inside dm_table_set_restrictions, but there's a little problem
here.  The first time it decides to call blk_integrity_register(), there are
memory allocations and kobject manipulation.  That's not desirable: I don't
want the number of sites relying upon PF_MEMALLOC and the amount of code that
has to remain under audit for memory pressure deadlocks to increase if we
can avoid that.  Those functions can be performed safely during alloc_dev() or
dm_table_create(), but with the device-mapper code as it currently is,
__bind() needs to remain as quick and as simple as possible.

Perhaps change the register/unregister interface to make it symmetric:
we always register and unregister when creating the device, then set the
integrity to the appropriate value - which might include NULL - when the new
table is put into place.

Currently how does device-mapper clear the integrity profile of a mapped_device
which used to have one but which no longer does after a table swap?  In other
words I'm suggesting 'not supported' could be a valid integrity profile, rather
than requiring an 'unregister' (which seems to be missing from the appropriate
code path in this patch anyway).

I'd also like to check how:
   kobject_uevent(&bi->kobj, KOBJ_ADD);
is meant to be used, and whether it could move outside __bind() to the end of the
dm_resume (where we already issue a uevent).

Updated version below.

Alasdair


From: Martin K. Petersen <martin.petersen@oracle.com>

When a bio gets split, mark its fragments with the BIO_CLONED flag.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm.c |    1 +
 1 files changed, 1 insertion(+)

Index: linux/drivers/md/dm.c
===================================================================
--- linux.orig/drivers/md/dm.c	2008-10-21 12:12:55.000000000 +0100
+++ linux/drivers/md/dm.c	2008-10-21 12:16:29.000000000 +0100
@@ -669,6 +669,7 @@ static struct bio *split_bvec(struct bio
 	clone->bi_size = to_bytes(len);
 	clone->bi_io_vec->bv_offset = offset;
 	clone->bi_io_vec->bv_len = clone->bi_size;
+	clone->bi_flags |= 1 << BIO_CLONED;
 
 	return clone;
 }
From: Martin K. Petersen <martin.petersen@oracle.com>

Add support for data integrity to DM.

If all subdevices support the same protection format the DM device is
flagged as capable.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm-table.c |   38 ++++++++++++++++++++++++++++++++++++++
 drivers/md/dm.c       |   15 +++++++++++++++
 2 files changed, 53 insertions(+)

Index: linux/drivers/md/dm-table.c
===================================================================
--- linux.orig/drivers/md/dm-table.c	2008-10-21 12:12:55.000000000 +0100
+++ linux/drivers/md/dm-table.c	2008-10-21 12:19:24.000000000 +0100
@@ -855,6 +855,43 @@ struct dm_target *dm_table_find_target(s
 	return &t->targets[(KEYS_PER_NODE * n) + k];
 }
 
+/*
+ * Set the integrity profile for this device if all devices used have
+ * matching profiles.
+ */
+static void dm_table_set_integrity(struct dm_table *t)
+{
+	struct list_head *devices = dm_table_get_devices(t);
+	struct dm_dev_internal *prev = NULL, *dd = NULL;
+	struct blk_integrity *bi;
+
+	list_for_each_entry(dd, devices, list) {
+		if (prev &&
+		    blk_integrity_compare(prev->dm_dev.bdev->bd_disk,
+					  dd->dm_dev.bdev->bd_disk) < 0) {
+			DMWARN("%s: integrity not set: %s and %s mismatch",
+			       dm_device_name(t->md),
+			       prev->dm_dev.bdev->bd_disk->disk_name,
+			       dd->dm_dev.bdev->bd_disk->disk_name);
+			return;
+		}
+		prev = dd;
+	}
+
+	if (!prev)
+		return;
+
+	bi = bdev_get_integrity(prev->dm_dev.bdev);
+	if (!bi)
+		return;
+
+	if (blk_integrity_register(dm_disk(t->md), bi))
+		DMERR("%s: %s: blk_integrity_register failed.",
+		       __func__, dm_device_name(t->md));
+	else
+		DMDEBUG("%s: Enabling data integrity.", dm_device_name(t->md));
+}
+
 void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q)
 {
 	/*
@@ -875,6 +912,7 @@ void dm_table_set_restrictions(struct dm
 	else
 		queue_flag_set_unlocked(QUEUE_FLAG_CLUSTER, q);
 
+	dm_table_set_integrity(t);
 }
 
 unsigned int dm_table_get_num_targets(struct dm_table *t)
Index: linux/drivers/md/dm.c
===================================================================
--- linux.orig/drivers/md/dm.c	2008-10-21 12:16:29.000000000 +0100
+++ linux/drivers/md/dm.c	2008-10-21 12:19:24.000000000 +0100
@@ -671,6 +671,12 @@ static struct bio *split_bvec(struct bio
 	clone->bi_io_vec->bv_len = clone->bi_size;
 	clone->bi_flags |= 1 << BIO_CLONED;
 
+	if (bio_integrity(bio)) {
+		bio_integrity_clone(clone, bio, bs);
+		bio_integrity_trim(clone,
+				   bio_sector_offset(bio, idx, offset), len);
+	}
+
 	return clone;
 }
 
@@ -692,6 +698,14 @@ static struct bio *clone_bio(struct bio 
 	clone->bi_size = to_bytes(len);
 	clone->bi_flags &= ~(1 << BIO_SEG_VALID);
 
+	if (bio_integrity(bio)) {
+		bio_integrity_clone(clone, bio, bs);
+
+		if (idx != bio->bi_idx || clone->bi_size < bio->bi_size)
+			bio_integrity_trim(clone,
+					   bio_sector_offset(bio, idx, 0), len);
+	}
+
 	return clone;
 }
 
@@ -1162,6 +1176,7 @@ static void free_dev(struct mapped_devic
 	mempool_destroy(md->tio_pool);
 	mempool_destroy(md->io_pool);
 	bioset_free(md->bs);
+	blk_integrity_unregister(md->disk);
 	del_gendisk(md->disk);
 	free_minor(minor);
 

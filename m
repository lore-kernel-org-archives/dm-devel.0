From: "Martin K. Petersen" <mkp@mkp.net>
Subject: Re: mirrored device with thousand of mappingtableentries
Date: Thu, 10 Mar 2011 11:11:57 -0500
Message-ID: <yq1aah37y5u.fsf@sermon.lab.mkp.net>
References: <20110228121149.GA3626@agk-dp.fab.redhat.com>
	<E04C10E329E0CD40816C9C17AE53BBD3018639D7@kit001.kaminario.local>
	<20110228131028.GB3626@agk-dp.fab.redhat.com>
	<E04C10E329E0CD40816C9C17AE53BBD301863A00@kit001.kaminario.local>
	<4D6BA566.1050305@redhat.com> <yq1oc5wp5i3.fsf@sermon.lab.mkp.net>
	<4D73F104.2050807@redhat.com> <yq1y64reiu8.fsf@sermon.lab.mkp.net>
	<20110307160914.GA29697@redhat.com>
	<yq1ipvudrzo.fsf@sermon.lab.mkp.net>
	<20110308171322.GB5692@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110308171322.GB5692@redhat.com> (Mike Snitzer's message of
	"Tue, 8 Mar 2011 12:13:42 -0500")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, device-mapper development <dm-devel@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> In general this approach looks fine too.  Doesn't address the
Mike> concern I had yesterday about the blk_integrity block_size
Mike> relative to DM (load vs resume) but I'd imagine you'd like to sort
Mike> that out in a separate patch.

Yeah, that'll come as part of my DIX1.1 patch set.

I believe I've addressed all your issues below.


block: Require subsystems to explicitly allocate bio_set integrity mempool

MD and DM create a new bio_set for every metadevice. Each bio_set has an
integrity mempool attached regardless of whether the metadevice is
capable of passing integrity metadata. This is a waste of memory.

Instead we defer the allocation decision to MD and DM since we know at
metadevice creation time whether integrity passthrough is needed or not.

Automatic integrity mempool allocation can then be removed from
bioset_create() and we make an explicit integrity allocation for the
fs_bio_set.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
Acked-by: Mike Snitzer <snizer@redhat.com>

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 38e4eb1..4e8e314 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -55,6 +55,7 @@ struct dm_table {
 	struct dm_target *targets;
 
 	unsigned discards_supported:1;
+	unsigned integrity_supported:1;
 
 	/*
 	 * Indicates the rw permissions for the new logical
@@ -859,7 +860,7 @@ int dm_table_alloc_md_mempools(struct dm_table *t)
 		return -EINVAL;
 	}
 
-	t->mempools = dm_alloc_md_mempools(type);
+	t->mempools = dm_alloc_md_mempools(type, t->integrity_supported);
 	if (!t->mempools)
 		return -ENOMEM;
 
@@ -935,8 +936,10 @@ static int dm_table_prealloc_integrity(struct dm_table *t, struct mapped_device
 	struct dm_dev_internal *dd;
 
 	list_for_each_entry(dd, devices, list)
-		if (bdev_get_integrity(dd->dm_dev.bdev))
+		if (bdev_get_integrity(dd->dm_dev.bdev)) {
+			t->integrity_supported = 1;
 			return blk_integrity_register(dm_disk(md), NULL);
+		}
 
 	return 0;
 }
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index eaa3af0..105963d 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2643,9 +2643,10 @@ int dm_noflush_suspending(struct dm_target *ti)
 }
 EXPORT_SYMBOL_GPL(dm_noflush_suspending);
 
-struct dm_md_mempools *dm_alloc_md_mempools(unsigned type)
+struct dm_md_mempools *dm_alloc_md_mempools(unsigned type, unsigned integrity)
 {
 	struct dm_md_mempools *pools = kmalloc(sizeof(*pools), GFP_KERNEL);
+	unsigned int pool_size = (type == DM_TYPE_BIO_BASED) ? 16 : MIN_IOS;
 
 	if (!pools)
 		return NULL;
@@ -2662,13 +2663,18 @@ struct dm_md_mempools *dm_alloc_md_mempools(unsigned type)
 	if (!pools->tio_pool)
 		goto free_io_pool_and_out;
 
-	pools->bs = (type == DM_TYPE_BIO_BASED) ?
-		    bioset_create(16, 0) : bioset_create(MIN_IOS, 0);
+	pools->bs = bioset_create(pool_size, 0);
 	if (!pools->bs)
 		goto free_tio_pool_and_out;
 
+	if (integrity && bioset_integrity_create(pools->bs, pool_size))
+		goto free_bioset_and_out;
+
 	return pools;
 
+free_bioset_and_out:
+	bioset_free(pools->bs);
+
 free_tio_pool_and_out:
 	mempool_destroy(pools->tio_pool);
 
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 0c2dd5f..1aaf167 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -149,7 +149,7 @@ void dm_kcopyd_exit(void);
 /*
  * Mempool operations
  */
-struct dm_md_mempools *dm_alloc_md_mempools(unsigned type);
+struct dm_md_mempools *dm_alloc_md_mempools(unsigned type, unsigned integrity);
 void dm_free_md_mempools(struct dm_md_mempools *pools);
 
 #endif
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 0ed7f6b..b317544 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -227,8 +227,7 @@ static int linear_run (mddev_t *mddev)
 	mddev->queue->unplug_fn = linear_unplug;
 	mddev->queue->backing_dev_info.congested_fn = linear_congested;
 	mddev->queue->backing_dev_info.congested_data = mddev;
-	md_integrity_register(mddev);
-	return 0;
+	return md_integrity_register(mddev);
 }
 
 static void free_conf(struct rcu_head *head)
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 818313e..f11e0bc 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1804,8 +1804,12 @@ int md_integrity_register(mddev_t *mddev)
 			mdname(mddev));
 		return -EINVAL;
 	}
-	printk(KERN_NOTICE "md: data integrity on %s enabled\n",
-		mdname(mddev));
+	printk(KERN_NOTICE "md: data integrity enabled on %s\n", mdname(mddev));
+	if (bioset_integrity_create(mddev->bio_set, BIO_POOL_SIZE)) {
+		printk(KERN_ERR "md: failed to create integrity pool for %s\n",
+		       mdname(mddev));
+		return -EINVAL;
+	}
 	return 0;
 }
 EXPORT_SYMBOL(md_integrity_register);
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 3a62d44..54b8d7c 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -345,7 +345,7 @@ static int multipath_remove_disk(mddev_t *mddev, int number)
 			p->rdev = rdev;
 			goto abort;
 		}
-		md_integrity_register(mddev);
+		err = md_integrity_register(mddev);
 	}
 abort:
 
@@ -520,7 +520,10 @@ static int multipath_run (mddev_t *mddev)
 	mddev->queue->unplug_fn = multipath_unplug;
 	mddev->queue->backing_dev_info.congested_fn = multipath_congested;
 	mddev->queue->backing_dev_info.congested_data = mddev;
-	md_integrity_register(mddev);
+
+	if (md_integrity_register(mddev))
+		goto out_free_conf;
+
 	return 0;
 
 out_free_conf:
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index c0ac457..17c001c 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -395,8 +395,7 @@ static int raid0_run(mddev_t *mddev)
 
 	blk_queue_merge_bvec(mddev->queue, raid0_mergeable_bvec);
 	dump_zones(mddev);
-	md_integrity_register(mddev);
-	return 0;
+	return md_integrity_register(mddev);
 }
 
 static int raid0_stop(mddev_t *mddev)
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 06cd712..1cca285 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1178,7 +1178,7 @@ static int raid1_remove_disk(mddev_t *mddev, int number)
 			p->rdev = rdev;
 			goto abort;
 		}
-		md_integrity_register(mddev);
+		err = md_integrity_register(mddev);
 	}
 abort:
 
@@ -2069,8 +2069,7 @@ static int run(mddev_t *mddev)
 	mddev->queue->unplug_fn = raid1_unplug;
 	mddev->queue->backing_dev_info.congested_fn = raid1_congested;
 	mddev->queue->backing_dev_info.congested_data = mddev;
-	md_integrity_register(mddev);
-	return 0;
+	return md_integrity_register(mddev);
 }
 
 static int stop(mddev_t *mddev)
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 747d061..17a2891 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1233,7 +1233,7 @@ static int raid10_remove_disk(mddev_t *mddev, int number)
 			p->rdev = rdev;
 			goto abort;
 		}
-		md_integrity_register(mddev);
+		err = md_integrity_register(mddev);
 	}
 abort:
 
@@ -2395,7 +2395,10 @@ static int run(mddev_t *mddev)
 
 	if (conf->near_copies < conf->raid_disks)
 		blk_queue_merge_bvec(mddev->queue, raid10_mergeable_bvec);
-	md_integrity_register(mddev);
+
+	if (md_integrity_register(mddev))
+		goto out_free_conf;
+
 	return 0;
 
 out_free_conf:
diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index e49cce2..9c5e6b2 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -761,6 +761,9 @@ int bioset_integrity_create(struct bio_set *bs, int pool_size)
 {
 	unsigned int max_slab = vecs_to_idx(BIO_MAX_PAGES);
 
+	if (bs->bio_integrity_pool)
+		return 0;
+
 	bs->bio_integrity_pool =
 		mempool_create_slab_pool(pool_size, bip_slab[max_slab].slab);
 
diff --git a/fs/bio.c b/fs/bio.c
index 5694b75..85e2eab 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1636,9 +1636,6 @@ struct bio_set *bioset_create(unsigned int pool_size, unsigned int front_pad)
 	if (!bs->bio_pool)
 		goto bad;
 
-	if (bioset_integrity_create(bs, pool_size))
-		goto bad;
-
 	if (!biovec_create_pools(bs, pool_size))
 		return bs;
 
@@ -1682,6 +1679,9 @@ static int __init init_bio(void)
 	if (!fs_bio_set)
 		panic("bio: can't allocate bios\n");
 
+	if (bioset_integrity_create(fs_bio_set, BIO_POOL_SIZE))
+		panic("bio: can't create integrity pool\n");
+
 	bio_split_pool = mempool_create_kmalloc_pool(BIO_SPLIT_ENTRIES,
 						     sizeof(struct bio_pair));
 	if (!bio_split_pool)

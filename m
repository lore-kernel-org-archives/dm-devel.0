From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: mirrored device with thousand of mappingtableentries
Date: Sun, 06 Mar 2011 21:59:43 -0500
Message-ID: <yq1y64reiu8.fsf@sermon.lab.mkp.net>
References: <E04C10E329E0CD40816C9C17AE53BBD3018639C2@kit001.kaminario.local>
	<20110228114801.GZ3626@agk-dp.fab.redhat.com>
	<E04C10E329E0CD40816C9C17AE53BBD3018639CE@kit001.kaminario.local>
	<20110228121149.GA3626@agk-dp.fab.redhat.com>
	<E04C10E329E0CD40816C9C17AE53BBD3018639D7@kit001.kaminario.local>
	<20110228131028.GB3626@agk-dp.fab.redhat.com>
	<E04C10E329E0CD40816C9C17AE53BBD301863A00@kit001.kaminario.local>
	<4D6BA566.1050305@redhat.com> <yq1oc5wp5i3.fsf@sermon.lab.mkp.net>
	<4D73F104.2050807@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4D73F104.2050807@redhat.com> (Zdenek Kabelac's message of "Sun,
	06 Mar 2011 21:39:32 +0100")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

>>>>> "Zdenek" == Zdenek Kabelac <zkabelac@redhat.com> writes:

Zdenek> My finding seems to show that BIP-256 slabtop segment grow by
Zdenek> ~73KB per each device (while dm-io is ab out ~26KB)

Ok, I see it now that I tried with a bunch of DM devices.

DM allocates a bioset per volume. And since each bioset has an integrity
mempool you'll end up with a bunch of memory locked down. It seems like
a lot but it's actually the same amount as we reserve for the data path
(bio-0 + biovec-256).

Since a bioset is not necessarily tied to a single block device we can't
automatically decide whether to allocate the integrity pool or not. In
the DM case, however, we just set up the integrity profile so the
information is available.

Can you please try the following patch? This will change things so we
only attach an integrity pool to the bioset if the logical volume is
integrity-capable.

-- 
Martin K. Petersen	Oracle Linux Engineering

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 38e4eb1..37a1b77 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -55,6 +55,7 @@ struct dm_table {
 	struct dm_target *targets;
 
 	unsigned discards_supported:1;
+	unsigned integrity_supported:1;
 
 	/*
 	 * Indicates the rw permissions for the new logical
@@ -859,7 +860,11 @@ int dm_table_alloc_md_mempools(struct dm_table *t)
 		return -EINVAL;
 	}
 
-	t->mempools = dm_alloc_md_mempools(type);
+	if (t->integrity_supported)
+		t->mempools = dm_alloc_md_mempools(type, 0);
+	else
+		t->mempools = dm_alloc_md_mempools(type, BIOSET_NO_INTEGRITY);
+
 	if (!t->mempools)
 		return -ENOMEM;
 
@@ -935,8 +940,10 @@ static int dm_table_prealloc_integrity(struct dm_table *t, struct mapped_device
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
index eaa3af0..f6146b5 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2643,7 +2643,7 @@ int dm_noflush_suspending(struct dm_target *ti)
 }
 EXPORT_SYMBOL_GPL(dm_noflush_suspending);
 
-struct dm_md_mempools *dm_alloc_md_mempools(unsigned type)
+struct dm_md_mempools *dm_alloc_md_mempools(unsigned type, unsigned int flags)
 {
 	struct dm_md_mempools *pools = kmalloc(sizeof(*pools), GFP_KERNEL);
 
@@ -2663,7 +2663,8 @@ struct dm_md_mempools *dm_alloc_md_mempools(unsigned type)
 		goto free_io_pool_and_out;
 
 	pools->bs = (type == DM_TYPE_BIO_BASED) ?
-		    bioset_create(16, 0) : bioset_create(MIN_IOS, 0);
+		bioset_create_flags(16, 0, flags) :
+		bioset_create_flags(MIN_IOS, 0, flags);
 	if (!pools->bs)
 		goto free_tio_pool_and_out;
 
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 0c2dd5f..d846ce0 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -149,7 +149,7 @@ void dm_kcopyd_exit(void);
 /*
  * Mempool operations
  */
-struct dm_md_mempools *dm_alloc_md_mempools(unsigned type);
+struct dm_md_mempools *dm_alloc_md_mempools(unsigned type, unsigned int);
 void dm_free_md_mempools(struct dm_md_mempools *pools);
 
 #endif
diff --git a/fs/bio.c b/fs/bio.c
index 4bd454f..6e4a381 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1603,9 +1603,10 @@ void bioset_free(struct bio_set *bs)
 EXPORT_SYMBOL(bioset_free);
 
 /**
- * bioset_create  - Create a bio_set
+ * bioset_create_flags  - Create a bio_set
  * @pool_size:	Number of bio and bio_vecs to cache in the mempool
  * @front_pad:	Number of bytes to allocate in front of the returned bio
+ * @flags:	Flags that affect memory allocation
  *
  * Description:
  *    Set up a bio_set to be used with @bio_alloc_bioset. Allows the caller
@@ -1615,7 +1616,8 @@ EXPORT_SYMBOL(bioset_free);
  *    Note that the bio must be embedded at the END of that structure always,
  *    or things will break badly.
  */
-struct bio_set *bioset_create(unsigned int pool_size, unsigned int front_pad)
+struct bio_set *bioset_create_flags(unsigned int pool_size,
+				    unsigned int front_pad, unsigned int flags)
 {
 	unsigned int back_pad = BIO_INLINE_VECS * sizeof(struct bio_vec);
 	struct bio_set *bs;
@@ -1636,7 +1638,8 @@ struct bio_set *bioset_create(unsigned int pool_size, unsigned int front_pad)
 	if (!bs->bio_pool)
 		goto bad;
 
-	if (bioset_integrity_create(bs, pool_size))
+	if ((flags & BIOSET_NO_INTEGRITY) == 0 &&
+	    bioset_integrity_create(bs, pool_size))
 		goto bad;
 
 	if (!biovec_create_pools(bs, pool_size))
@@ -1646,6 +1649,12 @@ bad:
 	bioset_free(bs);
 	return NULL;
 }
+EXPORT_SYMBOL(bioset_create_flags);
+
+struct bio_set *bioset_create(unsigned int pool_size, unsigned int front_pad)
+{
+	return bioset_create_flags(pool_size, front_pad, 0);
+}
 EXPORT_SYMBOL(bioset_create);
 
 static void __init biovec_init_slabs(void)
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 35dcdb3..2f758f3 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -208,7 +208,12 @@ struct bio_pair {
 extern struct bio_pair *bio_split(struct bio *bi, int first_sectors);
 extern void bio_pair_release(struct bio_pair *dbio);
 
+enum bioset_flags {
+	BIOSET_NO_INTEGRITY	= (1 << 0),
+};
+
 extern struct bio_set *bioset_create(unsigned int, unsigned int);
+extern struct bio_set *bioset_create_flags(unsigned int, unsigned int, unsigned int);
 extern void bioset_free(struct bio_set *);
 
 extern struct bio *bio_alloc(gfp_t, int);

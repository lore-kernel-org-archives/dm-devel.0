From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH 1/1] dm: add clone target
Date: Thu, 29 Aug 2019 12:19:30 -0400
Message-ID: <20190829161929.GA34247@lobo>
References: <20190709141522.29606-1-ntsironis@arrikto.com>
	<20190709141522.29606-2-ntsironis@arrikto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20190709141522.29606-2-ntsironis@arrikto.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Nikos Tsironis <ntsironis@arrikto.com>
Cc: vkoukis@arrikto.com, dm-devel@redhat.com, agk@redhat.com, iliastsi@arrikto.com
List-Id: dm-devel.ids

On Tue, Jul 09 2019 at 10:15am -0400,
Nikos Tsironis <ntsironis@arrikto.com> wrote:

> Add the dm-clone target, which allows cloning of arbitrary block
> devices.
> 
> dm-clone produces a one-to-one copy of an existing, read-only device
> (origin) into a writable device (clone): It presents a virtual block
> device which makes all data appear immediately, and redirects reads and
> writes accordingly.
> 
> The main use case of dm-clone is to clone a potentially remote,
> high-latency, read-only, archival-type block device into a writable,
> fast, primary-type device for fast, low-latency I/O. The cloned device
> is visible/mountable immediately and the copy of the origin device to
> the clone device happens in the background, in parallel with user I/O.
> 
> When the cloning completes, the dm-clone table can be removed altogether
> and be replaced, e.g., by a linear table, mapping directly to the clone
> device.
> 
> For further information and examples of how to use dm-clone, please read
> Documentation/device-mapper/dm-clone.rst
> 
> Suggested-by: Vangelis Koukis <vkoukis@arrikto.com>
> Co-developed-by: Ilias Tsitsimpis <iliastsi@arrikto.com>
> Signed-off-by: Ilias Tsitsimpis <iliastsi@arrikto.com>
> Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
> ---
>  Documentation/device-mapper/dm-clone.rst |  334 +++++
>  drivers/md/Kconfig                       |   13 +
>  drivers/md/Makefile                      |    2 +
>  drivers/md/dm-clone-metadata.c           |  991 +++++++++++++
>  drivers/md/dm-clone-metadata.h           |  158 +++
>  drivers/md/dm-clone-target.c             | 2244 ++++++++++++++++++++++++++++++
>  6 files changed, 3742 insertions(+)
>  create mode 100644 Documentation/device-mapper/dm-clone.rst
>  create mode 100644 drivers/md/dm-clone-metadata.c
>  create mode 100644 drivers/md/dm-clone-metadata.h
>  create mode 100644 drivers/md/dm-clone-target.c
> 
> diff --git a/Documentation/device-mapper/dm-clone.rst b/Documentation/device-mapper/dm-clone.rst
> new file mode 100644
> index 000000000000..948b7ce31ce3
> --- /dev/null
> +++ b/Documentation/device-mapper/dm-clone.rst
> @@ -0,0 +1,334 @@
> +.. SPDX-License-Identifier: GPL-2.0-only
> +
> +========
> +dm-clone
> +========
> +
> +Introduction
> +============
> +
> +dm-clone is a device mapper target which produces a one-to-one copy of an
> +existing, read-only device (origin) into a writable device (clone): It presents
> +a virtual block device which makes all data appear immediately, and redirects
> +reads and writes accordingly.
> +
> +The main use case of dm-clone is to clone a potentially remote, high-latency,
> +read-only, archival-type block device into a writable, fast, primary-type device
> +for fast, low-latency I/O. The cloned device is visible/mountable immediately
> +and the copy of the origin device to the clone device happens in the background,
> +in parallel with user I/O.
> +
> +For example, one could restore an application backup from a read-only copy,
> +accessible through a network storage protocol (NBD, Fibre Channel, iSCSI, AoE,
> +etc.), into a local SSD or NVMe device, and start using the device immediately,
> +without waiting for the restore to complete.
> +
> +When the cloning completes, the dm-clone table can be removed altogether and be
> +replaced, e.g., by a linear table, mapping directly to the clone device.
> +
> +The dm-clone target reuses the metadata library used by the thin-provisioning
> +target.
> +
> +Glossary
> +========
> +
> +   Region
> +     A fixed sized block. The unit of hydration.
> +
> +   Hydration
> +     The process of filling a region of the clone device with data from the same
> +     region of the origin device, i.e., copying the region from the origin to
> +     the clone device.
> +
> +Once a region gets hydrated we redirect all I/O regarding it to the clone
> +device.

There is a lot of awkward jargon that you're mixing into this target.

Why "region" and not "block"?  I can let "region" go but please be
consistent (don't fall back to calling a region a block anywhere).

Why "hydration"?  Just needed to call it _something_?  I can let it go
as long as it is a construct internal to the target's implementation.  I
see no point making consumers of this target, that copies data from a
source to destination, have to call something "hydration".

And while we're at it why "origin" device instead of "source"?
Why "clone" device instead of "dest" or "destination"?

I can give the target name "dm-clone" a pass.. but dm-copy is less
opaque IMHO.. I could go either way on those.


> +Background Hydration
> +--------------------
> +
> +dm-clone copies continuously from the origin to the clone device, until all of
> +the device has been copied.
> +
> +Copying data from the origin to the clone device uses bandwidth. The user can
> +set a throttle to prevent more than a certain amount of copying occurring at any
> +one time. Moreover, dm-clone takes into account user I/O traffic going to the
> +devices and pauses the background hydration when there is I/O in-flight.
> +
> +A message `hydration_threshold <#sectors>` can be used to set the maximum number
> +of sectors being copied, the default being 2048 sectors (1MB).

Think this should really be expressed in multiples of a region, e.g.:
copy_threshold <# regions> (or clone_threshold)

> +dm-clone employs dm-kcopyd for copying portions of the origin device to the
> +clone device. By default, we issue copy requests of size equal to the region
> +size. A message `hydration_block_size <#sectors>` can be used to tune the size
> +of these copy requests. Increasing the hydration block size results in dm-clone
> +trying to batch together contiguous regions, so we copy the data in blocks of
> +this size.

It is awkward to have 'hydration_block_size' vs target ctr
provided "region size".  copy_batch_size <# regions>?  (or
clone_batch_size)?

Please take care of the external facing documentation to not use
"hydration".  Of all the naming I dislike it the most.. sorry.

Also, please fold the following patch in before making any edits to the
.c files for v2.

This review pass is the most trivial of the high level review, I'll be
drilling in on other aspects of the implementation now.  But I suspect
you've done a solid job with those details (based on what I've seen so
far).

Thanks,
Mike

From 5cc5479c68f87876d7aaf796d611a69d8e645618 Mon Sep 17 00:00:00 2001
From: Mike Snitzer <snitzer@redhat.com>
Date: Tue, 27 Aug 2019 17:00:24 -0400
Subject: [PATCH] dm clone: remove needless empty newlines

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-clone-metadata.c | 35 +++---------------------
 drivers/md/dm-clone-target.c   | 61 +++---------------------------------------
 2 files changed, 7 insertions(+), 89 deletions(-)

diff --git a/drivers/md/dm-clone-metadata.c b/drivers/md/dm-clone-metadata.c
index db2f86d8356b..77480e94532b 100644
--- a/drivers/md/dm-clone-metadata.c
+++ b/drivers/md/dm-clone-metadata.c
@@ -184,7 +184,6 @@ static int sb_check(struct dm_block_validator *v, struct dm_block *b,
 
 	csum = dm_bm_checksum(&sb->flags, sb_block_size - sizeof(__le32),
 			      SUPERBLOCK_CSUM_XOR);
-
 	if (sb->csum != cpu_to_le32(csum)) {
 		DMERR("Superblock check failed: checksum %u, expected %u",
 		      csum, le32_to_cpu(sb->csum));
@@ -193,7 +192,6 @@ static int sb_check(struct dm_block_validator *v, struct dm_block *b,
 
 	/* Check metadata version */
 	metadata_version = le32_to_cpu(sb->version);
-
 	if (metadata_version < DM_CLONE_MIN_METADATA_VERSION ||
 	    metadata_version > DM_CLONE_MAX_METADATA_VERSION) {
 		DMERR("Clone metadata version %u found, but only versions between %u and %u supported.",
@@ -227,7 +225,6 @@ static int __superblock_all_zeroes(struct dm_block_manager *bm, bool *formatted)
 	 * zeroes.
 	 */
 	r = dm_bm_read_lock(bm, SUPERBLOCK_LOCATION, NULL, &sblock);
-
 	if (r) {
 		DMERR("Failed to read_lock superblock");
 		return r;
@@ -280,7 +277,6 @@ static int __copy_sm_root(struct dm_clone_metadata *md)
 	size_t root_size;
 
 	r = dm_sm_root_size(md->sm, &root_size);
-
 	if (r)
 		return r;
 
@@ -357,7 +353,6 @@ static int __format_metadata(struct dm_clone_metadata *md)
 	struct superblock_disk *sb;
 
 	r = dm_tm_create_with_sm(md->bm, SUPERBLOCK_LOCATION, &md->tm, &md->sm);
-
 	if (r) {
 		DMERR("Failed to create transaction manager");
 		return r;
@@ -366,7 +361,6 @@ static int __format_metadata(struct dm_clone_metadata *md)
 	dm_disk_bitset_init(md->tm, &md->bitset_info);
 
 	r = dm_bitset_empty(&md->bitset_info, &md->bitset_root);
-
 	if (r) {
 		DMERR("Failed to create empty on-disk bitset");
 		goto err_with_tm;
@@ -374,7 +368,6 @@ static int __format_metadata(struct dm_clone_metadata *md)
 
 	r = dm_bitset_resize(&md->bitset_info, md->bitset_root, 0,
 			     md->nr_regions, false, &md->bitset_root);
-
 	if (r) {
 		DMERR("Failed to resize on-disk bitset to %lu entries", md->nr_regions);
 		goto err_with_tm;
@@ -382,21 +375,18 @@ static int __format_metadata(struct dm_clone_metadata *md)
 
 	/* Flush to disk all blocks, except the superblock */
 	r = dm_tm_pre_commit(md->tm);
-
 	if (r) {
 		DMERR("dm_tm_pre_commit failed");
 		goto err_with_tm;
 	}
 
 	r = __copy_sm_root(md);
-
 	if (r) {
 		DMERR("__copy_sm_root failed");
 		goto err_with_tm;
 	}
 
 	r = superblock_write_lock_zero(md, &sblock);
-
 	if (r) {
 		DMERR("Failed to write_lock superblock");
 		goto err_with_tm;
@@ -405,7 +395,6 @@ static int __format_metadata(struct dm_clone_metadata *md)
 	sb = dm_block_data(sblock);
 	__prepare_superblock(md, sb);
 	r = dm_tm_commit(md->tm, sblock);
-
 	if (r) {
 		DMERR("Failed to commit superblock");
 		goto err_with_tm;
@@ -426,7 +415,6 @@ static int __open_or_format_metadata(struct dm_clone_metadata *md, bool may_form
 	bool formatted = false;
 
 	r = __superblock_all_zeroes(md->bm, &formatted);
-
 	if (r)
 		return r;
 
@@ -445,14 +433,12 @@ static int __create_persistent_data_structures(struct dm_clone_metadata *md,
 	md->bm = dm_block_manager_create(md->bdev,
 					 DM_CLONE_METADATA_BLOCK_SIZE << SECTOR_SHIFT,
 					 DM_CLONE_MAX_CONCURRENT_LOCKS);
-
 	if (IS_ERR(md->bm)) {
 		DMERR("Failed to create block manager");
 		return PTR_ERR(md->bm);
 	}
 
 	r = __open_or_format_metadata(md, may_format_device);
-
 	if (r)
 		dm_block_manager_destroy(md->bm);
 
@@ -511,12 +497,10 @@ int __load_bitset_in_core(struct dm_clone_metadata *md)
 
 	/* Flush bitset cache */
 	r = dm_bitset_flush(&md->bitset_info, md->bitset_root, &md->bitset_root);
-
 	if (r)
 		return r;
 
 	r = dm_bitset_cursor_begin(&md->bitset_info, md->bitset_root, md->nr_regions, &c);
-
 	if (r)
 		return r;
 
@@ -548,7 +532,6 @@ struct dm_clone_metadata *dm_clone_metadata_open(struct block_device *bdev,
 	struct dm_clone_metadata *md;
 
 	md = kzalloc(sizeof(*md), GFP_KERNEL);
-
 	if (!md) {
 		DMERR("Failed to allocate memory for dm-clone metadata");
 		return ERR_PTR(-ENOMEM);
@@ -567,7 +550,6 @@ struct dm_clone_metadata *dm_clone_metadata_open(struct block_device *bdev,
 	md->hydration_done = false;
 
 	md->region_map = vmalloc(bitmap_size(md->nr_regions));
-
 	if (!md->region_map) {
 		DMERR("Failed to allocate memory for region bitmap");
 		r = -ENOMEM;
@@ -575,19 +557,16 @@ struct dm_clone_metadata *dm_clone_metadata_open(struct block_device *bdev,
 	}
 
 	r = __create_persistent_data_structures(md, true);
-
 	if (r)
 		goto out_with_region_map;
 
 	r = __load_bitset_in_core(md);
-
 	if (r) {
 		DMERR("Failed to load on-disk region map");
 		goto out_with_pds;
 	}
 
 	r = dirty_map_init(md);
-
 	if (r)
 		goto out_with_pds;
 
@@ -682,7 +661,6 @@ int __metadata_commit(struct dm_clone_metadata *md)
 
 	/* Flush bitset cache */
 	r = dm_bitset_flush(&md->bitset_info, md->bitset_root, &md->bitset_root);
-
 	if (r) {
 		DMERR("dm_bitset_flush failed");
 		return r;
@@ -690,7 +668,6 @@ int __metadata_commit(struct dm_clone_metadata *md)
 
 	/* Flush to disk all blocks, except the superblock */
 	r = dm_tm_pre_commit(md->tm);
-
 	if (r) {
 		DMERR("dm_tm_pre_commit failed");
 		return r;
@@ -698,7 +675,6 @@ int __metadata_commit(struct dm_clone_metadata *md)
 
 	/* Save the space map root in md->metadata_space_map_root */
 	r = __copy_sm_root(md);
-
 	if (r) {
 		DMERR("__copy_sm_root failed");
 		return r;
@@ -706,7 +682,6 @@ int __metadata_commit(struct dm_clone_metadata *md)
 
 	/* Lock the superblock */
 	r = superblock_write_lock_zero(md, &sblock);
-
 	if (r) {
 		DMERR("Failed to write_lock superblock");
 		return r;
@@ -718,7 +693,6 @@ int __metadata_commit(struct dm_clone_metadata *md)
 
 	/* Unlock superblock and commit it to disk */
 	r = dm_tm_commit(md->tm, sblock);
-
 	if (r) {
 		DMERR("Failed to commit superblock");
 		return r;
@@ -859,7 +833,6 @@ int dm_clone_cond_set_range(struct dm_clone_metadata *md, unsigned long start,
 			dmap->changed = 1;
 		}
 	}
-
 out:
 	spin_unlock_irqrestore(&md->bitmap_lock, flags);
 
@@ -886,7 +859,6 @@ int dm_clone_reload_in_core_bitset(struct dm_clone_metadata *md)
 		goto out;
 
 	r = __load_bitset_in_core(md);
-
 out:
 	up_write(&md->lock);
 
@@ -917,11 +889,10 @@ int dm_clone_metadata_abort(struct dm_clone_metadata *md)
 	__destroy_persistent_data_structures(md);
 
 	r = __create_persistent_data_structures(md, false);
-
-	/* If something went wrong we can neither write nor read the metadata */
-	if (r)
+	if (r) {
+		/* If something went wrong we can neither write nor read the metadata */
 		md->fail_io = true;
-
+	}
 out:
 	up_write(&md->lock);
 
diff --git a/drivers/md/dm-clone-target.c b/drivers/md/dm-clone-target.c
index 2ce7524616f8..d10b149b54f5 100644
--- a/drivers/md/dm-clone-target.c
+++ b/drivers/md/dm-clone-target.c
@@ -459,11 +459,9 @@ static void complete_discard_bio(struct clone *clone, struct bio *bio, bool succ
 		bio_region_range(clone, bio, &rs, &re);
 		trim_bio(bio, rs << clone->region_shift,
 			 (re - rs) << clone->region_shift);
-
 		generic_make_request(bio);
-	} else {
+	} else
 		bio_endio(bio);
-	}
 }
 
 static void process_discard_bio(struct clone *clone, struct bio *bio)
@@ -561,7 +559,6 @@ static int hash_table_init(struct clone *clone)
 	sz = 1 << HASH_TABLE_BITS;
 
 	clone->ht = vmalloc(sz * sizeof(struct hash_table_bucket));
-
 	if (!clone->ht)
 		return -ENOMEM;
 
@@ -629,7 +626,6 @@ __find_or_insert_region_hydration(struct hash_table_bucket *bucket,
 	struct dm_clone_region_hydration *hd2;
 
 	hd2 = __hash_find(bucket, hd->region_nr);
-
 	if (hd2)
 		return hd2;
 
@@ -650,7 +646,6 @@ static struct dm_clone_region_hydration *alloc_hydration(struct clone *clone)
 	 * This might block but it can't fail.
 	 */
 	hd = mempool_alloc(&clone->hydration_pool, GFP_NOIO);
-
 	hd->clone = clone;
 
 	return hd;
@@ -665,11 +660,8 @@ static inline void free_hydration(struct dm_clone_region_hydration *hd)
 static void hydration_init(struct dm_clone_region_hydration *hd, unsigned long region_nr)
 {
 	hd->region_nr = region_nr;
-
 	hd->overwrite_bio = NULL;
-
 	bio_list_init(&hd->deferred_bios);
-
 	hd->status = 0;
 
 	INIT_LIST_HEAD(&hd->list);
@@ -867,16 +859,15 @@ static void hydrate_bio_region(struct clone *clone, struct bio *bio)
 	bucket_lock_irqsave(bucket, flags);
 
 	hd = __hash_find(bucket, region_nr);
-
-	/* Someone else is hydrating the region */
 	if (hd) {
+		/* Someone else is hydrating the region */
 		bio_list_add(&hd->deferred_bios, bio);
 		bucket_unlock_irqrestore(bucket, flags);
 		return;
 	}
 
-	/* The region has been hydrated */
 	if (dm_clone_is_region_hydrated(clone->md, region_nr)) {
+		/* The region has been hydrated */
 		bucket_unlock_irqrestore(bucket, flags);
 		issue_bio(clone, bio);
 		return;
@@ -902,9 +893,8 @@ static void hydrate_bio_region(struct clone *clone, struct bio *bio)
 	}
 
 	hd2 = __find_or_insert_region_hydration(bucket, hd);
-
-	/* Someone else started the region's hydration. */
 	if (hd2 != hd) {
+		/* Someone else started the region's hydration. */
 		bio_list_add(&hd2->deferred_bios, bio);
 		bucket_unlock_irqrestore(bucket, flags);
 		free_hydration(hd);
@@ -937,7 +927,6 @@ static void hydrate_bio_region(struct clone *clone, struct bio *bio)
 	} else {
 		bio_list_add(&hd->deferred_bios, bio);
 		bucket_unlock_irqrestore(bucket, flags);
-
 		hydration_copy(hd, 1);
 	}
 }
@@ -1138,7 +1127,6 @@ static int commit_metadata(struct clone *clone)
 
 	if (dm_clone_is_hydration_done(clone->md))
 		dm_table_event(clone->ti->table);
-
 out:
 	mutex_unlock(&clone->commit_lock);
 
@@ -1177,13 +1165,10 @@ static void process_deferred_discards(struct clone *clone)
 		if (unlikely(r))
 			break;
 	}
-
 out:
 	blk_start_plug(&plug);
-
 	while ((bio = bio_list_pop(&discards)))
 		complete_discard_bio(clone, bio, r == 0);
-
 	blk_finish_plug(&plug);
 }
 
@@ -1530,7 +1515,6 @@ static int parse_feature_args(struct dm_arg_set *as, struct clone *clone)
 		return 0;
 
 	r = dm_read_arg_group(&args, as, &argc, &ti->error);
-
 	if (r)
 		return r;
 
@@ -1575,7 +1559,6 @@ static int parse_core_args(struct dm_arg_set *as, struct clone *clone)
 		return 0;
 
 	r = dm_read_arg_group(&args, as, &argc, &ti->error);
-
 	if (r)
 		return r;
 
@@ -1620,7 +1603,6 @@ static int parse_region_size(struct clone *clone, struct dm_arg_set *as, char **
 	arg.error = "Invalid region size";
 
 	r = dm_read_arg(&arg, as, &region_size, error);
-
 	if (r)
 		return r;
 
@@ -1664,14 +1646,12 @@ static int parse_metadata_dev(struct clone *clone, struct dm_arg_set *as, char *
 
 	r = dm_get_device(clone->ti, dm_shift_arg(as), FMODE_READ | FMODE_WRITE,
 			  &clone->metadata_dev);
-
 	if (r) {
 		*error = "Error opening metadata device";
 		return r;
 	}
 
 	metadata_dev_size = get_dev_size(clone->metadata_dev);
-
 	if (metadata_dev_size > DM_CLONE_METADATA_MAX_SECTORS_WARNING)
 		DMWARN("Metadata device %s is larger than %u sectors: excess space will not be used.",
 		       bdevname(clone->metadata_dev->bdev, b), DM_CLONE_METADATA_MAX_SECTORS);
@@ -1686,17 +1666,14 @@ static int parse_clone_dev(struct clone *clone, struct dm_arg_set *as, char **er
 
 	r = dm_get_device(clone->ti, dm_shift_arg(as), FMODE_READ | FMODE_WRITE,
 			  &clone->clone_dev);
-
 	if (r) {
 		*error = "Error opening clone device";
 		return r;
 	}
 
 	clone_dev_size = get_dev_size(clone->clone_dev);
-
 	if (clone_dev_size < clone->ti->len) {
 		dm_put_device(clone->ti, clone->clone_dev);
-
 		*error = "Device size larger than clone device";
 		return -EINVAL;
 	}
@@ -1711,17 +1688,14 @@ static int parse_origin_dev(struct clone *clone, struct dm_arg_set *as, char **e
 
 	r = dm_get_device(clone->ti, dm_shift_arg(as), FMODE_READ,
 			  &clone->origin_dev);
-
 	if (r) {
 		*error = "Error opening origin device";
 		return r;
 	}
 
 	origin_dev_size = get_dev_size(clone->origin_dev);
-
 	if (origin_dev_size < clone->ti->len) {
 		dm_put_device(clone->ti, clone->origin_dev);
-
 		*error = "Device size larger than origin device";
 		return -EINVAL;
 	}
@@ -1735,7 +1709,6 @@ static int copy_ctr_args(struct clone *clone, int argc, const char **argv, char
 	const char **copy;
 
 	copy = kcalloc(argc, sizeof(*copy), GFP_KERNEL);
-
 	if (!copy)
 		goto error;
 
@@ -1752,7 +1725,6 @@ static int copy_ctr_args(struct clone *clone, int argc, const char **argv, char
 
 	clone->nr_ctr_args = argc;
 	clone->ctr_args = copy;
-
 	return 0;
 
 error:
@@ -1775,7 +1747,6 @@ static int clone_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	as.argv = argv;
 
 	clone = kzalloc(sizeof(*clone), GFP_KERNEL);
-
 	if (!clone) {
 		ti->error = "Failed to allocate clone structure";
 		return -ENOMEM;
@@ -1789,22 +1760,18 @@ static int clone_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	__set_bit(DM_CLONE_DISCARD_PASSDOWN, &clone->flags);
 
 	r = parse_metadata_dev(clone, &as, &ti->error);
-
 	if (r)
 		goto out_with_clone;
 
 	r = parse_clone_dev(clone, &as, &ti->error);
-
 	if (r)
 		goto out_with_meta_dev;
 
 	r = parse_origin_dev(clone, &as, &ti->error);
-
 	if (r)
 		goto out_with_clone_dev;
 
 	r = parse_region_size(clone, &as, &ti->error);
-
 	if (r)
 		goto out_with_origin_dev;
 
@@ -1812,31 +1779,26 @@ static int clone_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	clone->nr_regions = dm_sector_div_up(ti->len, clone->region_size);
 
 	r = validate_nr_regions(clone->nr_regions, &ti->error);
-
 	if (r)
 		goto out_with_origin_dev;
 
 	r = dm_set_target_max_io_len(ti, clone->region_size);
-
 	if (r) {
 		ti->error = "Failed to set max io len";
 		goto out_with_origin_dev;
 	}
 
 	r = parse_feature_args(&as, clone);
-
 	if (r)
 		goto out_with_origin_dev;
 
 	r = parse_core_args(&as, clone);
-
 	if (r)
 		goto out_with_origin_dev;
 
 	/* Load metadata */
 	clone->md = dm_clone_metadata_open(clone->metadata_dev->bdev, ti->len,
 					   clone->region_size);
-
 	if (IS_ERR(clone->md)) {
 		ti->error = "Failed to load metadata";
 		r = PTR_ERR(clone->md);
@@ -1855,7 +1817,6 @@ static int clone_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	/* Allocate hydration hash table */
 	r = hash_table_init(clone);
-
 	if (r) {
 		ti->error = "Failed to allocate hydration hash table";
 		goto out_with_metadata;
@@ -1872,7 +1833,6 @@ static int clone_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	atomic_set(&clone->hydrations_in_flight, 0);
 
 	clone->wq = alloc_workqueue("dm-" DM_MSG_PREFIX, WQ_MEM_RECLAIM, 0);
-
 	if (!clone->wq) {
 		ti->error = "Failed to allocate workqueue";
 		r = -ENOMEM;
@@ -1883,7 +1843,6 @@ static int clone_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	INIT_DELAYED_WORK(&clone->waker, do_waker);
 
 	clone->kcopyd_client = dm_kcopyd_client_create(&dm_kcopyd_throttle);
-
 	if (IS_ERR(clone->kcopyd_client)) {
 		r = PTR_ERR(clone->kcopyd_client);
 		goto out_with_wq;
@@ -1891,7 +1850,6 @@ static int clone_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	r = mempool_init_slab_pool(&clone->hydration_pool, MIN_HYDRATIONS,
 				   _hydration_cache);
-
 	if (r) {
 		ti->error = "Failed to create dm_clone_region_hydration memory pool";
 		goto out_with_kcopyd;
@@ -1899,7 +1857,6 @@ static int clone_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	/* Save a copy of the table line */
 	r = copy_ctr_args(clone, argc - 3, (const char **)argv + 3, &ti->error);
-
 	if (r)
 		goto out_with_mempool;
 
@@ -1921,28 +1878,20 @@ static int clone_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 out_with_mempool:
 	mempool_exit(&clone->hydration_pool);
-
 out_with_kcopyd:
 	dm_kcopyd_client_destroy(clone->kcopyd_client);
-
 out_with_wq:
 	destroy_workqueue(clone->wq);
-
 out_with_ht:
 	hash_table_exit(clone);
-
 out_with_metadata:
 	dm_clone_metadata_close(clone->md);
-
 out_with_origin_dev:
 	dm_put_device(ti, clone->origin_dev);
-
 out_with_clone_dev:
 	dm_put_device(ti, clone->clone_dev);
-
 out_with_meta_dev:
 	dm_put_device(ti, clone->metadata_dev);
-
 out_with_clone:
 	kfree(clone);
 
@@ -2213,12 +2162,10 @@ static int __init dm_clone_init(void)
 	int r;
 
 	_hydration_cache = KMEM_CACHE(dm_clone_region_hydration, 0);
-
 	if (!_hydration_cache)
 		return -ENOMEM;
 
 	r = dm_register_target(&clone_target);
-
 	if (r < 0) {
 		DMERR("Failed to register clone target");
 		return r;
-- 
2.15.0

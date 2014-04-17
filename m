From: Vasily Tarasov <tarasov@vasily.name>
Subject: [PATCH RFC 02/10] dm-dedup: core deduplication logic
Date: Thu, 17 Apr 2014 16:00:17 -0400
Message-ID: <535ed0d5.ea5e8c0a.8d16.ffffc7fc@mx.google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Christoph Hellwig <hch@infradead.org>, Philip Shilane <philip.shilane@emc.com>, Sonam Mandal <sonam.dp42@gmail.com>, Erez Zadok <ezk@fsl.cs.sunysb.edu>
List-Id: dm-devel.ids

The implementation of the constructor, destructor, and map functions.

The map function just puts all I/O requests in a work queue.  For reads,
the worker thread locates Physical Block Numbers (PBNs) in the
LBN-to-PBN mapping and remaps the I/O there.  If PBN is not found, a
block of zeroes is returned.

For writes, the worker thread computes the hash of a block and tries to
find the hash in the HASH-to-PBN mapping. If the hash is found, only the
LBN-to-PBN mapping needs to be updated. If the hash is not found, the
request is remapped to the new location on the data device and both
LBN-to-PBN and HASH-to-PBN mappings are updated.

Signed-off-by: Vasily Tarasov <tarasov@vasily.name>
---
 drivers/md/dm-dedup-target.c |  726 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 726 insertions(+), 0 deletions(-)
 create mode 100644 drivers/md/dm-dedup-target.c

diff --git a/drivers/md/dm-dedup-target.c b/drivers/md/dm-dedup-target.c
new file mode 100644
index 0000000..3b3b9ca
--- /dev/null
+++ b/drivers/md/dm-dedup-target.c
@@ -0,0 +1,726 @@
+/*
+ * Copyright (C) 2012-2014 Vasily Tarasov
+ * Copyright (C) 2012-2014 Geoff Kuenning
+ * Copyright (C) 2012-2014 Sonam Mandal
+ * Copyright (C) 2012-2014 Karthikeyani Palanisami
+ * Copyright (C) 2012-2014 Philip Shilane
+ * Copyright (C) 2012-2014 Sagar Trehan
+ * Copyright (C) 2012-2014 Erez Zadok
+ *
+ * This file is released under the GPL.
+ */
+
+#include "dm-dedup-target.h"
+#include "dm-dedup-rw.h"
+#include "dm-dedup-hash.h"
+#include "dm-dedup-backend.h"
+#include "dm-dedup-ram.h"
+#include "dm-dedup-cbt.h"
+#include "dm-dedup-kvstore.h"
+
+#define MAX_DEV_NAME_LEN 64
+
+struct on_disk_stats {
+	uint64_t physical_block_counter;
+	uint64_t logical_block_counter;
+};
+
+/*
+ * All incoming requests are packed in the dedup_work structure
+ * for further processing by the workqueue thread.
+ */
+struct dedup_work {
+	struct work_struct worker;
+	struct dedup_config *config;
+	struct bio *bio;
+};
+
+struct mark_and_sweep_data {
+	unsigned long *bitmap;
+	uint64_t bitmap_len;
+	uint64_t cleanup_count; /* number of hashes cleaned up */
+	struct dedup_config *dc;
+};
+
+enum backend {
+	BKND_INRAM,
+	BKND_COWBTREE
+};
+
+static void bio_zero_endio(struct bio *bio)
+{
+	zero_fill_bio(bio);
+	bio_endio(bio, 0);
+}
+
+static uint64_t bio_lbn(struct dedup_config *dc, struct bio *bio)
+{
+	return bio->bi_iter.bi_sector / dc->sectors_per_block;
+}
+
+static void do_io(struct dedup_config *dc, struct bio *bio,
+		  uint64_t pbn)
+{
+	int offset;
+
+	offset = (sector_t) bio->bi_iter.bi_sector % dc->sectors_per_block;
+	bio->bi_iter.bi_sector = (sector_t)pbn * dc->sectors_per_block + offset;
+
+	bio->bi_bdev = dc->data_dev->bdev;
+
+	generic_make_request(bio);
+}
+
+static void handle_read(struct dedup_config *dc, struct bio *bio)
+{
+	uint64_t lbn;
+	uint32_t vsize;
+	struct lbn_pbn_value lbnpbn_value;
+	int r;
+
+	lbn = bio_lbn(dc, bio);
+
+	r = dc->kvs_lbn_pbn->kvs_lookup(dc->kvs_lbn_pbn, (void *)&lbn,
+			sizeof(lbn), (void *)&lbnpbn_value, &vsize);
+	if (r == 0)
+		bio_zero_endio(bio);
+	else if (r == 1)
+		do_io(dc, bio, lbnpbn_value.pbn);
+	else
+		BUG();
+}
+
+static int allocate_block(struct dedup_config *dc, uint64_t *pbn_new)
+{
+	int r;
+
+	r = dc->mdops->alloc_data_block(dc->bmd, pbn_new);
+
+	if (!r) {
+		dc->logical_block_counter++;
+		dc->physical_block_counter++;
+	}
+
+	return r;
+}
+
+static int write_to_new_block(struct dedup_config *dc, uint64_t *pbn_new,
+			      struct bio *bio, uint64_t lbn)
+{
+	int r = 0;
+	struct lbn_pbn_value lbnpbn_value;
+
+	r = allocate_block(dc, pbn_new);
+	if (r < 0) {
+		r = -EIO;
+		return r;
+	}
+
+	lbnpbn_value.pbn = *pbn_new;
+
+	do_io(dc, bio, *pbn_new);
+
+	r = dc->kvs_lbn_pbn->kvs_insert(dc->kvs_lbn_pbn, (void *)&lbn,
+		sizeof(lbn), (void *)&lbnpbn_value, sizeof(lbnpbn_value));
+	if (r < 0)
+		BUG();
+
+	return r;
+}
+
+static int handle_write_no_hash(struct dedup_config *dc,
+			struct bio *bio, uint64_t lbn, u8 *hash)
+{
+	int r;
+	uint32_t vsize;
+	uint64_t pbn_new, pbn_old;
+	struct lbn_pbn_value lbnpbn_value;
+	struct hash_pbn_value hashpbn_value;
+
+	dc->uniqwrites++;
+
+	r = dc->kvs_lbn_pbn->kvs_lookup(dc->kvs_lbn_pbn, (void *)&lbn,
+			sizeof(lbn), (void *)&lbnpbn_value, &vsize);
+	if (r == 0) {
+		/* No LBN->PBN mapping entry */
+		dc->newwrites++;
+		r = write_to_new_block(dc, &pbn_new, bio, lbn);
+		if (r < 0)
+			goto out;
+
+		hashpbn_value.pbn = pbn_new;
+
+		r = dc->kvs_hash_pbn->kvs_insert(dc->kvs_hash_pbn, (void *)hash,
+				dc->crypto_key_size, (void *)&hashpbn_value,
+				sizeof(hashpbn_value));
+		if (r < 0)
+			BUG();
+
+		r = dc->mdops->inc_refcount(dc->bmd, pbn_new);
+		if (r < 0)
+			BUG();
+
+		goto out;
+	} else if (r < 0)
+		BUG();
+
+	/* LBN->PBN mappings exist */
+	dc->overwrites++;
+	r = write_to_new_block(dc, &pbn_new, bio, lbn);
+	if (r < 0)
+		goto out;
+
+	pbn_old = lbnpbn_value.pbn;
+	r = dc->mdops->dec_refcount(dc->bmd, pbn_old);
+	if (r < 0)
+		BUG();
+
+	dc->logical_block_counter--;
+
+	hashpbn_value.pbn = pbn_new;
+
+	r = dc->kvs_hash_pbn->kvs_insert(dc->kvs_hash_pbn, (void *)hash,
+				dc->crypto_key_size, (void *)&hashpbn_value,
+				sizeof(hashpbn_value));
+	if (r < 0)
+		BUG();
+
+	r = dc->mdops->inc_refcount(dc->bmd, pbn_new);
+	if (r < 0)
+		BUG();
+out:
+	return r;
+}
+
+static int handle_write_with_hash(struct dedup_config *dc, struct bio *bio,
+			     uint64_t lbn, u8 *final_hash,
+			     struct hash_pbn_value hashpbn_value)
+{
+	int r;
+	uint32_t vsize;
+	uint64_t pbn_new, pbn_old;
+	struct lbn_pbn_value lbnpbn_value;
+	struct lbn_pbn_value new_lbnpbn_value;
+
+	dc->dupwrites++;
+
+	pbn_new = hashpbn_value.pbn;
+	r = dc->kvs_lbn_pbn->kvs_lookup(dc->kvs_lbn_pbn, (void *)&lbn,
+			sizeof(lbn), (void *)&lbnpbn_value, &vsize);
+	if (r == 0) {
+		/* No LBN->PBN mapping entry */
+		dc->newwrites++;
+
+		r = dc->mdops->inc_refcount(dc->bmd, pbn_new);
+		if (r < 0)
+			BUG();
+
+		lbnpbn_value.pbn = pbn_new;
+
+		r = dc->kvs_lbn_pbn->kvs_insert(dc->kvs_lbn_pbn, (void *)&lbn,
+				sizeof(lbn), (void *)&lbnpbn_value,
+				sizeof(lbnpbn_value));
+		if (r < 0)
+			BUG();
+
+		dc->logical_block_counter++;
+
+		goto out;
+	} else if (r < 0)
+		BUG();
+
+	/* LBN->PBN mapping entry exists */
+	dc->overwrites++;
+	pbn_old = lbnpbn_value.pbn;
+	if (pbn_new != pbn_old) {
+		r = dc->mdops->inc_refcount(dc->bmd, pbn_new);
+		if (r < 0)
+			BUG();
+
+		new_lbnpbn_value.pbn = pbn_new;
+
+		r = dc->kvs_lbn_pbn->kvs_insert(dc->kvs_lbn_pbn, (void *)&lbn,
+			sizeof(lbn), (void *)&new_lbnpbn_value,
+			sizeof(new_lbnpbn_value));
+		if (r < 0)
+			BUG();
+
+		r = dc->mdops->dec_refcount(dc->bmd, pbn_old);
+		if (r < 0)
+			BUG();
+
+		goto out;
+	}
+
+	/* Nothing to do if writing same data to same LBN */
+
+out:
+	bio_endio(bio, 0);
+	return r;
+}
+
+static void handle_write(struct dedup_config *dc, struct bio *bio)
+{
+	uint64_t lbn;
+	u8 hash[MAX_DIGEST_SIZE];
+	struct hash_pbn_value hashpbn_value;
+	uint32_t vsize;
+	struct bio *new_bio = NULL;
+	int r;
+
+	dc->writes++;
+
+	/* Read-on-write handling */
+	if (bio->bi_iter.bi_size < dc->block_size) {
+		dc->reads_on_writes++;
+		new_bio = prepare_bio_on_write(dc, bio);
+		if (!new_bio) {
+			bio_endio(bio, -ENOMEM);
+			return;
+		}
+		bio = new_bio;
+	}
+
+	lbn = bio_lbn(dc, bio);
+
+	r = compute_hash_bio(dc->desc_table, bio, hash);
+	if (r)
+		BUG();
+
+	r = dc->kvs_hash_pbn->kvs_lookup(dc->kvs_hash_pbn, hash,
+				dc->crypto_key_size, &hashpbn_value, &vsize);
+
+	if (r == 0)
+		r = handle_write_no_hash(dc, bio, lbn, hash);
+	else if (r > 0)
+		r = handle_write_with_hash(dc, bio, lbn, hash,
+					hashpbn_value);
+	else
+		BUG();
+
+	dc->writes_after_flush++;
+	if ((dc->flushrq && dc->writes_after_flush >= dc->flushrq) ||
+			(bio->bi_rw & (REQ_FLUSH | REQ_FUA))) {
+		r = dc->mdops->flush_meta(dc->bmd);
+		dc->writes_after_flush = 0;
+	}
+
+	return;
+}
+
+static void process_bio(struct dedup_config *dc, struct bio *bio)
+{
+	switch (bio_data_dir(bio)) {
+	case READ:
+		handle_read(dc, bio);
+		break;
+	case WRITE:
+		handle_write(dc, bio);
+		break;
+	default:
+		DMERR("Unknown request type!");
+		bio_endio(bio, -EINVAL);
+	}
+}
+
+static void do_work(struct work_struct *ws)
+{
+	struct dedup_work *data = container_of(ws, struct dedup_work, worker);
+	struct dedup_config *dc = (struct dedup_config *)data->config;
+	struct bio *bio = (struct bio *)data->bio;
+
+	mempool_free(data, dc->dedup_work_pool);
+
+	process_bio(dc, bio);
+
+	return;
+}
+
+static void dedup_defer_bio(struct dedup_config *dc, struct bio *bio)
+{
+	struct dedup_work *data;
+
+	data = mempool_alloc(dc->dedup_work_pool, GFP_NOIO);
+	if (!data) {
+		bio_endio(bio, -ENOMEM);
+		return;
+	}
+
+	data->bio = bio;
+	data->config = dc;
+
+	INIT_WORK(&(data->worker), do_work);
+
+	queue_work(dc->workqueue, &(data->worker));
+}
+
+static int dm_dedup_map_fn(struct dm_target *ti, struct bio *bio)
+{
+	dedup_defer_bio(ti->private, bio);
+
+	return DM_MAPIO_SUBMITTED;
+}
+
+enum {
+	dmdedup_opt_data_dev,
+	dmdedup_opt_metadata_dev,
+	dmdedup_opt_block_size,
+	dmdedup_opt_crypto_alg,
+	dmdedup_opt_mdbackend,
+	dmdedup_opt_reconstruct,
+	dmdedup_opt_flushrq,
+	dmdedup_opt_err,
+};
+
+static match_table_t tokens = {
+	{dmdedup_opt_data_dev, "data_dev=%s"},
+	{dmdedup_opt_metadata_dev, "metadata_dev=%s"},
+	{dmdedup_opt_block_size, "block_size=%s"},
+	{dmdedup_opt_crypto_alg, "crypto_alg=%s"},
+	{dmdedup_opt_mdbackend, "mdbackend=%s"},
+	{dmdedup_opt_reconstruct, "reconstruct=%s"},
+	{dmdedup_opt_flushrq, "flushrq=%u"},
+	{dmdedup_opt_err, NULL},
+};
+
+static int dm_dedup_ctr_fn(struct dm_target *ti, unsigned int argc, char **argv)
+{
+	unsigned int i;
+	substring_t args[MAX_OPT_ARGS];
+	int token;
+	char data_dev_str[MAX_DEV_NAME_LEN];
+	bool data_dev_set = false;
+	char metadata_dev_str[MAX_DEV_NAME_LEN];
+	bool metadata_dev_set = false;
+	bool reconstruct = false;
+	bool reconstruct_set = false;
+	unsigned long block_size = 4096;
+	struct dedup_config *dc;
+	struct dm_dev *data_dev;
+	struct dm_dev *metadata_dev;
+	struct workqueue_struct *wq;
+	enum backend backend = BKND_COWBTREE;
+	struct init_param_inram iparam_inram;
+	struct init_param_cowbtree iparam_cowbtree;
+	void *iparam;
+	struct metadata *md = NULL;
+	uint64_t data_size;
+	int r = -EINVAL;
+	char crypto_alg[CRYPTO_ALG_NAME_LEN] = "md5";
+	int crypto_key_size;
+	struct on_disk_stats *data = NULL;
+	uint64_t logical_block_counter = 0;
+	uint64_t physical_block_counter = 0;
+	uint32_t flushrq = 0;
+	mempool_t *dedup_work_pool = NULL;
+
+	for (i = 0; i < argc; i++) {
+		token = match_token(argv[i], tokens, args);
+		switch (token) {
+		case dmdedup_opt_block_size:
+			if (kstrtoul(args[0].from, 10, &block_size) ||
+				!block_size || !is_power_of_2(block_size) ||
+					block_size < (1 << SECTOR_SHIFT)) {
+				ti->error = "invalid block size";
+				goto out;
+			}
+			break;
+		case dmdedup_opt_data_dev:
+			strcpy(data_dev_str, args[0].from);
+			data_dev_set = 1;
+			break;
+		case dmdedup_opt_metadata_dev:
+			strcpy(metadata_dev_str, args[0].from);
+			metadata_dev_set = 1;
+			break;
+		case dmdedup_opt_crypto_alg:
+			strcpy(crypto_alg, args[0].from);
+			break;
+		case dmdedup_opt_mdbackend:
+			if (!strcmp(args[0].from, "inram"))
+				backend = BKND_INRAM;
+			else if (!strcmp(args[0].from, "cowbtree"))
+				backend = BKND_COWBTREE;
+			else {
+				ti->error = "unsupported backend";
+				goto out;
+			}
+			break;
+		case dmdedup_opt_reconstruct:
+			if (!strcmp(args[0].from, "yes"))
+				reconstruct = true;
+			else if (!strcmp(args[0].from, "no"))
+				reconstruct = false;
+			else {
+				ti->error = "invalid reconstruct flag";
+				goto out;
+			}
+			reconstruct_set = true;
+			break;
+		case dmdedup_opt_flushrq:
+			if (kstrtou32(args[0].from, 10,
+						&flushrq)) {
+				ti->error = "invalid flushrq";
+				goto out;
+			}
+			break;
+		case dmdedup_opt_err:
+		default:
+			ti->error = "unrecognized parameter";
+			goto out;
+		}
+	}
+
+	if (!data_dev_set) {
+		ti->error = "data device is not specified";
+		goto out;
+	}
+
+	if (!metadata_dev_set) {
+		ti->error = "metadata device is not specified";
+		goto out;
+	}
+
+	if (!reconstruct_set) {
+		ti->error = "reconstruct flag is not specified";
+		goto out;
+	}
+
+	dc = kmalloc(sizeof(*dc), GFP_NOIO);
+	if (!dc) {
+		ti->error = "failed to allocate dedup target";
+		r = -ENOMEM;
+		goto out;
+	}
+
+	r = dm_get_device(ti, data_dev_str, dm_table_get_mode(ti->table),
+			&data_dev);
+	if (r) {
+		ti->error = "failed to open data device";
+		goto bad_data_dev;
+	}
+
+	r = dm_get_device(ti, metadata_dev_str, dm_table_get_mode(ti->table),
+			&metadata_dev);
+	if (r) {
+		ti->error = "failed to open metadata device";
+		goto bad_metadata_dev;
+	}
+
+	wq = create_singlethread_workqueue("dm-dedup");
+	if (!wq) {
+		ti->error = "failed to create workqueue";
+		r = -ENOMEM;
+		goto bad_wq;
+	}
+
+	dedup_work_pool = mempool_create_kmalloc_pool(MIN_DEDUP_WORK_IO,
+						sizeof(struct dedup_work));
+	if (!dedup_work_pool) {
+		r = -ENOMEM;
+		ti->error = "failed to create mempool";
+		goto bad_mempool;
+	}
+
+	dc->io_client = dm_io_client_create();
+	if (IS_ERR(dc->io_client)) {
+		r = PTR_ERR(dc->io_client);
+		ti->error = "failed to create dm_io_client";
+		goto bad_io_client;
+	}
+
+	dc->block_size = block_size;
+	dc->sectors_per_block = to_sector(block_size);
+	dc->lblocks = ti->len / dc->sectors_per_block;
+
+	data_size = i_size_read(data_dev->bdev->bd_inode);
+	dc->pblocks = data_size / block_size;
+
+	/* Meta-data backend specific part */
+	if (backend == BKND_INRAM) {
+		dc->mdops = &metadata_ops_inram;
+		iparam_inram.blocks = dc->pblocks;
+		iparam = &iparam_inram;
+	} else if (backend == BKND_COWBTREE) {
+		r = -EINVAL;
+		dc->mdops = &metadata_ops_cowbtree;
+		iparam_cowbtree.blocks = dc->pblocks;
+		iparam_cowbtree.metadata_bdev = metadata_dev->bdev;
+		iparam = &iparam_cowbtree;
+	} else
+		BUG();
+
+	md = dc->mdops->init_meta(iparam, reconstruct);
+	if (IS_ERR(md)) {
+		ti->error = "failed to initialize backend metadata";
+		r = PTR_ERR(md);
+		goto bad_metadata_init;
+	}
+
+	dc->desc_table = desc_table_init(crypto_alg);
+	if (!dc->desc_table || IS_ERR(dc->desc_table)) {
+		ti->error = "failed to initialize crypto API";
+		r = PTR_ERR(dc->desc_table);
+		goto bad_metadata_init;
+	}
+
+	crypto_key_size = get_hash_digestsize(dc->desc_table);
+
+	dc->kvs_hash_pbn = dc->mdops->kvs_create_sparse(md, crypto_key_size,
+				sizeof(struct hash_pbn_value),
+				dc->pblocks, reconstruct);
+	if (IS_ERR(dc->kvs_hash_pbn)) {
+		r = PTR_ERR(dc->kvs_hash_pbn);
+		ti->error = "failed to create sparse KVS";
+		goto bad_kvstore_init;
+	}
+
+	dc->kvs_lbn_pbn = dc->mdops->kvs_create_linear(md, 8,
+			sizeof(struct lbn_pbn_value), dc->lblocks, reconstruct);
+	if (IS_ERR(dc->kvs_lbn_pbn)) {
+		ti->error = "failed to create linear KVS";
+		r = PTR_ERR(dc->kvs_lbn_pbn);
+		goto bad_kvstore_init;
+	}
+
+	r = dc->mdops->flush_meta(md);
+	if (r < 0)
+		BUG();
+
+	if (reconstruct && dc->mdops->get_private_data) {
+		r = dc->mdops->get_private_data(md, (void **)&data,
+				sizeof(struct on_disk_stats));
+		if (r < 0)
+			BUG();
+
+		logical_block_counter = data->logical_block_counter;
+		physical_block_counter = data->physical_block_counter;
+	}
+
+	dc->data_dev = data_dev;
+	dc->metadata_dev = metadata_dev;
+	dc->workqueue = wq;
+	dc->dedup_work_pool = dedup_work_pool;
+	dc->bmd = md;
+
+	dc->logical_block_counter = logical_block_counter;
+	dc->physical_block_counter = physical_block_counter;
+
+	dc->writes = 0;
+	dc->dupwrites = 0;
+	dc->uniqwrites = 0;
+	dc->reads_on_writes = 0;
+	dc->overwrites = 0;
+	dc->newwrites = 0;
+
+	strcpy(dc->crypto_alg, crypto_alg);
+	dc->crypto_key_size = crypto_key_size;
+
+	dc->flushrq = flushrq;
+	dc->writes_after_flush = 0;
+
+	dm_set_target_max_io_len(ti, dc->sectors_per_block);
+	ti->private = dc;
+
+	r = 0;
+
+	goto out;
+
+bad_kvstore_init:
+	desc_table_deinit(dc->desc_table);
+bad_metadata_init:
+	if (md && !IS_ERR(md))
+		dc->mdops->exit_meta(md);
+	dm_io_client_destroy(dc->io_client);
+bad_io_client:
+	mempool_destroy(dedup_work_pool);
+bad_mempool:
+	destroy_workqueue(wq);
+bad_wq:
+	dm_put_device(ti, metadata_dev);
+bad_metadata_dev:
+	dm_put_device(ti, data_dev);
+bad_data_dev:
+	kfree(dc);
+out:
+	return r;
+}
+
+static void dm_dedup_dtr_fn(struct dm_target *ti)
+{
+	struct dedup_config *dc = ti->private;
+	struct on_disk_stats data;
+	int ret;
+
+	if (dc->mdops->set_private_data) {
+		data.physical_block_counter = dc->physical_block_counter;
+		data.logical_block_counter = dc->logical_block_counter;
+
+		ret = dc->mdops->set_private_data(dc->bmd, &data,
+				sizeof(struct on_disk_stats));
+		if (ret < 0)
+			BUG();
+	}
+
+	ret = dc->mdops->flush_meta(dc->bmd);
+	if (ret < 0)
+		BUG();
+
+	flush_workqueue(dc->workqueue);
+	destroy_workqueue(dc->workqueue);
+
+	mempool_destroy(dc->dedup_work_pool);
+
+	dc->mdops->exit_meta(dc->bmd);
+
+	dm_io_client_destroy(dc->io_client);
+
+	dm_put_device(ti, dc->data_dev);
+	dm_put_device(ti, dc->metadata_dev);
+	desc_table_deinit(dc->desc_table);
+
+	kfree(dc);
+}
+
+static int dm_dedup_endio_fn(struct dm_target *ti, struct bio *bio, int error)
+{
+	if (error || bio_data_dir(bio) != READ)
+		return 0;
+
+	return 0;
+}
+
+static struct target_type dm_dedup_target = {
+	.name = "dedup",
+	.version = {1, 0, 0},
+	.module = THIS_MODULE,
+	.features = 0x0,
+	.ctr = dm_dedup_ctr_fn,
+	.dtr = dm_dedup_dtr_fn,
+	.map = dm_dedup_map_fn,
+	.end_io = dm_dedup_endio_fn,
+};
+
+static int __init dm_dedup_init(void)
+{
+	int r;
+
+	r = dm_register_target(&dm_dedup_target);
+	if (r < 0)
+		DMERR("target registration failed: %d.", r);
+	else
+		DMINFO("target registered succesfully.");
+
+	return r;
+}
+
+static void __exit dm_dedup_exit(void)
+{
+	dm_unregister_target(&dm_dedup_target);
+}
+
+module_init(dm_dedup_init);
+module_exit(dm_dedup_exit);
+
+MODULE_DESCRIPTION(DM_NAME " target for data deduplication");
+MODULE_LICENSE("GPL");
-- 
1.7.1

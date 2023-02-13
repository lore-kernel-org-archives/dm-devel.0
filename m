Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 314F0C6379F
	for <dm-devel@archiver.kernel.org>; Mon, 13 Feb 2023 20:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676319295;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=wOlKdD2P27a6Z4vUTOnek6iIJzUnJu63mJHPaCpH6ig=;
	b=VDpDSHzGKfhl1QatP+NZtH3JRoyYgARQ+fScUs9S56Ra9LtaT38wpFxAJML5npBRW17bJ4
	C8/1Sqw6Oc0CUhbU0rJ8JIZpK5XhxhPzNGfMGL/PVmbeKz2VTeYtNmHO0YAPeFBDN2bkjy
	GThtFhLZHpfPNM+VPdF0Za+zk+eb2rk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-46-xFfdpuO8OBOXpFvUvJ9cqQ-1; Mon, 13 Feb 2023 15:14:51 -0500
X-MC-Unique: xFfdpuO8OBOXpFvUvJ9cqQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 96814101A521;
	Mon, 13 Feb 2023 20:14:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7FE44403D0C1;
	Mon, 13 Feb 2023 20:14:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6FE631946586;
	Mon, 13 Feb 2023 20:14:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6952A1946597
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Feb 2023 20:14:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 58077492B04; Mon, 13 Feb 2023 20:14:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4FFB4492B03
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:14:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1EB79811E9C
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:14:47 +0000 (UTC)
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com
 [209.85.160.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-325-45KHiZqcOZ-gvb_Ft65Wig-2; Mon, 13 Feb 2023 15:14:45 -0500
X-MC-Unique: 45KHiZqcOZ-gvb_Ft65Wig-2
Received: by mail-qt1-f175.google.com with SMTP id q13so15216850qtx.2
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 12:14:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=RO+svUkNW2LQoXehwBtMCUbJxNCkRk4usN/D2W0lqdc=;
 b=5yD99a+tisHviXNQuryc6eiZYa/i0cv0NvNtjb9yuVE4Y6pn87F+j+/PI34p817wje
 Om8L34cETXmzV/QsepBMJYGDHCiiwPIL9Vpql9FS3zbb5qJsZAEg+mv/jx8aSFc8sOlB
 O2jjdKLjzgWW7xe1yt92p//g8vx1nsr8X+/grOMR/MKykJvm750+7CdfrVO2HhUrdXUn
 YQsCekPtlVnkDX8f9XqDpsY5NhmFf5wwvtZhUGYSmQR5bNRLM7s9kMRW/eZM4F3AjHvC
 VQYMMzDcKrezstqkJYgc53I7D8N/QY6WfYwGbJSiR42an876WaWTpCxEA5JdQFTFoKOj
 CJzg==
X-Gm-Message-State: AO0yUKXXxT8p04Xk5dd8f25bqrXkkm6ADhfy7rBVt2k8roP7mJRpOB5O
 APNDES3qB6a4QZsaEa8yUcAnLVNEUrG96eK8G2KTaY6oW8xEtLpgUVBtMRTYunCDq6xIazYBJul
 j3tkQPlnWygeuAgmTWnkGbNL85k8PPsZz6ewwUnPkxqAK0ONjGuKqlp31oGlBhGuP0Y8aFA==
X-Google-Smtp-Source: AK7set8us30sSwZBAmPZf9ryt20Ksa8s2dkkNnwR+8H5cY7Q7jxHTCHwxIH5PexmvgTEUyqNAzdHAw==
X-Received: by 2002:a05:622a:10e:b0:3b8:6b23:4fc2 with SMTP id
 u14-20020a05622a010e00b003b86b234fc2mr42607773qtw.15.1676319283377; 
 Mon, 13 Feb 2023 12:14:43 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 u63-20020a379242000000b00731c30ac2e8sm10379486qkd.74.2023.02.13.12.14.42
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Feb 2023 12:14:42 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 13 Feb 2023 15:13:32 -0500
Message-Id: <20230213201401.45973-11-snitzer@kernel.org>
In-Reply-To: <20230213201401.45973-1-snitzer@kernel.org>
References: <20230213201401.45973-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH 10/39] dm: correct block comments format.
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: ebiggers@kernel.org, Heinz Mauelshagen <heinzm@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-bufio.c                         | 30 ++++++----
 drivers/md/dm-cache-metadata.c                |  7 ++-
 drivers/md/dm-cache-target.c                  | 58 ++++++++++++-------
 drivers/md/dm-crypt.c                         |  7 ++-
 drivers/md/dm-era-target.c                    | 58 ++++++++++++-------
 drivers/md/dm-io.c                            | 24 +++++---
 drivers/md/dm-ioctl.c                         | 33 +++++++----
 drivers/md/dm-kcopyd.c                        | 18 ++++--
 drivers/md/dm-log.c                           | 24 +++++---
 drivers/md/dm-mpath.c                         | 33 ++++++-----
 drivers/md/dm-ps-round-robin.c                | 13 +++--
 drivers/md/dm-raid.c                          | 12 ++--
 drivers/md/dm-raid1.c                         | 44 +++++++++-----
 drivers/md/dm-region-hash.c                   |  6 +-
 drivers/md/dm-snap-persistent.c               |  6 +-
 drivers/md/dm-snap-transient.c                |  6 +-
 drivers/md/dm-snap.c                          |  7 ++-
 drivers/md/dm-thin-metadata.c                 | 20 ++++---
 drivers/md/dm-thin.c                          | 24 +++++---
 drivers/md/dm.c                               | 12 ++--
 drivers/md/dm.h                               | 12 ++--
 drivers/md/persistent-data/dm-block-manager.c |  6 +-
 drivers/md/persistent-data/dm-btree.c         |  6 +-
 include/linux/device-mapper.h                 | 18 ++++--
 include/linux/dm-dirty-log.h                  |  2 +-
 include/linux/dm-region-hash.h                |  6 +-
 26 files changed, 315 insertions(+), 177 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 7d5495a09611..8d06ca801a10 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -259,9 +259,11 @@ static void buffer_record_stack(struct dm_buffer *b)
 }
 #endif
 
-/*----------------------------------------------------------------
+/*
+ *----------------------------------------------------------------
  * A red/black tree acts as an index for all the buffers.
- *--------------------------------------------------------------*/
+ *----------------------------------------------------------------
+ */
 static struct dm_buffer *__find(struct dm_bufio_client *c, sector_t block)
 {
 	struct rb_node *n = c->buffer_tree.rb_node;
@@ -562,7 +564,8 @@ static void __relink_lru(struct dm_buffer *b, int dirty)
 	b->last_accessed = jiffies;
 }
 
-/*----------------------------------------------------------------
+/*
+ *--------------------------------------------------------------------------
  * Submit I/O on the buffer.
  *
  * Bio interface is faster but it has some problems:
@@ -578,7 +581,8 @@ static void __relink_lru(struct dm_buffer *b, int dirty)
  * rejects the bio because it is too large, use dm-io layer to do the I/O.
  * The dm-io layer splits the I/O into multiple requests, avoiding the above
  * shortcomings.
- *--------------------------------------------------------------*/
+ *--------------------------------------------------------------------------
+ */
 
 /*
  * dm-io completion routine. It just calls b->bio.bi_end_io, pretending
@@ -717,9 +721,11 @@ static void submit_io(struct dm_buffer *b, enum req_op op,
 		use_dmio(b, op, sector, n_sectors, offset);
 }
 
-/*----------------------------------------------------------------
+/*
+ *--------------------------------------------------------------
  * Writing dirty buffers
- *--------------------------------------------------------------*/
+ *--------------------------------------------------------------
+ */
 
 /*
  * The endio routine for write.
@@ -999,9 +1005,11 @@ static void __check_watermark(struct dm_bufio_client *c,
 		__write_dirty_buffers_async(c, 1, write_list);
 }
 
-/*----------------------------------------------------------------
+/*
+ *--------------------------------------------------------------
  * Getting a buffer
- *--------------------------------------------------------------*/
+ *--------------------------------------------------------------
+ */
 
 static struct dm_buffer *__bufio_new(struct dm_bufio_client *c, sector_t block,
 				     enum new_flag nf, int *need_submit,
@@ -2060,9 +2068,11 @@ static void work_fn(struct work_struct *w)
 			   DM_BUFIO_WORK_TIMER_SECS * HZ);
 }
 
-/*----------------------------------------------------------------
+/*
+ *--------------------------------------------------------------
  * Module setup
- *--------------------------------------------------------------*/
+ *--------------------------------------------------------------
+ */
 
 /*
  * This is called only once for the whole dm_bufio module.
diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index ddcd633cce4b..c4b7fec93b99 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -163,10 +163,11 @@ struct dm_cache_metadata {
 	struct dm_bitset_cursor dirty_cursor;
 };
 
-/*-------------------------------------------------------------------
+/*
+ *-----------------------------------------------------------------
  * superblock validator
- *-----------------------------------------------------------------*/
-
+ *-----------------------------------------------------------------
+ */
 #define SUPERBLOCK_CSUM_XOR 9031977
 
 static void sb_prepare_for_write(struct dm_block_validator *v,
diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index e015123b218b..816f0c5f139f 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -525,9 +525,11 @@ static unsigned int lock_level(struct bio *bio)
 		READ_WRITE_LOCK_LEVEL;
 }
 
-/*----------------------------------------------------------------
+/*
+ *--------------------------------------------------------------
  * Per bio data
- *--------------------------------------------------------------*/
+ *--------------------------------------------------------------
+ */
 
 static struct per_bio_data *get_per_bio_data(struct bio *bio)
 {
@@ -706,9 +708,11 @@ static bool is_discarded_oblock(struct cache *cache, dm_oblock_t b)
 	return r;
 }
 
-/*----------------------------------------------------------------
+/*
+ * -------------------------------------------------------------
  * Remapping
- *--------------------------------------------------------------*/
+ *--------------------------------------------------------------
+ */
 static void remap_to_origin(struct cache *cache, struct bio *bio)
 {
 	bio_set_dev(bio, cache->origin_dev->bdev);
@@ -834,9 +838,11 @@ static void remap_to_origin_and_cache(struct cache *cache, struct bio *bio,
 	remap_to_cache(cache, bio, cblock);
 }
 
-/*----------------------------------------------------------------
+/*
+ *--------------------------------------------------------------
  * Failure modes
- *--------------------------------------------------------------*/
+ *--------------------------------------------------------------
+ */
 static enum cache_metadata_mode get_cache_mode(struct cache *cache)
 {
 	return cache->features.mode;
@@ -973,13 +979,14 @@ static void update_stats(struct cache_stats *stats, enum policy_operation op)
 	}
 }
 
-/*----------------------------------------------------------------
+/*
+ *---------------------------------------------------------------------
  * Migration processing
  *
  * Migration covers moving data from the origin device to the cache, or
  * vice versa.
- *--------------------------------------------------------------*/
-
+ *---------------------------------------------------------------------
+ */
 static void inc_io_migrations(struct cache *cache)
 {
 	atomic_inc(&cache->nr_io_migrations);
@@ -1431,9 +1438,11 @@ static int mg_start(struct cache *cache, struct policy_work *op, struct bio *bio
 	return mg_lock_writes(mg);
 }
 
-/*----------------------------------------------------------------
+/*
+ *--------------------------------------------------------------
  * invalidation processing
- *--------------------------------------------------------------*/
+ *--------------------------------------------------------------
+ */
 
 static void invalidate_complete(struct dm_cache_migration *mg, bool success)
 {
@@ -1554,9 +1563,11 @@ static int invalidate_start(struct cache *cache, dm_cblock_t cblock,
 	return invalidate_lock(mg);
 }
 
-/*----------------------------------------------------------------
+/*
+ *--------------------------------------------------------------
  * bio processing
- *--------------------------------------------------------------*/
+ *--------------------------------------------------------------
+ */
 
 enum busy {
 	IDLE,
@@ -1764,9 +1775,11 @@ static bool process_discard_bio(struct cache *cache, struct bio *bio)
 {
 	dm_dblock_t b, e;
 
-	// FIXME: do we need to lock the region?  Or can we just assume the
-	// user wont be so foolish as to issue discard concurrently with
-	// other IO?
+	/*
+	 * FIXME: do we need to lock the region?  Or can we just assume the
+	 * user wont be so foolish as to issue discard concurrently with
+	 * other IO?
+	 */
 	calc_discard_block_range(cache, bio, &b, &e);
 	while (b != e) {
 		set_discard(cache, b);
@@ -1812,10 +1825,11 @@ static void process_deferred_bios(struct work_struct *ws)
 		schedule_commit(&cache->committer);
 }
 
-/*----------------------------------------------------------------
+/*
+ *--------------------------------------------------------------
  * Main worker loop
- *--------------------------------------------------------------*/
-
+ *--------------------------------------------------------------
+ */
 static void requeue_deferred_bios(struct cache *cache)
 {
 	struct bio *bio;
@@ -1871,9 +1885,11 @@ static void check_migrations(struct work_struct *ws)
 	}
 }
 
-/*----------------------------------------------------------------
+/*
+ *--------------------------------------------------------------
  * Target methods
- *--------------------------------------------------------------*/
+ *--------------------------------------------------------------
+ */
 
 /*
  * This function gets called on the error paths of the constructor, so we
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 007c286702c2..2af24a6ad81a 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -364,9 +364,10 @@ static int crypt_iv_benbi_ctr(struct crypt_config *cc, struct dm_target *ti,
 		bs = crypto_skcipher_blocksize(any_tfm(cc));
 	log = ilog2(bs);
 
-	/* we need to calculate how far we must shift the sector count
-	 * to get the cipher block count, we use this shift in _gen */
-
+	/*
+	 * We need to calculate how far we must shift the sector count
+	 * to get the cipher block count, we use this shift in _gen.
+	 */
 	if (1 << log != bs) {
 		ti->error = "cypher blocksize is not a power of 2";
 		return -EINVAL;
diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index a96290103cca..c4fd79135794 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -22,9 +22,11 @@
 #define INVALID_WRITESET_ROOT SUPERBLOCK_LOCATION
 #define MIN_BLOCK_SIZE 8
 
-/*----------------------------------------------------------------
+/*
+ *--------------------------------------------------------------
  * Writeset
- *--------------------------------------------------------------*/
+ *--------------------------------------------------------------
+ */
 struct writeset_metadata {
 	uint32_t nr_bits;
 	dm_block_t root;
@@ -148,9 +150,11 @@ static int writeset_test_and_set(struct dm_disk_bitset *info,
 	return 1;
 }
 
-/*----------------------------------------------------------------
+/*
+ *--------------------------------------------------------------
  * On disk metadata layout
- *--------------------------------------------------------------*/
+ *--------------------------------------------------------------
+ */
 #define SPACE_MAP_ROOT_SIZE 128
 #define UUID_LEN 16
 
@@ -186,9 +190,11 @@ struct superblock_disk {
 	__le64 metadata_snap;
 } __packed;
 
-/*----------------------------------------------------------------
+/*
+ *--------------------------------------------------------------
  * Superblock validation
- *--------------------------------------------------------------*/
+ *--------------------------------------------------------------
+ */
 static void sb_prepare_for_write(struct dm_block_validator *v,
 				 struct dm_block *b,
 				 size_t sb_block_size)
@@ -252,9 +258,11 @@ static struct dm_block_validator sb_validator = {
 	.check = sb_check
 };
 
-/*----------------------------------------------------------------
+/*
+ *--------------------------------------------------------------
  * Low level metadata handling
- *--------------------------------------------------------------*/
+ *--------------------------------------------------------------
+ */
 #define DM_ERA_METADATA_BLOCK_SIZE 4096
 #define ERA_MAX_CONCURRENT_LOCKS 5
 
@@ -658,13 +666,15 @@ static void swap_writeset(struct era_metadata *md, struct writeset *new_writeset
 	synchronize_rcu();
 }
 
-/*----------------------------------------------------------------
+/*
+ *------------------------------------------------------------------------
  * Writesets get 'digested' into the main era array.
  *
  * We're using a coroutine here so the worker thread can do the digestion,
  * thus avoiding synchronisation of the metadata.  Digesting a whole
  * writeset in one go would cause too much latency.
- *--------------------------------------------------------------*/
+ *------------------------------------------------------------------------
+ */
 struct digest {
 	uint32_t era;
 	unsigned int nr_bits, current_bit;
@@ -784,10 +794,12 @@ static int metadata_digest_start(struct era_metadata *md, struct digest *d)
 	return 0;
 }
 
-/*----------------------------------------------------------------
- * High level metadata interface.  Target methods should use these, and not
- * the lower level ones.
- *--------------------------------------------------------------*/
+/*
+ *-----------------------------------------------------------------
+ * High level metadata interface.  Target methods should use these,
+ * and not the lower level ones.
+ *-----------------------------------------------------------------
+ */
 static struct era_metadata *metadata_open(struct block_device *bdev,
 					  sector_t block_size,
 					  bool may_format)
@@ -1189,9 +1201,11 @@ struct rpc {
 	struct completion complete;
 };
 
-/*----------------------------------------------------------------
+/*
+ *---------------------------------------------------------------
  * Remapping.
- *---------------------------------------------------------------*/
+ *---------------------------------------------------------------
+ */
 static bool block_size_is_power_of_two(struct era *era)
 {
 	return era->sectors_per_block_shift >= 0;
@@ -1214,9 +1228,11 @@ static void remap_to_origin(struct era *era, struct bio *bio)
 	bio_set_dev(bio, era->origin_dev->bdev);
 }
 
-/*----------------------------------------------------------------
+/*
+ *--------------------------------------------------------------
  * Worker thread
- *--------------------------------------------------------------*/
+ *--------------------------------------------------------------
+ */
 static void wake_worker(struct era *era)
 {
 	if (!atomic_read(&era->suspended))
@@ -1403,9 +1419,11 @@ static void stop_worker(struct era *era)
 	drain_workqueue(era->wq);
 }
 
-/*----------------------------------------------------------------
+/*
+ *--------------------------------------------------------------
  * Target methods
- *--------------------------------------------------------------*/
+ *--------------------------------------------------------------
+ */
 static void era_destroy(struct era *era)
 {
 	if (era->md)
diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index b2e4a6517e2e..9e0ef8bbd7e9 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -81,13 +81,15 @@ void dm_io_client_destroy(struct dm_io_client *client)
 }
 EXPORT_SYMBOL(dm_io_client_destroy);
 
-/*-----------------------------------------------------------------
+/*
+ *-------------------------------------------------------------------
  * We need to keep track of which region a bio is doing io for.
  * To avoid a memory allocation to store just 5 or 6 bits, we
  * ensure the 'struct io' pointer is aligned so enough low bits are
  * always zero and then combine it with the region number directly in
  * bi_private.
- *---------------------------------------------------------------*/
+ *-------------------------------------------------------------------
+ */
 static void store_io_and_region_in_bio(struct bio *bio, struct io *io,
 				       unsigned int region)
 {
@@ -108,10 +110,12 @@ static void retrieve_io_and_region_from_bio(struct bio *bio, struct io **io,
 	*region = val & (DM_IO_MAX_REGIONS - 1);
 }
 
-/*-----------------------------------------------------------------
+/*
+ *--------------------------------------------------------------
  * We need an io object to keep track of the number of bios that
  * have been dispatched for a particular io.
- *---------------------------------------------------------------*/
+ *--------------------------------------------------------------
+ */
 static void complete_io(struct io *io)
 {
 	unsigned long error_bits = io->error_bits;
@@ -155,10 +159,12 @@ static void endio(struct bio *bio)
 	dec_count(io, region, error);
 }
 
-/*-----------------------------------------------------------------
+/*
+ *--------------------------------------------------------------
  * These little objects provide an abstraction for getting a new
  * destination page for io.
- *---------------------------------------------------------------*/
+ *--------------------------------------------------------------
+ */
 struct dpages {
 	void (*get_page)(struct dpages *dp,
 			 struct page **p, unsigned long *len, unsigned int *offset);
@@ -291,9 +297,11 @@ static void km_dp_init(struct dpages *dp, void *data)
 	dp->context_ptr = data;
 }
 
-/*-----------------------------------------------------------------
+/*
+ *---------------------------------------------------------------
  * IO routines that accept a list of pages.
- *---------------------------------------------------------------*/
+ *---------------------------------------------------------------
+ */
 static void do_region(const blk_opf_t opf, unsigned int region,
 		      struct dm_io_region *where, struct dpages *dp,
 		      struct io *io)
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 36943bcbd8cb..ab080794eab5 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -35,10 +35,12 @@ struct dm_file {
 	volatile unsigned int global_event_nr;
 };
 
-/*-----------------------------------------------------------------
+/*
+ *---------------------------------------------------------------
  * The ioctl interface needs to be able to look up devices by
  * name or uuid.
- *---------------------------------------------------------------*/
+ *---------------------------------------------------------------
+ */
 struct hash_cell {
 	struct rb_node name_node;
 	struct rb_node uuid_node;
@@ -79,9 +81,11 @@ static void dm_hash_exit(void)
 	dm_hash_remove_all(false, false, false);
 }
 
-/*-----------------------------------------------------------------
+/*
+ *---------------------------------------------------------------
  * Code for looking up a device by name
- *---------------------------------------------------------------*/
+ *---------------------------------------------------------------
+ */
 static struct hash_cell *__get_name_cell(const char *str)
 {
 	struct rb_node *n = name_rb_tree.rb_node;
@@ -196,9 +200,11 @@ static struct hash_cell *__get_dev_cell(uint64_t dev)
 	return hc;
 }
 
-/*-----------------------------------------------------------------
+/*
+ *---------------------------------------------------------------
  * Inserting, removing and renaming a device.
- *---------------------------------------------------------------*/
+ *---------------------------------------------------------------
+ */
 static struct hash_cell *alloc_cell(const char *name, const char *uuid,
 				    struct mapped_device *md)
 {
@@ -501,9 +507,11 @@ void dm_deferred_remove(void)
 	dm_hash_remove_all(true, false, true);
 }
 
-/*-----------------------------------------------------------------
+/*
+ *---------------------------------------------------------------
  * Implementation of the ioctl commands
- *---------------------------------------------------------------*/
+ *---------------------------------------------------------------
+ */
 /*
  * All the ioctl commands get dispatched to functions with this
  * prototype.
@@ -1757,10 +1765,11 @@ static int target_message(struct file *filp, struct dm_ioctl *param, size_t para
 #define IOCTL_FLAGS_NO_PARAMS		1
 #define IOCTL_FLAGS_ISSUE_GLOBAL_EVENT	2
 
-/*-----------------------------------------------------------------
- * Implementation of open/close/ioctl on the special char
- * device.
- *---------------------------------------------------------------*/
+/*
+ *---------------------------------------------------------------
+ * Implementation of open/close/ioctl on the special char device.
+ *---------------------------------------------------------------
+ */
 static ioctl_fn lookup_ioctl(unsigned int cmd, int *ioctl_flags)
 {
 	static const struct {
diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
index f46e3201b66f..1b97a32faa4e 100644
--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -51,10 +51,12 @@ static unsigned int dm_get_kcopyd_subjob_size(void)
 	return sub_job_size_kb << 1;
 }
 
-/*-----------------------------------------------------------------
+/*
+ *----------------------------------------------------------------
  * Each kcopyd client has its own little pool of preallocated
  * pages for kcopyd io.
- *---------------------------------------------------------------*/
+ *---------------------------------------------------------------
+ */
 struct dm_kcopyd_client {
 	struct page_list *pages;
 	unsigned int nr_reserved_pages;
@@ -334,11 +336,13 @@ static void client_free_pages(struct dm_kcopyd_client *kc)
 	kc->nr_free_pages = kc->nr_reserved_pages = 0;
 }
 
-/*-----------------------------------------------------------------
+/*
+ *---------------------------------------------------------------
  * kcopyd_jobs need to be allocated by the *clients* of kcopyd,
  * for this reason we use a mempool to prevent the client from
  * ever having to do io (which could cause a deadlock).
- *---------------------------------------------------------------*/
+ *---------------------------------------------------------------
+ */
 struct kcopyd_job {
 	struct dm_kcopyd_client *kc;
 	struct list_head list;
@@ -901,9 +905,11 @@ int kcopyd_cancel(struct kcopyd_job *job, int block)
 }
 #endif  /*  0  */
 
-/*-----------------------------------------------------------------
+/*
+ *---------------------------------------------------------------
  * Client setup
- *---------------------------------------------------------------*/
+ *---------------------------------------------------------------
+ */
 struct dm_kcopyd_client *dm_kcopyd_client_create(struct dm_kcopyd_throttle *throttle)
 {
 	int r;
diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index 5b0d5187568e..a58d8ef97020 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -183,10 +183,12 @@ void dm_dirty_log_destroy(struct dm_dirty_log *log)
 }
 EXPORT_SYMBOL(dm_dirty_log_destroy);
 
-/*-----------------------------------------------------------------
+/*
+ *---------------------------------------------------------------
  * Persistent and core logs share a lot of their implementation.
  * FIXME: need a reload method to be called from a resume
- *---------------------------------------------------------------*/
+ *---------------------------------------------------------------
+ */
 /*
  * Magic for persistent mirrors: "MiRr"
  */
@@ -275,9 +277,11 @@ static inline void log_clear_bit(struct log_c *l,
 	l->touched_dirtied = 1;
 }
 
-/*----------------------------------------------------------------
+/*
+ *---------------------------------------------------------------
  * Header IO
- *--------------------------------------------------------------*/
+ *--------------------------------------------------------------
+ */
 static void header_to_disk(struct log_header_core *core, struct log_header_disk *disk)
 {
 	disk->magic = cpu_to_le32(core->magic);
@@ -353,11 +357,13 @@ static int _check_region_size(struct dm_target *ti, uint32_t region_size)
 	return 1;
 }
 
-/*----------------------------------------------------------------
+/*
+ *--------------------------------------------------------------
  * core log constructor/destructor
  *
  * argv contains region_size followed optionally by [no]sync
- *--------------------------------------------------------------*/
+ *--------------------------------------------------------------
+ */
 #define BYTE_SHIFT 3
 static int create_log_context(struct dm_dirty_log *log, struct dm_target *ti,
 			      unsigned int argc, char **argv,
@@ -532,11 +538,13 @@ static void core_dtr(struct dm_dirty_log *log)
 	destroy_log_context(lc);
 }
 
-/*----------------------------------------------------------------
+/*
+ *---------------------------------------------------------------------
  * disk log constructor/destructor
  *
  * argv contains log_device region_size followed optionally by [no]sync
- *--------------------------------------------------------------*/
+ *---------------------------------------------------------------------
+ */
 static int disk_ctr(struct dm_dirty_log *log, struct dm_target *ti,
 		    unsigned int argc, char **argv)
 {
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index c882d6e8dfdb..14bb5283e1e2 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -118,10 +118,11 @@ static void activate_path_work(struct work_struct *work);
 static void process_queued_bios(struct work_struct *work);
 static void queue_if_no_path_timeout_work(struct timer_list *t);
 
-/*-----------------------------------------------
+/*
+ *-----------------------------------------------
  * Multipath state flags.
- *-----------------------------------------------*/
-
+ *-----------------------------------------------
+ */
 #define MPATHF_QUEUE_IO 0			/* Must we queue all I/O? */
 #define MPATHF_QUEUE_IF_NO_PATH 1		/* Queue I/O if last path fails? */
 #define MPATHF_SAVED_QUEUE_IF_NO_PATH 2		/* Saved state during suspension */
@@ -144,10 +145,11 @@ static bool mpath_double_check_test_bit(int MPATHF_bit, struct multipath *m)
 	return r;
 }
 
-/*-----------------------------------------------
+/*
+ *-----------------------------------------------
  * Allocation routines
- *-----------------------------------------------*/
-
+ *-----------------------------------------------
+ */
 static struct pgpath *alloc_pgpath(void)
 {
 	struct pgpath *pgpath = kzalloc(sizeof(*pgpath), GFP_KERNEL);
@@ -303,10 +305,11 @@ static void multipath_init_per_bio_data(struct bio *bio, struct dm_mpath_io **mp
 	dm_bio_record(bio_details, bio);
 }
 
-/*-----------------------------------------------
+/*
+ *-----------------------------------------------
  * Path selection
- *-----------------------------------------------*/
-
+ *-----------------------------------------------
+ */
 static int __pg_init_all_paths(struct multipath *m)
 {
 	struct pgpath *pgpath;
@@ -826,7 +829,8 @@ static void trigger_event(struct work_struct *work)
 	dm_table_event(m->ti->table);
 }
 
-/*-----------------------------------------------------------------
+/*
+ *---------------------------------------------------------------
  * Constructor/argument parsing:
  * <#multipath feature args> [<arg>]*
  * <#hw_handler args> [hw_handler [<arg>]*]
@@ -835,7 +839,8 @@ static void trigger_event(struct work_struct *work)
  *     [<selector> <#selector args> [<arg>]*
  *      <#paths> <#per-path selector args>
  *         [<path> [<arg>]* ]+ ]+
- *---------------------------------------------------------------*/
+ *---------------------------------------------------------------
+ */
 static int parse_path_selector(struct dm_arg_set *as, struct priority_group *pg,
 			       struct dm_target *ti)
 {
@@ -2169,9 +2174,11 @@ static int multipath_busy(struct dm_target *ti)
 	return busy;
 }
 
-/*-----------------------------------------------------------------
+/*
+ *---------------------------------------------------------------
  * Module setup
- *---------------------------------------------------------------*/
+ *---------------------------------------------------------------
+ */
 static struct target_type multipath_target = {
 	.name = "multipath",
 	.version = {1, 14, 0},
diff --git a/drivers/md/dm-ps-round-robin.c b/drivers/md/dm-ps-round-robin.c
index 85ca14f87873..132a3dc94084 100644
--- a/drivers/md/dm-ps-round-robin.c
+++ b/drivers/md/dm-ps-round-robin.c
@@ -21,9 +21,11 @@
 #define RR_MIN_IO     1
 #define RR_VERSION    "1.2.0"
 
-/*-----------------------------------------------------------------
+/*
+ *---------------------------------------------------------------
  * Path-handling code, paths are held in lists
- *---------------------------------------------------------------*/
+ *---------------------------------------------------------------
+ */
 struct path_info {
 	struct list_head list;
 	struct dm_path *path;
@@ -40,10 +42,11 @@ static void free_paths(struct list_head *paths)
 	}
 }
 
-/*-----------------------------------------------------------------
+/*
+ *---------------------------------------------------------------
  * Round-robin selector
- *---------------------------------------------------------------*/
-
+ *---------------------------------------------------------------
+ */
 struct selector {
 	struct list_head valid_paths;
 	struct list_head invalid_paths;
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index ecd69e877621..08fcc9908d0c 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3184,12 +3184,12 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		/* Out-of-place space has to be available to allow for a reshape unless raid1! */
 		if (reshape_sectors || rs_is_raid1(rs)) {
 			/*
-			  * We can only prepare for a reshape here, because the
-			  * raid set needs to run to provide the repective reshape
-			  * check functions via its MD personality instance.
-			  *
-			  * So do the reshape check after md_run() succeeded.
-			  */
+			 * We can only prepare for a reshape here, because the
+			 * raid set needs to run to provide the repective reshape
+			 * check functions via its MD personality instance.
+			 *
+			 * So do the reshape check after md_run() succeeded.
+			 */
 			r = rs_prepare_reshape(rs);
 			if (r)
 				goto bad;
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index bd891bec2fc7..2b003fe536bc 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -33,9 +33,11 @@
 
 static DECLARE_WAIT_QUEUE_HEAD(_kmirrord_recovery_stopped);
 
-/*-----------------------------------------------------------------
+/*
+ *---------------------------------------------------------------
  * Mirror set structures.
- *---------------------------------------------------------------*/
+ *---------------------------------------------------------------
+ */
 enum dm_raid1_error {
 	DM_RAID1_WRITE_ERROR,
 	DM_RAID1_FLUSH_ERROR,
@@ -286,13 +288,15 @@ static int mirror_flush(struct dm_target *ti)
 	return 0;
 }
 
-/*-----------------------------------------------------------------
+/*
+ *---------------------------------------------------------------
  * Recovery.
  *
  * When a mirror is first activated we may find that some regions
  * are in the no-sync state.  We have to recover these by
  * recopying from the default mirror to all the others.
- *---------------------------------------------------------------*/
+ *---------------------------------------------------------------
+ */
 static void recovery_complete(int read_err, unsigned long write_err,
 			      void *context)
 {
@@ -409,9 +413,11 @@ static void do_recovery(struct mirror_set *ms)
 	}
 }
 
-/*-----------------------------------------------------------------
+/*
+ *---------------------------------------------------------------
  * Reads
- *---------------------------------------------------------------*/
+ *---------------------------------------------------------------
+ */
 static struct mirror *choose_mirror(struct mirror_set *ms, sector_t sector)
 {
 	struct mirror *m = get_default_mirror(ms);
@@ -499,9 +505,11 @@ static void hold_bio(struct mirror_set *ms, struct bio *bio)
 	spin_unlock_irq(&ms->lock);
 }
 
-/*-----------------------------------------------------------------
+/*
+ *---------------------------------------------------------------
  * Reads
- *---------------------------------------------------------------*/
+ *---------------------------------------------------------------
+ */
 static void read_callback(unsigned long error, void *context)
 {
 	struct bio *bio = context;
@@ -580,7 +588,8 @@ static void do_reads(struct mirror_set *ms, struct bio_list *reads)
 	}
 }
 
-/*-----------------------------------------------------------------
+/*
+ *---------------------------------------------------------------------
  * Writes.
  *
  * We do different things with the write io depending on the
@@ -589,9 +598,8 @@ static void do_reads(struct mirror_set *ms, struct bio_list *reads)
  * SYNC: 	increment pending, use kcopyd to write to *all* mirrors
  * RECOVERING:	delay the io until recovery completes
  * NOSYNC:	increment pending, just write to the default mirror
- *---------------------------------------------------------------*/
-
-
+ *---------------------------------------------------------------------
+ */
 static void write_callback(unsigned long error, void *context)
 {
 	unsigned int i;
@@ -843,9 +851,11 @@ static void trigger_event(struct work_struct *work)
 	dm_table_event(ms->ti->table);
 }
 
-/*-----------------------------------------------------------------
+/*
+ *---------------------------------------------------------------
  * kmirrord
- *---------------------------------------------------------------*/
+ *---------------------------------------------------------------
+ */
 static void do_mirror(struct work_struct *work)
 {
 	struct mirror_set *ms = container_of(work, struct mirror_set,
@@ -869,9 +879,11 @@ static void do_mirror(struct work_struct *work)
 	do_failures(ms, &failures);
 }
 
-/*-----------------------------------------------------------------
+/*
+ *---------------------------------------------------------------
  * Target functions
- *---------------------------------------------------------------*/
+ *---------------------------------------------------------------
+ */
 static struct mirror_set *alloc_context(unsigned int nr_mirrors,
 					uint32_t region_size,
 					struct dm_target *ti,
diff --git a/drivers/md/dm-region-hash.c b/drivers/md/dm-region-hash.c
index ce6a788e497c..460c48512362 100644
--- a/drivers/md/dm-region-hash.c
+++ b/drivers/md/dm-region-hash.c
@@ -19,7 +19,8 @@
 
 #define	DM_MSG_PREFIX	"region hash"
 
-/*-----------------------------------------------------------------
+/*
+ *------------------------------------------------------------------
  * Region hash
  *
  * The mirror splits itself up into discrete regions.  Each
@@ -54,7 +55,8 @@
  *   lists in the region_hash, with the 'state', 'list' and
  *   'delayed_bios' fields of the regions.  This is used from irq
  *   context, so all other uses will have to suspend local irqs.
- *---------------------------------------------------------------*/
+ *------------------------------------------------------------------
+ */
 struct dm_region_hash {
 	uint32_t region_size;
 	unsigned int region_shift;
diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index cd599c0e2454..c05e398d43d7 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -22,10 +22,12 @@
 
 #define DM_PREFETCH_CHUNKS		12
 
-/*-----------------------------------------------------------------
+/*
+ *---------------------------------------------------------------
  * Persistent snapshots, by persistent we mean that the snapshot
  * will survive a reboot.
- *---------------------------------------------------------------*/
+ *---------------------------------------------------------------
+ */
 
 /*
  * We need to store a record of which parts of the origin have
diff --git a/drivers/md/dm-snap-transient.c b/drivers/md/dm-snap-transient.c
index a643b087115f..44dad7a56492 100644
--- a/drivers/md/dm-snap-transient.c
+++ b/drivers/md/dm-snap-transient.c
@@ -17,9 +17,11 @@
 
 #define DM_MSG_PREFIX "transient snapshot"
 
-/*-----------------------------------------------------------------
+/*
+ *---------------------------------------------------------------
  * Implementation of the store for non-persistent snapshots.
- *---------------------------------------------------------------*/
+ *---------------------------------------------------------------
+ */
 struct transient_c {
 	sector_t next_free;
 };
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 3281a168a7d3..22b07a1bf972 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -2420,10 +2420,11 @@ static void snapshot_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	}
 }
 
-/*-----------------------------------------------------------------
+/*
+ *---------------------------------------------------------------
  * Origin methods
- *---------------------------------------------------------------*/
-
+ *---------------------------------------------------------------
+ */
 /*
  * If no exceptions need creating, DM_MAPIO_REMAPPED is returned and any
  * supplied bio was ignored.  The caller may submit it immediately.
diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index 92e3bfa369af..259fd752e3d0 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -15,7 +15,8 @@
 #include <linux/device-mapper.h>
 #include <linux/workqueue.h>
 
-/*--------------------------------------------------------------------------
+/*
+ *--------------------------------------------------------------------------
  * As far as the metadata goes, there is:
  *
  * - A superblock in block zero, taking up fewer than 512 bytes for
@@ -71,7 +72,8 @@
  *
  * All metadata io is in THIN_METADATA_BLOCK_SIZE sized/aligned chunks
  * from the block manager.
- *--------------------------------------------------------------------------*/
+ *--------------------------------------------------------------------------
+ */
 
 #define DM_MSG_PREFIX   "thin metadata"
 
@@ -240,10 +242,11 @@ struct dm_thin_device {
 	uint32_t snapshotted_time;
 };
 
-/*----------------------------------------------------------------
+/*
+ *--------------------------------------------------------------
  * superblock validator
- *--------------------------------------------------------------*/
-
+ *--------------------------------------------------------------
+ */
 #define SUPERBLOCK_CSUM_XOR 160774
 
 static void sb_prepare_for_write(struct dm_block_validator *v,
@@ -297,10 +300,11 @@ static struct dm_block_validator sb_validator = {
 	.check = sb_check
 };
 
-/*----------------------------------------------------------------
+/*
+ *--------------------------------------------------------------
  * Methods for the btree value types
- *--------------------------------------------------------------*/
-
+ *--------------------------------------------------------------
+ */
 static uint64_t pack_block_time(dm_block_t b, uint32_t t)
 {
 	return (b << 24) | t;
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 542927ecea9d..7cc86298baca 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2800,9 +2800,11 @@ static void requeue_bios(struct pool *pool)
 	rcu_read_unlock();
 }
 
-/*----------------------------------------------------------------
+/*
+ *--------------------------------------------------------------
  * Binding of control targets to a pool object
- *--------------------------------------------------------------*/
+ *--------------------------------------------------------------
+ */
 static bool is_factor(sector_t block_size, uint32_t n)
 {
 	return !sector_div(block_size, n);
@@ -2866,9 +2868,11 @@ static void unbind_control_target(struct pool *pool, struct dm_target *ti)
 		pool->ti = NULL;
 }
 
-/*----------------------------------------------------------------
+/*
+ *--------------------------------------------------------------
  * Pool creation
- *--------------------------------------------------------------*/
+ *--------------------------------------------------------------
+ */
 /* Initialize pool features. */
 static void pool_features_init(struct pool_features *pf)
 {
@@ -3092,9 +3096,11 @@ static struct pool *__pool_find(struct mapped_device *pool_md,
 	return pool;
 }
 
-/*----------------------------------------------------------------
+/*
+ *--------------------------------------------------------------
  * Pool target methods
- *--------------------------------------------------------------*/
+ *--------------------------------------------------------------
+ */
 static void pool_dtr(struct dm_target *ti)
 {
 	struct pool_c *pt = ti->private;
@@ -4096,9 +4102,11 @@ static struct target_type pool_target = {
 	.io_hints = pool_io_hints,
 };
 
-/*----------------------------------------------------------------
+/*
+ *--------------------------------------------------------------
  * Thin target methods
- *--------------------------------------------------------------*/
+ *--------------------------------------------------------------
+ */
 static void thin_get(struct thin_c *tc)
 {
 	refcount_inc(&tc->refcount);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 6a557c79a0d2..16f29a60a64f 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1873,9 +1873,11 @@ static int dm_poll_bio(struct bio *bio, struct io_comp_batch *iob,
 	return 1;
 }
 
-/*-----------------------------------------------------------------
+/*
+ *---------------------------------------------------------------
  * An IDR is used to keep track of allocated minor numbers.
- *---------------------------------------------------------------*/
+ *---------------------------------------------------------------
+ */
 static void free_minor(int minor)
 {
 	spin_lock(&_minor_lock);
@@ -2964,9 +2966,11 @@ void dm_internal_resume_fast(struct mapped_device *md)
 }
 EXPORT_SYMBOL_GPL(dm_internal_resume_fast);
 
-/*-----------------------------------------------------------------
+/*
+ *---------------------------------------------------------------
  * Event notification.
- *---------------------------------------------------------------*/
+ *---------------------------------------------------------------
+ */
 int dm_kobject_uevent(struct mapped_device *md, enum kobject_action action, unsigned int cookie)
 {
 	int r;
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 53a0a436e54d..40a06185d05f 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -48,9 +48,11 @@ struct dm_md_mempools;
 struct dm_target_io;
 struct dm_io;
 
-/*-----------------------------------------------------------------
+/*
+ *---------------------------------------------------------------
  * Internal table functions.
- *---------------------------------------------------------------*/
+ *---------------------------------------------------------------
+ */
 void dm_table_event_callback(struct dm_table *t,
 			     void (*fn)(void *), void *context);
 struct dm_target *dm_table_find_target(struct dm_table *t, sector_t sector);
@@ -119,9 +121,11 @@ static inline int dm_zone_map_bio(struct dm_target_io *tio)
 }
 #endif
 
-/*-----------------------------------------------------------------
+/*
+ *---------------------------------------------------------------
  * A registry of target types.
- *---------------------------------------------------------------*/
+ *---------------------------------------------------------------
+ */
 int dm_target_init(void);
 void dm_target_exit(void);
 struct target_type *dm_get_target_type(const char *name);
diff --git a/drivers/md/persistent-data/dm-block-manager.c b/drivers/md/persistent-data/dm-block-manager.c
index 6f1501046ada..741a1a90bdee 100644
--- a/drivers/md/persistent-data/dm-block-manager.c
+++ b/drivers/md/persistent-data/dm-block-manager.c
@@ -368,9 +368,11 @@ static void dm_block_manager_write_callback(struct dm_buffer *buf)
 	}
 }
 
-/*----------------------------------------------------------------
+/*
+ * -------------------------------------------------------------
  * Public interface
- *--------------------------------------------------------------*/
+ *--------------------------------------------------------------
+ */
 struct dm_block_manager {
 	struct dm_bufio_client *bufio;
 	bool read_only:1;
diff --git a/drivers/md/persistent-data/dm-btree.c b/drivers/md/persistent-data/dm-btree.c
index eab280c520bd..1e930e809169 100644
--- a/drivers/md/persistent-data/dm-btree.c
+++ b/drivers/md/persistent-data/dm-btree.c
@@ -14,9 +14,11 @@
 
 #define DM_MSG_PREFIX "btree"
 
-/*----------------------------------------------------------------
+/*
+ *--------------------------------------------------------------
  * Array manipulation
- *--------------------------------------------------------------*/
+ *--------------------------------------------------------------
+ */
 static void memcpy_disk(void *dest, const void *src, size_t len)
 	__dm_written_to_disk(src)
 {
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index f43b372e27a0..da546e7dfccb 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -434,10 +434,12 @@ const char *dm_shift_arg(struct dm_arg_set *as);
  */
 void dm_consume_args(struct dm_arg_set *as, unsigned int num_args);
 
-/*-----------------------------------------------------------------
+/*
+ *----------------------------------------------------------------
  * Functions for creating and manipulating mapped devices.
  * Drop the reference with dm_put when you finish with the object.
- *---------------------------------------------------------------*/
+ *----------------------------------------------------------------
+ */
 
 /*
  * DM_ANY_MINOR chooses the next available minor number.
@@ -518,9 +520,11 @@ struct queue_limits *dm_get_queue_limits(struct mapped_device *md);
 int dm_get_geometry(struct mapped_device *md, struct hd_geometry *geo);
 int dm_set_geometry(struct mapped_device *md, struct hd_geometry *geo);
 
-/*-----------------------------------------------------------------
+/*
+ *---------------------------------------------------------------
  * Functions for manipulating device-mapper tables.
- *---------------------------------------------------------------*/
+ *---------------------------------------------------------------
+ */
 
 /*
  * First create an empty table.
@@ -594,9 +598,11 @@ struct dm_table *dm_swap_table(struct mapped_device *md,
  */
 void dm_destroy_crypto_profile(struct blk_crypto_profile *profile);
 
-/*-----------------------------------------------------------------
+/*
+ *---------------------------------------------------------------
  * Macros.
- *---------------------------------------------------------------*/
+ *---------------------------------------------------------------
+ */
 #define DM_NAME "device-mapper"
 
 #define DM_FMT(fmt) DM_NAME ": " DM_MSG_PREFIX ": " fmt "\n"
diff --git a/include/linux/dm-dirty-log.h b/include/linux/dm-dirty-log.h
index 8642bfaf41b6..ed7aee2c50bd 100644
--- a/include/linux/dm-dirty-log.h
+++ b/include/linux/dm-dirty-log.h
@@ -97,7 +97,7 @@ struct dm_dirty_log_type {
 	 * Do not confuse this function with 'in_sync()', one
 	 * tells you if an area is synchronised, the other
 	 * assigns recovery work.
-	*/
+	 */
 	int (*get_resync_work)(struct dm_dirty_log *log, region_t *region);
 
 	/*
diff --git a/include/linux/dm-region-hash.h b/include/linux/dm-region-hash.h
index d9f89b8e34c1..982d32f5625e 100644
--- a/include/linux/dm-region-hash.h
+++ b/include/linux/dm-region-hash.h
@@ -13,9 +13,11 @@
 
 #include <linux/dm-dirty-log.h>
 
-/*-----------------------------------------------------------------
+/*
+ *----------------------------------------------------------------
  * Region hash
- *----------------------------------------------------------------*/
+ *----------------------------------------------------------------
+ */
 struct dm_region_hash;
 struct dm_region;
 
-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


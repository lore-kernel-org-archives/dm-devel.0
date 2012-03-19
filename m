From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm ssdcache: fix and/or tweak various low
	hanging fruit
Date: Mon, 19 Mar 2012 09:57:01 -0400
Message-ID: <20120319135700.GA20545@redhat.com>
References: <4F635E69.3070901@suse.de>
 <20120316180636.GA31055@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120316180636.GA31055@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Initial review (which hasn't yet touched on design, algorithms,
naming, etc) uncovered some small things:

- remove ': ' from DM_MSG_PREFIX, tweaked {D,W}PRINTK
- eliminate 2 4-byte holes in ssdcache_md structure
- clean up pool_init() error handling, switched to using KMEM_CACHE()
- fix ssd_cache_ctr() error path, dm_put_device for target_dev was
  missing if failed to get cache_dev
- fix ssdcache_iterate_devices() to consult cache_dev too because it
  is in the data path (resulting ssdcache dev now stacks limits
  properly, e.g.: if you mix a 4K ssd with a 512b target dev)
- wrap sio_in_flight with SSD_DEBUG
- document ssdcache_ctr (still have yet to make sense of the options)
- small s/eject/evict/ comment tweak

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-ssdcache.c |  130 ++++++++++++++++++++++-----------------------
 1 files changed, 64 insertions(+), 66 deletions(-)

diff --git a/drivers/md/dm-ssdcache.c b/drivers/md/dm-ssdcache.c
index f05e40f..1ab6cb3 100644
--- a/drivers/md/dm-ssdcache.c
+++ b/drivers/md/dm-ssdcache.c
@@ -1,6 +1,4 @@
 /*
- * dm-ssdcache.c
- *
  * Copyright (c) 2011 Hannes Reinecke, SUSE Linux Products GmbH
  *
  * This file is released under the GPL.
@@ -17,21 +15,21 @@
 #include <linux/dm-io.h>
 #include <linux/dm-kcopyd.h>
 
-#define DM_MSG_PREFIX "ssdcache: "
+#define DM_MSG_PREFIX "ssdcache"
 
 // #define SSD_DEBUG
 #define SSD_LOG
 #define SSDCACHE_USE_RADIX_TREE
 
 #ifdef SSD_LOG
-#define DPRINTK( s, arg... ) printk(DM_MSG_PREFIX s "\n", ##arg)
-#define WPRINTK( w, s, arg... ) printk(DM_MSG_PREFIX "%lu: %s (cte %lx:%02lx): "\
-				       s "\n", (w)->nr, __FUNCTION__, \
-				       (w)->cmd->hash, \
-				       (w)->cte_idx, ##arg)
+#define DPRINTK(s, arg...) printk(DM_MSG_PREFIX ": " s "\n", ## arg)
+#define WPRINTK(w, s, arg...) printk(DM_MSG_PREFIX ": %lu: %s (cte %lx:%02lx): " \
+				     s "\n", (w)->nr, __FUNCTION__,	\
+				     (w)->cmd->hash,			\
+				     (w)->cte_idx, ## arg)
 #else
-#define DPRINTK( s, arg... )
-#define WPRINTK( w, s, arg... )
+#define DPRINTK(s, arg...)
+#define WPRINTK(w, s, arg...)
 #endif
 
 #define SSDCACHE_COPY_PAGES 1024
@@ -57,6 +55,8 @@ enum ssdcache_strategy_t {
 	CACHE_LFU,
 };
 
+/* FIXME: add 'dm_' prefix to ssdcache_{md,io,te} structures */
+
 struct ssdcache_md;
 struct ssdcache_io;
 
@@ -74,8 +74,8 @@ struct ssdcache_te {
 
 struct ssdcache_md {
 	spinlock_t lock;	/* Lock to protect operations on the bio list */
-	unsigned long hash;	/* Hash number */
 	unsigned int num_cte;	/* Number of table entries */
+	unsigned long hash;	/* Hash number */
 	unsigned long atime;
 	struct ssdcache_ctx *sc;
 	struct ssdcache_te *te[DEFAULT_ALIASING];	/* RCU Table entries */
@@ -198,63 +198,47 @@ enum cte_match_t {
 
 static int pool_init(void)
 {
-	_sio_cache = kmem_cache_create("ssdcache-sio",
-					sizeof(struct ssdcache_io),
-					__alignof__(struct ssdcache_io),
-					0, NULL);
+	_sio_cache = KMEM_CACHE(ssdcache_io, 0);
 	if (!_sio_cache)
 		return -ENOMEM;
 
-	_cmd_cache = kmem_cache_create("ssdcache-cmd",
-				       sizeof(struct ssdcache_md),
-				       __alignof__(struct ssdcache_md),
-				       0, NULL);
-
-	if (!_cmd_cache) {
-		kmem_cache_destroy(_sio_cache);
-		return -ENOMEM;
-	}
-
-	_cte_cache = kmem_cache_create("ssdcache-cte",
-				       sizeof(struct ssdcache_te),
-				       __alignof__(struct ssdcache_te),
-				       0, NULL);
+	_cmd_cache = KMEM_CACHE(ssdcache_md, 0);
+	if (!_cmd_cache)
+		goto bad_cmd_cache;
 
-	if (!_cte_cache) {
-		kmem_cache_destroy(_cmd_cache);
-		kmem_cache_destroy(_sio_cache);
-		return -ENOMEM;
-	}
+	_cte_cache = KMEM_CACHE(ssdcache_te, 0);
+	if (!_cte_cache)
+		goto bad_cte_cache;
 
 	_sio_pool = mempool_create(MIN_SIO_ITEMS, mempool_alloc_slab,
-				    mempool_free_slab, _sio_cache);
-	if (!_sio_pool) {
-		kmem_cache_destroy(_cte_cache);
-		kmem_cache_destroy(_cmd_cache);
-		kmem_cache_destroy(_sio_cache);
-		return -ENOMEM;
-	}
+				   mempool_free_slab, _sio_cache);
+	if (!_sio_pool)
+		goto bad_sio_pool;
 
 	_cmd_pool = mempool_create(MIN_CMD_NUM, mempool_alloc_slab,
 				   mempool_free_slab, _cmd_cache);
-	if (!_cmd_pool) {
-		mempool_destroy(_sio_pool);
-		kmem_cache_destroy(_cte_cache);
-		kmem_cache_destroy(_cmd_cache);
-		kmem_cache_destroy(_sio_cache);
-	}
+	if (!_cmd_pool)
+		goto bad_cmd_pool;
 
 	_cte_pool = mempool_create(MIN_CTE_NUM, mempool_alloc_slab,
 				   mempool_free_slab, _cte_cache);
-	if (!_cte_pool) {
-		mempool_destroy(_cmd_pool);
-		mempool_destroy(_sio_pool);
-		kmem_cache_destroy(_cte_cache);
-		kmem_cache_destroy(_cmd_cache);
-		kmem_cache_destroy(_sio_cache);
-	}
+	if (!_cte_pool)
+		goto bad_cte_pool;
 
 	return 0;
+
+bad_cte_pool:
+	mempool_destroy(_cmd_pool);
+bad_cmd_pool:
+	mempool_destroy(_sio_pool);
+bad_sio_pool:
+	kmem_cache_destroy(_cte_cache);
+bad_cte_cache:
+	kmem_cache_destroy(_cmd_cache);
+bad_cmd_cache:
+	kmem_cache_destroy(_sio_cache);	
+
+	return -ENOMEM;
 }
 
 static void pool_exit(void)
@@ -1280,7 +1264,7 @@ retry:
 			busy++;
 			continue;
 		}
-		/* Can only eject CLEAN entries */
+		/* Can only evict CLEAN entries */
 		if (!cte_is_clean(cte, sio->bio_mask)) {
 #ifdef SSD_DEBUG
 			DPRINTK("%lu: %s (cte %lx:%x): skip not-clean cte",
@@ -1387,6 +1371,7 @@ static void sio_lookup_async(struct ssdcache_io *sio)
 	}
 }
 
+#ifdef SSD_DEBUG
 static void sio_in_flight(void)
 {
 	struct ssdcache_io *sio;
@@ -1400,6 +1385,7 @@ static void sio_in_flight(void)
 	spin_unlock_irqrestore(&_work_lock, flags);
 	DPRINTK("%d sios in flight", in_flight);
 }
+#endif
 
 /*
  * process_sio
@@ -1726,7 +1712,7 @@ static int ssdcache_parse_options(struct dm_target *ti,
 	unsigned int argc;
 	const char *opt_name;
 	static struct dm_arg _args[] = {
-		{0, 5, "invalid number of options"},
+		{0, 7, "invalid number of options"},
 	};
 
 	r = dm_read_arg_group(_args, as, &argc, &ti->error);
@@ -1831,7 +1817,12 @@ void ssdcache_format_options(struct ssdcache_ctx *sc, char *optstr)
 }
 
 /*
- * Construct a ssdcache mapping: <target_dev_path> <cache_dev_path>
+ * Construct an ssdcache mapping:
+ *
+ * ssdcache <target_dev_path> <cache_dev_path>
+ * [blocksize <value>] [assoc <value>] [writeback|writethrough|readcache]
+ * [options <#option args> [lfu|lru] [async_lookup] [queue_busy]
+ *       [disable_writeback] [skip_write_insert] [evict_on_write] [cmd_preload] ]
  */
 static int ssdcache_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
@@ -1849,35 +1840,35 @@ static int ssdcache_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	sc = kzalloc(sizeof(*sc), GFP_KERNEL);
 	if (sc == NULL) {
-		ti->error = "dm-ssdcache: Cannot allocate ssdcache context";
+		ti->error = "Cannot allocate ssdcache context";
 		return -ENOMEM;
 	}
 
 	devname = dm_shift_arg(&as);
 	if (!devname) {
-		ti->error = "dm-ssdcache: Target device is not specified";
+		ti->error = "Target device is not specified";
 		r = -EINVAL;
 		goto bad;
 	}
 	if (dm_get_device(ti, devname, dm_table_get_mode(ti->table),
 			  &sc->target_dev)) {
-		ti->error = "dm-ssdcache: Target device lookup failed";
+		ti->error = "Target device lookup failed";
 		r = -EINVAL;
 		goto bad;
 	}
 
 	devname = dm_shift_arg(&as);
 	if (!devname) {
-		ti->error = "dm-ssdcache: Cache device is not specified";
+		ti->error = "Cache device is not specified";
 		r = -EINVAL;
-		goto bad;
+		goto bad_cache_dev;
 	}
 	if (dm_get_device(ti, devname, dm_table_get_mode(ti->table),
 			  &sc->cache_dev)) {
-		ti->error = "dm-ssdcache: Cache device lookup failed";
+		ti->error = "Cache device lookup failed";
 		dm_put_device(ti, sc->target_dev);
 		r = -EINVAL;
-		goto bad;
+		goto bad_cache_dev;
 	}
 
 	sc->block_size = DEFAULT_BLOCKSIZE;
@@ -1968,8 +1959,9 @@ static int ssdcache_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	return 0;
 
 bad_io_client:
-	dm_put_device(ti, sc->target_dev);
 	dm_put_device(ti, sc->cache_dev);
+bad_cache_dev:
+	dm_put_device(ti, sc->target_dev);
 bad:
 	kfree(sc);
 	return r;
@@ -2121,11 +2113,17 @@ static int ssdcache_status(struct dm_target *ti, status_type_t type,
 static int ssdcache_iterate_devices(struct dm_target *ti,
 				  iterate_devices_callout_fn fn, void *data)
 {
+	int r = 0;
 	struct ssdcache_ctx *sc = ti->private;
 
 	if (!sc)
 		return 0;
-	return fn(ti, sc->target_dev, 0, ti->len, data);
+
+	r = fn(ti, sc->cache_dev, 0, ti->len, data);
+	if (!r)
+		r = fn(ti, sc->target_dev, 0, ti->len, data);
+
+	return r;
 }
 
 static struct target_type ssdcache_target = {

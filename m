From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm thin: fix pool target flags that control
	discard
Date: Fri, 23 Mar 2012 17:55:02 -0400
Message-ID: <20120323215502.GB11054@redhat.com>
References: <20120316152156.GA8836@ubuntu>
	<1331911358-8848-1-git-send-email-ejt@redhat.com>
	<1331911358-8848-11-git-send-email-ejt@redhat.com>
	<20120323123747.GB16214@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120323123747.GB16214@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

On Fri, Mar 23 2012 at  8:37am -0400,
Alasdair G Kergon <agk@redhat.com> wrote:

> On Fri, Mar 16, 2012 at 03:22:34PM +0000, Joe Thornber wrote:
> > +      'ignore_discard': disable discard support
> > +      'no_discard_passdown': don't pass discards down to the underlying data device
> 
> If someone reloads the pool target changing either of these options, how do connected
> thin targets pick up the change?  If they don't pick it up automatically, how do you
> determine whether they did or didn't pick it up - is that internal state not
> exposed to userspace yet?

Here are various fixes for dm_thin-add-pool-target-flags-to-control-discard.patch

o wire up 'discard_passdown' so that it does control whether or not the
  discard is passed to the pool's underlying data device
o disallow disabling discards if a pool was already configured with
  discards enabled (the default)
  - justification is inlined in the code
  - required pool_ctr knowing whether pool was created or not; so added
    'created' flag to __pool_find()
o if 'discard_passdown' is enabled (the default) verify that the pool's
  data device supports discards; if not warn and disable discard_passdown
o the pool device's discard support should _not_ be limited by whether
  'discard_passdown' is enabled or not.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c |   41 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 34 insertions(+), 7 deletions(-)

Index: linux/drivers/md/dm-thin.c
===================================================================
--- linux.orig/drivers/md/dm-thin.c
+++ linux/drivers/md/dm-thin.c
@@ -1209,7 +1209,7 @@ static void process_discard(struct thin_
 			 */
 			m = get_next_mapping(pool);
 			m->tc = tc;
-			m->pass_discard = !lookup_result.shared;
+			m->pass_discard = (!lookup_result.shared) & pool->pf.discard_passdown;
 			m->virt_block = block;
 			m->data_block = lookup_result.block;
 			m->cell = cell;
@@ -1790,7 +1790,8 @@ static void __pool_dec(struct pool *pool
 
 static struct pool *__pool_find(struct mapped_device *pool_md,
 				struct block_device *metadata_dev,
-				unsigned long block_size, char **error)
+				unsigned long block_size, char **error,
+				int *created)
 {
 	struct pool *pool = __pool_table_lookup_metadata_dev(metadata_dev);
 
@@ -1806,8 +1807,10 @@ static struct pool *__pool_find(struct m
 				return ERR_PTR(-EINVAL);
 			__pool_inc(pool);
 
-		} else
+		} else {
 			pool = pool_create(pool_md, metadata_dev, block_size, error);
+			*created = 1;
+		}
 	}
 
 	return pool;
@@ -1887,7 +1890,7 @@ static int parse_pool_features(struct dm
  */
 static int pool_ctr(struct dm_target *ti, unsigned argc, char **argv)
 {
-	int r;
+	int r, pool_created = 0;
 	struct pool_c *pt;
 	struct pool *pool;
 	struct pool_features pf;
@@ -1961,12 +1964,36 @@ static int pool_ctr(struct dm_target *ti
 	}
 
 	pool = __pool_find(dm_table_get_md(ti->table), metadata_dev->bdev,
-			   block_size, &ti->error);
+			   block_size, &ti->error, &pool_created);
 	if (IS_ERR(pool)) {
 		r = PTR_ERR(pool);
 		goto out_free_pt;
 	}
 
+	/*
+	 * 'pool_created' reflects whether this is the first table load.
+	 * Discard support is not allowed to be disabled after initial load.
+	 * Disabling it would require a pool reload to trigger thin device
+	 * changes (e.g. ti->discards_supported and QUEUE_FLAG_DISCARD).
+	 */
+	if (!pool_created && !pf.discard_enabled && pool->pf.discard_enabled) {
+		ti->error = "Discard support cannot be disabled once enabled";
+		r = -EINVAL;
+		goto out_free_pt;
+	}
+
+	/*
+	 * If discard_passdown was enabled verify that the data device
+	 * supports discards.  Disable discard_passdown if not.
+	 */
+	if (pf.discard_passdown) {
+		struct request_queue *q = bdev_get_queue(data_dev->bdev);
+		if (!q || !blk_queue_discard(q)) {
+			DMWARN("Discard unsupported by data device, disabling discard passdown");
+			pf.discard_passdown = 0;
+		}
+	}
+
 	pt->pool = pool;
 	pt->ti = ti;
 	pt->metadata_dev = metadata_dev;
@@ -1974,9 +2001,9 @@ static int pool_ctr(struct dm_target *ti
 	pt->low_water_blocks = low_water_blocks;
 	pt->pf = pf;
 	ti->num_flush_requests = 1;
-	if (pf.discard_enabled && pf.discard_passdown) {
-		ti->discards_supported = 1;
+	if (pf.discard_enabled) {
 		ti->num_discard_requests = 1;
+		ti->discards_supported = 1;
 	}
 	ti->private = pt;
 

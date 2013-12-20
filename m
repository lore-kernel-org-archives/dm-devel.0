From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-3.14 15/20] dm thin: add error_if_no_space
	feature
Date: Fri, 20 Dec 2013 18:37:28 -0500
Message-ID: <1387582653-13647-16-git-send-email-snitzer@redhat.com>
References: <1387582653-13647-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1387582653-13647-1-git-send-email-snitzer@redhat.com>
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
List-Id: dm-devel.ids

If the pool runs out of data or metadata space, the pool can either
queue or error the IO destined to the data device.  The default is to
queue the IO until more space is added.

An admin may now configure the pool to error IO when no space is
available by setting the 'error_if_no_space' feature when loading the
thin-pool table.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Joe Thornber <ejt@redhat.com>
---
 Documentation/device-mapper/thin-provisioning.txt |  7 +++++
 drivers/md/dm-thin.c                              | 31 ++++++++++++++++++-----
 2 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/Documentation/device-mapper/thin-provisioning.txt b/Documentation/device-mapper/thin-provisioning.txt
index 50c44cf..8a7a3d4 100644
--- a/Documentation/device-mapper/thin-provisioning.txt
+++ b/Documentation/device-mapper/thin-provisioning.txt
@@ -235,6 +235,8 @@ i) Constructor
       read_only: Don't allow any changes to be made to the pool
 		 metadata.
 
+      error_if_no_space: Error IOs, instead of queueing, if no space.
+
     Data block size must be between 64KB (128 sectors) and 1GB
     (2097152 sectors) inclusive.
 
@@ -276,6 +278,11 @@ ii) Status
 	contain the string 'Fail'.  The userspace recovery tools
 	should then be used.
 
+    error_if_no_space|queue_if_no_space
+	If the pool runs out of data or metadata space, the pool will
+	either queue or error the IO destined to the data device.  The
+	default is to queue the IO until more space is added.
+
 iii) Messages
 
     create_thin <dev id>
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 6e747eb..f16c3e4 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -144,6 +144,7 @@ struct pool_features {
 	bool zero_new_blocks:1;
 	bool discard_enabled:1;
 	bool discard_passdown:1;
+	bool error_if_no_space:1;
 };
 
 struct thin_c;
@@ -1444,6 +1445,9 @@ static void set_no_free_space(struct pool *pool)
 {
 	unsigned long flags;
 
+	if (pool->pf.error_if_no_space)
+		return;
+
 	spin_lock_irqsave(&pool->lock, flags);
 	pool->no_free_space = true;
 	spin_unlock_irqrestore(&pool->lock, flags);
@@ -1727,6 +1731,7 @@ static void pool_features_init(struct pool_features *pf)
 	pf->zero_new_blocks = true;
 	pf->discard_enabled = true;
 	pf->discard_passdown = true;
+	pf->error_if_no_space = false;
 }
 
 static void __pool_destroy(struct pool *pool)
@@ -1972,6 +1977,9 @@ static int parse_pool_features(struct dm_arg_set *as, struct pool_features *pf,
 		else if (!strcasecmp(arg_name, "read_only"))
 			pf->mode = PM_READ_ONLY;
 
+		else if (!strcasecmp(arg_name, "error_if_no_space"))
+			pf->error_if_no_space = true;
+
 		else {
 			ti->error = "Unrecognised pool feature requested";
 			r = -EINVAL;
@@ -2042,6 +2050,8 @@ static dm_block_t calc_metadata_threshold(struct pool_c *pt)
  *	     skip_block_zeroing: skips the zeroing of newly-provisioned blocks.
  *	     ignore_discard: disable discard
  *	     no_discard_passdown: don't pass discards down to the data device
+ *	     read_only: Don't allow any changes to be made to the pool metadata.
+ *	     error_if_no_space: error IOs, instead of queueing, if no space.
  */
 static int pool_ctr(struct dm_target *ti, unsigned argc, char **argv)
 {
@@ -2559,7 +2569,8 @@ static void emit_flags(struct pool_features *pf, char *result,
 		       unsigned sz, unsigned maxlen)
 {
 	unsigned count = !pf->zero_new_blocks + !pf->discard_enabled +
-		!pf->discard_passdown + (pf->mode == PM_READ_ONLY);
+		!pf->discard_passdown + (pf->mode == PM_READ_ONLY) +
+		pf->error_if_no_space;
 	DMEMIT("%u ", count);
 
 	if (!pf->zero_new_blocks)
@@ -2573,6 +2584,9 @@ static void emit_flags(struct pool_features *pf, char *result,
 
 	if (pf->mode == PM_READ_ONLY)
 		DMEMIT("read_only ");
+
+	if (pf->error_if_no_space)
+		DMEMIT("error_if_no_space ");
 }
 
 /*
@@ -2667,11 +2681,16 @@ static void pool_status(struct dm_target *ti, status_type_t type,
 			DMEMIT("rw ");
 
 		if (!pool->pf.discard_enabled)
-			DMEMIT("ignore_discard");
+			DMEMIT("ignore_discard ");
 		else if (pool->pf.discard_passdown)
-			DMEMIT("discard_passdown");
+			DMEMIT("discard_passdown ");
+		else
+			DMEMIT("no_discard_passdown ");
+
+		if (pool->pf.error_if_no_space)
+			DMEMIT("error_if_no_space ");
 		else
-			DMEMIT("no_discard_passdown");
+			DMEMIT("queue_if_no_space ");
 
 		break;
 
@@ -2770,7 +2789,7 @@ static struct target_type pool_target = {
 	.name = "thin-pool",
 	.features = DM_TARGET_SINGLETON | DM_TARGET_ALWAYS_WRITEABLE |
 		    DM_TARGET_IMMUTABLE,
-	.version = {1, 9, 0},
+	.version = {1, 10, 0},
 	.module = THIS_MODULE,
 	.ctr = pool_ctr,
 	.dtr = pool_dtr,
@@ -3057,7 +3076,7 @@ static int thin_iterate_devices(struct dm_target *ti,
 
 static struct target_type thin_target = {
 	.name = "thin",
-	.version = {1, 9, 0},
+	.version = {1, 10, 0},
 	.module	= THIS_MODULE,
 	.ctr = thin_ctr,
 	.dtr = thin_dtr,
-- 
1.8.1.4

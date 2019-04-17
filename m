From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 2/3] dm thin metadata: do not write metadata
 if no changes occurred
Date: Tue, 16 Apr 2019 21:30:50 -0400
Message-ID: <20190417013050.GA25356@redhat.com>
References: <20190415211717.18737-1-snitzer@redhat.com>
	<20190415211717.18737-3-snitzer@redhat.com>
	<20190416023903.GA19565@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20190416023903.GA19565@redhat.com>
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
Cc: ejt@redhat.com
List-Id: dm-devel.ids

Otherwise, just loading a thin-pool and then removing it will cause its
metadata to be changed (e.g. superblock written) -- even without any
thin devices being made active or metadata snapshot being manipulated.

Add 'in_service' flag to struct dm_pool_metadata and use a new
dm_pool_set_in_service() interface to set it if either a thin device is
activated or a message is sent to the thin-pool.  Once 'in_service' is
set it is never cleared.  __commit_transaction() will return 0 if
'in_service' is not set.

Also fix dm_pool_commit_metadata() to open the next transaction if the
return from __commit_transaction() is 0.  Not seeing why the early
return ever made since for a return of 0 given that dm-io's async_io(),
as used by bufio, always returns 0.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin-metadata.c | 23 ++++++++++++++++++++++-
 drivers/md/dm-thin-metadata.h |  2 ++
 drivers/md/dm-thin.c          |  9 +++++++++
 3 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index 7381e477a945..fcff30fc07cd 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -201,6 +201,13 @@ struct dm_pool_metadata {
 	 */
 	bool fail_io:1;
 
+	/*
+	 * Set once a thin-pool has been accessed through one of the interfaces
+	 * that imply the pool is in-service (e.g. thin devices created/deleted,
+	 * thin-pool message, metadata snapshots, etc).
+	 */
+	bool in_service:1;
+
 	/*
 	 * Reading the space map roots can fail, so we read it into these
 	 * buffers before the superblock is locked and updated.
@@ -790,6 +797,9 @@ static int __commit_transaction(struct dm_pool_metadata *pmd)
 	 */
 	BUILD_BUG_ON(sizeof(struct thin_disk_superblock) > 512);
 
+	if (unlikely(!pmd->in_service))
+		return 0;
+
 	r = __write_changed_details(pmd);
 	if (r < 0)
 		return r;
@@ -853,6 +863,7 @@ struct dm_pool_metadata *dm_pool_metadata_open(struct block_device *bdev,
 	pmd->time = 0;
 	INIT_LIST_HEAD(&pmd->thin_devices);
 	pmd->fail_io = false;
+	pmd->in_service = false;
 	pmd->bdev = bdev;
 	pmd->data_block_size = data_block_size;
 
@@ -1727,6 +1738,16 @@ int dm_pool_dec_data_range(struct dm_pool_metadata *pmd, dm_block_t b, dm_block_
 	return r;
 }
 
+void dm_pool_set_in_service(struct dm_pool_metadata *pmd)
+{
+	if (!pmd->in_service) {
+		down_write(&pmd->root_lock);
+		if (!pmd->in_service)
+			pmd->in_service = true;
+		up_write(&pmd->root_lock);
+	}
+}
+
 bool dm_thin_changed_this_transaction(struct dm_thin_device *td)
 {
 	int r;
@@ -1787,7 +1808,7 @@ int dm_pool_commit_metadata(struct dm_pool_metadata *pmd)
 		goto out;
 
 	r = __commit_transaction(pmd);
-	if (r <= 0)
+	if (r < 0)
 		goto out;
 
 	/*
diff --git a/drivers/md/dm-thin-metadata.h b/drivers/md/dm-thin-metadata.h
index f6be0d733c20..8192530984be 100644
--- a/drivers/md/dm-thin-metadata.h
+++ b/drivers/md/dm-thin-metadata.h
@@ -47,6 +47,8 @@ struct dm_pool_metadata *dm_pool_metadata_open(struct block_device *bdev,
 
 int dm_pool_metadata_close(struct dm_pool_metadata *pmd);
 
+void dm_pool_set_in_service(struct dm_pool_metadata *pmd);
+
 /*
  * Compat feature flags.  Any incompat flags beyond the ones
  * specified below will prevent use of the thin metadata.
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index fcd887703f95..b6dbbdfc9118 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3822,6 +3822,13 @@ static int pool_message(struct dm_target *ti, unsigned argc, char **argv,
 		return -EOPNOTSUPP;
 	}
 
+	/*
+	 * Any message sent to a thin-pool warrants putting it in-service
+	 * (even if the message is malformed, it speaks to a user
+	 *  attempting to interface with the thin-pool)
+	 */
+	dm_pool_set_in_service(pool->pmd);
+
 	if (!strcasecmp(argv[0], "create_thin"))
 		r = process_create_thin_mesg(argc, argv, pool);
 
@@ -4222,6 +4229,8 @@ static int thin_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		goto bad_pool;
 	}
 
+	dm_pool_set_in_service(tc->pool->pmd);
+
 	r = dm_pool_open_thin_device(tc->pool->pmd, tc->dev_id, &tc->td);
 	if (r) {
 		ti->error = "Couldn't open thin internal device";
-- 
2.18.0

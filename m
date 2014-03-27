From: Joe Thornber <ejt@redhat.com>
Subject: [PATCH 2/4] [persistent-data] change the semantics of
	dm_tm_commit().
Date: Thu, 27 Mar 2014 14:13:21 +0000
Message-ID: <1395929603-14604-3-git-send-email-ejt@redhat.com>
References: <1395929603-14604-1-git-send-email-ejt@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1395929603-14604-1-git-send-email-ejt@redhat.com>
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
Cc: Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

Now it assumes all data has been flushed apart from the single
superblock passed in.
---
 drivers/md/persistent-data/dm-transaction-manager.c |    5 +++--
 drivers/md/persistent-data/dm-transaction-manager.h |   17 ++++++++---------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/md/persistent-data/dm-transaction-manager.c b/drivers/md/persistent-data/dm-transaction-manager.c
index 81da1a2..3bc30a0 100644
--- a/drivers/md/persistent-data/dm-transaction-manager.c
+++ b/drivers/md/persistent-data/dm-transaction-manager.c
@@ -154,7 +154,7 @@ int dm_tm_pre_commit(struct dm_transaction_manager *tm)
 	if (r < 0)
 		return r;
 
-	return 0;
+	return dm_bm_flush(tm->bm);
 }
 EXPORT_SYMBOL_GPL(dm_tm_pre_commit);
 
@@ -164,8 +164,9 @@ int dm_tm_commit(struct dm_transaction_manager *tm, struct dm_block *root)
 		return -EWOULDBLOCK;
 
 	wipe_shadow_table(tm);
+	dm_bm_unlock(root);
 
-	return dm_bm_flush_and_unlock(tm->bm, root);
+	return dm_bm_flush(tm->bm);
 }
 EXPORT_SYMBOL_GPL(dm_tm_commit);
 
diff --git a/drivers/md/persistent-data/dm-transaction-manager.h b/drivers/md/persistent-data/dm-transaction-manager.h
index b5b1390..2772ed2 100644
--- a/drivers/md/persistent-data/dm-transaction-manager.h
+++ b/drivers/md/persistent-data/dm-transaction-manager.h
@@ -38,18 +38,17 @@ struct dm_transaction_manager *dm_tm_create_non_blocking_clone(struct dm_transac
 /*
  * We use a 2-phase commit here.
  *
- * i) In the first phase the block manager is told to start flushing, and
- * the changes to the space map are written to disk.  You should interrogate
- * your particular space map to get detail of its root node etc. to be
- * included in your superblock.
+ * i) Make all changes for the transaction *except* for the superblock.
+ * Then call dm_tm_pre_commit() to flush them to disk.
  *
- * ii) @root will be committed last.  You shouldn't use more than the
- * first 512 bytes of @root if you wish the transaction to survive a power
- * failure.  You *must* have a write lock held on @root for both stage (i)
- * and (ii).  The commit will drop the write lock.
+ * ii) Lock your superblock.  Update.  Then call dm_tm_commit() which will
+ * unlock the superblock and flush it.  No other blocks should be updated
+ * during this period.  Care should be taken to never unlock a partially
+ * updated superblock; perform any operations that could fail *before* you
+ * take the superblock lock.
  */
 int dm_tm_pre_commit(struct dm_transaction_manager *tm);
-int dm_tm_commit(struct dm_transaction_manager *tm, struct dm_block *root);
+int dm_tm_commit(struct dm_transaction_manager *tm, struct dm_block *superblock);
 
 /*
  * These methods are the only way to get hold of a writeable block.
-- 
1.7.10.4

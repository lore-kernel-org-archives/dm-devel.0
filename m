From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] make dm_{,un}register_dirty_log_type() static
Date: Mon, 31 Mar 2008 02:28:24 +0300
Message-ID: <20080330232824.GV28445@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756854AbYC3X2u@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

This patch makes the needlessly global dm_{,un}register_dirty_log_type() 
static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/md/dm-log.c |    6 ++----
 drivers/md/dm-log.h |    3 ---
 2 files changed, 2 insertions(+), 7 deletions(-)

5d0ca5f52a1c756246411406890c10b2d5cdd081 diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index 2a74b21..0d65cc7 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -17,7 +17,7 @@
 static LIST_HEAD(_log_types);
 static DEFINE_SPINLOCK(_lock);
 
-int dm_register_dirty_log_type(struct dirty_log_type *type)
+static int dm_register_dirty_log_type(struct dirty_log_type *type)
 {
 	spin_lock(&_lock);
 	type->use_count = 0;
@@ -27,7 +27,7 @@ int dm_register_dirty_log_type(struct dirty_log_type *type)
 	return 0;
 }
 
-int dm_unregister_dirty_log_type(struct dirty_log_type *type)
+static int dm_unregister_dirty_log_type(struct dirty_log_type *type)
 {
 	spin_lock(&_lock);
 
@@ -782,7 +782,5 @@ void dm_dirty_log_exit(void)
 	dm_unregister_dirty_log_type(&_core_type);
 }
 
-EXPORT_SYMBOL(dm_register_dirty_log_type);
-EXPORT_SYMBOL(dm_unregister_dirty_log_type);
 EXPORT_SYMBOL(dm_create_dirty_log);
 EXPORT_SYMBOL(dm_destroy_dirty_log);
diff --git a/drivers/md/dm-log.h b/drivers/md/dm-log.h
index 3fae87e..c45fc25 100644
--- a/drivers/md/dm-log.h
+++ b/drivers/md/dm-log.h
@@ -110,9 +110,6 @@ struct dirty_log_type {
 		      char *result, unsigned int maxlen);
 };
 
-int dm_register_dirty_log_type(struct dirty_log_type *type);
-int dm_unregister_dirty_log_type(struct dirty_log_type *type);
-
 
 /*
  * Make sure you use these two functions, rather than calling

From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] make dm_dirty_log_{init,exit}() static
Date: Mon, 28 Apr 2008 18:39:06 +0300
Message-ID: <20080428153906.GK2813@cs181133002.pp.htv.fi>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Heinz Mauelshagen <hjm@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-Id: dm-devel.ids

dm_dirty_log_{init,exit}() can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/md/dm-log.c |    4 ++--
 drivers/md/dm.h     |    6 ------
 2 files changed, 2 insertions(+), 8 deletions(-)

9fc29a7361124f1b56119645584cbe17d59e0e02 diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index 67a6f31..5b48478 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -831,7 +831,7 @@ static struct dm_dirty_log_type _disk_type = {
 	.status = disk_status,
 };
 
-int __init dm_dirty_log_init(void)
+static int __init dm_dirty_log_init(void)
 {
 	int r;
 
@@ -848,7 +848,7 @@ int __init dm_dirty_log_init(void)
 	return r;
 }
 
-void __exit dm_dirty_log_exit(void)
+static void __exit dm_dirty_log_exit(void)
 {
 	dm_dirty_log_type_unregister(&_disk_type);
 	dm_dirty_log_type_unregister(&_core_type);
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 8c03b63..1e59a0b 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -100,12 +100,6 @@ int dm_lock_for_deletion(struct mapped_device *md);
 
 void dm_kobject_uevent(struct mapped_device *md);
 
-/*
- * Dirty log
- */
-int dm_dirty_log_init(void);
-void dm_dirty_log_exit(void);
-
 int dm_kcopyd_init(void);
 void dm_kcopyd_exit(void);
 

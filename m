From: Heinz Mauelshagen <hjm@redhat.com>
Subject: [RFC PATCH 3/4] dm-log: adjust dm-raid1.c to cope with
	standalone dirty region log module
Date: Tue,  4 Mar 2008 15:28:30 +0100
Message-ID: <1204640911-28469-4-git-send-email-hjm@redhat.com>
References: <1204640911-28469-1-git-send-email-hjm@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1204640911-28469-1-git-send-email-hjm@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Heinz Mauelshagen <hjm@redhat.com>
List-Id: dm-devel.ids

Remove any dirty_log_{init,exit}() calls from dm-raid1.c to
allow it to share the standalone dm-log.ko with other targets.

Signed-off-by: Heinz Mauelshagen <hjm@redhat.com>
---
 drivers/md/dm-raid1.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git 2.6.25-rc3.orig/drivers/md/dm-raid1.c 2.6.25-rc3/drivers/md/dm-raid1.c
index 5160587..37afe35 100644
--- 2.6.25-rc3.orig/drivers/md/dm-raid1.c
+++ 2.6.25-rc3/drivers/md/dm-raid1.c
@@ -1864,15 +1864,9 @@ static int __init dm_mirror_init(void)
 {
 	int r;
 
-	r = dm_dirty_log_init();
-	if (r)
-		return r;
-
 	r = dm_register_target(&mirror_target);
-	if (r < 0) {
+	if (r < 0)
 		DMERR("Failed to register mirror target");
-		dm_dirty_log_exit();
-	}
 
 	return r;
 }
@@ -1884,8 +1878,6 @@ static void __exit dm_mirror_exit(void)
 	r = dm_unregister_target(&mirror_target);
 	if (r < 0)
 		DMERR("unregister failed %d", r);
-
-	dm_dirty_log_exit();
 }
 
 /* Module hooks */
-- 
1.5.4.1

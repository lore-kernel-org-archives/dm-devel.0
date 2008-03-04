From: Heinz Mauelshagen <hjm@redhat.com>
Subject: [RFC PATCH 1/4] dm-log: export dm_disk from dm.c
Date: Tue,  4 Mar 2008 15:28:28 +0100
Message-ID: <1204640911-28469-2-git-send-email-hjm@redhat.com>
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


Export dm_disk.


Signed-off-by: Heinz Mauelshagen <hjm@redhat.com>
---
 drivers/md/dm.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git 2.6.25-rc3.orig/drivers/md/dm.c 2.6.25-rc3/drivers/md/dm.c
index 6617ce4..30da5eb 100644
--- 2.6.25-rc3.orig/drivers/md/dm.c
+++ 2.6.25-rc3/drivers/md/dm.c
@@ -1626,6 +1626,7 @@ struct gendisk *dm_disk(struct mapped_device *md)
 {
 	return md->disk;
 }
+EXPORT_SYMBOL_GPL(dm_disk);
 
 int dm_suspended(struct mapped_device *md)
 {
-- 
1.5.4.1

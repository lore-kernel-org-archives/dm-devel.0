From: heinzm@redhat.com
Subject: [PATCH 2/3] dm core: export dm_disk to allow for dm-raid
	to pass it on to the MD raid0 personality
Date: Fri, 17 Apr 2015 14:39:45 +0200
Message-ID: <1429274386-16385-3-git-send-email-heinzm@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

This patch is a prerequisite for dm-raid "raid0" support to allow
dm-raid to set rs->md.gendisk, which is required by the MD RAID0
pesonality to set disk stacking limits.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>

---
 drivers/md/dm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 8001fe9..f11e2f5 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -3206,6 +3206,7 @@ struct gendisk *dm_disk(struct mapped_device *md)
 {
 	return md->disk;
 }
+EXPORT_SYMBOL_GPL(dm_disk);
 
 struct kobject *dm_kobject(struct mapped_device *md)
 {
-- 
2.1.0

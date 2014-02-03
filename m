From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/6] dm: implement dm_md_get_queue()
Date: Mon,  3 Feb 2014 09:18:09 +0100
Message-ID: <1391415493-102943-3-git-send-email-hare@suse.de>
References: <1391415493-102943-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1391415493-102943-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

From: Mike Snitzer <snitzer@redhat.com>

Add wrapper to extract the request_queue from a
mapped device.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm.c | 5 +++++
 drivers/md/dm.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 0704c52..933b8cb 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -475,6 +475,11 @@ sector_t dm_get_size(struct mapped_device *md)
 	return get_capacity(md->disk);
 }
 
+struct request_queue *dm_get_md_queue(struct mapped_device *md)
+{
+	return md->queue;
+}
+
 struct dm_stats *dm_get_stats(struct mapped_device *md)
 {
 	return &md->stats;
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index c57ba55..0eef13a 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -172,6 +172,7 @@ int dm_lock_for_deletion(struct mapped_device *md, bool mark_deferred, bool only
 int dm_cancel_deferred_remove(struct mapped_device *md);
 int dm_request_based(struct mapped_device *md);
 sector_t dm_get_size(struct mapped_device *md);
+struct request_queue *dm_get_md_queue(struct mapped_device *md);
 struct dm_stats *dm_get_stats(struct mapped_device *md);
 
 int dm_kobject_uevent(struct mapped_device *md, enum kobject_action action,
-- 
1.7.12.4

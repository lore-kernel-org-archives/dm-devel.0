From: heinzm@redhat.com
Subject: [PATCH 4/6] dm raid45 target: export dm_disk from dm.c
Date: Mon, 15 Jun 2009 19:21:14 +0200
Message-ID: <4a36830a.cZK/mQ1GyjYq+axV%heinzm@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
List-Id: dm-devel.ids


This patch exports the dm_disk symbol needed by the raid45 target.

Heinz

 drivers/md/{dm.c.orig => dm.c} |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm.c.orig b/drivers/md/dm.c
index 424f7b0..208070e 100644
--- a/drivers/md/dm.c.orig
+++ b/drivers/md/dm.c
@@ -1762,6 +1762,7 @@ struct gendisk *dm_disk(struct mapped_device *md)
 {
 	return md->disk;
 }
+EXPORT_SYMBOL_GPL(dm_disk);
 
 struct kobject *dm_kobject(struct mapped_device *md)
 {

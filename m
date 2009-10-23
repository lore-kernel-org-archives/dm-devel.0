From: heinzm@redhat.com
Subject: [PATCH 6/6] dm-replicator: export dm_disk symbol
Date: Fri, 23 Oct 2009 17:16:57 +0200
Message-ID: <1256311017-11291-7-git-send-email-heinzm@redhat.com>
References: <1256311017-11291-1-git-send-email-heinzm@redhat.com>
	<1256311017-11291-2-git-send-email-heinzm@redhat.com>
	<1256311017-11291-3-git-send-email-heinzm@redhat.com>
	<1256311017-11291-4-git-send-email-heinzm@redhat.com>
	<1256311017-11291-5-git-send-email-heinzm@redhat.com>
	<1256311017-11291-6-git-send-email-heinzm@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1256311017-11291-6-git-send-email-heinzm@redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

Export symbol dm_disk(dm.c) used by "blockdev" site
link handler (dm-repl-slink-blockdev.c).

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Zdenek Kabelac <zkabelac@redhat.com>
---
 drivers/md/dm.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 724efc6..901b95e 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2573,6 +2573,7 @@ struct gendisk *dm_disk(struct mapped_device *md)
 {
 	return md->disk;
 }
+EXPORT_SYMBOL_GPL(dm_disk);
 
 struct kobject *dm_kobject(struct mapped_device *md)
 {
-- 
1.6.2.5

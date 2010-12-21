From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 2/8] md/bitmap: use DIV_ROUND_UP in bitmap_init_from_disk
Date: Mon, 20 Dec 2010 21:37:39 -0500
Message-ID: <1292899065-31943-3-git-send-email-snitzer@redhat.com>
References: <1292899065-31943-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1292899065-31943-1-git-send-email-snitzer@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: jbrassow@redhat.com, neilb@suse.de
Cc: agk@redhat.com, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

From: NeilBrown <neilb@suse.de>

Keep DIV_ROUND_UP changes from e384e58549a2e9a83071ad80280c1a9053cfd84c
  md/bitmap: prepare for storing write-intent-bitmap via dm-dirty-log.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/bitmap.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 2eb51cd..f3f5edc 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -925,11 +925,11 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 		printk(KERN_INFO "%s: bitmap file is out of date, doing full "
 			"recovery\n", bmname(bitmap));
 
-	bytes = (chunks + 7) / 8;
+	bytes = DIV_ROUND_UP(bitmap->chunks, 8);
 	if (!bitmap->mddev->bitmap_info.external)
 		bytes += sizeof(bitmap_super_t);
 
-	num_pages = (bytes + PAGE_SIZE - 1) / PAGE_SIZE;
+	num_pages = DIV_ROUND_UP(bytes, PAGE_SIZE);
 
 	if (file && i_size_read(file->f_mapping->host) < bytes) {
 		printk(KERN_INFO "%s: bitmap file too short %lu < %lu\n",
-- 
1.7.2.3


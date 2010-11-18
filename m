From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 2 of 9] md minor updates
Date: Thu, 18 Nov 2010 17:42:30 -0600
Message-ID: <201011182342.oAINgUTB010528@hydrogen.msp.redhat.com>
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
List-Id: dm-devel.ids

Patch name: md-minor-updates.patch

Changes from e384e58549a2e9a83071ad80280c1a9053cfd84c that should
be kept.  (i.e. those cosmetic changes that are unrelated to 
dm dirty log support.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/bitmap.c
===================================================================
--- linux-2.6.orig/drivers/md/bitmap.c
+++ linux-2.6/drivers/md/bitmap.c
@@ -925,11 +925,11 @@ static int bitmap_init_from_disk(struct 
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

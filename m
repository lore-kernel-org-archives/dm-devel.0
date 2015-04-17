From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 6/7] block/partitions: use block_device name vsprintf helper
Date: Fri, 17 Apr 2015 12:29:18 +0400
Message-ID: <1429259359-13480-7-git-send-email-dmonakhov@openvz.org>
References: <1429259359-13480-1-git-send-email-dmonakhov@openvz.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1429259359-13480-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, axboe@kernel.dk, viro@zeniv.linux.org.uk, dm-devel@redhat.com, Dmitry Monakhov <dmonakhov@openvz.org>
List-Id: dm-devel.ids

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 block/partition-generic.c |    3 ++-
 block/partitions/amiga.c  |   13 ++++++-------
 block/partitions/sgi.c    |    9 ++++-----
 block/partitions/sun.c    |    9 ++++-----
 4 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/block/partition-generic.c b/block/partition-generic.c
index 0d9e5f9..ae67f16 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -45,7 +45,8 @@ char *disk_name(struct gendisk *hd, int partno, char *buf)
 
 const char *bdevname(struct block_device *bdev, char *buf)
 {
-	return disk_name(bdev->bd_disk, bdev->bd_part->partno, buf);
+	snprintf(buf, BDEVNAME_SIZE, "%pg", bdev);
+	return buf;
 }
 
 EXPORT_SYMBOL(bdevname);
diff --git a/block/partitions/amiga.c b/block/partitions/amiga.c
index 2b13533..240f4f6 100644
--- a/block/partitions/amiga.c
+++ b/block/partitions/amiga.c
@@ -34,7 +34,6 @@ int amiga_partition(struct parsed_partitions *state)
 	int start_sect, nr_sects, blk, part, res = 0;
 	int blksize = 1;	/* Multiplier for disk block size */
 	int slot = 1;
-	char b[BDEVNAME_SIZE];
 
 	for (blk = 0; ; blk++, put_dev_sector(sect)) {
 		if (blk == RDB_ALLOCATION_LIMIT)
@@ -42,8 +41,8 @@ int amiga_partition(struct parsed_partitions *state)
 		data = read_part_sector(state, blk, &sect);
 		if (!data) {
 			if (warn_no_part)
-				pr_err("Dev %s: unable to read RDB block %d\n",
-				       bdevname(state->bdev, b), blk);
+				pr_err("Dev %pg: unable to read RDB block %d\n",
+				       state->bdev, blk);
 			res = -1;
 			goto rdb_done;
 		}
@@ -64,8 +63,8 @@ int amiga_partition(struct parsed_partitions *state)
 			break;
 		}
 
-		pr_err("Dev %s: RDB in block %d has bad checksum\n",
-		       bdevname(state->bdev, b), blk);
+		pr_err("Dev %pg: RDB in block %d has bad checksum\n",
+		       state->bdev, blk);
 	}
 
 	/* blksize is blocks per 512 byte standard block */
@@ -85,8 +84,8 @@ int amiga_partition(struct parsed_partitions *state)
 		data = read_part_sector(state, blk, &sect);
 		if (!data) {
 			if (warn_no_part)
-				pr_err("Dev %s: unable to read partition block %d\n",
-				       bdevname(state->bdev, b), blk);
+				pr_err("Dev %pg: unable to read partition block %d\n",
+				       state->bdev, blk);
 			res = -1;
 			goto rdb_done;
 		}
diff --git a/block/partitions/sgi.c b/block/partitions/sgi.c
index ea8a86d..b040277 100644
--- a/block/partitions/sgi.c
+++ b/block/partitions/sgi.c
@@ -37,7 +37,6 @@ int sgi_partition(struct parsed_partitions *state)
 	Sector sect;
 	struct sgi_disklabel *label;
 	struct sgi_partition *p;
-	char b[BDEVNAME_SIZE];
 
 	label = read_part_sector(state, 0, &sect);
 	if (!label)
@@ -45,8 +44,8 @@ int sgi_partition(struct parsed_partitions *state)
 	p = &label->partitions[0];
 	magic = label->magic_mushroom;
 	if(be32_to_cpu(magic) != SGI_LABEL_MAGIC) {
-		/*printk("Dev %s SGI disklabel: bad magic %08x\n",
-		       bdevname(bdev, b), be32_to_cpu(magic));*/
+		/*printk("Dev %pg SGI disklabel: bad magic %08x\n",
+		       bdev, be32_to_cpu(magic));*/
 		put_dev_sector(sect);
 		return 0;
 	}
@@ -56,8 +55,8 @@ int sgi_partition(struct parsed_partitions *state)
 		csum += be32_to_cpu(cs);
 	}
 	if(csum) {
-		printk(KERN_WARNING "Dev %s SGI disklabel: csum bad, label corrupted\n",
-		       bdevname(state->bdev, b));
+		printk(KERN_WARNING "Dev %pg SGI disklabel: csum bad, label corrupted\n",
+		       state->bdev);
 		put_dev_sector(sect);
 		return 0;
 	}
diff --git a/block/partitions/sun.c b/block/partitions/sun.c
index b5b6fcf..25343d6 100644
--- a/block/partitions/sun.c
+++ b/block/partitions/sun.c
@@ -57,7 +57,6 @@ int sun_partition(struct parsed_partitions *state)
 	} * label;
 	struct sun_partition *p;
 	unsigned long spc;
-	char b[BDEVNAME_SIZE];
 	int use_vtoc;
 	int nparts;
 
@@ -67,8 +66,8 @@ int sun_partition(struct parsed_partitions *state)
 
 	p = label->partitions;
 	if (be16_to_cpu(label->magic) != SUN_LABEL_MAGIC) {
-/*		printk(KERN_INFO "Dev %s Sun disklabel: bad magic %04x\n",
-		       bdevname(bdev, b), be16_to_cpu(label->magic)); */
+/*		printk(KERN_INFO "Dev %pg Sun disklabel: bad magic %04x\n",
+		       bdev, be16_to_cpu(label->magic)); */
 		put_dev_sector(sect);
 		return 0;
 	}
@@ -77,8 +76,8 @@ int sun_partition(struct parsed_partitions *state)
 	for (csum = 0; ush >= ((__be16 *) label);)
 		csum ^= *ush--;
 	if (csum) {
-		printk("Dev %s Sun disklabel: Csum bad, label corrupted\n",
-		       bdevname(state->bdev, b));
+		printk("Dev %pg Sun disklabel: Csum bad, label corrupted\n",
+		       state->bdev);
 		put_dev_sector(sect);
 		return 0;
 	}
-- 
1.7.1

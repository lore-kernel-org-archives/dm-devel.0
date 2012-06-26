From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 1 of 4] MD RAID10: rename mirror_info structure
Date: Tue, 26 Jun 2012 03:49:24 -0500
Message-ID: <1340700564.19015.15.camel@f16>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: dm-devel@redhat.com, linux-raid@vger.kernel.org
Cc: jbrassow@redhat.com, agk@redhat.com, neilb@suse.de
List-Id: dm-devel.ids

MD RAID10: Rename the structure 'mirror_info' to 'raid10_info'

The same structure name ('mirror_info') is used by raid1.  Each of these
structures are defined in there respective header files.  If dm-raid is
to support both RAID1 and RAID10, the header files will be included and
the structure names must not collide.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/raid10.c
===================================================================
--- linux-upstream.orig/drivers/md/raid10.c
+++ linux-upstream/drivers/md/raid10.c
@@ -1547,7 +1547,7 @@ static void error(struct mddev *mddev, s
 static void print_conf(struct r10conf *conf)
 {
 	int i;
-	struct mirror_info *tmp;
+	struct raid10_info *tmp;
 
 	printk(KERN_DEBUG "RAID10 conf printout:\n");
 	if (!conf) {
@@ -1581,7 +1581,7 @@ static int raid10_spare_active(struct md
 {
 	int i;
 	struct r10conf *conf = mddev->private;
-	struct mirror_info *tmp;
+	struct raid10_info *tmp;
 	int count = 0;
 	unsigned long flags;
 
@@ -1656,7 +1656,7 @@ static int raid10_add_disk(struct mddev
 	else
 		mirror = first;
 	for ( ; mirror <= last ; mirror++) {
-		struct mirror_info *p = &conf->mirrors[mirror];
+		struct raid10_info *p = &conf->mirrors[mirror];
 		if (p->recovery_disabled == mddev->recovery_disabled)
 			continue;
 		if (p->rdev) {
@@ -1710,7 +1710,7 @@ static int raid10_remove_disk(struct mdd
 	int err = 0;
 	int number = rdev->raid_disk;
 	struct md_rdev **rdevp;
-	struct mirror_info *p = conf->mirrors + number;
+	struct raid10_info *p = conf->mirrors + number;
 
 	print_conf(conf);
 	if (rdev == p->rdev)
@@ -2876,7 +2876,7 @@ static sector_t sync_request(struct mdde
 			sector_t sect;
 			int must_sync;
 			int any_working;
-			struct mirror_info *mirror = &conf->mirrors[i];
+			struct raid10_info *mirror = &conf->mirrors[i];
 
 			if ((mirror->rdev == NULL ||
 			     test_bit(In_sync, &mirror->rdev->flags))
@@ -3382,7 +3382,7 @@ static struct r10conf *setup_conf(struct
 		goto out;
 
 	/* FIXME calc properly */
-	conf->mirrors = kzalloc(sizeof(struct mirror_info)*(mddev->raid_disks +
+	conf->mirrors = kzalloc(sizeof(struct raid10_info)*(mddev->raid_disks +
 							    max(0,mddev->delta_disks)),
 				GFP_KERNEL);
 	if (!conf->mirrors)
@@ -3446,7 +3446,7 @@ static int run(struct mddev *mddev)
 {
 	struct r10conf *conf;
 	int i, disk_idx, chunk_size;
-	struct mirror_info *disk;
+	struct raid10_info *disk;
 	struct md_rdev *rdev;
 	sector_t size;
 	sector_t min_offset_diff = 0;
@@ -3799,7 +3799,7 @@ static int raid10_check_reshape(struct m
 	if (mddev->delta_disks > 0) {
 		/* allocate new 'mirrors' list */
 		conf->mirrors_new = kzalloc(
-			sizeof(struct mirror_info)
+			sizeof(struct raid10_info)
 			*(mddev->raid_disks +
 			  mddev->delta_disks),
 			GFP_KERNEL);
@@ -3924,7 +3924,7 @@ static int raid10_start_reshape(struct m
 	spin_lock_irq(&conf->device_lock);
 	if (conf->mirrors_new) {
 		memcpy(conf->mirrors_new, conf->mirrors,
-		       sizeof(struct mirror_info)*conf->prev.raid_disks);
+		       sizeof(struct raid10_info)*conf->prev.raid_disks);
 		smp_mb();
 		kfree(conf->mirrors_old); /* FIXME and elsewhere */
 		conf->mirrors_old = conf->mirrors;
Index: linux-upstream/drivers/md/raid10.h
===================================================================
--- linux-upstream.orig/drivers/md/raid10.h
+++ linux-upstream/drivers/md/raid10.h
@@ -1,7 +1,7 @@
 #ifndef _RAID10_H
 #define _RAID10_H
 
-struct mirror_info {
+struct raid10_info {
 	struct md_rdev	*rdev, *replacement;
 	sector_t	head_position;
 	int		recovery_disabled;	/* matches
@@ -13,8 +13,8 @@ struct mirror_info {
 
 struct r10conf {
 	struct mddev		*mddev;
-	struct mirror_info	*mirrors;
-	struct mirror_info	*mirrors_new, *mirrors_old;
+	struct raid10_info	*mirrors;
+	struct raid10_info	*mirrors_new, *mirrors_old;
 	spinlock_t		device_lock;
 
 	/* geometry */



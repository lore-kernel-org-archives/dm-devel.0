From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 2 of 4] MD RAID1: rename mirror_info structure
Date: Tue, 26 Jun 2012 03:52:02 -0500
Message-ID: <1340700722.19015.19.camel@f16>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: dm-devel@redhat.com, linux-raid@vger.kernel.org
Cc: jbrassow@redhat.com, neilb@suse.de, agk@redhat.com
List-Id: dm-devel.ids

MD RAID1: Rename the structure 'mirror_info' to 'raid1_info'

The same structure name ('mirror_info') is used by raid10.  Each of these
structures are defined in there respective header files.  If dm-raid is
to support both RAID1 and RAID10, the header files will be included and
the structure names must not collide.  While only one of these structure
names needs to change, this patch adds consistency to the naming of the
structure.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/raid1.c
===================================================================
--- linux-upstream.orig/drivers/md/raid1.c
+++ linux-upstream/drivers/md/raid1.c
@@ -873,7 +873,7 @@ do_sync_io:
 static void make_request(struct mddev *mddev, struct bio * bio)
 {
 	struct r1conf *conf = mddev->private;
-	struct mirror_info *mirror;
+	struct raid1_info *mirror;
 	struct r1bio *r1_bio;
 	struct bio *read_bio;
 	int i, disks;
@@ -1367,7 +1367,7 @@ static int raid1_add_disk(struct mddev *
 	struct r1conf *conf = mddev->private;
 	int err = -EEXIST;
 	int mirror = 0;
-	struct mirror_info *p;
+	struct raid1_info *p;
 	int first = 0;
 	int last = conf->raid_disks - 1;
 	struct request_queue *q = bdev_get_queue(rdev->bdev);
@@ -1436,7 +1436,7 @@ static int raid1_remove_disk(struct mdde
 	struct r1conf *conf = mddev->private;
 	int err = 0;
 	int number = rdev->raid_disk;
-	struct mirror_info *p = conf->mirrors+ number;
+	struct raid1_info *p = conf->mirrors + number;
 
 	if (rdev != p->rdev)
 		p = conf->mirrors + conf->raid_disks + number;
@@ -2517,7 +2517,7 @@ static struct r1conf *setup_conf(struct
 {
 	struct r1conf *conf;
 	int i;
-	struct mirror_info *disk;
+	struct raid1_info *disk;
 	struct md_rdev *rdev;
 	int err = -ENOMEM;
 
@@ -2525,7 +2525,7 @@ static struct r1conf *setup_conf(struct
 	if (!conf)
 		goto abort;
 
-	conf->mirrors = kzalloc(sizeof(struct mirror_info)
+	conf->mirrors = kzalloc(sizeof(struct raid1_info)
 				* mddev->raid_disks * 2,
 				 GFP_KERNEL);
 	if (!conf->mirrors)
@@ -2794,7 +2794,7 @@ static int raid1_reshape(struct mddev *m
 	 */
 	mempool_t *newpool, *oldpool;
 	struct pool_info *newpoolinfo;
-	struct mirror_info *newmirrors;
+	struct raid1_info *newmirrors;
 	struct r1conf *conf = mddev->private;
 	int cnt, raid_disks;
 	unsigned long flags;
@@ -2837,7 +2837,7 @@ static int raid1_reshape(struct mddev *m
 		kfree(newpoolinfo);
 		return -ENOMEM;
 	}
-	newmirrors = kzalloc(sizeof(struct mirror_info) * raid_disks * 2,
+	newmirrors = kzalloc(sizeof(struct raid1_info) * raid_disks * 2,
 			     GFP_KERNEL);
 	if (!newmirrors) {
 		kfree(newpoolinfo);
Index: linux-upstream/drivers/md/raid1.h
===================================================================
--- linux-upstream.orig/drivers/md/raid1.h
+++ linux-upstream/drivers/md/raid1.h
@@ -1,7 +1,7 @@
 #ifndef _RAID1_H
 #define _RAID1_H
 
-struct mirror_info {
+struct raid1_info {
 	struct md_rdev	*rdev;
 	sector_t	head_position;
 };
@@ -24,7 +24,7 @@ struct pool_info {
 
 struct r1conf {
 	struct mddev		*mddev;
-	struct mirror_info	*mirrors;	/* twice 'raid_disks' to
+	struct raid1_info	*mirrors;	/* twice 'raid_disks' to
 						 * allow for replacements.
 						 */
 	int			raid_disks;



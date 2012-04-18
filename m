From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 2 of 5] DM RAID: Record and handle missing devices
Date: Tue, 17 Apr 2012 21:37:43 -0500
Message-ID: <1334716663.23908.21.camel@f14.redhat.com>
References: <1334716219.23908.14.camel@f14.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1334716219.23908.14.camel@f14.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: dm-devel@redhat.com, linux-raid@vger.kernel.org
Cc: neilb@suse.de, agk@redhat.com
List-Id: dm-devel.ids

Missing dm-raid devices should be recorded in the superblock

When specifying the devices that compose a DM RAID array, it is possible to denote
failed or missing devices with '-'s.  When this occurs, we must record this in the
superblock.  We do this by checking if the array position's data device is missing
and then forcing MD to record the superblock by setting 'MD_CHANGE_DEVS' in
'raid_resume'.  If we do not cause the superblock to be rewritten by the resume
function, it is possible for a stale superblock to be written by an out-going
in-active table (during 'raid_dtr').

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/dm-raid.c
===================================================================
--- linux-upstream.orig/drivers/md/dm-raid.c
+++ linux-upstream/drivers/md/dm-raid.c
@@ -617,16 +617,18 @@ static int read_disk_sb(struct md_rdev *
 
 static void super_sync(struct mddev *mddev, struct md_rdev *rdev)
 {
-	struct md_rdev *r;
+	int i;
 	uint64_t failed_devices;
 	struct dm_raid_superblock *sb;
+	struct raid_set *rs = container_of(mddev, struct raid_set, md);
 
 	sb = page_address(rdev->sb_page);
 	failed_devices = le64_to_cpu(sb->failed_devices);
 
-	rdev_for_each(r, mddev)
-		if ((r->raid_disk >= 0) && test_bit(Faulty, &r->flags))
-			failed_devices |= (1ULL << r->raid_disk);
+	for (i = 0; i < mddev->raid_disks; i++)
+		if (!rs->dev[i].data_dev ||
+		    test_bit(Faulty, &(rs->dev[i].rdev.flags)))
+			failed_devices |= (1ULL << i);
 
 	memset(sb, 0, sizeof(*sb));
 
@@ -1252,6 +1254,7 @@ static void raid_resume(struct dm_target
 {
 	struct raid_set *rs = ti->private;
 
+	set_bit(MD_CHANGE_DEVS, &rs->md.flags);
 	if (!rs->bitmap_loaded) {
 		bitmap_load(&rs->md);
 		rs->bitmap_loaded = 1;



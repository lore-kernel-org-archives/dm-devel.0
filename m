From: heinzm@redhat.com
Subject: [PATCH v2 4/5] dm raid: use read_disk_sb() throughout
Date: Sat, 14 Jan 2017 03:53:10 +0100
Message-ID: <20170114025311.22762-5-heinzm@redhat.com>
References: <20170114025311.22762-1-heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170114025311.22762-1-heinzm@redhat.com>
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

For consistency, call read_disk_sb() from
attempt_restore_of_faulty_devices() instead
of calling sync_page_io() directly.

Explicitly set device to faulty on superblock read error.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 87c1458..424c93c 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1936,18 +1936,21 @@ static int rs_check_reshape(struct raid_set *rs)
 	return -EPERM;
 }
 
-static int read_disk_sb(struct md_rdev *rdev, int size)
+static int read_disk_sb(struct md_rdev *rdev, int size, bool force_reload)
 {
 	BUG_ON(!rdev->sb_page);
 
-	if (rdev->sb_loaded)
+	if (rdev->sb_loaded && !force_reload)
 		return 0;
 
+	rdev->sb_loaded = 0;
+
 	if (!sync_page_io(rdev, 0, size, rdev->sb_page, REQ_OP_READ, 0, true)) {
 		DMERR("Failed to read superblock of device at position %d",
 		      rdev->raid_disk);
 		md_error(rdev->mddev, rdev);
-		return -EINVAL;
+		set_bit(Faulty, &rdev->flags);
+		return -EIO;
 	}
 
 	rdev->sb_loaded = 1;
@@ -2075,7 +2078,7 @@ static int super_load(struct md_rdev *rdev, struct md_rdev *refdev)
 		return -EINVAL;
 	}
 
-	r = read_disk_sb(rdev, rdev->sb_size);
+	r = read_disk_sb(rdev, rdev->sb_size, false);
 	if (r)
 		return r;
 
@@ -2453,7 +2456,6 @@ static int analyse_superblocks(struct dm_target *ti, struct raid_set *rs)
 			 * The rdev has to stay on the same_set list to allow for
 			 * the attempt to restore faulty devices on second resume.
 			 */
-			set_bit(Faulty, &rdev->flags);
 			rdev->raid_disk = rdev->saved_raid_disk = -1;
 			break;
 		}
@@ -3545,9 +3547,8 @@ static void attempt_restore_of_faulty_devices(struct raid_set *rs)
 		if (test_bit(Journal, &r->flags))
 			continue;
 
-		if (test_bit(Faulty, &r->flags) && r->sb_page &&
-		    sync_page_io(r, 0, r->sb_size, r->sb_page,
-				 REQ_OP_READ, 0, true)) {
+		if (test_bit(Faulty, &r->flags) &&
+		    r->meta_bdev && !read_disk_sb(r, r->sb_size, true)) {
 			DMINFO("Faulty %s device #%d has readable super block."
 			       "  Attempting to revive it.",
 			       rs->raid_type->name, i);
-- 
2.9.3

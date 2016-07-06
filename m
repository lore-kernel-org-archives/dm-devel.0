From: heinzm@redhat.com
Subject: [PATCH 03/26] dm raid: the sync_page_io() metadata_op
	argument is bool
Date: Wed,  6 Jul 2016 19:24:34 +0200
Message-ID: <1467825897-26058-4-git-send-email-heinzm@redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index e8e9b6a..0eceee8 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1784,7 +1784,7 @@ static int read_disk_sb(struct md_rdev *rdev, int size)
 	if (rdev->sb_loaded)
 		return 0;
 
-	if (!sync_page_io(rdev, 0, size, rdev->sb_page, REQ_OP_READ, 0, 1)) {
+	if (!sync_page_io(rdev, 0, size, rdev->sb_page, REQ_OP_READ, 0, true)) {
 		DMERR("Failed to read superblock of device at position %d",
 		      rdev->raid_disk);
 		md_error(rdev->mddev, rdev);
@@ -3258,8 +3258,8 @@ static void attempt_restore_of_faulty_devices(struct raid_set *rs)
 	for (i = 0; i < rs->md.raid_disks; i++) {
 		r = &rs->dev[i].rdev;
 		if (test_bit(Faulty, &r->flags) && r->sb_page &&
-		    sync_page_io(r, 0, r->sb_size, r->sb_page, REQ_OP_READ, 0,
-				 1)) {
+		    sync_page_io(r, 0, r->sb_size, r->sb_page,
+				 REQ_OP_READ, 0, true)) {
 			DMINFO("Faulty %s device #%d has readable super block."
 			       "  Attempting to revive it.",
 			       rs->raid_type->name, i);
-- 
2.5.5

From: heinzm@redhat.com
Subject: [PATCH 09/26] dm raid: make rs_set_capacity to work on
	shrinking reshape
Date: Wed,  6 Jul 2016 19:24:40 +0200
Message-ID: <1467825897-26058-10-git-send-email-heinzm@redhat.com>
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
 drivers/md/dm-raid.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index cc6eb7c..62e31b4 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -617,9 +617,7 @@ static void rs_set_capacity(struct raid_set *rs)
 {
 	struct mddev *mddev = &rs->md;
 
-	/* Make sure we access most actual mddev properties */
-	smp_rmb();
-	if (rs->ti->len != mddev->array_sectors && !rs_is_reshaping(rs)) {
+	if (rs->ti->len != mddev->array_sectors) {
 		struct gendisk *gendisk = dm_disk(dm_table_get_md(rs->ti->table));
 
 		set_capacity(gendisk, mddev->array_sectors);
@@ -1471,7 +1469,9 @@ static void do_table_event(struct work_struct *ws)
 {
 	struct raid_set *rs = container_of(ws, struct raid_set, md.event_work);
 
-	rs_set_capacity(rs);
+	smp_rmb(); /* Make sure we access most actual mddev properties */
+	if (!rs_is_reshaping(rs))
+		rs_set_capacity(rs);
 	dm_table_event(rs->ti->table);
 }
 
-- 
2.5.5

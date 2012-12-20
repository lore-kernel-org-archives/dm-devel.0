From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 2/4] dm: add WRITE SAME support
Date: Thu, 20 Dec 2012 00:57:11 -0500
Message-ID: <1355983033-17863-2-git-send-email-snitzer@redhat.com>
References: <20121220054725.GA17619@redhat.com>
	<1355983033-17863-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1355983033-17863-1-git-send-email-snitzer@redhat.com>
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
Cc: martin.petersen@oracle.com
List-Id: dm-devel.ids

WRITE SAME bios have a payload that contain a single page.  When
cloning WRITE SAME bios DM has no need to modify the bi_io_vec
attributes (doing so would be detrimental).  DM need only alter the
start and end of the WRITE SAME bio accordingly.

Rather than duplicate __clone_and_map_discard, factor out a common
function that is also used by __clone_and_map_write_same.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c |   44 +++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 739fd2b..cee9926 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1218,7 +1218,28 @@ static void __clone_and_map_simple(struct clone_info *ci, struct dm_target *ti)
 	ci->sector_count = 0;
 }
 
-static int __clone_and_map_discard(struct clone_info *ci)
+typedef unsigned (*get_num_requests_fn)(struct dm_target *ti);
+
+static unsigned get_num_discard_requests(struct dm_target *ti)
+{
+	return ti->num_discard_requests;
+}
+
+static unsigned get_num_write_same_requests(struct dm_target *ti)
+{
+	return ti->num_write_same_requests;
+}
+
+typedef bool (*is_split_required_fn)(struct dm_target *ti);
+
+static bool is_split_required_for_discard(struct dm_target *ti)
+{
+	return ti->split_discard_requests;
+}
+
+static int __clone_and_map_changing_extent_only(struct clone_info *ci,
+						get_num_requests_fn get_num_requests,
+						is_split_required_fn is_split_required)
 {
 	struct dm_target *ti;
 	sector_t len;
@@ -1229,15 +1250,15 @@ static int __clone_and_map_discard(struct clone_info *ci)
 			return -EIO;
 
 		/*
-		 * Even though the device advertised discard support,
-		 * that does not mean every target supports it, and
+		 * Even though the device advertised support for this type of
+		 * request, that does not mean every target supports it, and
 		 * reconfiguration might also have changed that since the
 		 * check was performed.
 		 */
-		if (!ti->num_discard_requests)
+		if (!get_num_requests || !get_num_requests(ti))
 			return -EOPNOTSUPP;
 
-		if (!ti->split_discard_requests)
+		if (is_split_required && !is_split_required(ti))
 			len = min(ci->sector_count, max_io_len_target_boundary(ci->sector, ti));
 		else
 			len = min(ci->sector_count, max_io_len(ci->sector, ti));
@@ -1250,6 +1271,17 @@ static int __clone_and_map_discard(struct clone_info *ci)
 	return 0;
 }
 
+static int __clone_and_map_discard(struct clone_info *ci)
+{
+	return __clone_and_map_changing_extent_only(ci, get_num_discard_requests,
+						    is_split_required_for_discard);
+}
+
+static int __clone_and_map_write_same(struct clone_info *ci)
+{
+	return __clone_and_map_changing_extent_only(ci, get_num_write_same_requests, NULL);
+}
+
 static int __clone_and_map(struct clone_info *ci)
 {
 	struct bio *bio = ci->bio;
@@ -1258,6 +1290,8 @@ static int __clone_and_map(struct clone_info *ci)
 
 	if (unlikely(bio->bi_rw & REQ_DISCARD))
 		return __clone_and_map_discard(ci);
+	else if (unlikely(bio->bi_rw & REQ_WRITE_SAME))
+		return __clone_and_map_write_same(ci);
 
 	ti = dm_table_find_target(ci->map, ci->sector);
 	if (!dm_target_is_valid(ti))
-- 
1.7.1

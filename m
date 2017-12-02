From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH V2 03/12] dm raid: correct resizing state in ctr
Date: Sat,  2 Dec 2017 01:03:50 +0100
Message-ID: <1b14555791be3e01ead8b0baa21b5a862f04c382.1512171097.git.heinzm@redhat.com>
References: <cover.1512171097.git.heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cover.1512171097.git.heinzm@redhat.com>
In-Reply-To: <cover.1512171097.git.heinzm@redhat.com>
References: <cover.1512171097.git.heinzm@redhat.com>
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
Cc: snitzer@redhat.com
List-Id: dm-devel.ids

Pay attention to existing reshape space to define
if a raid set needs resizing or we can hit
"Can't resize a reshaping raid set"
when a reshape is being requested.
---
 drivers/md/dm-raid.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 5f099d1f7ccc..ec28a6cf1bf8 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2969,10 +2969,10 @@ static void configure_discard_support(struct raid_set *rs)
 static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
 	int r;
-	bool resize;
+	bool resize = false;
 	struct raid_type *rt;
 	unsigned int num_raid_params, num_raid_devs;
-	sector_t calculated_dev_sectors, rdev_sectors;
+	sector_t calculated_dev_sectors, rdev_sectors, reshape_sectors;
 	struct raid_set *rs = NULL;
 	const char *arg;
 	struct rs_layout rs_layout;
@@ -3055,7 +3055,10 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad;
 	}
 
-	resize = calculated_dev_sectors != rdev_sectors;
+
+	reshape_sectors = _get_reshape_sectors(rs);
+	if (calculated_dev_sectors != rdev_sectors)
+		resize = calculated_dev_sectors != (reshape_sectors ? rdev_sectors - reshape_sectors : rdev_sectors);
 
 	INIT_WORK(&rs->md.event_work, do_table_event);
 	ti->private = rs;
@@ -3178,7 +3181,6 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	mddev_lock_nointr(&rs->md);
 	r = md_run(&rs->md);
 	rs->md.in_sync = 0; /* Assume already marked dirty */
-
 	if (r) {
 		ti->error = "Failed to run raid array";
 		mddev_unlock(&rs->md);
-- 
2.13.6

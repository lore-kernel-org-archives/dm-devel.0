From: heinzm@redhat.com
Subject: [PATCH] dm-raid: unsynced raid snapshot
	creation/deletion causes panic (work queue teardown race)
Date: Wed, 29 Apr 2015 14:33:09 +0200
Message-ID: <1430310789-564-1-git-send-email-heinzm@redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

This patch avoids oopses caused by a callback racing
with the destrution of a mapping.


Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Tested-by: Heinz Mauelshagen <heinzm@redhat.com>


---
 drivers/md/dm-raid.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 88e4c7f..fc4bc83 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1614,6 +1614,17 @@ static void raid_presuspend(struct dm_target *ti)
 {
 	struct raid_set *rs = ti->private;
 
+	/*
+	 * Address a teardown race when calling
+	 * raid_(pre|post)suspend followed by raid_dtr:
+	 *
+	 * MD's call chain md_stop_writes()->md_reap_sync_thread()
+	 * causes work to be queued on the md_misc_wq queue
+	 * not flushing it, hence the callback can occur after
+	 * a potential destruction of the raid set causing an oops.
+	 */
+	rs->md.event_work.func = NULL;
+
 	md_stop_writes(&rs->md);
 }
 
@@ -1684,6 +1695,13 @@ static void raid_resume(struct dm_target *ti)
 {
 	struct raid_set *rs = ti->private;
 
+	/*
+	 * See "Address a teardown race" in raid_presuspend()
+	 *
+	 * Reenable the worker function.
+	 */
+	rs->md.event_work.func = do_table_event;
+
 	set_bit(MD_CHANGE_DEVS, &rs->md.flags);
 	if (!rs->bitmap_loaded) {
 		bitmap_load(&rs->md);
-- 
2.1.0

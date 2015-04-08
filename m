From: heinzm@redhat.com
Subject: [PATCH 2/2] dm-raid1: [PATCH RFC] dm-raid1: keep writing
	after leg failure -> fix error end io logic if 'keep_log' set
	for on log failure; add ctr/... comments
Date: Wed,  8 Apr 2015 14:27:34 +0200
Message-ID: <1428496054-5837-3-git-send-email-heinzm@redhat.com>
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


The error endio log path seems wrong, because
the patch fails the io in case "keep_log" is set and
the log is _not_ errored.

It should be failed (as the comment explains), when
"keep_log" is set and the log has failed.


Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>

---
 drivers/md/dm-raid1.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index ef5f20c..cbf3527 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -813,9 +813,11 @@ static void do_failures(struct mirror_set *ms, struct bio_list *failures)
 		 */
 
 		/*
-		 * we return EIO when the log device is failed if keep_log is set
+		 * We return EIO when there's no valid mirror legs
+		 * -or-
+		 * the log device is failed if keep_log is set
 		 */
-		if (!get_valid_mirror(ms) || (keep_log(ms) && !ms->log_failure))
+		if (unlikely(!get_valid_mirror(ms) || (keep_log(ms) && ms->log_failure)))
 			bio_endio(bio, -EIO);
 		/*
 		 * After the userspace get noticed that the leg has failed,
@@ -1048,7 +1050,7 @@ static int parse_features(struct mirror_set *ms, unsigned argc, char **argv,
  * log_type is "core" or "disk"
  * #log_params is between 1 and 3
  *
- * If present, features must be "handle_errors".
+ * If present, features must be "handle_errors" and/or "keep_log".
  */
 static int mirror_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
@@ -1417,7 +1419,6 @@ static void mirror_status(struct dm_target *ti, status_type_t type,
 			DMEMIT(" 2 handle_errors keep_log");
 		else if (errors_handled(ms))
 			DMEMIT(" 1 handle_errors");
-
 	}
 }
 
-- 
2.1.0

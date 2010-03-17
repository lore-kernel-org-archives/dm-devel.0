From: Nikanth Karthikesan <knikanth@suse.de>
Subject: [PATCH] multipath: display average priority as group
	priority
Date: Wed, 17 Mar 2010 12:44:25 +0530
Message-ID: <201003171244.25957.knikanth@suse.de>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Display avg priority as group priority

Now average priority is used as path group priority, instead of sum of
priorities of the paths. But while displaying group priority, sum is
being displayed. Change it to print the average priority.

When there are no enabled paths, print 0 as priority.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 10e5ce5..9753fe2 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -378,6 +378,7 @@ snprint_pg_selector (char * buff, size_t len, struct pathgroup * pgp)
 static int
 snprint_pg_pri (char * buff, size_t len, struct pathgroup * pgp)
 {
+	int avg_priority = 0;
 	/*
 	 * path group priority is not updated for every path prio change,
 	 * but only on switch group code path.
@@ -385,7 +386,9 @@ snprint_pg_pri (char * buff, size_t len, struct pathgroup * pgp)
 	 * Printing is another reason to update.
 	 */
 	path_group_prio_update(pgp);
-	return snprint_int(buff, len, pgp->priority);
+	if (pgp->enabled_paths)
+		avg_priority = pgp->priority / pgp->enabled_paths;
+	return snprint_int(buff, len, avg_priority);
 }
 
 static int

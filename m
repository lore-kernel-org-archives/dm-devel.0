From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 2/2 v2] dm mpath: allow table load with 0
	priority groups
Date: Thu, 10 Feb 2011 16:06:10 -0500
Message-ID: <1297371970-13313-1-git-send-email-snitzer@redhat.com>
References: <1296490458-12910-2-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1296490458-12910-2-git-send-email-snitzer@redhat.com>
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
List-Id: dm-devel.ids

If an mpath device is held open when all paths in the last priority
group have failed userspace multipathd will attempt to reload the
associated DM table to reflect that the device no longer has any
priority groups.  But the reload attempt always failed because the
multipath target did not allow 0 priority groups.

Adjust multipath target to allow a table with both 0 priority groups
and 0 for the initial priority group number.

All multipath target messages related to priority group (enable_group,
disable_group, switch_group) will properly handle a priority group of
0 (will cause error).

When reloading a multipath table with 0 priority groups, userspace
multipathd must be updated to specify an initial priority group number
of 0 (rather than 1).

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Babu Moger <babu.moger@lsi.com>
---
 drivers/md/dm-mpath.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

v2: bumped multipath target version to 1.3.0, added babu's acked-by

Index: linux-2.6/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-mpath.c
+++ linux-2.6/drivers/md/dm-mpath.c
@@ -844,8 +844,8 @@ static int multipath_ctr(struct dm_targe
 {
 	/* target parameters */
 	static struct param _params[] = {
-		{1, 1024, "invalid number of priority groups"},
-		{1, 1024, "invalid initial priority group number"},
+		{0, 1024, "invalid number of priority groups"},
+		{0, 1024, "invalid initial priority group number"},
 	};
 
 	int r;
@@ -879,6 +879,13 @@ static int multipath_ctr(struct dm_targe
 	if (r)
 		goto bad;
 
+	if ((!m->nr_priority_groups && next_pg_num) ||
+	    (m->nr_priority_groups && !next_pg_num)) {
+		ti->error = "invalid initial priority group";
+		r = -EINVAL;
+		goto bad;
+	}
+
 	/* parse the priority groups */
 	while (as.argc) {
 		struct priority_group *pg;
@@ -1417,7 +1424,7 @@ static int multipath_status(struct dm_ta
 	else if (m->current_pg)
 		pg_num = m->current_pg->pg_num;
 	else
-			pg_num = 1;
+		pg_num = (m->nr_priority_groups ? 1 : 0);
 
 	DMEMIT("%u ", pg_num);
 
@@ -1671,7 +1678,7 @@ out:
  *---------------------------------------------------------------*/
 static struct target_type multipath_target = {
 	.name = "multipath",
-	.version = {1, 2, 0},
+	.version = {1, 3, 0},
 	.module = THIS_MODULE,
 	.ctr = multipath_ctr,
 	.dtr = multipath_dtr,

From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5/7] Move a logic to get a valid mirror leg to a
	function
Date: Wed, 18 Nov 2009 07:13:10 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0911180712340.21358@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0911180703410.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180709570.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180710370.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180711140.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180711510.21358@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0911180711510.21358@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Move a logic to get a valid mirror leg to a function.
It will be reused later.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-raid1.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

Index: linux-2.6.31-rc3-devel/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.31-rc3-devel.orig/drivers/md/dm-raid1.c	2009-07-20 20:46:49.000000000 +0200
+++ linux-2.6.31-rc3-devel/drivers/md/dm-raid1.c	2009-07-20 20:47:44.000000000 +0200
@@ -180,6 +180,15 @@ static void set_default_mirror(struct mi
 	atomic_set(&ms->default_mirror, m - m0);
 }
 
+static struct mirror *get_valid_mirror(struct mirror_set *ms)
+{
+	struct mirror *m;
+	for (m = ms->mirror; m < ms->mirror + ms->nr_mirrors; m++)
+		if (!atomic_read(&m->error_count))
+			return m;
+	return NULL;
+}
+
 /* fail_mirror
  * @m: mirror device to fail
  * @error_type: one of the enum's, DM_RAID1_*_ERROR
@@ -225,13 +234,10 @@ static void fail_mirror(struct mirror *m
 		goto out;
 	}
 
-	for (new = ms->mirror; new < ms->mirror + ms->nr_mirrors; new++)
-		if (!atomic_read(&new->error_count)) {
-			set_default_mirror(new);
-			break;
-		}
-
-	if (unlikely(new == ms->mirror + ms->nr_mirrors))
+	new = get_valid_mirror(ms);
+	if (new)
+		set_default_mirror(new);
+	else
 		DMWARN("All sides of mirror have failed.");
 
 out:

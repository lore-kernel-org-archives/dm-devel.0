From: Mike Christie <mchristi@redhat.com>
Subject: [PATCH 2/2] multipathd: Don't call repair on blacklisted
	paths
Date: Mon, 15 Aug 2016 12:13:46 -0500
Message-ID: <1471281226-7719-2-git-send-email-mchristi@redhat.com>
References: <1471281226-7719-1-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1471281226-7719-1-git-send-email-mchristi@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, christophe.varoqui@opensvc.com, bart.vanassche@sandisk.com
Cc: Mike Christie <mchristi@redhat.com>
List-Id: dm-devel.ids

This fixes a regression added in
015f87b16a7797a17afd514aec46e65c2a1a2f73

If a path is blacklisted the checkerloop will free the path so
don't call repair on it.

This moves the repair call down into check_path, because I think
we also do not need to call it for other cases where we cannot get
the uuid info or being orphaned.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 multipathd/main.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index f5e9a01..c4ffe6f 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1442,6 +1442,16 @@ int update_path_groups(struct multipath *mpp, struct vectors *vecs, int refresh)
 	return 0;
 }
 
+void repair_path(struct path * pp)
+{
+	if (pp->state != PATH_DOWN)
+		return;
+
+	checker_repair(&pp->checker);
+	if (strlen(checker_message(&pp->checker)))
+		LOG_MSG(1, checker_message(&pp->checker));
+}
+
 /*
  * Returns '1' if the path has been checked, '-1' if it was blacklisted
  * and '0' otherwise
@@ -1606,6 +1616,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 			pp->mpp->failback_tick = 0;
 
 			pp->mpp->stat_path_failures++;
+			repair_path(pp);
 			return 1;
 		}
 
@@ -1700,7 +1711,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 	}
 
 	pp->state = newstate;
-
+	repair_path(pp);
 
 	if (pp->mpp->wait_for_udev)
 		return 1;
@@ -1725,14 +1736,6 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 	return 1;
 }
 
-void repair_path(struct vectors * vecs, struct path * pp)
-{
-	if (pp->state != PATH_DOWN)
-		return;
-
-	checker_repair(&pp->checker);
-}
-
 static void *
 checkerloop (void *ap)
 {
@@ -1804,7 +1807,6 @@ checkerloop (void *ap)
 					i--;
 				} else
 					num_paths += rc;
-				repair_path(vecs, pp);
 			}
 			lock_cleanup_pop(vecs->lock);
 		}
-- 
2.7.2

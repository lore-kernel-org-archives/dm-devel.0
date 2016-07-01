From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH] multipathd: restore paths after reconfigure
Date: Fri,  1 Jul 2016 16:46:09 -0500
Message-ID: <1467409569-16088-1-git-send-email-bmarzins@redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

multipathd has code to finish gathering the information of paths that
were not active at the time they were discovered. When the checker loop
goes to check a path, and notices that it wasn't fully initialized, it
is supposed to complete the initialization.  However the code is broken.
This means that if you reconfigure multipathd while paths are down, they
will no longer be usable. This patch makes sure that check_path will
actually rerun pathinfo to finish setting up the path, so that after the
path comes back up, it will be usable again.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c |  5 +++--
 multipathd/main.c        | 20 ++++++++++++++++----
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index d5215f9..eb2e926 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1713,8 +1713,9 @@ pathinfo (struct path *pp, struct config *conf, int mask)
 			get_prio(pp);
 		}
 	}
-
-	pp->initialized = INIT_OK;
+	
+	if ((mask & DI_ALL) == DI_ALL)
+		pp->initialized = INIT_OK;
 	return PATHINFO_OK;
 
 blank:
diff --git a/multipathd/main.c b/multipathd/main.c
index 9682b3e..6e3ae69 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1439,7 +1439,8 @@ int update_path_groups(struct multipath *mpp, struct vectors *vecs, int refresh)
 }
 
 /*
- * Returns '1' if the path has been checked, '0' otherwise
+ * Returns '1' if the path has been checked, '-1' if it was blacklisted
+ * and '0' otherwise
  */
 int
 check_path (struct vectors * vecs, struct path * pp, int ticks)
@@ -1452,6 +1453,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 	int oldchkrstate = pp->chkrstate;
 	int retrigger_tries, checkint;
 	struct config *conf;
+	int ret;
 
 	if ((pp->initialized == INIT_OK ||
 	     pp->initialized == INIT_REQUESTED_UDEV) && !pp->mpp)
@@ -1511,10 +1513,14 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 		    (newstate == PATH_UP || newstate == PATH_GHOST)) {
 			condlog(2, "%s: add missing path", pp->dev);
 			conf = get_multipath_config();
-			if (pathinfo(pp, conf, DI_ALL) == 0) {
+			ret = pathinfo(pp, conf, DI_ALL | DI_BLACKLIST);
+			if (ret == PATHINFO_OK) {
 				ev_add_path(pp, vecs);
 				pp->tick = 1;
-			}
+			} else if (ret == PATHINFO_SKIPPED) {
+				put_multipath_config(conf);
+				return -1;
+			} 
 			put_multipath_config(conf);
 		}
 		return 0;
@@ -1779,7 +1785,13 @@ checkerloop (void *ap)
 			lock(vecs->lock);
 			pthread_testcancel();
 			vector_foreach_slot (vecs->pathvec, pp, i) {
-				num_paths += check_path(vecs, pp, ticks);
+				rc = check_path(vecs, pp, ticks);
+				if (rc < 0) {
+					vector_del_slot(vecs->pathvec, i);
+					free_path(pp);
+					i--;
+				} else;
+					num_paths += rc;
 			}
 			lock_cleanup_pop(vecs->lock);
 		}
-- 
1.8.3.1

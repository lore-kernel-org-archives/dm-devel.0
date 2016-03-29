From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 14/17] multipathd: print "fail" when remove fails
Date: Mon, 28 Mar 2016 22:13:11 -0500
Message-ID: <1459221194-23222-15-git-send-email-bmarzins@redhat.com>
References: <1459221194-23222-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1459221194-23222-1-git-send-email-bmarzins@redhat.com>
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

When multipathd fails to remove a path or a map, it was printing "ok"
instead of "fail", and exitting with a 0 return code.  Now it prints
"fail" and exits with a 1, like it does when other commands fail.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/cli_handlers.c | 8 ++++----
 multipathd/main.c         | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 21fe00e..168b872 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -511,7 +511,7 @@ cli_del_path (void * v, char ** reply, int * len, void * data)
 	pp = find_path_by_dev(vecs->pathvec, param);
 	if (!pp) {
 		condlog(0, "%s: path already removed", param);
-		return 0;
+		return 1;
 	}
 	return ev_remove_path(pp, vecs);
 }
@@ -585,19 +585,19 @@ cli_del_map (void * v, char ** reply, int * len, void * data)
 	minor = dm_get_minor(param);
 	if (minor < 0) {
 		condlog(2, "%s: not a device mapper table", param);
-		return 0;
+		return 1;
 	}
 	major = dm_get_major(param);
 	if (major < 0) {
 		condlog(2, "%s: not a device mapper table", param);
-		return 0;
+		return 1;
 	}
 	sprintf(dev_path,"dm-%d", minor);
 	alias = dm_mapname(major, minor);
 	if (!alias) {
 		condlog(2, "%s: mapname not found for %d:%d",
 			param, major, minor);
-		return 0;
+		return 1;
 	}
 	rc = ev_remove_map(param, alias, minor, vecs);
 	FREE(alias);
diff --git a/multipathd/main.c b/multipathd/main.c
index ea14e03..0128326 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -448,12 +448,12 @@ ev_remove_map (char * devname, char * alias, int minor, struct vectors * vecs)
 	if (!mpp) {
 		condlog(2, "%s: devmap not registered, can't remove",
 			devname);
-		return 0;
+		return 1;
 	}
 	if (strcmp(mpp->alias, alias)) {
 		condlog(2, "%s: minor number mismatch (map %d, event %d)",
 			mpp->alias, mpp->dmi->minor, minor);
-		return 0;
+		return 1;
 	}
 	return flush_map(mpp, vecs, 0);
 }
-- 
1.8.3.1

From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v3 09/17] multipathd: use update_path_groups
	instead of reload_map
Date: Sat, 30 Mar 2019 01:05:58 -0500
Message-ID: <1553925966-20958-10-git-send-email-bmarzins@redhat.com>
References: <1553925966-20958-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1553925966-20958-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

reload_map() doesn't do the work to sync the state after reloading the
map.  Instead of calling it directly, cli_reload() and uev_update_path()
should call update_path_groups(), which calls reload_map() with all the
necessary syncing.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/cli_handlers.c |  2 +-
 multipathd/main.c         | 13 ++++++++-----
 multipathd/main.h         |  2 ++
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index f95813e..60e17d6 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -877,7 +877,7 @@ cli_reload(void *v, char **reply, int *len, void *data)
 		return 1;
 	}
 
-	return reload_map(vecs, mpp, 0, 1);
+	return update_path_groups(mpp, vecs, 0);
 }
 
 int resize_map(struct multipath *mpp, unsigned long long size,
diff --git a/multipathd/main.c b/multipathd/main.c
index fd83a6a..7a317d9 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1273,10 +1273,13 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 			else {
 				if (ro == 1)
 					pp->mpp->force_readonly = 1;
-				retval = reload_map(vecs, mpp, 0, 1);
-				pp->mpp->force_readonly = 0;
-				condlog(2, "%s: map %s reloaded (retval %d)",
-					uev->kernel, mpp->alias, retval);
+				retval = update_path_groups(mpp, vecs, 0);
+				if (retval == 2)
+					condlog(2, "%s: map removed during reload", pp->dev);
+				else {
+					pp->mpp->force_readonly = 0;
+					condlog(2, "%s: map %s reloaded (retval %d)", uev->kernel, mpp->alias, retval);
+				}
 			}
 		}
 	}
@@ -1832,7 +1835,7 @@ int update_path_groups(struct multipath *mpp, struct vectors *vecs, int refresh)
 
 	dm_lib_release();
 	if (setup_multipath(vecs, mpp) != 0)
-		return 1;
+		return 2;
 	sync_map_state(mpp);
 
 	return 0;
diff --git a/multipathd/main.h b/multipathd/main.h
index 8fd426b..e5c1398 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -43,5 +43,7 @@ int __setup_multipath (struct vectors * vecs, struct multipath * mpp,
 		       int reset);
 #define setup_multipath(vecs, mpp) __setup_multipath(vecs, mpp, 1)
 int update_multipath (struct vectors *vecs, char *mapname, int reset);
+int update_path_groups(struct multipath *mpp, struct vectors *vecs,
+		       int refresh);
 
 #endif /* MAIN_H */
-- 
2.17.2

From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v2 3/7] multipathd: remove coalesce_paths from
	ev_add_map
Date: Thu,  8 Feb 2018 17:56:03 -0600
Message-ID: <1518134167-15938-4-git-send-email-bmarzins@redhat.com>
References: <1518134167-15938-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1518134167-15938-1-git-send-email-bmarzins@redhat.com>
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
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

If ev_add_map is called for a multipath device that doesn't exist in
device-mapper, it will call coalesce_paths to add it.  This doesn't work
and hasn't for years. It doesn't add the map to the mpvec, or start up
waiters, or do any of the necessary things that do get done when you
call ev_add_map for a map that does exist in device mapper.

Fortunately, there are only two things that call ev_add_map. uev_add_map
makes sure that the device does exist in device-mapper before calling
ev_add_map, and cli_add_map creates the device first and then calls
ev_add_map, if the device doesn't exist.

So, there is no reason for coalesce_paths to be in ev_add_map. This
removes it.

Cc: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 46 ++++++++++++++--------------------------------
 1 file changed, 14 insertions(+), 32 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 27cf234..dbf9890 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -412,18 +412,19 @@ uev_add_map (struct uevent * uev, struct vectors * vecs)
 	return rc;
 }
 
+/*
+ * ev_add_map expects that the multipath device already exists in kernel
+ * before it is called. It just adds a device to multipathd or updates an
+ * existing device.
+ */
 int
 ev_add_map (char * dev, char * alias, struct vectors * vecs)
 {
-	char * refwwid;
 	struct multipath * mpp;
-	int map_present;
-	int r = 1, delayed_reconfig, reassign_maps;
+	int delayed_reconfig, reassign_maps;
 	struct config *conf;
 
-	map_present = dm_map_present(alias);
-
-	if (map_present && !dm_is_mpath(alias)) {
+	if (!dm_is_mpath(alias)) {
 		condlog(4, "%s: not a multipath map", alias);
 		return 0;
 	}
@@ -468,33 +469,14 @@ ev_add_map (char * dev, char * alias, struct vectors * vecs)
 	/*
 	 * now we can register the map
 	 */
-	if (map_present) {
-		if ((mpp = add_map_without_path(vecs, alias))) {
-			sync_map_state(mpp);
-			condlog(2, "%s: devmap %s registered", alias, dev);
-			return 0;
-		} else {
-			condlog(2, "%s: uev_add_map failed", dev);
-			return 1;
-		}
-	}
-	r = get_refwwid(CMD_NONE, dev, DEV_DEVMAP, vecs->pathvec, &refwwid);
-
-	if (refwwid) {
-		r = coalesce_paths(vecs, NULL, refwwid, FORCE_RELOAD_NONE,
-				   CMD_NONE);
-		dm_lib_release();
+	if ((mpp = add_map_without_path(vecs, alias))) {
+		sync_map_state(mpp);
+		condlog(2, "%s: devmap %s registered", alias, dev);
+		return 0;
+	} else {
+		condlog(2, "%s: ev_add_map failed", dev);
+		return 1;
 	}
-
-	if (!r)
-		condlog(2, "%s: devmap %s added", alias, dev);
-	else if (r == 2)
-		condlog(2, "%s: uev_add_map %s blacklisted", alias, dev);
-	else
-		condlog(0, "%s: uev_add_map %s failed", alias, dev);
-
-	FREE(refwwid);
-	return r;
 }
 
 static int
-- 
2.7.4

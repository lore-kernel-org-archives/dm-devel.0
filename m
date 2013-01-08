From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 20/42] Switch off 'queue_if_no_path' before
	removing maps
Date: Tue,  8 Jan 2013 14:53:58 +0100
Message-ID: <1357653259-62650-21-git-send-email-hare@suse.de>
References: <1357653259-62650-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357653259-62650-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Before we try to flush a map we have to switch off the
'queue_if_no_path' setting to flush any outstanding I/O.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/devmapper.c |   26 +++++++++++++++++++++++++-
 libmultipath/devmapper.h |    1 +
 multipath/main.c         |    6 +++---
 3 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 051ecb2..a6e7150 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -707,6 +707,30 @@ _dm_flush_map (const char * mapname, int need_sync)
 }
 
 extern int
+dm_suspend_and_flush_map (const char * mapname)
+{
+	int s;
+
+	if (!dm_map_present(mapname))
+		return 0;
+
+	if (dm_type(mapname, TGT_MPATH) <= 0)
+		return 0; /* nothing to do */
+
+	s = dm_queue_if_no_path((char *)mapname, 0);
+	if (!s)
+		s = dm_simplecmd_flush(DM_DEVICE_SUSPEND, mapname, 0);
+
+	if (!dm_flush_map(mapname)) {
+		condlog(4, "multipath map %s removed", mapname);
+		return 0;
+	}
+	condlog(2, "failed to remove multipath map %s", mapname);
+	dm_simplecmd_noflush(DM_DEVICE_RESUME, mapname);
+	return 1;
+}
+
+extern int
 dm_flush_maps (void)
 {
 	int r = 0;
@@ -729,7 +753,7 @@ dm_flush_maps (void)
 		goto out;
 
 	do {
-		r |= dm_flush_map(names->name);
+		r |= dm_suspend_and_flush_map(names->name);
 		next = names->next;
 		names = (void *) names + next;
 	} while (next);
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 0c2e03f..b08aa31 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -22,6 +22,7 @@ int dm_type(const char *, char *);
 int _dm_flush_map (const char *, int);
 #define dm_flush_map(mapname) _dm_flush_map(mapname, 1)
 #define dm_flush_map_nosync(mapname) _dm_flush_map(mapname, 0)
+int dm_suspend_and_flush_map(const char * mapname);
 int dm_flush_maps (void);
 int dm_fail_path(char * mapname, char * path);
 int dm_reinstate_path(char * mapname, char * path);
diff --git a/multipath/main.c b/multipath/main.c
index 6208995..396c4b9 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -555,9 +555,9 @@ main (int argc, char *argv[])
 		goto out;
 	}
 	if (conf->remove == FLUSH_ONE) {
-		if (conf->dev_type == DEV_DEVMAP)
-			r = dm_flush_map(conf->dev);
-		else
+		if (conf->dev_type == DEV_DEVMAP) {
+			r = dm_suspend_and_flush_map(conf->dev);
+		} else
 			condlog(0, "must provide a map name to remove");
 
 		goto out;
-- 
1.7.4.2

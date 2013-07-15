From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 29/29] multipath: reset queue_if_no_path if flush
	failed
Date: Mon, 15 Jul 2013 15:00:30 +0200
Message-ID: <1373893230-26077-30-git-send-email-hare@suse.de>
References: <1373893230-26077-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1373893230-26077-1-git-send-email-hare@suse.de>
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

When flushing a map failed the 'queue_if_no_path' setting is
getting lost.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/devmapper.c |   21 +++++++++++++++++----
 libmultipath/devmapper.h |    2 +-
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 69f475c..4c8b923 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -366,7 +366,7 @@ out:
 }
 
 extern int
-dm_get_map(char * name, unsigned long long * size, char * outparams)
+dm_get_map(const char * name, unsigned long long * size, char * outparams)
 {
 	int r = 1;
 	struct dm_task *dmt;
@@ -685,7 +685,9 @@ _dm_flush_map (const char * mapname, int need_sync)
 extern int
 dm_suspend_and_flush_map (const char * mapname)
 {
-	int s;
+	int s = 0, queue_if_no_path = 0;
+	unsigned long long mapsize;
+	char params[PARAMS_SIZE] = {0};
 
 	if (!dm_map_present(mapname))
 		return 0;
@@ -693,8 +695,17 @@ dm_suspend_and_flush_map (const char * mapname)
 	if (dm_type(mapname, TGT_MPATH) <= 0)
 		return 0; /* nothing to do */
 
-	s = dm_queue_if_no_path((char *)mapname, 0);
-	if (!s)
+	if (!dm_get_map(mapname, &mapsize, params)) {
+		if (strstr(params, "queue_if_no_path"))
+			queue_if_no_path = 1;
+	}
+
+	if (queue_if_no_path)
+		s = dm_queue_if_no_path((char *)mapname, 0);
+	/* Leave queue_if_no_path alone if unset failed */
+	if (s)
+		queue_if_no_path = 0;
+	else
 		s = dm_simplecmd_flush(DM_DEVICE_SUSPEND, mapname, 0);
 
 	if (!dm_flush_map(mapname)) {
@@ -703,6 +714,8 @@ dm_suspend_and_flush_map (const char * mapname)
 	}
 	condlog(2, "failed to remove multipath map %s", mapname);
 	dm_simplecmd_noflush(DM_DEVICE_RESUME, mapname);
+	if (queue_if_no_path)
+		s = dm_queue_if_no_path((char *)mapname, 1);
 	return 1;
 }
 
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 8ea9dd3..b27db56 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -16,7 +16,7 @@ int dm_addmap_create_ro (struct multipath *mpp, char *params);
 int dm_addmap_reload (struct multipath *mpp, char *params);
 int dm_addmap_reload_ro (struct multipath *mpp, char *params);
 int dm_map_present (const char *);
-int dm_get_map(char *, unsigned long long *, char *);
+int dm_get_map(const char *, unsigned long long *, char *);
 int dm_get_status(char *, char *);
 int dm_type(const char *, char *);
 int _dm_flush_map (const char *, int);
-- 
1.7.10.4

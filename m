From: egoggin@emc.com
Subject: patch for adding new multipath mapped devices
Date: Mon, 17 Jul 2006 15:29:20 -0400
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E41491AA@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: christophe.varoqui@free.fr
List-Id: dm-devel.ids

Chrisophe,

This patch tries to deal with the fact that neither a dm mapped device's
name nor any of its targets are necessarily available at the time
hotplug/udev announces the existence of the mapped device.  Since my attempt
to patch this in the kernel was rejected 8 or so months ago, this patch
tries to deal with these badly ordered events by simply inserting delays
when thought justified.  The scope of the existing delay in dm_mapname() is
changed to incorporate the retrieval of the mapped
device's name and a new function dm_map_target_present() is created which
will delay until at least one target exists for a named map.

Without both of these changes, it is hit-or-miss whether or not
multipathd(8) will correctly learn about a dm multipath mapped device newly
added by multipath(8).

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index c0765ae..081e25c 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -183,6 +183,41 @@ out:
 }
 
 extern int
+dm_map_target_present (char * str)
+{
+	int r = 0;
+	struct dm_task *dmt;
+	struct dm_info info;
+	int loop = MAX_WAIT * LOOPS_PER_SEC;
+
+	if (!(dmt = dm_task_create(DM_DEVICE_INFO)))
+		return 0;
+
+	if (!dm_task_set_name(dmt, str))
+		goto out;
+
+	dm_task_no_open_count(dmt);
+
+	while (--loop) {
+		dm_shut_log();
+		if (!dm_task_run(dmt))
+			goto out;
+		dm_restore_log();
+
+		if (!dm_task_get_info(dmt, &info))
+			goto out;
+
+		if (info.target_count) {
+			r = 1;
+			break;
+		}
+	}
+out:
+	dm_task_destroy(dmt);
+	return r;
+}
+
+extern int
 dm_get_map(char * name, unsigned long long * size, char * outparams)
 {
 	int r = 1;
@@ -725,21 +760,21 @@ dm_mapname(int major, int minor)
 		r = dm_task_run(dmt);
 		dm_restore_log();
 
-		if (r)
+		if (!r) {
+			condlog(0, "%i:%i: timeout fetching map name",
+				major, minor);
+			goto bad;
+		}
+
+		map = dm_task_get_name(dmt);
+		if (map && strlen(map))
+			response = STRDUP((char *)dm_task_get_name(dmt));
+		if (response)
 			break;
 
 		usleep(1000 * 1000 / LOOPS_PER_SEC);
 	}
 
-	if (!r) {
-		condlog(0, "%i:%i: timeout fetching map name", major,
minor);
-		goto bad;
-	}
-
-	map = dm_task_get_name(dmt);
-	if (map && strlen(map))
-		response = STRDUP((char *)dm_task_get_name(dmt));
-
 	dm_task_destroy(dmt);
 	return response;
 bad:
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index c7879a7..e11c037 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -5,6 +5,7 @@ int dm_simplecmd (int, const char *);
 int dm_addmap (int, const char *, const char *, const char *,
 	       unsigned long long, const char *uuid);
 int dm_map_present (char *);
+int dm_map_target_present (char *);
 int dm_get_map(char *, unsigned long long *, char *);
 int dm_get_status(char *, char *);
 int dm_type(char *, char *);
diff --git a/multipathd/main.c b/multipathd/main.c
index 91a1597..48a69b9 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -234,7 +234,7 @@ ev_add_map (char * devname, struct vecto
 	if (!alias)
 		return 1;
 	
-	map_present = dm_map_present(alias);
+	map_present = dm_map_target_present(alias);
 
 	if (map_present && dm_type(alias, DEFAULT_TARGET) <= 0) {
 		condlog(4, "%s: not a multipath map", alias);

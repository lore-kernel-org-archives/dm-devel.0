From: Patrick Caulfield <pcaulfie@redhat.com>
Subject: PATCH - multipath UUID
Date: Thu, 29 Sep 2005 17:03:47 +0100
Message-ID: <433C1063.3070202@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030506050703030703060202"
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
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------030506050703030703060202
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

If you use aliases to rename the multipath devices to something sensible you
lose the WWIDs, this patch stores them as the device-mapper UUID and retrieves
them so they can be displayed using multipath -l.
-- 

patrick

--------------030506050703030703060202
Content-Type: text/x-patch;
 name="multipath-uuid.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="multipath-uuid.patch"

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -102,7 +102,7 @@ dm_simplecmd (int task, const char *name
 
 extern int
 dm_addmap (int task, const char *name, const char *target,
-	   const char *params, unsigned long long size) {
+	   const char *params, unsigned long long size, const char *uuid) {
 	int r = 0;
 	struct dm_task *dmt;
 
@@ -115,6 +115,9 @@ dm_addmap (int task, const char *name, c
 	if (!dm_task_add_target (dmt, 0, size, target, params))
 		goto addout;
 
+	if (uuid && !dm_task_set_uuid(dmt, uuid))
+		goto addout;
+
 	dm_task_no_open_count(dmt);
 
 	r = dm_task_run (dmt);
@@ -188,6 +191,34 @@ out:
 }
 
 extern int
+dm_get_uuid(char *name, char *uuid)
+{
+	struct dm_task *dmt;
+	const char *uuidtmp;
+
+	dmt = dm_task_create(DM_DEVICE_INFO);
+	if (!dmt)
+		return 1;
+
+        if (!dm_task_set_name (dmt, name))
+                goto uuidout;
+
+	if (!dm_task_run(dmt))
+                goto uuidout;
+
+	uuidtmp = dm_task_get_uuid(dmt);
+	if (uuidtmp)
+		strcpy(uuid, uuidtmp);
+	else
+		uuid[0] = '\0';
+
+uuidout:
+	dm_task_destroy(dmt);
+
+	return 0;
+}
+
+extern int
 dm_get_status(char * name, char * outstatus)
 {
 	int r = 1;
@@ -556,6 +587,8 @@ dm_get_maps (vector mp, char * type)
 			if (dm_get_status(names->name, mpp->status))
 				goto out1;
 
+			dm_get_uuid(names->name, mpp->wwid);
+
 			mpp->alias = MALLOC(strlen(names->name) + 1);
 
 			if (!mpp->alias)
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -1,7 +1,7 @@
 int dm_prereq (char *, int, int, int);
 int dm_simplecmd (int, const char *);
 int dm_addmap (int, const char *, const char *, const char *,
-	       unsigned long long);
+	       unsigned long long, const char *uuid);
 int dm_map_present (char *);
 int dm_get_map(char *, unsigned long long *, char *);
 int dm_get_status(char *, char *);
diff --git a/multipath/main.c b/multipath/main.c
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -625,7 +625,7 @@ domap (struct multipath * mpp)
 	 */
 	dm_log_init_verbose(0);
 
-	r = dm_addmap(op, mpp->alias, DEFAULT_TARGET, mpp->params, mpp->size);
+	r = dm_addmap(op, mpp->alias, DEFAULT_TARGET, mpp->params, mpp->size, mpp->wwid);
 
 	if (r == 0)
 		dm_simplecmd(DM_DEVICE_REMOVE, mpp->alias);

--------------030506050703030703060202
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------030506050703030703060202--

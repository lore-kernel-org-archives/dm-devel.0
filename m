From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [multipath-tools] [patch] make multipath and kpartx
	prefix the uuid
Date: Thu, 1 Jun 2006 18:55:11 -0500
Message-ID: <20060601235511.GC25695@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="uZ3hkaAS1mZxFaxD"
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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


--uZ3hkaAS1mZxFaxD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

In order for other programs to figure out who owns the dm-devices that
are created by multipath and kpartx, this patch adds a prefix to the uuid
for all multipath and kpartx created devices.  When multipath gets the uuid,
the prefix is stripped back off. However other programs can use the device
mapper library or dmsetup to easily check which devices were created by
multipath or kpartx.

the multipath prefix is mpath-
the kpartx prefix is part%d- where %d is the partition number.

-Ben

--uZ3hkaAS1mZxFaxD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="uuid.patch"

diff -urpN mp-devel-clean/kpartx/devmapper.c mp-devel-patched/kpartx/devmapper.c
--- mp-devel-clean/kpartx/devmapper.c	2006-02-02 19:54:53.000000000 -0600
+++ mp-devel-patched/kpartx/devmapper.c	2006-06-01 11:30:48.000000000 -0500
@@ -7,6 +7,10 @@
 #include <libdevmapper.h>
 #include <ctype.h>
 #include <linux/kdev_t.h>
+#include <errno.h>
+
+#define UUID_PREFIX "part%d-"
+#define MAX_PREFIX_LEN 8
 
 extern int
 dm_prereq (char * str, int x, int y, int z)
@@ -68,9 +72,10 @@ dm_simplecmd (int task, const char *name
 
 extern int
 dm_addmap (int task, const char *name, const char *target,
-	   const char *params, unsigned long size) {
+	   const char *params, unsigned long size, const char *uuid, int part) {
 	int r = 0;
 	struct dm_task *dmt;
+	char *prefixed_uuid;
 
 	if (!(dmt = dm_task_create (task)))
 		return 0;
@@ -81,10 +86,26 @@ dm_addmap (int task, const char *name, c
 	if (!dm_task_add_target (dmt, 0, size, target, params))
 		goto addout;
 
+	if (task == DM_DEVICE_CREATE && uuid) {
+		prefixed_uuid = malloc(MAX_PREFIX_LEN + strlen(uuid) + 1);
+		if (!prefixed_uuid) {
+			fprintf(stderr, "cannot create prefixed uuid : %s\n",
+				strerror(errno));
+			goto addout;
+		}
+		sprintf(prefixed_uuid, UUID_PREFIX "%s", part, uuid);
+		if (!dm_task_set_uuid(dmt, prefixed_uuid))
+			goto freeout;
+	}
+
 	dm_task_no_open_count(dmt);
 
 	r = dm_task_run (dmt);
 
+	freeout:
+	if (prefixed_uuid)
+		free(prefixed_uuid);
+
 	addout:
 	dm_task_destroy (dmt);
 	return r;
@@ -178,3 +199,26 @@ out:
 	return ret;
 }
 
+char *
+dm_mapuuid(int major, int minor)
+{
+	struct dm_task *dmt;
+	char *tmp, *uuid = NULL;
+
+	if (!(dmt = dm_task_create(DM_DEVICE_INFO)))
+		return NULL;
+
+	dm_task_no_open_count(dmt);
+	dm_task_set_major(dmt, major);
+	dm_task_set_minor(dmt, minor);
+
+	if (!dm_task_run(dmt))
+		goto out;
+
+	tmp = dm_task_get_uuid(dmt);
+	if (tmp[0] != '\0')
+		uuid = strdup(tmp);
+out:
+	dm_task_destroy(dmt);
+	return uuid;
+}
diff -urpN mp-devel-clean/kpartx/devmapper.h mp-devel-patched/kpartx/devmapper.h
--- mp-devel-clean/kpartx/devmapper.h	2006-02-02 19:54:53.000000000 -0600
+++ mp-devel-patched/kpartx/devmapper.h	2006-06-01 11:30:55.000000000 -0500
@@ -1,6 +1,8 @@
 int dm_prereq (char *, int, int, int);
 int dm_simplecmd (int, const char *);
-int dm_addmap (int, const char *, const char *, const char *, unsigned long);
+int dm_addmap (int, const char *, const char *, const char *, unsigned long,
+	       char *, int);
 int dm_map_present (char *);
 char * dm_mapname(int major, int minor);
 dev_t dm_get_first_dep(char *devname);
+char * dm_mapuuid(int major, int minor);
diff -urpN mp-devel-clean/kpartx/kpartx.c mp-devel-patched/kpartx/kpartx.c
--- mp-devel-clean/kpartx/kpartx.c	2006-02-10 11:02:17.000000000 -0600
+++ mp-devel-patched/kpartx/kpartx.c	2006-06-01 11:31:14.000000000 -0500
@@ -192,6 +192,7 @@ main(int argc, char **argv){
 	char partname[PARTNAME_SIZE], params[PARTNAME_SIZE + 16];
 	char * loopdev = NULL;
 	char * delim = NULL;
+	char *uuid = NULL;
 	int loopro = 0;
 	int hotplug = 0;
 	struct stat buf;
@@ -284,11 +285,6 @@ main(int argc, char **argv){
 	}
 
 	if (S_ISREG (buf.st_mode)) {
-		loopdev = malloc(LO_NAME_SIZE * sizeof(char));
-		
-		if (!loopdev)
-			exit(1);
-
 		/* already looped file ? */
 		loopdev = find_loop_by_file(device);
 
@@ -313,6 +309,13 @@ main(int argc, char **argv){
 	}
 	
 	off = find_devname_offset(device);
+
+	if (!loopdev)
+		uuid = dm_mapuuid((unsigned int)MAJOR(buf.st_rdev),
+				  (unsigned int)MINOR(buf.st_rdev));
+	if (!uuid)
+		uuid = device + off;
+		
 	fd = open(device, O_RDONLY);
 
 	if (fd == -1) {
@@ -420,7 +423,7 @@ main(int argc, char **argv){
 					DM_DEVICE_RELOAD : DM_DEVICE_CREATE);
 
 				dm_addmap(op, partname, DM_TARGET, params,
-					  slices[j].size);
+					  slices[j].size, uuid, j+1);
 
 				if (op == DM_DEVICE_RELOAD)
 					dm_simplecmd(DM_DEVICE_RESUME,
diff -urpN mp-devel-clean/libmultipath/devmapper.c mp-devel-patched/libmultipath/devmapper.c
--- mp-devel-clean/libmultipath/devmapper.c	2006-02-13 11:53:35.000000000 -0600
+++ mp-devel-patched/libmultipath/devmapper.c	2006-06-01 04:58:02.000000000 -0500
@@ -11,6 +11,7 @@
 #include <ctype.h>
 #include <linux/kdev_t.h>
 #include <unistd.h>
+#include <errno.h>
 
 #include <checkers.h>
 
@@ -23,6 +24,10 @@
 #define MAX_WAIT 5
 #define LOOPS_PER_SEC 5
 
+#define UUID_PREFIX "mpath-"
+#define UUID_PREFIX_LEN 6
+
+
 static void
 dm_dummy_log (int level, const char *file, int line, const char *f, ...)
 {
@@ -113,6 +118,7 @@ dm_addmap (int task, const char *name, c
 	   const char *params, unsigned long long size, const char *uuid) {
 	int r = 0;
 	struct dm_task *dmt;
+	char *prefixed_uuid = NULL;
 
 	if (!(dmt = dm_task_create (task)))
 		return 0;
@@ -123,13 +129,26 @@ dm_addmap (int task, const char *name, c
 	if (!dm_task_add_target (dmt, 0, size, target, params))
 		goto addout;
 
-	if (uuid && !dm_task_set_uuid(dmt, uuid))
-		goto addout;
+	if (uuid){
+		prefixed_uuid = MALLOC(UUID_PREFIX_LEN + strlen(uuid) + 1);
+		if (!prefixed_uuid) {
+			condlog(0, "cannot create prefixed uuid : %s\n",
+				strerror(errno));
+			goto addout;
+		}
+		sprintf(prefixed_uuid, UUID_PREFIX "%s", uuid);
+		if (!dm_task_set_uuid(dmt, prefixed_uuid))
+			goto freeout;
+	}
 
 	dm_task_no_open_count(dmt);
 
 	r = dm_task_run (dmt);
 
+	freeout:
+	if (prefixed_uuid)
+		free(prefixed_uuid);
+
 	addout:
 	dm_task_destroy (dmt);
 	return r;
@@ -215,8 +234,12 @@ dm_get_uuid(char *name, char *uuid)
                 goto uuidout;
 
 	uuidtmp = dm_task_get_uuid(dmt);
-	if (uuidtmp)
-		strcpy(uuid, uuidtmp);
+	if (uuidtmp) {
+		if (!strncmp(uuidtmp, UUID_PREFIX, UUID_PREFIX_LEN))
+			strcpy(uuid, uuidtmp + UUID_PREFIX_LEN);
+		else
+			strcpy(uuid, uuidtmp);
+	}
 	else
 		uuid[0] = '\0';
 

--uZ3hkaAS1mZxFaxD
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--uZ3hkaAS1mZxFaxD--

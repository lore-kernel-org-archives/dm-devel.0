From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW dmeventd/dmeventd.c  ...
Date: 25 Jan 2007 14:16:21 -0000
Message-ID: <20070125141621.18784.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	device-mapper
Changes by:	agk@sourceware.org	2007-01-25 14:16:21

Modified files:
	.              : WHATS_NEW 
	dmeventd       : dmeventd.c 
	dmsetup        : dmsetup.c 
	lib/ioctl      : libdm-iface.c 

Log message:
	Add some missing close() and fclose() return value checks.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.159&r2=1.160
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/dmeventd.c.diff?cvsroot=dm&r1=1.44&r2=1.45
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/dmsetup.c.diff?cvsroot=dm&r1=1.79&r2=1.80
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/ioctl/libdm-iface.c.diff?cvsroot=dm&r1=1.40&r2=1.41

--- device-mapper/WHATS_NEW	2007/01/24 18:09:06	1.159
+++ device-mapper/WHATS_NEW	2007/01/25 14:16:20	1.160
@@ -1,5 +1,6 @@
 Version 1.02.16 -
 ===================================
+  Add some missing close() and fclose() return value checks.
   Migrate dmsetup column-based output over to new libdevmapper report framework.
   Add descriptions to reporting field definitions.
   Add a dso-private variable to dmeventd dso interface.
--- device-mapper/dmeventd/dmeventd.c	2007/01/23 17:38:39	1.44
+++ device-mapper/dmeventd/dmeventd.c	2007/01/25 14:16:20	1.45
@@ -1566,7 +1566,8 @@
 	}
 
 	fprintf(fp, "%i", val);
-	fclose(fp);
+	if (fclose(fp))
+		perror(OOM_ADJ_FILE ": fclose failed");
 
 	return 1;
 }
@@ -1583,7 +1584,7 @@
 
 	sigemptyset(&my_sigset);
 	if (sigprocmask(SIG_SETMASK, &my_sigset, NULL) < 0) {
-		fprintf(stderr, "Unable to restore signals.");
+		fprintf(stderr, "Unable to restore signals.\n");
 		exit(EXIT_FAILURE);
 	}
 	signal(SIGTERM, &_exit_handler);
--- device-mapper/dmsetup/dmsetup.c	2007/01/24 18:09:07	1.79
+++ device-mapper/dmsetup/dmsetup.c	2007/01/25 14:16:20	1.80
@@ -231,8 +231,9 @@
 #else
 	free(buffer);
 #endif
-	if (file)
-		fclose(fp);
+	if (file && fclose(fp))
+		fprintf(stderr, "%s: fclose failed: %s", file, strerror(errno));
+
 	return r;
 }
 
@@ -1479,7 +1480,7 @@
 static int _int32_disp(struct dm_report *rh,
 		       struct dm_pool *mem __attribute((unused)),
 		       struct dm_report_field *field, const void *data,
-		       void *private)
+		       void *private __attribute((unused)))
 {
 	const int32_t value = *(const int32_t *)data;
 
@@ -1489,7 +1490,7 @@
 static int _uint32_disp(struct dm_report *rh,
 			struct dm_pool *mem __attribute((unused)),
 		        struct dm_report_field *field, const void *data,
-		        void *private)
+		        void *private __attribute((unused)))
 {
 	const uint32_t value = *(const int32_t *)data;
 
@@ -1499,7 +1500,7 @@
 static int _dm_name_disp(struct dm_report *rh,
 			 struct dm_pool *mem __attribute((unused)),
 			 struct dm_report_field *field, const void *data,
-			 void *private)
+			 void *private __attribute((unused)))
 {
 	const char *name = dm_task_get_name((struct dm_task *) data);
 
@@ -1509,7 +1510,7 @@
 static int _dm_uuid_disp(struct dm_report *rh,
 			 struct dm_pool *mem __attribute((unused)),
 			 struct dm_report_field *field,
-			 const void *data, void *private)
+			 const void *data, void *private __attribute((unused)))
 {
 	const char *uuid = dm_task_get_uuid((struct dm_task *) data);
 
@@ -1522,7 +1523,7 @@
 static int _dm_info_status_disp(struct dm_report *rh,
 				struct dm_pool *mem __attribute((unused)),
 				struct dm_report_field *field, const void *data,
-				void *private)
+				void *private __attribute((unused)))
 {
 	char buf[5];
 	const char *s = buf;
@@ -1607,7 +1608,7 @@
 			options = _string_args[OPTIONS_ARG];
 		else {
 			len = strlen(default_report_options) +
-			      strlen(_string_args[OPTIONS_ARG]);
+			      strlen(_string_args[OPTIONS_ARG]) + 1;
 			if (!(options = dm_malloc(len))) {
 				err("Failed to allocate option string.");
 				return 0;
--- device-mapper/lib/ioctl/libdm-iface.c	2007/01/08 15:18:52	1.40
+++ device-mapper/lib/ioctl/libdm-iface.c	2007/01/25 14:16:20	1.41
@@ -149,7 +149,8 @@
 			if (!strcmp(name, nm)) {
 				if (number) {
 					*number = num;
-					fclose(fl);
+					if (fclose(fl))
+						log_error("%s: fclose failed: %s", file, strerror(errno));
 					return 1;
 				}
 				dm_bit_set(_dm_bitset, num);
@@ -158,7 +159,8 @@
 			c = fgetc(fl);
 		} while (c != EOF && c != '\n');
 	}
-	fclose(fl);
+	if (fclose(fl))
+		log_error("%s: fclose failed: %s", file, strerror(errno));
 
 	if (number) {
 		log_error("%s: No entry for %s found", file, name);
@@ -1322,7 +1324,7 @@
 
 	dir = dm_dir();
 	if (!(d = opendir(dir))) {
-		fprintf(stderr, "opendir %s: %s", dir, strerror(errno));
+		log_error("opendir %s: %s", dir, strerror(errno));
 		return 0;
 	}
 
@@ -1335,9 +1337,8 @@
 		dm_task_run(dmt);
 	}
 
-	if (closedir(d)) {
-		fprintf(stderr, "closedir %s: %s", dir, strerror(errno));
-	}
+	if (closedir(d))
+		log_error("closedir %s: %s", dir, strerror(errno));
 
 	return r;
 }

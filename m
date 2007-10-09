From: meyering@sourceware.org
Subject: device-mapper ./WHATS_NEW dmsetup/dmsetup.c li ...
Date: 9 Oct 2007 12:14:49 -0000
Message-ID: <20071009121449.10970.qmail@sourceware.org>
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
Changes by:	meyering@sourceware.org	2007-10-09 12:14:48

Modified files:
	.              : WHATS_NEW 
	dmsetup        : dmsetup.c 
	lib            : libdm-common.c 
	man            : dmsetup.8 

Log message:
	Allow $DM_DEV_DIR envvar to override default of "/dev".
	
	* dmsetup/dmsetup.c (DEV_PATH): Remove definition.
	(parse_loop_device_name): Add parameter: dev_dir.
	Declare the "dev" parameter to be "const".
	Use dev_dir, not DEV_PATH.  Handle the case in which dev_dir
	does not end in a "/".
	(_get_abspath): Declare "path" parameter "const", to match.
	(_process_losetup_switches): Add parameter: dev_dir.
	Pass dev_dir to parse_loop_device_name.
	(_process_switches): Add parameter: dev_dir.
	Pass dev_dir to _process_losetup_switches.
	(main): Set dev_dir from the DM_DEV_DIR envvar, else to "/dev".
	Call dm_set_dev_dir.
	* lib/libdm-common.c (dm_set_dev_dir): Rewrite to be careful
	about boundary conditions, now that dev_dir may be tainted.
	* man/dmsetup.8: Mention $DM_DEV_DIR.
	
	Author: Jim Meyering <meyering@redhat.com>

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.205&r2=1.206
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/dmsetup.c.diff?cvsroot=dm&r1=1.95&r2=1.96
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-common.c.diff?cvsroot=dm&r1=1.46&r2=1.47
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/man/dmsetup.8.diff?cvsroot=dm&r1=1.17&r2=1.18

--- device-mapper/WHATS_NEW	2007/09/18 13:02:58	1.205
+++ device-mapper/WHATS_NEW	2007/10/09 12:14:48	1.206
@@ -1,5 +1,6 @@
 Version 1.02.23 - 
 ==================================
+  Allow $DM_DEV_DIR envvar to override default of "/dev".
   Create e.g., libdevmapper.so.1.02, in build dir alongside the .so file.
   Avoid static link failure with some SELinux libraries.
   Remove obsolete dmfs code from tree and update INSTALL.
--- device-mapper/dmsetup/dmsetup.c	2007/08/21 16:26:06	1.95
+++ device-mapper/dmsetup/dmsetup.c	2007/10/09 12:14:48	1.96
@@ -90,6 +90,8 @@
 #define ARGS_MAX 256
 #define LOOP_TABLE_SIZE (PATH_MAX + 255)
 
+#define DEFAULT_DM_DEV_DIR "/dev"
+
 /* FIXME Should be imported */
 #ifndef DM_MAX_TYPE_NAME
 #  define DM_MAX_TYPE_NAME 16
@@ -97,7 +99,6 @@
 
 /* FIXME Should be elsewhere */
 #define SECTOR_SHIFT 9L
-#define DEV_PATH "/dev/"
 
 #define err(msg, x...) fprintf(stderr, msg "\n", ##x)
 
@@ -2129,7 +2130,7 @@
  * Returns the full absolute path, or NULL if the path could
  * not be resolved.
  */
-static char *_get_abspath(char *path)
+static char *_get_abspath(const char *path)
 {
 	char *_path;
 
@@ -2141,7 +2142,7 @@
 	return _path;
 }
 
-static char *parse_loop_device_name(char *dev)
+static char *parse_loop_device_name(const char *dev, const char *dev_dir)
 {
 	char *buf;
 	char *device;
@@ -2153,7 +2154,13 @@
 		if (!(device = _get_abspath(dev)))
 			goto error;
 
-		if (strncmp(device, DEV_PATH, strlen(DEV_PATH)))
+		if (strncmp(device, dev_dir, strlen(dev_dir)))
+			goto error;
+
+		/* If dev_dir does not end in a slash, ensure that the
+		   following byte in the device string is "/".  */
+		if (dev_dir[strlen(dev_dir) - 1] != '/'
+		    && device[strlen(dev_dir)] != '/')
 			goto error;
 
 		strncpy(buf, strrchr(device, '/') + 1, (size_t) PATH_MAX);
@@ -2234,7 +2241,8 @@
 	return 0;
 }
 
-static int _process_losetup_switches(const char *base, int *argc, char ***argv)
+static int _process_losetup_switches(const char *base, int *argc, char ***argv,
+				     const char *dev_dir)
 {
 	static int ind;
 	int c;
@@ -2297,7 +2305,7 @@
 		return 0;
 	}
 
-	if (!(device_name = parse_loop_device_name((*argv)[0]))) {
+	if (!(device_name = parse_loop_device_name((*argv)[0], dev_dir))) {
 		fprintf(stderr, "%s: Could not parse loop_device %s\n",
 			base, (*argv)[0]);
 		_losetup_usage(stderr);
@@ -2344,7 +2352,7 @@
 	return 1;
 }
 
-static int _process_switches(int *argc, char ***argv)
+static int _process_switches(int *argc, char ***argv, const char *dev_dir)
 {
 	char *base, *namebase;
 	static int ind;
@@ -2422,7 +2430,7 @@
 	}
 
 	if (!strcmp(base, "losetup") || !strcmp(base, "dmlosetup")){
-		r = _process_losetup_switches(base, argc, argv);
+		r = _process_losetup_switches(base, argc, argv, dev_dir);
 		free(namebase);
 		return r;
 	}
@@ -2539,10 +2547,21 @@
 {
 	struct command *c;
 	int r = 1;
+	const char *dev_dir;
 
 	(void) setlocale(LC_ALL, "");
 
-	if (!_process_switches(&argc, &argv)) {
+	dev_dir = getenv ("DM_DEV_DIR");
+	if (dev_dir && *dev_dir) {
+		if (!dm_set_dev_dir(dev_dir)) {
+			fprintf(stderr, "Invalid DM_DEV_DIR envvar value.\n");
+			goto out;
+		}
+	} else {
+		dev_dir = DEFAULT_DM_DEV_DIR;
+	}
+
+	if (!_process_switches(&argc, &argv, dev_dir)) {
 		fprintf(stderr, "Couldn't process command line.\n");
 		goto out;
 	}
--- device-mapper/lib/libdm-common.c	2007/08/21 16:26:06	1.46
+++ device-mapper/lib/libdm-common.c	2007/10/09 12:14:48	1.47
@@ -463,9 +463,25 @@
 	_pop_node_ops();
 }
 
-int dm_set_dev_dir(const char *dir)
+int dm_set_dev_dir(const char *dev_dir)
 {
-	snprintf(_dm_dir, sizeof(_dm_dir), "%s%s", dir, DM_DIR);
+	size_t len;
+	const char *slash;
+	if (*dev_dir != '/') {
+		log_debug("Invalid dev_dir value, %s: "
+			  "not an absolute name.", dev_dir);
+		return 0;
+	}
+
+	len = strlen(dev_dir);
+	slash = dev_dir[len-1] == '/' ? "" : "/";
+
+	if (snprintf(_dm_dir, sizeof _dm_dir, "%s%s%s", dev_dir, slash, DM_DIR)
+	    >= sizeof _dm_dir) {
+		log_debug("Invalid dev_dir value, %s: name too long.", dev_dir);
+		return 0;
+	}
+
 	return 1;
 }
 
--- device-mapper/man/dmsetup.8	2007/01/29 19:35:24	1.17
+++ device-mapper/man/dmsetup.8	2007/10/09 12:14:48	1.18
@@ -341,6 +341,12 @@
 .br
 2056320 2875602 linear /dev/hdb 1028160
 
+.SH ENVIRONMENT VARIABLES
+.TP
+\fBDM_DEV_DIR\fP
+The device directory name.
+Defaults to "/dev" and must be an absolute name.
+
 .SH AUTHORS
 Original version: Joe Thornber (thornber@sistina.com)
 

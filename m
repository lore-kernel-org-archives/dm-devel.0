From: bmarzins@sourceware.org
Subject: multipath-tools libmultipath/alias.c libmultip ...
Date: 14 Dec 2006 23:44:33 -0000
Message-ID: <20061214234433.23798.qmail@sourceware.org>
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
Module name:	multipath-tools
Branch: 	RHEL5_FC6
Changes by:	bmarzins@sourceware.org	2006-12-14 23:44:33

Modified files:
	libmultipath   : alias.c hwtable.c 
	multipath      : multipath.conf.redhat 

Log message:
	Fix for bz #218304. Also added some helpful text to the default multipath.conf
	and pulled in a bug fix that got accidentally got dropped from RHEL4 to RHEL5.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/alias.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.4&r2=1.4.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.20&r2=1.20.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/multipath.conf.redhat.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.6&r2=1.6.2.1

--- multipath-tools/libmultipath/alias.c	2006/06/06 18:32:43	1.4
+++ multipath-tools/libmultipath/alias.c	2006/12/14 23:44:33	1.4.2.1
@@ -166,28 +166,14 @@
 
 
 static int
-lookup_binding(int fd, char *map_wwid, char **map_alias)
+lookup_binding(FILE *f, char *map_wwid, char **map_alias)
 {
 	char buf[LINE_MAX];
-	FILE *f;
 	unsigned int line_nr = 0;
-	int scan_fd;
 	int id = 0;
 
 	*map_alias = NULL;
-	scan_fd = dup(fd);
-	if (scan_fd < 0) {
-		condlog(0, "Cannot dup bindings file descriptor : %s",
-			strerror(errno));
-		return -1;
-	}
-	f = fdopen(scan_fd, "r");
-	if (!f) {
-		condlog(0, "cannot fdopen on bindings file descriptor : %s",
-			strerror(errno));
-		close(scan_fd);
-		return -1;
-	}
+
 	while (fgets(buf, LINE_MAX, f)) {
 		char *c, *alias, *wwid;
 		int curr_id;
@@ -215,38 +201,22 @@
 			if (*map_alias == NULL)
 				condlog(0, "Cannot copy alias from bindings "
 					"file : %s", strerror(errno));
-			fclose(f);
 			return id;
 		}
 	}
 	condlog(3, "No matching wwid [%s] in bindings file.", map_wwid);
-	fclose(f);
 	return id;
 }	
 
 static int
-rlookup_binding(int fd, char **map_wwid, char *map_alias)
+rlookup_binding(FILE *f, char **map_wwid, char *map_alias)
 {
 	char buf[LINE_MAX];
-	FILE *f;
 	unsigned int line_nr = 0;
-	int scan_fd;
 	int id = 0;
 
 	*map_wwid = NULL;
-	scan_fd = dup(fd);
-	if (scan_fd < 0) {
-		condlog(0, "Cannot dup bindings file descriptor : %s",
-			strerror(errno));
-		return -1;
-	}
-	f = fdopen(scan_fd, "r");
-	if (!f) {
-		condlog(0, "cannot fdopen on bindings file descriptor : %s",
-			strerror(errno));
-		close(scan_fd);
-		return -1;
-	}
+
 	while (fgets(buf, LINE_MAX, f)) {
 		char *c, *alias, *wwid;
 		int curr_id;
@@ -274,12 +244,10 @@
 			if (*map_wwid == NULL)
 				condlog(0, "Cannot copy alias from bindings "
 					"file : %s", strerror(errno));
-			fclose(f);
 			return id;
 		}
 	}
 	condlog(3, "No matching alias [%s] in bindings file.", map_alias);
-	fclose(f);
 	return id;
 }	
 
@@ -327,7 +295,8 @@
 get_user_friendly_alias(char *wwid, char *file)
 {
 	char *alias;
-	int fd, id;
+	int fd, scan_fd, id;
+	FILE *f;
 
 	if (!wwid || *wwid == '\0') {
 		condlog(3, "Cannot find binding for empty WWID");
@@ -337,14 +306,37 @@
 	fd = open_bindings_file(file);
 	if (fd < 0)
 		return NULL;
-	id = lookup_binding(fd, wwid, &alias);
+
+	scan_fd = dup(fd);
+	if (scan_fd < 0) {
+		condlog(0, "Cannot dup bindings file descriptor : %s",
+			strerror(errno));
+		close(fd);
+		return NULL;
+	}
+
+	f = fdopen(scan_fd, "r");
+	if (!f) {
+		condlog(0, "cannot fdopen on bindings file descriptor : %s",
+			strerror(errno));
+		close(scan_fd);
+		close(fd);
+		return NULL;
+	}
+
+	id = lookup_binding(f, wwid, &alias);
 	if (id < 0) {
+		fclose(f);
+		close(scan_fd);
 		close(fd);
 		return NULL;
 	}
+
 	if (!alias)
 		alias = allocate_binding(fd, wwid, id);
 
+	fclose(f);
+	close(scan_fd);
 	close(fd);
 	return alias;
 }
@@ -353,7 +345,8 @@
 get_user_friendly_wwid(char *alias, char *file)
 {
 	char *wwid;
-	int fd, id;
+	int fd, scan_fd, id;
+	FILE *f;
 
 	if (!alias || *alias == '\0') {
 		condlog(3, "Cannot find binding for empty alias");
@@ -363,12 +356,34 @@
 	fd = open_bindings_file(file);
 	if (fd < 0)
 		return NULL;
-	id = rlookup_binding(fd, &wwid, alias);
+
+	scan_fd = dup(fd);
+	if (scan_fd < 0) {
+		condlog(0, "Cannot dup bindings file descriptor : %s",
+			strerror(errno));
+		close(fd);
+		return NULL;
+	}
+
+	f = fdopen(scan_fd, "r");
+	if (!f) {
+		condlog(0, "cannot fdopen on bindings file descriptor : %s",
+			strerror(errno));
+		close(scan_fd);
+		close(fd);
+		return NULL;
+	}
+
+	id = rlookup_binding(f, &wwid, alias);
 	if (id < 0) {
+		fclose(f);
+		close(scan_fd);
 		close(fd);
 		return NULL;
 	}
 
+	fclose(f);
+	close(scan_fd);
 	close(fd);
 	return wwid;
 }
--- multipath-tools/libmultipath/hwtable.c	2006/10/12 16:16:09	1.20
+++ multipath-tools/libmultipath/hwtable.c	2006/12/14 23:44:33	1.20.2.1
@@ -329,7 +329,7 @@
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
-		.pgpolicy      = GROUP_BY_SERIAL,
+		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
--- multipath-tools/multipath/multipath.conf.redhat	2006/07/17 21:09:08	1.6
+++ multipath-tools/multipath/multipath.conf.redhat	2006/12/14 23:44:33	1.6.2.1
@@ -36,7 +36,12 @@
 ##
 ## The wwid line in the following blacklist section is shown as an example
 ## of how to blacklist devices by wwid.  The 3 devnode lines are the
-## compiled in default blacklist.
+## compiled in default blacklist. If you want to blacklist entire types
+## of devices, such as all scsi devices, you should use a devnode line.
+## However, if you want to blacklist specific devices, you should use
+## a wwid line.  Since there is no guarantee that a specific device will
+## not change names on reboot (from /dev/sda to /dev/sdb for example)
+## devnode lines are not recommended for blacklisting specific devices.
 ##
 #devnode_blacklist {
 #       wwid 26353900f02796769

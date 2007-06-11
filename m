From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath alias.c
Date: 11 Jun 2007 23:24:10 -0000
Message-ID: <20070611232410.25763.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2007-06-11 23:24:09

Modified files:
	libmultipath   : alias.c 

Log message:
	On bootup, the bindings file in can't be written to.  This was causing multipath
	to not check it for aliases. Now, it the bindings file is on a read-only
	filesystem, it will be opened read-only.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/alias.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.4.2.1&r2=1.4.2.2

--- multipath-tools/libmultipath/alias.c	2006/12/14 23:44:33	1.4.2.1
+++ multipath-tools/libmultipath/alias.c	2007/06/11 23:24:09	1.4.2.2
@@ -120,21 +120,34 @@
 
 
 static int
-open_bindings_file(char *file)
+open_bindings_file(char *file, int *can_write)
 {
 	int fd;
 	struct stat s;
 
 	if (ensure_directories_exist(file, 0700))
 		return -1;
+	*can_write = 1;
 	fd = open(file, O_RDWR | O_CREAT, S_IRUSR | S_IWUSR);
 	if (fd < 0) {
-		condlog(0, "Cannot open bindings file [%s] : %s", file,
-			strerror(errno));
-		return -1;
+		if (errno == EROFS) {
+			*can_write = 0;
+			condlog(3, "Cannot open bindings file [%s] read/write. "
+				" trying readonly", file);
+			fd = open(file, O_RDONLY);
+			if (fd < 0) {
+				condlog(0, "Cannot open bindings file [%s] "
+					"readonly : %s", file, strerror(errno));
+				return -1;
+			}
+		}
+		else {
+			condlog(0, "Cannot open bindings file [%s] : %s", file,
+				strerror(errno));
+			return -1;
+		}
 	}
-
-	if (lock_bindings_file(fd) < 0)
+	if (*can_write && lock_bindings_file(fd) < 0)
 		goto fail;
 	
 	memset(&s, 0, sizeof(s));
@@ -143,6 +156,8 @@
 		goto fail;
 	}
 	if (s.st_size == 0) {
+		if (*can_write == 0)
+			goto fail;
 		/* If bindings file is empty, write the header */
 		size_t len = strlen(BINDINGS_FILE_HEADER);
 		if (write_all(fd, BINDINGS_FILE_HEADER, len) != len) {
@@ -297,13 +312,14 @@
 	char *alias;
 	int fd, scan_fd, id;
 	FILE *f;
+	int can_write;
 
 	if (!wwid || *wwid == '\0') {
 		condlog(3, "Cannot find binding for empty WWID");
 		return NULL;
 	}
 
-	fd = open_bindings_file(file);
+	fd = open_bindings_file(file, &can_write);
 	if (fd < 0)
 		return NULL;
 
@@ -332,7 +348,7 @@
 		return NULL;
 	}
 
-	if (!alias)
+	if (!alias && can_write)
 		alias = allocate_binding(fd, wwid, id);
 
 	fclose(f);
@@ -345,7 +361,7 @@
 get_user_friendly_wwid(char *alias, char *file)
 {
 	char *wwid;
-	int fd, scan_fd, id;
+	int fd, scan_fd, id, unused;
 	FILE *f;
 
 	if (!alias || *alias == '\0') {
@@ -353,7 +369,7 @@
 		return NULL;
 	}
 
-	fd = open_bindings_file(file);
+	fd = open_bindings_file(file, &unused);
 	if (fd < 0)
 		return NULL;
 

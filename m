From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH v2] multipath: add find_multipaths feature.
Date: Wed, 31 Aug 2011 21:55:18 -0500
Message-ID: <20110901025518.GD11793@ether.msp.redhat.com>
References: <20110725185758.GA1368@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20110725185758.GA1368@ether.msp.redhat.com>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

This adds a new default feature, find_multipaths. When this is set to yes,
multipath will no longer try to create a multipath device for every
non-blacklisted device. Instead, it will only create a device when one of
three conditions are met.

1. Three are at least two non-blacklisted paths with the same wwid
2. The user manually forces the creation, by specifying a device with the
   multipath command.
3. A path has the same wwid as a multipath device that was previously crreated
   (even if that multipath device doesn't currently exist).

To do 3, multipath stores the wwid of every path that it creates in
/etc/multipath/wwids. Whenever a path is added it's wwid is checked against
this file.  If there's a match, it is multipathed, even if it's the only path.
This should allow multipath to automatically choose the correct paths to make
into multipath devics in most cases, without needing the user to edit the
blacklist.

This is identical to my first post, except that it includes a previously
missing call to remember_wwid. 

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/Makefile    |    2 
 libmultipath/alias.c     |  151 ---------------------------------------
 libmultipath/alias.h     |    1 
 libmultipath/config.c    |    1 
 libmultipath/config.h    |    1 
 libmultipath/configure.c |   14 +++
 libmultipath/defaults.h  |    2 
 libmultipath/dict.c      |   34 ++++++++
 libmultipath/file.c      |  178 +++++++++++++++++++++++++++++++++++++++++++++++
 libmultipath/file.h      |   11 ++
 libmultipath/finder.c    |  165 +++++++++++++++++++++++++++++++++++++++++++
 libmultipath/finder.h    |   18 ++++
 multipath/main.c         |    2 
 multipathd/main.c        |    6 +
 14 files changed, 435 insertions(+), 151 deletions(-)

Index: multipath-tools-110713/libmultipath/alias.c
===================================================================
--- multipath-tools-110713.orig/libmultipath/alias.c
+++ multipath-tools-110713/libmultipath/alias.c
@@ -3,19 +3,16 @@
  * Copyright (c) 2005 Benjamin Marzinski, Redhat
  */
 #include <stdlib.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <fcntl.h>
 #include <errno.h>
 #include <unistd.h>
 #include <string.h>
 #include <limits.h>
 #include <stdio.h>
-#include <signal.h>
 
 #include "debug.h"
 #include "uxsock.h"
 #include "alias.h"
+#include "file.h"
 
 
 /*
@@ -36,148 +33,6 @@
  * See the file COPYING included with this distribution for more details.
  */
 
-static int
-ensure_directories_exist(char *str, mode_t dir_mode)
-{
-	char *pathname;
-	char *end;
-	int err;
-
-	pathname = strdup(str);
-	if (!pathname){
-		condlog(0, "Cannot copy bindings file pathname : %s",
-			strerror(errno));
-		return -1;
-	}
-	end = pathname;
-	/* skip leading slashes */
-	while (end && *end && (*end == '/'))
-		end++;
-
-	while ((end = strchr(end, '/'))) {
-		/* if there is another slash, make the dir. */
-		*end = '\0';
-		err = mkdir(pathname, dir_mode);
-		if (err && errno != EEXIST) {
-			condlog(0, "Cannot make directory [%s] : %s",
-				pathname, strerror(errno));
-			free(pathname);
-			return -1;
-		}
-		if (!err)
-			condlog(3, "Created dir [%s]", pathname);
-		*end = '/';
-		end++;
-	}
-	free(pathname);
-	return 0;
-}
-
-static void
-sigalrm(int sig)
-{
-	/* do nothing */
-}
-
-static int
-lock_bindings_file(int fd)
-{
-	struct sigaction act, oldact;
-	sigset_t set, oldset;
-	struct flock lock;
-	int err;
-
-	memset(&lock, 0, sizeof(lock));
-	lock.l_type = F_WRLCK;
-	lock.l_whence = SEEK_SET;
-
-	act.sa_handler = sigalrm;
-	sigemptyset(&act.sa_mask);
-	act.sa_flags = 0;
-	sigemptyset(&set);
-	sigaddset(&set, SIGALRM);
-
-	sigaction(SIGALRM, &act, &oldact);
-	sigprocmask(SIG_UNBLOCK, &set, &oldset);
-
-	alarm(BINDINGS_FILE_TIMEOUT);
-	err = fcntl(fd, F_SETLKW, &lock);
-	alarm(0);
-
-	if (err) {
-		if (errno != EINTR)
-			condlog(0, "Cannot lock bindings file : %s",
-					strerror(errno));
-		else
-			condlog(0, "Bindings file is locked. Giving up.");
-	}
-
-	sigprocmask(SIG_SETMASK, &oldset, NULL);
-	sigaction(SIGALRM, &oldact, NULL);
-	return err;
-
-}
-
-
-static int
-open_bindings_file(char *file, int *can_write)
-{
-	int fd;
-	struct stat s;
-
-	if (ensure_directories_exist(file, 0700))
-		return -1;
-	*can_write = 1;
-	fd = open(file, O_RDWR | O_CREAT, S_IRUSR | S_IWUSR);
-	if (fd < 0) {
-		if (errno == EROFS) {
-			*can_write = 0;
-			condlog(3, "Cannot open bindings file [%s] read/write. "
-				" trying readonly", file);
-			fd = open(file, O_RDONLY);
-			if (fd < 0) {
-				condlog(0, "Cannot open bindings file [%s] "
-					"readonly : %s", file, strerror(errno));
-				return -1;
-			}
-		}
-		else {
-			condlog(0, "Cannot open bindings file [%s] : %s", file,
-				strerror(errno));
-			return -1;
-		}
-	}
-	if (*can_write && lock_bindings_file(fd) < 0)
-		goto fail;
-
-	memset(&s, 0, sizeof(s));
-	if (fstat(fd, &s) < 0){
-		condlog(0, "Cannot stat bindings file : %s", strerror(errno));
-		goto fail;
-	}
-	if (s.st_size == 0) {
-		if (*can_write == 0)
-			goto fail;
-		/* If bindings file is empty, write the header */
-		size_t len = strlen(BINDINGS_FILE_HEADER);
-		if (write_all(fd, BINDINGS_FILE_HEADER, len) != len) {
-			condlog(0,
-				"Cannot write header to bindings file : %s",
-				strerror(errno));
-			/* cleanup partially written header */
-			ftruncate(fd, 0);
-			goto fail;
-		}
-		fsync(fd);
-		condlog(3, "Initialized new bindings file [%s]", file);
-	}
-
-	return fd;
-
-fail:
-	close(fd);
-	return -1;
-}
 
 static int
 format_devname(char *name, int id, int len, char *prefix)
@@ -366,7 +221,7 @@ get_user_friendly_alias(char *wwid, char
 		return NULL;
 	}
 
-	fd = open_bindings_file(file, &can_write);
+	fd = open_file(file, &can_write, BINDINGS_FILE_HEADER);
 	if (fd < 0)
 		return NULL;
 
@@ -416,7 +271,7 @@ get_user_friendly_wwid(char *alias, char
 		return NULL;
 	}
 
-	fd = open_bindings_file(file, &unused);
+	fd = open_file(file, &unused, BINDINGS_FILE_HEADER);
 	if (fd < 0)
 		return NULL;
 
Index: multipath-tools-110713/libmultipath/alias.h
===================================================================
--- multipath-tools-110713.orig/libmultipath/alias.h
+++ multipath-tools-110713/libmultipath/alias.h
@@ -1,4 +1,3 @@
-#define BINDINGS_FILE_TIMEOUT 30
 #define BINDINGS_FILE_HEADER \
 "# Multipath bindings, Version : 1.0\n" \
 "# NOTE: this file is automatically maintained by the multipath program.\n" \
Index: multipath-tools-110713/libmultipath/config.c
===================================================================
--- multipath-tools-110713.orig/libmultipath/config.c
+++ multipath-tools-110713/libmultipath/config.c
@@ -497,6 +497,7 @@ load_config (char * file)
 	conf->flush_on_last_del = 0;
 	conf->attribute_flags = 0;
 	conf->reassign_maps = DEFAULT_REASSIGN_MAPS;
+	conf->find_multipaths = DEFAULT_FIND_MULTIPATHS;
 
 	/*
 	 * preload default hwtable
Index: multipath-tools-110713/libmultipath/config.h
===================================================================
--- multipath-tools-110713.orig/libmultipath/config.h
+++ multipath-tools-110713/libmultipath/config.h
@@ -92,6 +92,7 @@ struct config {
 	int attribute_flags;
 	int fast_io_fail;
 	unsigned int dev_loss;
+	int find_multipaths;
 	uid_t uid;
 	gid_t gid;
 	mode_t mode;
Index: multipath-tools-110713/libmultipath/configure.c
===================================================================
--- multipath-tools-110713.orig/libmultipath/configure.c
+++ multipath-tools-110713/libmultipath/configure.c
@@ -35,6 +35,7 @@
 #include "alias.h"
 #include "prio.h"
 #include "util.h"
+#include "finder.h"
 
 extern int
 setup_map (struct multipath * mpp, char * params, int params_size)
@@ -404,6 +405,8 @@ domap (struct multipath * mpp, char * pa
 		 * DM_DEVICE_CREATE, DM_DEVICE_RENAME, or DM_DEVICE_RELOAD
 		 * succeeded
 		 */
+		if (mpp->action == ACT_CREATE)
+			remember_wwid(mpp->wwid);
 		if (!conf->daemon) {
 			/* multipath client mode */
 			dm_switchgroup(mpp->alias, mpp->bestpg);
@@ -463,6 +466,10 @@ coalesce_paths (struct vectors * vecs, v
 
 	memset(empty_buff, 0, WWID_SIZE);
 
+	/* ignore refwwid if it's empty */
+	if (refwwid && !strlen(refwwid))
+		refwwid = NULL;
+
 	if (force_reload) {
 		vector_foreach_slot (pathvec, pp1, k) {
 			pp1->mpp = NULL;
@@ -492,6 +499,13 @@ coalesce_paths (struct vectors * vecs, v
 		if (refwwid && strncmp(pp1->wwid, refwwid, WWID_SIZE))
 			continue;
 
+		/* If find_multipaths was selected check if the path is valid */
+		if (conf->find_multipaths && !refwwid &&
+		    !should_multipath(pp1, pathvec)) {
+			orphan_path(pp1);
+			continue;
+		}
+
 		/*
 		 * at this point, we know we really got a new mp
 		 */
Index: multipath-tools-110713/libmultipath/defaults.h
===================================================================
--- multipath-tools-110713.orig/libmultipath/defaults.h
+++ multipath-tools-110713/libmultipath/defaults.h
@@ -15,6 +15,7 @@
 #define DEFAULT_USER_FRIENDLY_NAMES    0
 #define DEFAULT_VERBOSITY	2
 #define DEFAULT_REASSIGN_MAPS	1
+#define DEFAULT_FIND_MULTIPATHS 0
 
 #define DEFAULT_CHECKINT	5
 #define MAX_CHECKINT(a)		(a << 2)
@@ -24,5 +25,6 @@
 #define DEFAULT_SOCKET		"/var/run/multipathd.sock"
 #define DEFAULT_CONFIGFILE	"/etc/multipath.conf"
 #define DEFAULT_BINDINGS_FILE	"/etc/multipath/bindings"
+#define DEFAULT_WWIDS_FILE	"/etc/multipath/wwids"
 
 char * set_default (char * str);
Index: multipath-tools-110713/libmultipath/dict.c
===================================================================
--- multipath-tools-110713.orig/libmultipath/dict.c
+++ multipath-tools-110713/libmultipath/dict.c
@@ -525,6 +525,27 @@ def_flush_on_last_del_handler(vector str
 }
 
 static int
+def_find_multipaths_handler(vector strvec)
+{
+	char * buff;
+
+	buff = set_value(strvec);
+
+	if (!buff)
+		return 1;
+
+	if ((strlen(buff) == 2 && !strcmp(buff, "no")) ||
+	    (strlen(buff) == 1 && !strcmp(buff, "0")))
+		conf->find_multipaths = 0;
+	else if ((strlen(buff) == 3 && !strcmp(buff, "yes")) ||
+		 (strlen(buff) == 1 && !strcmp(buff, "1")))
+		conf->find_multipaths = 1;
+
+	FREE(buff);
+	return 0;
+}
+
+static int
 names_handler(vector strvec)
 {
 	char * buff;
@@ -2338,6 +2359,18 @@ snprint_def_flush_on_last_del (char * bu
 }
 
 static int
+snprint_def_find_multipaths (char * buff, int len, void * data)
+{
+	if (conf->find_multipaths == DEFAULT_FIND_MULTIPATHS)
+		return 0;
+	if (!conf->find_multipaths)
+		return snprintf(buff, len, "no");
+
+	return snprintf(buff, len, "yes");
+}
+
+
+static int
 snprint_def_user_friendly_names (char * buff, int len, void * data)
 {
 	if (!conf->user_friendly_names)
@@ -2428,6 +2461,7 @@ init_keywords(void)
 	install_keyword("fast_io_fail_tmo", &def_fast_io_fail_handler, &snprint_def_fast_io_fail);
 	install_keyword("dev_loss_tmo", &def_dev_loss_handler, &snprint_def_dev_loss);
 	install_keyword("bindings_file", &bindings_file_handler, &snprint_def_bindings_file);
+	install_keyword("find_multipaths", &def_find_multipaths_handler, &snprint_def_find_multipaths);
 	__deprecated install_keyword("default_selector", &def_selector_handler, NULL);
 	__deprecated install_keyword("default_path_grouping_policy", &def_pgpolicy_handler, NULL);
 	__deprecated install_keyword("default_getuid_callout", &def_getuid_callout_handler, NULL);
Index: multipath-tools-110713/libmultipath/file.c
===================================================================
--- /dev/null
+++ multipath-tools-110713/libmultipath/file.c
@@ -0,0 +1,178 @@
+/*
+ * Copyright (c) 2005 Christophe Varoqui
+ * Copyright (c) 2005 Benjamin Marzinski, Redhat
+ */
+#include <stdlib.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <unistd.h>
+#include <string.h>
+#include <limits.h>
+#include <stdio.h>
+#include <signal.h>
+
+#include "file.h"
+#include "debug.h"
+#include "uxsock.h"
+
+
+/*
+ * significant parts of this file were taken from iscsi-bindings.c of the
+ * linux-iscsi project.
+ * Copyright (C) 2002 Cisco Systems, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * See the file COPYING included with this distribution for more details.
+ */
+
+static int
+ensure_directories_exist(char *str, mode_t dir_mode)
+{
+	char *pathname;
+	char *end;
+	int err;
+
+	pathname = strdup(str);
+	if (!pathname){
+		condlog(0, "Cannot copy file pathname %s : %s",
+			str, strerror(errno));
+		return -1;
+	}
+	end = pathname;
+	/* skip leading slashes */
+	while (end && *end && (*end == '/'))
+		end++;
+
+	while ((end = strchr(end, '/'))) {
+		/* if there is another slash, make the dir. */
+		*end = '\0';
+		err = mkdir(pathname, dir_mode);
+		if (err && errno != EEXIST) {
+			condlog(0, "Cannot make directory [%s] : %s",
+				pathname, strerror(errno));
+			free(pathname);
+			return -1;
+		}
+		if (!err)
+			condlog(3, "Created dir [%s]", pathname);
+		*end = '/';
+		end++;
+	}
+	free(pathname);
+	return 0;
+}
+
+static void
+sigalrm(int sig)
+{
+	/* do nothing */
+}
+
+static int
+lock_file(int fd, char *file_name)
+{
+	struct sigaction act, oldact;
+	sigset_t set, oldset;
+	struct flock lock;
+	int err;
+
+	memset(&lock, 0, sizeof(lock));
+	lock.l_type = F_WRLCK;
+	lock.l_whence = SEEK_SET;
+
+	act.sa_handler = sigalrm;
+	sigemptyset(&act.sa_mask);
+	act.sa_flags = 0;
+	sigemptyset(&set);
+	sigaddset(&set, SIGALRM);
+
+	sigaction(SIGALRM, &act, &oldact);
+	sigprocmask(SIG_UNBLOCK, &set, &oldset);
+
+	alarm(FILE_TIMEOUT);
+	err = fcntl(fd, F_SETLKW, &lock);
+	alarm(0);
+
+	if (err) {
+		if (errno != EINTR)
+			condlog(0, "Cannot lock %s : %s", file_name,
+				strerror(errno));
+		else
+			condlog(0, "%s is locked. Giving up.", file_name);
+	}
+
+	sigprocmask(SIG_SETMASK, &oldset, NULL);
+	sigaction(SIGALRM, &oldact, NULL);
+	return err;
+}
+
+int
+open_file(char *file, int *can_write, char *header)
+{
+	int fd;
+	struct stat s;
+
+	if (ensure_directories_exist(file, 0700))
+		return -1;
+	*can_write = 1;
+	fd = open(file, O_RDWR | O_CREAT, S_IRUSR | S_IWUSR);
+	if (fd < 0) {
+		if (errno == EROFS) {
+			*can_write = 0;
+			condlog(3, "Cannot open file [%s] read/write. "
+				" trying readonly", file);
+			fd = open(file, O_RDONLY);
+			if (fd < 0) {
+				condlog(0, "Cannot open file [%s] "
+					"readonly : %s", file, strerror(errno));
+				return -1;
+			}
+		}
+		else {
+			condlog(0, "Cannot open file [%s] : %s", file,
+				strerror(errno));
+			return -1;
+		}
+	}
+	if (*can_write && lock_file(fd, file) < 0)
+		goto fail;
+
+	memset(&s, 0, sizeof(s));
+	if (fstat(fd, &s) < 0){
+		condlog(0, "Cannot stat file %s : %s", file, strerror(errno));
+		goto fail;
+	}
+	if (s.st_size == 0) {
+		if (*can_write == 0)
+			goto fail;
+		/* If file is empty, write the header */
+		size_t len = strlen(header);
+		if (write_all(fd, header, len) != len) {
+			condlog(0,
+				"Cannot write header to file %s : %s", file,
+				strerror(errno));
+			/* cleanup partially written header */
+			ftruncate(fd, 0);
+			goto fail;
+		}
+		fsync(fd);
+		condlog(3, "Initialized new file [%s]", file);
+	}
+
+	return fd;
+
+fail:
+	close(fd);
+	return -1;
+}
Index: multipath-tools-110713/libmultipath/file.h
===================================================================
--- /dev/null
+++ multipath-tools-110713/libmultipath/file.h
@@ -0,0 +1,11 @@
+/*
+ * Copyright (c) 2010 Benjamin Marzinski, Redhat
+ */
+
+#ifndef _FILE_H
+#define _FILE_H
+
+#define FILE_TIMEOUT 30
+int open_file(char *file, int *can_write, char *header);
+
+#endif /* _FILE_H */
Index: multipath-tools-110713/libmultipath/finder.c
===================================================================
--- /dev/null
+++ multipath-tools-110713/libmultipath/finder.c
@@ -0,0 +1,165 @@
+#include <stdlib.h>
+#include <errno.h>
+#include <unistd.h>
+#include <string.h>
+#include <limits.h>
+#include <stdio.h>
+
+#include "checkers.h"
+#include "vector.h"
+#include "structs.h"
+#include "debug.h"
+#include "uxsock.h"
+#include "file.h"
+#include "finder.h"
+#include "defaults.h"
+
+/*
+ * Copyright (c) 2010 Benjamin Marzinski, Redhat
+ */
+
+static int
+lookup_wwid(FILE *f, char *wwid) {
+	int c;
+	char buf[LINE_MAX];
+	int count;
+
+	while ((c = fgetc(f)) != EOF){
+		if (c != '/') {
+			if (fgets(buf, LINE_MAX, f) == NULL)
+				return 0;
+			else
+				continue;
+		}
+		count = 0;
+		while ((c = fgetc(f)) != '/') {
+			if (c == EOF)
+				return 0;
+			if (count >= WWID_SIZE - 1)
+				goto next;
+			if (wwid[count] == '\0')
+				goto next;
+			if (c != wwid[count++])
+				goto next;
+		}
+		if (wwid[count] == '\0')
+			return 1;
+next:
+		if (fgets(buf, LINE_MAX, f) == NULL)
+			return 0;
+	}
+	return 0;
+}
+
+static int
+write_out_wwid(int fd, char *wwid) {
+	int ret;
+	off_t offset;
+	char buf[WWID_SIZE + 3];
+
+	ret = snprintf(buf, WWID_SIZE + 3, "/%s/\n", wwid);
+	if (ret >= (WWID_SIZE + 3) || ret < 0){
+		condlog(0, "can't format wwid for writing (%d) : %s",
+			ret, strerror(errno));
+		return -1;
+	}
+	offset = lseek(fd, 0, SEEK_END);
+	if (offset < 0) {
+		condlog(0, "can't seek to the end of wwids file : %s",
+			strerror(errno));
+		return -1;
+	}
+	if (write_all(fd, buf, strlen(buf)) != strlen(buf)) {
+		condlog(0, "cannot write wwid to wwids file : %s",
+			strerror(errno));
+		ftruncate(fd, offset);
+		return -1;
+	}
+	return 1;
+}
+
+static int
+check_wwids_file(char *wwid, int write_wwid)
+{
+	int scan_fd, fd, can_write, found, ret;
+	FILE *f;
+	fd = open_file(DEFAULT_WWIDS_FILE, &can_write, WWIDS_FILE_HEADER);
+	if (fd < 0)
+		return -1;
+
+	scan_fd = dup(fd);
+	if (scan_fd < 0) {
+		condlog(0, "can't dup wwids file descriptor : %s",
+			strerror(errno));
+		close(fd);
+		return -1;
+	}
+	f = fdopen(scan_fd, "r");
+	if (!f) {
+		condlog(0,"can't fdopen wwids file : %s", strerror(errno));
+		close(fd);
+		close(scan_fd);
+		return -1;
+	}
+	found = lookup_wwid(f, wwid);
+	if (found) {
+		ret = 0;
+		goto out;
+	}
+	if (!write_wwid) {
+		ret = -1;
+		goto out;
+	}
+	if (!can_write) {
+		condlog(0, "wwids file is read-only. Can't write wwid");
+		ret = -1;
+		goto out;
+	}
+	ret = write_out_wwid(fd, wwid);
+out:
+	fclose(f);
+	close(scan_fd);
+	close(fd);
+	return ret;
+}
+
+int
+should_multipath(struct path *pp1, vector pathvec)
+{
+	int i;
+	struct path *pp2;
+
+	condlog(4, "checking if %s should be multipathed", pp1->dev);
+	vector_foreach_slot(pathvec, pp2, i) {
+		if (pp1->dev == pp2->dev)
+			continue;
+		if (strncmp(pp1->wwid, pp2->wwid, WWID_SIZE) == 0) {
+			condlog(3, "found multiple paths with wwid %s, "
+				"multipathing %s", pp1->wwid, pp1->dev);
+			return 1;
+		}
+	}
+	if (check_wwids_file(pp1->wwid, 0) < 0) {
+		condlog(3, "wwid %s not in wwids file, skipping %s",
+			pp1->wwid, pp1->dev);
+		return 0;
+	}
+	condlog(3, "found wwid %s in wwids file, multipathing %s", pp1->wwid,
+		pp1->dev);
+	return 1;
+}
+
+int
+remember_wwid(char *wwid)
+{
+	int ret = check_wwids_file(wwid, 1);
+	if (ret < 0){
+		condlog(3, "failed writing wwid %s to wwids file", wwid);
+		return -1;
+	}
+	if (ret == 1)
+		condlog(3, "wrote wwid %s to wwids file", wwid);
+	else
+		condlog(4, "wwid %s already in wwids file", wwid);
+	return 0;
+}
Index: multipath-tools-110713/libmultipath/finder.h
===================================================================
--- /dev/null
+++ multipath-tools-110713/libmultipath/finder.h
@@ -0,0 +1,18 @@
+/*
+ * Copyright (c) 2010 Benjamin Marzinski, Redhat
+ */
+
+#ifndef _FINDER_H
+#define _FINDER_H
+
+#define WWIDS_FILE_HEADER \
+"# Multipath wwids, Version : 1.0\n" \
+"# NOTE: This file is automatically maintained by multipath and multipathd.\n" \
+"# You should not need to edit this file in normal circumstances.\n" \
+"#\n" \
+"# Valid WWIDs:\n"
+
+int should_multipath(struct path *pp, vector pathvec);
+int remember_wwid(char *wwid);
+
+#endif /* _FINDER_H */
Index: multipath-tools-110713/multipath/main.c
===================================================================
--- multipath-tools-110713.orig/multipath/main.c
+++ multipath-tools-110713/multipath/main.c
@@ -313,7 +313,7 @@ configure (void)
 	/*
 	 * core logic entry point
 	 */
-	r = coalesce_paths(&vecs, NULL, NULL, conf->force_reload);
+	r = coalesce_paths(&vecs, NULL, refwwid, conf->force_reload);
 
 out:
 	if (refwwid)
Index: multipath-tools-110713/multipathd/main.c
===================================================================
--- multipath-tools-110713.orig/multipathd/main.c
+++ multipath-tools-110713/multipathd/main.c
@@ -47,6 +47,7 @@
 #include <print.h>
 #include <configure.h>
 #include <prio.h>
+#include <finder.h>
 #include <pgpolicies.h>
 #include <uevent.h>
 
@@ -447,6 +448,11 @@ rescan:
 			return 1;
 		}
 
+		if (conf->find_multipaths &&
+		    !should_multipath(pp, vecs->pathvec)) {
+			orphan_path(pp);
+			return 0;
+		}
 		condlog(4,"%s: creating new map", pp->dev);
 		if ((mpp = add_map_with_path(vecs, pp, 1))) {
 			mpp->action = ACT_CREATE;
Index: multipath-tools-110713/libmultipath/Makefile
===================================================================
--- multipath-tools-110713.orig/libmultipath/Makefile
+++ multipath-tools-110713/libmultipath/Makefile
@@ -15,7 +15,7 @@ OBJS = memory.o parser.o vector.o devmap
        pgpolicies.o debug.o regex.o defaults.o uevent.o \
        switchgroup.o uxsock.o print.o alias.o log_pthread.o \
        log.o configure.o structs_vec.o sysfs.o prio.o checkers.o \
-       lock.o waiter.o
+       lock.o waiter.o file.o finder.o
 
 LIBDM_API_FLUSH = $(shell grep -Ecs '^[a-z]*[[:space:]]+dm_task_no_flush' /usr/include/libdevmapper.h)
 

From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: User friendly names patch.
Date: Mon, 24 Oct 2005 10:23:41 -0500
Message-ID: <20051024152341.GA19176@phlogiston.msp.redhat.com>
References: <20051021233521.GA32160@phlogiston.msp.redhat.com>
	<1129966596.7313.58.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="zhXaljGHf11kAtnf"
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1129966596.7313.58.camel@zezette>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@free.fr, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Oct 22, 2005 at 09:36:35AM +0200, Christophe Varoqui wrote:
> On ven, 2005-10-21 at 18:35 -0500, Benjamin Marzinski wrote:
> > This is a patch to add the option of more user friendly names for the
> > multipath maps, in the form of mpath<n>.  It adds a configuration option
> > "user_friendly_names". If set, it will cause multipath to check a bindings
> > file for the names. The bindings file (/var/lib/multipath/bindings) has
> > alias to wwid mappings. If multipath finds its wwid in the file, it uses
> > the associated alias. If not, it creates a new alias, and adds the binding
> > to the bindings file. If the config option is not set, multipath defaults
> > to it's regular behavior. Specific aliases in /etc/multipath.conf override
> > this behavior.
> > 
> You forgot to attach the patch :/
> I'll review it again.

Oops.

Here.
 
> Last time I remember I had some worries about it, though I'm perfectly
> happy with the feature. Others' review is welcome.
> 
> Regards,
> cvaroqui
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="mp-alias.patch"

diff -urpN mp-devel-clean/libmultipath/alias.c mp-devel-patched/libmultipath/alias.c
--- mp-devel-clean/libmultipath/alias.c	1969-12-31 18:00:00.000000000 -0600
+++ mp-devel-patched/libmultipath/alias.c	2005-10-21 18:21:42.000000000 -0500
@@ -0,0 +1,271 @@
+#include <stdlib.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <unistd.h>
+#include <string.h>
+#include <limits.h>
+#include <stdio.h>
+#include "debug.h"
+#include "uxsock.h"
+#include "alias.h"
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
+		condlog(0, "Cannot copy bindings file pathname : %s",
+			strerror(errno));
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
+static int
+lock_bindings_file(int fd)
+{
+	struct flock lock;
+	int retrys = BINDINGS_FILE_RETRYS;
+	
+	memset(&lock, 0, sizeof(lock));
+	lock.l_type = F_WRLCK;
+	lock.l_whence = SEEK_SET;
+
+	while (fcntl(fd, F_SETLK, &lock) < 0) {
+		if (errno != EACCES && errno != EAGAIN) {
+			condlog(0, "Cannot lock bindings file : %s",
+				strerror(errno));
+			return -1;
+		} else {
+			condlog(0, "Bindings file is currently locked");
+			if ((retrys--) == 0)
+				return -1;
+		}
+		/* because I'm paranoid */
+		memset(&lock, 0, sizeof(lock));
+		lock.l_type = F_WRLCK;
+		lock.l_whence = SEEK_SET;
+		
+		condlog(0, "retrying");
+		sleep(1);
+	}
+	return 0;
+}
+
+
+static int
+open_bindings_file(char *file)
+{
+	int fd;
+	struct stat s;
+
+	if (ensure_directories_exist(file, 0700))
+		return -1;
+	fd = open(file, O_RDWR | O_CREAT, S_IRUSR | S_IWUSR);
+	if (fd < 0) {
+		condlog(0, "Cannot open bindings file [%s] : %s", file,
+			strerror(errno));
+		return -1;
+	}
+
+	if (lock_bindings_file(fd) < 0)
+		goto fail;
+	
+	memset(&s, 0, sizeof(s));
+	if (fstat(fd, &s) < 0){
+		condlog(0, "Cannot stat bindings file : %s", strerror(errno));
+		goto fail;
+	}
+	if (s.st_size == 0) {
+		/* If bindings file is empty, write the header */
+		size_t len = strlen(BINDINGS_FILE_HEADER);
+		if (write_all(fd, BINDINGS_FILE_HEADER, len) != len) {
+			condlog(0,
+				"Cannot write header to bindings file : %s",
+				strerror(errno));
+			/* cleanup partially written header */
+			ftruncate(fd, 0);
+			goto fail;
+		}
+		fsync(fd);
+		condlog(3, "Initialized new bindings file [%s]", file);
+	}
+	
+	return fd;
+
+fail:
+	close(fd);
+	return -1;
+}
+
+
+static int
+lookup_binding(int fd, char *map_wwid, char **map_alias)
+{
+	char buf[LINE_MAX];
+	FILE *f;
+	unsigned int line_nr = 0;
+	int scan_fd;
+	int id = 0;
+
+	*map_alias = NULL;
+	scan_fd = dup(fd);
+	if (scan_fd < 0) {
+		condlog(0, "Cannot dup bindings file descriptor : %s",
+			strerror(errno));
+		return -1;
+	}
+	f = fdopen(scan_fd, "r");
+	if (!f) {
+		condlog(0, "cannot fdopen on bindings file descriptor : %s",
+			strerror(errno));
+		close(scan_fd);
+		return -1;
+	}
+	while (fgets(buf, LINE_MAX, f)) {
+		char *c, *alias, *wwid;
+		int curr_id;
+
+		line_nr++;
+		c = strpbrk(buf, "#\n\r");
+		if (c)
+			*c = '\0';
+		alias = strtok(buf, " \t");
+		if (!alias) /* blank line */
+			continue;
+		if (sscanf(alias, "mpath%d", &curr_id) == 1 && curr_id >= id)
+			id = curr_id + 1;
+		wwid = strtok(NULL, " \t");
+		if (!wwid){
+			condlog(3,
+				"Ignoring malformed line %u in bindings file",
+				line_nr);
+			continue;
+		}
+		if (strcmp(wwid, map_wwid) == 0){
+			condlog(3, "Found matching wwid [%s] in bindings file."
+				"\nSetting alias to %s", wwid, alias);
+			*map_alias = strdup(alias);
+			if (*map_alias == NULL)
+				condlog(0, "Cannot copy alias from bindings "
+					"file : %s", strerror(errno));
+			fclose(f);
+			return id;
+		}
+	}
+	condlog(3, "No matching wwid [%s] in bindings file.", map_wwid);
+	fclose(f);
+	return id;
+}	
+
+static char *
+allocate_binding(int fd, char *wwid, int id)
+{
+	char buf[LINE_MAX];
+	off_t offset;
+	char *alias, *c;
+	
+	if (id < 0) {
+		condlog(0, "Bindings file full. Cannot allocate new binding");
+		return NULL;
+	}
+	
+	snprintf(buf, LINE_MAX, "mpath%d %s\n", id, wwid);
+	buf[LINE_MAX - 1] = '\0';
+
+	offset = lseek(fd, 0, SEEK_END);
+	if (offset < 0){
+		condlog(0, "Cannot seek to end of bindings file : %s",
+			strerror(errno));
+		return NULL;
+	}
+	if (write_all(fd, buf, strlen(buf)) != strlen(buf)){
+		condlog(0, "Cannot write binding to bindings file : %s",
+			strerror(errno));
+		/* clear partial write */
+		ftruncate(fd, offset);
+		return NULL;
+	}
+	c = strchr(buf, ' ');
+	*c = '\0';
+	alias = strdup(buf);
+	if (alias == NULL)
+		condlog(0, "cannot copy new alias from bindings file : %s",
+			strerror(errno));
+	else
+		condlog(3, "Created new binding [%s] for WWID [%s]", alias,
+			wwid);
+	return alias;
+}		
+
+char *
+get_user_friendly_alias(char *wwid)
+{
+	char *alias;
+	int fd, id;
+
+	if (!wwid || *wwid == '\0') {
+		condlog(3, "Cannot find binding for empty WWID");
+		return NULL;
+	}
+
+	fd = open_bindings_file(BINDINGS_FILE_NAME);
+	if (fd < 0)
+		return NULL;
+	id = lookup_binding(fd, wwid, &alias);
+	if (id < 0) {
+		close(fd);
+		return NULL;
+	}
+	if (!alias)
+		alias = allocate_binding(fd, wwid, id);
+
+	close(fd);
+	return alias;
+}
diff -urpN mp-devel-clean/libmultipath/alias.h mp-devel-patched/libmultipath/alias.h
--- mp-devel-clean/libmultipath/alias.h	1969-12-31 18:00:00.000000000 -0600
+++ mp-devel-patched/libmultipath/alias.h	2005-10-21 18:21:42.000000000 -0500
@@ -0,0 +1,13 @@
+#define BINDINGS_FILE_NAME "/var/lib/multipath/bindings"
+#define BINDINGS_FILE_RETRYS 3
+#define BINDINGS_FILE_HEADER \
+"# Multipath bindings, Version : 1.0\n" \
+"# NOTE: this file is automatically maintained by the multipath program.\n" \
+"# You should not need to edit this file in normal circumstances.\n" \
+"#\n" \
+"# Format:\n" \
+"# alias wwid\n" \
+"#\n"
+
+
+char *get_user_friendly_alias(char *wwid);
diff -urpN mp-devel-clean/libmultipath/config.h mp-devel-patched/libmultipath/config.h
--- mp-devel-clean/libmultipath/config.h	2005-10-21 17:55:11.000000000 -0500
+++ mp-devel-patched/libmultipath/config.h	2005-10-21 18:21:42.000000000 -0500
@@ -58,6 +58,7 @@ struct config {
 	int remove;
 	int rr_weight;
 	int no_path_retry;
+	int user_friendly_names;
 
 	char * dev;
 	char * udev_dir;
diff -urpN mp-devel-clean/libmultipath/devmapper.h mp-devel-patched/libmultipath/devmapper.h
--- mp-devel-clean/libmultipath/devmapper.h	2005-10-21 17:55:11.000000000 -0500
+++ mp-devel-patched/libmultipath/devmapper.h	2005-10-21 18:21:42.000000000 -0500
@@ -19,6 +19,7 @@ int dm_geteventnr (char *name);
 int dm_get_minor (char *name);
 char * dm_mapname(int major, int minor);
 int dm_remove_partmaps (char * mapname);
+int dm_get_uuid(char *name, char *uuid);
 
 #if 0
 int dm_rename (char * old, char * new);
diff -urpN mp-devel-clean/libmultipath/dict.c mp-devel-patched/libmultipath/dict.c
--- mp-devel-clean/libmultipath/dict.c	2005-10-21 17:55:11.000000000 -0500
+++ mp-devel-patched/libmultipath/dict.c	2005-10-21 18:21:42.000000000 -0500
@@ -191,6 +191,25 @@ def_no_path_retry_handler(vector strvec)
 	return 0;
 }
 
+static int
+names_handler(vector strvec)
+{
+	char * buff;
+
+	buff = set_value(strvec);
+
+	if (!buff)
+		return 1;
+
+	if (!strncmp(buff, "no", 2) || !strncmp(buff, "0", 1))
+		conf->user_friendly_names = 0;
+	else if (!strncmp(buff, "yes", 2) || !strncmp(buff, "1", 1))
+		conf->user_friendly_names = 1;
+
+	FREE(buff);
+	return 0;
+}
+
 /*
  * blacklist block handlers
  */
@@ -641,6 +660,7 @@ init_keywords(void)
 	install_keyword("rr_min_io", &def_minio_handler);
 	install_keyword("rr_weight", &def_weight_handler);
 	install_keyword("no_path_retry", &def_no_path_retry_handler);
+	install_keyword("user_friendly_names", &names_handler);
 
 	/*
 	 * deprecated synonyms
diff -urpN mp-devel-clean/libmultipath/Makefile mp-devel-patched/libmultipath/Makefile
--- mp-devel-clean/libmultipath/Makefile	2005-10-21 17:55:11.000000000 -0500
+++ mp-devel-patched/libmultipath/Makefile	2005-10-21 18:21:42.000000000 -0500
@@ -10,7 +10,7 @@ OBJS = memory.o parser.o vector.o devmap
        hwtable.o blacklist.o util.o dmparser.o config.o \
        structs.o cache.o discovery.o propsel.o dict.o \
        pgpolicies.o debug.o regex.o defaults.o uevent.o \
-       switchgroup.o uxsock.o print.o
+       switchgroup.o uxsock.o print.o alias.o
 
 CFLAGS = -pipe -g -Wall -Wunused -Wstrict-prototypes
 
diff -urpN mp-devel-clean/libmultipath/propsel.c mp-devel-patched/libmultipath/propsel.c
--- mp-devel-clean/libmultipath/propsel.c	2005-10-21 17:55:11.000000000 -0500
+++ mp-devel-patched/libmultipath/propsel.c	2005-10-21 18:21:42.000000000 -0500
@@ -5,6 +5,7 @@
 #include "config.h"
 #include "debug.h"
 #include "pgpolicies.h"
+#include "alias.h"
 
 #include "../libcheckers/checkers.h"
 
@@ -126,8 +127,13 @@ select_alias (struct multipath * mp)
 {
 	if (mp->mpe && mp->mpe->alias)
 		mp->alias = mp->mpe->alias;
-	else
-		mp->alias = mp->wwid;
+	else {
+		mp->alias = NULL;
+		if (conf->user_friendly_names)
+			mp->alias = get_user_friendly_alias(mp->wwid);
+		if (mp->alias == NULL)
+			mp->alias = mp->wwid;
+	}
 
 	return 0;
 }
diff -urpN mp-devel-clean/libmultipath/uxsock.h mp-devel-patched/libmultipath/uxsock.h
--- mp-devel-clean/libmultipath/uxsock.h	2005-10-21 17:55:11.000000000 -0500
+++ mp-devel-patched/libmultipath/uxsock.h	2005-10-21 18:21:42.000000000 -0500
@@ -3,4 +3,5 @@ int ux_socket_connect(const char *name);
 int ux_socket_listen(const char *name);
 int send_packet(int fd, const char *buf, size_t len);
 int recv_packet(int fd, char **buf, size_t *len);
-
+size_t write_all(int fd, const void *buf, size_t len);
+size_t read_all(int fd, void *buf, size_t len);
diff -urpN mp-devel-clean/multipath/main.c mp-devel-patched/multipath/main.c
--- mp-devel-clean/multipath/main.c	2005-10-21 17:59:04.000000000 -0500
+++ mp-devel-patched/multipath/main.c	2005-10-21 18:21:42.000000000 -0500
@@ -744,10 +744,10 @@ coalesce_paths (vector curmp, vector pat
 
 		mpp->mpe = find_mpe(pp1->wwid);
 		mpp->hwe = pp1->hwe;
+		strcpy(mpp->wwid, pp1->wwid);
 		select_alias(mpp);
 
 		pp1->mpp = mpp;
-		strcpy(mpp->wwid, pp1->wwid);
 		mpp->size = pp1->size;
 		mpp->paths = vector_alloc();
 
diff -urpN mp-devel-clean/multipath.conf.annotated mp-devel-patched/multipath.conf.annotated
--- mp-devel-clean/multipath.conf.annotated	2005-10-21 17:57:58.000000000 -0500
+++ mp-devel-patched/multipath.conf.annotated	2005-10-21 18:21:42.000000000 -0500
@@ -110,6 +110,20 @@
 #	# default : (null)
 #	#
 #	#no_path_retry  queue
+#
+#	#
+#	# name    : user_friendly_names
+#	# scope   : multipath
+#	# desc    : If set to "yes", using the bindings file
+#	#           /var/lib/multipath/bindings to assign a persistent and
+#	#           unique alias to the multipath, in the form of mpath<n>.
+#	#           If set to "no" use the WWID as the alias. In either case
+#	#           this be will be overriden by any specific aliases in this
+#	#           file.
+#	# values  : yes|no
+#	# default : no
+#	user_friendly_names no
+#
 #}
 #	
 ##
diff -urpN mp-devel-clean/multipath.conf.synthetic mp-devel-patched/multipath.conf.synthetic
--- mp-devel-clean/multipath.conf.synthetic	2005-10-21 17:57:58.000000000 -0500
+++ mp-devel-patched/multipath.conf.synthetic	2005-10-21 18:21:42.000000000 -0500
@@ -14,6 +14,7 @@
 #	rr_weight		priorities
 #	failback		immediate
 #	no_path_retry		fail
+#	user_friendly_name	no
 #}
 #devnode_blacklist {
 #       wwid 26353900f02796769
diff -urpN mp-devel-clean/multipathd/main.c mp-devel-patched/multipathd/main.c
--- mp-devel-clean/multipathd/main.c	2005-10-21 17:57:58.000000000 -0500
+++ mp-devel-patched/multipathd/main.c	2005-10-21 18:21:42.000000000 -0500
@@ -213,15 +213,10 @@ update_multipath_strings (struct multipa
 static void
 set_multipath_wwid (struct multipath * mpp)
 {
-	char * wwid;
-
-	wwid = get_mpe_wwid(mpp->alias);
+	if (mpp->wwid)
+		return;
 
-	if (wwid) {
-		strncpy(mpp->wwid, wwid, WWID_SIZE);
-		wwid = NULL;
-	} else
-		strncpy(mpp->wwid, mpp->alias, WWID_SIZE);
+	dm_get_uuid(mpp->alias, mpp->wwid);
 }
 
 static int

--zhXaljGHf11kAtnf
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--zhXaljGHf11kAtnf--

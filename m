From: bmarzins@sourceware.org
Subject: multipath-tools libmultipath/config.c libmulti ...
Date: 27 Oct 2011 21:36:22 -0000
Message-ID: <20111027213622.8092.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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
Changes by:	bmarzins@sourceware.org	2011-10-27 21:36:20

Modified files:
	libmultipath   : config.c config.h dict.c print.c 
	multipathd     : main.c 

Log message:
	fix for bz #703277.  When checking for mounts to keep in the multipathd
	namespace, check if a necessary directory is a symlink, and if so, keep mounts
	at its target, or at any parent directories. Also add a new default option,
	keep_dir, to allow users to manually select directories to keep. Mounts at
	these, or their parent directories will also be kept.  Not applicable upstream.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/config.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.19.2.10&r2=1.19.2.11
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/config.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.15&r2=1.18.2.16
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/dict.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.17.2.21&r2=1.17.2.22
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/print.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.2.3&r2=1.5.2.4
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.69.2.38&r2=1.69.2.39

--- multipath-tools/libmultipath/config.c	2011/04/05 18:41:45	1.19.2.10
+++ multipath-tools/libmultipath/config.c	2011/10/27 21:36:19	1.19.2.11
@@ -394,6 +394,7 @@
 	free_hwtable(conf->hwtable);
 	free_keywords(conf->keywords);
 	free_strvec(conf->binvec);
+	free_strvec(conf->keep_dirs);
 	FREE(conf);
 }
 
@@ -418,6 +419,9 @@
 	conf->attribute_flags = 0;
 	conf->flush_on_last_del = 0;
 	conf->file_timeout = DEFAULT_FILE_TIMEOUT;
+	conf->keep_dirs = vector_alloc();
+	if (!conf->keep_dirs)
+		goto out;
 
 	/*
 	 * read the config file
--- multipath-tools/libmultipath/config.h	2011/04/05 18:41:45	1.18.2.15
+++ multipath-tools/libmultipath/config.h	2011/10/27 21:36:20	1.18.2.16
@@ -103,6 +103,7 @@
 	vector mptable;
 	vector hwtable;
 	vector binvec;
+	vector keep_dirs;
 
 	vector blist_devnode;
 	vector blist_wwid;
--- multipath-tools/libmultipath/dict.c	2011/10/10 04:18:38	1.17.2.21
+++ multipath-tools/libmultipath/dict.c	2011/10/27 21:36:20	1.17.2.22
@@ -524,6 +524,24 @@
 	return 0;
 }
 
+static int
+keep_dir_handler(vector strvec)
+{
+	char * buff;
+
+	buff = set_value(strvec);
+	if (!buff)
+		return 1;
+
+	if (!vector_alloc_slot(conf->keep_dirs)) {
+		free(buff);
+		return 1;
+	}
+	vector_set_slot(conf->keep_dirs, buff);
+
+	return 0;
+}
+
 /*
  * blacklist block handlers
  */
@@ -2117,6 +2135,16 @@
 }
 
 static int
+snprint_keep_dir(char * buff, int len, void * data)
+{
+	char *str = (char *)data;
+
+	if (!str || str[0] == '\0')
+		return 0;
+	return snprintf(buff, len, "\"%s\"", str);
+}
+
+static int
 snprint_ble_simple (char * buff, int len, void * data)
 {
 	struct blentry * ble = (struct blentry *)data;
@@ -2176,6 +2204,7 @@
 	install_keyword("fast_io_fail_tmo", &def_fast_io_fail_handler, &snprint_def_fast_io_fail);
 	install_keyword("dev_loss_tmo", &def_dev_loss_handler, &snprint_def_dev_loss);
 	install_keyword("file_timeout", &file_timeout_handler, &snprint_file_timeout);
+	install_keyword_multi("keep_dir", &keep_dir_handler, &snprint_keep_dir);
 	__deprecated install_keyword("default_selector", &def_selector_handler, NULL);
 	__deprecated install_keyword("default_path_grouping_policy", &def_pgpolicy_handler, NULL);
 	__deprecated install_keyword("default_getuid_callout", &def_getuid_callout_handler, NULL);
--- multipath-tools/libmultipath/print.c	2008/08/22 21:55:43	1.5.2.3
+++ multipath-tools/libmultipath/print.c	2011/10/27 21:36:20	1.5.2.4
@@ -853,6 +853,20 @@
 		return len;
 
 	iterate_sub_keywords(rootkw, kw, i) {
+		if (strcmp(kw->string, "keep_dir") == 0) {
+			char *str;
+			int j;
+			if (!conf->keep_dirs)
+				continue;
+			vector_foreach_slot(conf->keep_dirs, str, j) {
+				fwd += snprint_keyword(buff + fwd, len - fwd,
+						       "\t%k %v\n", kw, str);
+				if (fwd > len)
+					return len;
+			}
+			continue;
+
+		}
 		fwd += snprint_keyword(buff + fwd, len - fwd, "\t%k %v\n",
 				kw, NULL);
 		if (fwd > len)
--- multipath-tools/multipathd/main.c	2011/10/24 13:46:54	1.69.2.38
+++ multipath-tools/multipathd/main.c	2011/10/27 21:36:20	1.69.2.39
@@ -1336,6 +1336,43 @@
 }
 
 static int
+find_keep_dirs(void)
+{
+	int i, j, r;
+	char link_target[PATH_MAX];
+	char *dir;
+	char *needed_dirs[15] = { "/sbin", "/bin", "/tmp", "/usr", "/usr/lib",
+				  "/etc", "/proc", "/sys", "/var", "/var/lib",
+				  "/var/run", "/lib", "/lib64", "/usr/lib64",
+				  "/ram" };
+	for (i = 0; i < 15; i++) {
+		r = readlink(needed_dirs[i], link_target, PATH_MAX - 1);
+		if (r <= 0)
+			continue;
+		link_target[r] = '\0';
+		vector_foreach_slot(conf->keep_dirs, dir, j)
+			if (strcmp(dir, link_target) == 0)
+				goto next;
+		dir = strdup(link_target);
+		if (!dir) {
+			condlog(0, "can't allocate symlink space for %s",
+				needed_dirs[i]);
+			return -1;
+		}
+		if (!vector_alloc_slot(conf->keep_dirs)) {
+			condlog(0, "can't store symlink for %s",
+				needed_dirs[i]);
+			free(dir);
+			return -1;
+		}
+		vector_set_slot(conf->keep_dirs, dir);
+next:
+		;
+	}
+	return 0;
+}
+
+static int
 unmount_extra_devs(void)
 {
 	char buf[LINE_MAX];
@@ -1346,8 +1383,10 @@
 		condlog(0, "couldn't open /proc/mounts : %s", strerror(errno));
 		return -1;
 	}
-
+	find_keep_dirs();
 	while (fgets(buf, LINE_MAX, file)) {
+		int i;
+		char *keep;
 		char *end, *mnt = strchr(buf, ' ');
 		if (!mnt)
 			continue;
@@ -1358,6 +1397,17 @@
 			continue;
 		}
 		*end = '\0';
+		if (conf->keep_dirs) {
+			vector_foreach_slot(conf->keep_dirs, keep, i) {
+				int mnt_len = strlen(mnt);
+				int keep_len = strlen(keep);
+				if (strncmp(mnt, keep, mnt_len) == 0 &&
+				    (mnt_len == keep_len ||
+				     (mnt_len < keep_len &&
+				      keep[mnt_len] == '/')))
+					goto next;
+			}
+		}
 		if (strcmp(mnt, "/") == 0 || strcmp(mnt, "/sbin") == 0 ||
 		    strcmp(mnt, "/bin") == 0 || strcmp(mnt, "/tmp") == 0 ||
 		    strcmp(mnt, "/usr") == 0 || strncmp(mnt, "/usr/lib", 8) == 0 ||
@@ -1368,9 +1418,11 @@
 		    strncmp(mnt, "/lib64", 6) == 0 || strncmp(mnt, "/usr/lib64", 10) == 0 ||
 		    strncmp(mnt, "/ram", 4) == 0)
 			continue;
-		if (umount2(mnt, MNT_DETACH) < 0 && errno != ENOENT) {
-			condlog(0, "failed to umount '%s' (%s). skipping", mnt, strerror(errno));
-		}
+		if (umount2(mnt, MNT_DETACH) < 0 && errno != ENOENT)
+			condlog(0, "failed to umount '%s' (%s). skipping", mnt,
+				strerror(errno));
+next:
+		;
 	}
 	fclose(file);
 	return 0;

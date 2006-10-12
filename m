From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW ./configure ./config ...
Date: 12 Oct 2006 15:42:26 -0000
Message-ID: <20061012154226.9559.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2006-10-12 15:42:25

Modified files:
	.              : WHATS_NEW configure configure.in 
	dmsetup        : dmsetup.c 
	include        : configure.h.in 
	kernel/ioctl   : dm-ioctl.h 
	lib            : .exported_symbols libdevmapper.h 
	lib/ioctl      : libdm-iface.c libdm-targets.h 
	man            : dmsetup.8 

Log message:
	Add suspend noflush support.
	Add basic dmsetup loop support.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.124&r2=1.125
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/configure.diff?cvsroot=dm&r1=1.37&r2=1.38
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/configure.in.diff?cvsroot=dm&r1=1.38&r2=1.39
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/dmsetup.c.diff?cvsroot=dm&r1=1.71&r2=1.72
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/include/configure.h.in.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/kernel/ioctl/dm-ioctl.h.diff?cvsroot=dm&r1=1.43&r2=1.44
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/.exported_symbols.diff?cvsroot=dm&r1=1.22&r2=1.23
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdevmapper.h.diff?cvsroot=dm&r1=1.58&r2=1.59
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/ioctl/libdm-iface.c.diff?cvsroot=dm&r1=1.37&r2=1.38
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/ioctl/libdm-targets.h.diff?cvsroot=dm&r1=1.18&r2=1.19
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/man/dmsetup.8.diff?cvsroot=dm&r1=1.14&r2=1.15

--- device-mapper/WHATS_NEW	2006/10/03 21:51:28	1.124
+++ device-mapper/WHATS_NEW	2006/10/12 15:42:24	1.125
@@ -1,5 +1,7 @@
 Version 1.02.11 -  
 =============================
+  Add suspend noflush support.
+  Add basic dmsetup loop support.
 
 Version 1.02.10 - 19 Sep 2006
 =============================
--- device-mapper/configure	2006/05/10 19:38:25	1.37
+++ device-mapper/configure	2006/10/12 15:42:24	1.38
@@ -3735,7 +3735,8 @@
 
 
 
-for ac_header in termios.h
+
+for ac_header in termios.h sys/statvfs.h
 do
 as_ac_Header=`echo "ac_cv_header_$ac_header" | $as_tr_sh`
 if eval "test \"\${$as_ac_Header+set}\" = set"; then
@@ -5445,6 +5446,81 @@
 
 
 ################################################################################
+
+echo "$as_me:$LINENO: checking for canonicalize_file_name in -lc" >&5
+echo $ECHO_N "checking for canonicalize_file_name in -lc... $ECHO_C" >&6
+if test "${ac_cv_lib_c_canonicalize_file_name+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  ac_check_lib_save_LIBS=$LIBS
+LIBS="-lc  $LIBS"
+cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+
+/* Override any gcc2 internal prototype to avoid an error.  */
+#ifdef __cplusplus
+extern "C"
+#endif
+/* We use char because int might match the return type of a gcc2
+   builtin and then its argument prototype would still apply.  */
+char canonicalize_file_name ();
+int
+main ()
+{
+canonicalize_file_name ();
+  ;
+  return 0;
+}
+_ACEOF
+rm -f conftest.$ac_objext conftest$ac_exeext
+if { (eval echo "$as_me:$LINENO: \"$ac_link\"") >&5
+  (eval $ac_link) 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } &&
+	 { ac_try='test -z "$ac_c_werror_flag"
+			 || test ! -s conftest.err'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; } &&
+	 { ac_try='test -s conftest$ac_exeext'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; }; then
+  ac_cv_lib_c_canonicalize_file_name=yes
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+ac_cv_lib_c_canonicalize_file_name=no
+fi
+rm -f conftest.err conftest.$ac_objext \
+      conftest$ac_exeext conftest.$ac_ext
+LIBS=$ac_check_lib_save_LIBS
+fi
+echo "$as_me:$LINENO: result: $ac_cv_lib_c_canonicalize_file_name" >&5
+echo "${ECHO_T}$ac_cv_lib_c_canonicalize_file_name" >&6
+if test $ac_cv_lib_c_canonicalize_file_name = yes; then
+
+cat >>confdefs.h <<\_ACEOF
+#define HAVE_CANONICALIZE_FILE_NAME 1
+_ACEOF
+
+fi
+
+
+################################################################################
 echo "$as_me:$LINENO: checking whether to enable selinux support" >&5
 echo $ECHO_N "checking whether to enable selinux support... $ECHO_C" >&6
 # Check whether --enable-selinux or --disable-selinux was given.
--- device-mapper/configure.in	2006/05/10 19:38:25	1.38
+++ device-mapper/configure.in	2006/10/12 15:42:24	1.39
@@ -71,7 +71,7 @@
 
 AC_CHECK_HEADERS(ctype.h dirent.h errno.h fcntl.h getopt.h inttypes.h limits.h stdarg.h stdio.h stdlib.h string.h sys/ioctl.h sys/param.h sys/stat.h sys/types.h unistd.h,,AC_MSG_ERROR(bailing out))
 
-AC_CHECK_HEADERS(termios.h)
+AC_CHECK_HEADERS(termios.h sys/statvfs.h)
 ################################################################################
 dnl -- Checks for typedefs, structures, and compiler characteristics.
 AC_C_CONST
@@ -210,6 +210,11 @@
 AC_CHECK_LIB(c, getline, AC_DEFINE([HAVE_GETLINE], 1, [Define to 1 if getline is available.]))
 
 ################################################################################
+dnl -- canonicalize_file_name included in recent libc
+
+AC_CHECK_LIB(c, canonicalize_file_name, AC_DEFINE([HAVE_CANONICALIZE_FILE_NAME], 1, [Define to 1 if canonicalize_file_name is available.]))
+
+################################################################################
 dnl -- Disable selinux
 AC_MSG_CHECKING(whether to enable selinux support)
 AC_ARG_ENABLE(selinux, [  --disable-selinux       Disable selinux support],
--- device-mapper/dmsetup/dmsetup.c	2006/08/10 20:53:21	1.71
+++ device-mapper/dmsetup/dmsetup.c	2006/10/12 15:42:24	1.72
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.
- * Copyright (C) 2004-2005 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2004-2006 Red Hat, Inc. All rights reserved.
  * Copyright (C) 2005 NEC Corperation
  *
  * This file is part of the device-mapper userspace tools.
@@ -38,6 +38,16 @@
 #include <locale.h>
 #include <langinfo.h>
 
+#include <fcntl.h>
+#include <sys/stat.h>
+
+/* FIXME Unused so far */
+#undef HAVE_SYS_STATVFS_H
+
+#ifdef HAVE_SYS_STATVFS_H
+#  include <sys/statvfs.h>
+#endif
+
 #ifdef HAVE_SYS_IOCTL_H
 #  include <sys/ioctl.h>
 #endif
@@ -78,6 +88,11 @@
 
 #define LINE_SIZE 4096
 #define ARGS_MAX 256
+#define LOOP_TABLE_SIZE (PATH_MAX + 255)
+
+/* FIXME Should be elsewhere */
+#define SECTOR_SHIFT 9L
+#define DEV_PATH "/dev/"
 
 #define err(msg, x...) fprintf(stderr, msg "\n", ##x)
 
@@ -93,6 +108,7 @@
 	MAJOR_ARG,
 	MINOR_ARG,
 	MODE_ARG,
+	NOFLUSH_ARG,
 	NOHEADINGS_ARG,
 	NOLOCKFS_ARG,
 	NOOPENCOUNT_ARG,
@@ -180,7 +196,7 @@
 
 #ifndef HAVE_GETLINE
 	buffer_size = LINE_SIZE;
-	if (!(buffer = malloc(buffer_size))) {
+	if (!(buffer = dm_malloc(buffer_size))) {
 		err("Failed to malloc line buffer.");
 		return 0;
 	}
@@ -195,7 +211,7 @@
 	r = 1;
 
       out:
-	free(buffer);
+	dm_free(buffer);
 	if (file)
 		fclose(fp);
 	return r;
@@ -512,7 +528,7 @@
 	for (i = 0; i < argc; i++)
 		sz += strlen(argv[i]) + 1;
 
-	str = malloc(sz);
+	str = dm_malloc(sz);
 	memset(str, 0, sz);
 
 	for (i = 0; i < argc; i++) {
@@ -524,7 +540,7 @@
 	if (!dm_task_set_message(dmt, str))
 		goto out;
 
-	free(str);
+	dm_free(str);
 
 	if (_switches[NOOPENCOUNT_ARG] && !dm_task_no_open_count(dmt))
 		goto out;
@@ -603,6 +619,9 @@
 	if (event_nr && !dm_task_set_event_nr(dmt, event_nr))
 		goto out;
 
+	if (_switches[NOFLUSH_ARG] && !dm_task_no_flush(dmt))
+		goto out;
+
 	if (_switches[NOOPENCOUNT_ARG] && !dm_task_no_open_count(dmt))
 		goto out;
 
@@ -744,28 +763,28 @@
 		return 0;
 
 	if (!_set_task_device(dmt, name, 0))
-		goto err;
+		goto error;
 
 	if (!dm_task_add_target(dmt, 0, size, "error", ""))
-		goto err;
+		goto error;
 
 	if (_switches[READ_ONLY] && !dm_task_set_ro(dmt))
-		goto err;
+		goto error;
 
 	if (_switches[NOOPENCOUNT_ARG] && !dm_task_no_open_count(dmt))
-		goto err;
+		goto error;
 
 	if (!dm_task_run(dmt))
-		goto err;
+		goto error;
 
 	if (!_simple(DM_DEVICE_RESUME, name, 0, 0)) {
 		_simple(DM_DEVICE_CLEAR, name, 0, 0);
-		goto err;
+		goto error;
 	}
 
 	r = 1;
 
-err:
+error:
 	dm_task_destroy(dmt);
 	return r;
 }
@@ -1518,7 +1537,8 @@
 
 	fprintf(out, "Usage:\n\n");
 	fprintf(out, "dmsetup [--version] [-v|--verbose [-v|--verbose ...]]\n"
-		"        [-r|--readonly] [--noopencount] [--nolockfs]\n\n");
+		"        [-r|--readonly] [--noopencount] [--nolockfs]\n"
+		"        [--noflush]\n\n");
 	for (i = 0; _commands[i].name; i++)
 		fprintf(out, "\t%s %s\n", _commands[i].name, _commands[i].help);
 	fprintf(out, "\n<device> may be device name or -u <uuid> or "
@@ -1529,6 +1549,13 @@
 	return;
 }
 
+static void _losetup_usage(FILE *out)
+{
+	fprintf(out, "Usage:\n\n");
+	fprintf(out, "losetup [-d|-a] [-e encryption] "
+		     "[-o offset] [-f|loop_device] [file]\n\n");
+}
+
 static struct command *_find_command(const char *name)
 {
 	int i;
@@ -1606,11 +1633,225 @@
 	return 1;
 }
 
+/*
+ * Returns the full absolute path, or NULL if the path could
+ * not be resolved.
+ */
+static char *_get_abspath(char *path)
+{
+	char *_path;
+
+#ifdef HAVE_CANONICALIZE_FILE_NAME
+	_path = canonicalize_file_name(path);
+#else
+	/* FIXME Provide alternative */
+#endif
+	return _path;
+}
+
+static char *parse_loop_device_name(char *dev)
+{
+	char *buf;
+	char *device;
+
+	if (!(buf = dm_malloc(PATH_MAX)));
+		return NULL;
+
+	if (dev[0] == '/') {
+		if (!(device = _get_abspath(dev)))
+			goto error;
+
+		if (strncmp(device, DEV_PATH, strlen(DEV_PATH)))
+			goto error;
+
+		strncpy(buf, strrchr(device, '/') + 1, PATH_MAX);
+		dm_free(device);
+
+	} else {
+		/* check for device number */
+		if (!strncmp(dev, "loop", strlen("loop")))
+			strncpy(buf, dev, PATH_MAX);
+		else
+			goto error;
+	}
+
+	return buf;
+
+error:
+	return NULL;
+}
+
+/*
+ *  create a table for a mapped device using the loop target.
+ */
+static int _loop_table(char *table, size_t tlen, char *file, char *dev, off_t off)
+{
+	struct stat fbuf;
+	off_t size, sectors;
+	int fd = -1;
+#ifdef HAVE_SYS_STATVFS_H
+	struct statvfs fsbuf;
+	off_t blksize;
+#endif
+
+	if (!_switches[READ_ONLY])
+		fd = open(file, O_RDWR);
+
+	if (fd < 0) {
+		_switches[READ_ONLY]++;
+		fd = open(file, O_RDONLY);
+	}
+
+	if (fd < 0)
+		goto error;
+
+	if (fstat(fd, &fbuf))
+		goto error;
+
+	size = (fbuf.st_size - off);
+	sectors = size >> SECTOR_SHIFT;
+
+	if (_switches[VERBOSE_ARG])
+		fprintf(stderr, "losetup: set loop size to %llukB (%llu sectors)\n",
+			sectors >> 1, sectors);
+
+#ifdef HAVE_SYS_STATVFS_H
+	if (fstatvfs(fd, &fsbuf))
+		goto error;       
+
+	/* FIXME Fragment size currently unused */
+	blksize = fsbuf.f_frsize;
+#endif
+
+	close(fd);
+
+	if (dm_snprintf(table, tlen, "%llu %llu loop %s %llu\n", 0ULL, 
+			(long long unsigned)sectors, file, off) < 0)
+		return 0;
+
+	if (_switches[VERBOSE_ARG] > 1)
+		fprintf(stderr, "Table: %s\n", table);
+
+	return 1;
+
+error:
+	if (fd > -1)
+		close(fd);
+	return 0;
+}
+
+static int _process_losetup_switches(const char *base, int *argc, char ***argv)
+{
+	static int ind;
+	int c;
+	int encrypt_loop = 0, delete = 0, find = 0, show_all = 0;
+	char *device_name = NULL;
+	char *loop_file = NULL;
+	off_t offset = 0;
+
+#ifdef HAVE_GETOPTLONG
+	static struct option long_options[] = {
+		{0, 0, 0, 0}
+	};
+#endif
+
+	optarg = 0;
+	optind = OPTIND_INIT;
+	while ((ind = -1, c = GETOPTLONG_FN(*argc, *argv, "ade:fo:v",
+					    long_options, NULL)) != -1 ) {
+		if (c == ':' || c == '?')
+			return 0;
+		if (c == 'a')
+			show_all++;
+		if (c == 'd')
+			delete++;
+		if (c == 'e')
+			encrypt_loop++;
+		if (c == 'f')
+			find++;
+		if (c == 'o')
+			offset = atoi(optarg);
+		if (c == 'v')
+			_switches[VERBOSE_ARG]++;
+	}
+
+	*argv += optind ;
+	*argc -= optind ;
+
+	if (encrypt_loop){
+		fprintf(stderr, "%s: Sorry, cryptoloop is not yet implemented "
+				"in this version.\n", base);
+		return 0;
+	}
+
+	if (show_all) {
+		fprintf(stderr, "%s: Sorry, show all is not yet implemented "
+				"in this version.\n", base);
+		return 0;
+	}
+
+	if (find) {
+		fprintf(stderr, "%s: Sorry, find is not yet implemented "
+				"in this version.\n", base);
+		if (!*argc)
+			return 0;
+	}
+
+	if (!*argc) {
+		fprintf(stderr, "%s: Please specify loop_device.\n", base);
+		_losetup_usage(stderr);
+		return 0;
+	}
+
+	if (!(device_name = parse_loop_device_name((*argv)[0]))) {
+		fprintf(stderr, "%s: Could not parse loop_device %s\n",
+			base, (*argv)[0]);
+		_losetup_usage(stderr);
+		return 0;
+	}
+
+	if (delete) {
+		*argc = 2;
+
+		(*argv)[1] = device_name;
+		(*argv)[0] = (char *) "remove";
+
+		return 1;
+	}
+
+	if (*argc != 2) {
+		fprintf(stderr, "%s: Too few arguments\n", base);
+		_losetup_usage(stderr);
+		return 0;
+	}
+
+	/* FIXME move these to make them available to native dmsetup */
+	if (!(loop_file = _get_abspath((*argv)[(find) ? 0 : 1]))) {
+		fprintf(stderr, "%s: Could not parse loop file name %s\n",
+			base, (*argv)[1]);
+		_losetup_usage(stderr);
+		return 0;
+	}
+
+	/* FIXME Missing free */
+	_table = dm_malloc(LOOP_TABLE_SIZE);
+	if (!_loop_table(_table, LOOP_TABLE_SIZE, loop_file, device_name, offset)) {
+		fprintf(stderr, "Could not build device-mapper table for %s\n", (*argv)[0]);
+		return 0;
+	}
+	_switches[TABLE_ARG]++;
+
+	(*argv)[0] = (char *) "create";
+	(*argv)[1] = device_name ;
+
+	return 1;
+}
+
 static int _process_switches(int *argc, char ***argv)
 {
 	char *base, *namebase;
 	static int ind;
-	int c;
+	int c, r;
 
 #ifdef HAVE_GETOPTLONG
 	static struct option long_options[] = {
@@ -1622,6 +1863,7 @@
 		{"major", 1, &ind, MAJOR_ARG},
 		{"minor", 1, &ind, MINOR_ARG},
 		{"mode", 1, &ind, MODE_ARG},
+		{"noflush", 0, &ind, NOFLUSH_ARG},
 		{"noheadings", 0, &ind, NOHEADINGS_ARG},
 		{"nolockfs", 0, &ind, NOLOCKFS_ARG},
 		{"noopencount", 0, &ind, NOOPENCOUNT_ARG},
@@ -1678,6 +1920,12 @@
 		return 1;
 	}
 
+	if(!strcmp(base, "losetup") || !strcmp(base, "dmlosetup")){
+		r = _process_losetup_switches(base, argc, argv);
+		free(namebase);
+		return r;
+	}
+
 	free(namebase);
 
 	optarg = 0;
@@ -1733,6 +1981,8 @@
 			_switches[TARGET_ARG]++;
 			_target = optarg;
 		}
+		if ((ind == NOFLUSH_ARG))
+			_switches[NOFLUSH_ARG]++;
 		if ((ind == NOHEADINGS_ARG))
 			_switches[NOHEADINGS_ARG]++;
 		if ((ind == NOLOCKFS_ARG))
--- device-mapper/include/configure.h.in	2006/05/10 19:38:25	1.1
+++ device-mapper/include/configure.h.in	2006/10/12 15:42:24	1.2
@@ -3,6 +3,9 @@
 /* Define to 1 if the `closedir' function returns void instead of `int'. */
 #undef CLOSEDIR_VOID
 
+/* Define to 1 if canonicalize_file_name is available. */
+#undef HAVE_CANONICALIZE_FILE_NAME
+
 /* Define to 1 if you have the <ctype.h> header file. */
 #undef HAVE_CTYPE_H
 
@@ -113,6 +116,9 @@
 /* Define to 1 if you have the <sys/param.h> header file. */
 #undef HAVE_SYS_PARAM_H
 
+/* Define to 1 if you have the <sys/statvfs.h> header file. */
+#undef HAVE_SYS_STATVFS_H
+
 /* Define to 1 if you have the <sys/stat.h> header file. */
 #undef HAVE_SYS_STAT_H
 
--- device-mapper/kernel/ioctl/dm-ioctl.h	2006/08/21 12:04:49	1.43
+++ device-mapper/kernel/ioctl/dm-ioctl.h	2006/10/12 15:42:24	1.44
@@ -287,9 +287,9 @@
 #define DM_DEV_SET_GEOMETRY	_IOWR(DM_IOCTL, DM_DEV_SET_GEOMETRY_CMD, struct dm_ioctl)
 
 #define DM_VERSION_MAJOR	4
-#define DM_VERSION_MINOR	8
+#define DM_VERSION_MINOR	11
 #define DM_VERSION_PATCHLEVEL	0
-#define DM_VERSION_EXTRA	"-ioctl (2006-06-08)"
+#define DM_VERSION_EXTRA	"-ioctl (2006-10-12)"
 
 /* Status bits */
 #define DM_READONLY_FLAG	(1 << 0) /* In/Out */
@@ -325,4 +325,9 @@
  */
 #define DM_SKIP_LOCKFS_FLAG	(1 << 10) /* In */
 
+/*
+ * Set this to suspend without flushing queued ios.
+ */
+#define DM_NOFLUSH_FLAG		(1 << 11) /* In */
+
 #endif				/* _LINUX_DM_IOCTL_H */
--- device-mapper/lib/.exported_symbols	2006/08/21 12:52:39	1.22
+++ device-mapper/lib/.exported_symbols	2006/10/12 15:42:24	1.23
@@ -28,6 +28,7 @@
 dm_task_set_mode
 dm_task_suppress_identical_reload
 dm_task_add_target
+dm_task_no_flush
 dm_task_no_open_count
 dm_task_skip_lockfs
 dm_task_update_nodes
--- device-mapper/lib/libdevmapper.h	2006/08/21 12:52:39	1.58
+++ device-mapper/lib/libdevmapper.h	2006/10/12 15:42:24	1.59
@@ -151,6 +151,7 @@
 int dm_task_set_geometry(struct dm_task *dmt, const char *cylinders, const char *heads, const char *sectors, const char *start);
 int dm_task_set_message(struct dm_task *dmt, const char *message);
 int dm_task_set_sector(struct dm_task *dmt, uint64_t sector);
+int dm_task_no_flush(struct dm_task *dmt);
 int dm_task_no_open_count(struct dm_task *dmt);
 int dm_task_skip_lockfs(struct dm_task *dmt);
 int dm_task_suppress_identical_reload(struct dm_task *dmt);
--- device-mapper/lib/ioctl/libdm-iface.c	2006/08/08 21:22:31	1.37
+++ device-mapper/lib/ioctl/libdm-iface.c	2006/10/12 15:42:24	1.38
@@ -1026,6 +1026,13 @@
 	return 1;
 }
 
+int dm_task_no_flush(struct dm_task *dmt)
+{
+	dmt->noflush = 1;
+
+	return 1;
+}
+
 int dm_task_no_open_count(struct dm_task *dmt)
 {
 	dmt->no_open_count = 1;
@@ -1270,6 +1277,8 @@
 
 	if (dmt->type == DM_DEVICE_SUSPEND)
 		dmi->flags |= DM_SUSPEND_FLAG;
+	if (dmt->noflush)
+		dmi->flags |= DM_NOFLUSH_FLAG;
 	if (dmt->read_only)
 		dmi->flags |= DM_READONLY_FLAG;
 	if (dmt->skip_lockfs)
--- device-mapper/lib/ioctl/libdm-targets.h	2006/02/20 23:55:58	1.18
+++ device-mapper/lib/ioctl/libdm-targets.h	2006/10/12 15:42:24	1.19
@@ -52,6 +52,7 @@
 	char *message;
 	char *geometry;
 	uint64_t sector;
+	int noflush;
 	int no_open_count;
 	int skip_lockfs;
 	int suppress_identical_reload;
--- device-mapper/man/dmsetup.8	2006/08/10 14:11:03	1.14
+++ device-mapper/man/dmsetup.8	2006/10/12 15:42:25	1.15
@@ -13,7 +13,7 @@
 .I [-f|--force]
 .br
 .B dmsetup suspend
-.I [--nolockfs] device_name
+.I [--nolockfs] [--noflush] device_name
 .br
 .B dmsetup resume
 .I device_name
@@ -213,7 +213,7 @@
 With --target, only information relating to the specified target type
 is displayed.
 .IP \fBsuspend
-.I [--nolockfs]
+.I [--nolockfs] [--noflush]
 .I device_name
 .br
 Suspends a device.  Any I/O that has already been mapped by the device
@@ -221,6 +221,9 @@
 device will be postponed for as long as the device is suspended.
 If there's a filesystem on the device which supports the operation, 
 an attempt will be made to sync it first unless --nolockfs is specified.
+Some targets such as recent (October 2006) versions of multipath may support
+the --noflush option.  This lets outstanding I/O that has not yet reached the
+device to remain unflushed.
 .IP \fBtable
 .I [--target target_type]
 .I [device_name]

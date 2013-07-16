From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 09/30] multipath: Deprecate 'getuid'
	configuration variable
Date: Tue, 16 Jul 2013 09:13:00 +0200
Message-ID: <1373958801-103613-10-git-send-email-hare@suse.de>
References: <1373958801-103613-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1373958801-103613-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Older versions of multipath-tools used the 'getuid_callout'
configuration variable to generate the WWID. So for compatibility
we should be accepting existing configurations, but mark the
variable as 'deprecated'.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/Makefile      |   2 +-
 libmultipath/callout.c     | 216 +++++++++++++++++++++++++++++++++++++++++++++
 libmultipath/callout.h     |   7 ++
 libmultipath/config.c      |  13 +++
 libmultipath/config.h      |   3 +
 libmultipath/dict.c        |  47 ++++++++++
 libmultipath/discovery.c   |  55 ++++++++----
 libmultipath/propsel.c     |  12 +++
 libmultipath/structs.h     |   1 +
 libmultipath/structs_vec.c |   1 +
 multipath.conf.annotated   |  12 ++-
 multipath/multipath.conf.5 |   5 ++
 12 files changed, 354 insertions(+), 20 deletions(-)
 create mode 100644 libmultipath/callout.c
 create mode 100644 libmultipath/callout.h

diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index 22d3844..ae1d8a3 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -9,7 +9,7 @@ DEVLIB = libmultipath.so
 LIBS = $(DEVLIB).$(SONAME)
 LIBDEPS = -lpthread -ldl -ldevmapper -ludev
 
-OBJS = memory.o parser.o vector.o devmapper.o \
+OBJS = memory.o parser.o vector.o devmapper.o callout.o \
        hwtable.o blacklist.o util.o dmparser.o config.o \
        structs.o discovery.o propsel.o dict.o \
        pgpolicies.o debug.o regex.o defaults.o uevent.o \
diff --git a/libmultipath/callout.c b/libmultipath/callout.c
new file mode 100644
index 0000000..c35c7c0
--- /dev/null
+++ b/libmultipath/callout.c
@@ -0,0 +1,216 @@
+/*
+ * Source: copy of the udev package source file
+ *
+ * Copyrights of the source file apply
+ * Copyright (c) 2004 Christophe Varoqui
+ */
+#include <stdio.h>
+#include <sys/stat.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/types.h>
+#include <stdlib.h>
+#include <fcntl.h>
+#include <sys/wait.h>
+#include <errno.h>
+
+#include "checkers.h"
+#include "vector.h"
+#include "structs.h"
+#include "util.h"
+#include "debug.h"
+
+int execute_program(char *path, char *value, int len)
+{
+	int retval;
+	int count;
+	int status;
+	int fds[2], null_fd;
+	pid_t pid;
+	char *pos;
+	char arg[CALLOUT_MAX_SIZE];
+	int argc = sizeof(arg) / 2;
+	char *argv[argc + 1];
+	int i;
+
+	i = 0;
+
+	if (strchr(path, ' ')) {
+		strlcpy(arg, path, sizeof(arg));
+		pos = arg;
+		while (pos != NULL && i < argc) {
+			if (pos[0] == '\'') {
+				/* don't separate if in apostrophes */
+				pos++;
+				argv[i] = strsep(&pos, "\'");
+				while (pos[0] == ' ')
+					pos++;
+			} else {
+				argv[i] = strsep(&pos, " ");
+			}
+			i++;
+		}
+	} else {
+		argv[i++] = path;
+	}
+	argv[i] =  NULL;
+
+	retval = pipe(fds);
+
+	if (retval != 0) {
+		condlog(0, "error creating pipe for callout: %s", strerror(errno));
+		return -1;
+	}
+
+	pid = fork();
+
+	switch(pid) {
+	case 0:
+		/* child */
+		close(STDOUT_FILENO);
+
+		/* dup write side of pipe to STDOUT */
+		if (dup(fds[1]) < 0)
+			return -1;
+
+		/* Ignore writes to stderr */
+		null_fd = open("/dev/null", O_WRONLY);
+		if (null_fd > 0) {
+			close(STDERR_FILENO);
+			retval = dup(null_fd);
+			close(null_fd);
+		}
+
+		retval = execv(argv[0], argv);
+		condlog(0, "error execing %s : %s", argv[0], strerror(errno));
+		exit(-1);
+	case -1:
+		condlog(0, "fork failed: %s", strerror(errno));
+		close(fds[0]);
+		close(fds[1]);
+		return -1;
+	default:
+		/* parent reads from fds[0] */
+		close(fds[1]);
+		retval = 0;
+		i = 0;
+		while (1) {
+			count = read(fds[0], value + i, len - i-1);
+			if (count <= 0)
+				break;
+
+			i += count;
+			if (i >= len-1) {
+				condlog(0, "not enough space for response from %s", argv[0]);
+				retval = -1;
+				break;
+			}
+		}
+
+		if (count < 0) {
+			condlog(0, "no response from %s", argv[0]);
+			retval = -1;
+		}
+
+		if (i > 0 && value[i-1] == '\n')
+			i--;
+		value[i] = '\0';
+
+		wait(&status);
+		close(fds[0]);
+
+		retval = -1;
+		if (WIFEXITED(status)) {
+			status = WEXITSTATUS(status);
+			if (status == 0)
+				retval = 0;
+			else
+				condlog(0, "%s exitted with %d", argv[0], status);
+		}
+		else if (WIFSIGNALED(status))
+			condlog(0, "%s was terminated by signal %d", argv[0], WTERMSIG(status));
+		else
+			condlog(0, "%s terminated abnormally", argv[0]);
+	}
+	return retval;
+}
+
+extern int
+apply_format (char * string, char * cmd, struct path * pp)
+{
+	char * pos;
+	char * dst;
+	char * p;
+	char * q;
+	int len;
+	int myfree;
+
+	if (!string)
+		return 1;
+
+	if (!cmd)
+		return 1;
+
+	dst = cmd;
+	p = dst;
+	pos = strchr(string, '%');
+	myfree = CALLOUT_MAX_SIZE;
+
+	if (!pos) {
+		strcpy(dst, string);
+		return 0;
+	}
+
+	len = (int) (pos - string) + 1;
+	myfree -= len;
+
+	if (myfree < 2)
+		return 1;
+
+	snprintf(p, len, "%s", string);
+	p += len - 1;
+	pos++;
+
+	switch (*pos) {
+	case 'n':
+		len = strlen(pp->dev) + 1;
+		myfree -= len;
+
+		if (myfree < 2)
+			return 1;
+
+		snprintf(p, len, "%s", pp->dev);
+		for (q = p; q < p + len; q++) {
+			if (q && *q == '!')
+				*q = '/';
+		}
+		p += len - 1;
+		break;
+	case 'd':
+		len = strlen(pp->dev_t) + 1;
+		myfree -= len;
+
+		if (myfree < 2)
+			return 1;
+
+		snprintf(p, len, "%s", pp->dev_t);
+		p += len - 1;
+		break;
+	default:
+		break;
+	}
+	pos++;
+
+	if (!*pos)
+		return 0;
+
+	len = strlen(pos) + 1;
+	myfree -= len;
+
+	if (myfree < 2)
+		return 1;
+
+	snprintf(p, len, "%s", pos);
+	condlog(3, "reformated callout = %s", dst);
+	return 0;
+}
diff --git a/libmultipath/callout.h b/libmultipath/callout.h
new file mode 100644
index 0000000..ab648e8
--- /dev/null
+++ b/libmultipath/callout.h
@@ -0,0 +1,7 @@
+#ifndef _CALLOUT_H
+#define _CALLOUT_H
+
+int execute_program(char *, char *, int);
+int apply_format (char *, char *, struct path *);
+
+#endif /* _CALLOUT_H */
diff --git a/libmultipath/config.c b/libmultipath/config.c
index 138e6b4..cc44244 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -167,6 +167,9 @@ free_hwe (struct hwentry * hwe)
 	if (hwe->revision)
 		FREE(hwe->revision);
 
+	if (hwe->getuid)
+		FREE(hwe->getuid);
+
 	if (hwe->uid_attribute)
 		FREE(hwe->uid_attribute);
 
@@ -224,6 +227,9 @@ free_mpe (struct mpentry * mpe)
 	if (mpe->selector)
 		FREE(mpe->selector);
 
+	if (mpe->getuid)
+		FREE(mpe->getuid);
+
 	if (mpe->uid_attribute)
 		FREE(mpe->uid_attribute);
 
@@ -312,6 +318,7 @@ merge_hwe (struct hwentry * dst, struct hwentry * src)
 	merge_str(vendor);
 	merge_str(product);
 	merge_str(revision);
+	merge_str(getuid);
 	merge_str(uid_attribute);
 	merge_str(features);
 	merge_str(hwhandler);
@@ -369,6 +376,9 @@ store_hwe (vector hwtable, struct hwentry * dhwe)
 	if (dhwe->uid_attribute && !(hwe->uid_attribute = set_param_str(dhwe->uid_attribute)))
 		goto out;
 
+	if (dhwe->getuid && !(hwe->getuid = set_param_str(dhwe->getuid)))
+		goto out;
+
 	if (dhwe->features && !(hwe->features = set_param_str(dhwe->features)))
 		goto out;
 
@@ -473,6 +483,9 @@ free_config (struct config * conf)
 	if (conf->uid_attribute)
 		FREE(conf->uid_attribute);
 
+	if (conf->getuid)
+		FREE(conf->getuid);
+
 	if (conf->features)
 		FREE(conf->features);
 
diff --git a/libmultipath/config.h b/libmultipath/config.h
index f1578a8..ca65f88 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -27,6 +27,7 @@ struct hwentry {
 	char * product;
 	char * revision;
 	char * uid_attribute;
+	char * getuid;
 	char * features;
 	char * hwhandler;
 	char * selector;
@@ -54,6 +55,7 @@ struct mpentry {
 	char * wwid;
 	char * alias;
 	char * uid_attribute;
+	char * getuid;
 	char * selector;
 	char * features;
 
@@ -116,6 +118,7 @@ struct config {
 	char * multipath_dir;
 	char * selector;
 	char * uid_attribute;
+	char * getuid;
 	char * features;
 	char * hwhandler;
 	char * bindings_file;
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 757d220..b747fcd 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -161,6 +161,17 @@ def_uid_attribute_handler(vector strvec)
 }
 
 static int
+def_getuid_callout_handler(vector strvec)
+{
+	conf->getuid = set_value(strvec);
+
+	if (!conf->getuid)
+		return 1;
+
+	return 0;
+}
+
+static int
 def_prio_handler(vector strvec)
 {
 	conf->prio_name = set_value(strvec);
@@ -973,6 +984,19 @@ hw_uid_attribute_handler(vector strvec)
 }
 
 static int
+hw_getuid_callout_handler(vector strvec)
+{
+	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);
+
+	hwe->getuid = set_value(strvec);
+
+	if (!hwe->getuid)
+		return 1;
+
+	return 0;
+}
+
+static int
 hw_selector_handler(vector strvec)
 {
 	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);
@@ -2118,6 +2142,17 @@ snprint_hw_uid_attribute (char * buff, int len, void * data)
 }
 
 static int
+snprint_hw_getuid_callout (char * buff, int len, void * data)
+{
+	struct hwentry * hwe = (struct hwentry *)data;
+
+	if (!hwe->getuid)
+		return 0;
+
+	return snprintf(buff, len, "\"%s\"", hwe->getuid);
+}
+
+static int
 snprint_hw_prio (char * buff, int len, void * data)
 {
 	struct hwentry * hwe = (struct hwentry *)data;
@@ -2443,6 +2478,15 @@ snprint_def_uid_attribute (char * buff, int len, void * data)
 }
 
 static int
+snprint_def_getuid_callout (char * buff, int len, void * data)
+{
+	if (!conf->getuid)
+		return 0;
+
+	return snprintf(buff, len, "\"%s\"", conf->getuid);
+}
+
+static int
 snprint_def_prio (char * buff, int len, void * data)
 {
 	if (!conf->prio_name)
@@ -2738,6 +2782,7 @@ init_keywords(void)
 	install_keyword("path_selector", &def_selector_handler, &snprint_def_selector);
 	install_keyword("path_grouping_policy", &def_pgpolicy_handler, &snprint_def_path_grouping_policy);
 	install_keyword("uid_attribute", &def_uid_attribute_handler, &snprint_def_uid_attribute);
+	install_keyword("getuid_callout", &def_getuid_callout_handler, &snprint_def_getuid_callout);
 	install_keyword("prio", &def_prio_handler, &snprint_def_prio);
 	install_keyword("prio_args", &def_prio_args_handler, &snprint_def_prio_args);
 	install_keyword("features", &def_features_handler, &snprint_def_features);
@@ -2769,6 +2814,7 @@ init_keywords(void)
 	__deprecated install_keyword("default_selector", &def_selector_handler, NULL);
 	__deprecated install_keyword("default_path_grouping_policy", &def_pgpolicy_handler, NULL);
 	__deprecated install_keyword("default_uid_attribute", &def_uid_attribute_handler, NULL);
+	__deprecated install_keyword("default_getuid_callout", &def_getuid_callout_handler, NULL);
 	__deprecated install_keyword("default_features", &def_features_handler, NULL);
 	__deprecated install_keyword("default_path_checker", &def_path_checker_handler, NULL);
 
@@ -2809,6 +2855,7 @@ init_keywords(void)
 	install_keyword("product_blacklist", &bl_product_handler, &snprint_hw_bl_product);
 	install_keyword("path_grouping_policy", &hw_pgpolicy_handler, &snprint_hw_path_grouping_policy);
 	install_keyword("uid_attribute", &hw_uid_attribute_handler, &snprint_hw_uid_attribute);
+	install_keyword("getuid_callout", &hw_getuid_callout_handler, &snprint_hw_getuid_callout);
 	install_keyword("path_selector", &hw_selector_handler, &snprint_hw_selector);
 	install_keyword("path_checker", &hw_path_checker_handler, &snprint_hw_path_checker);
 	install_keyword("checker", &hw_path_checker_handler, NULL);
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 6af5083..fcb8e4f 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -20,6 +20,7 @@
 #include "structs.h"
 #include "config.h"
 #include "blacklist.h"
+#include "callout.h"
 #include "debug.h"
 #include "propsel.h"
 #include "sg_include.h"
@@ -974,9 +975,9 @@ static int
 get_uid (struct path * pp)
 {
 	char *c;
-	const char *value;
+	const char *origin;
 
-	if (!pp->uid_attribute)
+	if (!pp->uid_attribute && !pp->getuid)
 		select_getuid(pp);
 
 	if (!pp->udev) {
@@ -985,23 +986,41 @@ get_uid (struct path * pp)
 	}
 
 	memset(pp->wwid, 0, WWID_SIZE);
-	value = udev_device_get_property_value(pp->udev, pp->uid_attribute);
-	if ((!value || strlen(value) == 0) && conf->dry_run == 2)
-		value = getenv(pp->uid_attribute);
-	if (value && strlen(value)) {
-		size_t len = WWID_SIZE;
-
-		if (strlen(value) + 1 > WWID_SIZE) {
-			condlog(0, "%s: wwid overflow", pp->dev);
-		} else {
-			len = strlen(value);
+	if (pp->getuid) {
+		char buff[CALLOUT_MAX_SIZE];
+
+		/* Use 'getuid' callout, deprecated */
+		condlog(1, "%s: using deprecated getuid callout", pp->dev);
+		if (apply_format(pp->getuid, &buff[0], pp)) {
+			condlog(0, "error formatting uid callout command");
+			memset(pp->wwid, 0, WWID_SIZE);
+		} else if (execute_program(buff, pp->wwid, WWID_SIZE)) {
+			condlog(3, "error calling out %s", buff);
+			memset(pp->wwid, 0, WWID_SIZE);
 		}
-		strncpy(pp->wwid, value, len);
+		origin = "callout";
 	} else {
-		condlog(3, "%s: no %s attribute", pp->dev,
-			pp->uid_attribute);
+		const char *value;
+
+		value = udev_device_get_property_value(pp->udev,
+						       pp->uid_attribute);
+		if ((!value || strlen(value) == 0) && conf->dry_run == 2)
+			value = getenv(pp->uid_attribute);
+		if (value && strlen(value)) {
+			size_t len = WWID_SIZE;
+
+			if (strlen(value) + 1 > WWID_SIZE) {
+				condlog(0, "%s: wwid overflow", pp->dev);
+			} else {
+				len = strlen(value);
+			}
+			strncpy(pp->wwid, value, len);
+		} else {
+			condlog(3, "%s: no %s attribute", pp->dev,
+				pp->uid_attribute);
+		}
+		origin = "udev";
 	}
-
 	/* Strip any trailing blanks */
 	c = strchr(pp->wwid, '\0');
 	c--;
@@ -1009,8 +1028,8 @@ get_uid (struct path * pp)
 		*c = '\0';
 		c--;
 	}
-	condlog(3, "%s: uid = %s (udev)", pp->dev,
-		*pp->wwid == '\0' ? "<empty>" : pp->wwid);
+	condlog(3, "%s: uid = %s (%s)", pp->dev,
+		*pp->wwid == '\0' ? "<empty>" : pp->wwid, origin);
 	return 0;
 }
 
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 613dafc..65c2c7f 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -371,12 +371,24 @@ select_getuid (struct path * pp)
 			pp->dev, pp->uid_attribute);
 		return 0;
 	}
+	if (pp->hwe && pp->hwe->getuid) {
+		pp->getuid = pp->hwe->getuid;
+		condlog(3, "%s: getuid = %s (deprecated) (controller setting)",
+			pp->dev, pp->getuid);
+		return 0;
+	}
 	if (conf->uid_attribute) {
 		pp->uid_attribute = conf->uid_attribute;
 		condlog(3, "%s: uid_attribute = %s (config file default)",
 			pp->dev, pp->uid_attribute);
 		return 0;
 	}
+	if (conf->getuid) {
+		pp->getuid = conf->getuid;
+		condlog(3, "%s: getuid = %s (deprecated) (config file default)",
+			pp->dev, pp->getuid);
+		return 0;
+	}
 	pp->uid_attribute = STRDUP(DEFAULT_UID_ATTRIBUTE);
 	condlog(3, "%s: uid_attribute = %s (internal default)",
 		pp->dev, pp->uid_attribute);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index ef3d76f..64de06e 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -173,6 +173,7 @@ struct path {
 	int pgindex;
 	int detect_prio;
 	char * uid_attribute;
+	char * getuid;
 	struct prio prio;
 	char * prio_args;
 	struct checker checker;
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 186cd0e..993d3e0 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -82,6 +82,7 @@ orphan_path (struct path * pp)
 	pp->mpp = NULL;
 	pp->dmstate = PSTATE_UNDEF;
 	pp->uid_attribute = NULL;
+	pp->getuid = NULL;
 	prio_put(&pp->prio);
 	checker_put(&pp->checker);
 	if (pp->fd >= 0)
diff --git a/multipath.conf.annotated b/multipath.conf.annotated
index 09ed632..15ec468 100644
--- a/multipath.conf.annotated
+++ b/multipath.conf.annotated
@@ -59,10 +59,20 @@
 #	path_grouping_policy	multibus
 #
 #	#
+#	# name    : uid_attribute
+#	# scope   : multipath & multipathd
+#	# desc    : the default udev attribute from which the path
+#	# 	    identifier should be generated.
+#	# default : ID_SERIAL
+#	#
+#	uid_attribute	"ID_SERIAL"
+#
+#	#
 #	# name    : getuid_callout
 #	# scope   : multipath & multipathd
 #	# desc    : the default program and args to callout to obtain a unique 
-#	#           path identifier. Absolute path required
+#	#           path identifier. This parameter is deprecated.
+#	#           This parameter is deprecated, superseded by uid_attribute
 #	# default : /lib/udev/scsi_id --whitelisted --device=/dev/%n
 #	#
 #	getuid_callout	"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 70d15f3..ade9885 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -144,6 +144,11 @@ The udev attribute providing a unique path
 identifier. Default value is
 .I ID_SERIAL
 .TP
+.B getuid_callout
+The default program and args to callout to obtain a unique path
+identifier. Should be specified with an absolute path.
+This parameter is deprecated; \fIuid_attribute\fR should be used instead.
+.TP
 .B prio
 The name of the path priority routine. The specified routine
 should return a numeric value specifying the relative priority
-- 
1.7.12.4

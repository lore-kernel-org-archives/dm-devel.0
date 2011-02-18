From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.annotated lib ...
Date: 18 Feb 2011 18:27:02 -0000
Message-ID: <20110218182702.7824.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2011-02-18 18:27:00

Modified files:
	.              : multipath.conf.annotated 
	libmultipath   : config.h configure.c dict.c discovery.c 
	                 discovery.h propsel.c propsel.h structs.h 
	                 util.c util.h 
	multipathd     : copy.c main.c 

Log message:
	Backport dev_loss_tmo and fast_io_fail_tmo multipath.conf options to RHEL5.
	Fix for bz #672575

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.annotated.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.17&r2=1.18.2.18
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/config.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.13&r2=1.18.2.14
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/configure.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.2.2.10&r2=1.2.2.11
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/dict.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.17.2.16&r2=1.17.2.17
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/discovery.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.32.2.17&r2=1.32.2.18
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/discovery.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.14.2.5&r2=1.14.2.6
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/propsel.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.11.2.5&r2=1.11.2.6
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/propsel.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.2.2&r2=1.5.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/structs.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.8&r2=1.18.2.9
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/util.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.2.1&r2=1.5.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/util.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.4.2.1&r2=1.4.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/copy.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.2.3&r2=1.5.2.4
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.69.2.31&r2=1.69.2.32

--- multipath-tools/multipath.conf.annotated	2010/09/03 22:23:22	1.18.2.17
+++ multipath-tools/multipath.conf.annotated	2011/02/18 18:27:00	1.18.2.18
@@ -240,6 +240,26 @@
 #	# default : taken for /sys/block/sd<x>/device/timeout
 #	checker_timeout 60
 #
+#      #
+#      # name    : fast_io_fail_tmo
+#      # scope   : multipath & multipathd
+#      # desc    : The number of seconds the scsi layer will wait after a
+#      #           problem has been detected on a FC remote port before failing
+#      #           IO to devices on that remote port.
+#      # values  : off | n >= 0 (smaller than dev_loss_tmo)
+#      # default : determined by the OS
+#      fast_io_fail_tmo 5
+#
+#      #
+#      # name    : dev_loss_tmo
+#      # scope   : multipath & multipathd
+#      # desc    : The number of seconds the scsi layer will wait after a
+#      #           problem has been detected on a FC remote port before
+#      #           removing it from the system.
+#      # values  : n > 0
+#      # default : determined by the OS
+#      dev_loss_tmo 600
+#
 #}
 #	
 ##
@@ -590,6 +610,24 @@
 #		# default : none
 #		#
 #		product_blacklist	LUN_Z
+#
+#              #
+#              # name    : fast_io_fail_tmo
+#              # scope   : multipath & multipathd
+#              # desc    : The number of seconds the scsi layer will wait after
+#              #           a problem has been detected on a FC remote port
+#              #           before failing IO to devices on that remote port.
+#              # values  : off | n >= 0 (smaller than dev_loss_tmo)
+#              fast_io_fail_tmo 5
+#
+#              #
+#              # name    : dev_loss_tmo
+#              # scope   : multipath & multipathd
+#              # desc    : The number of seconds the scsi layer will wait after
+#              #           a problem has been detected on a FC remote port
+#              #           before removing it from the system.
+#              # values  : n > 0
+#              dev_loss_tmo 600
 #	}
 #	device {
 #		vendor			"COMPAQ  "
--- multipath-tools/libmultipath/config.h	2010/09/08 21:40:29	1.18.2.13
+++ multipath-tools/libmultipath/config.h	2011/02/18 18:27:00	1.18.2.14
@@ -30,6 +30,8 @@
 	int minio;
 	int pg_timeout;
 	int flush_on_last_del;
+	int fast_io_fail;
+	unsigned int dev_loss;
 	struct checker * checker;
 	char * bl_product;
 };
@@ -81,6 +83,8 @@
 	int allow_queueing;
 	int pg_prio_calc;
 	int log_checker_err;
+	int fast_io_fail;
+	unsigned int dev_loss;
 	uid_t uid;
 	gid_t gid;
 	mode_t mode;
--- multipath-tools/libmultipath/configure.c	2011/02/16 19:00:51	1.2.2.10
+++ multipath-tools/libmultipath/configure.c	2011/02/18 18:27:00	1.2.2.11
@@ -35,6 +35,7 @@
 #include "dict.h"
 #include "alias.h"
 #include "devmapper.h"
+#include "util.h"
 
 extern int
 setup_map (struct multipath * mpp)
@@ -62,7 +63,10 @@
 	select_minio(mpp);
 	select_no_path_retry(mpp);
 	select_pg_timeout(mpp);
+	select_fast_io_fail(mpp);
+	select_dev_loss(mpp);
 
+	sysfs_set_scsi_tmo(mpp);
 	/*
 	 * assign paths to path groups -- start with no groups and all paths
 	 * in mpp->paths
@@ -635,7 +639,7 @@
 		return NULL;
 
 	if (dev_type == DEV_DEVNODE) {
-		basename(dev, buff);
+		basenamecpy(dev, buff);
 		pp = find_path_by_dev(pathvec, buff);
 		
 		if (!pp) {
--- multipath-tools/libmultipath/dict.c	2010/09/10 14:25:20	1.17.2.16
+++ multipath-tools/libmultipath/dict.c	2011/02/18 18:27:00	1.17.2.17
@@ -35,6 +35,35 @@
 }
 
 static int
+def_fast_io_fail_handler(vector strvec)
+{
+	char * buff;
+
+	buff = set_value(strvec);
+	if (strlen(buff) == 3 && !strcmp(buff, "off"))
+		conf->fast_io_fail = -1;
+	else if (sscanf(buff, "%d", &conf->fast_io_fail) != 1 ||
+			conf->fast_io_fail < -1)
+		conf->fast_io_fail = 0;
+
+	FREE(buff);
+	return 0;
+}
+
+static int
+def_dev_loss_handler(vector strvec)
+{
+	char * buff;
+
+	buff = set_value(strvec);
+	if (sscanf(buff, "%u", &conf->dev_loss) != 1)
+		conf->dev_loss = 0;
+
+	FREE(buff);
+	return 0;
+}
+
+static int
 verbosity_handler(vector strvec)
 {
 	char * buff;
@@ -694,6 +723,37 @@
 }
 
 static int
+hw_fast_io_fail_handler(vector strvec)
+{
+	char * buff;
+	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);
+
+	buff = set_value(strvec);
+	if (strlen(buff) == 3 && !strcmp(buff, "off"))
+		hwe->fast_io_fail = -1;
+	else if (sscanf(buff, "%d", &hwe->fast_io_fail) != 1 ||
+			hwe->fast_io_fail < -1)
+		hwe->fast_io_fail = 0;
+
+	FREE(buff);
+	return 0;
+}
+
+static int
+hw_dev_loss_handler(vector strvec)
+{
+	char * buff;
+	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);
+
+	buff = set_value(strvec);
+	if (sscanf(buff, "%u", &hwe->dev_loss) != 1)
+		hwe->dev_loss = 0;
+
+	FREE(buff);
+	return 0;
+}
+
+static int
 hw_pgpolicy_handler(vector strvec)
 {
 	char * buff;
@@ -1502,6 +1562,26 @@
 }
 
 static int
+snprint_hw_fast_io_fail(char * buff, int len, void * data)
+{
+	struct hwentry * hwe = (struct hwentry *)data;
+	if (!hwe->fast_io_fail)
+		return 0;
+	if (hwe->fast_io_fail == -1)
+		return snprintf(buff, len, "off");
+	return snprintf(buff, len, "%d", hwe->fast_io_fail);
+}
+
+static int
+snprint_hw_dev_loss(char * buff, int len, void * data)
+{
+	struct hwentry * hwe = (struct hwentry *)data;
+	if (!hwe->dev_loss)
+		return 0;
+	return snprintf(buff, len, "%u", hwe->dev_loss);
+}
+
+static int
 snprint_hw_vendor (char * buff, int len, void * data)
 {
 	struct hwentry * hwe = (struct hwentry *)data;
@@ -1726,6 +1806,24 @@
 }
 
 static int
+snprint_def_fast_io_fail(char * buff, int len, void * data)
+{
+	if (!conf->fast_io_fail)
+		return 0;
+	if (conf->fast_io_fail == -1)
+		return snprintf(buff, len, "off");
+	return snprintf(buff, len, "%d", conf->fast_io_fail);
+}
+
+static int
+snprint_def_dev_loss(char * buff, int len, void * data)
+{
+	if (!conf->dev_loss)
+		return 0;
+	return snprintf(buff, len, "%u", conf->dev_loss);
+}
+
+static int
 snprint_def_verbosity (char * buff, int len, void * data)
 {
 	return snprintf(buff, len, "%i", conf->verbosity);
@@ -2035,6 +2133,8 @@
 	install_keyword("mode", &def_mode_handler, &snprint_def_mode);
 	install_keyword("uid", &def_uid_handler, &snprint_def_uid);
 	install_keyword("gid", &def_gid_handler, &snprint_def_gid);
+	install_keyword("fast_io_fail_tmo", &def_fast_io_fail_handler, &snprint_def_fast_io_fail);
+	install_keyword("dev_loss_tmo", &def_dev_loss_handler, &snprint_def_dev_loss);
 	__deprecated install_keyword("default_selector", &def_selector_handler, NULL);
 	__deprecated install_keyword("default_path_grouping_policy", &def_pgpolicy_handler, NULL);
 	__deprecated install_keyword("default_getuid_callout", &def_getuid_callout_handler, NULL);
@@ -2089,6 +2189,8 @@
 	install_keyword("rr_min_io", &hw_minio_handler, &snprint_hw_rr_min_io);
 	install_keyword("flush_on_last_del", &hw_flush_on_last_del_handler, &snprint_hw_flush_on_last_del);
 	install_keyword("pg_timeout", &hw_pg_timeout_handler, &snprint_hw_pg_timeout);
+	install_keyword("fast_io_fail_tmo", &hw_fast_io_fail_handler, &snprint_hw_fast_io_fail);
+	install_keyword("dev_loss_tmo", &hw_dev_loss_handler, &snprint_hw_dev_loss);
 	install_sublevel_end();
 
 	install_keyword_root("multipaths", &multipaths_handler);
--- multipath-tools/libmultipath/discovery.c	2010/11/30 17:21:19	1.32.2.17
+++ multipath-tools/libmultipath/discovery.c	2011/02/18 18:27:00	1.32.2.18
@@ -11,6 +11,7 @@
 #include <errno.h>
 #include <sysfs/dlist.h>
 #include <sysfs/libsysfs.h>
+#include <libgen.h>
 
 #include <checkers.h>
 
@@ -477,6 +478,123 @@
 }
 
 static int
+find_rport_id(struct path *pp)
+{
+	char attr_path[SYSFS_PATH_SIZE];
+	char link_path[SYSFS_PATH_SIZE];
+	char *dir, *base;
+	int host, channel, rport_id = -1;
+	int len;
+
+	if (safe_sprintf(attr_path,
+			 "%s/class/fc_transport/target%i:%i:%i/device",
+			 sysfs_path, pp->sg_id.host_no, pp->sg_id.channel,
+			 pp->sg_id.scsi_id)) {
+		condlog(0, "attr_path too small for target");
+		return -1;
+	}
+	len = readlink(attr_path, link_path, SYSFS_PATH_SIZE);
+	if (len < 0) {
+		condlog(3, "failed to read link '%s' : %s", attr_path,
+			strerror(errno));
+		return -1;
+	}
+	link_path[(len < SYSFS_PATH_SIZE)? len : len - 1] = '\0';
+	dir = link_path;
+	do {
+		base = basename(dir);
+		dir = dirname(dir);
+
+		if (sscanf(base, "rport-%d:%d-%d", &host,
+		    &channel, &rport_id) == 3)
+			break;
+	} while (strcmp(dir, "/") && strcmp(dir, "."));
+
+	if (rport_id < 0)
+		return -1;
+
+	return rport_id;
+}
+
+
+static int
+sysfs_attr_set_value(const char *devpath, const char *attr_name,
+		     const char *value)
+{
+	char attr_path[SYSFS_PATH_SIZE];
+	struct sysfs_attribute * attr;
+	int ret = -1;
+
+	if (safe_sprintf(attr_path, "%s%s/%s", sysfs_path, devpath,
+			 attr_name)) {
+		condlog(0, "sysfs_path %s%s/%s too large", sysfs_path,
+			devpath, attr_name);
+		return ret;
+	}
+	attr = sysfs_open_attribute(attr_path);
+	if (!attr) {
+		condlog(0, "failed to open %s : %s", attr_path,
+			strerror(errno));
+		return ret;
+	}
+	if (sysfs_write_attribute(attr, value, strlen(value)) < 0) {
+		condlog(0, "failed to write '%s' to %s : %s", value, attr_path,
+			strerror(errno));
+		goto out;
+	}
+	ret = 0;
+out:
+	sysfs_close_attribute(attr);
+	return ret;
+}
+
+int
+sysfs_set_scsi_tmo (struct multipath *mpp)
+{
+	char attr_path[SYSFS_PATH_SIZE];
+	struct path *pp;
+	int i;
+	char value[11];
+	int rport_id;
+
+	if (!mpp->dev_loss && !mpp->fast_io_fail)
+		return 0;
+	vector_foreach_slot(mpp->paths, pp, i) {
+		rport_id = find_rport_id(pp);
+		if (rport_id < 0) {
+			condlog(0, "failed to find rport_id for target%d:%d:%d",
+				pp->sg_id.host_no, pp->sg_id.channel,
+				pp->sg_id.scsi_id);
+			return 1;
+		}
+		if (safe_snprintf(attr_path, SYSFS_PATH_SIZE,
+				  "/class/fc_remote_ports/rport-%d:%d-%d",
+				  pp->sg_id.host_no, pp->sg_id.channel,
+				  rport_id)) {
+			condlog(0, "attr_path '/class/fc_remote_ports/rport-%d:%d-%d' too large", pp->sg_id.host_no, pp->sg_id.channel, rport_id);
+
+			return 1;
+		}
+		if (mpp->fast_io_fail){
+			if (mpp->fast_io_fail == -1)
+				sprintf(value, "off");
+			else
+				snprintf(value, 11, "%u", mpp->fast_io_fail);
+			if (sysfs_attr_set_value(attr_path, "fast_io_fail_tmo",
+						value))
+				return 1;
+		}
+		if (mpp->dev_loss){
+			snprintf(value, 11, "%u", mpp->dev_loss);
+			if (sysfs_attr_set_value(attr_path, "dev_loss_tmo",
+						value))
+				return 1;
+		}
+	}
+	return 0;
+}
+
+static int
 sysfs_get_bus (char * sysfs_path, struct path * pp)
 {
 	struct sysfs_device *sdev;
@@ -590,7 +708,7 @@
 	if (0 > sysfs_get_link(attr_path, attr_buff, sizeof(attr_buff)))
 		return 1;
 	
-	basename(attr_buff, attr_path);
+	basenamecpy(attr_buff, attr_path);
 
 	sscanf(attr_path, "%i:%i:%i:%i",
 			&pp->sg_id.host_no,
@@ -674,7 +792,7 @@
 	if (0 > sysfs_get_link(attr_path, attr_buff, sizeof(attr_buff)))
 		return 1;
 	
-	basename(attr_buff, attr_path);
+	basenamecpy(attr_buff, attr_path);
 	pp->sg_id.lun = 0;
 	sscanf(attr_path, "%i.%i.%x",
 			&pp->sg_id.host_no,
--- multipath-tools/libmultipath/discovery.h	2010/09/03 03:46:12	1.14.2.5
+++ multipath-tools/libmultipath/discovery.h	2011/02/18 18:27:00	1.14.2.6
@@ -33,9 +33,9 @@
 int sysfs_get_state (char * sysfs_path, char * dev, char * buff, int len);
 int sysfs_get_size (char * sysfs_path, char * dev, unsigned long long *);
 int sysfs_get_timeout (char * sysfs_path, char * dev, unsigned int *timeout);
+int sysfs_set_scsi_tmo (struct multipath *mpp);
 int path_discovery (vector pathvec, struct config * conf, int flag);
 
-void basename (char *, char *);
 int do_tur (char *);
 int devt2devname (char *, char *);
 int pathinfo (struct path *, vector hwtable, int mask);
--- multipath-tools/libmultipath/propsel.c	2010/01/27 22:33:29	1.11.2.5
+++ multipath-tools/libmultipath/propsel.c	2011/02/18 18:27:00	1.11.2.6
@@ -479,3 +479,45 @@
 	condlog(3, "pg_timeout = NONE (internal default)");
 	return 0;
 }
+
+extern int
+select_fast_io_fail(struct multipath *mp)
+{
+	if (mp->hwe && mp->hwe->fast_io_fail) {
+		mp->fast_io_fail = mp->hwe->fast_io_fail;
+		if (mp->fast_io_fail == -1)
+			condlog(3, "%s: fast_io_fail_tmo = off (controller default)", mp->alias);
+		else
+			condlog(3, "%s: fast_io_fail_tmo = %d (controller default)", mp->alias, mp->fast_io_fail);
+		return 0;
+	}
+	if (conf->fast_io_fail) {
+		mp->fast_io_fail = conf->fast_io_fail;
+		if (mp->fast_io_fail == -1)
+			condlog(3, "%s: fast_io_fail_tmo = off (config file default)", mp->alias);
+		else
+			condlog(3, "%s: fast_io_fail_tmo = %d (config file default)", mp->alias, mp->fast_io_fail);
+		return 0;
+	}
+	mp->fast_io_fail = 0;
+	return 0;
+}
+
+extern int
+select_dev_loss(struct multipath *mp)
+{
+	if (mp->hwe && mp->hwe->dev_loss) {
+		mp->dev_loss = mp->hwe->dev_loss;
+		condlog(3, "%s: dev_loss_tmo = %u (controller default)",
+				mp->alias, mp->dev_loss);
+		return 0;
+	}
+	if (conf->dev_loss) {
+		mp->dev_loss = conf->dev_loss;
+		condlog(3, "%s: dev_loss_tmo = %u (config file default)",
+				mp->alias, mp->dev_loss);
+		return 0;
+	}
+	mp->dev_loss = 0;
+	return 0;
+}
--- multipath-tools/libmultipath/propsel.h	2008/09/04 20:09:48	1.5.2.2
+++ multipath-tools/libmultipath/propsel.h	2011/02/18 18:27:00	1.5.2.3
@@ -15,3 +15,5 @@
 int select_uid(struct multipath *mp);
 int select_gid(struct multipath *mp);
 int select_flush_on_last_del(struct multipath *mp);
+int select_fast_io_fail(struct multipath *mp);
+int select_dev_loss(struct multipath *mp);
--- multipath-tools/libmultipath/structs.h	2010/09/08 21:40:30	1.18.2.8
+++ multipath-tools/libmultipath/structs.h	2011/02/18 18:27:00	1.18.2.9
@@ -169,6 +169,8 @@
 	int pg_timeout;
 	int attribute_flags;
 	int flush_on_last_del;
+	int fast_io_fail;
+	unsigned int dev_loss;
 	uid_t uid;
 	gid_t gid;
 	mode_t mode;
--- multipath-tools/libmultipath/util.c	2007/06/18 17:37:18	1.5.2.1
+++ multipath-tools/libmultipath/util.c	2011/02/18 18:27:00	1.5.2.2
@@ -39,7 +39,7 @@
 }
 
 void
-basename (char * str1, char * str2)
+basenamecpy (char * str1, char * str2)
 {
 	char *p = str1 + (strlen(str1) - 1);
 
--- multipath-tools/libmultipath/util.h	2007/06/18 17:37:18	1.4.2.1
+++ multipath-tools/libmultipath/util.h	2011/02/18 18:27:00	1.4.2.2
@@ -3,7 +3,7 @@
 
 int strcmp_chomp(char *, char *);
 void strchop(char *);
-void basename (char * src, char * dst);
+void basenamecpy (char * src, char * dst);
 int filepresent (char * run);
 int get_word (char * sentence, char ** word);
 void cciss_basename (char * , char * );
--- multipath-tools/multipathd/Attic/copy.c	2009/08/19 21:52:40	1.5.2.3
+++ multipath-tools/multipathd/Attic/copy.c	2011/02/18 18:27:00	1.5.2.4
@@ -91,7 +91,7 @@
 	char dst[FILESIZE];
 	char filename[FILESIZE];
 	
-	basename(src, filename);
+	basenamecpy(src, filename);
 	if (FILESIZE <= snprintf(dst, FILESIZE, "%s/%s", dstdir, filename)) {
 		condlog(0, "[copy.c] filename buffer overflow : %s ", filename);
 		return -1;
--- multipath-tools/multipathd/main.c	2010/12/07 06:02:23	1.69.2.31
+++ multipath-tools/multipathd/main.c	2011/02/18 18:27:00	1.69.2.32
@@ -695,7 +695,7 @@
 	if (uev_discard(uev->devpath))
 		return 0;
 
-	basename(uev->devpath, devname);
+	basenamecpy(uev->devpath, devname);
 	lock(vecs->lock);
 
 	/*

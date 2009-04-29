From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.annotated lib ...
Date: 29 Apr 2009 04:41:34 -0000
Message-ID: <20090429044134.9576.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2009-04-29 04:41:33

Modified files:
	.              : multipath.conf.annotated 
	libmultipath   : config.c defaults.h dict.c 

Log message:
	Fix for bz #471854
	Port of Hannes Reinecke's verbosity patch from upstream.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.annotated.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.10&r2=1.18.2.11
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/config.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.19.2.7&r2=1.19.2.8
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/defaults.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.7&r2=1.7.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/dict.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.17.2.9&r2=1.17.2.10

--- multipath-tools/multipath.conf.annotated	2009/01/16 22:47:31	1.18.2.10
+++ multipath-tools/multipath.conf.annotated	2009/04/29 04:41:32	1.18.2.11
@@ -16,6 +16,16 @@
 #	udev_dir	/dev
 #
 #	#
+#	# name    : verbosity
+#	# scope   : multipath & multipathd
+#	# desc    : The verbosity level of the command. It can be overridden by
+#	#           the -v command line option.
+#	# values  : 0-6
+#	# default : 2
+#	#
+#	verbosity 3
+#
+#	#
 #	# name    : polling_interval
 #	# scope   : multipathd
 #	# desc    : interval between two path checks in seconds
--- multipath-tools/libmultipath/config.c	2008/09/04 20:09:48	1.19.2.7
+++ multipath-tools/libmultipath/config.c	2009/04/29 04:41:33	1.19.2.8
@@ -407,7 +407,7 @@
 	 * internal defaults
 	 */
 	if (!conf->verbosity)
-		conf->verbosity = 2;
+		conf->verbosity = DEFAULT_VERBOSITY;
 
 	conf->dev_type = DEV_NONE;
 	conf->minio = 1000;
--- multipath-tools/libmultipath/defaults.h	2006/06/06 18:32:43	1.7
+++ multipath-tools/libmultipath/defaults.h	2009/04/29 04:41:33	1.7.2.1
@@ -11,6 +11,7 @@
 #define DEFAULT_NO_PATH_RETRY  NO_PATH_RETRY_UNDEF
 #define DEFAULT_PGTIMEOUT      -PGTIMEOUT_NONE
 #define DEFAULT_USER_FRIENDLY_NAMES    0
+#define DEFAULT_VERBOSITY      2
 
 #define DEFAULT_CHECKINT	5
 #define MAX_CHECKINT(a)		(a << 2)
--- multipath-tools/libmultipath/dict.c	2008/12/02 20:24:24	1.17.2.9
+++ multipath-tools/libmultipath/dict.c	2009/04/29 04:41:33	1.17.2.10
@@ -35,6 +35,17 @@
 }
 
 static int
+verbosity_handler(vector strvec)
+{
+	char * buff;
+
+	buff = VECTOR_SLOT(strvec, 1);
+	conf->verbosity = atoi(buff);
+
+	return 0;
+}
+
+static int
 udev_dir_handler(vector strvec)
 {
 	conf->udev_dir = set_value(strvec);
@@ -1651,6 +1662,14 @@
 }
 
 static int
+snprint_def_verbosity (char * buff, int len, void * data)
+{
+	if (conf->checkint == DEFAULT_VERBOSITY)
+		return 0;
+	return snprintf(buff, len, "%i", conf->verbosity);
+}
+
+static int
 snprint_def_udev_dir (char * buff, int len, void * data)
 {
 	if (!conf->udev_dir)
@@ -1927,6 +1946,8 @@
 init_keywords(void)
 {
 	install_keyword_root("defaults", NULL);
+	install_keyword("verbosity", &verbosity_handler, &snprint_def_verbosity)
+;
 	install_keyword("polling_interval", &polling_interval_handler, &snprint_def_polling_interval);
 	install_keyword("udev_dir", &udev_dir_handler, &snprint_def_udev_dir);
 	install_keyword("selector", &def_selector_handler, &snprint_def_selector);

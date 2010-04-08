From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.annotated lib ...
Date: 8 Apr 2010 19:31:50 -0000
Message-ID: <20100408193150.3525.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2010-04-08 19:31:50

Modified files:
	.              : multipath.conf.annotated 
	libmultipath   : config.h configure.c 
	multipath      : main.c 

Log message:
	Fix for bz #579789. Add a -q option to multipath to disable queueing,
	regardless of the configuration setting.  On boot, if a multipath device with
	no useable paths and queue_if_no_path is created, it can cause a hang if IO
	happens to it before multipathd is started.  Using the -q option during boot
	will cause multipath to fail the IO if no paths are up, until multipathd is
	started.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.annotated.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.15&r2=1.18.2.16
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/config.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.9&r2=1.18.2.10
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/configure.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.2.2.6&r2=1.2.2.7
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.44.2.7&r2=1.44.2.8

--- multipath-tools/multipath.conf.annotated	2010/01/27 22:33:28	1.18.2.15
+++ multipath-tools/multipath.conf.annotated	2010/04/08 19:31:49	1.18.2.16
@@ -84,7 +84,8 @@
 #	# name    : path_checker
 #	# scope   : multipath & multipathd
 #	# desc    : the default method used to determine the paths' state
-#	# values  : directio|tur|hp_sw|rdac|emc_clariion|readsector0|cciss_tur
+#	# values  : directio|tur|hp_sw|rdac|emc_clariion|readsector0|cciss_tur|
+#	#           hp_tur
 #	# default : readsector0
 #	#
 #	#path_checker	readsector0
@@ -484,7 +485,7 @@
 #		# scope   : multipathd
 #		# desc    : path checking alorithm to use to check path state
 #		# values  : directio|tur|hp_sw|rdac|emc_clariion|readsector0|
-#		#           cciss_tur
+#		#           cciss_tur|hp_tur
 #		# default : readsector0
 #		#
 #		path_checker		readsector0
--- multipath-tools/libmultipath/config.h	2010/01/27 16:46:48	1.18.2.9
+++ multipath-tools/libmultipath/config.h	2010/04/08 19:31:49	1.18.2.10
@@ -78,6 +78,7 @@
 	int flush_on_last_del;
 	int queue_without_daemon;
 	int checker_timeout;
+	int override_queueing;
 	uid_t uid;
 	gid_t gid;
 	mode_t mode;
--- multipath-tools/libmultipath/configure.c	2009/12/04 21:19:51	1.2.2.6
+++ multipath-tools/libmultipath/configure.c	2010/04/08 19:31:49	1.2.2.7
@@ -537,7 +537,9 @@
 		if (r == DOMAP_DRY)
 			continue;
 
-		if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF) {
+		if (conf->override_queueing)
+			dm_queue_if_no_path(mpp->alias, 0);
+		else if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF) {
 			if (mpp->no_path_retry == NO_PATH_RETRY_FAIL)
 				dm_queue_if_no_path(mpp->alias, 0);
 			else
--- multipath-tools/multipath/main.c	2009/05/04 18:12:07	1.44.2.7
+++ multipath-tools/multipath/main.c	2010/04/08 19:31:49	1.44.2.8
@@ -1,7 +1,7 @@
 /*
  * Soft:        multipath device mapper target autoconfig
  *
- * Version:     $Id: main.c,v 1.44.2.7 2009/05/04 18:12:07 bmarzins Exp $
+ * Version:     $Id: main.c,v 1.44.2.8 2010/04/08 19:31:49 bmarzins Exp $
  *
  * Author:      Christophe Varoqui
  *
@@ -84,6 +84,7 @@
 		"\t   2\t\t\tdefault verbosity\n" \
 		"\t   3\t\t\tprint debug information\n" \
 		"\t-h\t\tprint this usage text\n" \
+		"\t-q\t\tforce all maps to turn off queue_if_no_path\n"\
 		"\t-b file\t\tbindings file location\n" \
 		"\t-d\t\tdry run, do not create or update devmaps\n" \
 		"\t-l\t\tshow multipath topology (sysfs and DM info)\n" \
@@ -324,7 +325,7 @@
 	if (load_config(DEFAULT_CONFIGFILE))
 		exit(1);
 
-	while ((arg = getopt(argc, argv, ":dhl::FfM:v:p:b:r")) != EOF ) {
+	while ((arg = getopt(argc, argv, ":dhl::FfM:v:p:b:rq")) != EOF ) {
 		switch(arg) {
 		case 1: printf("optarg : %s\n",optarg);
 			break;
@@ -335,6 +336,9 @@
 
 			conf->verbosity = atoi(optarg);
 			break;
+		case 'q':
+			conf->override_queueing = 1;
+			break;
 		case 'b':
 			if (conf->bindings_file)
 				FREE(conf->bindings_file);	

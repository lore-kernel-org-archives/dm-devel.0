From: bmarzins@sourceware.org
Subject: multipath-tools libmultipath/config.h multipat ...
Date: 7 Apr 2010 06:37:50 -0000
Message-ID: <20100407063750.2877.qmail@sourceware.org>
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
Branch: 	RHEL4_FC5
Changes by:	bmarzins@sourceware.org	2010-04-07 06:37:50

Modified files:
	libmultipath   : config.h 
	multipath      : main.c 
	multipathd     : multipathd.init.redhat 

Log message:
	Fix for bz #575244. Add a -q option to multipath to disable queueing,
	regardless of the configuration setting.  On boot, if a multipath device with
	no useable paths and queue_if_no_path is created, it can cause a hang if IO
	happens to it before multipathd is started.  Using the -q option during boot
	will cause multipath to fail the IO if no paths are up, until multipathd is
	started.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/config.h.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.17.2.4&r2=1.17.2.5
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/main.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.41.2.7&r2=1.41.2.8
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/multipathd.init.redhat.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.2.2.2&r2=1.2.2.3

--- multipath-tools/libmultipath/config.h	2008/04/14 22:40:08	1.17.2.4
+++ multipath-tools/libmultipath/config.h	2010/04/07 06:37:49	1.17.2.5
@@ -78,6 +78,7 @@
 	int max_fds;
 	int attribute_flags;
 	int flush_on_last_del;
+	int override_queueing;
 	uid_t uid;
 	gid_t gid;
 	mode_t mode;
--- multipath-tools/multipath/main.c	2008/04/14 22:32:04	1.41.2.7
+++ multipath-tools/multipath/main.c	2010/04/07 06:37:49	1.41.2.8
@@ -1,7 +1,7 @@
 /*
  * Soft:        multipath device mapper target autoconfig
  *
- * Version:     $Id: main.c,v 1.41.2.7 2008/04/14 22:32:04 bmarzins Exp $
+ * Version:     $Id: main.c,v 1.41.2.8 2010/04/07 06:37:49 bmarzins Exp $
  *
  * Author:      Christophe Varoqui
  *
@@ -828,7 +828,9 @@
 
 		if (r || mpp->action == ACT_RELOADFEATURES) {
 			condlog(3, "reloading features");
-			if (r && mpp->no_path_retry != NO_PATH_RETRY_UNDEF) {
+			if (conf->override_queueing)
+				dm_queue_if_no_path(mpp->alias, 0);
+			else if (r && mpp->no_path_retry != NO_PATH_RETRY_UNDEF) {
 				if (mpp->no_path_retry == NO_PATH_RETRY_FAIL)
 					dm_queue_if_no_path(mpp->alias, 0);
 				else
@@ -880,6 +882,7 @@
 		"\t   2\t\t\tdefault verbosity\n" \
 		"\t   3\t\t\tprint debug information\n" \
 		"\t-b file\t\tbindings file location\n" \
+		"\t-q\t\tforce all maps to turn off queue_if_no_path\n"\
 		"\t-d\t\tdry run, do not create or update devmaps\n" \
 		"\t-l\t\tshow multipath topology (sysfs and DM info)\n" \
 		"\t-ll\t\tshow multipath topology (maximum info)\n" \
@@ -1146,6 +1149,9 @@
 		case 'F':
 			conf->remove = FLUSH_ALL;
 			break;
+		case 'q':
+			conf->override_queueing = 1;
+			break;
 		case 'l':
 			conf->list = 1;
 			conf->dry_run = 1;
--- multipath-tools/multipathd/multipathd.init.redhat	2007/07/23 22:15:11	1.2.2.2
+++ multipath-tools/multipathd/multipathd.init.redhat	2010/04/07 06:37:49	1.2.2.3
@@ -33,6 +33,7 @@
 start() {
 	test -x $DAEMON || exit 5
 	echo -n $"Starting $prog daemon: "
+	/sbin/multipath -v0
 	daemon $DAEMON
 	RETVAL=$?
 	[ $RETVAL -eq 0 ] && touch $lockdir/$prog

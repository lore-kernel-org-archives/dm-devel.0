From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: multipath can't be run with -S, so don't try
Date: Tue, 3 May 2005 16:17:03 -0500
Message-ID: <20050503211703.GD5323@phlogiston.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="bp/iNruPH9dso1Pn"
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This is a patch clean up the references to -S in multipath, multipathd, and
the conf files.

-Ben

--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="no_S.patch"

diff -urN multipath-tools-0.4.5-pre2/multipath/main.c multipath-tools-patched/multipath/main.c
--- multipath-tools-0.4.5-pre2/multipath/main.c	2005-04-28 17:01:10.000000000 -0500
+++ multipath-tools-patched/multipath/main.c	2005-05-03 14:54:52.000000000 -0500
@@ -761,7 +761,7 @@
 usage (char * progname)
 {
 	fprintf (stderr, VERSION_STRING);
-	fprintf (stderr, "Usage: %s\t[-v level] [-d] [-l] [-S]\n",
+	fprintf (stderr, "Usage: %s\t[-v level] [-d] [-l]\n",
 		progname);
 	fprintf (stderr,
 		"\t\t\t[-p failover|multibus|group_by_serial|group_by_prio]\n" \
diff -urN multipath-tools-0.4.5-pre2/multipath.conf.annotated multipath-tools-patched/multipath.conf.annotated
--- multipath-tools-0.4.5-pre2/multipath.conf.annotated	2005-04-29 18:19:05.000000000 -0500
+++ multipath-tools-patched/multipath.conf.annotated	2005-05-03 14:54:22.000000000 -0500
@@ -7,9 +7,9 @@
 	# name    : multipath_tool
 	# scope   : multipathd
 	# desc    : the tool in charge of configuring the multipath device maps
-	# default : "/sbin/multipath -v 0 -S"
+	# default : "/sbin/multipath -v 0"
 	#
-	multipath_tool	"/sbin/multipath -v 0 -S"
+	multipath_tool	"/sbin/multipath -v 0"
 
 	#
 	# name    : udev_dir
diff -urN multipath-tools-0.4.5-pre2/multipath.conf.synthetic multipath-tools-patched/multipath.conf.synthetic
--- multipath-tools-0.4.5-pre2/multipath.conf.synthetic	2005-04-28 18:08:30.000000000 -0500
+++ multipath-tools-patched/multipath.conf.synthetic	2005-05-03 14:54:34.000000000 -0500
@@ -1,5 +1,5 @@
 defaults {
-	multipath_tool	"/sbin/multipath -v 0 -S"
+	multipath_tool	"/sbin/multipath -v 0"
 	udev_dir	/dev
 	polling_interval 10
 	default_selector	"round-robin 0"
diff -urN multipath-tools-0.4.5-pre2/multipathd/main.h multipath-tools-patched/multipathd/main.h
--- multipath-tools-0.4.5-pre2/multipathd/main.h	2005-04-07 14:37:22.000000000 -0500
+++ multipath-tools-patched/multipathd/main.h	2005-05-03 14:55:26.000000000 -0500
@@ -3,6 +3,6 @@
 
 #define DAEMON 1
 #define CHECKINT 5
-#define MULTIPATH "/sbin/multipath -v0 -S"
+#define MULTIPATH "/sbin/multipath -v0"
 
 #endif

--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--bp/iNruPH9dso1Pn--

From: bmarzins@sourceware.org
Subject: multipath-tools/multipath main.c multipath.8
Date: 18 Jun 2012 22:22:00 -0000
Message-ID: <20120618222200.3095.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2012-06-18 22:21:59

Modified files:
	multipath      : main.c multipath.8 

Log message:
	Fix for bz747180
	Add missing options to man page and multipath -h output

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.44.2.12&r2=1.44.2.13
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/multipath.8.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.9.2.2&r2=1.9.2.3

--- multipath-tools/multipath/main.c	2012/06/14 21:56:47	1.44.2.12
+++ multipath-tools/multipath/main.c	2012/06/18 22:21:59	1.44.2.13
@@ -1,7 +1,7 @@
 /*
  * Soft:        multipath device mapper target autoconfig
  *
- * Version:     $Id: main.c,v 1.44.2.12 2012/06/14 21:56:47 bmarzins Exp $
+ * Version:     $Id: main.c,v 1.44.2.13 2012/06/18 22:21:59 bmarzins Exp $
  *
  * Author:      Christophe Varoqui
  *
@@ -74,11 +74,11 @@
 usage (char * progname)
 {
 	fprintf (stderr, VERSION_STRING);
-	fprintf (stderr, "Usage: %s\t[-v level] [-d] [-h|-l|-ll|-f|-F|-r|-q]\n",
+	fprintf (stderr,
+		 "Usage: %s\t[-v level] [-b file] [-d] [-h|-l|-ll|-f|-F|-r|-q|-B]\n",
 		progname);
 	fprintf (stderr,
-		"\t\t\t[-p failover|multibus|group_by_serial|group_by_prio]\n" \
-		"\t\t\t[device]\n" \
+		"\t\t\t[-p policy] [device]\n" \
 		"\n" \
 		"\t-v level\tverbosity level\n" \
 		"\t   0\t\t\tno output\n" \
@@ -88,6 +88,7 @@
 		"\t-h\t\tprint this usage text\n" \
 		"\t-q\t\tallow queue_if_no_path when multipathd is nor running\n"\
 		"\t-b file\t\tbindings file location\n" \
+		"\t-B\t\tTreat the bindings file as read-only\n" \
 		"\t-d\t\tdry run, do not create or update devmaps\n" \
 		"\t-l\t\tshow multipath topology (sysfs and DM info)\n" \
 		"\t-ll\t\tshow multipath topology (maximum info)\n" \
--- multipath-tools/multipath/multipath.8	2012/06/14 21:56:47	1.9.2.2
+++ multipath-tools/multipath/multipath.8	2012/06/18 22:21:59	1.9.2.3
@@ -6,7 +6,9 @@
 .RB [\| \-v\ \c
 .IR verbosity \|]
 .RB [\| \-d \|]
-.RB [\| \-h | \-l | \-ll | \-f | \-F | \-B \|]
+.RB [\| \-h | \-l | \-ll | \-f | \-F | \-B | \-r | \-q \|]
+.RB [\| \-b\ \c
+.IR filename \|]
 .RB [\| \-p\ \c
 .BR failover | multibus | group_by_serial | group_by_prio | group_by_node_name \|]
 .RB [\| device \|]
@@ -35,6 +37,12 @@
 .B \-d
 dry run, do not create or update devmaps
 .TP
+.BI \-b " file"
+set the location of the user_friendly_names bindings file.
+.TP
+.B \-q
+allow devices to set queue_if_no_path while multipathd is not running.
+.TP
 .B \-l
 show the current multipath topology from information fetched in sysfs and the device mapper
 .TP

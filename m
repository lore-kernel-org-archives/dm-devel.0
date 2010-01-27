From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.annotated lib ...
Date: 27 Jan 2010 22:33:30 -0000
Message-ID: <20100127223330.7875.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2010-01-27 22:33:29

Modified files:
	.              : multipath.conf.annotated 
	libmultipath   : discovery.c propsel.c 

Log message:
	Make checker_timeout be in seconds.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.annotated.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.14&r2=1.18.2.15
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/discovery.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.32.2.12&r2=1.32.2.13
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/propsel.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.11.2.4&r2=1.11.2.5

--- multipath-tools/multipath.conf.annotated	2009/08/31 18:43:18	1.18.2.14
+++ multipath-tools/multipath.conf.annotated	2010/01/27 22:33:28	1.18.2.15
@@ -219,7 +219,15 @@
 #	# default : determined by the process
 #	gid     0
 #
-
+#	#
+#	# name    : checker_timeout
+#	# scope   : multipath & multipathd
+#	# desc    : The timeout to use for path checkers that issue scsi
+#	#           commands with an explicit timeout, in seconds.
+#	# values  : n > 0
+#	# default : taken for /sys/block/sd<x>/device/timeout
+#	checker_timeout 60
+#
 #}
 #	
 ##
--- multipath-tools/libmultipath/discovery.c	2010/01/27 17:21:48	1.32.2.12
+++ multipath-tools/libmultipath/discovery.c	2010/01/27 22:33:29	1.32.2.13
@@ -262,7 +262,7 @@
 	if (r != 1)
 		return 1;
 
-	*timeout = t;
+	*timeout = t * 1000;
 	return 0;
 out:
 	sysfs_close_attribute(attr);
--- multipath-tools/libmultipath/propsel.c	2010/01/27 16:46:48	1.11.2.4
+++ multipath-tools/libmultipath/propsel.c	2010/01/27 22:33:29	1.11.2.5
@@ -235,16 +235,16 @@
 		pp->dev, checker_name(c));
 out:
 	if (conf->checker_timeout) {
-		c->timeout = conf->checker_timeout;
-		condlog(3, "%s: checker timeout = %u (config file default)",
+		c->timeout = conf->checker_timeout * 1000;
+		condlog(3, "%s: checker timeout = %u ms (config file default)",
 			pp->dev, c->timeout);
 	}
 	else if (sysfs_get_timeout(sysfs_path, pp->dev, &c->timeout) == 0)
-		condlog(3, "%s: checker timeout = %u (sysfs setting)",
+		condlog(3, "%s: checker timeout = %u ms (sysfs setting)",
 			pp->dev, c->timeout);
 	else {
 		c->timeout = DEF_TIMEOUT;
-		condlog(3, "%s: checker timeout = %u (internal default)",
+		condlog(3, "%s: checker timeout = %u ms (internal default)",
 			pp->dev, c->timeout);
 	}
 	return 0;

From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.defaults libm ...
Date: 14 Sep 2010 19:42:38 -0000
Message-ID: <20100914194238.9633.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2010-09-14 19:42:38

Modified files:
	.              : multipath.conf.defaults 
	libmultipath   : hwtable.c 

Log message:
	Fix for bz #580729.  Removed the /bin/true prio callout.  It works the same as
	not having one, and it's not statically compiled, and thus can cause problems on
	RHEL 5.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.4.25&r2=1.5.4.26
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.20.2.31&r2=1.20.2.32

--- multipath-tools/multipath.conf.defaults	2010/09/03 22:23:22	1.5.4.25
+++ multipath-tools/multipath.conf.defaults	2010/09/14 19:42:37	1.5.4.26
@@ -89,7 +89,6 @@
 #		vendor			"HP"
 #		product			"MSA2[02]12fc|MSA2012i"
 #		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
-#		prio_callout		"/bin/true"    
 #		features		"0"
 #		hardware_handler	"0"
 #		path_grouping_policy	multibus 
--- multipath-tools/libmultipath/hwtable.c	2010/09/03 03:46:12	1.20.2.31
+++ multipath-tools/libmultipath/hwtable.c	2010/09/14 19:42:37	1.20.2.32
@@ -127,7 +127,7 @@
 		.vendor        = "HP",
 		.product       = "MSA2[02]12fc|MSA2012i",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = "/bin/true",
+		.getprio       = NULL,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,

From: bmarzins@sourceware.org
Subject: multipath-tools/multipathd multipathd.init.redhat
Date: 30 Apr 2007 18:07:26 -0000
Message-ID: <20070430180726.13250.qmail@sourceware.org>
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
Branch: 	RHEL4_FC5
Changes by:	bmarzins@sourceware.org	2007-04-30 19:07:26

Modified files:
	multipathd     : multipathd.init.redhat 

Log message:
	No multipathd description was being shown in system-config-services because of
	a blank line in /etc/init/mutlipath.d. Removed blank line.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/multipathd.init.redhat.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.2&r2=1.2.2.1

--- multipath-tools/multipathd/multipathd.init.redhat	2005/06/13 17:39:12	1.2
+++ multipath-tools/multipathd/multipathd.init.redhat	2007/04/30 18:07:26	1.2.2.1
@@ -1,5 +1,4 @@
 #!/bin/bash
-
 #
 #	/etc/rc.d/init.d/multipathd
 #

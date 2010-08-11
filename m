From: bmarzins@sourceware.org
Subject: multipath-tools/multipath multipath.conf.5
Date: 11 Aug 2010 23:18:45 -0000
Message-ID: <20100811231845.6945.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2010-08-11 23:18:43

Modified files:
	multipath      : multipath.conf.5 

Log message:
	Fix for bz #599686
	Small manpage clarification.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/multipath.conf.5.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.1.2.3&r2=1.1.2.4

--- multipath-tools/multipath/Attic/multipath.conf.5	2010/02/10 04:11:18	1.1.2.3
+++ multipath-tools/multipath/Attic/multipath.conf.5	2010/08/11 23:18:43	1.1.2.4
@@ -40,7 +40,8 @@
 .TP 17
 .B defaults
 This section defines default values for attributes which are used
-whenever no specific setting is given.
+whenever no values are given in the appropriate device or multipath
+sections.
 .TP
 .B blacklist
 This section defines which devices should be excluded from the

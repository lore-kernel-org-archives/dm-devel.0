From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath discovery.c
Date: 7 Mar 2011 15:45:16 -0000
Message-ID: <20110307154516.11067.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2011-03-07 15:45:15

Modified files:
	libmultipath   : discovery.c 

Log message:
	Increase the length of time we will wait for a file to be created. No applicable
	upstream.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/discovery.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.32.2.18&r2=1.32.2.19

--- multipath-tools/libmultipath/discovery.c	2011/02/18 18:27:00	1.32.2.18
+++ multipath-tools/libmultipath/discovery.c	2011/03/07 15:45:15	1.32.2.19
@@ -181,7 +181,7 @@
  * not multipath(8), ran by udev
  */
 #if DAEMON
-#define WAIT_MAX_SECONDS 60
+#define WAIT_MAX_SECONDS 90
 #define WAIT_LOOP_PER_SECOND 5
 
 static int

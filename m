From: bmarzins@sourceware.org
Subject: multipath-tools/multipathd main.c
Date: 24 Oct 2011 13:46:54 -0000
Message-ID: <20111024134654.2483.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2011-10-24 13:46:54

Modified files:
	multipathd     : main.c 

Log message:
	fix for bz #741664. setup_multipath frees the multipath device if it fails,
	so check the return value, and don't touch the multipath device, it
	setup_multipath() has returned 1.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.69.2.37&r2=1.69.2.38

--- multipath-tools/multipathd/main.c	2011/10/10 04:15:41	1.69.2.37
+++ multipath-tools/multipathd/main.c	2011/10/24 13:46:54	1.69.2.38
@@ -988,7 +988,8 @@
 		return 1;
 	}
 	dm_lib_release();
-	setup_multipath(vecs, mpp);
+	if (setup_multipath(vecs, mpp) != 0)
+		return 1;
 	sync_map_state(mpp);
 
 	return 0;

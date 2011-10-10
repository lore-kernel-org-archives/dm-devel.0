From: bmarzins@sourceware.org
Subject: multipath-tools/multipathd main.c
Date: 10 Oct 2011 03:47:07 -0000
Message-ID: <20111010034707.13284.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2011-10-10 03:47:07

Modified files:
	multipathd     : main.c 

Log message:
	Fix for BZ# 655976. Don't automatically update path groups on devices set to
	manual failback when the prio changes.  This fix is already upstream.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.69.2.35&r2=1.69.2.36

--- multipath-tools/multipathd/main.c	2011/04/11 17:01:08	1.69.2.35
+++ multipath-tools/multipathd/main.c	2011/10/10 03:47:07	1.69.2.36
@@ -1153,8 +1153,7 @@
 			 * path prio refreshing
 			 */
 			condlog(4, "path prio refresh");
-			if (update_prio(pp, new_path_up) &&
-			    pp->mpp->pgpolicyfn == (pgpolicyfn *)group_by_prio)
+			if (update_prio(pp, new_path_up) && pp->mpp->pgpolicyfn == (pgpolicyfn *)group_by_prio && (pp->mpp->pgfailback == -FAILBACK_IMMEDIATE || pp->mpp->pgfailback > 0))
 				update_path_groups(pp->mpp, vecs, !new_path_up);
 			else if (need_switch_pathgroup(pp->mpp, 0)) {
 				if (pp->mpp->pgfailback > 0 &&

From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: [PATCH] multipath-tools: Manual failback fix when
	priority changes
Date: Fri, 27 May 2011 10:30:19 -0400
Message-ID: <47D23AD8469A2B448F33C24BD7A39BD90DBE8600@RTPMVEXC1-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Current code switches the path-group when there is a change in priority. However,
this is not the right thing to do when failback is set to manual. This patch fixes
this problem. Call update_path_groups only if failback is immediate.

Signed-off-by: Babu Moger <babu.moger@netapp.com>

---
--- multipath-tools/multipathd/main.c.orig	2011-05-26 08:06:08.000000000 -0500
+++ multipath-tools/multipathd/main.c	2011-05-26 08:21:39.000000000 -0500
@@ -1189,7 +1189,8 @@ check_path (struct vectors * vecs, struc
 	condlog(4, "path prio refresh");
 
 	if (update_prio(pp, new_path_up) &&
-	    pp->mpp->pgpolicyfn == (pgpolicyfn *)group_by_prio)
+	    (pp->mpp->pgpolicyfn == (pgpolicyfn *)group_by_prio) &&
+	     pp->mpp->pgfailback == -FAILBACK_IMMEDIATE)
 		update_path_groups(pp->mpp, vecs, !new_path_up);
 	else if (need_switch_pathgroup(pp->mpp, 0)) {
 		if (pp->mpp->pgfailback > 0 &&

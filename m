Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E71CEC77B7C
	for <dm-devel@archiver.kernel.org>; Wed, 24 May 2023 23:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684970486;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=8S73b2JkEQuFtYYbBUF+mSX6GYg+mMm5IK+/f7gmPXw=;
	b=TbZ6qoSvkSaYDawCsaOcga8SaCqygxb9uZ3cpOh8+kp3tlrE9dubDSUM8VRtDjTK27Q3/q
	5Xk8LfG1EcCdAN6e1/NPZwt84Xrc4s3W19/C3l+p41WGXbzwRyqta1ARsMSglW+ifxwME6
	hTETwNzpoCILP3o0/zsqSF+awlJIVbc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-359-rdLBq6CgMOSk3uT-F8zgug-1; Wed, 24 May 2023 19:21:25 -0400
X-MC-Unique: rdLBq6CgMOSk3uT-F8zgug-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0BF8F8037AD;
	Wed, 24 May 2023 23:21:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EE7B540C6EC4;
	Wed, 24 May 2023 23:21:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AE99819465A8;
	Wed, 24 May 2023 23:21:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E1D7E19465A0
 for <dm-devel@listman.corp.redhat.com>; Wed, 24 May 2023 23:21:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D2093C50927; Wed, 24 May 2023 23:21:20 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AAE57C50926;
 Wed, 24 May 2023 23:21:20 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 34ONLITh028725;
 Wed, 24 May 2023 18:21:18 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 34ONLIVC028724;
 Wed, 24 May 2023 18:21:18 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 24 May 2023 18:21:11 -0500
Message-Id: <1684970472-28669-5-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1684970472-28669-1-git-send-email-bmarzins@redhat.com>
References: <1684970472-28669-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH 4/5] multipathd: reload map if the path groups
 are out of order
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: device-mapper development <dm-devel@redhat.com>,
 Martin Wilck <Martin.Wilck@suse.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

need_switch_pathgroup() only checks if the currently used pathgroup is
not the highest priority pathgroup. If it isn't, all multipathd does is
instruct the kernel to switch to the correct pathgroup.  However, the
kernel treats the pathgroups as if they were ordered by priority. When
the kernel runs out of paths to use in the currently selected pathgroup,
it will start checking the pathgroups in order until it finds one with
usable paths.

need_switch_pathgroup() should also check if the pathgroups are out of
order, and if so, multipathd should reload the map to reorder them
correctly.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/libmultipath.version |  5 ++++
 libmultipath/switchgroup.c        | 27 ++++++++++++++++++++++
 libmultipath/switchgroup.h        |  1 +
 multipathd/main.c                 | 38 +++++++++++++++++++++----------
 4 files changed, 59 insertions(+), 12 deletions(-)

diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 8f72c452..38074699 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -237,3 +237,8 @@ global:
 local:
 	*;
 };
+
+LIBMULTIPATH_19.1.0 {
+global:
+	path_groups_in_order;
+} LIBMULTIPATH_19.0.0;
diff --git a/libmultipath/switchgroup.c b/libmultipath/switchgroup.c
index b1e1f39b..b1180839 100644
--- a/libmultipath/switchgroup.c
+++ b/libmultipath/switchgroup.c
@@ -7,6 +7,33 @@
 #include "structs.h"
 #include "switchgroup.h"
 
+bool path_groups_in_order(struct multipath *mpp)
+{
+	int i;
+	struct pathgroup *pgp;
+	bool seen_marginal_pg = false;
+	int last_prio = INT_MAX;
+
+	if (VECTOR_SIZE(mpp->pg) < 2)
+		return true;
+
+	vector_foreach_slot(mpp->pg, pgp, i) {
+		/* skip pgs with PRIO_UNDEF, since this is likely temporary */
+		if (!pgp->paths || pgp->priority == PRIO_UNDEF)
+			continue;
+		if (pgp->marginal && !seen_marginal_pg) {
+			last_prio = INT_MAX;
+			continue;
+		}
+		if (seen_marginal_pg && !pgp->marginal)
+			return false;
+		if (pgp->priority > last_prio)
+			return false;
+		last_prio = pgp->priority;
+	}
+	return true;
+}
+
 void path_group_prio_update(struct pathgroup *pgp)
 {
 	int i;
diff --git a/libmultipath/switchgroup.h b/libmultipath/switchgroup.h
index 9365e2e2..43dbb6c9 100644
--- a/libmultipath/switchgroup.h
+++ b/libmultipath/switchgroup.h
@@ -1,2 +1,3 @@
 void path_group_prio_update (struct pathgroup * pgp);
 int select_path_group (struct multipath * mpp);
+bool path_groups_in_order(struct multipath *mpp);
diff --git a/multipathd/main.c b/multipathd/main.c
index e7c272ad..2ea7c76b 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -396,7 +396,7 @@ void put_multipath_config(__attribute__((unused)) void *arg)
 }
 
 static int
-need_switch_pathgroup (struct multipath * mpp, int refresh)
+need_switch_pathgroup (struct multipath * mpp, int refresh, bool *need_reload)
 {
 	struct pathgroup * pgp;
 	struct path * pp;
@@ -404,6 +404,7 @@ need_switch_pathgroup (struct multipath * mpp, int refresh)
 	struct config *conf;
 	int bestpg;
 
+	*need_reload = false;
 	if (!mpp)
 		return 0;
 
@@ -430,10 +431,9 @@ need_switch_pathgroup (struct multipath * mpp, int refresh)
 		return 0;
 
 	mpp->bestpg = bestpg;
-	if (mpp->bestpg != mpp->nextpg)
-		return 1;
+	*need_reload = !path_groups_in_order(mpp);
 
-	return 0;
+	return (*need_reload || mpp->bestpg != mpp->nextpg);
 }
 
 static void
@@ -1982,20 +1982,26 @@ ghost_delay_tick(struct vectors *vecs)
 }
 
 static void
-deferred_failback_tick (vector mpvec)
+deferred_failback_tick (struct vectors *vecs)
 {
 	struct multipath * mpp;
 	unsigned int i;
+	bool need_reload;
 
-	vector_foreach_slot (mpvec, mpp, i) {
+	vector_foreach_slot (vecs->mpvec, mpp, i) {
 		/*
 		 * deferred failback getting sooner
 		 */
 		if (mpp->pgfailback > 0 && mpp->failback_tick > 0) {
 			mpp->failback_tick--;
 
-			if (!mpp->failback_tick && need_switch_pathgroup(mpp, 1))
-				switch_pathgroup(mpp);
+			if (!mpp->failback_tick &&
+			    need_switch_pathgroup(mpp, 1, &need_reload)) {
+				if (need_reload)
+					reload_and_sync_map(mpp, vecs, 0);
+				else
+					switch_pathgroup(mpp);
+			}
 		}
 	}
 }
@@ -2579,6 +2585,7 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 		int prio_changed = update_prio(pp, new_path_up);
 		bool need_refresh = (!new_path_up && prio_changed &&
 				     pp->priority != PRIO_UNDEF);
+		bool need_reload;
 
 		if (prio_changed &&
 		    pp->mpp->pgpolicyfn == (pgpolicyfn *)group_by_prio &&
@@ -2586,15 +2593,22 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 			condlog(2, "%s: path priorities changed. reloading",
 				pp->mpp->alias);
 			reload_and_sync_map(pp->mpp, vecs, !new_path_up);
-		} else if (need_switch_pathgroup(pp->mpp, need_refresh)) {
+		} else if (need_switch_pathgroup(pp->mpp, need_refresh,
+			                         &need_reload)) {
 			if (pp->mpp->pgfailback > 0 &&
 			    (new_path_up || pp->mpp->failback_tick <= 0))
 				pp->mpp->failback_tick =
 					pp->mpp->pgfailback + 1;
 			else if (pp->mpp->pgfailback == -FAILBACK_IMMEDIATE ||
 				 (chkr_new_path_up &&
-				  followover_should_failback(pp)))
-				switch_pathgroup(pp->mpp);
+				  followover_should_failback(pp))) {
+				if (need_reload)
+					reload_and_sync_map(pp->mpp, vecs,
+							    !need_refresh &&
+							    !new_path_up);
+				else
+					switch_pathgroup(pp->mpp);
+			}
 		}
 	}
 	return 1;
@@ -2720,7 +2734,7 @@ unlock:
 		pthread_cleanup_push(cleanup_lock, &vecs->lock);
 		lock(&vecs->lock);
 		pthread_testcancel();
-		deferred_failback_tick(vecs->mpvec);
+		deferred_failback_tick(vecs);
 		retry_count_tick(vecs->mpvec);
 		missing_uev_wait_tick(vecs);
 		ghost_delay_tick(vecs);
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


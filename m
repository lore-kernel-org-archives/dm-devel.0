Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D88EC77B7A
	for <dm-devel@archiver.kernel.org>; Wed,  7 Jun 2023 20:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686170895;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=spOCUSQplOWoM4RNJ7bjc8UAZrCJjYGuYLapQ2Ca37I=;
	b=augLuxu1w+vBr01zvPVUy+YUwMq7Uem7GBHhHOyWG4jMDnpo3N8GCo3ouRZHspA+F/2feY
	6tnzp+HQylpS/v9NDkJYUWihFSaNlokCqQm4mEcs2J4IenJXuRoFmzmuv9A+qiPDdw+9Sn
	Mgsz0kVduoTbtMYH5tV3NacxApzLiG8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-502-ErZ8GHxcMHW3DKbdMnq5DQ-1; Wed, 07 Jun 2023 16:48:14 -0400
X-MC-Unique: ErZ8GHxcMHW3DKbdMnq5DQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BE2E81C03361;
	Wed,  7 Jun 2023 20:48:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AEA0F48205E;
	Wed,  7 Jun 2023 20:48:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A181F19452C3;
	Wed,  7 Jun 2023 20:48:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6D19919465BA
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Jun 2023 20:48:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5F5DEC1603B; Wed,  7 Jun 2023 20:48:10 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 40450C16044;
 Wed,  7 Jun 2023 20:48:10 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 357Km7cQ005833;
 Wed, 7 Jun 2023 15:48:07 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 357Km7A0005832;
 Wed, 7 Jun 2023 15:48:07 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed,  7 Jun 2023 15:47:52 -0500
Message-Id: <1686170873-5754-11-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1686170873-5754-1-git-send-email-bmarzins@redhat.com>
References: <1686170873-5754-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH V3 10/11] multipathd: reload map if the path
 groups are out of order
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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
 multipathd/main.c | 70 +++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 58 insertions(+), 12 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index f603d143..584be895 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -395,11 +395,47 @@ void put_multipath_config(__attribute__((unused)) void *arg)
 	rcu_read_unlock();
 }
 
+/*
+ * The path group orderings that this function finds acceptible are different
+ * from now select_path_group determines the best pathgroup. The idea here is
+ * to only trigger a kernel reload when it is obvious that the pathgroups would
+ * be out of order, even if all the paths were usable. Thus pathgroups with
+ * PRIO_UNDEF are skipped, and the number of enabled paths doesn't matter here.
+ */
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
+		if (seen_marginal_pg && !pgp->marginal)
+			return false;
+		/* skip pgs with PRIO_UNDEF, since this is likely temporary */
+		if (!pgp->paths || pgp->priority == PRIO_UNDEF)
+			continue;
+		if (pgp->marginal && !seen_marginal_pg) {
+			seen_marginal_pg = true;
+			last_prio = pgp->priority;
+			continue;
+		}
+		if (pgp->priority > last_prio)
+			return false;
+		last_prio = pgp->priority;
+	}
+	return true;
+}
+
 static int
-need_switch_pathgroup (struct multipath * mpp)
+need_switch_pathgroup (struct multipath * mpp, bool *need_reload)
 {
 	int bestpg;
 
+	*need_reload = false;
 	if (!mpp)
 		return 0;
 
@@ -411,10 +447,9 @@ need_switch_pathgroup (struct multipath * mpp)
 		return 0;
 
 	mpp->bestpg = bestpg;
-	if (mpp->bestpg != mpp->nextpg)
-		return 1;
+	*need_reload = !path_groups_in_order(mpp);
 
-	return 0;
+	return (*need_reload || mpp->bestpg != mpp->nextpg);
 }
 
 static void
@@ -1963,20 +1998,26 @@ ghost_delay_tick(struct vectors *vecs)
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
 
-			if (!mpp->failback_tick && need_switch_pathgroup(mpp))
-				switch_pathgroup(mpp);
+			if (!mpp->failback_tick &&
+			    need_switch_pathgroup(mpp, &need_reload)) {
+				if (need_reload)
+					reload_and_sync_map(mpp, vecs);
+				else
+					switch_pathgroup(mpp);
+			}
 		}
 	}
 }
@@ -2219,6 +2260,7 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 	struct config *conf;
 	int marginal_pathgroups, marginal_changed = 0;
 	int ret;
+	bool need_reload;
 
 	if (((pp->initialized == INIT_OK || pp->initialized == INIT_PARTIAL ||
 	      pp->initialized == INIT_REQUESTED_UDEV) && !pp->mpp) ||
@@ -2548,13 +2590,17 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 		condlog(2, "%s: path priorities changed. reloading",
 			pp->mpp->alias);
 		reload_and_sync_map(pp->mpp, vecs);
-	} else if (need_switch_pathgroup(pp->mpp)) {
+	} else if (need_switch_pathgroup(pp->mpp, &need_reload)) {
 		if (pp->mpp->pgfailback > 0 &&
 		    (new_path_up || pp->mpp->failback_tick <= 0))
 			pp->mpp->failback_tick = pp->mpp->pgfailback + 1;
 		else if (pp->mpp->pgfailback == -FAILBACK_IMMEDIATE ||
-			 (chkr_new_path_up && followover_should_failback(pp)))
-			switch_pathgroup(pp->mpp);
+			 (chkr_new_path_up && followover_should_failback(pp))) {
+			if (need_reload)
+				reload_and_sync_map(pp->mpp, vecs);
+			else
+				switch_pathgroup(pp->mpp);
+		}
 	}
 	return 1;
 }
@@ -2680,7 +2726,7 @@ unlock:
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


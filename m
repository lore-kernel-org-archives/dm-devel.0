Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF661C7EE43
	for <dm-devel@archiver.kernel.org>; Tue,  6 Jun 2023 20:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686082449;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=yVU8Z+Kfba179vpGY8rabznhppqcJnBfizWp3aiECOI=;
	b=Cj/xjq4FOFa9t9aSSfyS/MONCio3jT6eu76hIuGi21zUH/ZrLbWIUkwzGR9kBi54bh4wXl
	9kLn0+F0BihIS21u74aiCDrE7w+nVT3mruVcw5IHMRHKo7Zk/HlPmRjxpeYsg5dRVWZVcC
	Tefo5qBQEh1HcA+r1G1NlGQevFRJPds=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-192-Ky_8_UtXNgKKtCAJ_5gruA-1; Tue, 06 Jun 2023 16:13:43 -0400
X-MC-Unique: Ky_8_UtXNgKKtCAJ_5gruA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1DC47185A78F;
	Tue,  6 Jun 2023 20:13:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 099B7C1603B;
	Tue,  6 Jun 2023 20:13:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C32FB19452D1;
	Tue,  6 Jun 2023 20:13:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4196B19452C3
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Jun 2023 20:13:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2373140CFD48; Tue,  6 Jun 2023 20:13:27 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 01D6C40CFD46;
 Tue,  6 Jun 2023 20:13:26 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 356KDO38029284;
 Tue, 6 Jun 2023 15:13:24 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 356KDOEF029283;
 Tue, 6 Jun 2023 15:13:24 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Tue,  6 Jun 2023 15:13:09 -0500
Message-Id: <1686082391-29210-10-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1686082391-29210-1-git-send-email-bmarzins@redhat.com>
References: <1686082391-29210-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH V2 09/11] multipathd: only refresh priorities in
 update_prio()
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Multipathd previously had various rules to update priorities in
update_prio(), need_switch_pathgroup(), and reload_map(). Instead, only
update the priority in update_prio().  To cover the cases where the
priorities were getting updated in other functions, update_prio() now
always updates all paths' priorities, if the priority on the path that
it was called with changes.

Also, do not try to update a path's priority if it is down. Previously,
when refreshing all the paths' priorities, a path could have its
priority updated when it was in the PATH_DOWN state, as long as its
priority was PRIO_UNDEF. But if a path is down, and the last time
multipath tried to get its priority, it failed, it seems likely that the
prioritizer will just fail again.

Finally, skip updating all paths' priorities in
deferred_failback_tick().  Now that all the paths' priorities will get
updated when one changes before starting the deferred failback count,
it's no longer necessary to update them all again when the failback
timeout expires.  The checker loop will continue to update them
correctly while the timeout is going on.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/cli_handlers.c  |   8 +--
 multipathd/fpin_handlers.c |   4 +-
 multipathd/main.c          | 109 +++++++++++++------------------------
 multipathd/main.h          |   3 +-
 4 files changed, 45 insertions(+), 79 deletions(-)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 44bf43df..c9addfbb 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -810,7 +810,7 @@ cli_reload(void *v, struct strbuf *reply, void *data)
 		return 1;
 	}
 
-	return reload_and_sync_map(mpp, vecs, 0);
+	return reload_and_sync_map(mpp, vecs);
 }
 
 static int resize_map(struct multipath *mpp, unsigned long long size,
@@ -1449,7 +1449,7 @@ static int cli_set_marginal(void * v, struct strbuf *reply, void * data)
 	}
 	pp->marginal = 1;
 
-	return reload_and_sync_map(pp->mpp, vecs, 0);
+	return reload_and_sync_map(pp->mpp, vecs);
 }
 
 static int cli_unset_marginal(void * v, struct strbuf *reply, void * data)
@@ -1476,7 +1476,7 @@ static int cli_unset_marginal(void * v, struct strbuf *reply, void * data)
 	}
 	pp->marginal = 0;
 
-	return reload_and_sync_map(pp->mpp, vecs, 0);
+	return reload_and_sync_map(pp->mpp, vecs);
 }
 
 static int cli_unset_all_marginal(void * v, struct strbuf *reply, void * data)
@@ -1513,7 +1513,7 @@ static int cli_unset_all_marginal(void * v, struct strbuf *reply, void * data)
 		vector_foreach_slot (pgp->paths, pp, j)
 			pp->marginal = 0;
 
-	return reload_and_sync_map(mpp, vecs, 0);
+	return reload_and_sync_map(mpp, vecs);
 }
 
 #define HANDLER(x) x
diff --git a/multipathd/fpin_handlers.c b/multipathd/fpin_handlers.c
index 8f464f04..aa0f63c9 100644
--- a/multipathd/fpin_handlers.c
+++ b/multipathd/fpin_handlers.c
@@ -127,7 +127,7 @@ empty:
 	/* walk backwards because reload_and_sync_map() can remove mpp */
 	vector_foreach_slot_backwards(vecs->mpvec, mpp, i) {
 		if (mpp->fpin_must_reload) {
-			ret = reload_and_sync_map(mpp, vecs, 0);
+			ret = reload_and_sync_map(mpp, vecs);
 			if (ret == 2)
 				condlog(2, "map removed during reload");
 			else
@@ -262,7 +262,7 @@ unref:
 	/* walk backwards because reload_and_sync_map() can remove mpp */
 	vector_foreach_slot_backwards(vecs->mpvec, mpp, i) {
 		if (mpp->fpin_must_reload) {
-			ret = reload_and_sync_map(mpp, vecs, 0);
+			ret = reload_and_sync_map(mpp, vecs);
 			if (ret == 2)
 				condlog(2, "map removed during reload");
 			else
diff --git a/multipathd/main.c b/multipathd/main.c
index bdeffe76..f603d143 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -396,32 +396,13 @@ void put_multipath_config(__attribute__((unused)) void *arg)
 }
 
 static int
-need_switch_pathgroup (struct multipath * mpp, int refresh)
+need_switch_pathgroup (struct multipath * mpp)
 {
-	struct pathgroup * pgp;
-	struct path * pp;
-	unsigned int i, j;
-	struct config *conf;
 	int bestpg;
 
 	if (!mpp)
 		return 0;
 
-	/*
-	 * Refresh path priority values
-	 */
-	if (refresh) {
-		vector_foreach_slot (mpp->pg, pgp, i) {
-			vector_foreach_slot (pgp->paths, pp, j) {
-				conf = get_multipath_config();
-				pthread_cleanup_push(put_multipath_config,
-						     conf);
-				pathinfo(pp, conf, DI_PRIO);
-				pthread_cleanup_pop(1);
-			}
-		}
-	}
-
 	if (!mpp->pg || VECTOR_SIZE(mpp->paths) == 0)
 		return 0;
 
@@ -1594,7 +1575,7 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 			else {
 				if (ro == 1)
 					pp->mpp->force_readonly = 1;
-				retval = reload_and_sync_map(mpp, vecs, 0);
+				retval = reload_and_sync_map(mpp, vecs);
 				if (retval == 2)
 					condlog(2, "%s: map removed during reload", pp->dev);
 				else {
@@ -1994,7 +1975,7 @@ deferred_failback_tick (vector mpvec)
 		if (mpp->pgfailback > 0 && mpp->failback_tick > 0) {
 			mpp->failback_tick--;
 
-			if (!mpp->failback_tick && need_switch_pathgroup(mpp, 1))
+			if (!mpp->failback_tick && need_switch_pathgroup(mpp))
 				switch_pathgroup(mpp);
 		}
 	}
@@ -2051,54 +2032,40 @@ int update_prio(struct path *pp, int refresh_all)
 	int i, j, changed = 0;
 	struct config *conf;
 
-	if (refresh_all) {
-		vector_foreach_slot (pp->mpp->pg, pgp, i) {
-			vector_foreach_slot (pgp->paths, pp1, j) {
-				oldpriority = pp1->priority;
-				conf = get_multipath_config();
-				pthread_cleanup_push(put_multipath_config,
-						     conf);
-				pathinfo(pp1, conf, DI_PRIO);
-				pthread_cleanup_pop(1);
-				if (pp1->priority != oldpriority)
-					changed = 1;
-			}
-		}
-		return changed;
-	}
 	oldpriority = pp->priority;
-	conf = get_multipath_config();
-	pthread_cleanup_push(put_multipath_config, conf);
-	if (pp->state != PATH_DOWN)
+	if (pp->state != PATH_DOWN) {
+		conf = get_multipath_config();
+		pthread_cleanup_push(put_multipath_config, conf);
 		pathinfo(pp, conf, DI_PRIO);
-	pthread_cleanup_pop(1);
+		pthread_cleanup_pop(1);
+	}
 
-	if (pp->priority == oldpriority)
+	if (pp->priority == oldpriority && !refresh_all)
 		return 0;
-	return 1;
+
+	vector_foreach_slot (pp->mpp->pg, pgp, i) {
+		vector_foreach_slot (pgp->paths, pp1, j) {
+			if (pp1 == pp || pp1->state == PATH_DOWN)
+				continue;
+			oldpriority = pp1->priority;
+			conf = get_multipath_config();
+			pthread_cleanup_push(put_multipath_config, conf);
+			pathinfo(pp1, conf, DI_PRIO);
+			pthread_cleanup_pop(1);
+			if (pp1->priority != oldpriority)
+				changed = 1;
+		}
+	}
+	return changed;
 }
 
-static int reload_map(struct vectors *vecs, struct multipath *mpp, int refresh,
+static int reload_map(struct vectors *vecs, struct multipath *mpp,
 		      int is_daemon)
 {
 	char *params __attribute__((cleanup(cleanup_charp))) = NULL;
-	struct path *pp;
-	int i, r;
+	int r;
 
 	update_mpp_paths(mpp, vecs->pathvec);
-	if (refresh) {
-		vector_foreach_slot (mpp->paths, pp, i) {
-			struct config *conf = get_multipath_config();
-			pthread_cleanup_push(put_multipath_config, conf);
-			r = pathinfo(pp, conf, DI_PRIO);
-			pthread_cleanup_pop(1);
-			if (r) {
-				condlog(2, "%s: failed to refresh pathinfo",
-					mpp->alias);
-				return 1;
-			}
-		}
-	}
 	if (setup_map(mpp, &params, vecs)) {
 		condlog(0, "%s: failed to setup map", mpp->alias);
 		return 1;
@@ -2115,10 +2082,9 @@ static int reload_map(struct vectors *vecs, struct multipath *mpp, int refresh,
 	return 0;
 }
 
-int reload_and_sync_map(struct multipath *mpp,
-			struct vectors *vecs, int refresh)
+int reload_and_sync_map(struct multipath *mpp, struct vectors *vecs)
 {
-	if (reload_map(vecs, mpp, refresh, 1))
+	if (reload_map(vecs, mpp, 1))
 		return 1;
 	if (setup_multipath(vecs, mpp) != 0)
 		return 2;
@@ -2573,25 +2539,26 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 	 */
 	condlog(4, "path prio refresh");
 
-	if (marginal_changed)
-		reload_and_sync_map(pp->mpp, vecs, 1);
-	else if (update_prio(pp, new_path_up) &&
-	    (pp->mpp->pgpolicyfn == (pgpolicyfn *)group_by_prio) &&
-	     pp->mpp->pgfailback == -FAILBACK_IMMEDIATE) {
+	if (marginal_changed) {
+		update_prio(pp, 1);
+		reload_and_sync_map(pp->mpp, vecs);
+	} else if (update_prio(pp, new_path_up) &&
+		   pp->mpp->pgpolicyfn == (pgpolicyfn *)group_by_prio &&
+		   pp->mpp->pgfailback == -FAILBACK_IMMEDIATE) {
 		condlog(2, "%s: path priorities changed. reloading",
 			pp->mpp->alias);
-		reload_and_sync_map(pp->mpp, vecs, !new_path_up);
-	} else if (need_switch_pathgroup(pp->mpp, 0)) {
+		reload_and_sync_map(pp->mpp, vecs);
+	} else if (need_switch_pathgroup(pp->mpp)) {
 		if (pp->mpp->pgfailback > 0 &&
 		    (new_path_up || pp->mpp->failback_tick <= 0))
-			pp->mpp->failback_tick =
-				pp->mpp->pgfailback + 1;
+			pp->mpp->failback_tick = pp->mpp->pgfailback + 1;
 		else if (pp->mpp->pgfailback == -FAILBACK_IMMEDIATE ||
 			 (chkr_new_path_up && followover_should_failback(pp)))
 			switch_pathgroup(pp->mpp);
 	}
 	return 1;
 }
+
 enum checker_state {
 	CHECKER_STARTING,
 	CHECKER_RUNNING,
diff --git a/multipathd/main.h b/multipathd/main.h
index e8bee8e6..a253d186 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -47,8 +47,7 @@ int __setup_multipath (struct vectors * vecs, struct multipath * mpp,
 		       int reset);
 #define setup_multipath(vecs, mpp) __setup_multipath(vecs, mpp, 1)
 int update_multipath (struct vectors *vecs, char *mapname, int reset);
-int reload_and_sync_map(struct multipath *mpp, struct vectors *vecs,
-			int refresh);
+int reload_and_sync_map(struct multipath *mpp, struct vectors *vecs);
 
 void handle_path_wwid_change(struct path *pp, struct vectors *vecs);
 bool check_path_wwid_change(struct path *pp);
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


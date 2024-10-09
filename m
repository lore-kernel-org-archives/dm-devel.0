Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7451D69E
	for <dm-devel@lists.linux.dev>; Wed,  9 Oct 2024 01:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728436534; cv=none; b=ZDNAQ/4LhLBrg3W8gCr9zcYV434Geg7a2LEhdcir99N+E2rnOzWN05yxf/gMgHyva2kptrI8jk86Mt/deLFFdtg1tW+6APY2RdbxmrhcXXGmtXh2UfhaNIhgUckqotSrMC1eoA+h0u4SxrrWuStEomr7hIPklRkdgrqw9sEhxaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728436534; c=relaxed/simple;
	bh=e6OzqhsAonj4bA/TeGJUiRtgmpbsZ7PzyPONeAorJIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A2fSRL2e5JAfnWeUXprsS6Rk06bU8dQSgb9/OdbN+kLl0VJbPkEFoqb8GEgRVJw5qaIoVNP3d9oPYo7/vYY9nciHHB4LWXxwqs5O2YA1RgGElWc3Io3kqpeYhsjcXEt2guBv04F4a9+jUNtODvwjbcxbYhPz5GmlmynKIhAsmiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YXeELukt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YXeELukt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728436530;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q0amrwaMhpzwHVsclVNYT1+bKgK5IvtHmiQkFNtvjBE=;
	b=YXeELuktuv9MNHqMEE5tqM7qA499NqZhQ62oBf+a0jP5H9rCCm+Ya6+oxMMehCrE1whvCE
	Q8CXjZc8mdz3kUY8Et75fC2HMX/Kv5YE+EeY3jwMpoPW+hx7r+QJM/g/n9RKuYzOm2XX4X
	eJBFquPysln6yrQ2ypmf+2gOjaFt0sU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-468-XxDCrwLNOnm2llaWwGa0pw-1; Tue,
 08 Oct 2024 21:15:28 -0400
X-MC-Unique: XxDCrwLNOnm2llaWwGa0pw-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CAB3F1955F40;
	Wed,  9 Oct 2024 01:15:27 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8774719560A3;
	Wed,  9 Oct 2024 01:15:27 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4991FQKv2381664
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 8 Oct 2024 21:15:26 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4991FQGL2381663;
	Tue, 8 Oct 2024 21:15:26 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v4 14/22] multipathd: update priority once after updating all paths
Date: Tue,  8 Oct 2024 21:15:15 -0400
Message-ID: <20241009011523.2381575-15-bmarzins@redhat.com>
In-Reply-To: <20241009011523.2381575-1-bmarzins@redhat.com>
References: <20241009011523.2381575-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Instead of updating the path priorities and possibly reloading the
multipath device when each path is updated, wait till all paths
have been updated, and then go through the multipath devices updating
the priorities once, reloading if necessary.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs.h |   9 +++
 multipathd/main.c      | 174 +++++++++++++++++++++++++++--------------
 2 files changed, 123 insertions(+), 60 deletions(-)

diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index af8e31e9..1f531d30 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -318,6 +318,7 @@ enum check_path_states {
 	CHECK_PATH_UNCHECKED,
 	CHECK_PATH_STARTED,
 	CHECK_PATH_CHECKED,
+	CHECK_PATH_NEW_UP,
 	CHECK_PATH_SKIPPED,
 	CHECK_PATH_REMOVED,
 };
@@ -421,6 +422,13 @@ enum prflag_value {
 	PRFLAG_SET,
 };
 
+enum prio_update_type {
+	PRIO_UPDATE_NONE,
+	PRIO_UPDATE_NORMAL,
+	PRIO_UPDATE_NEW_PATH,
+	PRIO_UPDATE_MARGINAL,
+};
+
 struct multipath {
 	char wwid[WWID_SIZE];
 	char alias_old[WWID_SIZE];
@@ -464,6 +472,7 @@ struct multipath {
 	int queue_mode;
 	unsigned int sync_tick;
 	int synced_count;
+	enum prio_update_type prio_update;
 	uid_t uid;
 	gid_t gid;
 	mode_t mode;
diff --git a/multipathd/main.c b/multipathd/main.c
index ca84331d..f48dbe25 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1996,15 +1996,13 @@ mpvec_garbage_collector (struct vectors * vecs)
  * best pathgroup, and this is the first path in the pathgroup to come back
  * up, then switch to this pathgroup */
 static int
-followover_should_failback(struct path * pp)
+do_followover_should_failback(struct path * pp)
 {
 	struct pathgroup * pgp;
 	struct path *pp1;
 	int i;
 
-	if (pp->mpp->pgfailback != -FAILBACK_FOLLOWOVER ||
-	    !pp->mpp->pg || !pp->pgindex ||
-	    pp->pgindex != pp->mpp->bestpg)
+	if (!pp->pgindex || pp->pgindex != pp->mpp->bestpg)
 		return 0;
 
 	pgp = VECTOR_SLOT(pp->mpp->pg, pp->pgindex - 1);
@@ -2017,6 +2015,26 @@ followover_should_failback(struct path * pp)
 	return 1;
 }
 
+static int
+followover_should_failback(struct multipath *mpp)
+{
+	struct path *pp;
+	struct pathgroup * pgp;
+	int i, j;
+
+	if (mpp->pgfailback != -FAILBACK_FOLLOWOVER || !mpp->pg)
+		return 0;
+
+	vector_foreach_slot (mpp->pg, pgp, i) {
+		vector_foreach_slot (pgp->paths, pp, j) {
+			if (pp->is_checked == CHECK_PATH_NEW_UP &&
+			    do_followover_should_failback(pp))
+				return 1;
+		}
+	}
+	return 0;
+}
+
 static void
 missing_uev_wait_tick(struct vectors *vecs)
 {
@@ -2132,41 +2150,58 @@ partial_retrigger_tick(vector pathvec)
 	}
 }
 
-static int update_prio(struct path *pp, int force_refresh_all)
+static bool update_prio(struct multipath *mpp, bool refresh_all)
 {
 	int oldpriority;
-	struct path *pp1;
+	struct path *pp;
 	struct pathgroup * pgp;
-	int i, j, changed = 0;
+	int i, j;
+	bool changed = false;
+	bool skipped_path = false;
 	struct config *conf;
 
-	oldpriority = pp->priority;
-	if (pp->state != PATH_DOWN) {
-		conf = get_multipath_config();
-		pthread_cleanup_push(put_multipath_config, conf);
-		pathinfo(pp, conf, DI_PRIO);
-		pthread_cleanup_pop(1);
+	vector_foreach_slot (mpp->pg, pgp, i) {
+		vector_foreach_slot (pgp->paths, pp, j) {
+			if (pp->state == PATH_DOWN)
+				continue;
+			/*
+			 * refresh_all will be set if the mpp has any path
+			 * for whom pp->marginal switched values or for whom
+			 * pp->is_checked == CHECK_PATH_NEW_UP
+			 */
+			if (!refresh_all &&
+			    pp->is_checked != CHECK_PATH_CHECKED) {
+				skipped_path = true;
+				continue;
+			}
+			oldpriority = pp->priority;
+			conf = get_multipath_config();
+			pthread_cleanup_push(put_multipath_config, conf);
+			pathinfo(pp, conf, DI_PRIO);
+			pthread_cleanup_pop(1);
+			if (pp->priority != oldpriority)
+				changed = true;
+		}
 	}
-
-	if (pp->priority != oldpriority)
-		changed = 1;
-	else if (!force_refresh_all)
-		return 0;
-
-	vector_foreach_slot (pp->mpp->pg, pgp, i) {
-		vector_foreach_slot (pgp->paths, pp1, j) {
-			if (pp1 == pp || pp1->state == PATH_DOWN)
+	if (!changed || !skipped_path)
+		return changed;
+	/*
+	 * If a path changed priorities, refresh the priorities of any
+	 * paths we skipped
+	 */
+	vector_foreach_slot (mpp->pg, pgp, i) {
+		vector_foreach_slot (pgp->paths, pp, j) {
+			if (pp->state == PATH_DOWN)
+				continue;
+			if (pp->is_checked == CHECK_PATH_CHECKED)
 				continue;
-			oldpriority = pp1->priority;
 			conf = get_multipath_config();
 			pthread_cleanup_push(put_multipath_config, conf);
-			pathinfo(pp1, conf, DI_PRIO);
+			pathinfo(pp, conf, DI_PRIO);
 			pthread_cleanup_pop(1);
-			if (pp1->priority != oldpriority)
-				changed = 1;
 		}
 	}
-	return changed;
+	return true;
 }
 
 static int reload_map(struct vectors *vecs, struct multipath *mpp,
@@ -2393,14 +2428,12 @@ static int
 update_path_state (struct vectors * vecs, struct path * pp)
 {
 	int newstate;
-	int new_path_up = 0;
 	int chkr_new_path_up = 0;
 	int disable_reinstate = 0;
 	int oldchkrstate = pp->chkrstate;
 	unsigned int checkint, max_checkint;
 	struct config *conf;
-	int marginal_pathgroups, marginal_changed = 0;
-	bool need_reload;
+	int marginal_pathgroups;
 
 	conf = get_multipath_config();
 	checkint = conf->checkint;
@@ -2462,7 +2495,7 @@ update_path_state (struct vectors * vecs, struct path * pp)
 			}
 			if (!pp->marginal) {
 				pp->marginal = 1;
-				marginal_changed = 1;
+				pp->mpp->prio_update = PRIO_UPDATE_MARGINAL;
 			}
 		} else {
 			if (pp->marginal || pp->state == PATH_DELAYED)
@@ -2470,7 +2503,7 @@ update_path_state (struct vectors * vecs, struct path * pp)
 					pp->dev);
 			if (marginal_pathgroups && pp->marginal) {
 				pp->marginal = 0;
-				marginal_changed = 1;
+				pp->mpp->prio_update = PRIO_UPDATE_MARGINAL;
 			}
 		}
 	}
@@ -2537,7 +2570,8 @@ update_path_state (struct vectors * vecs, struct path * pp)
 		 */
 		if (!disable_reinstate)
 			reinstate_path(pp);
-		new_path_up = 1;
+		if (pp->mpp->prio_update != PRIO_UPDATE_MARGINAL)
+			pp->mpp->prio_update = PRIO_UPDATE_NEW_PATH;
 
 		if (oldchkrstate != PATH_UP && oldchkrstate != PATH_GHOST)
 			chkr_new_path_up = 1;
@@ -2588,38 +2622,48 @@ update_path_state (struct vectors * vecs, struct path * pp)
 				LOG_MSG(2, pp);
 		}
 	}
-
+	if (pp->mpp->prio_update == PRIO_UPDATE_NONE &&
+            (newstate == PATH_UP || newstate == PATH_GHOST))
+		pp->mpp->prio_update = PRIO_UPDATE_NORMAL;
 	pp->state = newstate;
+	return chkr_new_path_up ? CHECK_PATH_NEW_UP : CHECK_PATH_CHECKED;
+}
 
-	if (pp->mpp->wait_for_udev)
-		return CHECK_PATH_CHECKED;
-	/*
-	 * path prio refreshing
-	 */
-	condlog(4, "path prio refresh");
-
-	if (marginal_changed) {
-		update_prio(pp, 1);
-		reload_and_sync_map(pp->mpp, vecs);
-	} else if (update_prio(pp, new_path_up) &&
-		   pp->mpp->pgpolicyfn == (pgpolicyfn *)group_by_prio &&
-		   pp->mpp->pgfailback == -FAILBACK_IMMEDIATE) {
+static int
+update_mpp_prio(struct vectors *vecs, struct multipath *mpp)
+{
+	bool need_reload, changed;
+	enum prio_update_type prio_update = mpp->prio_update;
+	mpp->prio_update = PRIO_UPDATE_NONE;
+
+	if (mpp->wait_for_udev || prio_update == PRIO_UPDATE_NONE)
+		return 0;
+	condlog(4, "prio refresh");
+
+	changed = update_prio(mpp, prio_update != PRIO_UPDATE_NORMAL);
+	if (prio_update == PRIO_UPDATE_MARGINAL)
+		return reload_and_sync_map(mpp, vecs);
+	if (changed && mpp->pgpolicyfn == (pgpolicyfn *)group_by_prio &&
+	    mpp->pgfailback == -FAILBACK_IMMEDIATE) {
 		condlog(2, "%s: path priorities changed. reloading",
-			pp->mpp->alias);
-		reload_and_sync_map(pp->mpp, vecs);
-	} else if (need_switch_pathgroup(pp->mpp, &need_reload)) {
-		if (pp->mpp->pgfailback > 0 &&
-		    (new_path_up || pp->mpp->failback_tick <= 0))
-			pp->mpp->failback_tick = pp->mpp->pgfailback + 1;
-		else if (pp->mpp->pgfailback == -FAILBACK_IMMEDIATE ||
-			 (chkr_new_path_up && followover_should_failback(pp))) {
+			mpp->alias);
+		return reload_and_sync_map(mpp, vecs);
+	}
+	if (need_switch_pathgroup(mpp, &need_reload)) {
+		if (mpp->pgfailback > 0 &&
+		    (prio_update == PRIO_UPDATE_NEW_PATH ||
+		     mpp->failback_tick <= 0))
+			mpp->failback_tick = mpp->pgfailback + 1;
+		else if (mpp->pgfailback == -FAILBACK_IMMEDIATE ||
+			 (prio_update == PRIO_UPDATE_NEW_PATH &&
+			  followover_should_failback(mpp))) {
 			if (need_reload)
-				reload_and_sync_map(pp->mpp, vecs);
+				return reload_and_sync_map(mpp, vecs);
 			else
-				switch_pathgroup(pp->mpp);
+				switch_pathgroup(mpp);
 		}
 	}
-	return CHECK_PATH_CHECKED;
+	return 0;
 }
 
 static int
@@ -2856,7 +2900,7 @@ update_paths(struct vectors *vecs, int *num_paths_p, time_t start_secs)
 			i--;
 		else {
 			pp->is_checked = rc;
-			if (rc == CHECK_PATH_CHECKED)
+			if (rc == CHECK_PATH_CHECKED || rc == CHECK_PATH_NEW_UP)
 				(*num_paths_p)++;
 		}
 		if (++paths_checked % 128 == 0 &&
@@ -2929,8 +2973,10 @@ checkerloop (void *ap)
 			vector_foreach_slot(vecs->mpvec, mpp, i)
 				mpp->synced_count = 0;
 			if (checker_state == CHECKER_STARTING) {
-				vector_foreach_slot(vecs->mpvec, mpp, i)
+				vector_foreach_slot(vecs->mpvec, mpp, i) {
 					sync_mpp(vecs, mpp, ticks);
+					mpp->prio_update = PRIO_UPDATE_NONE;
+				}
 				vector_foreach_slot(vecs->pathvec, pp, i)
 					pp->is_checked = CHECK_PATH_UNCHECKED;
 				checker_state = CHECKER_CHECKING_PATHS;
@@ -2940,6 +2986,14 @@ checkerloop (void *ap)
 			if (checker_state == CHECKER_UPDATING_PATHS)
 				checker_state = update_paths(vecs, &num_paths,
 							     start_time.tv_sec);
+			if (checker_state == CHECKER_FINISHED) {
+				vector_foreach_slot(vecs->mpvec, mpp, i) {
+					if (update_mpp_prio(vecs, mpp) == 2) {
+						/* multipath device deleted */
+						i--;
+					}
+				}
+			}
 			lock_cleanup_pop(vecs->lock);
 			if (checker_state != CHECKER_FINISHED) {
 				/* Yield to waiters */
-- 
2.45.0


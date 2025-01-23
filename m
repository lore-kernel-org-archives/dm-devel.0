Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FABB335C0
	for <dm-devel@lists.linux.dev>; Thu, 23 Jan 2025 03:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737602212; cv=none; b=m+/yrFhWu7KHiVC8/jXC/BJPaxxacXZsFKQOSNQ8yEW8fiyL42uOwG3QrqQAZmBd+m8E3D8NPhhhS79y5TF2wsCt+LKy2qkY95CZxjRcRXVYJP+vm3xCRr2XuhJ1qBi6eKOZ1isW/k8r7KaZAxIIYZlZTibFLGgZ1CyMh4vaSWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737602212; c=relaxed/simple;
	bh=Rc8c0WYM4d4Neh/an61UsAKlt374hKUq+G7+9WQccZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=jVub9LKLmLv0lyLrlMlMmR4iyqmiqrZiI94nh2lLSzQ/4v0bmXsMDVMbQPpDwcNgfwtsqkUFbg9DQZd+d4vi9YlsxaW3wk7rp0ZuO7fDixLfbvi4SV7jyAiASaMc3xl+aI+EsSb8362t+f2RLZRKUqN8PSDKdsm0eyyUxf+LHsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AfCTgAuD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AfCTgAuD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737602208;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PT7KLaYPdd4l4K1QlM6BEQHEzUGONO/W7yLtNRs4cxo=;
	b=AfCTgAuDroAj8qVy1B0z4UXEe8g0q68/4xQnYtZhgufIGbnN7JQKGy+3wsXNg8jUqh+q38
	7D0YQIfljM3/z3VL6P0JXuDpsrxqNP6EqrN8iKK0dpw5FV/pUlZH5iHoaNe4oBU+jqAAFN
	r/HgV6AeTT0Ok4XeFzlEErjqG8Hvj5s=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-361-FAp82OcjMsG7LMGhXsagZw-1; Wed,
 22 Jan 2025 22:16:46 -0500
X-MC-Unique: FAp82OcjMsG7LMGhXsagZw-1
X-Mimecast-MFC-AGG-ID: FAp82OcjMsG7LMGhXsagZw
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8095919560B9;
	Thu, 23 Jan 2025 03:16:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 49FEC19560AD;
	Thu, 23 Jan 2025 03:16:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 50N3GiLt3017917
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 22 Jan 2025 22:16:44 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 50N3GiSl3017916;
	Wed, 22 Jan 2025 22:16:44 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 01/13] multipathd: use symbolic values for wait_for_udev
Date: Wed, 22 Jan 2025 22:16:31 -0500
Message-ID: <20250123031643.3017891-2-bmarzins@redhat.com>
In-Reply-To: <20250123031643.3017891-1-bmarzins@redhat.com>
References: <20250123031643.3017891-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ZaJO0hSBV4K0J8djkBw2GCQyPiT0ZiuahKnm6yWZL4Q_1737602205
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c  |  2 +-
 libmultipath/structs.h    |  8 +++++++-
 multipathd/cli_handlers.c | 16 ++++++++--------
 multipathd/main.c         | 35 ++++++++++++++++++-----------------
 4 files changed, 34 insertions(+), 27 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 191df1ef..534ca7f4 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -1018,7 +1018,7 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
 				mpp->action = ACT_NOTHING;
 			else {
 				conf = get_multipath_config();
-				mpp->wait_for_udev = 1;
+				mpp->wait_for_udev = UDEV_WAIT_STARTED;
 				mpp->uev_wait_tick = conf->uev_wait_timeout;
 				put_multipath_config(conf);
 			}
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 9d22bdd0..1b5a878b 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -430,6 +430,12 @@ enum prio_update_type {
 	PRIO_UPDATE_MARGINAL,
 };
 
+enum udev_wait_states {
+	UDEV_WAIT_DONE = 0,
+	UDEV_WAIT_STARTED,
+	UDEV_WAIT_RELOAD,
+};
+
 struct multipath {
 	char wwid[WWID_SIZE];
 	char alias_old[WWID_SIZE];
@@ -441,7 +447,7 @@ struct multipath {
 	int bestpg;
 	int queuedio;
 	int action;
-	int wait_for_udev;
+	enum udev_wait_states wait_for_udev;
 	int uev_wait_tick;
 	int pgfailback;
 	int failback_tick;
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 0849fe51..4bcc82ac 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -812,7 +812,7 @@ cli_reload(void *v, struct strbuf *reply, void *data)
 	if (!mpp)
 		return -ENODEV;
 
-	if (mpp->wait_for_udev) {
+	if (mpp->wait_for_udev != UDEV_WAIT_DONE) {
 		condlog(2, "%s: device not fully created, failing reload",
 			mpp->alias);
 		return 1;
@@ -841,7 +841,7 @@ cli_resize(void *v, struct strbuf *reply, void *data)
 	if (!mpp)
 		return -ENODEV;
 
-	if (mpp->wait_for_udev) {
+	if (mpp->wait_for_udev != UDEV_WAIT_DONE) {
 		condlog(2, "%s: device not fully created, failing resize",
 			mpp->alias);
 		return 1;
@@ -1046,7 +1046,7 @@ cli_suspend(void * v, struct strbuf *reply, void * data)
 	if (!mpp)
 		return 1;
 
-	if (mpp->wait_for_udev) {
+	if (mpp->wait_for_udev != UDEV_WAIT_DONE) {
 		condlog(2, "%s: device not fully created, failing suspend",
 			mpp->alias);
 		return 1;
@@ -1078,7 +1078,7 @@ cli_resume(void * v, struct strbuf *reply, void * data)
 		return 1;
 
 	udev_flags = (mpp->skip_kpartx)? MPATH_UDEV_NO_KPARTX_FLAG : 0;
-	if (mpp->wait_for_udev) {
+	if (mpp->wait_for_udev != UDEV_WAIT_DONE) {
 		condlog(2, "%s: device not fully created, failing resume",
 			mpp->alias);
 		return 1;
@@ -1131,7 +1131,7 @@ cli_reassign (void * v, struct strbuf *reply, void * data)
 	if (!mpp)
 		return 1;
 
-	if (mpp->wait_for_udev) {
+	if (mpp->wait_for_udev != UDEV_WAIT_DONE) {
 		condlog(2, "%s: device not fully created, failing reassign",
 			mpp->alias);
 		return 1;
@@ -1406,7 +1406,7 @@ static int cli_set_marginal(void * v, struct strbuf *reply, void * data)
 
 	condlog(2, "%s: set marginal path %s (operator)",
 		pp->mpp->alias, pp->dev_t);
-	if (pp->mpp->wait_for_udev) {
+	if (pp->mpp->wait_for_udev != UDEV_WAIT_DONE) {
 		condlog(2, "%s: device not fully created, failing set marginal",
 			pp->mpp->alias);
 		return 1;
@@ -1433,7 +1433,7 @@ static int cli_unset_marginal(void * v, struct strbuf *reply, void * data)
 
 	condlog(2, "%s: unset marginal path %s (operator)",
 		pp->mpp->alias, pp->dev_t);
-	if (pp->mpp->wait_for_udev) {
+	if (pp->mpp->wait_for_udev != UDEV_WAIT_DONE) {
 		condlog(2, "%s: device not fully created, "
 			"failing unset marginal", pp->mpp->alias);
 		return 1;
@@ -1461,7 +1461,7 @@ static int cli_unset_all_marginal(void * v, struct strbuf *reply, void * data)
 	if (!mpp)
 		return -ENODEV;
 
-	if (mpp->wait_for_udev) {
+	if (mpp->wait_for_udev != UDEV_WAIT_DONE) {
 		condlog(2, "%s: device not fully created, "
 			"failing unset all marginal", mpp->alias);
 		return 1;
diff --git a/multipathd/main.c b/multipathd/main.c
index 4e26861d..3b4e61fc 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -331,7 +331,7 @@ static bool unblock_reconfigure(void)
  */
 void remove_map_callback(struct multipath *mpp)
 {
-	if (mpp->wait_for_udev > 0)
+	if (mpp->wait_for_udev != UDEV_WAIT_DONE)
 		unblock_reconfigure();
 }
 
@@ -871,7 +871,7 @@ ev_add_map (char * dev, const char * alias, struct vectors * vecs)
 	mpp = find_mp_by_alias(vecs->mpvec, alias);
 
 	if (mpp) {
-		if (mpp->wait_for_udev > 1) {
+		if (mpp->wait_for_udev == UDEV_WAIT_RELOAD) {
 			condlog(2, "%s: performing delayed actions",
 				mpp->alias);
 			if (update_map(mpp, vecs, 0))
@@ -882,8 +882,8 @@ ev_add_map (char * dev, const char * alias, struct vectors * vecs)
 		reassign_maps = conf->reassign_maps;
 		put_multipath_config(conf);
 		dm_get_info(mpp->alias, &mpp->dmi);
-		if (mpp->wait_for_udev) {
-			mpp->wait_for_udev = 0;
+		if (mpp->wait_for_udev != UDEV_WAIT_DONE) {
+			mpp->wait_for_udev = UDEV_WAIT_DONE;
 			if (!need_to_delay_reconfig(vecs) &&
 			    unblock_reconfigure())
 				return 0;
@@ -1241,7 +1241,7 @@ ev_add_path (struct path * pp, struct vectors * vecs, int need_do_map)
 	}
 	if (mpp)
 		trigger_path_udev_change(pp, true);
-	if (mpp && mpp->wait_for_udev &&
+	if (mpp && mpp->wait_for_udev != UDEV_WAIT_DONE &&
 	    (pathcount(mpp, PATH_UP) > 0 ||
 	     (pathcount(mpp, PATH_GHOST) > 0 &&
 	      path_get_tpgs(pp) != TPGS_IMPLICIT &&
@@ -1249,7 +1249,7 @@ ev_add_path (struct path * pp, struct vectors * vecs, int need_do_map)
 		/* if wait_for_udev is set and valid paths exist */
 		condlog(3, "%s: delaying path addition until %s is fully initialized",
 			pp->dev, mpp->alias);
-		mpp->wait_for_udev = 2;
+		mpp->wait_for_udev = UDEV_WAIT_RELOAD;
 		orphan_path(pp, "waiting for create to complete");
 		return 0;
 	}
@@ -1433,8 +1433,8 @@ ev_remove_path (struct path *pp, struct vectors * vecs, int need_do_map)
 		    flush_map_nopaths(mpp, vecs))
 			goto out;
 
-		if (mpp->wait_for_udev) {
-			mpp->wait_for_udev = 2;
+		if (mpp->wait_for_udev != UDEV_WAIT_DONE) {
+			mpp->wait_for_udev = UDEV_WAIT_RELOAD;
 			retval = REMOVE_PATH_DELAY;
 			goto out;
 		}
@@ -1646,8 +1646,8 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 		if (needs_ro_update(mpp, ro)) {
 			condlog(2, "%s: update path write_protect to '%d' (uevent)", uev->kernel, ro);
 
-			if (mpp->wait_for_udev)
-				mpp->wait_for_udev = 2;
+			if (mpp->wait_for_udev != UDEV_WAIT_DONE)
+				mpp->wait_for_udev = UDEV_WAIT_RELOAD;
 			else {
 				if (ro == 1)
 					pp->mpp->force_readonly = 1;
@@ -1661,7 +1661,7 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 			}
 		}
 		if (auto_resize != AUTO_RESIZE_NEVER && mpp &&
-		    !mpp->wait_for_udev) {
+		    mpp->wait_for_udev == UDEV_WAIT_DONE) {
 			struct pathgroup *pgp;
 			struct path *pp2;
 			unsigned int i, j;
@@ -2018,13 +2018,13 @@ followover_should_failback(struct multipath *mpp)
 static bool
 missing_uev_wait_tick(struct multipath *mpp, bool *timed_out)
 {
-	if (mpp->wait_for_udev && --mpp->uev_wait_tick <= 0) {
-		int wait = mpp->wait_for_udev;
+	if (mpp->wait_for_udev != UDEV_WAIT_DONE && --mpp->uev_wait_tick <= 0) {
+		enum udev_wait_states wait = mpp->wait_for_udev;
 
-		mpp->wait_for_udev = 0;
+		mpp->wait_for_udev = UDEV_WAIT_DONE;
 		*timed_out = true;
 		condlog(0, "%s: timeout waiting on creation uevent. enabling reloads", mpp->alias);
-		return wait > 1;
+		return wait == UDEV_WAIT_RELOAD;
 	}
 	return false;
 }
@@ -2635,7 +2635,8 @@ static bool update_mpp_prio(struct multipath *mpp)
 	enum prio_update_type prio_update = mpp->prio_update;
 	mpp->prio_update = PRIO_UPDATE_NONE;
 
-	if (mpp->wait_for_udev || prio_update == PRIO_UPDATE_NONE)
+	if (mpp->wait_for_udev != UDEV_WAIT_DONE ||
+	    prio_update == PRIO_UPDATE_NONE)
 		return false;
 	condlog(4, "prio refresh");
 
@@ -3246,7 +3247,7 @@ need_to_delay_reconfig(struct vectors * vecs)
 		return 0;
 
 	vector_foreach_slot(vecs->mpvec, mpp, i) {
-		if (mpp->wait_for_udev)
+		if (mpp->wait_for_udev != UDEV_WAIT_DONE)
 			return 1;
 	}
 	return 0;
-- 
2.46.2


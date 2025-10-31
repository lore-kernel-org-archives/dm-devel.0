Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141512F7466
	for <dm-devel@lists.linux.dev>; Fri, 31 Oct 2025 19:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761938385; cv=none; b=lNNIKe0iit3PzF6hldNuw5zOUtXM2Dy4KM6ZK+zC1MxH4V1VTOeLi0k32BMvxuFM8gvY8ss+IK+ZInWp5vPggFp51NthcrrO8iC2NALYtHvPkDUSxQxDqNLWg7Sqo8AF9FTRxb/ORlf2FUgCEclv7c9e3EMoYzP4pTWLHcnjhs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761938385; c=relaxed/simple;
	bh=sgblVJx9tvK6okEBfyoSjF93YH4mCod3s8PGeSF0+qc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=kBvXBUDVZJ/kEiePLtMylKueA7Hutbg4cKbelxHR1jlfeppxz5KS2pJq4aovUVamYD1NaVHG51+8vzhDmaytiamKIJ1DAlak7pLa8KhptYIYMDFIx74RM9JnW2TyMl78KoBjziWyVFWB7mvWj5bHpnppTjmDo9zykxy51wzXqn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cc+nTGx3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cc+nTGx3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761938382;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=EB/TMhUQQun4kUree4BkUSf06970Q1VCm6ezW0oWQk8=;
	b=Cc+nTGx3PzxYVt569ROPnEpCXmzwv+Xd3iZMQWMCiat+SB8L0hUzSPLiQ5aztiy+QdNubs
	PtjL6lSNVqxRbcLqhE18Nn+B7ZbZvPjIAxQW68tHkWUBmleCN093+yhei9AtMkE3GXQkUc
	DNRr7HEK6n8hXnW0W/7ni6XW5NxUFwA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-395-IHdrb-8RO86NA2qnoskrbQ-1; Fri,
 31 Oct 2025 15:19:38 -0400
X-MC-Unique: IHdrb-8RO86NA2qnoskrbQ-1
X-Mimecast-MFC-AGG-ID: IHdrb-8RO86NA2qnoskrbQ_1761938377
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 78DD018002C9;
	Fri, 31 Oct 2025 19:19:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 36BE619560A2;
	Fri, 31 Oct 2025 19:19:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 59VJJZD8186179
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 31 Oct 2025 15:19:35 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 59VJJZJV186178;
	Fri, 31 Oct 2025 15:19:35 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH] multipathd: Fix race while registering PR key
Date: Fri, 31 Oct 2025 15:19:35 -0400
Message-ID: <20251031191935.186170-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xbU5ixd5u2demxFCfdOJr_3EKm_tcJPUX2y-tlgVVJo_1761938377
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

When libmpathpersist registers a key, It first checks which paths are
active, then registers the key on those paths, and then tells multipathd
that the key has been registered, and it should start tracking it. If
a path comes up after libmpathpersist checks for active paths, but before
it tells multipathd that the key has been registered, multipathd will not
register a key no that path (since it hasn't been told to that the device
has a registered key yet). This can leave the device with a path that is
missing a key.

To solve this, when multipathd is told that a key has been registered,
it checks if there are the same number of registered keys as active
paths.  If there aren't, it registers keys on all the paths (at least
until the number of registered keys and active paths are equal).

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/cli_handlers.c |  6 ++++-
 multipathd/main.c         | 47 ++++++++++++++++++++++++++++-----------
 multipathd/main.h         |  1 +
 3 files changed, 40 insertions(+), 14 deletions(-)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 7f572fb4..2812d01e 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -1291,7 +1291,11 @@ cli_setprstatus(void * v, struct strbuf *reply, void * data)
 
 	if (mpp->prflag != PR_SET) {
 		set_pr(mpp);
-		condlog(2, "%s: prflag set", param);
+		pr_register_active_paths(mpp, true);
+		if (mpp->prflag == PR_SET)
+			condlog(2, "%s: prflag set", param);
+		else
+			condlog(0, "%s: Failed to set prflag", param);
 	}
 	memset(&mpp->old_pr_key, 0, 8);
 
diff --git a/multipathd/main.c b/multipathd/main.c
index d11a8576..70268d98 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -90,7 +90,8 @@
 #define MSG_SIZE 32
 
 static unsigned int
-mpath_pr_event_handle(struct path *pp, unsigned int nr_keys_needed);
+mpath_pr_event_handle(struct path *pp, unsigned int nr_keys_needed,
+		      unsigned int nr_keys_wanted);
 
 #define LOG_MSG(lvl, pp)					\
 do {								\
@@ -629,19 +630,28 @@ flush_map_nopaths(struct multipath *mpp, struct vectors *vecs) {
 	return true;
 }
 
-static void
-pr_register_active_paths(struct multipath *mpp)
+void pr_register_active_paths(struct multipath *mpp, bool check_nr_active)
 {
 	unsigned int i, j, nr_keys = 0;
+	unsigned int nr_active = 0;
 	struct path *pp;
 	struct pathgroup *pgp;
 
+	if (check_nr_active) {
+		nr_active = count_active_paths(mpp);
+		if (!nr_active)
+			return;
+	}
+
 	vector_foreach_slot (mpp->pg, pgp, i) {
 		vector_foreach_slot (pgp->paths, pp, j) {
 			if (mpp->prflag == PR_UNSET)
 				return;
-			if ((pp->state == PATH_UP) || (pp->state == PATH_GHOST))
-				nr_keys = mpath_pr_event_handle(pp, nr_keys);
+			if (pp->state == PATH_UP || pp->state == PATH_GHOST) {
+				nr_keys = mpath_pr_event_handle(pp, nr_keys, nr_active);
+				if (check_nr_active && nr_keys == nr_active)
+					return;
+			}
 		}
 	}
 }
@@ -729,7 +739,7 @@ fail:
 
 	sync_map_state(mpp, false);
 
-	pr_register_active_paths(mpp);
+	pr_register_active_paths(mpp, false);
 
 	if (VECTOR_SIZE(offline_paths) != 0)
 		handle_orphaned_offline_paths(offline_paths);
@@ -1319,7 +1329,7 @@ rescan:
 		verify_paths(mpp);
 		mpp->action = ACT_RELOAD;
 		prflag = mpp->prflag;
-		mpath_pr_event_handle(pp, 0);
+		mpath_pr_event_handle(pp, 0, 0);
 	} else {
 		if (!should_multipath(pp, vecs->pathvec, vecs->mpvec)) {
 			orphan_path(pp, "only one path");
@@ -1403,7 +1413,7 @@ rescan:
 
 	if (retries >= 0) {
 		if ((mpp->prflag == PR_SET && prflag != PR_SET) || start_waiter)
-			pr_register_active_paths(mpp);
+			pr_register_active_paths(mpp, false);
 		condlog(2, "%s [%s]: path added to devmap %s",
 			pp->dev, pp->dev_t, mpp->alias);
 		return 0;
@@ -2646,9 +2656,9 @@ update_path_state (struct vectors * vecs, struct path * pp)
 			 */
 			condlog(2, "%s: checking persistent "
 				"reservation registration", pp->dev);
-			mpath_pr_event_handle(pp, 0);
+			mpath_pr_event_handle(pp, 0, 0);
 			if (pp->mpp->prflag == PR_SET && prflag != PR_SET)
-				pr_register_active_paths(pp->mpp);
+				pr_register_active_paths(pp->mpp, false);
 		}
 
 		/*
@@ -3309,7 +3319,7 @@ configure (struct vectors * vecs, enum force_reload_types reload_type)
 	vector_foreach_slot(mpvec, mpp, i){
 		if (remember_wwid(mpp->wwid) == 1)
 			trigger_paths_udev_change(mpp, true);
-		pr_register_active_paths(mpp);
+		pr_register_active_paths(mpp, false);
 	}
 
 	/*
@@ -4341,16 +4351,25 @@ static int update_map_pr(struct multipath *mpp, struct path *pp, unsigned int *n
 }
 
 /*
- * This function is called with the number of registered keys that should be
+ * This function is called with two numbers
+ *
+ * nr_keys_needed: the number of registered keys that should be
  * seen for this device to know that the key has not been preempted while the
  * path was getting registered. If 0 is passed in, update_mpath_pr is called
  * before registering the key to figure out the number, assuming that at
  * least one key must exist.
  *
+ * nr_keys_wanted: Only used if nr_keys_needed is 0, so we don't know how
+ * many keys we currently have. If nr_keys_wanted in non-zero and the
+ * number of keys found by the initial call to update_map_pr() matches it,
+ * exit early, since we have all the keys we are expecting.
+ *
  * The function returns the number of keys that are registered or 0 if
  * it's unknown.
  */
-static unsigned int mpath_pr_event_handle(struct path *pp, unsigned int nr_keys_needed)
+static unsigned int
+mpath_pr_event_handle(struct path *pp, unsigned int nr_keys_needed,
+		      unsigned int nr_keys_wanted)
 {
 	struct multipath *mpp = pp->mpp;
 	int ret;
@@ -4366,6 +4385,8 @@ static unsigned int mpath_pr_event_handle(struct path *pp, unsigned int nr_keys_
 		nr_keys_needed = 1;
 		if (update_map_pr(mpp, pp, &nr_keys_needed) != MPATH_PR_SUCCESS)
 			return 0;
+		if (nr_keys_wanted && nr_keys_wanted == nr_keys_needed)
+			return nr_keys_needed;
 	}
 
 	check_prhold(mpp, pp);
diff --git a/multipathd/main.h b/multipathd/main.h
index 29b57e3d..6d60ee81 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -54,4 +54,5 @@ int resize_map(struct multipath *mpp, unsigned long long size,
 	       struct vectors *vecs);
 void set_pr(struct multipath *mpp);
 void unset_pr(struct multipath *mpp);
+void pr_register_active_paths(struct multipath *mpp, bool check_active_nr);
 #endif /* MAIN_H_INCLUDED */
-- 
2.50.1


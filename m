Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CDBB20322
	for <dm-devel@lists.linux.dev>; Fri,  7 Nov 2025 01:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762477704; cv=none; b=f+RCgbMs/UvBpoLmJNMJMxEtbUXuhuO35E4386XDzWrlwvcnmUkuUPQVSJ+PW/8I++EvEYJeHVUm4qXtDH6b7o3l8J+FqKu+Rb270RPld8v38IB/h3eOPMsHwGRpn1xsvoHeiHwVc48+F2E71sh98Okqt0wFWR1Ecqr22+439mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762477704; c=relaxed/simple;
	bh=Z0NB6Sc3ehJhAunK3XzqA24aLOX1JJDhdJtGvPWpJDg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=HcBiM+9Za4wH34BojAPbKkuIF0Cqo0ZnCZBapVwt2MXzoMRjL40YbVU311Exuq/ppet66yrlLbp565WM9oyrRQ598O46jBiRfXT3+cBsrIuDlCujQ+PNCms7M+H2bb4C5zxvVjSgzlQeoJp0pT+n8Zmjk65YnFeQgasp9xjwkMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XN12XBoJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XN12XBoJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762477701;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IB6KVobDjxJ74eI37ppuiu8tpBV9RPfrUpp2mWT8qZ8=;
	b=XN12XBoJ4Tw7eULlzZ/T0mExP5E/L5Ga6xiK9Mj3DOTZsFjHt/t5RCxCkhszBTQWRpof8W
	tq6z+2rdtTJsezXiSdY86opKA45U1QhySYkjVfyIs63fbbVaZnjq7Oi0ewa+2t0D1qmWVE
	7r+L1JN4JJn7jgxhQNsbo2wuOhU3Kcg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-581-_GnZbCmIM0WbHOYGah75Jg-1; Thu,
 06 Nov 2025 20:08:18 -0500
X-MC-Unique: _GnZbCmIM0WbHOYGah75Jg-1
X-Mimecast-MFC-AGG-ID: _GnZbCmIM0WbHOYGah75Jg_1762477697
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3DE2B1800447;
	Fri,  7 Nov 2025 01:08:17 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E11223001E83;
	Fri,  7 Nov 2025 01:08:16 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5A718FdU447879
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 6 Nov 2025 20:08:15 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5A718Es1447878;
	Thu, 6 Nov 2025 20:08:14 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2] multipathd: Fix race while registering PR key
Date: Thu,  6 Nov 2025 20:08:14 -0500
Message-ID: <20251107010814.447870-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: vkCcAgpUwTvbxs4-zTsM9juZNA0h8zcf-aHoBrV2RjI_1762477697
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
until the number of registered keys and active paths are equal). To
avoid doing a bunch of unnecessary PR work, pr_register_active_paths()
has a new option to track the number of active paths, and
mpath_pr_event_handle() now takes the number of keys to expect. The
first time it's called, when there is an unknown number of keys, if the
number of keys it finds matches the number of active_paths, it and
pr_register_active_paths() exit early, since there is no registering
work to do.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---

Changes in v2:
  - made update_map_pr() set nr_keys to 0 when it failed to get the keys
    or when it unset prflag (to fix a bug found by Martin Wilck)

 multipathd/cli_handlers.c |  6 ++++-
 multipathd/main.c         | 57 ++++++++++++++++++++++++++++-----------
 multipathd/main.h         |  1 +
 3 files changed, 48 insertions(+), 16 deletions(-)

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
index d11a8576..4c86f31e 100644
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
@@ -4267,7 +4277,8 @@ void unset_pr(struct multipath *mpp)
  *
  * The number of found keys must be at least as large as *nr_keys,
  * and if MPATH_PR_SUCCESS is returned and mpp->prflag is PR_SET after
- * the call, *nr_keys will be set to the number of found keys.
+ * the call, *nr_keys will be set to the number of found keys. Otherwise
+ * it will be set to 0.
  */
 static int update_map_pr(struct multipath *mpp, struct path *pp, unsigned int *nr_keys)
 {
@@ -4277,8 +4288,10 @@ static int update_map_pr(struct multipath *mpp, struct path *pp, unsigned int *n
 	bool was_set = (mpp->prflag == PR_SET);
 
 	/* If pr is explicitly unset, it must be manually set */
-	if (mpp->prflag == PR_UNSET)
+	if (mpp->prflag == PR_UNSET) {
+		*nr_keys = 0;
 		return MPATH_PR_SUCCESS;
+	}
 
 	if (!get_be64(mpp->reservation_key)) {
 		/* Nothing to do. Assuming pr mgmt feature is disabled*/
@@ -4286,6 +4299,7 @@ static int update_map_pr(struct multipath *mpp, struct path *pp, unsigned int *n
 		condlog(was_set ? 2 : 4,
 			"%s: reservation_key not set in multipath.conf",
 			mpp->alias);
+		*nr_keys = 0;
 		return MPATH_PR_SUCCESS;
 	}
 
@@ -4297,6 +4311,7 @@ static int update_map_pr(struct multipath *mpp, struct path *pp, unsigned int *n
 			unset_pr(mpp);
 		condlog(0, "%s : pr in read keys service action failed Error=%d",
 			mpp->alias, ret);
+		*nr_keys = 0;
 		return ret;
 	}
 
@@ -4335,22 +4350,32 @@ static int update_map_pr(struct multipath *mpp, struct path *pp, unsigned int *n
 		condlog(was_set ? 1 : 3,
 			"%s: %u keys found. needed %u. prflag unset.",
 			mpp->alias, nr_found, *nr_keys);
+		*nr_keys = 0;
 	}
 
 	return MPATH_PR_SUCCESS;
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
@@ -4366,6 +4391,8 @@ static unsigned int mpath_pr_event_handle(struct path *pp, unsigned int nr_keys_
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


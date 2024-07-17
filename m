Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1DC1849CC
	for <dm-devel@lists.linux.dev>; Wed, 17 Jul 2024 18:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721239879; cv=none; b=W1w4yw+AXoHzo7t7RY76N3iRqbA3pEuNKtCZQgZC6C3Bhj+QYlZ0AmM93e6liXffOaUj0mXHDwcplRjebEioQBQDxtvWEh4G9UTM5PLpqf+G3cHe2TUUna2rP+jf2+fONEQBp9xPUwoKKz9u18xNp/fePuRjPJ/BdmTVaN2drzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721239879; c=relaxed/simple;
	bh=BLI7pAwl7HC8ZV9FxUg5e2ks2h4/7d82adBO6lXMI4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rfk+3uyOh2fauwSEFNKZLpariR13ajjqlP/SdZBmcKfUoS5j6Z2tk7ud7nzE/ljF/vZONHSsIDW81/d7PTB7mNarNlMH46YOLpfutww877uxV0i7GS+xI436pYHlkjaq/Om99Brc4781Ms5s3wVRKLauwgapIGIqh8h3DHE4zDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NX99btVT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NX99btVT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721239876;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gRhJwNTuOrG9y1ymZlwHyFJeF8aV7WLvohClQnzaAOo=;
	b=NX99btVTYkt4aD4Njbabz+6sGe+22ZoNTcRMKMC51yXh7qKNlXlEPG8qvjVyGoXjeYNQF1
	fFPmV5flQhaf50tVK6MaiRzzshpkCHiBV/fvfb43uxBSFnA64UfdCGX/mEW5gqImXk8ayy
	kdqIlzMxJaPgvr0/oqVISOe+fDm/xhY=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-500-hR0cXyOvPVixkSKJOBQjPA-1; Wed,
 17 Jul 2024 14:11:13 -0400
X-MC-Unique: hR0cXyOvPVixkSKJOBQjPA-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 40B8C19560AD;
	Wed, 17 Jul 2024 18:11:12 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B9AF31955D4A;
	Wed, 17 Jul 2024 18:11:11 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46HIBAcY2173632
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 17 Jul 2024 14:11:10 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46HIBAGc2173631;
	Wed, 17 Jul 2024 14:11:10 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 19/20] multipathd: check paths in order by mpp
Date: Wed, 17 Jul 2024 14:11:05 -0400
Message-ID: <20240717181106.2173527-20-bmarzins@redhat.com>
In-Reply-To: <20240717181106.2173527-1-bmarzins@redhat.com>
References: <20240717181106.2173527-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Instead of checking all of the paths in vecs->pathvec in order, first
check all the paths in each multipath device. Then check the
uninitialized paths.

One issue with checking paths this way is that the multipath device can
be resynced or even removed while a path is being checked. The path can
also be removed. If there is any change to the multipath device,
multipathd needs to loop through its paths again, because the current
indexes may not longer be valid.

To do this change mpp->is_checked to an int called mpp->synced_count,
and increment it whenever the multipath device gets resynced. After each
path is checked, make sure that the multipath device still exists, that
mpp->synced_count hasn't changed. If either has happened, restart
checking at the current index in mpvec (which will either be the same
mpp if it was just resynced, or the next mpp if the last one was
deleted). Since the multipath device is resynced when its first path is
checked, this restart will happen to every multipath device at least
once per loop. But the paths themselves aren't rechecked, so it's not
much overhead.

If resyncing a multipath device fails in do_check_mpp(), there may be
path devices that have pp->mpp set, but are no longer in one of the
multipath device's pathgroups, and thus will not get checked. This
almost definitely means the multipath device was deleted. If
do_check_mpp() failed to resync the device, but it wasn't deleted, it
will get called again in max_checkint seconds even if it no longer has
mpp->pg set, and the paths will get checked again after that.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs.h     |  2 +-
 libmultipath/structs_vec.c |  1 +
 multipathd/main.c          | 54 ++++++++++++++++++++++++++++++++------
 3 files changed, 48 insertions(+), 9 deletions(-)

diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 457d7836..91509881 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -455,7 +455,7 @@ struct multipath {
 	int ghost_delay_tick;
 	int queue_mode;
 	unsigned int sync_tick;
-	bool is_checked;
+	int synced_count;
 	uid_t uid;
 	gid_t gid;
 	mode_t mode;
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 345d3069..cf9c6fe8 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -513,6 +513,7 @@ update_multipath_table (struct multipath *mpp, vector pathvec, int flags)
 	conf = get_multipath_config();
 	mpp->sync_tick = conf->max_checkint;
 	put_multipath_config(conf);
+	mpp->synced_count++;
 
 	r = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY,
 			  (mapid_t) { .str = mpp->alias },
diff --git a/multipathd/main.c b/multipathd/main.c
index 161c6962..5eefa475 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2356,7 +2356,6 @@ do_sync_mpp(struct vectors * vecs, struct multipath *mpp)
 	int i, ret;
 	struct path *pp;
 
-	mpp->is_checked = true;
 	ret = update_multipath_strings(mpp, vecs->pathvec);
 	if (ret != DMP_OK) {
 		condlog(1, "%s: %s", mpp->alias, ret == DMP_NOT_FOUND ?
@@ -2431,7 +2430,7 @@ do_check_path (struct vectors * vecs, struct path * pp)
 		return handle_path_wwid_change(pp, vecs)? CHECK_PATH_REMOVED :
 							  CHECK_PATH_SKIPPED;
 	}
-	if (!pp->mpp->is_checked) {
+	if (pp->mpp->synced_count == 0) {
 		do_sync_mpp(vecs, pp->mpp);
 		/* if update_multipath_strings orphaned the path, quit early */
 		if (!pp->mpp)
@@ -2788,18 +2787,57 @@ check_paths(struct vectors *vecs, unsigned int ticks, int *num_paths_p)
 {
 	unsigned int paths_checked = 0;
 	struct timespec diff_time, start_time, end_time;
+	struct multipath *mpp;
 	struct path *pp;
 	int i, rc;
 
 	get_monotonic_time(&start_time);
+
+	vector_foreach_slot(vecs->mpvec, mpp, i) {
+		struct pathgroup *pgp;
+		struct path *pp;
+		int j, k;
+		bool check_for_waiters = false;
+		/* maps can be rechecked, so this is not always 0 */
+		int synced_count = mpp->synced_count;
+
+		vector_foreach_slot (mpp->pg, pgp, j) {
+			vector_foreach_slot (pgp->paths, pp, k) {
+				if (!pp->mpp || pp->is_checked)
+					continue;
+				pp->is_checked = true;
+				rc = check_path(vecs, pp, ticks,
+						start_time.tv_sec);
+				if (rc == CHECK_PATH_CHECKED)
+					(*num_paths_p)++;
+				if (++paths_checked % 128 == 0)
+					check_for_waiters = true;
+				/*
+				 * mpp has been removed or resynced. Path may
+				 * have been removed.
+				 */
+				if (VECTOR_SLOT(vecs->mpvec, i) != mpp ||
+				    synced_count != mpp->synced_count) {
+					i--;
+					goto next_mpp;
+				}
+			}
+		}
+next_mpp:
+		if (check_for_waiters &&
+		    (lock_has_waiters(&vecs->lock) || waiting_clients())) {
+			get_monotonic_time(&end_time);
+			timespecsub(&end_time, &start_time, &diff_time);
+			if (diff_time.tv_sec > 0)
+				return CHECKER_RUNNING;
+		}
+	}
 	vector_foreach_slot(vecs->pathvec, pp, i) {
-		if (pp->is_checked)
+		if (pp->mpp || pp->is_checked)
 			continue;
 		pp->is_checked = true;
-		if (pp->mpp)
-			rc = check_path(vecs, pp, ticks, start_time.tv_sec);
-		else
-			rc = handle_uninitialized_path(vecs, pp, ticks);
+
+		rc = handle_uninitialized_path(vecs, pp, ticks);
 		if (rc == CHECK_PATH_REMOVED)
 			i--;
 		else if (rc == CHECK_PATH_CHECKED)
@@ -2872,7 +2910,7 @@ checkerloop (void *ap)
 			lock(&vecs->lock);
 			pthread_testcancel();
 			vector_foreach_slot(vecs->mpvec, mpp, i)
-				mpp->is_checked = false;
+				mpp->synced_count = 0;
 			if (checker_state == CHECKER_STARTING) {
 				vector_foreach_slot(vecs->mpvec, mpp, i)
 					sync_mpp(vecs, mpp, ticks);
-- 
2.45.0


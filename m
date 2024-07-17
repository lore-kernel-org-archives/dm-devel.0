Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC445183090
	for <dm-devel@lists.linux.dev>; Wed, 17 Jul 2024 18:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721239877; cv=none; b=tTNhbPrrEBaqYosU5yIXPcVsYrVE82Q3JYSbNwU52uJO0zmFoUtjOEH4WW9HBUaRPxWDhs9Ok/4edFijiuvKErooW7bj4/kC2k4m3+x/a8N/SWVcezOdfIrOZSBz4BMia9u8iU57by6HHFDvsvywiiv/4xwxoisNpiTLCj6KtAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721239877; c=relaxed/simple;
	bh=jvkKHsQeNsRwgmF8KoDLEZYYiIxrcwyLc2RHsXfDSM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OGeVf+jif/QaUDBGA6yiRQt+qreUl+zWGy07tvlKsvYmsLice0YPqTj0FsC/K5vrSwIntkRO8lafDNlDASZ3VpXIM4mWfJtpEHjWRTZUUH5u/vyeSeBjduqz2ls6lbFatL6ytXSKHrkiFq/TSIcxxhnhg0uzR4rF0iOUQGAQymk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RVZnUq8y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RVZnUq8y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721239874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tdUh1mIcHTtFmruWxFXBIhScsccsNQmCqr+wTZ8ze0M=;
	b=RVZnUq8yu/5bYrs/nyWYWxbAkS36RDqlbM7iVaovJtUzsyWjcNh0Oyk/9112OtMBsbVBkn
	gg5+/96rHgyIW0Iw0j7PmmeQY0N0RSikqDRsM8M15aLit/U2w5tLCxOZolT69lcImc29Il
	DzrLruFvwNXv3pMem9JaBc4quihgVg0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-314-sGmmgWzbPdyj6ewRis06tQ-1; Wed,
 17 Jul 2024 14:11:11 -0400
X-MC-Unique: sGmmgWzbPdyj6ewRis06tQ-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 57BAC1955D42;
	Wed, 17 Jul 2024 18:11:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EAF2A1955F3B;
	Wed, 17 Jul 2024 18:11:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46HIB8nM2173596
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 17 Jul 2024 14:11:08 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46HIB8922173595;
	Wed, 17 Jul 2024 14:11:08 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 10/20] multipathd: adjust when mpp is synced with the kernel
Date: Wed, 17 Jul 2024 14:10:56 -0400
Message-ID: <20240717181106.2173527-11-bmarzins@redhat.com>
In-Reply-To: <20240717181106.2173527-1-bmarzins@redhat.com>
References: <20240717181106.2173527-1-bmarzins@redhat.com>
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

Move the code to sync the mpp device state into a helper function and
add a counter to to make sure that the device is synced at least once
every max_checkint secs. This makes sure that multipath devices with no
paths will still get synced with the kernel.  Also, if multiple paths
are checked in the same loop, the multipath device will only be synced
with the kernel once, since every time the mpp is synced in any code
path, mpp->sync_tick is reset.

The code still syncs the mpp before updating the path state for two
main reasons.

1. Sometimes multipathd leaves the mpp with a garbage state. Future
   patches will fix most of these cases, but the code intentially
   does not remove the mpp is resyncing fails while checking paths.
   But this does leave the mpp with a garbage state.

2. The kernel chages the multipath state independently of multipathd. If
   the kernel fails a path, a uevent will arrive shortly. But the kernel
   doesn't provide any notification when it switches the active
   path group or if it ends up picking a different one than multipathd
   selected. Multipathd needs to know the actual current pathgroup to
   know when it should be switching them.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c   |  1 +
 libmultipath/structs.h     |  2 ++
 libmultipath/structs_vec.c |  5 +++
 multipathd/main.c          | 64 +++++++++++++++++++++++++-------------
 4 files changed, 50 insertions(+), 22 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index b4de863c..34158e31 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -358,6 +358,7 @@ int setup_map(struct multipath *mpp, char **params, struct vectors *vecs)
 
 	sysfs_set_scsi_tmo(conf, mpp);
 	marginal_pathgroups = conf->marginal_pathgroups;
+	mpp->sync_tick = conf->max_checkint;
 	pthread_cleanup_pop(1);
 
 	if (!mpp->features || !mpp->hwhandler || !mpp->selector) {
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 3b91e39c..002eeae1 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -453,6 +453,8 @@ struct multipath {
 	int ghost_delay;
 	int ghost_delay_tick;
 	int queue_mode;
+	unsigned int sync_tick;
+	bool is_checked;
 	uid_t uid;
 	gid_t gid;
 	mode_t mode;
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 731b1bce..60360c76 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -505,10 +505,15 @@ update_multipath_table (struct multipath *mpp, vector pathvec, int flags)
 	char __attribute__((cleanup(cleanup_charp))) *params = NULL;
 	char __attribute__((cleanup(cleanup_charp))) *status = NULL;
 	unsigned long long size = mpp->size;
+	struct config *conf;
 
 	if (!mpp)
 		return r;
 
+	conf = get_multipath_config();
+	mpp->sync_tick = conf->max_checkint;
+	put_multipath_config(conf);
+
 	r = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY,
 			  (mapid_t) { .str = mpp->alias },
 			  (mapinfo_t) {
diff --git a/multipathd/main.c b/multipathd/main.c
index 08b424d6..d7c87039 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2342,6 +2342,37 @@ check_path_state(struct path *pp)
 	return newstate;
 }
 
+static void
+do_sync_mpp(struct vectors * vecs, struct multipath *mpp)
+{
+	int i, ret;
+	struct path *pp;
+
+	mpp->is_checked = true;
+	ret = update_multipath_strings(mpp, vecs->pathvec);
+	if (ret != DMP_OK) {
+		condlog(1, "%s: %s", mpp->alias, ret == DMP_NOT_FOUND ?
+			"device not found" :
+			"couldn't synchronize with kernel state");
+		vector_foreach_slot (mpp->paths, pp, i)
+			pp->dmstate = PSTATE_UNDEF;
+		return;
+	}
+	set_no_path_retry(mpp);
+}
+
+static void
+sync_mpp(struct vectors * vecs, struct multipath *mpp, unsigned int ticks)
+{
+	if (mpp->sync_tick)
+		mpp->sync_tick -= (mpp->sync_tick > ticks) ? ticks :
+				  mpp->sync_tick;
+	if (mpp->sync_tick)
+		return;
+
+	do_sync_mpp(vecs, mpp);
+}
+
 /*
  * Returns '1' if the path has been checked and '0' otherwise
  */
@@ -2356,7 +2387,6 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 	unsigned int checkint, max_checkint;
 	struct config *conf;
 	int marginal_pathgroups, marginal_changed = 0;
-	int ret;
 	bool need_reload;
 
 	if (pp->initialized == INIT_REMOVED)
@@ -2395,26 +2425,6 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 		pp->tick = 1;
 		return 0;
 	}
-	/*
-	 * Synchronize with kernel state
-	 */
-	ret = update_multipath_strings(pp->mpp, vecs->pathvec);
-	if (ret != DMP_OK) {
-		if (ret == DMP_NOT_FOUND) {
-			/* multipath device missing. Likely removed */
-			condlog(1, "%s: multipath device '%s' not found",
-				pp->dev, pp->mpp ? pp->mpp->alias : "");
-			return 0;
-		} else
-			condlog(1, "%s: Couldn't synchronize with kernel state",
-				pp->dev);
-		pp->dmstate = PSTATE_UNDEF;
-	}
-	/* if update_multipath_strings orphaned the path, quit early */
-	if (!pp->mpp)
-		return 0;
-	set_no_path_retry(pp->mpp);
-
 	if (pp->recheck_wwid == RECHECK_WWID_ON &&
 	    (newstate == PATH_UP || newstate == PATH_GHOST) &&
 	    ((pp->state != PATH_UP && pp->state != PATH_GHOST) ||
@@ -2424,7 +2434,12 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 		handle_path_wwid_change(pp, vecs);
 		return 0;
 	}
-
+	if (!pp->mpp->is_checked) {
+		do_sync_mpp(vecs, pp->mpp);
+		/* if update_multipath_strings orphaned the path, quit early */
+		if (!pp->mpp)
+			return 0;
+	}
 	if ((newstate != PATH_UP && newstate != PATH_GHOST &&
 	     newstate != PATH_PENDING) && (pp->state == PATH_DELAYED)) {
 		/* If path state become failed again cancel path delay state */
@@ -2752,12 +2767,17 @@ checkerloop (void *ap)
 		while (checker_state != CHECKER_FINISHED) {
 			unsigned int paths_checked = 0, i;
 			struct timespec chk_start_time;
+			struct multipath *mpp;
 
 			pthread_cleanup_push(cleanup_lock, &vecs->lock);
 			lock(&vecs->lock);
 			pthread_testcancel();
+			vector_foreach_slot(vecs->mpvec, mpp, i)
+				mpp->is_checked = false;
 			get_monotonic_time(&chk_start_time);
 			if (checker_state == CHECKER_STARTING) {
+				vector_foreach_slot(vecs->mpvec, mpp, i)
+					sync_mpp(vecs, mpp, ticks);
 				vector_foreach_slot(vecs->pathvec, pp, i)
 					pp->is_checked = false;
 				checker_state = CHECKER_RUNNING;
-- 
2.45.0


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E2318411A
	for <dm-devel@lists.linux.dev>; Wed, 17 Jul 2024 18:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721239879; cv=none; b=ZR1mSUG0EbOFKElqPtGwzN6y4OZ1vqnPnKeo1gTVI1P7pwS47V7In+WY5oNNBfFpD/QlUSg5Tcx1CzEUk4+dgIFOmt3jjQHhSSWH7E1oWgdG1/VKUC/FR99OClqCfF3Oo7sjguz9tZVLuu2niJNTrzYT4WLJS5tsIa2heA45cqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721239879; c=relaxed/simple;
	bh=oIWlO7jA1YcbQ6FHKgkSkQBZs1MDTckZpCvHby+uNxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PukAvxMH/YZUFnOhX1qrSCwG7hWyEiUvKR30sii3wBzPeTJEYBIpq2+/D8jQsEh2bYYIMG4b7TIg2SW4sqz6RqfoCE5AW2zi3gL0Zlbk4Jn6usz8Ktv48a1PIFbA88ScXLCh4fb6/xc4Hdil5U+3FCbBnTYtGQRcV9W+H5Fa4fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UgwDBjd3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UgwDBjd3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721239875;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aTFUmfIoni0V2VjyDJay0u1FiqPdUYHcx5fRDwQvh5U=;
	b=UgwDBjd3poN2wRzs2u16G55j673sGmg3C6uvEjxVMZOP6VwrqxfO3KxQGizF1+GczXQndX
	Ao2y+YMNaNTVqMoGKDSZUivhFRhaFYT593P8ht/X+rre30foTeqZFXarhwXZRM0YPXN91a
	JdppgVS097B5ivIAChG/derdk/yZyeo=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-119-j8Pw3IGDMXisHePoEPrSyQ-1; Wed,
 17 Jul 2024 14:11:12 -0400
X-MC-Unique: j8Pw3IGDMXisHePoEPrSyQ-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 033101955D4C;
	Wed, 17 Jul 2024 18:11:11 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B1A6F19560AA;
	Wed, 17 Jul 2024 18:11:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46HIB9Xw2173612
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 17 Jul 2024 14:11:09 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46HIB9p22173611;
	Wed, 17 Jul 2024 14:11:09 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 14/20] multipathd: correctly handle paths removed for a wwid change
Date: Wed, 17 Jul 2024 14:11:00 -0400
Message-ID: <20240717181106.2173527-15-bmarzins@redhat.com>
In-Reply-To: <20240717181106.2173527-1-bmarzins@redhat.com>
References: <20240717181106.2173527-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

If check_path() exitted because the path's wwid changed and it was
removed, checkerloop() wasn't decrementing the pathvec loop count.
This caused the next path to be skipped by the checker loop.

To solve this, switch check_path() and handle_uninitialized_path() to
symbolic returns and make check_path() return CHECK_PATH_REMOVED when a
path is removed, make handle_uninitialized_path() also remove the path
if it was blacklisted, and make checkerloop() just decrement the loop
count when a path handling function returns CHECK_PATH_REMOVED.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 73 ++++++++++++++++++++++++++---------------------
 multipathd/main.h |  2 +-
 2 files changed, 41 insertions(+), 34 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 0d2a6780..92a0e424 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -974,20 +974,24 @@ rescan_path(struct udev_device *ud)
 	}
 }
 
-void
+/* Returns true if the path was removed */
+bool
 handle_path_wwid_change(struct path *pp, struct vectors *vecs)
 {
 	struct udev_device *udd;
 	static const char add[] = "add";
 	ssize_t ret;
 	char dev[FILE_NAME_SIZE];
+	bool removed = false;
 
 	if (!pp || !pp->udev)
-		return;
+		return removed;
 
 	strlcpy(dev, pp->dev, sizeof(dev));
 	udd = udev_device_ref(pp->udev);
-	if (!(ev_remove_path(pp, vecs, 1) & REMOVE_PATH_SUCCESS) && pp->mpp) {
+	if (ev_remove_path(pp, vecs, 1) & REMOVE_PATH_SUCCESS) {
+		removed = true;
+	} else if (pp->mpp) {
 		pp->dmstate = PSTATE_FAILED;
 		dm_fail_path(pp->mpp->alias, pp->dev_t);
 	}
@@ -997,6 +1001,7 @@ handle_path_wwid_change(struct path *pp, struct vectors *vecs)
 	if (ret != sizeof(add) - 1)
 		log_sysfs_attr_set_value(1, ret,
 					 "%s: failed to trigger add event", dev);
+	return removed;
 }
 
 bool
@@ -2376,9 +2381,12 @@ sync_mpp(struct vectors * vecs, struct multipath *mpp, unsigned int ticks)
 	do_sync_mpp(vecs, mpp);
 }
 
-/*
- * Returns '1' if the path has been checked and '0' otherwise
- */
+enum check_path_return {
+	CHECK_PATH_CHECKED,
+	CHECK_PATH_SKIPPED,
+	CHECK_PATH_REMOVED,
+};
+
 static int
 check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 {
@@ -2393,12 +2401,12 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 	bool need_reload;
 
 	if (pp->initialized == INIT_REMOVED)
-		return 0;
+		return CHECK_PATH_SKIPPED;
 
 	if (pp->tick)
 		pp->tick -= (pp->tick > ticks) ? ticks : pp->tick;
 	if (pp->tick)
-		return 0; /* don't check this path yet */
+		return CHECK_PATH_SKIPPED;
 
 	conf = get_multipath_config();
 	checkint = conf->checkint;
@@ -2419,14 +2427,14 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 
 	newstate = check_path_state(pp);
 	if (newstate == PATH_WILD || newstate == PATH_UNCHECKED)
-		return 0;
+		return CHECK_PATH_SKIPPED;
 	/*
 	 * Async IO in flight. Keep the previous path state
 	 * and reschedule as soon as possible
 	 */
 	if (newstate == PATH_PENDING) {
 		pp->tick = 1;
-		return 0;
+		return CHECK_PATH_SKIPPED;
 	}
 	if (pp->recheck_wwid == RECHECK_WWID_ON &&
 	    (newstate == PATH_UP || newstate == PATH_GHOST) &&
@@ -2434,14 +2442,14 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 	     pp->dmstate == PSTATE_FAILED) &&
 	    check_path_wwid_change(pp)) {
 		condlog(0, "%s: path wwid change detected. Removing", pp->dev);
-		handle_path_wwid_change(pp, vecs);
-		return 0;
+		return handle_path_wwid_change(pp, vecs)? CHECK_PATH_REMOVED :
+							  CHECK_PATH_SKIPPED;
 	}
 	if (!pp->mpp->is_checked) {
 		do_sync_mpp(vecs, pp->mpp);
 		/* if update_multipath_strings orphaned the path, quit early */
 		if (!pp->mpp)
-			return 0;
+			return CHECK_PATH_SKIPPED;
 	}
 	if ((newstate != PATH_UP && newstate != PATH_GHOST &&
 	     newstate != PATH_PENDING) && (pp->state == PATH_DELAYED)) {
@@ -2452,7 +2460,7 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 		 * to the shortest delay
 		 */
 		pp->checkint = checkint;
-		return 1;
+		return CHECK_PATH_CHECKED;
 	}
 	if ((newstate == PATH_UP || newstate == PATH_GHOST) &&
 	    (san_path_check_enabled(pp->mpp) ||
@@ -2467,7 +2475,7 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 					 * in time */
 					pp->tick = 1;
 				pp->state = PATH_DELAYED;
-				return 1;
+				return CHECK_PATH_CHECKED;
 			}
 			if (!pp->marginal) {
 				pp->marginal = 1;
@@ -2525,7 +2533,7 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 			pp->mpp->failback_tick = 0;
 
 			pp->mpp->stat_path_failures++;
-			return 1;
+			return CHECK_PATH_CHECKED;
 		}
 
 		if (newstate == PATH_UP || newstate == PATH_GHOST) {
@@ -2604,7 +2612,7 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 	pp->state = newstate;
 
 	if (pp->mpp->wait_for_udev)
-		return 1;
+		return CHECK_PATH_CHECKED;
 	/*
 	 * path prio refreshing
 	 */
@@ -2631,12 +2639,9 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 				switch_pathgroup(pp->mpp);
 		}
 	}
-	return 1;
+	return CHECK_PATH_CHECKED;
 }
 
-/*
- * Returns -1 if the path was blacklisted, and 0 otherwise
- */
 static int
 handle_uninitialized_path(struct vectors * vecs, struct path * pp,
 			  unsigned int ticks)
@@ -2648,12 +2653,12 @@ handle_uninitialized_path(struct vectors * vecs, struct path * pp,
 
 	if (pp->initialized != INIT_NEW && pp->initialized != INIT_FAILED &&
 	    pp->initialized != INIT_MISSING_UDEV)
-		return 0;
+		return CHECK_PATH_SKIPPED;
 
 	if (pp->tick)
 		pp->tick -= (pp->tick > ticks) ? ticks : pp->tick;
 	if (pp->tick)
-		return 0; /* don't check this path yet */
+		return CHECK_PATH_SKIPPED;
 
 	conf = get_multipath_config();
 	retrigger_tries = conf->retrigger_tries;
@@ -2675,7 +2680,7 @@ handle_uninitialized_path(struct vectors * vecs, struct path * pp,
 				log_sysfs_attr_set_value(1, ret,
 							 "%s: failed to trigger change event",
 							 pp->dev);
-			return 0;
+			return CHECK_PATH_SKIPPED;
 		} else {
 			condlog(1, "%s: not initialized after %d udev retriggers",
 				pp->dev, retrigger_tries);
@@ -2706,10 +2711,16 @@ handle_uninitialized_path(struct vectors * vecs, struct path * pp,
 			ev_add_path(pp, vecs, 1);
 			pp->tick = 1;
 		} else if (ret == PATHINFO_SKIPPED) {
-			return -1;
+			int i;
+
+			condlog(1, "%s: path blacklisted. removing", pp->dev);
+			if ((i = find_slot(vecs->pathvec, (void *)pp)) != -1)
+				vector_del_slot(vecs->pathvec, i);
+			free_path(pp);
+			return CHECK_PATH_REMOVED;
 		}
 	}
-	return 0;
+	return CHECK_PATH_CHECKED;
 }
 
 enum checker_state {
@@ -2794,14 +2805,10 @@ checkerloop (void *ap)
 				else
 					rc = handle_uninitialized_path(vecs, pp,
 								       ticks);
-				if (rc < 0) {
-					condlog(1, "%s: check_path() failed, removing",
-						pp->dev);
-					vector_del_slot(vecs->pathvec, i);
-					free_path(pp);
+				if (rc == CHECK_PATH_REMOVED)
 					i--;
-				} else
-					num_paths += rc;
+				else if (rc == CHECK_PATH_CHECKED)
+					num_paths++;
 				if (++paths_checked % 128 == 0 &&
 				    (lock_has_waiters(&vecs->lock) ||
 				     waiting_clients())) {
diff --git a/multipathd/main.h b/multipathd/main.h
index 4fcd6402..7aa93ca3 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -47,7 +47,7 @@ int setup_multipath(struct vectors * vecs, struct multipath * mpp);
 int update_multipath(struct vectors *vecs, char *mapname);
 int reload_and_sync_map(struct multipath *mpp, struct vectors *vecs);
 
-void handle_path_wwid_change(struct path *pp, struct vectors *vecs);
+bool handle_path_wwid_change(struct path *pp, struct vectors *vecs);
 bool check_path_wwid_change(struct path *pp);
 int finish_path_init(struct path *pp, struct vectors * vecs);
 int resize_map(struct multipath *mpp, unsigned long long size,
-- 
2.45.0


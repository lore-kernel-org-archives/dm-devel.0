Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE3349644
	for <dm-devel@lists.linux.dev>; Mon, 22 Jul 2024 23:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721690597; cv=none; b=ezzVRlfzJFU2e+54gEYeD6P8pseEIjv/fD0QHUP3o3sgtOHsxM79ob7+lDuoFKpT/5iaCtB0NTYmz0rk1KOFe7psIRFc/y9Pr1UXfSLV/4oYzQside6hXHhZmc0A8Rc0uagsAgNvXcxDQBtsfzj6iehxJxZDmLjfKl7wqK/nrRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721690597; c=relaxed/simple;
	bh=iUQ+OMZawtgcZwGPAeE2Dgye3j2Jf3k/DJCu8WLNyEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rjglLke7Mj0PIBLxXJy4jqgITOtPEVl7mdQzoTQhPiHKdrNbVJYrVH7szGyvaMzRhWfKwTZHQxiPbgDNlArNia+JLB2ChGXTNgAoe4PmlAo/eTU2yHRo5OcZlE16AHTc0jVUlMS63KW+UxtRYfDKiMfVm2Yt8WbbryS+GJf51bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MEryoBxD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MEryoBxD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721690594;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wpM3OA0XPMigBJrRw0VvlLO7rINiCuWArnmJh1xhSEg=;
	b=MEryoBxDCQZ9iPydOOIXeJ7HWrgeDK3omXt0BtBmMzejoMPIisLDJrkvb4vielc/cvAsTk
	ElZ1svGSDT14nioEKyZHoeCMimY6CDP/5Hoe90/bGaaMsDwyA+ueRm6zwteCzjSETtQwND
	m7HHbWT0j2gyAzTaNYkND+ouyhIbKj8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-83-GqD5DksxM2Kj49f37iVNNQ-1; Mon,
 22 Jul 2024 19:23:12 -0400
X-MC-Unique: GqD5DksxM2Kj49f37iVNNQ-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B00F61956080;
	Mon, 22 Jul 2024 23:23:11 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F36F51955D45;
	Mon, 22 Jul 2024 23:23:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46MNN9hu2495980
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 22 Jul 2024 19:23:09 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46MNN9V02495979;
	Mon, 22 Jul 2024 19:23:09 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v3 17/20] multipathd: make multipath devices manage their path check times
Date: Mon, 22 Jul 2024 19:23:08 -0400
Message-ID: <20240722232308.2495956-4-bmarzins@redhat.com>
In-Reply-To: <20240722232308.2495956-1-bmarzins@redhat.com>
References: <20240722232308.2495956-1-bmarzins@redhat.com>
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

multipathd's path checking can be very bursty, with all the paths
running their path checkers at the same time, and then all doing nothing
while waiting for the next check time. Alternatively, the paths in a
multipath device might all run their path checkers at a different time,
which can keep the multipath device from having a coherent view of the
state of all of its paths.

This patch makes all the paths of a multipath device converge to running
their checkers at the same time, and spreads out when this time is for
the different multipath devices.

To do this, the checking time is divided into adjustment intervals
(conf->adjust_int), so that the checkers run at some index within this
interval. conf->adjust_int is chosen so that it is a multiple of all
possible pp->checkint values. This means that regardless of
pp->checkint, the path should always be checked on the same indexes,
each adjustement interval.

Each multipath device has a goal index. These are evenly spread out
between 0 and conf->max_checkint. Every conf->adjust_int seconds, each
multipath device should try to check all of its paths on its goal index.
If the multipath device's check times are not aligned with the goal
index, then pp->tick for the next check will be decremented by one, to
align it over time.

In order for the path checkers to run every pp->checkint seconds,
multipathd needs to track how long a path check has been pending for,
and subtract that time from the number of ticks till the checker is run
again. If the checker has been pending for more that pp->checkint,
the path will be rechecked on the next tick after the checker returns.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c  | 12 ++++++
 libmultipath/config.h  |  1 +
 libmultipath/structs.c |  1 +
 libmultipath/structs.h |  1 +
 multipathd/main.c      | 91 ++++++++++++++++++++++++++++++++++--------
 5 files changed, 89 insertions(+), 17 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 83fa7369..a59533b5 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -982,6 +982,18 @@ int _init_config (const char *file, struct config *conf)
 		conf->checkint = conf->max_checkint;
 	condlog(3, "polling interval: %d, max: %d",
 		conf->checkint, conf->max_checkint);
+	/*
+	 * make sure that that adjust_int is a multiple of all possible values
+	 * of pp->checkint.
+	 */
+	if (conf->max_checkint % conf->checkint == 0) {
+		conf->adjust_int = conf->max_checkint;
+	} else {
+		conf->adjust_int = conf->checkint;
+		while (2 * conf->adjust_int < conf->max_checkint)
+			conf->adjust_int *= 2;
+		conf->adjust_int *= conf->max_checkint;
+	}
 
 	if (conf->blist_devnode == NULL) {
 		conf->blist_devnode = vector_alloc();
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 384193ab..800c0ca9 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -147,6 +147,7 @@ struct config {
 	int minio_rq;
 	unsigned int checkint;
 	unsigned int max_checkint;
+	unsigned int adjust_int;
 	bool use_watchdog;
 	int pgfailback;
 	int rr_weight;
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 0a26096a..232b4230 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -149,6 +149,7 @@ uninitialize_path(struct path *pp)
 	pp->state = PATH_UNCHECKED;
 	pp->uid_attribute = NULL;
 	pp->checker_timeout = 0;
+	pp->pending_ticks = 0;
 
 	if (checker_selected(&pp->checker))
 		checker_put(&pp->checker);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 002eeae1..457d7836 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -360,6 +360,7 @@ struct path {
 	unsigned long long size;
 	unsigned int checkint;
 	unsigned int tick;
+	unsigned int pending_ticks;
 	int bus;
 	int offline;
 	int state;
diff --git a/multipathd/main.c b/multipathd/main.c
index 36e54587..b075b057 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2388,7 +2388,7 @@ enum check_path_return {
 };
 
 static int
-check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
+do_check_path (struct vectors * vecs, struct path * pp)
 {
 	int newstate;
 	int new_path_up = 0;
@@ -2400,14 +2400,6 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 	int marginal_pathgroups, marginal_changed = 0;
 	bool need_reload;
 
-	if (pp->initialized == INIT_REMOVED)
-		return CHECK_PATH_SKIPPED;
-
-	if (pp->tick)
-		pp->tick -= (pp->tick > ticks) ? ticks : pp->tick;
-	if (pp->tick)
-		return CHECK_PATH_SKIPPED;
-
 	conf = get_multipath_config();
 	checkint = conf->checkint;
 	max_checkint = conf->max_checkint;
@@ -2419,12 +2411,6 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 		pp->checkint = checkint;
 	};
 
-	/*
-	 * provision a next check soonest,
-	 * in case we exit abnormally from here
-	 */
-	pp->tick = checkint;
-
 	newstate = check_path_state(pp);
 	if (newstate == PATH_WILD || newstate == PATH_UNCHECKED)
 		return CHECK_PATH_SKIPPED;
@@ -2587,7 +2573,6 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 				condlog(4, "%s: delay next check %is",
 					pp->dev_t, pp->checkint);
 			}
-			pp->tick = pp->checkint;
 		}
 	}
 	else if (newstate != PATH_UP && newstate != PATH_GHOST) {
@@ -2640,6 +2625,77 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 	return CHECK_PATH_CHECKED;
 }
 
+static int
+check_path (struct vectors * vecs, struct path * pp, unsigned int ticks,
+	    time_t start_secs)
+{
+	int r;
+	unsigned int adjust_int, max_checkint;
+	struct config *conf;
+	time_t next_idx, goal_idx;
+
+	if (pp->initialized == INIT_REMOVED)
+		return CHECK_PATH_SKIPPED;
+
+	if (pp->tick)
+		pp->tick -= (pp->tick > ticks) ? ticks : pp->tick;
+	if (pp->tick)
+		return CHECK_PATH_SKIPPED;
+
+	conf = get_multipath_config();
+	max_checkint = conf->max_checkint;
+	adjust_int = conf->adjust_int;
+	put_multipath_config(conf);
+
+	r = do_check_path(vecs, pp);
+
+	/*
+	 * do_check_path() removed or orphaned the path.
+	 */
+	if (r == CHECK_PATH_REMOVED || !pp->mpp)
+		return r;
+
+	if (pp->tick != 0) {
+		/* the path checker is pending */
+		if (pp->state != PATH_DELAYED)
+			pp->pending_ticks++;
+		else
+			pp->pending_ticks = 0;
+		return r;
+	}
+
+	/* schedule the next check */
+	pp->tick = pp->checkint;
+	if (pp->pending_ticks >= pp->tick)
+		pp->tick = 1;
+	else
+		pp->tick -= pp->pending_ticks;
+	pp->pending_ticks = 0;
+
+	if (pp->tick == 1)
+		return r;
+
+	/*
+	 * every mpp has a goal_idx in the range of
+	 * 0 <= goal_idx < conf->max_checkint
+	 *
+	 * The next check has an index, next_idx, in the range of
+	 * 0 <= next_idx < conf->adjust_int
+	 *
+	 * If the difference between the goal index and the next check index
+	 * is not a multiple of pp->checkint, then the device is not checking
+	 * the paths at its goal index, and pp->tick will be decremented by
+	 * one, to align it over time.
+	 */
+	goal_idx = (find_slot(vecs->mpvec, pp->mpp)) *
+		   max_checkint / VECTOR_SIZE(vecs->mpvec);
+	next_idx = (start_secs + pp->tick) % adjust_int;
+	if ((goal_idx - next_idx) % pp->checkint != 0)
+		pp->tick--;
+
+	return r;
+}
+
 static int
 handle_uninitialized_path(struct vectors * vecs, struct path * pp,
 			  unsigned int ticks)
@@ -2799,7 +2855,8 @@ checkerloop (void *ap)
 					continue;
 				pp->is_checked = true;
 				if (pp->mpp)
-					rc = check_path(vecs, pp, ticks);
+					rc = check_path(vecs, pp, ticks,
+							chk_start_time.tv_sec);
 				else
 					rc = handle_uninitialized_path(vecs, pp,
 								       ticks);
-- 
2.45.0


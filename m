Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C512A3A1B6
	for <dm-devel@lists.linux.dev>; Sat, 13 Jul 2024 06:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720850720; cv=none; b=LOgJuCTMnpFlCjl0cmvPOEDM0r5pKskK4wQBvoU6iSctJlPzZO+lY13G3gPrZIJAX3Vi/3GXIJBADpFmHvTmNs1m8tR6eBqRf60I4Z09OC7nDt5QVqjuCH+mveZGIqHbX/MUxTJgdYoPIlh5Dqhff5VaOMvWNlx4HCgVmlCqnv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720850720; c=relaxed/simple;
	bh=UgpOLZvJcSAO42qfd//iC2MecIxeNepMwJUH85gx0ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uDzp+l46I5dvge6LiW1vEaPjefby6Erqc5T25l3KmB5VXO7q4Y2tM4vxocaJEz6NhLTIuiezMsbxxEPHqQzMIjm7vB1sqaDwrKK2MxnDZRVsTeaEXPCAgdjBeOoYgbaiErRD7yKn53oznnPdPB8Jw72uifvl3X9gqe33vyyAjc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eOuNfiK7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eOuNfiK7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720850717;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KIJjceIgCuVfdt5qgOlWOqLjdtq+BC1ahvWyAXy99UQ=;
	b=eOuNfiK7BPZA5VgR6XEq2zhl7+IqyTQXPmhVwPLgkB0azPfU6R1jby1/VgMc2B6u37Zqax
	1NHtoqirmIe+TCaCHzK41x1sYziZlHO//MtCUOdiBQ80P7SbYh8CFmdTI+dAbex1PKNYXr
	Km6fYbD3etC4x0cC8UijMyn8ACbMykY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-396-Vr7-oh7cMTiHM7kgblpoag-1; Sat,
 13 Jul 2024 02:05:13 -0400
X-MC-Unique: Vr7-oh7cMTiHM7kgblpoag-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 25CE61956080;
	Sat, 13 Jul 2024 06:05:12 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B2ED61955F40;
	Sat, 13 Jul 2024 06:05:11 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46D65AMk2015570
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 13 Jul 2024 02:05:10 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46D65AiV2015569;
	Sat, 13 Jul 2024 02:05:10 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 19/22] multipathd: make multipath devices manage their path check times
Date: Sat, 13 Jul 2024 02:05:03 -0400
Message-ID: <20240713060506.2015463-20-bmarzins@redhat.com>
In-Reply-To: <20240713060506.2015463-1-bmarzins@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
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
interval. conf->adjust_int is chosen so that it is at least twice as
long as conf->max_checkint, and is a multiple of all possible
pp->checkint values. This means that regardless of pp->checkint, the
path should always be checked on the same indexes, each adjustement
interval.

Each multipath device has a goal index. These are evenly spread out
between 0 and conf->max_checkint. Every conf->adjust_int seconds, each
multipath device should try to check all of its paths on its goal index.
If a path isn't checked on the goal index, then pp->tick for the next
check after the goal_idx will be decremented by one, to align it over
time.

In order for the path checkers to run every pp->checkint seconds,
multipathd needs to track how long a path check has been pending for,
and subtract that time from the number of ticks till the checker is run
again. If the checker has been pending for more that pp->checkint,
the path will be rechecked on the next tick after the checker returns.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c  | 13 ++++++
 libmultipath/config.h  |  1 +
 libmultipath/structs.c |  1 +
 libmultipath/structs.h |  1 +
 multipathd/main.c      | 90 ++++++++++++++++++++++++++++++++++--------
 5 files changed, 89 insertions(+), 17 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 83fa7369..ca584372 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -982,6 +982,19 @@ int _init_config (const char *file, struct config *conf)
 		conf->checkint = conf->max_checkint;
 	condlog(3, "polling interval: %d, max: %d",
 		conf->checkint, conf->max_checkint);
+	/*
+	 * make sure that that adjust_int is at least twice as large
+	 * as checkint and is a multiple of all possible values of
+	 * pp->checkint.
+	 */
+	if (conf->max_checkint % conf->checkint == 0) {
+		conf->adjust_int = 2 * conf->max_checkint;
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
index 1583e001..472e1001 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -148,6 +148,7 @@ uninitialize_path(struct path *pp)
 	pp->dmstate = PSTATE_UNDEF;
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
index daf668eb..42ccb92f 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2386,7 +2386,7 @@ check_mpp(struct vectors * vecs, struct multipath *mpp, unsigned int ticks)
  * and '0' otherwise
  */
 static int
-check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
+do_check_path (struct vectors * vecs, struct path * pp)
 {
 	int newstate;
 	int new_path_up = 0;
@@ -2398,14 +2398,6 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 	int marginal_pathgroups, marginal_changed = 0;
 	bool need_reload;
 
-	if (pp->initialized == INIT_REMOVED)
-		return 0;
-
-	if (pp->tick)
-		pp->tick -= (pp->tick > ticks) ? ticks : pp->tick;
-	if (pp->tick)
-		return 0; /* don't check this path yet */
-
 	conf = get_multipath_config();
 	checkint = conf->checkint;
 	max_checkint = conf->max_checkint;
@@ -2417,12 +2409,6 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
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
 		return 0;
@@ -2584,7 +2570,6 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 				condlog(4, "%s: delay next check %is",
 					pp->dev_t, pp->checkint);
 			}
-			pp->tick = pp->checkint;
 		}
 	}
 	else if (newstate != PATH_UP && newstate != PATH_GHOST) {
@@ -2637,6 +2622,76 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 	return 1;
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
+		return 0;
+
+	if (pp->tick)
+		pp->tick -= (pp->tick > ticks) ? ticks : pp->tick;
+	if (pp->tick)
+		return 0; /* don't check this path yet */
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
+	if (r < 0 || !pp->mpp)
+		return r;
+
+	/*
+	 * the path checker is pending
+	 */
+	if (pp->tick != 0) {
+		pp->pending_ticks++;
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
+	 * Every adjust_int seconds, each multipath device should try to
+	 * check all of its paths on its goal_idx. If a path isn't checked
+	 * on the goal_idx, then pp->tick for the next check after the
+	 * goal_idx will be decremented by one, to align it over time.
+	 */
+	goal_idx = (find_slot(vecs->mpvec, pp->mpp)) *
+		   max_checkint / VECTOR_SIZE(vecs->mpvec);
+	next_idx = (start_secs + pp->tick) % adjust_int;
+	if (next_idx > goal_idx && next_idx - goal_idx < pp->checkint)
+		pp->tick--;
+
+	return r;
+}
+
 /*
  * Returns -1 if the path was removed, and 0 otherwise
  */
@@ -2799,7 +2854,8 @@ checkerloop (void *ap)
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


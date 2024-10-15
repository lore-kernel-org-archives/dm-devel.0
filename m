Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577B8170A30
	for <dm-devel@lists.linux.dev>; Tue, 15 Oct 2024 03:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728962924; cv=none; b=lR+0sDLN/nJM/0SbsRNkb/i9qh/chVIMFkca/U06TG2Zv7PvjfBSC2+1KINSKZvzhBroKr5CTRFMZjvL9IDvlen9fj5cAWsycszkWutcAaUG6KyPr6gRSo47pgK4aWnB+0tXjgjVfmWoaHa8xToliGeaRD99rqlQ+TgMxIvgH/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728962924; c=relaxed/simple;
	bh=wWPnR+o3byB0vhX6nlRIAyV5Xl/EVbcg+NTourlorjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X/Z7Dl9sPZpbkDqbs8498nLyFINoxZZKNRwncA3ZQDawUHDmDOrFZiUfLdrUFSw9WgBrMElRAQQO0GBds8hb3FZoB/FHW6EXXuYEyJ3JOE1hFXjPKl1DkwNumbPcilPfsMNF4m2pt5PPxVGSM0/48pCAGoC6wA4wEq+rwxvQo+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aUON/tCp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aUON/tCp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728962921;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3ocU7+I2+d1xMXa/ZMQZXn9qyzm2+esou0DE/soHhxk=;
	b=aUON/tCpxmYiLBGHL65OTjefdQQwj435LzQYWC340fpiKziaxvS4ul6oru1D2hdM81cYCf
	DPdPRgKNeCRADsSHi44snM76gHxv1BCXnwvLqqTHjDRl1SyEtDrRIPIPGxkshqdIFS8gpR
	BKKwY9lNDFPFoV38i2MPG5IhdX9TUT8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-437-UuDIdsfKNvuoIMdwBK-NCQ-1; Mon,
 14 Oct 2024 23:28:39 -0400
X-MC-Unique: UuDIdsfKNvuoIMdwBK-NCQ-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AC2BF195609D;
	Tue, 15 Oct 2024 03:28:38 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 773AA19560AE;
	Tue, 15 Oct 2024 03:28:38 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 49F3Sbxr2693327
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 23:28:37 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 49F3SbdP2693326;
	Mon, 14 Oct 2024 23:28:37 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v5 12/23] multipathd: split check_paths into two functions
Date: Mon, 14 Oct 2024 23:28:24 -0400
Message-ID: <20241015032835.2693247-13-bmarzins@redhat.com>
In-Reply-To: <20241015032835.2693247-1-bmarzins@redhat.com>
References: <20241015032835.2693247-1-bmarzins@redhat.com>
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

Instead of checking and updating each path, the checkerloop now starts
the checkers on all the paths in check_paths(), and then goes back and
updates all the paths in update_paths(). Since the async checkers use an
absolute time to wait for before returning PATH_PENDING, only one
checker actually needs to be waited for in update_paths(). The rest will
already have reached their timeout when update_path() is called for
them.

The check_paths() and update_paths() loop over the pathvec instead of
looping through the multipath device paths to avoid having to restart
checking of the device paths when the multipath device needs to be
resynced while updating the paths.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs.h |  10 +++-
 multipathd/main.c      | 104 +++++++++++++++++++----------------------
 2 files changed, 56 insertions(+), 58 deletions(-)

diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index d8231e95..af8e31e9 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -314,6 +314,14 @@ enum recheck_wwid_states {
 	RECHECK_WWID_ON = YNU_YES,
 };
 
+enum check_path_states {
+	CHECK_PATH_UNCHECKED,
+	CHECK_PATH_STARTED,
+	CHECK_PATH_CHECKED,
+	CHECK_PATH_SKIPPED,
+	CHECK_PATH_REMOVED,
+};
+
 struct vpd_vendor_page {
 	int pg;
 	const char *name;
@@ -395,7 +403,7 @@ struct path {
 	int fast_io_fail;
 	unsigned int dev_loss;
 	int eh_deadline;
-	bool is_checked;
+	enum check_path_states is_checked;
 	bool can_use_env_uid;
 	unsigned int checker_timeout;
 	/* configlet pointers */
diff --git a/multipathd/main.c b/multipathd/main.c
index 89f02a3a..ca84331d 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2389,13 +2389,6 @@ sync_mpp(struct vectors * vecs, struct multipath *mpp, unsigned int ticks)
 	do_sync_mpp(vecs, mpp);
 }
 
-enum check_path_return {
-	CHECK_PATH_STARTED,
-	CHECK_PATH_CHECKED,
-	CHECK_PATH_SKIPPED,
-	CHECK_PATH_REMOVED,
-};
-
 static int
 update_path_state (struct vectors * vecs, struct path * pp)
 {
@@ -2776,6 +2769,10 @@ update_uninitialized_path(struct vectors * vecs, struct path * pp)
 	int newstate, ret;
 	struct config *conf;
 
+	if (pp->initialized != INIT_NEW && pp->initialized != INIT_FAILED &&
+	    pp->initialized != INIT_MISSING_UDEV)
+		return CHECK_PATH_SKIPPED;
+
 	newstate = get_new_state(pp);
 
 	if (!strlen(pp->wwid) &&
@@ -2805,80 +2802,69 @@ update_uninitialized_path(struct vectors * vecs, struct path * pp)
 
 enum checker_state {
 	CHECKER_STARTING,
-	CHECKER_RUNNING,
+	CHECKER_CHECKING_PATHS,
+	CHECKER_UPDATING_PATHS,
 	CHECKER_FINISHED,
 };
 
 static enum checker_state
-check_paths(struct vectors *vecs, unsigned int ticks, int *num_paths_p)
+check_paths(struct vectors *vecs, unsigned int ticks)
 {
 	unsigned int paths_checked = 0;
 	struct timespec diff_time, start_time, end_time;
-	struct multipath *mpp;
 	struct path *pp;
-	int i, rc;
+	int i;
 
 	get_monotonic_time(&start_time);
 
-	vector_foreach_slot(vecs->mpvec, mpp, i) {
-		struct pathgroup *pgp;
-		struct path *pp;
-		int j, k;
-		bool check_for_waiters = false;
-		/* maps can be rechecked, so this is not always 0 */
-		int synced_count = mpp->synced_count;
-
-		vector_foreach_slot (mpp->pg, pgp, j) {
-			vector_foreach_slot (pgp->paths, pp, k) {
-				if (!pp->mpp || pp->is_checked)
-					continue;
-				pp->is_checked = true;
-				rc = check_path(pp, ticks);
-				if (rc == CHECK_PATH_STARTED)
-					rc = update_path(vecs, pp,
-							 start_time.tv_sec);
-				if (rc == CHECK_PATH_CHECKED)
-					(*num_paths_p)++;
-				if (++paths_checked % 128 == 0)
-					check_for_waiters = true;
-				/*
-				 * mpp has been removed or resynced. Path may
-				 * have been removed.
-				 */
-				if (VECTOR_SLOT(vecs->mpvec, i) != mpp ||
-				    synced_count != mpp->synced_count) {
-					i--;
-					goto next_mpp;
-				}
-			}
-		}
-next_mpp:
-		if (check_for_waiters &&
+	vector_foreach_slot(vecs->pathvec, pp, i) {
+		if (pp->is_checked != CHECK_PATH_UNCHECKED)
+			continue;
+		if (pp->mpp)
+			pp->is_checked = check_path(pp, ticks);
+		else
+			pp->is_checked = check_uninitialized_path(pp, ticks);
+		if (++paths_checked % 128 == 0 &&
 		    (lock_has_waiters(&vecs->lock) || waiting_clients())) {
 			get_monotonic_time(&end_time);
 			timespecsub(&end_time, &start_time, &diff_time);
 			if (diff_time.tv_sec > 0)
-				return CHECKER_RUNNING;
+				return CHECKER_CHECKING_PATHS;
 		}
 	}
+	return CHECKER_UPDATING_PATHS;
+}
+
+static enum checker_state
+update_paths(struct vectors *vecs, int *num_paths_p, time_t start_secs)
+{
+	unsigned int paths_checked = 0;
+	struct timespec diff_time, start_time, end_time;
+	struct path *pp;
+	int i, rc;
+
+	get_monotonic_time(&start_time);
+
 	vector_foreach_slot(vecs->pathvec, pp, i) {
-		if (pp->mpp || pp->is_checked)
+		if (pp->is_checked != CHECK_PATH_STARTED)
 			continue;
-		pp->is_checked = true;
-
-		rc = check_uninitialized_path(pp, ticks);
-		if (rc == CHECK_PATH_STARTED)
+		if (pp->mpp)
+			rc = update_path(vecs, pp, start_secs);
+		else
 			rc = update_uninitialized_path(vecs, pp);
 		if (rc == CHECK_PATH_REMOVED)
 			i--;
-		else if (rc == CHECK_PATH_CHECKED)
-			(*num_paths_p)++;
+		else {
+			pp->is_checked = rc;
+			if (rc == CHECK_PATH_CHECKED)
+				(*num_paths_p)++;
+		}
 		if (++paths_checked % 128 == 0 &&
 		    (lock_has_waiters(&vecs->lock) || waiting_clients())) {
 			get_monotonic_time(&end_time);
 			timespecsub(&end_time, &start_time, &diff_time);
 			if (diff_time.tv_sec > 0)
-				return CHECKER_RUNNING;
+				return CHECKER_UPDATING_PATHS;
 		}
 	}
 	return CHECKER_FINISHED;
@@ -2946,10 +2932,14 @@ checkerloop (void *ap)
 				vector_foreach_slot(vecs->mpvec, mpp, i)
 					sync_mpp(vecs, mpp, ticks);
 				vector_foreach_slot(vecs->pathvec, pp, i)
-					pp->is_checked = false;
-				checker_state = CHECKER_RUNNING;
+					pp->is_checked = CHECK_PATH_UNCHECKED;
+				checker_state = CHECKER_CHECKING_PATHS;
 			}
-			checker_state = check_paths(vecs, ticks, &num_paths);
+			if (checker_state == CHECKER_CHECKING_PATHS)
+				checker_state = check_paths(vecs, ticks);
+			if (checker_state == CHECKER_UPDATING_PATHS)
+				checker_state = update_paths(vecs, &num_paths,
+							     start_time.tv_sec);
 			lock_cleanup_pop(vecs->lock);
 			if (checker_state != CHECKER_FINISHED) {
 				/* Yield to waiters */
-- 
2.45.0


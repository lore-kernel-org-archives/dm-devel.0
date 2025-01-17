Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB291A9B35
	for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 20:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737145677; cv=none; b=PwYGoGuJqc+nlX47PYJvLdub/yXMLD0LwGHf1BAQWjvdUbhQhq12oVRtwTguoJspH8xQyvHiQWzIw3GeU6GnuJxaF4KY+uHP22nOtNqUnokvqYG0kuACyrN8uY3fQxerk3i9CsAg6GOl5fMiFpS4eij9SypiNdLSyfizHV+ccxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737145677; c=relaxed/simple;
	bh=sZOHwAqDpipyKxKfNoAlh8Ak0TAGqtVc1Ii71Bqx1y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xb6RSd9/uQ9Ewge2oI/JIHIPDLlXjUO8M2jtVS4SU03+Foxm4H8aU/1TLMyj/uZCth7i+RIw6UC0hLDR7p0bjiantuibN4kelgGoPBCj70IzVfudCRYKR2Gs8EM/Ah4wW44ZNNNDZ6B8/kL5Ynr2Gb1yWv7lyNvDBsthdPqHfEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IzQSIasq; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IzQSIasq"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-385d7b4da2bso2238961f8f.1
        for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 12:27:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1737145673; x=1737750473; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RX46TXlaWZ179jdb2ilM9hHCnCASlGV3qH99y9qJfr8=;
        b=IzQSIasqeK8A9UU+6WEYdKJ7ah7IiSYmTDO9O/0JDcHrSuqypzI00RVspL7VM3LcEI
         sOn7CWAP8i+it4fN/kCwyS+hW4kCRvAwG86PCHNqQ9d6Vk5CHG5CyO4//BKIpr76YX6F
         FKePu1vHKS0G4JFMYocqJYtDUZ8W5zpQFnHon2RvPSMu+BW5/BjTprhCULnaLhJ+GKFB
         jjAY771BQAwPmQNtWDKZANotJF/dN14/UnRL/BUQKFFCnA6qC7uveZ3eGKDlPQHPNGhM
         +V+wUNSdVmrG0O3TCJhk0fgTtb2eD7yw6f/SsapqQQQVl6n8tYpk3O5XiBU8fFmdbq3w
         lf3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737145673; x=1737750473;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RX46TXlaWZ179jdb2ilM9hHCnCASlGV3qH99y9qJfr8=;
        b=N+9oLNtZ66HR2tMWq8ETDfNcM3TQBq2NtQkSCzCDO3toZyhopTZbfqrn4WZa8HgFfJ
         WUYf9gKm+qBrBMbQ3A1WlcwxKGqQGCRSmV5L0hi06d05FXvpZi7QB+meANJl15XNC0jg
         jX5AA9ODB69Pho0sovFVMWk20gkEemQusXkmT2KIEu7nylnQkQMiWO0+3Q+mSYYwDaJ+
         BmA1BDtaXO3eRL+cXtzmYwLZgeyk2Wd9Lx1jpLN2ZjxX2slZ9EvDmftBM4Xc0hyrzgHQ
         afyN6jA9SD3t8yu+Jqp5SZsMcZs2cXYqMEqBozlAxhJwCxoc99srR/FpZmdrPFNgA/Rf
         vjXg==
X-Gm-Message-State: AOJu0YxWTl3QTrae+LlBR3WlSRT3YAN1B58oQRn34X/f7YhZhvZlvTle
	/8ts31PpP4kdrrbKVbgBD1ap0RnJW8B8s8/AfTk6V5sgEIuuztpQsSn0a/7LT1JHVcMDmCs2YbZ
	G
X-Gm-Gg: ASbGncs5k04eQ4U7wzVKbAHdzT+IQbdrCPq90Ruif5T2NAXvV5+Zj5pdJ79Gq/TzMlp
	4HuTQrG705p4gwVX3coi/VraT+BfEZ4xIYdOOHuLAN/UIDwZmrKdPdkDvQ9qHJ58boKPAFGqdOt
	sN/lQekPlXWeucKo1WYTbYFtAI3OrqMcZtABgnLjFfkODSoERSWvARfqkkx6CODBh4m2ZF2TyHm
	Wit0+BHJGgyde2hTUDenq58/cZ0UXZAJ3UO7Kb7k9e6iUlQjjoaFWg/SxQ/pnlvvEM7p2gAELCy
	6AUuh0qva+wlIuC8IK1LNQCFT2YTeVwL1CnHRY+0Kcg=
X-Google-Smtp-Source: AGHT+IFXQvTg5q/AW3MrxAqwqt5fkeCGbmcUjDoiDhuldlGis19JRj4Se6JUpUcVUqCG7fsD9/NkVg==
X-Received: by 2002:a05:6000:1f8d:b0:385:d7f9:f157 with SMTP id ffacd0b85a97d-38bf57a749dmr4544306f8f.36.1737145673243;
        Fri, 17 Jan 2025 12:27:53 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-38bf3214df8sm3359932f8f.4.2025.01.17.12.27.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2025 12:27:52 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 03/15] multipathd: sync maps at end of checkerloop
Date: Fri, 17 Jan 2025 21:27:26 +0100
Message-ID: <20250117202738.126196-4-mwilck@suse.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250117202738.126196-1-mwilck@suse.com>
References: <20250117202738.126196-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rather than calling sync_mpp early in the checkerloop and tracking
map synchronization with synced_count, call sync_mpp() in the CHECKER_FINISHED
state, if either at least one path of the map has been checked in the current
iteration, or the sync tick has expired. This avoids potentially deleting
paths from the pathvec through the do_sync_mpp() -> update_multipath_strings()
-> sync_paths -> check_removed_paths() call chain while we're iterating over
the pathvec. Also, the time gap between obtaining path states and syncing
the state with the kernel is smaller this way.

Suggested-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs.h     |  2 +-
 libmultipath/structs_vec.c |  1 -
 multipathd/main.c          | 26 +++++++++++---------------
 3 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 6a30c59..9d22bdd 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -471,7 +471,7 @@ struct multipath {
 	int ghost_delay_tick;
 	int queue_mode;
 	unsigned int sync_tick;
-	int synced_count;
+	int checker_count;
 	enum prio_update_type prio_update;
 	uid_t uid;
 	gid_t gid;
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 7a4e3eb..6aa744d 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -530,7 +530,6 @@ update_multipath_table (struct multipath *mpp, vector pathvec, int flags)
 	conf = get_multipath_config();
 	mpp->sync_tick = conf->max_checkint;
 	put_multipath_config(conf);
-	mpp->synced_count++;
 
 	r = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY,
 			  (mapid_t) { .str = mpp->alias },
diff --git a/multipathd/main.c b/multipathd/main.c
index 4a28fbb..e4e6bf7 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2470,7 +2470,7 @@ sync_mpp(struct vectors * vecs, struct multipath *mpp, unsigned int ticks)
 	if (mpp->sync_tick)
 		mpp->sync_tick -= (mpp->sync_tick > ticks) ? ticks :
 				  mpp->sync_tick;
-	if (mpp->sync_tick)
+	if (mpp->sync_tick && !mpp->checker_count)
 		return;
 
 	do_sync_mpp(vecs, mpp);
@@ -2513,12 +2513,6 @@ update_path_state (struct vectors * vecs, struct path * pp)
 		return handle_path_wwid_change(pp, vecs)? CHECK_PATH_REMOVED :
 							  CHECK_PATH_SKIPPED;
 	}
-	if (pp->mpp->synced_count == 0) {
-		do_sync_mpp(vecs, pp->mpp);
-		/* if update_multipath_strings orphaned the path, quit early */
-		if (!pp->mpp)
-			return CHECK_PATH_SKIPPED;
-	}
 	if ((newstate != PATH_UP && newstate != PATH_GHOST &&
 	     newstate != PATH_PENDING) && (pp->state == PATH_DELAYED)) {
 		/* If path state become failed again cancel path delay state */
@@ -2918,9 +2912,11 @@ check_paths(struct vectors *vecs, unsigned int ticks)
 	vector_foreach_slot(vecs->pathvec, pp, i) {
 		if (pp->is_checked != CHECK_PATH_UNCHECKED)
 			continue;
-		if (pp->mpp)
+		if (pp->mpp) {
 			pp->is_checked = check_path(pp, ticks);
-		else
+			if (pp->is_checked == CHECK_PATH_STARTED)
+				pp->mpp->checker_count++;
+		} else
 			pp->is_checked = check_uninitialized_path(pp, ticks);
 		if (pp->is_checked == CHECK_PATH_STARTED &&
 		    checker_need_wait(&pp->checker))
@@ -3014,12 +3010,10 @@ checkerloop (void *ap)
 			pthread_cleanup_push(cleanup_lock, &vecs->lock);
 			lock(&vecs->lock);
 			pthread_testcancel();
-			vector_foreach_slot(vecs->mpvec, mpp, i)
-				mpp->synced_count = 0;
 			if (checker_state == CHECKER_STARTING) {
 				vector_foreach_slot(vecs->mpvec, mpp, i) {
-					sync_mpp(vecs, mpp, ticks);
 					mpp->prio_update = PRIO_UPDATE_NONE;
+					mpp->checker_count = 0;
 				}
 				vector_foreach_slot(vecs->pathvec, pp, i)
 					pp->is_checked = CHECK_PATH_UNCHECKED;
@@ -3032,11 +3026,13 @@ checkerloop (void *ap)
 							     start_time.tv_sec);
 			if (checker_state == CHECKER_FINISHED) {
 				vector_foreach_slot(vecs->mpvec, mpp, i) {
-					if ((update_mpp_prio(mpp) ||
-					     (mpp->need_reload && mpp->synced_count > 0)) &&
-					    reload_and_sync_map(mpp, vecs) == 2)
+					sync_mpp(vecs, mpp, ticks);
+					if ((update_mpp_prio(mpp) || mpp->need_reload) &&
+					    reload_and_sync_map(mpp, vecs) == 2) {
 						/* multipath device deleted */
 						i--;
+						continue;
+					}
 				}
 			}
 			lock_cleanup_pop(vecs->lock);
-- 
2.47.1


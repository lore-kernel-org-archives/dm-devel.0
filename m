Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284CD1EC4FF
	for <dm-devel@lists.linux.dev>; Wed, 11 Dec 2024 22:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733957984; cv=none; b=ODsNOzu/pChM+/h4bDt/1wCnrW45BQr+ic65UFRE7JsVqMr6AQ17ID9M53/mnoKnqz3gFRlipWBKB+Lf63rgxHrU/aIKA1lPP0sTDBywR+oAW6VFEcWsZaZuY/IF+c2Mp3dVHtKiOSy0A1LNxJDs15aEG4ksuqamGvnXi422Kfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733957984; c=relaxed/simple;
	bh=0QDGzQbtPqdNTozXX0mMTyFMLbTLlXtwC/nNVePloHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cWqLU+ct9e25rFobtUyUvXFtVlFGRvKphqAB3hkT70nz7TSEzFvSQFtQi4+N0YV6Xc4fp58SVzdU38vLILeOV1Cd6tYLO3dIZn9ZlW+fZrERbp5qeYI5d3GJujJMFiFAqVadcJ/+CNPFf7h7uLxPqUlEPtWo0xmCutdRUhYIsiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eptqk6oZ; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eptqk6oZ"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-aa696d3901bso652765866b.1
        for <dm-devel@lists.linux.dev>; Wed, 11 Dec 2024 14:59:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733957980; x=1734562780; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BgPJSin5jP5VRIqUQ9862eG8HLIn33QQmOwi7IYM680=;
        b=eptqk6oZrR6T1rDDZrp02+tpgS3T9qsUd01AmR1dVuIP+eomJ26WguZtbyQMcaiDjY
         IY7iW/OI6Ppu4IcyV1T+Adz+L8bDfrNGxDMlScMTOYMWxVpPM76lIZnutc6IFERhCr14
         JIb/j1v5qoQwn6lxpxXzacSXpCQxq/YM+d5hczWeIhvc5iCTlaMKOEQY6q/xTaQEUKNh
         LoU+0xHiFlecZ4IYzvqLMbtQz35VJ4/AAN+qwemrNWD9IuluRo94sU8eIS+ub0N33PQ7
         3Q2YtkDee4prqB8hXsIexc7jAZr0cDUodN3ktOnqynIxOll95nHXoMdHwYEsaqcOxipU
         cFeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733957980; x=1734562780;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BgPJSin5jP5VRIqUQ9862eG8HLIn33QQmOwi7IYM680=;
        b=XFkDt2GMD+cJClR9/n0saPrrLqQdZZc0nlLtozOISArFJ4DIYHeCwnI7QDQQncvoVZ
         65UvKsrNymOavDrwZiYcutrQ2FwqeJwqY3UPCBwi65L6ggkqlPSGZNYU5imnJQzc9n6w
         h19aFLWPwuV1pJoFA4nDiv/hm0wB7aIg2j1f11m9s0e3FPVhIZ1amP65TcSPj40GcTlx
         Cu0O6b1cVbTsO0ZSb+ArVWNmqpUgPckv8UY6tB4divP3i8vvH07iF93YJacdD02Y2Wb7
         6LBvnxkh0m/svyFSGETN+ErL3dU3QtXRDUN97oqDe4YPobT0Y6DWoFJXbYmZ3jC4h6JI
         Hrxw==
X-Gm-Message-State: AOJu0YwOj6QHJPtFJNVB6s5rjka0HHo/6KC/1ggVOE5vai2IL9DeR1h7
	Vuww3hGfTNeKbe190+ZZAvYN/Fazvk1QlHGIp6X3szJ2faxKiq0BaTJDg9/Qe3k=
X-Gm-Gg: ASbGncu6oVKv66l8rr+QCSTQL/HJtwADgYw1laNQSu+RfHjKFBIIiqDcEKdG5nckXXq
	7pk3CHu2Fx6mHMPf2BHUpazQZVy7oTs3uY+QeOsg6i18uUUM/J47vDafui1KJrwIDvmvg6cVjwO
	wTqyJEEnGWXjTioGtWln61OFtsNLYvoIP7zkqQweV2IiW3HXpToCPvwrmQz9Hj7lvd6ybL6lbAl
	kDa24e2npBDJH3OETjF5Zd/GxRGsG7NljCAylyiweZ2c6k2b1dNG827luBya5SCTsLCHwQKJ/TE
	K3mg4dJwXVJ+YsX7ngmJai3oaO8geU6UE6a3CdQP
X-Google-Smtp-Source: AGHT+IFNUDmpgsw5ke7ZaL48eLNTBfOAPkcikjGaMSE/lQy7fKkuNn3lv48hocbMFy45x4I8x+BBUA==
X-Received: by 2002:a17:907:9516:b0:aa6:841a:dff0 with SMTP id a640c23a62f3a-aa6c1b29e83mr137475566b.32.1733957980041;
        Wed, 11 Dec 2024 14:59:40 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-aa6a263efc1sm326205166b.68.2024.12.11.14.59.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2024 14:59:39 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 03/14] multipathd: sync maps at end of checkerloop
Date: Wed, 11 Dec 2024 23:58:58 +0100
Message-ID: <20241211225909.298770-4-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241211225909.298770-1-mwilck@suse.com>
References: <20241211225909.298770-1-mwilck@suse.com>
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
2.47.0


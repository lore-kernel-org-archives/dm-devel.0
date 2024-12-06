Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E89F212FB3
	for <dm-devel@lists.linux.dev>; Fri,  6 Dec 2024 23:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528210; cv=none; b=KMim0zRyXHUweaKzlP1lEEkHL1riad49/QHQpg6rqmngaDky6q+fK9WC8mJ4Gi3PTL2fLyO2LYC2j0lhJNCx/FQJgoqZVN2zpGnSlnDf3uANhEQkxcBJv8DoepE36x85OdjBZXXCOVh9rxdC9SvaSq9lNLBOUNSfOGh1LGDtwiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528210; c=relaxed/simple;
	bh=99uGPMq0omkWSLWdPVQDfNnPqGwKMmW9f1MHjsiGP+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tqEF2pwULbTFhhsyShE3XlDYTatTcSvJ0Rmdenll+NfLuCRQcvBCtvzHjdx7EH5mAkcOIMeJISKlr0AqKV6FXPwJ7UslPLJsccFAGQjzG8MjMa95uqKAojTEeWv2a21dAW/tlVmk/sTAHSIiVRzHzNgO585UM6DOOO3COjefnVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Xd+cOntt; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Xd+cOntt"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5d123ac1c3cso2747224a12.0
        for <dm-devel@lists.linux.dev>; Fri, 06 Dec 2024 15:36:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733528205; x=1734133005; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iJCJKhRUhIxt0DsHNnlVHOy+99tf5fNWISYxhL/xf8A=;
        b=Xd+cOnttF2JmZ2pOCtuSyo9bRVG/3i9au5xAb/HyLYErRHGyqOWb///iXj3qCtTvZ7
         BEyzTMDvMew8LbDYsMYB/iLiOqbIcuMROtuQl4hELx85Igudr6jUmHaEt/P/B1gqIbuG
         0Uoi4ZliGP4tjtFUNDXJ/s2KP9lobgJCYldDBzG9o5vRy1wFJP7gKXaEzkKsFMR/9H6j
         0SRDyhcoxSfpiz5o8rOWbjcs/OghsINgjhr2SI7RkPeH4wBwBhyW/LQrkzc0br+OgtBK
         Lraz3Xsbf6MbGUlCdXjsyb1ZgChsV3R5QPNB5zEqGTiefa8IvQeeKIQAkeCpeQ40Iaig
         1IzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733528205; x=1734133005;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iJCJKhRUhIxt0DsHNnlVHOy+99tf5fNWISYxhL/xf8A=;
        b=V6mEYp9JK6Q4zilP6/x+UIjVC1vZLpOXPHosdZscL98Cf02Hajhq1TGJoxtIrGGDG3
         p/6aJxv8T/IUuqPboZf0YgllXinDH5uDqEcTD6HsTooleHQaT522CpIEBBKTjK03UN7n
         JRz4kZTE7/0wqcfP0f0LECuR0gE2YQqfrb2K6fQNEdgnpF6HkCUp6a0Sk8vT1WCxCiCM
         xY2Qu2GqjHVDBThsXnzuUAPBL8HEMtxpRnx4MZI7RN7pok+WQvh6m/BP42eJqsGlVf9Y
         xiSFRuBtusgTaNPO5WrwYjF7U978yFlcCbl7dIIfhE3JyKZT0ckdqP/jtgIGl1KuyoJ9
         dRHw==
X-Gm-Message-State: AOJu0Yy3peyZsjLgzqlYaOrkq2lPmWI1Nxc6oXBummXUEEzpJnpEcB/H
	CfbRko92Gyvb5RKkJr/h9KQAuPeOYSnTjas6jVAdlegQmSa1Kr7iEC7BtUqk0R0=
X-Gm-Gg: ASbGncsR2vtcW3tULBhWshVrBhFo/ATuGHWxtGgNvmW+BGEO7NkjGVBv8aw7CCITjTU
	qx3YxwzBYIQyvzYmDD2olBKaCTvkduKpE1IN7irWs4PCa6Oxp9BMLFekfzcHMXD947dT//dOfjy
	uw3qBq31mbSt9B1KMTGrHrgomkPH2Ygcyfrf19vA/tqQ/Lr7eUXh8onbfwfnFrXU3YoXJ+M4oys
	RfHWN58r1ytMIkB6Q+J6565bLytNHP8+4hSX+FN1FJVvHZSOvwmgbKzZIYdhVB/t+ep4SjeToNW
	3ytCOyVxjlrUZnzPlnYFLR6Jak048L+6ac6o
X-Google-Smtp-Source: AGHT+IF197EoKhgthcz1+J3N44NxYkLhM9HzV296tI2R9ff/veDl6oYMG5STUHujxjBo8FrQJ4J+Cg==
X-Received: by 2002:a05:6402:2115:b0:5d0:8197:7ab3 with SMTP id 4fb4d7f45d1cf-5d3be6bd82fmr3552535a12.3.1733528205233;
        Fri, 06 Dec 2024 15:36:45 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-5d14c799affsm2694026a12.54.2024.12.06.15.36.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Dec 2024 15:36:44 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 03/13] multipathd: allow map removal in do_sync_mpp()
Date: Sat,  7 Dec 2024 00:36:07 +0100
Message-ID: <20241206233617.382200-4-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241206233617.382200-1-mwilck@suse.com>
References: <20241206233617.382200-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We previously didn't allow map removal inside the checker loop. But
with the late updates to the checkerloop code, it should be safe to orphan
paths and delete maps even in this situation. We remove such maps everywhere
else in the code already, whenever refresh_multipath() or setup_multipath()
is called.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 43 ++++++++++++++++++++-----------------------
 1 file changed, 20 insertions(+), 23 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 4a28fbb..131dab6 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2446,34 +2446,30 @@ get_new_state(struct path *pp)
 	return newstate;
 }
 
-static void
-do_sync_mpp(struct vectors * vecs, struct multipath *mpp)
+/* Returns true if the mpp was deleted */
+static int
+do_sync_mpp(struct vectors *vecs, struct multipath *mpp)
 {
-	int i, ret;
-	struct path *pp;
+	int ret;
+
+	ret = refresh_multipath(vecs, mpp);
+	if (ret)
+		return ret;
 
-	ret = update_multipath_strings(mpp, vecs->pathvec);
-	if (ret != DMP_OK) {
-		condlog(1, "%s: %s", mpp->alias, ret == DMP_NOT_FOUND ?
-			"device not found" :
-			"couldn't synchronize with kernel state");
-		vector_foreach_slot (mpp->paths, pp, i)
-			pp->dmstate = PSTATE_UNDEF;
-		return;
-	}
 	set_no_path_retry(mpp);
+	return 0;
 }
 
-static void
+static int
 sync_mpp(struct vectors * vecs, struct multipath *mpp, unsigned int ticks)
 {
 	if (mpp->sync_tick)
 		mpp->sync_tick -= (mpp->sync_tick > ticks) ? ticks :
 				  mpp->sync_tick;
 	if (mpp->sync_tick)
-		return;
+		return 0;
 
-	do_sync_mpp(vecs, mpp);
+	return do_sync_mpp(vecs, mpp);
 }
 
 static int
@@ -2513,12 +2509,10 @@ update_path_state (struct vectors * vecs, struct path * pp)
 		return handle_path_wwid_change(pp, vecs)? CHECK_PATH_REMOVED :
 							  CHECK_PATH_SKIPPED;
 	}
-	if (pp->mpp->synced_count == 0) {
-		do_sync_mpp(vecs, pp->mpp);
+	if (pp->mpp->synced_count == 0 && do_sync_mpp(vecs, pp->mpp))
 		/* if update_multipath_strings orphaned the path, quit early */
-		if (!pp->mpp)
-			return CHECK_PATH_SKIPPED;
-	}
+		return CHECK_PATH_SKIPPED;
+
 	if ((newstate != PATH_UP && newstate != PATH_GHOST &&
 	     newstate != PATH_PENDING) && (pp->state == PATH_DELAYED)) {
 		/* If path state become failed again cancel path delay state */
@@ -3018,8 +3012,11 @@ checkerloop (void *ap)
 				mpp->synced_count = 0;
 			if (checker_state == CHECKER_STARTING) {
 				vector_foreach_slot(vecs->mpvec, mpp, i) {
-					sync_mpp(vecs, mpp, ticks);
-					mpp->prio_update = PRIO_UPDATE_NONE;
+					if (sync_mpp(vecs, mpp, ticks))
+						/* map deleted */
+						i--;
+					else
+						mpp->prio_update = PRIO_UPDATE_NONE;
 				}
 				vector_foreach_slot(vecs->pathvec, pp, i)
 					pp->is_checked = CHECK_PATH_UNCHECKED;
-- 
2.47.0


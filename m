Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078F41A3179
	for <dm-devel@lists.linux.dev>; Wed,  7 Jan 2026 20:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767817145; cv=none; b=QQ6k/xsCz5hGJKR2v6n1qvCBK/y9GCJgsUTy5WjD0O96jGSHN/e+4VG5a2r4xLiWICg4cfFz4OYtTX3/uKXkpXttwN2jkYJktU1sH6lQ6AwfNUApjetS0H45+WbBQAMMP0VjyTz3k1MbaR/MEi6wvcgx4CsyQTE1A8ZZS152B5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767817145; c=relaxed/simple;
	bh=4FbtXa+mfNrxUv7SqnQtKOljLyxD9xsqIdDn3uofPL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X5SA7j5dOkoab1EFwvYQiV4i1lTxTq+LcedqzMQHaofV+kQjaI3mKpy/m+LulHyu5Arbk8HR3/Yuw9N+oCbv2sGaoo9cRrVa9tqa3tYoWjmj7nrZNxF5Oz4Z7/vcRXPB9bDgtZL1NjFPgxB8xvj7Xd9fEZ61BACVpKS/bdCVIYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=N9AuuGOA; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="N9AuuGOA"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-64b9d01e473so3812165a12.2
        for <dm-devel@lists.linux.dev>; Wed, 07 Jan 2026 12:18:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767817138; x=1768421938; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RQY5tC5ttfmxVAaDi+YFi6O90XDnx5JDOFaMhYRSaEo=;
        b=N9AuuGOAWsEUUD2m7XZ9JXSmv9RNit9lYxkdR/UEmflR85oAcJqL8ygEFO6/GDstPq
         KQ0ppkSjHwss1LhKVSwbr3+uKN5AW7PFGuxCG+G/Bh7yYXcFPzDtgnBXG0m5JUQrWLs/
         zxnN3WB6HGyLyPdbPUBKT2fI7nuHVTuBXNYCks43N7l7YSehtQGbh2+4yqlqkTybWLJj
         kxxLIDlZf646M+L5a0YEV28/GBLAnWwYOqUNDsOf64iOQHYLgx087QoHjyNgciT00f2j
         L+xdsTHi3SdkX/ZBpYg/DGWiUjWzbxOyT2QxuSzdfjiyN9uuBfe77z/8Q75sXXinIzFF
         UmIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767817138; x=1768421938;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RQY5tC5ttfmxVAaDi+YFi6O90XDnx5JDOFaMhYRSaEo=;
        b=GEMCGfxVflAywMgnZe7D/5IfrJRx3JG7yPIul5OXmcrxYNCz67KXMdsWEk/rHokMpA
         9ihMIQoSbj/iitUOtvExjUa1+mDnpQDpR4RsDjaB49NhTV+StXmcd38bz31gVDdgLdUy
         BOD+8Px7oUOrC/C1ZCoxHFwqxPYfLV+PzBY+iYIoa+gmEkk65MQetbTB6zcb/S1I3sll
         EnyDB6RSUAuK4BDSnbqvotq+iQOc3qqcpZKTVbvCEkjKyes0RJbm45F+7mcer92aQc1p
         LlXNgE0ipPFevNZ8yTWh7uLp1tqH1GCee/+XHSHzO7PlDpCIddu9x0LJ2lHeaXRiq6Pv
         cFKQ==
X-Gm-Message-State: AOJu0YwMOetgaeI+954oLUZvfokulK189OaFIvXy6lLQLyDIMQ3NBAyp
	6jBFHqw76j0/yAdwUMExv/C0aMHvxUGTPtoJ6Z1FP+ETl7U8bpvZZB9d/v1+FHG8GDE=
X-Gm-Gg: AY/fxX4HXCYUoSJCx/IgaYyqOXK3Rc/31+hbLYg+nNQJkwiQm/rzuZ0FbhFy43pvxy/
	gQ+IhJzMRqmtf6qEZ/vJrSL+qDCxUiXl2vDcAyV2++c6yFWIIRfM/wgBspR8FMpbOtBgpMDxffy
	UctErict2vO0cM9dthJUvxtmlGuHuapQIPLW30Npvs3Y9HV0YgWHIYpxsIAqHrQFW2tPKvgx46u
	AWr/We9dryPjadEPSHKl2KbxaITRS0cxffoG3sYw0X0wQjyDCntvl+TWQ2CowoSS//p650HV6FT
	4dqGsKYTUU6KNZGOVu+96jzRo6W72MbHoQ1kmrpstjsilFBcWSdR3odoorbDSFB43ZDWz+CKpLS
	lT2O7HgiZYEh7wTKIbCs9UAzdRCNsi9lfOCVXxMdQopO8hwkLnlF7WHGefgx+UwkK8dZ7h2/JLE
	khZrL6reD7e4cMmk2t+z9zKBuhWL9IuooDH41z9xNju8Yint18APnVE5aWghkJtGL1IAbDHm55R
	g==
X-Google-Smtp-Source: AGHT+IE1jZhiIRQMh85yFe5ndETyJsNDro7YussyWYHoISx2Ei2nRPKqyJZtiObhFLkeKxNSkYDZ8A==
X-Received: by 2002:a17:907:3d42:b0:b80:46f5:cabe with SMTP id a640c23a62f3a-b8444c4d2aemr417606466b.4.1767817138042;
        Wed, 07 Jan 2026 12:18:58 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b844e46ee63sm204995266b.15.2026.01.07.12.18.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jan 2026 12:18:57 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH v3 17/26] libmultipath: annotate functions that may free paths
Date: Wed,  7 Jan 2026 21:18:17 +0100
Message-ID: <20260107201826.323977-18-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260107201826.323977-1-mwilck@suse.com>
References: <20260107201826.323977-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Paths are freed in check_removed_paths() quite deeply in the call
stack. Annotate this function and some of its callers, lest we forget
about it.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs_vec.c | 33 +++++++++++++++++++++++++++++++--
 multipathd/main.c          | 10 ++++++----
 2 files changed, 37 insertions(+), 6 deletions(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 62b208b..0e8dc24 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -561,6 +561,34 @@ static struct path *find_devt_in_pathgroups(const struct multipath *mpp,
 	return NULL;
 }
 
+/*
+ * check_removed_paths()
+ *
+ * This function removes paths from the pathvec and frees them if they have
+ * been marked for removal (INIT_REMOVED, INIT_PARTIAL).
+ * This is important because some callers (e.g. uev_add_path->ev_remove_path())
+ * rely on the paths being actually gone when the call stack returns.
+ * Be sure not to call it while these paths are still referenced elsewhere
+ * (e.g. from coalesce_paths(), where curmp may still reference them).
+ *
+ * Most important call stacks in multipath-tools 0.13.0:
+ *
+ * checker_finished()
+ *   sync_mpp()
+ *     do_sync_mpp()
+ *       update_multipath_strings()
+ *         sync_paths()
+ *           check_removed_paths()
+ *
+ * [multiple callers including update_map(), ev_remove_path(), ...]
+ *   setup_multipath()
+ *     refresh_multipath()
+ *       update_multipath_strings()
+ *         sync_paths()
+ *           check_removed_paths()
+ *
+ * refresh_multipath() is also called from a couple of CLI handlers.
+ */
 static void check_removed_paths(const struct multipath *mpp, vector pathvec)
 {
 	struct path *pp;
@@ -581,6 +609,7 @@ static void check_removed_paths(const struct multipath *mpp, vector pathvec)
 	}
 }
 
+/* This function may free paths. See check_removed_paths(). */
 void sync_paths(struct multipath *mpp, vector pathvec)
 {
 	struct path *pp;
@@ -609,8 +638,8 @@ void sync_paths(struct multipath *mpp, vector pathvec)
 		pp->mpp = mpp;
 }
 
-int
-update_multipath_strings(struct multipath *mpp, vector pathvec)
+/* This function may free paths. See check_removed_paths(). */
+int update_multipath_strings(struct multipath *mpp, vector pathvec)
 {
 	struct pathgroup *pgp;
 	int i, r = DMP_ERR;
diff --git a/multipathd/main.c b/multipathd/main.c
index 34dedeb..190e24b 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -503,6 +503,7 @@ remove_maps_and_stop_waiters(struct vectors *vecs)
 	remove_maps(vecs);
 }
 
+/* This function may free paths. See check_removed_paths(). */
 int refresh_multipath(struct vectors *vecs, struct multipath *mpp)
 {
 	if (update_multipath_strings(mpp, vecs->pathvec) != DMP_OK) {
@@ -513,6 +514,7 @@ int refresh_multipath(struct vectors *vecs, struct multipath *mpp)
 	return 0;
 }
 
+/* This function may free paths. See check_removed_paths(). */
 int setup_multipath(struct vectors *vecs, struct multipath *mpp)
 {
 	if (refresh_multipath(vecs, mpp) != 0)
@@ -2517,8 +2519,8 @@ get_new_state(struct path *pp)
 	return newstate;
 }
 
-static int
-do_sync_mpp(struct vectors * vecs, struct multipath *mpp)
+/* This function may free paths. See check_removed_paths(). */
+static int do_sync_mpp(struct vectors *vecs, struct multipath *mpp)
 {
 	int i, ret;
 	struct path *pp;
@@ -2536,8 +2538,8 @@ do_sync_mpp(struct vectors * vecs, struct multipath *mpp)
 	return ret;
 }
 
-static int
-sync_mpp(struct vectors * vecs, struct multipath *mpp, unsigned int ticks)
+/* This function may free paths. See check_removed_paths(). */
+static int sync_mpp(struct vectors *vecs, struct multipath *mpp, unsigned int ticks)
 {
 	if (mpp->sync_tick)
 		mpp->sync_tick -= (mpp->sync_tick > ticks) ? ticks :
-- 
2.52.0


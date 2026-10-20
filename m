Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792529338;
	b=w3d4T9g7RMvCLj9bYdRkSvcN77rXpsqZKL1vKqV2GC1qVKct9aUV9Agct0CObE74Sy7r
	 rWjGCvwMlxSxIxF3PnNkRTN414wmRnoOqUQ9t540dBzElsvK7X8r/ZiriaU9Tz13O71tJ
	 Epv+f0E/r/XfRNQwJPj0yhpPbxdwUq8FzeTblfdPuqebcJMMa2LjEQKOFq3alY0Tm5zEE
	 xJ+SgXISkmIyW2cYax1A0R/mDBzITUqo0hcLua7rThYd4HMXqHhnXMViaGHt5KqAMjo9e
	 5R+r1aZ2FV3SUeV0udSHB6bwxBTAVn3NP/3fsYiprlSbFCEXeQnzRzSN2xuF4hQQlPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792529338;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=WbBI4Qddsspl3tG2TS3iGy3tfYGiPyJ96cZqKyYG2AI=;
	b=GV4omQAEmfuDYl9PZI1UAqxiOP/ltZChfE8DXrA0kFfTU9dMvBRndKVt7ReeqiXoN+2Y
	 RzgNjY7E3Vl/+dyz9sTYNwPFB6/X0Qg5l3FsnPtbzOBXtjFkEDzi/pqrv1j5bIgLf5hUJ
	 FDcII1AHDUxYhk5TlQqJ/g49ZpbdiH6a7nb/m/VeN0urdAHSxHSgK7Z31oVyz8bIllXNR
	 NeVuBLiuMAu32Ht1itVxArjGN1OClQANCYj87PplIMKxGXQ86HvUSCWKmnvkhM5C8Knag
	 JcQLV9NgM+yRqhGttsYtkByNmblZw8W+z97jb14cFezR1gVhjumrjDmMKQ1DhvXAiLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=QoMyX3AS;
	arc=none smtp.remote-ip=74.125.82.173
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD8B606A31F
	for <dm-devel@lists.linux.dev>; Tue, 20 Oct 2026 20:48:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7DD8B606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=QoMyX3AS
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-33bf40b0c8bso126eec.0
        for <dm-devel@lists.linux.dev>; Tue, 20 Oct 2026 13:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1792529336; x=1793134136; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WbBI4Qddsspl3tG2TS3iGy3tfYGiPyJ96cZqKyYG2AI=;
        b=QoMyX3ASuZsiQ/irnyYDfaQfY+IDAoH6Q3xhPOA/rzL34V5/L/Poq7WIOvkzX0ovVo
         vSQ9nMfOA0O0jMu8msZq3dNZVJIv+PZ8MktIH8onGQzwoStlX/XnCWpKh0GHgN2cTY8v
         6DEt02qERiB1q/p4Jzs+nIYVexC6xkm3RLmTCE1MQq1vjIwio3PQGsQ8lKUVY7WSWA0r
         yHZnxA7brIDIiwXnh3gFvvHbKj8VLntR1HansNcVgOtsXZgLtFtf7qXSI41PSgVy05p0
         rwWmRAqmSPtxefuf4BW6QNK1UbwDdbKDaI875LsqAi5zE7qvvgPsBm35qP5fu3ga42m/
         siCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792529336; x=1793134136;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WbBI4Qddsspl3tG2TS3iGy3tfYGiPyJ96cZqKyYG2AI=;
        b=uXF2Qh+y9I+F5zku4hiPAn1+hl/Ks0eoVAoZIjzCKlz7vnmmbc+LJGYwaME7LscJkJ
         2jVpUN0aMpHCWwXF/Qu7wYDnuZk9bBsk/YN+1jGhIyzQLC/N54Ca70Z/gPfW4uphhRjs
         opDIjc3ND9xPBBcwVQfJXhZUtiPiWuyEo912GN1kX0w9FhwWiislJEKKPJ71qEBW435N
         TQy4OqwoF4/U6d8/tQ/zf6pTt9owtCmguAVzDP9INhyrfaKHp+kWKpO05n2zKRylK2Kz
         A3Czci6MjvrapFrqt0lvKTQ9C6T/pUCDFoET5l/yv5ynpeqUMGGPBU5gqFS/S5aG+1Qm
         28Ag==
X-Gm-Message-State: AFq9FYINknvFgX++LD9DKCFoE0eISRLtLqzsM5snp0pFvJnctBv/39Ru
	6acFBhSoaQBjVvbG/PvDElTJ7GtXyCAtReweWSMjrSw2qiLS3tR64RQd6pMyqztYyJ4arr6wNO5
	97tYeTGhp7eOsL/W/q+58Rd2nYyf5KpT8qWm98K8QCUyr9qLaLgOU28MUryorzje9xYO9a4hIU/
	LE38gHA8dGTSGworzhQSbjSRk9TutedYr1oVt92Hv7DHAxDpM=
X-Gm-Gg: AYBFou1WTuE9mE38BaKu1ROeJHuASTvxRc7sFPuO5ghgdYLl6njpn+yW4TRjysXb0Mv
	Q7vdL/WuaGfXgegIXYpssCD/SVYBAK2/yJRibzCQ/aQjYUgceQOS+LBm4VSWWOZ8VdJMhy7vhFy
	78ottoZVlEmTuyMtZ9VdjC9e1jj6APBudyk2eHWmjOOSd8uIEzPV1CULcoWwCdtZrb6FzwDDgPx
	RWgVPnuV+sASw28n0MXduDTjFIZMlKwZ5rwYtC5oezFQYXed6FL0j7j1+NUmmuyetJyNDop3MZR
	SOKyIuGWX0ks9pDXKzn4vkmcm1kPuuRUEleSpDubQdNhji7r4cbxUMJir+5oC7jfWAkQBB+E+Gk
	JHBec4pMw7j8eAObbZw8oM8Jv5sJG7aALEx5Ks2QjSLqrZvhUxqpFr6VxiQ+1GD0YouDj1s9uwn
	7aQhLh5s1/PggLW8puRyiWjM8qx8eawf7XYMtByPhP6ghAxKOATBvZld4yeo5QYHjyC71UGgyiu
	JN2usIPb6f9Icj3n0p2A50BT8zbMIVj+wF9W+aD44fTtc533VlgeHet98Si1MqmjPHvS1FwHium
	7EmhIitZJ9KyiLKqwxuMT8R+ua8Y6V22NPndQr3Nx+UBheAin7YW3CGn3TgTOGL6KMmJAgk=
X-Received: by 2002:a05:701b:21c8:b0:143:5266:48ee with SMTP id a92af1059eb24-18514634391mr15036879c88.42.1792529336110;
        Tue, 20 Oct 2026 13:48:56 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.106])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1903a180adasm954412c88.8.2026.10.20.13.48.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 20 Oct 2026 13:48:55 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: dm-devel@lists.linux.dev
Cc: Brian Bunker <brian@purestorage.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH 1/1] multipathd: don't leave maps read-only after write protect is cleared
Date: Tue, 20 Oct 2026 13:48:39 -0700
Message-ID: <20261020204841.50459-2-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261020204841.50459-1-brian@purestorage.com>
References: <20261020204841.50459-1-brian@purestorage.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ev_add_path() sets mpp->force_readonly when a newly added path is
read-only, but never clears it. If a map is created or reloaded while
its storage is write protected, the flag stays set. When write protect
is cleared, the reload that uev_update_path() does for the DISK_RO=0
uevent uses the stale flag and loads the map read-only, even though all
of its paths are read-write. uev_update_path() clears the flag after
that reload, so the map only recovers if another DISK_RO=0 uevent
reloads it again. If none comes, the map stays read-only, and since
mpp->dmi.read_only is then 1, needs_ro_update() also ignores later
DISK_RO=1 uevents for it.

Add a helper, map_has_ro_path(), that checks whether any of a map's
paths is read-only in sysfs, and use it to set force_readonly:

- In ev_add_path(), set force_readonly from all of the map's paths
  rather than only the path being added, and clear it once the map has
  been loaded, as uev_update_path() already does after its reload. With
  need_do_map == 0 the flag is left set for the call that loads the map.

- In uev_update_path(), set force_readonly from the paths' current
  state in sysfs instead of from the uevent. The kernel updates the ro
  attribute before it sends the DISK_RO uevent, so sysfs is current
  when the uevent is handled.

- In update_map(), which does reloads that were delayed while the map
  was waiting for udev (UDEV_WAIT_RELOAD), recompute force_readonly
  before setting up the map, since the paths' state may have changed
  since it was last set.

Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 multipathd/main.c | 44 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 37 insertions(+), 7 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 9bce4d6b..68916256 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -709,6 +709,22 @@ void cleanup_reset_vec(struct vector_s **v)
 	vector_reset(*v);
 }
 
+static int sysfs_get_ro(struct path *pp);
+
+/* A map must be loaded read-only if any of its paths is read-only. */
+static bool
+map_has_ro_path(struct multipath *mpp)
+{
+	struct path *pp;
+	unsigned int i;
+
+	vector_foreach_slot (mpp->paths, pp, i) {
+		if (sysfs_get_ro(pp) == 1)
+			return true;
+	}
+	return false;
+}
+
 static int
 update_map (struct multipath *mpp, struct vectors *vecs, int new_map)
 {
@@ -732,6 +748,13 @@ retry:
 
 	mpp->action = ACT_RELOAD;
 
+	/*
+	 * This may be a delayed reload, and the paths' write protect
+	 * state may have changed since force_readonly was last set.
+	 * Recompute it from the current paths.
+	 */
+	mpp->force_readonly = map_has_ro_path(mpp);
+
 	if (setup_map(mpp, &params, vecs)) {
 		condlog(0, "%s: failed to setup new map in update", mpp->alias);
 		retries = -1;
@@ -1305,7 +1328,6 @@ ev_add_path (struct path * pp, struct vectors * vecs, int need_do_map)
 	int retries = 3;
 	int start_waiter = 0;
 	int ret;
-	int ro;
 	unsigned char prflag = PR_UNSET;
 
 	/*
@@ -1370,10 +1392,11 @@ rescan:
 			goto fail; /* leave path added to pathvec */
 	}
 
-	/* ro check - if new path is ro, force map to be ro as well */
-	ro = sysfs_get_ro(pp);
-	if (ro == 1)
-		mpp->force_readonly = 1;
+	/*
+	 * Load the map read-only if any of its paths is read-only,
+	 * not just the one being added.
+	 */
+	mpp->force_readonly = map_has_ro_path(mpp);
 
 	if (!need_do_map)
 		return 0;
@@ -1400,6 +1423,8 @@ rescan:
 		sleep(1);
 		ret = domap(mpp, params, 1);
 	}
+	/* force_readonly only applies to this load, as in uev_update_path() */
+	mpp->force_readonly = 0;
 	if (ret == DOMAP_FAIL || ret == DOMAP_RETRY) {
 		condlog(0, "%s: failed in domap for addition of new "
 			"path %s", mpp->alias, pp->dev);
@@ -1732,8 +1757,13 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 			if (mpp->wait_for_udev != UDEV_WAIT_DONE)
 				mpp->wait_for_udev = UDEV_WAIT_RELOAD;
 			else {
-				if (ro == 1)
-					pp->mpp->force_readonly = 1;
+				/*
+				 * force_readonly may be stale from ev_add_path().
+				 * Set it from the paths' current state in sysfs,
+				 * which the kernel updates before sending the
+				 * uevent, rather than from the uevent itself.
+				 */
+				pp->mpp->force_readonly = map_has_ro_path(mpp);
 				retval = reload_and_sync_map(mpp, vecs);
 				if (retval == 2)
 					condlog(2, "%s: map removed during reload", pp->dev);
-- 
2.56.0


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793665925;
	b=Ynm7bpB1EVXBRZb4fkYMMfe7j24d7aPz6QlFR4FF501GoWhmr2cjIJcAh7IRX18P7rx0
	 Qmj3w46JkE6JhlOvi631dq3fUyRZwrePq1NVkbRT71hiv8lAKIUhYKtoOlqnbehhSPqvF
	 Nj1G1rAuZLtlEujiZaPy4QdU53gDwrI17xFkVS+I7qjJE9jNX244Fo6TgGNxZBxrrtV7x
	 sumReseG3ddcWMrhYm+GBeIdQSERDqXN3R9ebEitrfCOjh1G/hj1EG8SiVqlJiU2LiT/R
	 S3kGKOa5oAtq6Do93Sh0MvECko1XDon35s71kzy2aY2EbWn0kRzkzusuygsMBnwbwdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793665925;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Nc+re5jC4fmenvJQpiA7tMbYZQqND4ERNzqQ2Z2xd8Y=;
	b=bFc9oYT1DxWCt/LixAkYJSpWDvmSFhWTpL6a0kYl+FibXpU9xbeOFTZyArzhWWYhSCB/
	 RWtis6jUI6B2sgXiD+LLogVFCgsS1Hw+xdd9gS6R/2weW9zsY762/u8g7E8BP05YmGVpe
	 InomMhOVb3psZuOGWJe+gzRt6MWLMePGZXx8kyx6wrbul3G4l5unJx6kbPzIZQNCn8WLR
	 Xmy2pZV5p22UJgyscxWpi4yfo7LXdTqYj9b3IpsuunOfS9j+FS7XlqN4xDXJNOB9n5cAF
	 4dVmHB6cvbEZYXfAN67hMVQelSuscYkLi6Tn1354ZrNQMNku3MPl0Fab/QIH1BRJMLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=bF+jcwXB;
	arc=none smtp.remote-ip=74.125.82.50
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE37A606A32C
	for <dm-devel@lists.linux.dev>; Tue,  3 Nov 2026 00:32:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DE37A606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=bF+jcwXB
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-1a2af4c8d00so5144504c88.0
        for <dm-devel@lists.linux.dev>; Mon, 02 Nov 2026 16:32:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1793665924; x=1794270724; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Nc+re5jC4fmenvJQpiA7tMbYZQqND4ERNzqQ2Z2xd8Y=;
        b=bF+jcwXBP0WnH9lm2X/Ys7fdmMxdzI+JuZ7+nuFRKV9Gin6H/psEmV15akxibtCruL
         ebRnIH9/N2qo69prYoz41JZpzMw4J1HrahDiHpUq2l8N5DxxlyEnuK8OyDNtCXZoPPml
         Wq00U8sPyL1ADKCPHERnnpztJFg4jCpTJ4FjXOFqvy0rPEUNIyLKerZOw3Rf9cN7r6ZE
         73czK0qQOFxrq15OOGR3Qm8UOkixgcFf0AI64s9FZBx3lwFmMh0NwCBE6INN4+DqCV+O
         fcVLGmnEwtrdehxJG1zghDQ2k8vU8HFfdL+S4LYaVZY4DvJzshoLZUdTnj0OiETQ1u9M
         JSnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793665924; x=1794270724;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Nc+re5jC4fmenvJQpiA7tMbYZQqND4ERNzqQ2Z2xd8Y=;
        b=rKlRywKyRuxTqhSxY1TaZeSlNvHZqvlWtZKJZezjLeR8f3w+LRzuoNwQ2agfms6mcY
         DAJavlpnBLUQS72WnCy+48YSZ0z9zIc7VK2QyQSM1lI5Ldj7Vx8zxXJ7q1vXXMK4v8wh
         7CCXRJkQiwFw+40RUe25iC0+fdBjQ6uKjhwy4RE2cOtVhJQlYJfSabHtiCvnCmENLOiu
         9DdPOMPcJKYTsp8EHhMt9NSKj7hgHrbxz3qPAYWHlAyLemD1UPtoqBPl0jfpo+2Oz2C/
         m+6oWZ0ntnYmaFT0iUtWWbGc8466MSJkvTen1Lo86x+YS4agOxqjrTvT/0Tx4pn218eB
         8EXg==
X-Gm-Message-State: AFq9FYJrhueqY4nnS5hORTzLGjWOvWotn8rmUswfDwbrtQkRrGcTWAtf
	gu0sYhmuqfXdQs55XMx4us4IDiMo4nlQGQOh7YCWXy4wsjdz/Lz1ONNBn0Ola+yuU4H3TRjNrqL
	K7FWju+/LFy4FdywqIDqT4Yjb/bcaKp8Q0ntAzR/EAHDQkKHX2n+iHBk60AmmP5CUvv5sHwia1a
	cGRsLg+NsdVDc/ezW5T6ZObeUZd+4IEkEvAEWtxbe8d/fHEAI=
X-Gm-Gg: AYBFou0+efDFarwVoYEs0FVEzXlIkp7mkqYExQy6SnrqWuxq2KyjIIKrov7e0EdQ0UP
	J9dfs+gWTugfKuWm5EL4Isteuechks71wQOK46H9ZO620T+Dnj9xhy0jjhhgkfsp0l2U27EBJtt
	IXYF1LqbDc1aArjB7/sR0iwc0hJ8wdOyPEJ5xI2FbhUweG+5TVRugXIIz9mZR+QqSDmpMIPb9t6
	jY/jx0Wf2PSftCm+h0PXZVeLYYv1Cd36+bpfl51zIF1/eKUosgmdYgILrnuu5f76nvoy7FH4QSs
	kMNzqryIQFlbi2k6t9nUIWzRf3Q+ZuCbTtmxZhzpcmP1pePFR8wimi/UU+7j9Zz/eVGThqUGq7o
	TsK2XGIJeZmp+78S7VJSKZlLaTASV+qpDoXn8teN6iuYEg9jLEG0p1bSb4KIBVQWYsPRowBnymd
	TyMtYCmJwoBntHFg0nhNjivg6L4AZQvwnE89Ut576T1sDNYJWlaEDpGzC+VMFSVXjYIPWjWiqz5
	3QxLdid4nehg9CYKide4KgvsY9nZNGJC0m1JSXZpveLgjFlRDyHj8GnveuqvlIy9MfNmZlxzAlX
	g+hHmwZVkactMaIajxhBy2m7/WGOyZ5sYDF3cTDGaI6wkbEdeAjq6AQKRcqPFphUThYHh02W/Pt
	NY+S+ixdgeBreYlC32WCuFhuviVhckWWgluKIR6xVbrGCiFSNLp4Z/wIz8hmXbT3KD67I+MU2Nf
	mo3xG+A1awKKiPCwE4dEYkYWKh
X-Received: by 2002:a05:7022:f903:b0:13b:2f26:6881 with SMTP id a92af1059eb24-1ac55f2d154mr18378303c88.4.1793665923643;
        Mon, 02 Nov 2026 16:32:03 -0800 (PST)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.93])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac1b38ac58sm36417225c88.23.2026.11.02.16.32.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 02 Nov 2026 16:32:03 -0800 (PST)
From: Brian Bunker <brian@purestorage.com>
To: dm-devel@lists.linux.dev
Cc: bmarzins@redhat.com,
	mwilck@suse.com,
	christophe.varoqui@opensvc.com,
	Brian Bunker <brian@purestorage.com>
Subject: [PATCH v6 1/1] multipathd: don't leave maps read-only after write protect is cleared
Date: Mon,  2 Nov 2026 16:31:50 -0800
Message-ID: <20261103003150.78513-2-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103003150.78513-1-brian@purestorage.com>
References: <20261103003150.78513-1-brian@purestorage.com>
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

Fix this by setting force_readonly before each load and clearing it
once the load has succeeded:

- uev_update_path() no longer takes the path's ro state from the
  uevent's DISK_RO. The uevent only says that something changed. The
  kernel updates the ro attribute before it sends the uevent, so sysfs
  is current when the uevent is handled, while the uevent itself may
  have been queued behind later changes. It just calls
  needs_ro_update(), which reads the ro state of all of the map's paths
  from sysfs.

- needs_ro_update() no longer takes an ro value. It sets
  force_readonly from the ro state of the map's paths, and returns true
  if that differs from the map's current state. If the map is already
  read-only and has to stay so, it clears the flag and returns false,
  since dm has to reopen the paths for any read-write reload anyway. If
  the map has no dm info, it fetches it, and returns false if that
  fails, instead of assuming a reload is needed. Since the flag is
  recomputed on every call, a failed read-only reload is retried on the
  next uevent without any special handling.

- ev_add_path() sets it from all of the map's paths rather than only
  the path being added, and only when it is about to load the map
  (need_do_map). mpp->paths is up to date there after adopt_paths(),
  while mpp->pg doesn't contain the new paths yet.

- update_map(), which does reloads that were delayed while the map was
  waiting for udev (UDEV_WAIT_RELOAD), recomputes it from the map's
  paths before setting up the map.

- dm_addmap_create() clears it as soon as it has read it. A failed
  create leaves no map behind, and the next create computes the flag
  again.

- dm_addmap_reload() clears it once the reload and resume have
  succeeded. If the reload fails, the map keeps its old table, and the
  flag stays set so that the next reload tries again.

Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 libmultipath/devmapper.c |  18 ++++-
 multipathd/main.c        | 144 ++++++++++++++++++++++++---------------
 2 files changed, 105 insertions(+), 57 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index e3870f59..34e0f640 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -539,10 +539,15 @@ static uint16_t build_udev_flags(const struct multipath *mpp, int reload)
 
 int dm_addmap_create (struct multipath *mpp, char *params)
 {
-	int ro;
+	int ro = mpp->force_readonly ? 1 : 0;
 	uint16_t udev_flags = build_udev_flags(mpp, 0);
 
-	for (ro = mpp->force_readonly ? 1 : 0; ro <= 1; ro++) {
+	/*
+	 * force_readonly only applies to this load. Clear it, so that it
+	 * can't affect later loads, even if this one fails.
+	 */
+	mpp->force_readonly = 0;
+	for (; ro <= 1; ro++) {
 		int err;
 
 		if (dm_addmap(DM_DEVICE_CREATE, TGT_MPATH, mpp, params, ro,
@@ -599,8 +604,15 @@ int dm_addmap_reload(struct multipath *mpp, char *params, int flush)
 		r = dm_simplecmd(DM_DEVICE_RESUME, mpp->alias,
 				 DMFL_NEED_SYNC | (flush ? 0 : DMFL_NO_FLUSH),
 				 udev_flags);
-	if (r)
+	if (r) {
+		/*
+		 * force_readonly only applies to this reload. If the reload
+		 * fails, the map keeps its old table, and the flag stays set
+		 * so that the next reload tries again.
+		 */
+		mpp->force_readonly = 0;
 		return r;
+	}
 
 	/* If the resume failed, dm will leave the device suspended, and
 	 * drop the new table, so doing a second resume will try using
diff --git a/multipathd/main.c b/multipathd/main.c
index 9bce4d6b..f3b0cb5f 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -709,6 +709,55 @@ void cleanup_reset_vec(struct vector_s **v)
 	vector_reset(*v);
 }
 
+static int
+sysfs_get_ro (struct path *pp)
+{
+	int ro;
+	char buff[3]; /* Either "0\n\0" or "1\n\0" */
+
+	if (!pp->udev)
+		return -1;
+
+	if (!sysfs_attr_get_value_ok(pp->udev, "ro", buff, sizeof(buff))) {
+		condlog(3, "%s: Cannot read ro attribute in sysfs", pp->dev);
+		return -1;
+	}
+
+	if (sscanf(buff, "%d\n", &ro) != 1 || ro < 0 || ro > 1) {
+		condlog(3, "%s: Cannot parse ro attribute", pp->dev);
+		return -1;
+	}
+
+	return ro;
+}
+
+/* A map must be loaded read-only if any of its paths is read-only. */
+static bool
+has_ro_path(vector paths)
+{
+	struct path *pp;
+	unsigned int i;
+
+	vector_foreach_slot (paths, pp, i) {
+		if (sysfs_get_ro(pp) == 1)
+			return true;
+	}
+	return false;
+}
+
+static bool
+map_has_ro_path(struct multipath *mpp)
+{
+	struct pathgroup *pgp;
+	unsigned int i;
+
+	vector_foreach_slot (mpp->pg, pgp, i) {
+		if (has_ro_path(pgp->paths))
+			return true;
+	}
+	return false;
+}
+
 static int
 update_map (struct multipath *mpp, struct vectors *vecs, int new_map)
 {
@@ -732,6 +781,14 @@ retry:
 
 	mpp->action = ACT_RELOAD;
 
+	/*
+	 * This may be a delayed reload, and the paths' write protect
+	 * state may have changed since force_readonly was last set.
+	 * Recompute it from the current paths. mpp->paths is up to date
+	 * after adopt_paths(), while mpp->pg isn't until setup_map().
+	 */
+	mpp->force_readonly = has_ro_path(mpp->paths);
+
 	if (setup_map(mpp, &params, vecs)) {
 		condlog(0, "%s: failed to setup new map in update", mpp->alias);
 		retries = -1;
@@ -1270,28 +1327,6 @@ out:
 	return ret;
 }
 
-static int
-sysfs_get_ro (struct path *pp)
-{
-	int ro;
-	char buff[3]; /* Either "0\n\0" or "1\n\0" */
-
-	if (!pp->udev)
-		return -1;
-
-	if (!sysfs_attr_get_value_ok(pp->udev, "ro", buff, sizeof(buff))) {
-		condlog(3, "%s: Cannot read ro attribute in sysfs", pp->dev);
-		return -1;
-	}
-
-	if (sscanf(buff, "%d\n", &ro) != 1 || ro < 0 || ro > 1) {
-		condlog(3, "%s: Cannot parse ro attribute", pp->dev);
-		return -1;
-	}
-
-	return ro;
-}
-
 /*
  * returns:
  * 0: added
@@ -1305,7 +1340,6 @@ ev_add_path (struct path * pp, struct vectors * vecs, int need_do_map)
 	int retries = 3;
 	int start_waiter = 0;
 	int ret;
-	int ro;
 	unsigned char prflag = PR_UNSET;
 
 	/*
@@ -1370,14 +1404,16 @@ rescan:
 			goto fail; /* leave path added to pathvec */
 	}
 
-	/* ro check - if new path is ro, force map to be ro as well */
-	ro = sysfs_get_ro(pp);
-	if (ro == 1)
-		mpp->force_readonly = 1;
-
 	if (!need_do_map)
 		return 0;
 
+	/*
+	 * Load the map read-only if any of its paths is read-only, not
+	 * just the one being added. mpp->paths is up to date after
+	 * adopt_paths(), while mpp->pg doesn't have the new paths yet.
+	 */
+	mpp->force_readonly = has_ro_path(mpp->paths);
+
 	if (!dm_map_present(mpp->alias)) {
 		mpp->action = ACT_CREATE;
 		start_waiter = 1;
@@ -1594,27 +1630,27 @@ finish_path_init(struct path *pp, struct vectors * vecs)
 }
 
 static bool
-needs_ro_update(struct multipath *mpp, int ro)
+needs_ro_update(struct multipath *mpp)
 {
-	struct pathgroup * pgp;
-	struct path * pp;
-	unsigned int i, j;
-
-	if (!mpp || ro < 0)
+	if (!mpp)
 		return false;
-	if (!has_dm_info(mpp))
-		return true;
-	if (mpp->dmi.read_only == ro)
+	if (!has_dm_info(mpp) &&
+	    dm_get_info(mpp->alias, &mpp->dmi) != DMP_OK) {
+		condlog(2, "%s: failed to get dm info", mpp->alias);
 		return false;
-	if (ro == 1)
-		return true;
-	vector_foreach_slot (mpp->pg, pgp, i) {
-		vector_foreach_slot (pgp->paths, pp, j) {
-			if (sysfs_get_ro(pp) == 1)
-				return false;
-		}
 	}
-	return true;
+	mpp->force_readonly = map_has_ro_path(mpp);
+
+	/*
+	 * The map is read-only and has to stay so. dm has to reopen its
+	 * paths for any read-write reload anyway, so the flag isn't needed.
+	 */
+	if (mpp->force_readonly && mpp->dmi.read_only) {
+		mpp->force_readonly = 0;
+		return false;
+	}
+	/* The current map state doesn't match the paths' state. Update it. */
+	return (mpp->force_readonly != mpp->dmi.read_only);
 }
 
 int resize_map(struct multipath *mpp, unsigned long long size,
@@ -1652,7 +1688,7 @@ out:
 static int
 uev_update_path (struct uevent *uev, struct vectors * vecs)
 {
-	int ro, retval = 0, rc;
+	int retval = 0, rc;
 	struct path * pp;
 	struct config *conf;
 	int needs_reinit = 0;
@@ -1725,22 +1761,22 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 			pthread_cleanup_pop(1);
 		}
 
-		ro = uevent_get_disk_ro(uev);
-		if (needs_ro_update(mpp, ro)) {
-			condlog(2, "%s: update path write_protect to '%d' (uevent)", uev->kernel, ro);
+		/*
+		 * The uevent only tells us that something changed. Check the
+		 * paths' ro state in sysfs, which the kernel updates before
+		 * sending the uevent, instead of trusting the uevent's DISK_RO.
+		 */
+		if (needs_ro_update(mpp)) {
+			condlog(2, "%s: update path write_protect to '%d' (uevent)", uev->kernel, mpp->force_readonly);
 
 			if (mpp->wait_for_udev != UDEV_WAIT_DONE)
 				mpp->wait_for_udev = UDEV_WAIT_RELOAD;
 			else {
-				if (ro == 1)
-					pp->mpp->force_readonly = 1;
 				retval = reload_and_sync_map(mpp, vecs);
 				if (retval == 2)
 					condlog(2, "%s: map removed during reload", pp->dev);
-				else {
-					pp->mpp->force_readonly = 0;
+				else
 					condlog(2, "%s: map %s reloaded (retval %d)", uev->kernel, mpp->alias, retval);
-				}
 			}
 		}
 		if (auto_resize != AUTO_RESIZE_NEVER && mpp &&
-- 
2.56.0


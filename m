Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792712948;
	b=0eYHQ8Rj3SWa+ppHWS35wirYvvQD9Iz5RWfCZ9lVETWbBEJUq28DnvcK/O5RYhN4iSFF
	 iGGCz2U6X2odtLFqPDNIubj9Kkj53ncx/UyOccCYPAyI9Z5rDoMH0ZwRU0Gxe/kOoTagO
	 lpVA9n/RAtvzKJuo1Gry713Ofh9LFXgqJuoEQarRNWttE29GMroKP1LqtkY9yxS8UAo5P
	 egF8hm3Dz12bZXR2+r6plf9IBP8MV4+Oex8Ki0xtuQ5p1Y+zcrbn+yfp+6gIk7y38KoIF
	 pPKofEc1qH7BkyoAz+FSN7drjjHgKY47vHm5YPimbSsaTJ2uZiucGBMbm/RxyAg9nPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792712948;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=CpXNeJ45qpMcKxpLyi7y1clPku4qXfYhzTH8Jt1qRQw=;
	b=QoY5MLsrXQ18zyEk+sFTbChZgoQ6cpPYdgoWCTAPNSZwANdKI+FHjV/XzhtOeRdzU1H1
	 ji9KEQ614LXbToc+/UzUywcfApRlP4PlmPg7w1pc1SnKCCAo0mcdCwHYJaw3AiP0rIODS
	 aFdIaP7OpBvEihyHMmEgrnFogH/eI/cHWasppZtOS1bNNzXGPYt47Tn09PI4fYaYK6nUC
	 +cqGo6qNTzeRnC5GtP9RV+epsyQOiuPwJ1j8y08yTB1jBjAWdll3BDWLDq6M4gLbz+fXq
	 mc36BeYypzpht8CHfxq8hNsYuxOj776sfe2W58BPUzXfPT5QKsHhxN2KRyFXq8T51Aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=JCVcd3Xi;
	arc=none smtp.remote-ip=74.125.82.172
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90213606A31D
	for <dm-devel@lists.linux.dev>; Thu, 22 Oct 2026 23:49:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 90213606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=JCVcd3Xi
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-3645f0f3fcdso589195eec.0
        for <dm-devel@lists.linux.dev>; Thu, 22 Oct 2026 16:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1792712947; x=1793317747; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CpXNeJ45qpMcKxpLyi7y1clPku4qXfYhzTH8Jt1qRQw=;
        b=JCVcd3XiC5hQ3g8+D3JwgfLfstWAJ5BaCcCiZRYgnz13sEmI5kPDBCQgAvzPsaOavf
         Jmx84FnuOeUfJzzJpS4Bkn5wsx39U/pZ7ito9SE7LzKuoG6Kc/55N8wMExxK0q5UAgoJ
         zmdMmQgQApeKhK2/2kEEZqOQfoIy+/i9hP2Ulog5OmPptoIjR5eOhLZwhDexfZtR2bK0
         pEaSOKLLeGV5zwCADXkQ5Ycu1b8/3kWAD/9lKVL8dH9xdj3uKCHoPcfJ8oY8gJWPWm36
         ucJUV0Qq7eGzQOJRAto2goxNrR8J5IpQIOqIYpiGjSh2nQAcNdYSQtUmL39yvGyJr0K6
         kf+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792712947; x=1793317747;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CpXNeJ45qpMcKxpLyi7y1clPku4qXfYhzTH8Jt1qRQw=;
        b=1szHxzfBrsl43RpgsuoiFXcaQp9DbxYbWyCRD0UzbVej1CKKCBNDzEPpO6dIWT5H2g
         91fyNJ91FwdXGN8GcwdnCn4luZ+OcUeN/5Jz82NkcNBQVHkWUOwMV9ZSLdLRseOd9eZ2
         C/NviD4Ue8xs/cj6abV9GNTqzDMXeax/kaRKGUqP9AUpMaOrvpedo0saDY8+UMPLancL
         NvP4gO107dhfwC9N/+dwyzuAjSjiukPIAT2QHoWwHLOK2JWwchRoEfQFnV1irMgQHO54
         gBoyR+03WPOEebzy1Y9IXDSn1AK8pRTvl5sn656jUihtkQJ/AnNd6glTTGp35YmCUcAv
         AfbQ==
X-Gm-Message-State: AFq9FYJok+a2xFtUpO996Mn4YycV5MwxGdVGo73JAHTrO6ua+VyU8c0Y
	K0QJ20V5jEiTND51VlW6eZpl3hYUYdHof+JBSyb+A8ASItGWMHx3AFqhVHI3t/7fdBFzNpE+zb7
	yQPQ2Uoj8LaTNuPHNM+CUE41rO6Rr4yvXbfFGW4WNb3xJdssUm4U92LCw/uIfeQK7Q1SHh55jXQ
	MEmDEVvu108+3nrY7FxmSYpOsPWaWEXFITOAtqhHgsXefPgVw=
X-Gm-Gg: AYBFou3WOvM9u9L6mLaNmxjM50fct/ZGQDCpgWl1cWGrwuoZThYZTzcMoJWrfbwmSRn
	Vu7L0SJLx8X4vywRZocVba6GsmQhGNpXzw9JH0agJZJefR9YinOt4MSjwhdt78MVFrk0/aCrZS6
	5ncJ9e/WNC35l9dyXw/PewIwl+5h0OSDpp7tG5Oz8Op06Ax0CYZ20ayCGIGupK/ZQmQVL9A/eAH
	FKGibk0fpFLGm8PgoYd4X+fvRaIiaLJnmq175k02wpgJi20OSCKFLaW95RrwSIj9p6LFyZbev4y
	a0v+Rx/R6PQXNkzy4/+nlyyJs66RbCmJCTbPG+g/8hz9NNVnZ2bdAGxM66u7J6z2czx9Utpu7wd
	FjKJHG1HPPjUiFefoHTI7eSaGhBZg+b+uTJVJD7zRSxS0GzIH8+aIG3cbRLCl1s3AmxehMNIaeg
	Iw6vMg135sEiqbirClT1JWD6FKVYRgdDu8W1bO9WuFCCZeoBDPDRQPTUb+kZs4X18WuM1UaxF50
	JWPAoYWLrZIjv2FiwV+3sJnmp2b2chyXGtTcUok9pVIVhg1M5hRzQ1z8uxFort/jcxhXWsAcpr9
	NIMEp/JVC55mfu27sTgGxFU6BknhRvd271SxpAC5BfcX2RZXbgPTH6nAWgP8yA3etz79vgh5TAB
	bByZvIPLfSreeCCHXdQZdypb3kZxBrjjEDRITTicNpiHFKE+Fm+fc
X-Received: by 2002:a05:7300:c01a:10b0:355:fdc0:a811 with SMTP id 5a478bee46e88-369d9868651mr887849eec.37.1792712946252;
        Thu, 22 Oct 2026 16:49:06 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.106])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369d9c15883sm1488766eec.3.2026.10.22.16.49.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 22 Oct 2026 16:49:05 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: dm-devel@lists.linux.dev
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Brian Bunker <brian@purestorage.com>
Subject: [PATCH v4 1/1] multipathd: don't leave maps read-only after write protect is cleared
Date: Thu, 22 Oct 2026 16:48:53 -0700
Message-ID: <20261022234853.79725-2-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261022234853.79725-1-brian@purestorage.com>
References: <20261022234853.79725-1-brian@purestorage.com>
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
when the load reads it:

- needs_ro_update() now sets force_readonly whenever it returns true:
  to 1 for a DISK_RO=1 uevent, and to 0 when all of the map's paths
  are writable. uev_update_path() no longer sets or clears it itself.
  If the map has no dm info, needs_ro_update() now fetches it, and
  returns false if that fails, instead of assuming a reload is needed.

- ev_add_path() sets it from all of the map's paths rather than only
  the path being added, and only when it is about to load the map
  (need_do_map). mpp->paths is up to date there after adopt_paths(),
  while mpp->pg doesn't contain the new paths yet.

- update_map(), which does reloads that were delayed while the map was
  waiting for udev (UDEV_WAIT_RELOAD), recomputes it from the map's
  paths before setting up the map.

- dm_addmap_create() and dm_addmap_reload() clear it as soon as they
  have read it, so it only applies to the load it was set for.

- If a reload fails, dm_addmap_reload() sets it back, because the map
  still has its old table. If the map was supposed to become read-only,
  the next reload then tries again. needs_ro_update() clears the flag
  again when a DISK_RO=0 uevent arrives for a read-write map and none
  of the map's paths is read-only any more, so that a later reload for
  an unrelated reason, such as a path group change, doesn't load the
  map read-only.

Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 libmultipath/devmapper.c |  26 ++++++--
 multipathd/main.c        | 128 +++++++++++++++++++++++++--------------
 2 files changed, 103 insertions(+), 51 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index e3870f59..324a92cc 100644
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
@@ -578,19 +583,26 @@ int dm_addmap_create (struct multipath *mpp, char *params)
 int dm_addmap_reload(struct multipath *mpp, char *params, int flush)
 {
 	int r = 0;
+	int force_ro = mpp->force_readonly;
 	uint16_t udev_flags = build_udev_flags(mpp, 1);
 
+	/*
+	 * force_readonly only applies to this load. Clear it, so that it
+	 * can't affect later loads, unless this one fails (see below).
+	 */
+	mpp->force_readonly = 0;
+
 	/*
 	 * DM_DEVICE_RELOAD cannot wait on a cookie, as
 	 * the cookie will only ever be released after an
 	 * DM_DEVICE_RESUME. So call DM_DEVICE_RESUME
 	 * after each successful call to DM_DEVICE_RELOAD.
 	 */
-	if (!mpp->force_readonly)
+	if (!force_ro)
 		r = dm_addmap(DM_DEVICE_RELOAD, TGT_MPATH, mpp, params,
 			      ADDMAP_RW, 0);
 	if (!r) {
-		if (!mpp->force_readonly && errno != EROFS)
+		if (!force_ro && errno != EROFS)
 			return 0;
 		r = dm_addmap(DM_DEVICE_RELOAD, TGT_MPATH, mpp,
 			      params, ADDMAP_RO, 0);
@@ -609,6 +621,12 @@ int dm_addmap_reload(struct multipath *mpp, char *params, int flush)
 		dm_simplecmd(DM_DEVICE_RESUME, mpp->alias,
 			     DMFL_NEED_SYNC | (flush ? 0 : DMFL_NO_FLUSH),
 			     udev_flags);
+	/*
+	 * The map still has its old table. If it was supposed to become
+	 * read-only, keep force_readonly set, so that the next reload
+	 * tries again.
+	 */
+	mpp->force_readonly = force_ro;
 	return 0;
 }
 
diff --git a/multipathd/main.c b/multipathd/main.c
index 9bce4d6b..ddef64fa 100644
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
@@ -1596,24 +1632,26 @@ finish_path_init(struct path *pp, struct vectors * vecs)
 static bool
 needs_ro_update(struct multipath *mpp, int ro)
 {
-	struct pathgroup * pgp;
-	struct path * pp;
-	unsigned int i, j;
-
 	if (!mpp || ro < 0)
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
+	if (mpp->dmi.read_only == ro) {
+		/*
+		 * A failed read-only reload leaves force_readonly set while
+		 * the map is still read-write. Clear it once no path is
+		 * read-only any more.
+		 */
+		if (ro == 0 && mpp->force_readonly && !map_has_ro_path(mpp))
+			mpp->force_readonly = 0;
+		return false;
+	}
+	if (ro == 0 && map_has_ro_path(mpp))
+		return false;
+	mpp->force_readonly = ro;
 	return true;
 }
 
@@ -1732,15 +1770,11 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
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


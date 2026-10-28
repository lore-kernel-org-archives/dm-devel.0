Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793147095;
	b=Wm9rnV4XtyIKvrTogl16m3kdFHbMOoopaihfogyC38xNWaepXyD2G3oqN7s2ky370dfO
	 yNect6IPEJ3YPvZ5nO9J4kCF4YU/mAkhKV2rz1QUEWO5vqceqZn7YqI7drn5uZn36Z5Ez
	 UdJwTHpcdkNdoEVMyytNtFzSelPAjwPvKRPx2g0mAtAan9/ujjWit8DXG2w6RZa5tteJG
	 joX9ljuu/k25UPoo+R1ilaitCVOiznGucC/g16/HjCnW23HH/sGFq3dtYR9+KnKRzYCku
	 SpNoIochzxW0mYxq0Kc3WYUnQCukz1XAjjbhXqHB00CBTSnU0M2Yd94xJIQHpd7S6XQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793147095;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=jPxQIhTwvIV0yPtdAkzyTFVfJrLIS84QVzI+o1XaLEo=;
	b=TReLNXf5wf9tzCzhFk3k3eOsLF4kb0VWHrT9GVFpvq+oSoPBGcGWouTsBBjuTRHRO4J/
	 vI3xlxRV33Z2CPEp3JRXqtmxruDB8N2G1NTiOhbC+cIG1vyOsRceDqVF4yfVy/QVJLGC4
	 mloZc+kCKkOaFGTayM9pVMESb7/LGdR2XcGIwhtt3Yxddi+oZOJRzHp2WSnW0263to80t
	 NeS12RWYvWfYV+MaD9WI4IJHDYq0ZoaW6rtRk05K/1JTtcaBo3nkIQloUmZI0N9jwoqX9
	 PX8uZNdoAn+qnJCeDBYC6GbEjfCaqMEBvZWzTYBPsyKcK1lbGI5ED+NBT9lVaPMHGzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=JaHMcG3O;
	arc=none smtp.remote-ip=74.125.82.172
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E89606A31E
	for <dm-devel@lists.linux.dev>; Wed, 28 Oct 2026 00:24:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E4E89606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=JaHMcG3O
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-3645f0f3fcdso738838eec.0
        for <dm-devel@lists.linux.dev>; Tue, 27 Oct 2026 17:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1793147094; x=1793751894; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jPxQIhTwvIV0yPtdAkzyTFVfJrLIS84QVzI+o1XaLEo=;
        b=JaHMcG3OsMsHNowl+qTnSLJvYffZkb7TTyMtNdzi3Ld8h0XewGxVLVTeX5mFCcLUTv
         uELJBje6j0tFZCodPO3k+4WmsrooLvi0e3pfo2FE+/ZOv+Phx/4qVY5nh9u63CJad+X5
         mjRIo8ZoS5CFkFGV4k8Fhbc22rBDysY8ZXvth16VjIA2zbH+sP1/9h4pmFVZqe/h4Im0
         LoqQCCQVl3Fs3jQpnTbYYRGsG8IujnwFUKYibViZuQDXJF0BF8AjRWlZB/iCwuK0dJUd
         hCgVc7XB3sCpaUdlVj0QPfr7MnLLbJeB4n0l7rNPTCS1rXiFKMvOSBRPsI2JSsbAs2Wh
         oMqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793147094; x=1793751894;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jPxQIhTwvIV0yPtdAkzyTFVfJrLIS84QVzI+o1XaLEo=;
        b=D78xH5wJ3b5t9aW0J0y6RBse72ZufFsLKOXx07t6tssPdf1VDYqEAtfwmOr6q5HPr5
         ZlV/TJdGuzlgAdYC3B5E8dokP92DIroIFURWQjLZENBoOmXenLuY21dTvOetL0i70sgt
         hV/e5zP5TouHUqoUIv4EJEwpSRyAxrBBsApnni/clzjsIiktiA8OXyB12lREqxJXWU+6
         y/wy9YDufWwkO8lKmRFSe9EJ/6H+5T/IGCRXmIhfFgJiuADIFFDEsLakTGkUGNHLg7um
         nGn83dVJULR60utc9yHW4u/oTSdHuteMeo9nDtXPFy9Iy+kLNP1XA5A2QfwcJsijb6Jx
         TNug==
X-Gm-Message-State: AFq9FYK+s0Ym1jaZQRiRodN2rmlBKIJ0MbisrwEsjK8Tpqacj/KuvvKE
	rGms0iS5An/9wnTibikUz70aO2EvOl8GMD3Bx62Jnh/ZTTv1fdWIpKAcwJ/85SMN01sUv81uYLO
	BGa+htutu4Dun6uct40eWp23SaaplsrOHGXY4ihjj80yuTNaFO4aSp+T2w8MqiXNTqsWsi1HXhu
	G3xCXkAMeBvXhhz2XIWdI3/E1EEC5YDH09fEg7SXk9F7bHkaw=
X-Gm-Gg: AYBFou2PA/Ywi0d0b9hutoXgAtHJiYiPeM0B4vOJdNOHVpM/VxruaiOrDdcUzOndBLE
	1w6ieG5vA1FcDHkXJuWt0Ms1xcgBtGM2DjhnlfYnqEIbad+3DT7/CG++b4gXtfIjKXbHW1wW2Hf
	EweyQ/6DbaXwO3sazR53lXdtRy5iPl7BKDPnICmqQXLrvTc60tzcSsE7tVLXqZvw2gMdwxOT0GS
	hHDPZUzkg2Ef64D2hBK52vSf41teUhswwAKZAz/j8S/Kmzzo0j5dGeu9kEtSvp2/LWvwStzla6r
	2rT0JGlsSIIqJGMI0W6s4xqAq2PAKsT38kKY/fvmjydev5LzIE/vtIBWLi4OwfNGJEx7xzyD8a/
	PAQK2O0M8ivuXUfeG6ajdLHbzmsrsAWEc8mbddSxKJcupIDiIJKlYzZxikg/HO2aRzUpMtBMsZc
	cGtBq3DxJZmTBxF6em3rYklr915nPkPel9dekjz8aGuxyN8U+GbtBt1h00UkRCCuEcevaOUHjKc
	VHO0pFNG2pfAsWxCFOG3OADQRKtF6LFW99j4F3iEZ8RXB68QrR62hm31W217PwtDVjEe1XetBm2
	Eyf3gW9NhPzRnFFwisc7YzcHxY5NE9W7cOem52Pwk1GimtVM6uTTucTnTkyVpdogpqpp4Y6omoa
	H1oCHsnmku/1dadhUONcMqk3SFzptpLhsYADDShQIQZhKaWFxca9M6w==
X-Received: by 2002:a05:7301:5413:b0:34d:2c1a:9892 with SMTP id 5a478bee46e88-36a201f8919mr1163764eec.40.1793147093549;
        Tue, 27 Oct 2026 17:24:53 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([136.226.79.111])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a23641e78sm620510eec.0.2026.10.27.17.24.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 27 Oct 2026 17:24:53 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: dm-devel@lists.linux.dev
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Uday Shankar <ushankar@purestorage.com>,
	Brian Bunker <brian@purestorage.com>
Subject: [PATCH v5 1/1] multipathd: don't leave maps read-only after write protect is cleared
Date: Tue, 27 Oct 2026 17:24:37 -0700
Message-ID: <20261028002437.39990-2-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028002437.39990-1-brian@purestorage.com>
References: <20261028002437.39990-1-brian@purestorage.com>
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

- uev_update_path() takes the path's ro state from sysfs instead of
  from the uevent's DISK_RO. The uevent only says that something
  changed. The kernel updates the ro attribute before it sends the
  uevent, so sysfs is current when the uevent is handled, while the
  uevent itself may have been queued behind later changes. If sysfs
  can't be read, nothing is done.

- needs_ro_update() now sets force_readonly whenever it returns true:
  to 1 when the path is read-only, and to 0 when all of the map's paths
  are writable. uev_update_path() no longer sets or clears it itself.
  When needs_ro_update() returns false, it clears the flag, unless the
  map is read-write while one of its paths is still read-only. In that
  case an earlier read-only reload failed, and the flag stays set so
  that the next reload tries again. If the map has no dm info,
  needs_ro_update() now fetches it, and returns false if that fails,
  instead of assuming a reload is needed.

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
 multipathd/main.c        | 144 ++++++++++++++++++++++++++-------------
 2 files changed, 111 insertions(+), 51 deletions(-)

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
index 9bce4d6b..1100584f 100644
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
@@ -1596,24 +1632,34 @@ finish_path_init(struct path *pp, struct vectors * vecs)
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
+		 * No reload is needed. A failed read-only reload leaves
+		 * force_readonly set while the map is still read-write. Keep
+		 * it only while one of the map's paths is still read-only,
+		 * so that the next reload tries again.
+		 */
+		if (mpp->force_readonly && (ro == 1 || !map_has_ro_path(mpp)))
+			mpp->force_readonly = 0;
+		return false;
+	}
+	if (ro == 0 && map_has_ro_path(mpp)) {
+		/*
+		 * The map is read-only and has to stay so. dm has to reopen
+		 * its paths for any read-write reload anyway, so the flag
+		 * isn't needed.
+		 */
+		mpp->force_readonly = 0;
+		return false;
+	}
+	mpp->force_readonly = ro;
 	return true;
 }
 
@@ -1725,22 +1771,24 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 			pthread_cleanup_pop(1);
 		}
 
-		ro = uevent_get_disk_ro(uev);
+		/*
+		 * The uevent only tells us that something changed. Take the
+		 * path's ro state from sysfs, which the kernel updates before
+		 * sending the uevent. If sysfs can't be read, don't act on
+		 * the uevent's DISK_RO either.
+		 */
+		ro = sysfs_get_ro(pp);
 		if (needs_ro_update(mpp, ro)) {
 			condlog(2, "%s: update path write_protect to '%d' (uevent)", uev->kernel, ro);
 
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


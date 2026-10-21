Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792607294;
	b=vTnZwSOoeb8ke8Z2k0WcQfWrJQVVq8iBCzpjlWRS3DMoRDw2vrn7mC3IMULxf7n6r1fs
	 2qp1IZavNOs1GxphGddDtlIsoHwBN0uW5UOazT0Uc19uJigUJdmv8WHnZUCZDkBxppjy2
	 8trDuUbEaXY6TSr3W+1BFafW3hRdB2Sou/nyufi/4fHn0zTHlHJDZhlVdeO1ZSZ9+eyk3
	 82n/IQ9w0E3Gz+XkGqjuhW+ruP+UJknOL1Vx1HcESP5LXh3ehDa0YycKE0fScSK7WiuLH
	 +lma7c+AF0Q7ix7aZ3O2GvVTVSJ0StcUGAz6En8pMHA1+zEPjyw7Yw/eJTjEHhAFbJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792607294;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=L3wTq8hQwQXBNalpECXpi6e8VC1pWMZV+7Swqo2OoXY=;
	b=KRvwvLVEO6v2Tkp4UKC4KBif0x2Yw63M0kgMxtJ47WrkYR9wdd9fx30eEEMqBPU/Fxpt
	 6sNkHcWgg4J2ra9Mx/W0eiXPFVD0vrtN/K/Ybk4l+CDTcH68KtaPQVYo/uErOLNVNKfC8
	 tco4GbrPaiQPucMklbvPEuNqLtOmWpGoBpUCEe+R3G2ooO6vD6KvqRos2v02LmVPAy6F0
	 pmswisubPyClniQe3TiTKfUn37HKbVVTpyHoBvHOCkW5xx14xnmMsoQg9sT+br5ptpUP9
	 rD0WN8/IB8nsOIq8xfvEMOSHGOC3pRT7nNS1TZh3euzZCxNAp0ODtEITbF7vdlSEGQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=ddPA334G;
	arc=none smtp.remote-ip=74.125.82.174
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3787C606A319
	for <dm-devel@lists.linux.dev>; Wed, 21 Oct 2026 18:28:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3787C606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=ddPA334G
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-3282db206d3so2385071eec.0
        for <dm-devel@lists.linux.dev>; Wed, 21 Oct 2026 11:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1792607292; x=1793212092; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=L3wTq8hQwQXBNalpECXpi6e8VC1pWMZV+7Swqo2OoXY=;
        b=ddPA334GCa6a4NQIh2VsFMxBd/xfcHluU+kvr5R5yaRbGVXyO3FfmEbLnrGWPRLx+3
         JgPH6VxYQqNdV504IH4HpOh42zWarqvfQ+XZFN1y1GCQWkSHM2mr7k8DDRROlQACRIc8
         NUSdHv49BT6k+xEP0TznHwbh7bev2nO2XgitfrAEAZT1WEz4lZzoaiZziUZDzev0eZn5
         ER01MJ1o6HUHATiZVYdBU1GVptJT4LJKSpMpcETnBdAdowSQsl1mXTL3Brj4wlSWWJKy
         8tm2bh2XFoneHGseBynqvfj+Z/Ah5AGO8AaHOPMNEDn/ZP7SRn85b7yBbG/sSDx8VbjH
         qdNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792607292; x=1793212092;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=L3wTq8hQwQXBNalpECXpi6e8VC1pWMZV+7Swqo2OoXY=;
        b=POalPERU5HZ4kChohq2EmVh4xbxlwxaIVDxYIg2BNknvvWF1s1y7arudn0CzQ2tY3E
         4k4jg7vlNGQdH/wQ0dqhxYCEylOb6i4de3mWKYXN+maN7S+Q9gN264NtDDESb+y7mQ+n
         MB+C5GzMoCqGkdmxSnHfrTfJG53+EWOszM39TCXryGTaWQebkw41AeD95WvwQBugj+cE
         e/ZEwqLUNjEWDUgGUBHpLOcgYiesBXi1OyyOLsU4AeHWCAx9QFghmbhtquBAYX4Dfjva
         xO3nwkpOGc+7Id9+Lf+lf+9/wf4U8c5g3zV9MapIEZUm5prtSxSj3M4eM0AEJbantoKh
         4KNg==
X-Gm-Message-State: AFq9FYLurjB/OGtkboIUH2ykD7vR+jHZV8RNOV1XE19/szkAMBBwUY+8
	+GtZ5irwMRc0kNI+Tad8gY89R66wKNP1IYPLL3gWHgcl+4cFKY/QJOQ6sJ0PT4S1t3zqK9zBkvN
	zZYF7b/bo2gz8Pse+dXorkZORTM3jgezaXLKXe1JVeWmupmrWG+gk1EW2YCUAIAGDQYtJElKYW8
	ZzzRMr+r3JQR2N/PTUOt3dd1SJwvddCmwhzx6sOwo9Lc+ikVA=
X-Gm-Gg: AYBFou1pRejaZ+DaT61TN5dx3X59Yq743iggdqPqYmz7x8XiaI5KCSmh2TsA3LInAxj
	fHa7WKuJw1dLK7vRGeMCakv4Y6Xd250av0Rlw6KQ1ioDPXZpGGsWiCtxMxh08x5aA/8Brl47jcX
	xpNxNYgY/rHF0soBRqTJ9rzmy58V9NNpo0mvWVbgNbQ5PQ858MCfIzzX+NF0wBQdsKTOo86h8tM
	wg3SUUwB+g6RzRTHgNHvss6MOl8xygic0RCdIW/rLGDzJcjV77N/AW2ubq1XtiTcq25DrQOTHwN
	WMyjt81MTgbBiPzgyul3uB593HRJwSPDLP/xdsLgkXBIaqvi/GUpQmfB/YBj+4P9q0lPUWPiNYh
	l3sa0UO/EzyJnM1sxzZS92dCiTFKcLO1aMG6EvbUMU2B6ylLiIXuogXgNdcmI0wqtdqjyT8/dJp
	io9EpXKhYn2ERSbN3ezqfcL6aTGnoT+zhT+kr/tFTonqBnw3RegvHCXQlvJzE+WUm/CRincDIow
	1QrUTkssDlLBnUscCoD9oewro/t2c0yf//MNYZoATarWOCnDFkQwgeZWiM7mTH+PsK0RQfWy7FG
	bUsvLn/WoJgZyARZWGc9yeXYVe5JXp8EC2ZSzab29JioKUYmWpwZ9kSZKlEZaiPhQub3JetKRji
	xS+ZpR2NxLRXa5rH4N58YGOTlswLhIhZ23SgmZpIyuMeCxrn6PW0k
X-Received: by 2002:a05:7300:2152:b0:35c:dd03:55d2 with SMTP id 5a478bee46e88-3674db4d057mr5941074eec.26.1792607291932;
        Wed, 21 Oct 2026 11:28:11 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.106])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36740cc8439sm9841561eec.11.2026.10.21.11.28.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 21 Oct 2026 11:28:11 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: dm-devel@lists.linux.dev
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Brian Bunker <brian@purestorage.com>
Subject: [PATCH v2 1/1] multipathd: don't leave maps read-only after write protect is cleared
Date: Wed, 21 Oct 2026 11:27:59 -0700
Message-ID: <20261021182759.30106-2-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261021182759.30106-1-brian@purestorage.com>
References: <20261021182759.30106-1-brian@purestorage.com>
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
when a load succeeds:

- needs_ro_update() now sets force_readonly whenever it returns true:
  to 1 for a DISK_RO=1 uevent, to 0 when all of the map's paths are
  writable, and from the paths' state when the map has no dm info.
  uev_update_path() no longer sets or clears it itself.

- ev_add_path() sets it from all of the map's paths rather than only
  the path being added, and only when it is about to load the map
  (need_do_map). mpp->paths is up to date there after adopt_paths(),
  while mpp->pg doesn't contain the new paths yet.

- update_map(), which does reloads that were delayed while the map was
  waiting for udev (UDEV_WAIT_RELOAD), recomputes it from the map's
  paths before setting up the map.

- dm_addmap() clears it after a successful load, as it does for
  need_reload, so it can't outlive the load it was set for.

Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 libmultipath/devmapper.c |   4 +-
 multipathd/main.c        | 113 +++++++++++++++++++++++++--------------
 2 files changed, 75 insertions(+), 42 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index e3870f59..c2939dca 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -520,8 +520,10 @@ dm_addmap (int task, const char *target, struct multipath *mpp,
 	if (task == DM_DEVICE_CREATE)
 		libmp_udev_wait(cookie);
 
-	if (r)
+	if (r) {
 		mpp->need_reload = false;
+		mpp->force_readonly = 0;
+	}
 	return r;
 }
 
diff --git a/multipathd/main.c b/multipathd/main.c
index 9bce4d6b..605e24ae 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -709,6 +709,42 @@ void cleanup_reset_vec(struct vector_s **v)
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
 static int
 update_map (struct multipath *mpp, struct vectors *vecs, int new_map)
 {
@@ -732,6 +768,14 @@ retry:
 
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
@@ -1270,28 +1314,6 @@ out:
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
@@ -1305,7 +1327,6 @@ ev_add_path (struct path * pp, struct vectors * vecs, int need_do_map)
 	int retries = 3;
 	int start_waiter = 0;
 	int ret;
-	int ro;
 	unsigned char prflag = PR_UNSET;
 
 	/*
@@ -1370,14 +1391,16 @@ rescan:
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
@@ -1597,23 +1620,35 @@ static bool
 needs_ro_update(struct multipath *mpp, int ro)
 {
 	struct pathgroup * pgp;
-	struct path * pp;
-	unsigned int i, j;
+	unsigned int i;
 
 	if (!mpp || ro < 0)
 		return false;
-	if (!has_dm_info(mpp))
+	if (!has_dm_info(mpp)) {
+		mpp->force_readonly = 0;
+		vector_foreach_slot (mpp->pg, pgp, i) {
+			if (has_ro_path(pgp->paths)) {
+				mpp->force_readonly = 1;
+				break;
+			}
+		}
 		return true;
+	}
 	if (mpp->dmi.read_only == ro)
 		return false;
-	if (ro == 1)
+	if (ro == 1) {
+		mpp->force_readonly = 1;
 		return true;
+	}
 	vector_foreach_slot (mpp->pg, pgp, i) {
-		vector_foreach_slot (pgp->paths, pp, j) {
-			if (sysfs_get_ro(pp) == 1)
-				return false;
-		}
+		if (has_ro_path(pgp->paths))
+			return false;
 	}
+	/*
+	 * Clear force_readonly in case it is still set from an earlier
+	 * failed load.
+	 */
+	mpp->force_readonly = 0;
 	return true;
 }
 
@@ -1732,15 +1767,11 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
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


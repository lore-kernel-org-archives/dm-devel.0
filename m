Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792624815;
	b=nZJIy/5VXSHCJa4rg6FBArsxCdKcLBjvLxiEUkrQ/X0t0FgUhXPOwU5fa/MGa9xhTsO/
	 KZ9HJ81/GOWCsEqkYMNZu0pTwPPoxR3uygPZY174DcsPGqIC7PAcM62kbYy0AxPdGvQWa
	 avPovvdCb7d5hCWhmiKMmbqecQ2u6M7uuxhAeRg+dhrOjnquWNBBs3hTxWrcAYAOpaoaN
	 CJiQbLAfjcReOYQvnFLvy2rMqPtkEVOnYRKqJBeTdN6AHg0f9YVCiCh83z92bAsuvlDAy
	 Yo2AoCQv0i1gLuiU6dMKhGk/5mZQTyOtV9HgOc42kDSvD6/uhbkQclQl8USroIsVPWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792624815;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=1/CYyVJUn/GS2AjCqu0vlIqVNz2wTFto3KqARkXjEf0=;
	b=kLkobtRJAXy0d3hdWXK1lWu6s4x9fTjlwYFDJ2YXN5oeqTTuS+LU3oa0nbDeYK4MaOit
	 lxbjYrwG7gbN3sIMh00aDm4jPjDS+/0Z57yandE0SjBQDWcYu8faYQqxLf6+RCZS4HfFP
	 tXF6sLjc2w0yyN/gKQvePEpYPqFaB9sn8GLG6XgU6MjV2l05IhG7gWRILFbdFS/N0h+zS
	 UHajKXxGElJms2CFpk2y3LvFUpy6Styw+IlZpuPr8Tse3P1QgHTAigDSSSbn92ZhqcZa4
	 9qt1gsButI4vxX0wxR0RzOLSq3H4HNJ+opyCmaf0WfdwbXc47/fPiRwfD1J2/aEQpYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=CnpYQTRR;
	arc=none smtp.remote-ip=74.125.82.172
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B473606A31B
	for <dm-devel@lists.linux.dev>; Wed, 21 Oct 2026 23:20:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6B473606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=CnpYQTRR
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-3535bf8b3e0so2430151eec.0
        for <dm-devel@lists.linux.dev>; Wed, 21 Oct 2026 16:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1792624813; x=1793229613; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1/CYyVJUn/GS2AjCqu0vlIqVNz2wTFto3KqARkXjEf0=;
        b=CnpYQTRRIQ8GBtG4pcQFCNCKhoFDWS+/obPPHWEnaDZAlQ/kwkWLZqpcXXov5bfFgA
         cJOGBdplnsV8PgjliWCH3t1eYFV0Nzy2DNVUK5gpfOsJI6iN9/ovd2f0dNSzmnyigaSa
         ruw1pFp7b8HOVVREBC+1IdSGcplyT5xzn0Oc5AJOlWjmoZsF1N2c6ff+/nPWkTI5tSsK
         8AXtTeMkVxi6WL7G6n+kTfNsQ8v8EeI70+7u8DswpeiyeLfkWAxRFVEUpTih2vtQ5z0c
         9zU/6vAEEQp/WF6Y1COLb4jqxULx8XGNbBMN+siaN/gl+vc5cfhaWjf7goJ38+Esphsj
         mUpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792624813; x=1793229613;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1/CYyVJUn/GS2AjCqu0vlIqVNz2wTFto3KqARkXjEf0=;
        b=ptFgld+2wIkDMPV22S8Z9Ku2rCJtFof0r/AVcOYkeJ/1iJC70MBG5xdf6g76rLV1ew
         j2LCJkAlgrq9GRG4XLEV7v/VN4t35T9J7tmvKRlntZPdYBAlFUu2RxqqI6FwPdNorTg2
         uuSxdDIRXotxvqtYO0IPCiNO12d/LY/+VAf85Urk2OqHSUM4cQmvp6xl08kTgxKrUoAi
         qz7s57bVJITp1QKl5gJ6lZ0YNIv2CzEcbkXcEbwSXX2hcs1zBb9PMmWVh3zrW0i9VN+L
         bCn3hxNB+Gu+5H89k+xsz+e2DZN8SCAMCIX4+gfpWBRBCSI2UruTvprh2YK/apzU+f4r
         xN3A==
X-Gm-Message-State: AFq9FYIMbHAR8Dm0IZ6y4572BbyfTBYQLHpIwzyXjNRJ02bG9csh+VTn
	UxY8yuJgCvJDjsvKRDoIX1YNTfpFwbr8yjqvCE0tH37FYZtxLPphoVKsDr/IKc5FaEfFcT5SuJH
	2iFISG1hGWFT2Pwj351d9ClH5aiWeuA1R9S61LRegLvi5jCP/ciAMXJrRfYkqR2rSsQiYdFNnmy
	aVxxMynHSn7nVKD3Go2zIPHhX+i4X1Un7ucChnzXQirHXajrM=
X-Gm-Gg: AYBFou39iZ0/SIRsXvNcO/+1/w/npQE/p02YBXlSWBu3PZebgHmn/RIWSic4OUQXmt1
	zooOWXqC2lDh1fJXV8vyAJuHX0/molJSyV0iXUme+068qEc3ckpi0pQSXb5ISajC7YJD3XCuD3G
	ki5M/RLwxlU1BkBQfTmrkREZv8PDoRJF9Phw0aRyW36jr9/EFm1lpL4oT1jTFLq+YuKAnnZ1Fv9
	5bJCVuTfwp8vjkrNrFNJ+/Fq10tjJ6kcw7Y8QJ3gVDeuxFU3lwa5pzM270m/FO3Y2dlzVygK3td
	kyFBqBj4r0fG8HWjzRvvWCWVoB40YDG28qB33OtEJcIfSkOJ8NktaGXGxHmAum0/u9X7LbLZ/5r
	HQfCOP3FO+a/wp7VCrvIEJkHFDBwRECh355jToe6ZWgH6eOO4hB+bNKd7sz/33PQDeamTZCofGb
	JjAG5TzpPoSelFfnkWPSW/nTcZZMTtmr2R/ZN9LBImgZLdgrVOEsdD1EbXRRN5MYDYhS7QtUkyf
	ZW7Szu+jGL1FS5C2DqJpWXP9DBjnufn5tUrrYrrvUYoR3GWLdo9Dw+JNIu1N8tN+FzDBCt0MOnF
	3cfRkJnOxGSPWls5pHjxfoEjMA09DmlOLGF9nFOL/9ypACGPVynNADRjtv9O/B6AYByzi/q7jFQ
	y2Nv2kOPSQbEfS5ms6KKbuNGbI1hER3n5nx4wOuzk4RUp1w89ImUEgo2aMlr1CKtIxm66V/GV5n
	Nh
X-Received: by 2002:a05:7022:298:b0:188:e51:e86a with SMTP id a92af1059eb24-1909fc7cb20mr4075087c88.2.1792624813112;
        Wed, 21 Oct 2026 16:20:13 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([136.226.79.111])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1903bb7f098sm14372742c88.12.2026.10.21.16.20.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 21 Oct 2026 16:20:12 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: dm-devel@lists.linux.dev
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Brian Bunker <brian@purestorage.com>
Subject: [PATCH v3 1/1] multipathd: don't leave maps read-only after write protect is cleared
Date: Wed, 21 Oct 2026 16:19:59 -0700
Message-ID: <20261021231959.69270-2-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261021231959.69270-1-brian@purestorage.com>
References: <179261848556.617150.17378002460197797656.b4-review@b4>
 <20261021231959.69270-1-brian@purestorage.com>
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
  have read it, so it only applies to the load it was set for, even if
  that load fails. Otherwise a failed load would leave it set, and a
  later reload for an unrelated reason, such as a path group change,
  would load the map read-only.

Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 libmultipath/devmapper.c |  17 +++++--
 multipathd/main.c        | 104 +++++++++++++++++++++++----------------
 2 files changed, 75 insertions(+), 46 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index e3870f59..c994715e 100644
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
@@ -578,19 +583,23 @@ int dm_addmap_create (struct multipath *mpp, char *params)
 int dm_addmap_reload(struct multipath *mpp, char *params, int flush)
 {
 	int r = 0;
+	int force_ro = mpp->force_readonly;
 	uint16_t udev_flags = build_udev_flags(mpp, 1);
 
+	/* As in dm_addmap_create(), force_readonly only applies to this load */
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
diff --git a/multipathd/main.c b/multipathd/main.c
index 9bce4d6b..c5788ef9 100644
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
@@ -1597,23 +1620,24 @@ static bool
 needs_ro_update(struct multipath *mpp, int ro)
 {
 	struct pathgroup * pgp;
-	struct path * pp;
-	unsigned int i, j;
+	unsigned int i;
 
 	if (!mpp || ro < 0)
 		return false;
-	if (!has_dm_info(mpp))
-		return true;
+	if (!has_dm_info(mpp) &&
+	    dm_get_info(mpp->alias, &mpp->dmi) != DMP_OK) {
+		condlog(2, "%s: failed to get dm info", mpp->alias);
+		return false;
+	}
 	if (mpp->dmi.read_only == ro)
 		return false;
-	if (ro == 1)
-		return true;
-	vector_foreach_slot (mpp->pg, pgp, i) {
-		vector_foreach_slot (pgp->paths, pp, j) {
-			if (sysfs_get_ro(pp) == 1)
+	if (ro == 0) {
+		vector_foreach_slot (mpp->pg, pgp, i) {
+			if (has_ro_path(pgp->paths))
 				return false;
 		}
 	}
+	mpp->force_readonly = ro;
 	return true;
 }
 
@@ -1732,15 +1756,11 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
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


Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8328814A96
	for <dm-devel@lists.linux.dev>; Wed, 17 Apr 2024 18:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713379623; cv=none; b=tP9P+xmftkR5J20g5NjSzaRQQ3LSWPawvsw0KYLCvC4GnxR3sUxgyDqF7iB0gM6eGlAHfSddYqIHvd7R1qIjoGBbWWHT19+BR/2R4ZJd/VXw2Mb8i2hzucFIw762Zj5bcBiDk4iPHWAvftS2+vBSk/01iX10/mjVEpSmLFToINM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713379623; c=relaxed/simple;
	bh=Oqb6UXlQRZ4MkuGarXB8tFvIBVigD0yxdWr9Y+YlEXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AxR6YN5nkMjK+gZzBx/+R+TIUZk+BQcgr+O6iRouigUEYwz9H8VgwEYl4MAM/nGYBAQuz9NmAuPZcbmYXmBP/rwwsqIgslVo827JOW6JgeaFOEUfWrlIGE9sagjuSw6kAmBc79kNvtz956bfMdi/9QejH9eqG8oGyyHPrKbSMnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ig7JooY4; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ig7JooY4"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a55692e09c9so10977366b.0
        for <dm-devel@lists.linux.dev>; Wed, 17 Apr 2024 11:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1713379620; x=1713984420; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v2eBvjLt81/TLit0FrLrg/nOi5eX+QqzSNRXc3RJe4Q=;
        b=Ig7JooY4cJCH/N3XdkC+MFCZOCEjSEFwl1gR4dzPaPe06TJA4M/rT9d8W7HMmfLRGP
         HUIhmQ+zEGqoaJorUrmmzbfia58Bbpl5TKFz/HQB5ZwgHs83/Wu3FRVpbzI1quR4pi7W
         nC8QxNbikhq94Irs/JSYEuRSkJfknZzqNo7ND9znDTh9MDvAr0mPahBuEdnhN5alfSTN
         WEUoirf8OeQKaRYBS1MyDqOZOO3o/ycL+5K/eRrIPqCIFj1+5Fw9nLO0Mdh7s6AylIne
         siUKTn4pzVVHdvv4XKCeoTXHWEKJHI2wMCw492riThTsTCzzTYUSZUcIsxHAdMowD8J2
         AVog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713379620; x=1713984420;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v2eBvjLt81/TLit0FrLrg/nOi5eX+QqzSNRXc3RJe4Q=;
        b=G2u+8OmIrzrI8TFK7Jw4AN2BIgTErRdgQU99k0ZFuynarBNoG3+PhZBBGFfrBD293V
         C6+57/RfeBT5DCEkPG65rn6SRqPk+/n1u9lsypPrgbPVH5KaTESymjU0hjKgSslS24RP
         PKhG/269bDqaLbWndqjyBYToImz4sDNOumB4YTwKPHXK1LzmU62sObUPB00dQNI3zSA+
         AQ3moFIGFlxFUcUP0rivyHZjIq9YTD5YASUWUNNPpiOWYkJSNB2avmS8xzjkgxR+lfJv
         WOrFGIiyoHSfN57NoTLRkwjVHTa+cjVWHhiiBlkq/USRybNoGuzlTxT/85kStWKFjn4T
         +5Hw==
X-Gm-Message-State: AOJu0YwDbSWjn2nz4cAapCllVVKIRdGXmbn3haJJejlPp24BCzyMxy70
	/LW+CdvFwWXzS0HV+sczbZtgIO4cFztaIhUO9LFZN9bNcCb5FO9Xveeupa1A7lqoSzom3lqByez
	e
X-Google-Smtp-Source: AGHT+IF0fK8CWpl1QmRrwSE87eY22aDD4vo6Whtldb5h1i9oCoXaq3TgeixWZpbXNBps/9zOqt/JLQ==
X-Received: by 2002:a50:d598:0:b0:570:5e97:c023 with SMTP id v24-20020a50d598000000b005705e97c023mr344017edi.33.1713379619805;
        Wed, 17 Apr 2024 11:46:59 -0700 (PDT)
Received: from localhost (dslb-090-186-231-154.090.186.pools.vodafone-ip.de. [90.186.231.154])
        by smtp.gmail.com with UTF8SMTPSA id d6-20020aa7c1c6000000b005704049eaecsm2455519edp.1.2024.04.17.11.46.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Apr 2024 11:46:59 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Etienne AUJAMES <eaujames@ddn.com>
Subject: [PATCH 5/8] libmultipath: Only set max_sectors_kb on map creation
Date: Wed, 17 Apr 2024 20:46:41 +0200
Message-ID: <20240417184644.6193-6-mwilck@suse.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240417184644.6193-1-mwilck@suse.com>
References: <20240417184644.6193-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changing max_sectors_kb on a live map is dangerous. When I/O occurs while the
max_sectors_kb value of a map is larger than that of any of its paths, I/O
errors like this may result:

  blk_insert_cloned_request: over max size limit. (127 > 126)

This situation must be strictly avoided. The kernel makes sure that the
map's limits match those of the paths when the map is created. But setting
max_sectors_kb on path devices before reloading is dangerous, even if we
read the value from the map's max_sectors_kb beforehand. The reason for
this is that the sysfs value max_sectors_kb is the kernel's max_sectors
divided by 2, and user space has no way to figure out if the kernel-internal
value is odd or even. Thus by writing back the value just read to
max_sectors_kb, one might actually decrease the kernel value by one.

The only safe way to set max_sectors_kb on a live map would be to suspend
it, flushing all outstanding IO, then the path max_sectors_kb, reload,
and resume.

Since commit 8fd4868 ("libmultipath: don't set max_sectors_kb on reloads"),
we don't set the configured max_sectors_kb any more. But as shown above,
this is not safe. So really only set max_sectors_kb when creating a map.

Users who have stacked block devices on top of multipath, as described in the
commit message of 8fd4868 must make sure that the max_sectors_kb setting is
correct when the multipath map is first created. Decreasing the map's
max_sectors_kb value (without touching the paths) should actually be possible
in this situation, because stacked block devices are usually bio-based, and
bio-based IO (in contrast to request-based) can be split if the lower-level
device has can't handle the size of the I/O.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c | 38 ++++----------------------------------
 1 file changed, 4 insertions(+), 34 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 13602f3..8cbb2a8 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -566,46 +566,18 @@ trigger_paths_udev_change(struct multipath *mpp, bool is_mpath)
 	mpp->needs_paths_uevent = 0;
 }
 
-static int
-sysfs_set_max_sectors_kb(struct multipath *mpp, int is_reload)
+static int sysfs_set_max_sectors_kb(struct multipath *mpp)
 {
 	struct pathgroup * pgp;
 	struct path *pp;
 	char buff[11];
 	ssize_t len;
 	int i, j, ret, err = 0;
-	struct udev_device *udd;
-	int max_sectors_kb;
 
 	if (mpp->max_sectors_kb == MAX_SECTORS_KB_UNDEF)
 		return 0;
-	max_sectors_kb = mpp->max_sectors_kb;
-	if (is_reload) {
-		if (!has_dm_info(mpp) &&
-		    dm_get_info(mpp->alias, &mpp->dmi) != 0) {
-			condlog(1, "failed to get dm info for %s", mpp->alias);
-			return 1;
-		}
-		udd = get_udev_for_mpp(mpp);
-		if (!udd) {
-			condlog(1, "failed to get udev device to set max_sectors_kb for %s", mpp->alias);
-			return 1;
-		}
-		ret = sysfs_attr_get_value(udd, "queue/max_sectors_kb", buff,
-					   sizeof(buff));
-		udev_device_unref(udd);
-		if (!sysfs_attr_value_ok(ret, sizeof(buff))) {
-			condlog(1, "failed to get current max_sectors_kb from %s", mpp->alias);
-			return 1;
-		}
-		if (sscanf(buff, "%u\n", &max_sectors_kb) != 1) {
-			condlog(1, "can't parse current max_sectors_kb from %s",
-				mpp->alias);
-			return 1;
-		}
-	}
-	snprintf(buff, 11, "%d", max_sectors_kb);
-	len = strlen(buff);
+
+	len = snprintf(buff, sizeof(buff), "%d", mpp->max_sectors_kb);
 
 	vector_foreach_slot (mpp->pg, pgp, i) {
 		vector_foreach_slot(pgp->paths, pp, j) {
@@ -923,7 +895,7 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
 			return DOMAP_RETRY;
 		}
 
-		sysfs_set_max_sectors_kb(mpp, 0);
+		sysfs_set_max_sectors_kb(mpp);
 		if (is_daemon && mpp->ghost_delay > 0 && count_active_paths(mpp) &&
 		    pathcount(mpp, PATH_UP) == 0)
 			mpp->ghost_delay_tick = mpp->ghost_delay;
@@ -934,7 +906,6 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
 
 	case ACT_RELOAD:
 	case ACT_RELOAD_RENAME:
-		sysfs_set_max_sectors_kb(mpp, 1);
 		if (mpp->ghost_delay_tick > 0 && pathcount(mpp, PATH_UP))
 			mpp->ghost_delay_tick = 0;
 		r = dm_addmap_reload(mpp, params, 0);
@@ -942,7 +913,6 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
 
 	case ACT_RESIZE:
 	case ACT_RESIZE_RENAME:
-		sysfs_set_max_sectors_kb(mpp, 1);
 		if (mpp->ghost_delay_tick > 0 && pathcount(mpp, PATH_UP))
 			mpp->ghost_delay_tick = 0;
 		r = dm_addmap_reload(mpp, params, 1);
-- 
2.44.0


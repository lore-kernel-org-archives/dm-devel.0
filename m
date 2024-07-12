Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C729517C6B
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804579; cv=none; b=A7FxdxWsv9zdJcicTqvRmxWu9OcFzizDgo2QAAPnqPD3lKCzOmZuiJgJrHcP6zI+XBX3Ek71DA91z0aPrtPiiOVYLFZQUK0huzjORh58ZwHhzHcWZIua8fGt2qYSqLLisb4c4IJ0su9oYj+6g/VWiJtYObPjg6958jmb9i3JvpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804579; c=relaxed/simple;
	bh=0SefcOZA2VGyfnGdP9TrIvcSJBuU2atdXx6iWLAxW5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MFmqlTtV+QPf7p+2asj0xZHBiIg2pi6HMbbUfro+p6pDtw4FlSaFvnAaMdg9DPEJLQqvPtizxw39aaWhyM2g7CQh4jrODaLCVIojdMAI9du1UF91SyHrsXpa00uQuuPPxoyD7DeXCt03jr7ajaz+Va3DCsyjgd0PHkw0kogBtAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aIuD/vOQ; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aIuD/vOQ"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-57cf8880f95so2808015a12.3
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804576; x=1721409376; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4t6Jj3ad2vs5+I9v4godq/mHLy5FWdIDHzP5z/52gbc=;
        b=aIuD/vOQhqs2FVvFreefuT8lFgoVw9+8Ary2iaYGRIxt065lQ0QGe9kmh6D1KWNgck
         DGuPvqMBW145s3cCd6KSpXhNLTLdf8kBgzu6oUgMwPm3s4bTNaZXNr8tSaNDTZUghJhK
         JEZinP5sPe8ct0Gvgdfhe4b4lwXcmhYQ5Obsl7b8A4I8lJY8L8QRyc+2Gz6l9rQL/P6+
         Iy2LALzcFcfopjA5rMSk3kVFWP5O1X3wAVy88UOG+2gMNFpawPwr+lWP+NSFP7N3pbFA
         xq4wipDKLBttROCFBal/aqO/LQCky/irZyTaUdBB+PJjaycgv8qVrVJQOJV9p4a6xxQT
         RMow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804576; x=1721409376;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4t6Jj3ad2vs5+I9v4godq/mHLy5FWdIDHzP5z/52gbc=;
        b=u9uPbi9EdtfXhZPp8N2qqY9MJiSghjtoO7YbEkZUqNDp2Ok8xDJp2Y8ixZ4w+BpDLE
         OcRON1EWSAQU0yE+EKbdJW2gmho9ybGZFpiKKYdtWrbZAJlU9nXg3PxU/g9WoGMeVYmz
         HLWxxXWphIJzfU8wOGhM3qxZiOPGK0lKlMMo2/KmM9UNKcx1qIcuv58UN696oEEQN3GA
         a909naj5OK6ND+BbI/yQQJIENTHaTrXRNcPr3Oqgs5WryvugsCSbJwatCoYyqMY0jWEn
         22YeB/IGOECqeDMnFBfy6pCbRQKn54DEAKX5k/yFkbilAiHS8sie4r0uBdxW8GuVKFrV
         IKDQ==
X-Gm-Message-State: AOJu0Yx2iEtDLZtxLU992rVL7NE+Z+z29SWymPRZEMNkpk3I02SJIe5j
	+mJzseIhI85Piz7qoPV6Qs7w867AYjl0/Lfbe9KAnkXF0+8RxASxvzsyeqK/FIk=
X-Google-Smtp-Source: AGHT+IFDjWLmYBJl4YRdH0aMP6zTqhOU9J/dj8dEtlGFyxIXN38BEP63hN5BO3aZfrFUDOlLhUsKJg==
X-Received: by 2002:a17:906:e0d4:b0:a72:9001:ed73 with SMTP id a640c23a62f3a-a780b88277amr993221166b.50.1720804576148;
        Fri, 12 Jul 2024 10:16:16 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a87213dsm361138966b.221.2024.07.12.10.16.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:16:16 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 42/49] multipathd: implement add_map_without_path() with libmp_mapinfo()
Date: Fri, 12 Jul 2024 19:14:50 +0200
Message-ID: <20240712171458.77611-43-mwilck@suse.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240712171458.77611-1-mwilck@suse.com>
References: <20240712171458.77611-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Also, change the return value to int, as this is more expressive and
the returned struct multipath isn't used by the caller.

Also remove the call to sync_map_state() in ev_add_map(), which is
redundant because add_map_without_path() would have called update_map()
and thus sync_map_state() already.

Note: this removes the call to remove_map() at the end of the function,
which doesn't make sense anyway, because update_multipath_table()
would not return error unless the table disassembly failed, in which
case nothing would have been added the the mpvec or pathvec yet.
It should be sufficient to just cleanup the local data structures when
add_map_without_path() fails.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 79 ++++++++++++++++++++++++-----------------------
 1 file changed, 41 insertions(+), 38 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 1e7a6ac..536974c 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -707,51 +707,57 @@ fail:
 	return 0;
 }
 
-static struct multipath *
-add_map_without_path (struct vectors *vecs, const char *alias)
+static int add_map_without_path (struct vectors *vecs, const char *alias)
 {
-	struct multipath * mpp = alloc_multipath();
+	struct multipath __attribute__((cleanup(cleanup_multipath_and_paths)))
+		*mpp = alloc_multipath();
+	char __attribute__((cleanup(cleanup_charp))) *params = NULL;
+	char __attribute__((cleanup(cleanup_charp))) *status = NULL;
 	struct config *conf;
+	char uuid[DM_UUID_LEN];
+	int rc = DMP_ERR;
 
-	if (!mpp)
-		return NULL;
-	if (!alias) {
-		free(mpp);
-		return NULL;
-	}
+	if (!mpp || !(mpp->alias = strdup(alias)))
+		return DMP_ERR;
 
-	mpp->alias = strdup(alias);
+	if ((rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY,
+				(mapid_t) { .str = mpp->alias },
+				(mapinfo_t) {
+					.uuid = uuid,
+					.dmi = &mpp->dmi,
+					.size = &mpp->size,
+					.target = &params,
+					.status = &status,
+				})) != DMP_OK)
+		return rc;
+
+	if (!is_mpath_uuid(uuid))
+		return DMP_NO_MATCH;
+	else
+		strlcpy(mpp->wwid, uuid + UUID_PREFIX_LEN, sizeof(mpp->wwid));
 
-	if (dm_get_info(mpp->alias, &mpp->dmi) != DMP_OK) {
-		condlog(3, "%s: cannot access table", mpp->alias);
-		goto out;
-	}
-	if (!strlen(mpp->wwid) &&
-	    dm_get_wwid(mpp->alias, mpp->wwid, WWID_SIZE) != DMP_OK) {
-		condlog(3, "%s: cannot obtain WWID", mpp->alias);
-		goto out;
-	}
 	if (!strlen(mpp->wwid))
 		condlog(1, "%s: adding map with empty WWID", mpp->alias);
+
 	conf = get_multipath_config();
 	mpp->mpe = find_mpe(conf->mptable, mpp->wwid);
 	put_multipath_config(conf);
 
-	if (update_multipath_table(mpp, vecs->pathvec, 0) != DMP_OK)
-		goto out;
+	if ((rc = update_multipath_table__(mpp, vecs->pathvec, 0, params, status)) != DMP_OK)
+		return DMP_ERR;
 
 	if (!vector_alloc_slot(vecs->mpvec))
-		goto out;
+		return DMP_ERR;
+	vector_set_slot(vecs->mpvec, steal_ptr(mpp));
 
-	vector_set_slot(vecs->mpvec, mpp);
+	/*
+	 * We can pass mpp here, steal_ptr() has just nullified it.
+	 * vector_set_slot() just set the last slot, use that.
+	 */
+	if (update_map(VECTOR_LAST_SLOT(vecs->mpvec), vecs, 1) != 0) /* map removed */
+		return DMP_ERR;
 
-	if (update_map(mpp, vecs, 1) != 0) /* map removed */
-		return NULL;
-
-	return mpp;
-out:
-	remove_map(mpp, vecs->pathvec, vecs->mpvec);
-	return NULL;
+	return DMP_OK;
 }
 
 static int
@@ -865,14 +871,9 @@ int
 ev_add_map (char * dev, const char * alias, struct vectors * vecs)
 {
 	struct multipath * mpp;
-	int reassign_maps;
+	int reassign_maps, rc;
 	struct config *conf;
 
-	if (dm_is_mpath(alias) != DM_IS_MPATH_YES) {
-		condlog(4, "%s: not a multipath map", alias);
-		return 0;
-	}
-
 	mpp = find_mp_by_alias(vecs->mpvec, alias);
 
 	if (mpp) {
@@ -910,10 +911,12 @@ ev_add_map (char * dev, const char * alias, struct vectors * vecs)
 	/*
 	 * now we can register the map
 	 */
-	if ((mpp = add_map_without_path(vecs, alias))) {
-		sync_map_state(mpp);
+	if ((rc = add_map_without_path(vecs, alias)) == DMP_OK) {
 		condlog(2, "%s: devmap %s registered", alias, dev);
 		return 0;
+	} else if (rc == DMP_NO_MATCH) {
+		condlog(4, "%s: not a multipath map", alias);
+		return 0;
 	} else {
 		condlog(2, "%s: ev_add_map failed", dev);
 		return 1;
-- 
2.45.2


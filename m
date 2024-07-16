Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F07954673
	for <dm-devel@lists.linux.dev>; Tue, 16 Jul 2024 20:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721163249; cv=none; b=TnMSSS32LFxVu1dJCXYDXpfIM6kvBAEEEq7eFXA6VMcgrNHj2cSLMFUAcWa5oDEo2R8w7sVUo6ReKTgpkFfTztFkAp3B72WdgtYybgg/Oywk4ONsw8asEZH0JWArqvFpdRImcZI2H5NG/bSnEeAovHxTD+HiEZy+mTcFRxn9Rwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721163249; c=relaxed/simple;
	bh=GweVNAqcZa9BKq5VD8ofvk2pAhBaeBgRzh4dPQOvBbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zq2417TN7TaZAlsUr4H1KnKx8FXTiKEH9ittF9VAaDNeZqJfHl9tzUfYRAKohyqLgZQF8boPRZ9XNH6X6H1aeD9AAaoGuxbti3Jv8oVgjdWABp4cuDBAjqc2rWRfeIOHF8KEc/yMK30pmjzHLCUGRvznki8kXP72iMhHXoKWbmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KmupzFgd; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KmupzFgd"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-52ea34ffcdaso6505174e87.1
        for <dm-devel@lists.linux.dev>; Tue, 16 Jul 2024 13:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721163245; x=1721768045; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EO+kKpFf+oG6lWy22jU3Kfjo0Qyea68mUaTXA7pruVo=;
        b=KmupzFgdRG5DlZr3wUH7ay6iePDaUhm0HIMKc7VldRL6/eaIAZwdYDAFlbxWtRyOJh
         D789GSw7i281ImjLJXhc585mGlo9jg5zCp81uDFY2NeotAnrU2HrsAayspj8hsGK/nEk
         HnbSf41/eVynaHhhQoLxmPLeBf6g2X9MKJO1qHK1gzzPrSSiWeBAJ1yhLvnyiQNz7ndY
         BYhofrgJuaOySIakjzeVL37p4C4LvMcJZJFz8eAVG+lUM8MqEElbdmiRdb+rEg9sFPn0
         cDx5uMpZKcQOPKyfmhmLOXNr6i9ZVheHgj2Su4D3qzqaNShuMEoeE1IVdY9SCYYsp6KB
         zbng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721163245; x=1721768045;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EO+kKpFf+oG6lWy22jU3Kfjo0Qyea68mUaTXA7pruVo=;
        b=rJk5o2qySW9VJFMuG9l+OgIZc6bDZnM64FTNQp2VF7n5YNCmG4mPZNKTcpzWnm/gYs
         jIf5AuZD73xU4q777MFbvSfgWy+oJS71+HUtOzf2derusJ/H+GtJdmMEz/s0kaYWCLYR
         F586c3UjfthPJnbk+jdqX7NnGSJ2bPI6VvnvlMgiWib3JpBAEEzlDMOjZzgRIbiXTcMj
         XtlVPi9TaVG9emuFqUWsEm1TeQc/I/UacQ8d1urTOnaVkU0i62xIyzZQ/6xbf0iUxv8o
         FcPOlTtbGlfmoNwMB/zIjL8Ergyj1Jz0RrkoWdtcDfGYUasDUHrWlTNJka/WDUDYGK7t
         ej1A==
X-Gm-Message-State: AOJu0YyTTYyYKR7xTNppO0gpyWVDF55i5trS/ePYSsaJ9QcgZNLBc8+3
	ioKj1ctULEP4diFegkQMj366JgZbC8QuQ9JfFyWv6UGwOje3O4GwNW6DIewguNQ=
X-Google-Smtp-Source: AGHT+IFdF0cecF7ATqUOZeBEVARs3IKwee8082XMGNmjIC7glIEWBPe5u8k5N//ClJmrT0iNz1flJQ==
X-Received: by 2002:a05:6512:ea6:b0:52c:db4e:8dfc with SMTP id 2adb3069b0e04-52edf032eb5mr2083603e87.65.1721163244527;
        Tue, 16 Jul 2024 13:54:04 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a79bc5b7edfsm361369066b.68.2024.07.16.13.54.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jul 2024 13:54:04 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH v3 42/49] multipathd: implement add_map_without_path() with libmp_mapinfo()
Date: Tue, 16 Jul 2024 22:53:42 +0200
Message-ID: <20240716205344.146310-5-mwilck@suse.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716205344.146310-1-mwilck@suse.com>
References: <20240716205344.146310-1-mwilck@suse.com>
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
index 1e7a6ac..32011c9 100644
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
+	 * We can't pass mpp here, steal_ptr() has just nullified it.
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


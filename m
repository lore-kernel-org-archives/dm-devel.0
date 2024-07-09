Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3108918562D
	for <dm-devel@lists.linux.dev>; Tue,  9 Jul 2024 21:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561229; cv=none; b=QSPSujSN370JM8i8zzvNsAXBkUxeLPzY25402a1OQncoQNrt8W1ekLB0yOTRs9NbuV0R11HvUTsFELkLV7mL2rBjDpmf9Sp5aewKMYqCnsuyZiVAniPGZWMDMdNzVJpMhcKwAgNT7hJiFFg1WEuf9R1dpvmy14LDgbj3LNnBk2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561229; c=relaxed/simple;
	bh=0aP5E//cpd2+LFPciApI3ZGg8ZAX7pnmhH+F5MpfZzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HzRj7JzevYwiJZrNFToB8qr3L6w47hDVkSvA8svzPJButQ/NnG0MwErhY1U7Air1lagtsx3i531xamzwPdtQmZkAmB/V0A3m71AWSSZpUDJ0sCu5SEbHvlm2LZo4XHXyZm5Det86djVVm2WWbuXfQLKA9OaLNNt/CJ7pUtWj0v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=RIeLH8ff; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="RIeLH8ff"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-52ea2ce7abaso7635750e87.0
        for <dm-devel@lists.linux.dev>; Tue, 09 Jul 2024 14:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720561225; x=1721166025; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7lpqCjYsPcG0uUiH2tzp+60eXf8ot/bmvAS/AsFKwIw=;
        b=RIeLH8ffMO1qnU4MK7s6MgxmR9cYCx1FP8lxfZNyxMcx304LcqYe/x4I8kngkun1Xx
         lOGN5pidvWn92rQ6NiUJfzxZt0UBOMAM3iy5/Tn5iaSQnD4WRf0MkGXb1Q7b9STpK3Kc
         nqrRVxVLRvaF3J0lveN8ssMAQMrQiuaBXtO5Lm+8cWUaEIo7GwGaEnlRw4eaNZij12rC
         SEJhfX/6iUEZZyYDEvtdhRyIoFIoufRRGPu5u8On6YZP/qfrjW1/Og91+/zQMiyCaRHe
         GDMniJfkRcQhRuU3R6cd/IRGJoNqtz0Doxf/hn6JTzX7rjANAWyuvumFVPNnvdbO6Ygu
         rfew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720561225; x=1721166025;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7lpqCjYsPcG0uUiH2tzp+60eXf8ot/bmvAS/AsFKwIw=;
        b=SEs61Gahlwa5lnnam6isFYdNms4b3CLOKnsJ6YPr9swk6zzBrtFmD2JIsrZFhGJlRW
         bhiHAH2Mb/+Z+18vAVKPAEZLVGJRNKWa63C3mLknYqeg0YYpjhy3gy1kYynJGn4CVLlv
         EfND1avt9KP3KrkF3yMQSjx81SAhKzRfhw6H6JcAqbGkdMelGQsniPVpKofnoEWP5BM4
         HQPdIcoY6Rb9CHp0u3ubY2z/oX4G2OLpnq0p1Jd20X/ts//PrjnAvzwpsQnZ3riP5q9R
         j8svS3r3vNLxY0CXom7lt6GtGjRWwrUJ2/Lg7vvAntMsAJVEgpTlVEXHfh9qc5ALGUrz
         BgVQ==
X-Gm-Message-State: AOJu0YxOOjn1DXFbvsznQiiJnyi2PDzEVmPoZUMHWD1ESVcLT2sovv7Z
	ykL0LQWaoMEf/ks3PCuDakX1Cs0FeNeobVweVJuj6LpUEt1fDliX1FpYvg9b//I=
X-Google-Smtp-Source: AGHT+IFls4kLacC2cUtPpws0IXCl3vb0Nxxr94hSgGvPh26iEjUxTkusST9OoglmDUFbVRVP/MbnFQ==
X-Received: by 2002:a05:6512:3b20:b0:52c:adc4:137c with SMTP id 2adb3069b0e04-52eb99949a2mr2749743e87.20.1720561225188;
        Tue, 09 Jul 2024 14:40:25 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-594bbe2d006sm1467718a12.31.2024.07.09.14.40.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:40:25 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 40/44] multipathd: implement add_map_without_path() with libmp_mapinfo()
Date: Tue,  9 Jul 2024 23:39:31 +0200
Message-ID: <20240709213935.177028-41-mwilck@suse.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709213935.177028-1-mwilck@suse.com>
References: <20240709213935.177028-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Also, change the return value to int, as this is more expressive and
the returned struct multipath isn't used by the caller.

Note: this removes the call to remove_map() at the end of the function,
which doesn't make sense anyway, because update_multipath_table()
would not return error unless the table disassembly failed, in which
case nothing would have been added the the mpvec or pathvec yet.
It should be sufficient to just cleanup the local data structures when
add_map_without_path() fails.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 69 ++++++++++++++++++++++++-----------------------
 1 file changed, 36 insertions(+), 33 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 442a154..9e82188 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -707,48 +707,53 @@ fail:
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
+	if ((rc = libmp_mapinfo(DM_MAP_BY_NAME,
+				(mapid_t) { .str = mpp->alias },
+				(mapinfo_t) {
+					.uuid = uuid,
+					.tgt_type = TGT_MPATH,
+					.dmi = &mpp->dmi,
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
-	if (!strlen(mpp->wwid))
-		dm_get_wwid(mpp->alias, mpp->wwid, WWID_SIZE);
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
-
-	vector_set_slot(vecs->mpvec, mpp);
+		return DMP_ERR;
+	vector_set_slot(vecs->mpvec, steal_ptr(mpp));
 
 	if (update_map(mpp, vecs, 1) != 0) /* map removed */
-		return NULL;
+		return DMP_ERR;
 
-	return mpp;
-out:
-	remove_map(mpp, vecs->pathvec, vecs->mpvec);
-	return NULL;
+	return DMP_OK;
 }
 
 static int
@@ -862,14 +867,9 @@ int
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
@@ -907,10 +907,13 @@ ev_add_map (char * dev, const char * alias, struct vectors * vecs)
 	/*
 	 * now we can register the map
 	 */
-	if ((mpp = add_map_without_path(vecs, alias))) {
+	if ((rc = add_map_without_path(vecs, alias)) == DMP_OK) {
 		sync_map_state(mpp);
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


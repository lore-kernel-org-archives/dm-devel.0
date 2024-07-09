Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14755189F22
	for <dm-devel@lists.linux.dev>; Tue,  9 Jul 2024 21:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561219; cv=none; b=jcv7ET7L8e21HHmbV+aMdvBCSJ1g771vDr/ZF+Fndpw95+GtTxpyfNUjwn9wLadIgxNibHLMYZscRYA12a5LgWVGZchvS5bGHWPabacfmWEnuwSjhoPtJlTCRD98dnUY48k5tSfyf1np0GIrQJ4ar/SEMr+BR1MZZg5xSVWAWTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561219; c=relaxed/simple;
	bh=wm1e40gUxzFuSfpPjnNQ+V/mDBsnqCaSTOkX6hmJIn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tkT1vMMIw5cXT4C1ONRLZmmZEFmnDHOAcyXs2Q9N+Xf17JivdsKtk89JEreuui7DjPlbbabx0pPyippzl6wVmOArP3tekgfSFs4AGfWm+CAh9xNWzgRR2nJggzQ24ZsKlLBSZfhc/btw8CqTBDKa0tR6IpiSB70U+fSJz0UJKWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=U6of9Pmy; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="U6of9Pmy"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a77bf336171so34070866b.1
        for <dm-devel@lists.linux.dev>; Tue, 09 Jul 2024 14:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720561215; x=1721166015; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h9VdPzY1OlazbFV1Ek6cNvLVlraOsQCHaeouX6HfzBc=;
        b=U6of9PmybE8JrXgsD5suA4nizRh0t1vS+fvZ7p1VW0wovmtFl7RlUf18sDPUSik9e7
         +q+lBZqzHpF0aHJstS7kuUegEPbA0Xmqq9BwjJvV5kBjS9HzLTGZDSb1glCPHXN036wm
         I5kXcIBa6T2lRE3O/jHJo7L17+Y9EY0mtjCd9CiIsqBvCkgUWbePVJGavBJa40HuSxTJ
         elEmhQpSoKkmjYXiLv8qeT2p2/T7hh5dFLBwQLoRPZK/d4xawIiMYkFl9G3me4cKk0P2
         cU9KQRytxC150ImkmtgAXJHLduU2Rqgi+AgCvki0N6Jfw4Z9QI2AEDk3bIt++VC72jOz
         7cnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720561215; x=1721166015;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h9VdPzY1OlazbFV1Ek6cNvLVlraOsQCHaeouX6HfzBc=;
        b=jKmvbpmYgCaYAle5vsRy1N+qX6Xdm75K/ASWRr+d3pa/6VmidyjzIgJFsFbAOljbBK
         A2TRWE1k0GdCPozlydpAMOz3w6lfeoSfdCaTuxXW5LMSFYEOKehgqlIjPUNdGc60pJKR
         yxwHkXLGmMbeLOq9x5pkUg0er7ffGfM1WmVQPjZo4VeIWxLsY/FKNBM7g3iPkkSaiOfV
         ur+m7BazjOLcHq6+oDWi5B3AAQpfZ3sw18cfT7AiEglahaa8zmEQGh6Q/5SaakPQ0IuK
         Y3Hf0DhKpN1fct4A9tU6BNYDlsgrogBMcjgslxp3/esUrLhSfOSqDEMT4mEN+1GmPTiA
         5zGg==
X-Gm-Message-State: AOJu0YznB1nMTUM5vUFxZJBfym1M36q8w4IPYzarzVBOMgWhTn122hgB
	9wQ+Xgbc4V58iakL//WQz159wKtFKnXZDgxFM10cbfJbH1s67L49qgyd/1ORnMI=
X-Google-Smtp-Source: AGHT+IF+IA+jJdq+swaQdtsTGVppAZkW5FayTAi3kIjeSZmj9em1GoMrEvSuNGNyRYHUF5hvNYNbMw==
X-Received: by 2002:a17:906:b0c:b0:a72:75a5:bb42 with SMTP id a640c23a62f3a-a780d28ed3fmr229167266b.29.1720561215510;
        Tue, 09 Jul 2024 14:40:15 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a730394sm109297466b.95.2024.07.09.14.40.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:40:15 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 29/44] libmultipath: implement dm_get_multipath() with new API
Date: Tue,  9 Jul 2024 23:39:20 +0200
Message-ID: <20240709213935.177028-30-mwilck@suse.com>
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

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 6276041..bfe202a 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1284,7 +1284,8 @@ dm_disablegroup(const char * mapname, int index)
 
 struct multipath *dm_get_multipath(const char *name)
 {
-	struct multipath *mpp = NULL;
+	struct multipath __attribute((cleanup(cleanup_multipath))) *mpp = NULL;
+	char uuid[DM_UUID_LEN];
 
 	mpp = alloc_multipath();
 	if (!mpp)
@@ -1293,20 +1294,23 @@ struct multipath *dm_get_multipath(const char *name)
 	mpp->alias = strdup(name);
 
 	if (!mpp->alias)
-		goto out;
+		return NULL;
 
-	if (dm_get_map(name, &mpp->size, NULL) != DMP_OK)
-		goto out;
+	if (libmp_mapinfo(DM_MAP_BY_NAME,
+			  (mapid_t) { .str = name },
+			  (mapinfo_t) {
+				  .size = &mpp->size,
+				  .uuid = uuid,
+				  .dmi = &mpp->dmi,
+				  .tgt_type = TGT_MPATH
+			  }) != DMP_OK)
+		return NULL;
 
-	if (dm_get_wwid(name, mpp->wwid, WWID_SIZE) != DMP_OK)
-		condlog(2, "%s: failed to get uuid for %s", __func__, name);
-	if (dm_get_info(name, &mpp->dmi) != 0)
-		condlog(2, "%s: failed to get info for %s", __func__, name);
+	if (strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN))
+		return NULL;
 
-	return mpp;
-out:
-	free_multipath(mpp, KEEP_PATHS);
-	return NULL;
+	strlcpy(mpp->wwid, uuid + UUID_PREFIX_LEN, sizeof(mpp->wwid));
+	return steal_ptr(mpp);
 }
 
 int dm_get_maps(vector mp)
-- 
2.45.2


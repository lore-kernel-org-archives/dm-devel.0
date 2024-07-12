Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D09C174EF8
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804568; cv=none; b=W0JqAclCuJw4tidO4L4wBTiCQEUuAdY0brpWV8JKhQUl4Shxj421Md7Y5So4BlaPQUA8H7j0TXaE3njzKCylIHFNdlNlM2wdoKscufpz341cAPYaQ0G/vxaJ1bO3IT8n9FUBXLPjMzasbymFdu9LJKpLDeSbDTrJsQbscwR0UiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804568; c=relaxed/simple;
	bh=oESVIlTvO/5abDWegJygZFZAnJNqDSMmX8tBYhUIsR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L1iffSGG0Au9KUo93VsgbMTKjDtJkAv7vcsYSaF1KyiY6wKK5QatfUcnQ7gRksVAI85wHKb0csPlATjFqrd7OqNfLp9A3fpOsP061u/UkwXMv6Vwcf02bSGGYHe5i1bd7IxlbNaYwfYiFJywPQXg0L14wYxUfbreptknfIWkveI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HCxNRIIX; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HCxNRIIX"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a77c1658c68so279309966b.0
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804565; x=1721409365; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I7N36qMCpcSl6TETGX5COtXj99LlnsyTYf2d/0laR8c=;
        b=HCxNRIIXvJFWOAVDekOhuqzoY1Y9bJx25M0kw7WnapwRxS3BbMsPEgqU9KDF1J6FUY
         ZFSXmT0dLkFzgt+xiyVE5VuhlPWacfV3Zkh7YXZJliJc6VEa0fHq+l/Qmok2jdwNakLa
         Cnonbwavivx/CRiorsIb4hSsb1jq9QwgkMuRVt82s/RSi+Fc0DVaiMBSWlzY/hCI5NvI
         ZK4N7Ab1XZ/agT1LaONVQFrLBXULWKAgAswi324GkNdds4JrXYySSRt29ADcCu0NWDBO
         kPcqhBpbA+/dBapDOO3Cq5sS9pGpOIsK9fSx8e6vd3BaX4NafdQ/lhlighuUWo3FZ931
         msHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804565; x=1721409365;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I7N36qMCpcSl6TETGX5COtXj99LlnsyTYf2d/0laR8c=;
        b=MHZaWAxFY9ze6ySqoiMwKZ+fE9g7tWfWtizteHCqFmqk4HX6RL8JBPxjqrD5uQxrt9
         SORDL+OIEUIfkWEW1z4xTmODBH9mB/QkVQdO9AWfrzaC/7iy9Ek8aDEDAkhwrh7kqhmz
         qZL0v5GvM9VzB64AlxtN9upjW23F5CIpFu89ispgKpFx5qYvg1fKlpizCgiKgSAFPMKV
         gtaitTIHEN1+z7krrSWflFGGpZUb/F1fJxjtoO7n2KYWzUHbrYo7bB99f2V3Hpnl9lCk
         H2n8hUvzsillhnxtwgJ4YRao2DXgPS5OxEzFUVzmR8yVMjK9qcIHFo8XN8LV+HmeV46w
         lvUA==
X-Gm-Message-State: AOJu0YxAYV0Z+ah8WWs9JRFwi9a7rzELInFnX8hkNLptyqyZMjoLsCli
	XiGRxzTJbDjpF2oxXHRFrBkxBbu+Vr3tkhwLQ29dDIzn4gypn39kr2sbP7IEdMc=
X-Google-Smtp-Source: AGHT+IGG7tvY3kLK2g/swpkF+Q57NJcii2DP69L5Bo8Ydp5Ci/bB2Q9lSBGiPJvyIOmEeAVlPtQnJg==
X-Received: by 2002:a17:906:af09:b0:a6f:6029:998f with SMTP id a640c23a62f3a-a780b705436mr715243566b.46.1720804564605;
        Fri, 12 Jul 2024 10:16:04 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a7ff73bsm361701066b.101.2024.07.12.10.16.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:16:04 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 31/49] libmultipath: implement dm_get_multipath() with new API
Date: Fri, 12 Jul 2024 19:14:39 +0200
Message-ID: <20240712171458.77611-32-mwilck@suse.com>
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

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 11bccb1..2f547ab 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1302,7 +1302,8 @@ dm_disablegroup(const char * mapname, int index)
 
 struct multipath *dm_get_multipath(const char *name)
 {
-	struct multipath *mpp = NULL;
+	struct multipath __attribute((cleanup(cleanup_multipath))) *mpp = NULL;
+	char uuid[DM_UUID_LEN];
 
 	mpp = alloc_multipath();
 	if (!mpp)
@@ -1311,22 +1312,22 @@ struct multipath *dm_get_multipath(const char *name)
 	mpp->alias = strdup(name);
 
 	if (!mpp->alias)
-		goto out;
+		return NULL;
 
-	if (dm_get_map(name, &mpp->size, NULL) != DMP_OK)
-		goto out;
+	if (libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY,
+			  (mapid_t) { .str = name },
+			  (mapinfo_t) {
+				  .size = &mpp->size,
+				  .uuid = uuid,
+				  .dmi = &mpp->dmi,
+			  }) != DMP_OK)
+		return NULL;
 
-	if (dm_get_wwid(name, mpp->wwid, WWID_SIZE) != DMP_OK) {
-		condlog(2, "%s: failed to get uuid for %s", __func__, name);
-		mpp->wwid[0] = '\0';
-	}
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


Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BFD3176FDF
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804567; cv=none; b=EUX6Zzs2wfPFqr06mIXpKZTqwZHrlvPayH38JB0h9tliUGZA3ko5RA11HKGST+XBFaFSd/LGfdBSybZ28sqwJvkuzpXPrPiLqtIlYlV2/tN9bq+wu255KN0V05RgUJTFZDY2+GrDdvaIAsFY4j8NO4nkvxDIS8hztMhSrh+ypnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804567; c=relaxed/simple;
	bh=CpUi9ryYZ9UT1cESP/YEM9Hlk43mDR6clCNFL3HA4S8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QrW9bQurKcKtDm6MIW6H89Vx/M2TbcNtlzLMrBOtb27pQdyc+O82JaWJ/QXceE+Mcw0afE9TxzfuGU+xV/TF/o6QZ/hF0cxQGhjbbS+nO/S4VARiBU2kM0Iznp9yDqzj6ALsOSbkPRuERwVBiOwWww/PbAGT39zq60ZSk7Mr7tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SLYOuuAZ; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SLYOuuAZ"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2eeb2d60efbso26562491fa.1
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804564; x=1721409364; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Wn1uWuzvav9H0JMIm7n9qmYN7T2+TrD9QXFyG47DaU=;
        b=SLYOuuAZMXgQLv2rB7bBddqs5pI8eXkmKG0xE6xFI9fWL+PtJanOt6+VZ82VHSUG7Z
         EVzkmMloqZxfj20WsHpZjSHOi65W4sVkeX/Rn1vK5KMrfeTH4I8IYq0xRJ5YytU1q0st
         ljCei/SR0+sZYKyHuTc/zyt6PtxpPlQTY8jgY6mFC8Hi+IMke/JC6eYJ1AGd6qEz8f+/
         OT0I8MtcSjVScqFvtMuFfrLCjocE46ZMXdSH176xD3eyPA9SuM/oUage7KWTNdu/nhp5
         Z2spznqmDLuw87c/S3MsoNReywZYpvUfl04/EfrfIYNdA9udGJVdhepmUwks09YNrDDx
         GzRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804564; x=1721409364;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9Wn1uWuzvav9H0JMIm7n9qmYN7T2+TrD9QXFyG47DaU=;
        b=ZbD9AvQJ0+J/ZIm1BQ6yFFPPaJ6J3yUc+8oXno5HtGL+TXDmyTuNukDib/8qxjFy7S
         ojN7OHTMEUNq5pmB+qFm29MbNkmU+rDPRUaDnelheTQgsSRyyfNTg6l5PAk9mD+Ep8eb
         zzkAf9EtwvsUVBWvXShyx31sOxXvTMRB+H9XcEoH47RncGnkQFsh5f+V0papQc/skvd+
         GznAQie4th5TeB7fg7KMjc25ALIwUEZ9zGP1FYj+ZUdUvb67e+pNd1jjGCFnwDYH12od
         o1bGXSHqqNhTEpQzJNc2CkKSUNNjFCofTodUdPYQmwxPLEwQQIWhrmXCPRsRReRvJp5f
         9Rmw==
X-Gm-Message-State: AOJu0YxF+E1wtZRkCTKbpCaarAm5yrXv7aMR9ST2tf6k8qTax0JV20in
	qP00Cc4eyo+DiV9F4pIwnc3LDEc8w32q5krKu6Bvgwt6qB5+CuOsVZeSNl/SzV8=
X-Google-Smtp-Source: AGHT+IEDTQkNEliO3LAvvSVzWzYKOSDroZNbLcgpw5OIRuYBnKGteYHyesVZ+RX+Ka40TAiHRvA9kg==
X-Received: by 2002:a2e:a4ad:0:b0:2ec:3d2e:2408 with SMTP id 38308e7fff4ca-2eeb317175emr80829981fa.33.1720804563611;
        Fri, 12 Jul 2024 10:16:03 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-594bb96042fsm4766405a12.5.2024.07.12.10.16.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:16:03 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 30/49] libmultipath: implement dm_is_mpath() with new API
Date: Fri, 12 Jul 2024 19:14:38 +0200
Message-ID: <20240712171458.77611-31-mwilck@suse.com>
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
---
 libmultipath/devmapper.c | 59 ++++++++++------------------------------
 1 file changed, 15 insertions(+), 44 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 47ff827..11bccb1 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -975,52 +975,23 @@ static int dm_type_match(const char *name, char *type)
 
 int dm_is_mpath(const char *name)
 {
-	int r = DM_IS_MPATH_ERR;
-	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
-	struct dm_info info;
-	uint64_t start, length;
-	char *target_type = NULL;
-	char *params;
-	const char *uuid;
+	char uuid[DM_UUID_LEN];
+	int rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY,
+			       (mapid_t) { .str = name },
+			       (mapinfo_t) { .uuid = uuid });
 
-	if (!(dmt = libmp_dm_task_create(DM_DEVICE_TABLE)))
-		goto out;
-
-	if (!dm_task_set_name(dmt, name))
-		goto out;
-
-	if (!libmp_dm_task_run(dmt)) {
-		dm_log_error(3, DM_DEVICE_TABLE, dmt);
-		goto out;
+	switch (rc) {
+	case DMP_OK:
+		if (!strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN))
+			return DM_IS_MPATH_YES;
+		/* fallthrough */
+	case DMP_NOT_FOUND:
+	case DMP_NO_MATCH:
+		return DM_IS_MPATH_NO;
+	case DMP_ERR:
+	default:
+		return DM_IS_MPATH_ERR;
 	}
-
-	if (!dm_task_get_info(dmt, &info))
-		goto out;
-
-	r = DM_IS_MPATH_NO;
-
-	if (!info.exists)
-		goto out;
-
-	uuid = dm_task_get_uuid(dmt);
-
-	if (!uuid || strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN) != 0)
-		goto out;
-
-	/* Fetch 1st target */
-	if (dm_get_next_target(dmt, NULL, &start, &length, &target_type,
-			       &params) != NULL)
-		/* multiple targets */
-		goto out;
-
-	if (!target_type || strcmp(target_type, TGT_MPATH) != 0)
-		goto out;
-
-	r = DM_IS_MPATH_YES;
-out:
-	if (r == DM_IS_MPATH_ERR)
-		condlog(3, "%s: dm command failed in %s: %s", name, __func__, strerror(errno));
-	return r;
 }
 
 int dm_map_present_by_wwid(const char *wwid)
-- 
2.45.2


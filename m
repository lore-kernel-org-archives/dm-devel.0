Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C0B187878
	for <dm-devel@lists.linux.dev>; Tue,  9 Jul 2024 21:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561207; cv=none; b=dXAm84vd6gldz9XbqYnTNeEcTRvH54t8VqYmkYwr+TBOwO41EEWGtNwqwc9Isn+pegww7/MgesN1l4fY2eJflJTqcx5MAiRcEOMoEVHrNZRDJoNYkB5Iy20z1yaB1qRfxN7WbXaUOCGb/lP62DJr7Loev+w1Jd3gPzh39d7ZJuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561207; c=relaxed/simple;
	bh=5azA+96xjxAf/3cdlZ8QO4L0n3Xyk9ehEouToGEdoxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qjlsioiHphatMH+W1aKR/De5Y1cmDWiI0SrtB2wy6CeDbVcZqbNCGfaQ095M5gaNmLpShuwUczilrcj6E0Lp0L3+EtJFw8EKAmXCQgPleea11cR0VuTItJVPGmX8mJs2P5IwX6bYoRQK4wPiP2h8peE2PF6NiMKykVhSoxSzTN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZHLwGel8; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZHLwGel8"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a77cc73d35fso35431566b.0
        for <dm-devel@lists.linux.dev>; Tue, 09 Jul 2024 14:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720561204; x=1721166004; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dNOLoa86oCDwoFhLeNdxj1vxeRQCeNWt1xwXJCqeQbk=;
        b=ZHLwGel8EMJb4pJMuGoLJGuSCsGbl/lb9Nxc6NuyuyeSl3ghWmhqBD5UcuC2utY4z6
         g4NZDjkew/brGj9O9ZOy5RH4YtGQYIcp+BX1vAMF8cGkrlSbxv+U3FTCXRZE84YiZhNj
         yYDCRFEgEbICavsy9xlntCZxvfmcNse5NL0qLyZT7Q/TcfxXmfNrOw9cGc2fp79di/ut
         CxLjaQheSTDsFetgEVhX6Eo+8Rx2wF2di161wEqCgONsLQGJUi/wbE3o7z9hXbTL6coc
         HrLrGyEtPNyQz2GiWboq4QnPAMRIzG2oCsWoGkpAD5BOt+b9e8MJpiF70UcPX5sGTGXk
         T69A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720561204; x=1721166004;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dNOLoa86oCDwoFhLeNdxj1vxeRQCeNWt1xwXJCqeQbk=;
        b=l6PEwO9QKNEMcLmBaQXxzBSt4ACutkXQ110MH2eBJ+2uyBq39+OFOC0hYlrA4Ql1za
         sFq+Dtxq1ZT9JG1l4JLSXNew7WctMv+4B/t4369vPoir25GlHvPFnaXS2E/ZHBpSC5uo
         ODbvgTJT/5sA64gpEt+IRTIy5LV2NdaunsHHBn3XgMpVZwsGSmDJggCPengYKCNRTWnX
         N9m87qfXrdCJaCHWuCHQcKeK+66lcvKdY6YPQyn15WNR022pXJzl0nbbX8JTNPKcNmqJ
         aV5zfJxWILBuSjoE5MHf/BhO3KIJOQtj7Y8fSKtIMeyWtTpEYBDjXcaz35hqcAKb8xUx
         iJBg==
X-Gm-Message-State: AOJu0YySVlkrXU636O3wCA9ow8pPC6Ez0A1L1bLa7qVZ6EBsq7fK1LJF
	9Rncr0BzKueFLR1ewOaR0C7ndFPq7X1Vw1yGUOyM60b/5RCrlfd3LORYiXMyvjG8dL/SpOr4dEu
	s
X-Google-Smtp-Source: AGHT+IFruyo7+OYMYddabwvtX28lgVNPW5/kA15d+vmK6MpN02J1Yy34wGFJMYhNbysV3RCmEt7LiQ==
X-Received: by 2002:a17:906:c151:b0:a77:a1f1:cfa0 with SMTP id a640c23a62f3a-a780d30b945mr287928066b.36.1720561203883;
        Tue, 09 Jul 2024 14:40:03 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a6e04fesm107717966b.68.2024.07.09.14.40.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:40:03 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 20/44] libmultipath: remove dm_get_prefixed_uuid()
Date: Tue,  9 Jul 2024 23:39:11 +0200
Message-ID: <20240709213935.177028-21-mwilck@suse.com>
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

... and replace it by calls to the new API.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 53 +++++++++-------------------------------
 1 file changed, 11 insertions(+), 42 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index bdeba48..56157af 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -783,6 +783,13 @@ int libmp_mapinfo(int flags, mapid_t id, mapinfo_t info)
 			       libmp_map_identifier(flags, id, idbuf));
 }
 
+static int dm_get_dm_uuid(const char *mapname, char uuid[DM_UUID_LEN])
+{
+	return libmp_mapinfo(DM_MAP_BY_NAME,
+			     (mapid_t) { .str = mapname },
+			     (mapinfo_t) { .uuid = uuid });
+}
+
 int dm_get_map(const char *name, unsigned long long *size, char **outparams)
 {
 	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
@@ -822,48 +829,11 @@ int dm_get_map(const char *name, unsigned long long *size, char **outparams)
 	}
 }
 
-static int
-dm_get_prefixed_uuid(const char *name, char *uuid, int uuid_len)
-{
-	struct dm_task *dmt;
-	const char *uuidtmp;
-	struct dm_info info;
-	int r = 1;
-
-	dmt = libmp_dm_task_create(DM_DEVICE_INFO);
-	if (!dmt)
-		return 1;
-
-	if (uuid_len > 0)
-		uuid[0] = '\0';
-
-	if (!dm_task_set_name (dmt, name))
-		goto uuidout;
-
-	if (!libmp_dm_task_run(dmt)) {
-		dm_log_error(3, DM_DEVICE_INFO, dmt);
-		goto uuidout;
-	}
-
-	if (!dm_task_get_info(dmt, &info) ||
-	    !info.exists)
-		goto uuidout;
-
-	uuidtmp = dm_task_get_uuid(dmt);
-	if (uuidtmp)
-		strlcpy(uuid, uuidtmp, uuid_len);
-
-	r = 0;
-uuidout:
-	dm_task_destroy(dmt);
-	return r;
-}
-
 int dm_get_uuid(const char *name, char *uuid, int uuid_len)
 {
 	char tmp[DM_UUID_LEN];
 
-	if (dm_get_prefixed_uuid(name, tmp, sizeof(tmp)))
+	if (dm_get_dm_uuid(name, tmp) != DMP_OK)
 		return 1;
 
 	if (!strncmp(tmp, UUID_PREFIX, UUID_PREFIX_LEN))
@@ -874,16 +844,15 @@ int dm_get_uuid(const char *name, char *uuid, int uuid_len)
 	return 0;
 }
 
-static int
-is_mpath_part(const char *part_name, const char *map_name)
+static int is_mpath_part(const char *part_name, const char *map_name)
 {
 	char *p;
 	char part_uuid[DM_UUID_LEN], map_uuid[DM_UUID_LEN];
 
-	if (dm_get_prefixed_uuid(part_name, part_uuid, sizeof(part_uuid)))
+	if (dm_get_dm_uuid(part_name, part_uuid) != DMP_OK)
 		return 0;
 
-	if (dm_get_prefixed_uuid(map_name, map_uuid, sizeof(map_uuid)))
+	if (dm_get_dm_uuid(map_name, map_uuid) != DMP_OK)
 		return 0;
 
 	if (strncmp(part_uuid, "part", 4) != 0)
-- 
2.45.2


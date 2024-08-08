Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C81190052
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 15:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130814; cv=none; b=CrFxBeiBWdIj1ZHLlB9AJWsbEiULJX2wSWD94p140FKCOt0nTSe2tOfKQJ1+JsUabNse+zU6ImSJUH4OmgOK3rsh2dkVMwjYNmiLuOzZXduEa3YBuS9a6N5z6gOjecQJYLG1m44DFF51PhQQNBAB0ZNggsscQVQgi9uTqSFMpnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130814; c=relaxed/simple;
	bh=YldyASmHQR6yBsZtvwE1UTiXJc5S3SoQKOO/hgkj35U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LMysTUk+dHtTuM/mcfZCU41d3OPbCWF0IfqDz773JcVPLH3PHfInmxpsKIBqGG2XprgEh1b+w3aUwKERtEynca0kIXF7scKnSNplX97K++O2MypPUBCiUWz/xgaFecHiVkFnnjIFon4vK8VpLD5dl1a0Y4ievEVnZChiRk/+0jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ERYCytZk; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ERYCytZk"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5b8c2a611adso1477110a12.1
        for <dm-devel@lists.linux.dev>; Thu, 08 Aug 2024 08:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723130810; x=1723735610; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iBExBQRh3j/9Rh2atBVlds4Oyhd4/qDgaeQVZMCb2Qc=;
        b=ERYCytZkCZDl7WkLIXpBIMkWT/cjSTSRh9fTrcPqe3BFk/9Ex/heO8Zme8ymS1Da9y
         A0rkvcH39RGuMygXAwNuTro6wL6QI4kdMDOS804G8HFAFDC9N8oCPC9OcH1lTZzEC5bN
         b2Zb2yrg8Bxwv4oIkK0eREE/vOOxmih8EsrQdPk48PTME0b+NcI5jrPulGVV3FjO5y3i
         iAq/EcROS/yyvWtLs2FcHk0QzniL558ZnCsDDXHq8BxrtvDcDCpdUBhjBfLdk3jJonbu
         20vEZMshZFqG857UCeAAEC07X5kFiScvd3fYQ8hi86+FL4dOxxmiO5mPCd9IzKKhMOaE
         y0uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723130810; x=1723735610;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iBExBQRh3j/9Rh2atBVlds4Oyhd4/qDgaeQVZMCb2Qc=;
        b=okfNCLCBnK8fUS6V571eUqV14J+nVv5Bw+v4lHPoqH6UuaMU+U1QhTQyy73k8A7IfQ
         KbgVte0+T/LqD8oKRlYNJ9zrte9T2RqmZqO/K+03IzRrzeitcgi0cUo3SQ39chK+w5mZ
         dygRVGTUHEWdlcvjuJilb2ryKq3q8JqdNEPK2vgszDYr2EBXBmM4GKN+xfGR4dkPXZA7
         trT9JSBpMorKmvrIBdppyfroJcq5uXPHX8XPfnMy3sT5zZaDQMCU4SmwcHbIYm6KRLJK
         cRQltG5if4oCLBvqS9AWDLI8QEunNZwrZs1ItWtOwVH4+WqMUGWKsrMfsO6VzCNTnJHE
         1Oag==
X-Gm-Message-State: AOJu0YwLtToat4eUFNDtDw/vY5xJyV4nXa8LzWmdp1VbYZ4GKHr2Cvpt
	bUYVJXiVNnN5GcmaeGyyHzA/0LtFom5mh7QlSLf5C5d6iXgFbVbOFVlPAXaFDJg=
X-Google-Smtp-Source: AGHT+IEkp5NsFgC3IHHuA7P+NEUKEREIzAgCE61ywFY4cqmWefjS4/j0JtCE67IS349vB/fEhYRVcg==
X-Received: by 2002:a17:907:f71d:b0:a7a:9144:e242 with SMTP id a640c23a62f3a-a8090c6eb5fmr169446766b.27.1723130810094;
        Thu, 08 Aug 2024 08:26:50 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a7dc9ecb129sm751177366b.222.2024.08.08.08.26.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 08:26:49 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 16/41] libmultipath: rename identifiers with leading underscores in devmapper.h
Date: Thu,  8 Aug 2024 17:25:55 +0200
Message-ID: <20240808152620.93965-17-mwilck@suse.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240808152620.93965-1-mwilck@suse.com>
References: <20240808152620.93965-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 16 ++++++++--------
 libmultipath/devmapper.h | 12 ++++++------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index fe604f1..0a4b586 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -86,10 +86,10 @@ const char *dmp_errstr(int rc)
 		[DMP_OK] = "success",
 		[DMP_NOT_FOUND] = "not found",
 		[DMP_NO_MATCH] = "target type mismatch",
-		[__DMP_LAST__] = "**invalid**",
+		[DMP_LAST__] = "**invalid**",
 	};
-	if (rc < 0 || rc > __DMP_LAST__)
-		rc = __DMP_LAST__;
+	if (rc < 0 || rc > DMP_LAST__)
+		rc = DMP_LAST__;
 	return str[rc];
 }
 
@@ -624,7 +624,7 @@ has_dm_info(const struct multipath *mpp)
 
 static int libmp_set_map_identifier(int flags, mapid_t id, struct dm_task *dmt)
 {
-	switch (flags & __DM_MAP_BY_MASK) {
+	switch (flags & DM_MAP_BY_MASK__) {
 	case DM_MAP_BY_UUID:
 		if (!id.str || !(*id.str))
 			return 0;
@@ -682,7 +682,7 @@ static int libmp_mapinfo__(int flags, mapid_t id, mapinfo_t info, const char *ma
 	 */
 	if (info.target && !info.status)
 		ioctl_nr = DM_DEVICE_TABLE;
-	else if (info.status || info.size || flags & __MAPINFO_TGT_TYPE)
+	else if (info.status || info.size || flags & MAPINFO_TGT_TYPE__)
 		ioctl_nr = DM_DEVICE_STATUS;
 	else
 		ioctl_nr = DM_DEVICE_INFO;
@@ -715,7 +715,7 @@ static int libmp_mapinfo__(int flags, mapid_t id, mapinfo_t info, const char *ma
 		return DMP_NOT_FOUND;
 	}
 
-	if (info.target || info.status || info.size || flags & __MAPINFO_TGT_TYPE) {
+	if (info.target || info.status || info.size || flags & MAPINFO_TGT_TYPE__) {
 		if (dm_get_next_target(dmt, NULL, &start, &length,
 				       &target_type, &params) != NULL) {
 			condlog(2, "%s: map %s has multiple targets", fname__, map_id);
@@ -725,7 +725,7 @@ static int libmp_mapinfo__(int flags, mapid_t id, mapinfo_t info, const char *ma
 			condlog(2, "%s: map %s has no targets", fname__, map_id);
 			return DMP_NOT_FOUND;
 		}
-		if (flags & __MAPINFO_TGT_TYPE) {
+		if (flags & MAPINFO_TGT_TYPE__) {
 			const char *tgt_type = flags & MAPINFO_MPATH_ONLY ? TGT_MPATH : TGT_PART;
 
 			if (strcmp(target_type, tgt_type)) {
@@ -797,7 +797,7 @@ static int libmp_mapinfo__(int flags, mapid_t id, mapinfo_t info, const char *ma
 /* Helper: format a string describing the map for log messages */
 static const char* libmp_map_identifier(int flags, mapid_t id, char buf[BLK_DEV_SIZE])
 {
-	switch (flags & __DM_MAP_BY_MASK) {
+	switch (flags & DM_MAP_BY_MASK__) {
 	case DM_MAP_BY_NAME:
 	case DM_MAP_BY_UUID:
 		return id.str;
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index b5330ab..d9c08fd 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -35,15 +35,15 @@ enum {
 	DMP_OK,
 	DMP_NOT_FOUND,
 	DMP_NO_MATCH,
-	__DMP_LAST__,
+	DMP_LAST__,
 };
 
 const char* dmp_errstr(int rc);
 
 /**
- * enum mapinfo_flags: input flags for libmp_mapinfo()
+ * input flags for libmp_mapinfo()
  */
-enum __mapinfo_flags {
+enum {
 	/** DM_MAP_BY_NAME: identify map by device-mapper name from @name */
 	DM_MAP_BY_NAME      = 0,
 	/** DM_MAP_BY_UUID: identify map by device-mapper UUID from @uuid */
@@ -52,12 +52,12 @@ enum __mapinfo_flags {
 	DM_MAP_BY_DEV,
 	/** DM_MAP_BY_DEVT: identify map by a dev_t */
 	DM_MAP_BY_DEVT,
-	__DM_MAP_BY_MASK    = (1 << 8) - 1,
+	DM_MAP_BY_MASK__    = (1 << 8) - 1,
 	/* Fail if target type is not multipath */
 	MAPINFO_MPATH_ONLY  = (1 << 8),
 	/* Fail if target type is not "partition" (linear) */
 	MAPINFO_PART_ONLY   = (1 << 9),
-	__MAPINFO_TGT_TYPE  = (MAPINFO_MPATH_ONLY | MAPINFO_PART_ONLY),
+	MAPINFO_TGT_TYPE__  = (MAPINFO_MPATH_ONLY | MAPINFO_PART_ONLY),
 	/* Fail if the UUID doesn't match the multipath UUID format */
 	MAPINFO_CHECK_UUID  = (1 << 10),
 };
@@ -92,7 +92,7 @@ typedef struct libmp_map_info {
 
 /**
  * libmp_mapinfo(): obtain information about a map from the kernel
- * @param flags: see __mapinfo_flags above.
+ * @param flags: see enum values above.
  *     Exactly one of DM_MAP_BY_NAME, DM_MAP_BY_UUID, and DM_MAP_BY_DEV must be set.
  * @param id: string or major/minor to identify the map to query
  * @param info: output parameters, see above. Non-NULL elements will be filled in.
-- 
2.46.0


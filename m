Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45D1176AB1
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804573; cv=none; b=i/1jWDOyo96qZXt9Huicf1GXtKFCBGbpbnB+HZy1X2N3RmEbhi7wFUZj5PPgg27Ptt99I/T1av+hPqlKWRjtTVazjJKmnZuomQ0hiMQdKidDPiNmhIYkOa3pS8Wy16FW+0GO9jQ1HhYgKT05W4riQNeJBnRyuXTmv2MLxXvncUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804573; c=relaxed/simple;
	bh=BEDR0u26pztS4Q43SaC5sQX0wkvfVRn2KrHxFGkwjqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sOmVehQORsE+VUgYe2NWgSZKpCNktP2NgoPyL2X3Q2b8hPHKdwSHgm5nWLqI6/P9O7194owD46F7ecA0LtzfujIManQDip9VY1Rk+B6ufKDC5WP8+Mn9IPea/vObQ639hLQLmJc6WGE6CVZtKRtPmozA+sNB7MoVGtTL0caSdtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Gs7SBqvm; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Gs7SBqvm"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5957040e32aso1405670a12.2
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804570; x=1721409370; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GtR/ikc0e+KVBZHlRcqPzge00dOuQp7heewk7/O9FD0=;
        b=Gs7SBqvmYTPpxqvnem3GExAAkg/fHfyIZkaPXAVn0q78VQjst48ggPTmqXRZB/paAQ
         XLs8c5BbM+geep4e55PyUl9ntVXG3tSTJ4I3sqRP48dFH4g4rI+PeXARVnA0/A3PCOmD
         ++0P2Rw8RMoKTZH/RYPb2pb6/dlSLDHkB9AVccBqE6PKTfCGoXi+bWdwUrmA94WejHS/
         lmIFfg2UWONNBBQalXMEwjny7IbyJulosvq2ZtShNr0aoFk5B5ohpBELbXVYPwIdFb6O
         s38LWKp4sZazmEz1KtFJe3uP3HqRakNQrG82Y6bnFB+tAPQlgrUXh996kpvGNVBwmYv6
         7ZWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804570; x=1721409370;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GtR/ikc0e+KVBZHlRcqPzge00dOuQp7heewk7/O9FD0=;
        b=jECS3uKr9RiKEemWxP55h2yAJO11bPFao5ST9QVi54Qizmj0tNVtzW5czzIFjkE58e
         hS+O6wnqrnHN5ZW3f9gG3GqLRGvVEPlzxuvySTxZm1hj/8XvWZJPHwEJ4rEnT/0US07G
         etwZq1yHZeZy0zNUkiGmAkGXtSwXbTOkAGEUOsn7i1HYL5DHRmuY/39u7c0wTJ83zrmK
         A/BZIluFBom+EIrW0A8ly42ICnpmUZMhqfxp6brM2uUOZHleSJ1rCD48IabfbPObXKel
         gMPagG92F+g+ATk3C9lNaWYGPzcJwSDxAM1UCmiZJhiPzyomqolxNcsErVgOdKkhCnO+
         YiAA==
X-Gm-Message-State: AOJu0Yx70z//8NYF8HErgMv6v/POeaMmeOTjWxcKTzxXmRkp5wM/HVkJ
	3FDPSNNvr3SD3k23B9/fg7Ux9MpYKP4UEzzGnK8IWxvqS5RUvJJpaPk+jOKN2M2Dbh9hdUlLzbH
	z
X-Google-Smtp-Source: AGHT+IH7KlF66LNTtKAyqd/OyKVnb+N5Z3OlDDMPWN4XzrBguvIsaBGBGvn3H1vPeZj9loehdJ6uCA==
X-Received: by 2002:a05:6402:27ce:b0:58f:41e0:8d22 with SMTP id 4fb4d7f45d1cf-594bab8083fmr14131085a12.1.1720804569924;
        Fri, 12 Jul 2024 10:16:09 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-594bbe2cca6sm4739714a12.27.2024.07.12.10.16.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:16:09 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 37/49] libmultipath: use libmp_pathinfo() in update_multipath_table()
Date: Fri, 12 Jul 2024 19:14:45 +0200
Message-ID: <20240712171458.77611-38-mwilck@suse.com>
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

This allows us to remove dm_get_status(), and dm_get_map(), of which
update_multipath_table() was the last caller.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c   | 89 --------------------------------------
 libmultipath/devmapper.h   |  2 -
 libmultipath/structs_vec.c | 26 ++++++-----
 3 files changed, 15 insertions(+), 102 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 587fc17..86ac01b 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -815,45 +815,6 @@ static int dm_get_dm_uuid(const char *mapname, char uuid[DM_UUID_LEN])
 			     (mapinfo_t) { .uuid = uuid });
 }
 
-int dm_get_map(const char *name, unsigned long long *size, char **outparams)
-{
-	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
-	uint64_t start, length;
-	char *target_type = NULL;
-	char *params = NULL;
-
-	if (!(dmt = libmp_dm_task_create(DM_DEVICE_TABLE)))
-		return DMP_ERR;
-
-	if (!dm_task_set_name(dmt, name))
-		return DMP_ERR;
-
-	errno = 0;
-	if (!libmp_dm_task_run(dmt)) {
-		dm_log_error(3, DM_DEVICE_TABLE, dmt);
-		if (dm_task_get_errno(dmt) == ENXIO)
-			return DMP_NOT_FOUND;
-		else
-			return DMP_ERR;
-	}
-
-	/* Fetch 1st target */
-	if (dm_get_next_target(dmt, NULL, &start, &length,
-			       &target_type, &params) != NULL || !params)
-		/* more than one target or not found target */
-		return DMP_NOT_FOUND;
-
-	if (size)
-		*size = length;
-
-	if (!outparams)
-		return DMP_OK;
-	else {
-		*outparams = strdup(params);
-		return *outparams ? DMP_OK : DMP_ERR;
-	}
-}
-
 bool is_mpath_uuid(const char uuid[DM_UUID_LEN])
 {
 	return !strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN);
@@ -896,56 +857,6 @@ static bool is_mpath_part_uuid(const char part_uuid[DM_UUID_LEN],
 	return !strcmp(part_uuid + nc, map_uuid);
 }
 
-int dm_get_status(const char *name, char **outstatus)
-{
-	int r = DMP_ERR;
-	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
-	uint64_t start, length;
-	char *target_type = NULL;
-	char *status = NULL;
-
-	if (!(dmt = libmp_dm_task_create(DM_DEVICE_STATUS)))
-		return r;
-
-	if (!dm_task_set_name(dmt, name))
-		goto out;
-
-	errno = 0;
-	if (!libmp_dm_task_run(dmt)) {
-		dm_log_error(3, DM_DEVICE_STATUS, dmt);
-		if (dm_task_get_errno(dmt) == ENXIO)
-			r = DMP_NOT_FOUND;
-		goto out;
-	}
-
-	r = DMP_NOT_FOUND;
-	/* Fetch 1st target */
-	if (dm_get_next_target(dmt, NULL, &start, &length,
-			       &target_type, &status) != NULL)
-		goto out;
-
-	if (!target_type || strcmp(target_type, TGT_MPATH) != 0)
-		goto out;
-
-	if (!status) {
-		condlog(2, "got null status.");
-		goto out;
-	}
-
-	if (!outstatus)
-		r = DMP_OK;
-	else {
-		*outstatus = strdup(status);
-		r = *outstatus ? DMP_OK : DMP_ERR;
-	}
-out:
-	if (r != DMP_OK)
-		condlog(0, "%s: %s: error getting map status string: %d",
-			__func__, name, r);
-
-	return r;
-}
-
 int dm_is_mpath(const char *name)
 {
 	char uuid[DM_UUID_LEN];
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 7231a98..3daaa4c 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -131,8 +131,6 @@ int dm_simplecmd_noflush (int task, const char *name, uint16_t udev_flags);
 int dm_addmap_create (struct multipath *mpp, char *params);
 int dm_addmap_reload (struct multipath *mpp, char *params, int flush);
 int dm_map_present_by_wwid(const char *uuid);
-int dm_get_map(const char *name, unsigned long long *size, char **outparams);
-int dm_get_status(const char *name, char **outstatus);
 
 enum {
 	DM_IS_MPATH_NO,
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index ccc4efc..f2cfe31 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -484,30 +484,34 @@ int
 update_multipath_table (struct multipath *mpp, vector pathvec, int flags)
 {
 	int r = DMP_ERR;
-	char *params = NULL;
+	char __attribute__((cleanup(cleanup_charp))) *params = NULL;
+	char __attribute__((cleanup(cleanup_charp))) *status = NULL;
+	unsigned long long size = mpp->size;
 
 	if (!mpp)
 		return r;
 
-	r = dm_get_map(mpp->alias, &mpp->size, &params);
+	r = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY,
+			  (mapid_t) { .str = mpp->alias },
+			  (mapinfo_t) {
+				  .target = &params,
+				  .status = &status,
+				  .size = &mpp->size,
+			  });
+
 	if (r != DMP_OK) {
-		condlog(2, "%s: %s", mpp->alias, (r == DMP_ERR)? "error getting table" : "map not present");
+		condlog(2, "%s: %s", mpp->alias, dmp_errstr(r));
 		return r;
-	}
+	} else if (size != mpp->size)
+		condlog(0, "%s: size changed from %llu to %llu", mpp->alias, size, mpp->size);
 
 	if (disassemble_map(pathvec, params, mpp)) {
 		condlog(2, "%s: cannot disassemble map", mpp->alias);
-		free(params);
 		return DMP_ERR;
 	}
 
-	free(params);
-	params = NULL;
-	if (dm_get_status(mpp->alias, &params) != DMP_OK)
-		condlog(2, "%s: %s", mpp->alias, (r == DMP_ERR)? "error getting status" : "map not present");
-	else if (disassemble_status(params, mpp))
+	if (disassemble_status(status, mpp))
 		condlog(2, "%s: cannot disassemble status", mpp->alias);
-	free(params);
 
 	/* FIXME: we should deal with the return value here */
 	update_pathvec_from_dm(pathvec, mpp, flags);
-- 
2.45.2


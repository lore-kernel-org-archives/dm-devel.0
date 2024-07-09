Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E00189F32
	for <dm-devel@lists.linux.dev>; Tue,  9 Jul 2024 21:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561224; cv=none; b=MICPXSeazVG3EeJsj9ytTz1zaWp/CdStH0TKAW1mpYJxzjFWhYWYQ4OxqHVqSX6gVfBsPHwmqYHYsmEWvXifETXPHIZU/EHAiAsnQLJs52rg+2bHzMuo9Jfc+VB18emeY3iYB/NnEJXKZBKz0dtffS2OUtg3ykP7yBjwyBbuoIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561224; c=relaxed/simple;
	bh=3KG9MEMksYD/eutXiGRdlaUuwxyDOAEd8CSqJTz6ta8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U8uCO1HTkrOKbOJDvH1E92hnf6cA2nP85aDdtL3LdASC134d2vNdmMvnPKJ3asuJSCbbFif/iSkyHJj6tfe2XiXe8PRMElZLppDXJXr7PCZimG+4TvMusnQyW6HbzOjYH+ZRw/B8KCB9cJ29W31oYA5IxghfiIWP2b98u66uvZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FgfvcmDr; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FgfvcmDr"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-58b447c51bfso7057182a12.2
        for <dm-devel@lists.linux.dev>; Tue, 09 Jul 2024 14:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720561221; x=1721166021; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V6jxI8IuJZXYh6Vf9cRs/3xPvNRowoNzRPF2Bd36OA4=;
        b=FgfvcmDrLGcDWqO7WgSnuJZPEe+jQTpqFPUmppXVIT36fN2JxRQiPzwKZB+kxViOU8
         F0VpsOP8gkiHSOr+iBrLrFr2eUl9V7wQJRlVkivP3lITgzNIAemAkXaXtSV2/sweSH65
         ONRPP0LW28wToApjmGIAb0YW137lrsc40xwldG3p2hp+wZFsJdmGkOFo1QYaq/jZJd3b
         eVpsTCnpGBSq3GWH/IAE7SB5Gqi4nnaMOm6lCJLQr7mdIWZlHKaoZUNYj0qcMjrFt4Mr
         zCLFFUq+2OaRxMpKzbvOy1l2prnTD6bV38kRGLvGbwwfzbKJSOwCmtXSF/kfRT76d3y1
         x2iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720561221; x=1721166021;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V6jxI8IuJZXYh6Vf9cRs/3xPvNRowoNzRPF2Bd36OA4=;
        b=J0Ye3X7vzyFsqKp7sXiUyPrBJWGpAcwlZ91vrRwIFMq4OeMLGxCeA74skqZvineyxD
         e4p+fSxfIev5OLgvhYxJ7g6nreXTF964P56bZkIETJbDcMmmdas/JIo+1L2f/b+GcBr0
         PtCPLBxugmzo884Z+IEHG5jLVBQt/PoMphCNdlh3GCZD6QeozhVE/9/gXJ0XzjSIZrBx
         RgigglviNH5lsTth4sL8CvLcmDRg5Z3RV7tVGMceLnKh6z9qz1lJqPZ12gckC6IRTrwM
         LtLJUYdRCByhNtDqDsfs121Xjtz7rSnzNTPTyxaJW0G7fP2RWXCtGpX77giPsVtRGoFL
         RrJA==
X-Gm-Message-State: AOJu0Yx2y9KU0Y2tPWYXFgFJ+x2pf9Oz6QG+23Fx/+4c0d3YHeDVqpBX
	6YXOflXVSdeXboFobGOrCyYTexAQbroWLTvQPMjfXb7L191NxBDdkUAbgBH1i7M5aWIIltPFgcs
	W
X-Google-Smtp-Source: AGHT+IE4NW2VAUD6fE+vcqkk4aMCOfb/wIJVboJO+898xvrGkg3lsIjOUP1nscezpqtzwN69lkZKRw==
X-Received: by 2002:a17:906:3710:b0:a72:8a62:65e7 with SMTP id a640c23a62f3a-a780b87f063mr240751566b.57.1720561220844;
        Tue, 09 Jul 2024 14:40:20 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-594bd45a0d5sm1468578a12.66.2024.07.09.14.40.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:40:20 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 35/44] libmultipath: use libmp_pathinfo() in update_multipath_table()
Date: Tue,  9 Jul 2024 23:39:26 +0200
Message-ID: <20240709213935.177028-36-mwilck@suse.com>
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

This allows us to remove dm_get_status(), and dm_get_map(), of which
update_multipath_table() was the last caller.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c   | 89 --------------------------------------
 libmultipath/devmapper.h   |  2 -
 libmultipath/structs_vec.c | 22 +++++-----
 3 files changed, 12 insertions(+), 101 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 185c76b..105e838 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -804,45 +804,6 @@ static int dm_get_dm_uuid(const char *mapname, char uuid[DM_UUID_LEN])
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
@@ -886,56 +847,6 @@ static bool is_mpath_part_uuid(const char part_uuid[DM_UUID_LEN],
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
index ed5e866..cb5151e 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -126,8 +126,6 @@ int dm_simplecmd_noflush (int task, const char *name, uint16_t udev_flags);
 int dm_addmap_create (struct multipath *mpp, char *params);
 int dm_addmap_reload (struct multipath *mpp, char *params, int flush);
 int dm_map_present_by_wwid(const char *uuid);
-int dm_get_map(const char *name, unsigned long long *size, char **outparams);
-int dm_get_status(const char *name, char **outstatus);
 
 enum {
 	DM_IS_MPATH_NO,
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index ccc4efc..770e498 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -484,30 +484,32 @@ int
 update_multipath_table (struct multipath *mpp, vector pathvec, int flags)
 {
 	int r = DMP_ERR;
-	char *params = NULL;
+	char __attribute__((cleanup(cleanup_charp))) *params = NULL;
+	char __attribute__((cleanup(cleanup_charp))) *status = NULL;
 
 	if (!mpp)
 		return r;
 
-	r = dm_get_map(mpp->alias, &mpp->size, &params);
+	r = libmp_mapinfo(DM_MAP_BY_NAME,
+			  (mapid_t) { .str = mpp->alias },
+			  (mapinfo_t) {
+				  .target = &params,
+				  .status = &status,
+				  .tgt_type = TGT_MPATH
+			  });
+
 	if (r != DMP_OK) {
-		condlog(2, "%s: %s", mpp->alias, (r == DMP_ERR)? "error getting table" : "map not present");
+		condlog(2, "%s: %s", mpp->alias, dmp_errstr(r));
 		return r;
 	}
 
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


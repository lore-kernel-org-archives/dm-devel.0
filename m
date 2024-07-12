Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185EA176228
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804570; cv=none; b=tr+JpDpK5XxBeXw6R6FCnbBh2cmRvA3CSu8rC+2PXk7q2d1b1wprUVz07MaheyOO0ttyjFx4Xg+blnk4wzaVH+u1DdGAARI474Flz8rFv7oGb12BSAwckw/Y5W+wNF2KGGECu4BHZiDB1619iYlZt0yrs78jcXn/Y7O7/6LZjZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804570; c=relaxed/simple;
	bh=fN4QplXuqUjHwByYmUvDNZveEYmgQJcJGoh6pTjDIk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PXWDlVxTBxdkxHDx61GppziEtFikCWyxgLv4hvSr/TeAEJQi0riMVmWvv2ZhtyLWuEEdlJNuah4Goexc3ClUZZztEkaE5t4+dJ2goQ0GeljR6bvHPL9odN/r3F/oAM7wq1Y+MfO2HDqvDcQ+MXdchw0w3jeREmh76suc3QmqGYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dij0vAeb; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dij0vAeb"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-595856e2336so3804701a12.1
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804566; x=1721409366; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5lRj/fzwkWhiBcG+aLN/qvt6ptCQSYYEiGkgciwWklo=;
        b=dij0vAebCBBXELqR6wbzeWTxJQH+0jeTnLGHkqCEdCEm+8EQF6ACJ7A8fLmSRvMjsE
         1FejE3eJbddlYxckAzKG4/iOUH5eweq1D0Mw0yldnBuQBn+A+QnC3AyJ+hBtpgYQ2wsS
         rI3PLIN+q4qbNjr3o1UdC2cL+bRANlq1LX3FMVzToqpJEGLFIhyJEFMKOUnBeYXpOTSy
         IZU3RM6CRoLWrjDodBaAV8nQ83Jfj+0CvIV+mLimfkmVYEnmqLUuwYkbuOYPU6P/CR5O
         CvUunSEc8ffajC00dPezsvvJ3f3DkQJZWQY8VL092ws+j7Dp0cYA/7mJSjcNU8zBfICz
         Tx+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804566; x=1721409366;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5lRj/fzwkWhiBcG+aLN/qvt6ptCQSYYEiGkgciwWklo=;
        b=aamoFZSFn+O/yMqlIY8VdeiXN6r+TPpZbEFMskcvIfwMNuaa+yvXTYMYpKMuq8j51R
         yLklDyTL8fl9QAQlCBjoPOICP5WVJ/kDUfpfYnL3ftRxLlmpJmiYbfW37Jh+/M/SmA8B
         qqLVW0QFbENVzWogiax9nucvya1BqqKXntii52Stau1aRFSc//CdLCyGWkLEiH0QuoPu
         bOiu0bq7RfCEqrP6DjY5N9SPrw/YOWKO/ELFK53XnJklJGvkGGS3mOH9NZiy5Ir8TEgK
         +nFB3Wd5HGu+T5aCxoqhCEoThz7MlmVQSBnsqfqZEDjvNS5cdj6dojlcW6G5nMWG1vKr
         YckA==
X-Gm-Message-State: AOJu0YwNFm187yKW9H9GrLQSjZppgDdNaSNBmkFzg0c9kK9E5tQcvygH
	+IHdsUArrFU0W0cbz8IDNg8c1iBFTRKd5bEJ86LRkebToUjRBoSih219D2PPM0Y=
X-Google-Smtp-Source: AGHT+IHHroq+KWU4SUwLLawFyBFB1Tpee2UOTrc/4zLeBtcGlpOJMT6c5Wh47KYWq2PnL4QIsPIwwg==
X-Received: by 2002:a05:6402:34d5:b0:57c:7f3a:6c81 with SMTP id 4fb4d7f45d1cf-599642c3368mr2992051a12.8.1720804566325;
        Fri, 12 Jul 2024 10:16:06 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-594bbe2cf93sm4732586a12.33.2024.07.12.10.16.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:16:06 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 33/49] libmultipath: add is_mpath_uuid() helper
Date: Fri, 12 Jul 2024 19:14:41 +0200
Message-ID: <20240712171458.77611-34-mwilck@suse.com>
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

Export it, as it will be used by multipathd and libmpathpersist.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c          | 13 +++++++++----
 libmultipath/devmapper.h          |  2 ++
 libmultipath/libmultipath.version |  1 +
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 9483f02..6f17d32 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -840,6 +840,11 @@ int dm_get_map(const char *name, unsigned long long *size, char **outparams)
 	}
 }
 
+bool is_mpath_uuid(const char uuid[DM_UUID_LEN])
+{
+	return !strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN);
+}
+
 /**
  * dm_get_wwid(): return WWID for a multipath map
  * @returns:
@@ -857,7 +862,7 @@ int dm_get_wwid(const char *name, char *uuid, int uuid_len)
 	if (rc != DMP_OK)
 		return rc;
 
-	if (!strncmp(tmp, UUID_PREFIX, UUID_PREFIX_LEN))
+	if (is_mpath_uuid(tmp))
 		strlcpy(uuid, tmp + UUID_PREFIX_LEN, uuid_len);
 	else
 		return DMP_NO_MATCH;
@@ -982,7 +987,7 @@ int dm_is_mpath(const char *name)
 
 	switch (rc) {
 	case DMP_OK:
-		if (!strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN))
+		if (is_mpath_uuid(uuid))
 			return DM_IS_MPATH_YES;
 		/* fallthrough */
 	case DMP_NOT_FOUND:
@@ -1082,7 +1087,7 @@ int _dm_flush_map (const char *mapname, int flags, int retries)
 			  (mapinfo_t) {
 				  .uuid = uuid,
 				  .target = &params }) != DMP_OK
-	    || strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN))
+	    || !is_mpath_uuid(uuid))
 		return DM_FLUSH_OK; /* nothing to do */
 
 	/* if the device currently has no partitions, do not
@@ -1325,7 +1330,7 @@ struct multipath *dm_get_multipath(const char *name)
 			  }) != DMP_OK)
 		return NULL;
 
-	if (strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN))
+	if (!is_mpath_uuid(uuid))
 		return NULL;
 
 	strlcpy(mpp->wwid, uuid + UUID_PREFIX_LEN, sizeof(mpp->wwid));
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 4c8f345..a10821f 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -136,6 +136,8 @@ enum {
 	DM_IS_MPATH_YES,
 	DM_IS_MPATH_ERR,
 };
+
+bool is_mpath_uuid(const char uuid[DM_UUID_LEN]);
 int dm_is_mpath(const char *name);
 
 enum {
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 7d3ff63..5b8f9e0 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -127,6 +127,7 @@ global:
 	init_foreign;
 	init_prio;
 	io_err_stat_handle_pathfail;
+	is_mpath_uuid;
 	is_path_valid;
 	libmp_dm_task_create;
 	libmp_get_version;
-- 
2.45.2


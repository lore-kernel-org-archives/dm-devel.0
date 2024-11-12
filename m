Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A7E2003A7
	for <dm-devel@lists.linux.dev>; Tue, 12 Nov 2024 15:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731423768; cv=none; b=RmfJpZMc8Ic3n7P/Zpblnx5ASidU5fGohZcdlI2uOYNa7ftpr++467D1La1UGJHL21gzSVq22IdCb4WOO7/Qi5MI/zQoDVBZRCqsV63y3dXaMk4PY3XjAFrGV4tyeYKqjtV+Bxcgw75XL4juRjDgqyX+XoQHAfNAO4qBGMCFIQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731423768; c=relaxed/simple;
	bh=utDlDlQhKqlS5l5THjX0MseDGzkyTLR9WCslEfr89ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rxx/x7OF8rmTXFYne2XVuqMS+tyTFY5uxMk83K1NXRmlFpv9x41NWzZMXghdltkuEKLjz/m6b+KGxmtRhXMJ1BssKcv4RquUEMVynBuf4JbMtSUtQZJE5ydEsY1Ir2D7VHB3CdyCxNAd0KkydKuq7nKIGDAWpPAc2uy+jNIzZbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Bs6o9r/j; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Bs6o9r/j"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-37d473c4bb6so5371917f8f.3
        for <dm-devel@lists.linux.dev>; Tue, 12 Nov 2024 07:02:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1731423765; x=1732028565; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8EjBg45QqWf6gRdCDySJFRg4CsD2SUgeEDpFPqg1a4g=;
        b=Bs6o9r/j6C0ruoD5AycOkYuhfA+kjyXevZXa1erYncFTOeveGixvzOzLD9iLnSySNm
         xXfHT1/0hJoLR9dpDwWbwH4H2jRQKrjRkmPG0uTThLZgkklI8kICWV2HNP01qZs238mo
         Q1vy1Qe8njqdS8ATeberfYLkU6uP5io+/kl7QvPox9F3qPVkoym7JGMTL5qQvnAukEnF
         S7SiWQhNEEnYmZC/D4mlRwZhymCyV34D4qKQUKxoHRqSB0tcWf0tVZn15BjqOFG3VOK2
         HNMsWPXAX1bfyin3eqi/Pi3nxxKKl/+6QrHDC6E0XgDyyMbhcxFW8iX4i6QNIWFEZrfY
         oruA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731423765; x=1732028565;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8EjBg45QqWf6gRdCDySJFRg4CsD2SUgeEDpFPqg1a4g=;
        b=DLu7WfhJWYD7i0MreCvnKkvgJKjYtgInxaJCbf6OHUbgfx0g//wmmsVPDE0iVQnYKP
         f8jZnUHT1LLzwUwwNDRhgr9GASWhkEhGjKYUNYt9KxWNr9t8C8TAcMSkrwocSg2pV8Yv
         eNQ0HB0KDw8pZ7kzWomEoGCRRQwN9lFOZOOy6/f2uHgVrLK5D/9/cE8OjCbEXNhqMZqM
         aw6b4szVs4hpJkTQ5KEWmGkXowiPS7zLrHUPwQmMtsT1fsmiOf92OwQLL94jzFd3OHju
         vGyto6sEHMPnAv7v9LwRiSvD/8I/rTJG3p9NkeEdOzzGYmaqx+ev0ZllAZqddg/L37w1
         1YIQ==
X-Gm-Message-State: AOJu0YytnY56eCb2FtW26SB4MFFegqpPOQUzng/ecYY79UIwKXwGOO66
	KvEy6hwKYs/lFGTMrXfk1jMzkctO9TYo598XjAR9ZskE2ZzL8w0y6z6xdH+bUkY=
X-Google-Smtp-Source: AGHT+IGdF2X64g63RU0Be5s3pss3YtADLEN8Ey+4pHcg0+rFSqMb5ruzbx6ojPwwqsNGNMbKDmsxVg==
X-Received: by 2002:a05:6000:1564:b0:37d:4376:6e1d with SMTP id ffacd0b85a97d-381f1884855mr18108895f8f.41.1731423760600;
        Tue, 12 Nov 2024 07:02:40 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-381ed9ea587sm15866452f8f.78.2024.11.12.07.02.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2024 07:02:40 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 07/12] libmultipath: make MAPINFO_CHECK_UUID work with partitions
Date: Tue, 12 Nov 2024 16:02:10 +0100
Message-ID: <20241112150215.90182-8-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112150215.90182-1-mwilck@suse.com>
References: <20241112150215.90182-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The semantics of MAPINFO_CHECK_UUID, MAPINFO_MPATH_ONLY and MAPINFO_PART_ONLY
are confusing. Fix that by supporting UUID check for partitions, too.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 30 ++++++++++++++++--------------
 libmultipath/devmapper.h |  8 +++++++-
 2 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index d193586..03dae16 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -616,6 +616,18 @@ static bool is_mpath_uuid(const char uuid[DM_UUID_LEN])
 	return !strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN);
 }
 
+static bool is_mpath_part_uuid(const char part_uuid[DM_UUID_LEN],
+			       const char map_uuid[DM_UUID_LEN])
+{
+	char c;
+	int np, nc;
+
+	if (2 != sscanf(part_uuid, "part%d-%n" UUID_PREFIX "%c", &np, &nc, &c)
+	    || np <= 0)
+		return false;
+	return map_uuid == NULL || !strcmp(part_uuid + nc, map_uuid);
+}
+
 bool
 has_dm_info(const struct multipath *mpp)
 {
@@ -720,8 +732,10 @@ static int libmp_mapinfo__(int flags, mapid_t id, mapinfo_t info, const char *ma
 		&& !(uuid = dm_task_get_uuid(dmt))))
 		return DMP_ERR;
 
-	if (flags & MAPINFO_CHECK_UUID && !is_mpath_uuid(uuid)) {
-		condlog(3, "%s: UUID mismatch: %s", fname__, uuid);
+	if (flags & MAPINFO_CHECK_UUID &&
+	    ((flags & MAPINFO_PART_ONLY && !is_mpath_part_uuid(uuid, NULL)) ||
+	     !is_mpath_uuid(uuid))) {
+		condlog(4, "%s: UUID mismatch: %s", fname__, uuid);
 		return DMP_NO_MATCH;
 	}
 
@@ -846,18 +860,6 @@ int dm_get_wwid(const char *name, char *uuid, int uuid_len)
 	return DMP_OK;
 }
 
-static bool is_mpath_part_uuid(const char part_uuid[DM_UUID_LEN],
-			       const char map_uuid[DM_UUID_LEN])
-{
-	char c;
-	int np, nc;
-
-	if (2 != sscanf(part_uuid, "part%d-%n" UUID_PREFIX "%c", &np, &nc, &c)
-	    || np <= 0)
-		return false;
-	return !strcmp(part_uuid + nc, map_uuid);
-}
-
 int dm_is_mpath(const char *name)
 {
 	int rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY | MAPINFO_CHECK_UUID,
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index ba05e0a..6b3bbad 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -58,7 +58,13 @@ enum {
 	/* Fail if target type is not "partition" (linear) */
 	MAPINFO_PART_ONLY   = (1 << 9),
 	MAPINFO_TGT_TYPE__  = (MAPINFO_MPATH_ONLY | MAPINFO_PART_ONLY),
-	/* Fail if the UUID doesn't match the multipath UUID format */
+	/*
+	 * Fail if the UUID doesn't match the expected UUID format
+	 * If combined with MAPINFO_PART_ONLY, checks for partition UUID format
+	 * ("part<N>-mpath-xyz").
+	 * Otherwise (whether or not MAPINFO_MPATH_ONLY is set) checks for
+	 * multipath UUID format ("mpath-xyz").
+	 */
 	MAPINFO_CHECK_UUID  = (1 << 10),
 };
 
-- 
2.47.0


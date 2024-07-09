Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F5A189F4B
	for <dm-devel@lists.linux.dev>; Tue,  9 Jul 2024 21:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561229; cv=none; b=GYrzHyMFzra0+dHcKvTsOeUfUUoDDpCxU/NJlD0q+3Ds/JEMzL7PpYJWe3e96ysypzZr+g8LTM5th7zKXj8IVXpRHNto4wlKDlNhXoEUW4VLqAooKE+17hCpHKI/xXp5oZO7VoIav2M/zBE9isgL2We1aL5LNw8TarJRkT6eOQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561229; c=relaxed/simple;
	bh=/vNXK8ZwfNd3MH8NLgxmbSVgQ2JFuiCfn17tgWTwDUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iP1yJZWSfN/246R1Lko/HLz2Lv68dzCzuibzFxk4ejt7QlnYP3dB3/nc5W8gKp/pB+bx7yypbw1AWUA/0eUo55NAzxGNoVNNEX7eYuOKVglA21tGVzgKQc3LOOYDhunG66gK8F5aFhuknFWMutBOCgfsi3BRUESpiDRvbDPIDAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ENe2zwia; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ENe2zwia"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a77cc73d35fso35479766b.0
        for <dm-devel@lists.linux.dev>; Tue, 09 Jul 2024 14:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720561226; x=1721166026; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xothMHvVSxnWIQ9LZMHqLA249Sx3wnBWK8WN0S3U6VI=;
        b=ENe2zwiausGrNhjdmeJkAz+YsTrCNZHHmjEvUejv9hCgGFzGzfBYFVK4TDbaE6MYnR
         F65dvr7wht0NmBOPGVDrirco1XoBt5S8s6bdzPcsoTKPyt/eZxtKjSo3gl2+2KIpEbcN
         8yQdYZ5oWqOEm7HOV2TTJzr7VOK0vKEBuHHXCDr4uIF61vdAXhyO23x6n/9IS0CG4dZa
         BCg+B5KJ8Ft7ckgLNJLNfe2v6A3/X4M2b/5UZj8fiUZdhiU31YApKB7QPx9ikBSVjYCT
         shYlxBebwsLlvbuJdFFUy4Zemhfq5tTFCBxv830Nvr+KxEwzB4GpGC0Tvw5ma+PaKVHV
         voyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720561226; x=1721166026;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xothMHvVSxnWIQ9LZMHqLA249Sx3wnBWK8WN0S3U6VI=;
        b=Dcicr5lAbpgGOvKdzCq01PB0gQ9WAXQuol2fzhHL+ZW0Ur+xV6HobOoS7abYd/g2Ci
         9Rj7zFAI+VaJ9+ZmM5DkiJ+LVGPDUuxqv8XQlm98nM5ollI3jgHiZao20m+RZ/lapJn4
         UE690Vl7BJvu+5kGjyxj+6ziW73e99ypu1Ka5MIdUC7Qw1lRmfv2xu/c/zMSJ08KZJwS
         uNsjRidzQ/pHQrHU0hJ+iS0nhxNH34tQv0cZhADCYm1maJCmLY3onadAdj7CiNCJU4wF
         SoGuilAyzSAP3HoBin9IbIPo9zdeJnenGHivqs5CnFXcMffD/FpRaAzOw4cSV0SyxGIY
         G5+g==
X-Gm-Message-State: AOJu0YygXkSMbXU+KyCgRDvtmIZptcOtiR4N7LALbCIsxY6+Dg6UsKdW
	Kfhg+puTnmXuVJOeY15Df/01n2LyN+GAYfMNMvslOaY1xqoKNI7quc+g2aQn+HCwkvu+6EihTOD
	2
X-Google-Smtp-Source: AGHT+IGJj9MEwa3K+tfnuy70eCwgFHQEQfsBkkMYxKoeH2ZLFOBejBkiLKvMUu9N5dFSdAwNyKR+4A==
X-Received: by 2002:a17:906:f598:b0:a77:c7d8:7b4c with SMTP id a640c23a62f3a-a780d22e380mr374993966b.11.1720561226105;
        Tue, 09 Jul 2024 14:40:26 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a8541f7sm108063566b.154.2024.07.09.14.40.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:40:25 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 41/44] libmultipath: simplify dm_get_maps()
Date: Tue,  9 Jul 2024 23:39:32 +0200
Message-ID: <20240709213935.177028-42-mwilck@suse.com>
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

Make dm_get_multipath() return a distinct error code for non-multipath
targets. This way the extra call to dm_is_mpath() is not necessary any
more. As dm_get_maps() is the only caller of dm_get_multipath(), transform
it into a static function.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 44 +++++++++++++++++++++-------------------
 libmultipath/devmapper.h |  1 -
 2 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 105e838..e653ca6 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1169,40 +1169,43 @@ dm_disablegroup(const char * mapname, int index)
 	return dm_groupmsg("disable", mapname, index);
 }
 
-struct multipath *dm_get_multipath(const char *name)
+static int dm_get_multipath(const char *name, struct multipath **pmpp)
 {
 	struct multipath __attribute((cleanup(cleanup_multipath))) *mpp = NULL;
 	char uuid[DM_UUID_LEN];
+	int rc;
 
 	mpp = alloc_multipath();
 	if (!mpp)
-		return NULL;
+		return DMP_ERR;
 
 	mpp->alias = strdup(name);
 
 	if (!mpp->alias)
-		return NULL;
+		return DMP_ERR;
 
-	if (libmp_mapinfo(DM_MAP_BY_NAME,
+	if ((rc = libmp_mapinfo(DM_MAP_BY_NAME,
 			  (mapid_t) { .str = name },
 			  (mapinfo_t) {
 				  .size = &mpp->size,
 				  .uuid = uuid,
 				  .dmi = &mpp->dmi,
 				  .tgt_type = TGT_MPATH
-			  }) != DMP_OK)
-		return NULL;
+			  })) != DMP_OK)
+		return rc;
 
 	if (!is_mpath_uuid(uuid))
-		return NULL;
+		return DMP_NO_MATCH;
 
 	strlcpy(mpp->wwid, uuid + UUID_PREFIX_LEN, sizeof(mpp->wwid));
-	return steal_ptr(mpp);
+	*pmpp = steal_ptr(mpp);
+
+	return DMP_OK;
 }
 
 int dm_get_maps(vector mp)
 {
-	struct multipath * mpp;
+	struct multipath *mpp = NULL;
 	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
 	struct dm_names *names;
 	unsigned next = 0;
@@ -1227,20 +1230,19 @@ int dm_get_maps(vector mp)
 	}
 
 	do {
-		if (dm_is_mpath(names->name) != DM_IS_MPATH_YES)
-			goto next;
-
-		mpp = dm_get_multipath(names->name);
-		if (!mpp)
-			return 1;
-
-		if (!vector_alloc_slot(mp)) {
-			free_multipath(mpp, KEEP_PATHS);
+		switch (dm_get_multipath(names->name, &mpp)) {
+		case DMP_OK:
+			if (!vector_alloc_slot(mp)) {
+				free_multipath(mpp, KEEP_PATHS);
+				return 1;
+			}
+			vector_set_slot(mp, mpp);
+			break;
+		case DMP_NO_MATCH:
+			break;
+		default:
 			return 1;
 		}
-
-		vector_set_slot(mp, mpp);
-next:
 		next = names->next;
 		names = (void *) names + next;
 	} while (next);
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index cb5151e..d9e9bcc 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -179,7 +179,6 @@ int dm_rename (const char * old, char * new, char * delim, int skip_kpartx);
 int dm_reassign(const char * mapname);
 int dm_reassign_table(const char *name, char *old, char *new);
 int dm_setgeometry(struct multipath *mpp);
-struct multipath *dm_get_multipath(const char *name);
 
 #define VERSION_GE(v, minv) ( \
 	(v[0] > minv[0]) || \
-- 
2.45.2


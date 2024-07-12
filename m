Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07797171644
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804581; cv=none; b=bHwcdTK/nWQRKEZYc1MPpxvFmsTvwxEMzGvhD+9QKHNU1y4xSiajM95MOW9r1R9LNCdEDf96eDpkH4V8FU2LNJR2Ka7WHdYsQ3vdpJapl8bSfPj4fETTE7Es1sr+dzaS4DSV71h+hDwi4EpeLQb0pHLmchHPI+vQrZI+01glsNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804581; c=relaxed/simple;
	bh=l+So8C98Vkng7UsbS5wUnPgzLBUlGOE+NCUp4/6T7+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y1AZsyvHX+0k6jjunoPJw+4SM3eGZMVlD8z4/UmSvDX/i2zecUxaOISVA5k7SIb0IbmicVcdNp9CARatDmq/98FT/tlwBAKlQDayIgwveaOetLwFVcUd13fhImERV5a40TjZERYDUGNGuvx/71QUwKWjgNeH9v2oebd6K83zC3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SAUYtg9v; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SAUYtg9v"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-58be2b8b6b2so2903846a12.3
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804577; x=1721409377; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2ffMD0XQCVtitda9bJYFeR9HeIWQ36ZylmX7OTCZPtY=;
        b=SAUYtg9vy7+oMlyvtvXsNi6hSdxEUrRvdlTHYzA6Hi7BUUZhVaYPy8+XRGW4GzmwfM
         hYQWFFOHvqu2sctBUQgop929RxVVseHNcO4EnNAdWDrKoOpr1OCKSNFSB/KVMiCW9tKB
         gwDji8zBTpC8Um2Ofz2G9uPDxXCn0jphaRsNcUFqsVPbhPLHwbnwxa8M7YjRynlB1Hxh
         io2V8H8WQkQOzS6HhRRpPJoSgidzxPnaHVUWT5/PlItwQuE+VhN2o/OpfwaVvuNoOSov
         73TpTPXsjgytRaNt8XAA1V12kjbwXKvd/HgqQ0ikGA0MraL1F96x6AKWb3MlugSeWpSM
         tqCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804577; x=1721409377;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2ffMD0XQCVtitda9bJYFeR9HeIWQ36ZylmX7OTCZPtY=;
        b=R/o73amkVkXV0xEFDE3J0Uspe6SQVzwcPbwFrZ8j6yYt4vtqcIZjKTuhWxG6wRseEP
         3hMWSnA6rxpTZHrxtRGc8LsTgob/VpLvI5+GR6pHqU6/QbfTkZY+NcYMuggKtMqHF7uQ
         b0DlSIruc3ZZOSk1sDoV9RExeiWpPCQWL6xkhbLEU1/Sc62tbL2GUGPq2gMWsWJxlNAf
         NasBPThJjAQWC8U8Dq6IoPpAFGUvu7PZaXDqSe/f6vB0VojUxYUONxIyXPO+MPUXEKTs
         jOqQr1JC8hi+kHuEAQholUfrFN8nTI1AFoREecJc6W5CfdS3g96L4R1n1hbNnMWDTt6b
         7QYA==
X-Gm-Message-State: AOJu0Yw23gWBIWKhHaJuqq9AJnP/GYBQIfQKwGPliriYVvqY0Kt2trQC
	2BXSoEpoT0LyRoCXQcyEZXO6x4Y1zx4QGRTFAJh5MVAJV1x4C3SnjuGKzEQySpM=
X-Google-Smtp-Source: AGHT+IFQTwNnO1nrh2eA2u1czJFbgWBwKPh+5C514Te3MRulTbu6T62HxtWTavlgrgxxEqsgwQsWMQ==
X-Received: by 2002:a50:d513:0:b0:599:7a9c:37b0 with SMTP id 4fb4d7f45d1cf-5997a9c3c27mr1761137a12.35.1720804577249;
        Fri, 12 Jul 2024 10:16:17 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-594bda30fabsm4763556a12.93.2024.07.12.10.16.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:16:16 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 43/49] libmultipath: simplify dm_get_maps()
Date: Fri, 12 Jul 2024 19:14:51 +0200
Message-ID: <20240712171458.77611-44-mwilck@suse.com>
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

Make dm_get_multipath() return a distinct error code for non-multipath
targets. This way the extra call to dm_is_mpath() is not necessary any
more. As dm_get_maps() is the only caller of dm_get_multipath(), transform
it into a static function.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 44 +++++++++++++++++++++-------------------
 libmultipath/devmapper.h |  1 -
 2 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 86ac01b..b52b10e 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1186,39 +1186,42 @@ dm_disablegroup(const char * mapname, int index)
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
 
-	if (libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY,
+	if ((rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY,
 			  (mapid_t) { .str = name },
 			  (mapinfo_t) {
 				  .size = &mpp->size,
 				  .uuid = uuid,
 				  .dmi = &mpp->dmi,
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
@@ -1243,20 +1246,19 @@ int dm_get_maps(vector mp)
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
index 3daaa4c..d01f9f2 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -184,7 +184,6 @@ int dm_rename (const char * old, char * new, char * delim, int skip_kpartx);
 int dm_reassign(const char * mapname);
 int dm_reassign_table(const char *name, char *old, char *new);
 int dm_setgeometry(struct multipath *mpp);
-struct multipath *dm_get_multipath(const char *name);
 
 #define VERSION_GE(v, minv) ( \
 	(v[0] > minv[0]) || \
-- 
2.45.2


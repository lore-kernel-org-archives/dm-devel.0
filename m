Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4838A176AC4
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804557; cv=none; b=Zq+UIF0xq/DLHULVao3YYZXTJZVQ9mPm0WQldVSBEt3IW9i0QRe5ZjfrkIc9O1bXmkoqU20xgtrCf9WjkCJeOVCYOqPk393I+yOlYyfwRHe41osC/Mq5nWI8GtmDy7x3PLOUXlBvi08jkHzXUJ43rZ2TjDecfz5dLWEFsyv1ZoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804557; c=relaxed/simple;
	bh=a8G7yjtFjtTnylXmRJ1wkfGU2sh+fH+uwA2vwP4mSi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DAIanL1tr8aEW20fwrcGpept5S+C+WDzK0U4p6d18IOteWZKNKolcWRiMkH4pc8uJVbg4BbEP8YhWKKqqo0AqeMYzME46BgOnLElQjoPNOTz8rVzb5tSHow2UDWXy18p3tFuRNQY9ugdqGPG+KOXyc5VTUGrMz0mQjADg9P9Ij4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bQiaD7mj; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bQiaD7mj"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a77bf336171so394390066b.1
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804553; x=1721409353; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BHKJqr4xfU2xTHDsp1UcD3N458lleWBHy+eHORPTvdw=;
        b=bQiaD7mjymreECKlEMjCh2tCWwTI2CQyrFchYxrEVBhw9JRocvEYMLYymoT758aJbk
         SN6Qh7iPhBDqgWCqhCVj5Zp+u9HA1Ei/3dQ0UKAevmcpfuEKAC4xspBz02xqbtqrtyQP
         mJ0LkjxZ5PZcXDzaV0Mgayx0sSWNNurBvGf++uXDnBWelRr9dC51ICQmWHkfrlW2kBuN
         rwfa11LZ0fofL2+IeKbkOd68apTy5+olB0jrS+Fac+0ijcPWqHIbpbsZEGB134yCsAXN
         hrFfaulClyD7OFYa1zjdHywANpZ7LczgCmzIo/hfm3P4Y1qUyg/9Dg0rkO1MjSszWH4Q
         OKyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804553; x=1721409353;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BHKJqr4xfU2xTHDsp1UcD3N458lleWBHy+eHORPTvdw=;
        b=vlUhunWUWZAdM+aHs008tg+sScnfiG+/LoNr4dbrz0I3moAuSb651JhD0vNKo2R8ua
         Kbip6aLLohk8hiTsVDeaQ9k5BRYiPypHjbkg4WjGLasa1FsWyO+M0045FXmLw+7J5bq/
         z/uPW9CL/gN+Cn2dn/nKyhTWBR4kdiW8ldLzpVJmqf3E9psqtSLp6G44YHWI7j6RkNrq
         lrx3Oesh/8LqSn4jKPbBQDwUjyS+lRBm7IrEU9QUoITKCAjkCrz4BxVi4moJzk5SgtTK
         R3AN+IMRube7tYub3LlM5k6+uo1ttxxnGF26rhFQOYFqejusOgN8B8EpzFtuK8Jn6JgW
         Tg4Q==
X-Gm-Message-State: AOJu0Yx62mjgh9btGIt6FNssqevOhCxESj04kQMDFlIe58i8btxXIT7G
	OaCtog0o/d3BAhOGUABCgvlCcKCnXnFu95V7giJUt6b57XyxNrDI06bqupHHNmQ=
X-Google-Smtp-Source: AGHT+IHT7UGdGQMBdB/W1cBiUuR+5IvgukWy6+QnZ7tJ3wfkrrWaC5GbM1muSMtcsVXeOGGA1G6XIg==
X-Received: by 2002:a17:907:7802:b0:a77:c693:9ddf with SMTP id a640c23a62f3a-a799cd38e5cmr221936366b.34.1720804553345;
        Fri, 12 Jul 2024 10:15:53 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a7ff722sm358883666b.123.2024.07.12.10.15.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:15:53 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 22/49] libmultipath: remove dm_get_prefixed_uuid()
Date: Fri, 12 Jul 2024 19:14:30 +0200
Message-ID: <20240712171458.77611-23-mwilck@suse.com>
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

... and replace it by calls to the new API.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 53 +++++++++-------------------------------
 1 file changed, 11 insertions(+), 42 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 754f45e..0bc5e34 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -794,6 +794,13 @@ int libmp_mapinfo(int flags, mapid_t id, mapinfo_t info)
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
@@ -833,48 +840,11 @@ int dm_get_map(const char *name, unsigned long long *size, char **outparams)
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
@@ -885,16 +855,15 @@ int dm_get_uuid(const char *name, char *uuid, int uuid_len)
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


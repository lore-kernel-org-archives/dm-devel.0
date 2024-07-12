Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B311317799B
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804572; cv=none; b=TL2l+WXn9wM+yl7yx0Z/iBdD8Ga9emHG6231F9sf8MIYaac1O8V6XXDnyjjN96ti3r7u0g6QwCqXaVKwwj/T0WLDcLRDjdXbOt5wjc6orizkhxX9P04Ga5fLZlZlAOiLjh3AgKAXN+XOmWEf0oJSqEBLFiuXWkVNOH7RGzKvNZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804572; c=relaxed/simple;
	bh=zud+B1oqsmi3XLFljSXJ2pSJNl3tU+FHDB0+hqqBGvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZbRBV7nDWIGKxHfkv7/vcbAcTT9aOWbyXJcTeuEUBT9kTTUwIjmFct++a19V7bdUWKePmUkWhJVxdndVkCLas+cjiB3h5j+O2BqVonIIYFZx8dIS0QqG/Alj97CzhU+ohAGs5sajIg0erb+/GQCNiL5RQs/+e08/O4jAXt/Re1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OLaNjqSW; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OLaNjqSW"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-57cf8880f95so2807898a12.3
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:16:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804569; x=1721409369; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0j3JXw6+f5Tz0Pb832Ll7sGOk/jw34ZbI5Ip+mrftAg=;
        b=OLaNjqSWCfZb6Mxz9fZ7ZpCGm3YRNfF3fzNwPSy6C9SghU+UFHTbtmTzaiFCpu/zyN
         KQwEQffbOO6e/2Q58AOxbV6fWUJJxnSTSFz7GO1E2Bx2JDMDAo9M27Bt8RPyrMBRycqs
         kJlg4htKccHSyeGxlQR7tPygN1bZddlXOUOt6x2Ud3ZTAbwTuML1xugk2IQWRQdvKdLr
         Ht2Fme0weYfNUzX9qo3HJSNzINgzDNK8308PcNGk6UB97uJOhH5dUSDlESFg2s9yBtdD
         GXaUU3rwOuVcw9F25kc85mvvykg+ixNrk0HrYLZ9mFQIJOjHto8XtDIPZXbv2aqZyXv4
         189Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804569; x=1721409369;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0j3JXw6+f5Tz0Pb832Ll7sGOk/jw34ZbI5Ip+mrftAg=;
        b=rDhF12WRDIMnTSCkzmJsHEdMRL5COhqNduK+rM4cyy3AZ82QkKIACTq2wDt1jIid94
         yv7NG960ZNGhO86hLTdHsQWnTMBRs8NWyb5Q8BNY3KKv3S7CA65gRjmo3BNGxZ7KlF5d
         zPhgWcQKR/nyYdzUFa5xR23DCWClumKm8nwH2Zot9zZ9Py0VJYCmuVsbOymaiU9y2qfJ
         Ebt7w8EILJUTpy5aYCPnFu9VI0tnc0fehCFHhFBFDOSJCqOMcvTz4Ikt8XCyFKscmC7X
         B+tBJ1bmQ4/E7PNw5OIBL/ukm1/q7PEE7/YQk4HANaA4i/kCg1qEe8Q06Qf2elhEd97Y
         Os8g==
X-Gm-Message-State: AOJu0Ywz/M2vmPna0hzrkYryhidjIQfYyASxxz7fOzZZ1ZgyHX/DSYLj
	/UK85eUaac0+WBMQsozcIQ17xvhb9596Adyoy3vIoV2mkQTHrXyyHNoLrwWaFqg=
X-Google-Smtp-Source: AGHT+IGZJ0m/87PFSFtkDJeYjAYMXmaqXasUnPqpA58TnyzfLTUP3jrkgi5Boilx/OoU4GNhEeXHbQ==
X-Received: by 2002:a05:6402:354f:b0:57d:2c9:6497 with SMTP id 4fb4d7f45d1cf-594bab80106mr11021413a12.3.1720804569058;
        Fri, 12 Jul 2024 10:16:09 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-594bda27f56sm4778048a12.80.2024.07.12.10.16.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:16:08 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 36/49] libmultipath: use libmp_mapinfo() in do_foreach_partmaps()
Date: Fri, 12 Jul 2024 19:14:44 +0200
Message-ID: <20240712171458.77611-37-mwilck@suse.com>
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

Also, simplify the if statement a bit.
drop is_mpath_part() and dm_type_match, because do_foreach_partmaps() was the
last user of these functions.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 100 ++++++++++-----------------------------
 1 file changed, 26 insertions(+), 74 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index e51c2f0..587fc17 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -946,60 +946,6 @@ out:
 	return r;
 }
 
-enum {
-	DM_TYPE_NOMATCH = 0,
-	DM_TYPE_MATCH,
-	/* more than 1 target */
-	DM_TYPE_MULTI,
-	/* empty map */
-	DM_TYPE_EMPTY,
-	DM_TYPE_ERR,
-};
-static int dm_type_match(const char *name, char *type)
-{
-	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
-	uint64_t start, length;
-	char *target_type = NULL;
-	char *params;
-
-	if (!(dmt = libmp_dm_task_create(DM_DEVICE_TABLE)))
-		return DM_TYPE_ERR;
-
-	if (!dm_task_set_name(dmt, name))
-		return DM_TYPE_ERR;
-
-	if (!libmp_dm_task_run(dmt)) {
-		dm_log_error(3, DM_DEVICE_TABLE, dmt);
-		return DM_TYPE_ERR;
-	}
-
-	/* Fetch 1st target */
-	if (dm_get_next_target(dmt, NULL, &start, &length,
-			       &target_type, &params) != NULL)
-		/* multiple targets */
-		return DM_TYPE_MULTI;
-	else if (!target_type)
-		return DM_TYPE_EMPTY;
-	else if (!strcmp(target_type, type))
-		return DM_TYPE_MATCH;
-	else
-		return DM_TYPE_NOMATCH;
-}
-
-static bool is_mpath_part(const char *part_name, const char *map_name)
-{
-	char part_uuid[DM_UUID_LEN], map_uuid[DM_UUID_LEN];
-
-	if (dm_get_dm_uuid(map_name, map_uuid) != DMP_OK
-	    || !is_mpath_uuid(map_uuid))
-		return false;
-
-	if (dm_get_dm_uuid(part_name, part_uuid) != DMP_OK)
-		return false;
-
-	return is_mpath_part_uuid(part_uuid, map_uuid);
-}
-
 int dm_is_mpath(const char *name)
 {
 	char uuid[DM_UUID_LEN];
@@ -1441,7 +1387,7 @@ char *dm_mapname(int major, int minor)
 }
 
 static int
-do_foreach_partmaps (const char * mapname,
+do_foreach_partmaps (const char *mapname,
 		     int (*partmap_func)(const char *, void *),
 		     void *data)
 {
@@ -1449,10 +1395,19 @@ do_foreach_partmaps (const char * mapname,
 	char __attribute__((cleanup(cleanup_charp))) *params = NULL;
 	struct dm_names *names;
 	unsigned next = 0;
-	unsigned long long size;
-	char dev_t[32];
+	char dev_t[BLK_DEV_SIZE];
 	int r = 1;
 	char *p;
+	char map_uuid[DM_UUID_LEN];
+	struct dm_info info;
+
+	if (libmp_mapinfo(DM_MAP_BY_NAME,
+			  (mapid_t) { .str = mapname },
+			  (mapinfo_t) { .uuid = map_uuid, .dmi = &info }) != DMP_OK)
+		return 1;
+
+	if (safe_sprintf(dev_t, "%i:%i", info.major, info.minor))
+		return 1;
 
 	if (!(dmt = libmp_dm_task_create(DM_DEVICE_LIST)))
 		return 1;
@@ -1467,41 +1422,38 @@ do_foreach_partmaps (const char * mapname,
 		/* this is perfectly valid */
 		return 0;
 
-	if (dm_dev_t(mapname, &dev_t[0], 32))
-		return 1;
-
 	do {
+		char part_uuid[DM_UUID_LEN];
+
 		if (
 		    /*
 		     * if there is only a single "linear" target
 		     */
-		    (dm_type_match(names->name, TGT_PART) == DM_TYPE_MATCH) &&
-
+		    libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_PART_ONLY,
+				  (mapid_t) { .str = names->name },
+				  (mapinfo_t) {
+					  .uuid = part_uuid,
+					  .target = &params,
+				  }) == DMP_OK &&
 		    /*
 		     * and the uuid of the target is a partition of the
 		     * uuid of the multipath device
 		     */
-		    is_mpath_part(names->name, mapname) &&
-
-		    /*
-		     * and we can fetch the map table from the kernel
-		     */
-		    dm_get_map(names->name, &size, &params) == DMP_OK &&
+		    is_mpath_part_uuid(part_uuid, map_uuid) &&
 
 		    /*
 		     * and the table maps over the multipath map
 		     */
 		    (p = strstr(params, dev_t)) &&
-		    !isdigit(*(p + strlen(dev_t)))
-		   ) {
-			if ((r = partmap_func(names->name, data)) != 0)
-				return 1;
-		}
+		    !isdigit(*(p + strlen(dev_t))) &&
+
+		    (r = partmap_func(names->name, data)) != 0)
+			return 1;
 
 		free(params);
 		params = NULL;
 		next = names->next;
-		names = (void *) names + next;
+		names = (void*) names + next;
 	} while (next);
 
 	return 0;
-- 
2.45.2


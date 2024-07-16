Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6DC7208BA
	for <dm-devel@lists.linux.dev>; Tue, 16 Jul 2024 20:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721163249; cv=none; b=s5qllQKklXIo6awyfVQeUl5SEClO+p+lEkoBblmGt/mp5f44iSfO/TkwD2WiF6sGR75LRmlH0ZEUJ9DyLx8B+jYu9XH4pEOF0GmtqzYiMS0Yc5+EGS7IuBnxUXrOZ7Kl6vL//uVlngspb97K63GVq4izPwW1GsDOoDu79kG6qEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721163249; c=relaxed/simple;
	bh=RqS5OkdukJ/6NixKEHYVlFKH5k3SPN1uZ1rTaDPfy6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RbTWGFGllTmZiY+KoJY7EgbohkATAXAIU6x7j+Ee9kLz/+JeEY4r/JXax4PEUE3iAYE8MsUObbEMcZeE02bKiiTEu0+UWEf1+Aqo08/v70/+7LlFwpU++ks9tIAJA4bb1HMRwtolZc24GotJj0H4MNc/5ZWMdUom96aZLAZ3VDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=P19Ip/Zb; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="P19Ip/Zb"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-52e99060b41so6261852e87.2
        for <dm-devel@lists.linux.dev>; Tue, 16 Jul 2024 13:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721163244; x=1721768044; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0ojZN+hLTa0bKNhAR9crVk8ZyRoXR89FPSaOF6y6qOQ=;
        b=P19Ip/ZbGtKTYFIqQEveb49B4bbFYamema8DHJD+yPQOsgXFPX5FRTm6Gtxydsw1pd
         g7YaWUzLICLhoYMPHgDk58nwRBMncXO1rBTY/HQSvqgaMV+/OpU1grC0TV2lavLeBrOJ
         j9IEQjUUblCnkjUZx5wgitTJkprRtZGgQaPhtv2PtE1WLJHGgKZwVprY9HCUox04yvY9
         JBlaWIh7Yorsh8lTpFSnqKR9l/Tzivi4yo7kA8/QxOYaqsIKGA5XiHh9CfNSG8g3a8dv
         eM+2IL7+iDP4XAa1m5NJfgmoJ1IKyDggtgplD2MzCsHkUfCe4SWzwhOWV6IzUMSualS+
         0zqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721163244; x=1721768044;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0ojZN+hLTa0bKNhAR9crVk8ZyRoXR89FPSaOF6y6qOQ=;
        b=UuLWXKDne/cP1fQZpFR6pFYboFuSWuMhAPJrDGLiN3/TFTMXS+SZoDgj6kuQ1zc0tx
         4p+DbDd6swnGmAEakBhb4emyxm3u07byho/4+pLrxkrm0FjiQm107s366GOge9QH8Y94
         P90DygXZd2xP2y25rbd6ohqaW6ewQoNKcADbTIbppLhz+yTDF42/E24kS0db2q0ho6CP
         uDJsWQtlcF4hp0Bg5i2JJYG5hq2o+MhVmsS1szBUOD9C8FKypvdcbKHIWBp2C0iPbX0v
         UIepKN/8J6StK2jOxJBN94iLS3AkesD1KHSX1JHEWoNbVJC3ccUHj2EiMB9AOVfgimtP
         YX0Q==
X-Gm-Message-State: AOJu0Ywn2e0T7/85iPdsyLkdwz5tA2nRUakteYVDocVDSVaJlmUgByuI
	Bitnq3z2BaQgifh2MQAT8HLvUsgd9fMLDfV6Bwo/33GdbbGNQ5SsrifLiwn0RnA=
X-Google-Smtp-Source: AGHT+IFWXIb5w+UNrPdg9GzSJf2pNXCY7MalSa4OW7lqoUjh5Sv5nEpD2wKjHwteTf7kcn108pY3Mg==
X-Received: by 2002:ac2:4e07:0:b0:52e:767a:ada7 with SMTP id 2adb3069b0e04-52edf02c24bmr2154345e87.50.1721163243536;
        Tue, 16 Jul 2024 13:54:03 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a79bc7f1bffsm356582666b.135.2024.07.16.13.54.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jul 2024 13:54:03 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH v3 36/49] libmultipath: use libmp_mapinfo() in do_foreach_partmaps()
Date: Tue, 16 Jul 2024 22:53:41 +0200
Message-ID: <20240716205344.146310-4-mwilck@suse.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716205344.146310-1-mwilck@suse.com>
References: <20240716205344.146310-1-mwilck@suse.com>
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
index 1d41207..37d2578 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -948,60 +948,6 @@ out:
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
@@ -1443,7 +1389,7 @@ char *dm_mapname(int major, int minor)
 }
 
 static int
-do_foreach_partmaps (const char * mapname,
+do_foreach_partmaps (const char *mapname,
 		     int (*partmap_func)(const char *, void *),
 		     void *data)
 {
@@ -1451,9 +1397,18 @@ do_foreach_partmaps (const char * mapname,
 	char __attribute__((cleanup(cleanup_charp))) *params = NULL;
 	struct dm_names *names;
 	unsigned next = 0;
-	unsigned long long size;
-	char dev_t[32];
+	char dev_t[BLK_DEV_SIZE];
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
@@ -1468,41 +1423,38 @@ do_foreach_partmaps (const char * mapname,
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
-			if (partmap_func(names->name, data) != 0)
-				return 1;
-		}
+		    !isdigit(*(p + strlen(dev_t))) &&
+
+		    (partmap_func(names->name, data) != 0))
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


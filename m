Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A243B189F2F
	for <dm-devel@lists.linux.dev>; Tue,  9 Jul 2024 21:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561223; cv=none; b=rNbjy0feueUfeqUvf8m0tz/hJ2b3uvHTN824WDftrGUJbt6HrfMKOiY7sfd1A0oYuPNVwJ7hIg9vx0xfiCU98N9Zoz7VTFC/+zZVeZ9LGH5E12LK4059YtiN3TuaZv8Q8BSN/4k+voyRecrL18XCNLcuiCDaVDP/N45tRKe5+5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561223; c=relaxed/simple;
	bh=t3+2hzdJUxHvUdsXsVZgBFXOzntDmyDqb06IXcC/o1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jz3uqdSBggu5qmDArrOUVBzkpUM5vGUZYDUgsIS2cy7i5h8GLVp67L0HLNg4/6aDWb4Uw5vVzRgXvqOcSDxxsSIyJcupm1bvhaSb/QL8W7LJkiylCDRNvN70XQyGSm13ta9AYWI3rnn25fwkxxt87Bok4lFD2OJwd+JDJgNgX60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LOa15SE4; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LOa15SE4"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a7979c3ffb1so4354666b.2
        for <dm-devel@lists.linux.dev>; Tue, 09 Jul 2024 14:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720561220; x=1721166020; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wVA1lF8wGSqjEhnr7LdWiCu28aMvyYZBiBSYWm6DWLI=;
        b=LOa15SE4v10cjjPktdP5YpK2U2B4Cvky0TyRWizt6ATYEl08zcs6/fMtmVOlY42HLz
         3zoHCaivlGN+ynpgQ5OrOG27QxtFVWUPWb0KAKx4XggMkgQQGR2C2nlJr8h7uViZWL52
         lDXAXGDP0AlVWgIElfBizScbZeJhLHsQ5T97zjedto3iANpBgQ7WNJw7s++brO8T1MyH
         XcBFlWbpIPWVuUijW2A6MUWf6q0dcx9hxyz5d74ViWi/kKoi1IzhP503wJprRk8vzw9i
         ix5IlWD0bnbtD8m7vkdgSO/GEZCrJq2KRZA/LlBao5m6C5FLLF5ZjCQQHs2Q7gqnekIW
         Yg8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720561220; x=1721166020;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wVA1lF8wGSqjEhnr7LdWiCu28aMvyYZBiBSYWm6DWLI=;
        b=YyQwmCrUJhqHNBP76nZfTbwRXK7V1e4fg7GvBdJ/GF/kwqGzPWzmS+Xs0sKtcnqp2j
         bC7AzkQMxngADocem/lQmgRlIQAiu7n+pVQi9BpfPtfn5PRC6h16kP4wrxHX1aDmV/cK
         7aL0ppAWK31oluNtUw37DoUOg4guTmGA+XBUfqGjzUA3AKZjERfhmwetRA2rlooJe/I1
         6Gkj3N+h0S/IciAoM+pG5hfkrmF0Uh7kE3hs/aa3OrnxR6CwiLmjJRsgfnT97U9w5rfU
         tx9hru+6OtdgG+g7blG4yhEnxShnThgDUN8sBurAN5lBPgEu3qfWqCo7WeSY+tzOJc3E
         iXoA==
X-Gm-Message-State: AOJu0YzbtioA8FWOnYufstVS4LMr6pHKGG2sK4j9JTTIgzj3KEt76uvU
	dz3PmzHHrxMnmlKt8VDHPWCLi5gCtkJn3JXsIKaqRrf6KBgt1H12L7IzgAoqLIs=
X-Google-Smtp-Source: AGHT+IGrQzIwqnEHbOwMzY0dD1kkjFXhQz52I3Y4VJPS3q3UZ/YgkcHQdPM0f7nOZl75pekY2In+bg==
X-Received: by 2002:a50:d61d:0:b0:57c:6ade:d8f5 with SMTP id 4fb4d7f45d1cf-594bb67f905mr2944039a12.21.1720561219870;
        Tue, 09 Jul 2024 14:40:19 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-594bc4e80c6sm1501494a12.46.2024.07.09.14.40.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:40:19 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 34/44] libmultipath: use libmp_mapinfo() in do_foreach_partmaps()
Date: Tue,  9 Jul 2024 23:39:25 +0200
Message-ID: <20240709213935.177028-35-mwilck@suse.com>
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

Also, simplify the if statement a bit.
drop is_mpath_part() and dm_type_match, because do_foreach_partmaps() was the
last user of these functions.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 102 +++++++++++----------------------------
 1 file changed, 28 insertions(+), 74 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index f7ad7a8..185c76b 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -936,60 +936,6 @@ out:
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
@@ -1425,7 +1371,7 @@ char *dm_mapname(int major, int minor)
 }
 
 static int
-do_foreach_partmaps (const char * mapname,
+do_foreach_partmaps (const char *mapname,
 		     int (*partmap_func)(const char *, void *),
 		     void *data)
 {
@@ -1433,10 +1379,20 @@ do_foreach_partmaps (const char * mapname,
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
+			  (mapinfo_t) { .uuid = map_uuid, .dmi = &info }) != DMP_OK
+	    || !is_mpath_uuid(map_uuid))
+		return 1;
+
+	if (safe_sprintf(dev_t, "%i:%i", info.major, info.minor))
+		return 1;
 
 	if (!(dmt = libmp_dm_task_create(DM_DEVICE_LIST)))
 		return 1;
@@ -1451,41 +1407,39 @@ do_foreach_partmaps (const char * mapname,
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
+		    libmp_mapinfo(DM_MAP_BY_NAME,
+				  (mapid_t) { .str = names->name },
+				  (mapinfo_t) {
+					  .tgt_type = TGT_PART,
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


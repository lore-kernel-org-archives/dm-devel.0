Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF2D17836D
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804584; cv=none; b=utdTHl3M9fd/yBJIRrfWqWF2aqYuo+HDyOfG0z0KwHnXnqUCLRQjwv5x9HrUawtXHo10/zjKg+Ww8x4CmR+TcPbGC04AXXfvMHMFOpoDJqnnJrRSI/u5FiFk2M3nYGxadeVz6/ZiR4dmmaYP0/7xF7A67Bvv/ezxQUYjWGrziDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804584; c=relaxed/simple;
	bh=7Y0f+Km+jmh3o/ntj4+vkeIN57Ripocxqm1pn4RGfgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oP38hHhzvKCR+X3I3ZMR6z6UFeV88fAvn/zuNfVKsBxbZ9qm+hTbNHIYXSUgw6LZMzauFVYpJzW7F2mDALZ0GgAVpYacaBdORHuhtcj9JL02bRsz6Z60gNkfIUZ1c5SbDuZgAqQ+JDYw3dPcUzaK26lRDO32Blz6FZkErDpTwyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Kr9o26dG; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Kr9o26dG"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a77e7420697so328557166b.1
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804581; x=1721409381; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9jSFu0vK64uftNQS4GPPdyGYtRVv01//ENda8KRwDYk=;
        b=Kr9o26dGT02blU8W41k4ndMS6lxdApLHfvt5AwTHx2cb/U6FPnF3wDH1mjGW/M8LSv
         X/jeXmH8T5boOn945zrh+QJDVbwDTn0Li1o4tDCFDvUzRDaGrM6Zm58pJOzbTiMKQtri
         5lMK4/qtelcUekUQ9By4gAbQgmzzwGddm1K+hia/3N+BeQ6MsiecYkBnGbfszZd4xJv3
         jn0mJmlovlreKAAp2Pj4LpMyhb7iijrWknMHSU7Q2KyjAjsNdbOG/lu8XdoVhCuveozR
         6AGZHBBtVnSCjgWbgeJo0tQ744UB8ItemO+hQ5Crit2A4KVYb1izb7iErmULWDAiA8WN
         +lCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804581; x=1721409381;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9jSFu0vK64uftNQS4GPPdyGYtRVv01//ENda8KRwDYk=;
        b=lM4hY+afgRpLmgHkiL83A1V38ahSQuCNk5nnF8YqXmG4jrgcf+HLy9oFslDPUtv29Q
         Y7pXyMcmtZoacO/j2wcrkUBnFfaT/PLerDK4MfWOeFdpmqXsLek8EsVmEzvOs3ZH8XW4
         TmITmy6dsJ9rjwuJ3XmTHztPXlObN5vF2Hc7KHQwB3p2L++rbn9woaPB3vdBqGi5qn4E
         SccNrUqI1ejdzgzNPtbZKDjzw2kz3bPjgj3Vjy36iyaIvgHLwBpDRsWuqOqCLLUCOK3S
         mqNoUHgzoq5hGobXt1CpHpL6KrcnYKp9INAfgdhUlmIU2VyKCl4V0Mnk2Eum+8dUqlSM
         1D2g==
X-Gm-Message-State: AOJu0Yyn/tS2PP0+H+jRx7nehHLEOvoPIp6+xNam8PsbdOEvEtHHX6wP
	1gtT06cR800D/MbRmUvHH7ZHWkTOr+VQswWXrZPmnaDTV3FfyeQjvKh41D6eZGM=
X-Google-Smtp-Source: AGHT+IFLBor2iFkXzquokwF0fXhu7JYFm/sDxcBau0vdzeny834gxYP/ODZ333+mnVA9xLxC7Q0FQw==
X-Received: by 2002:a17:907:6e88:b0:a77:e0ed:8bb with SMTP id a640c23a62f3a-a780b6ff10emr1032277766b.42.1720804580755;
        Fri, 12 Jul 2024 10:16:20 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a7ff073sm359689366b.137.2024.07.12.10.16.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:16:20 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 47/49] libmultipath: don't call do_foreach_partmaps() recursively
Date: Fri, 12 Jul 2024 19:14:55 +0200
Message-ID: <20240712171458.77611-48-mwilck@suse.com>
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

We've removed partition mappings recursively since 83fb936 ("Correctly remove
logical partition maps"). This was wrong, because kpartx doesn't create
logical partitions as mappings onto the extended partition. Rather, logical
partitions are created by kpartx as mappings to the multipath device, and
afaics, this has always been the case. Therefore, the loop in
do_foreach_partmaps() will detect all partition mappings (primary, extended,
and logical) without recursion. At least since 4059e42 ("libmultipath: fix
partition detection"), the recursion has actually been pointless, because
is_mpath_part() would never have returned "true" for a pair of two partition
mappings (one representing an extended partition and one a logical partition).

Avoiding the recursion has the additional benefit that the complexity of
removing maps scales with N, where N is the number of dm devices, rather than
with N^2. Also, it simplifies the code.

Split partmap_in_use() into two separate functions, mpath_in_use() (to be called
for multipath maps) and count_partitions(), which is called from
do_foreach_partmaps().

Because do_foreach_partmaps() is now only legitimately called for multipath
maps, quit early if called for another map type.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c          | 48 +++++++++++++++++++------------
 libmultipath/devmapper.h          |  2 +-
 libmultipath/libmultipath.version |  2 +-
 multipathd/main.c                 |  2 +-
 4 files changed, 33 insertions(+), 21 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 5749d63..d9d96be 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -933,22 +933,37 @@ has_partmap(const char *name __attribute__((unused)),
 	return 1;
 }
 
-int
-partmap_in_use(const char *name, void *data)
+/*
+ * This will be called from mpath_in_use, for each partition.
+ * If the partition itself in use, returns 1 immediately, causing
+ * do_foreach_partmaps() to stop iterating and return 1.
+ * Otherwise, increases the partition count.
+ */
+static int count_partitions(const char *name, void *data)
+{
+	int *ret_count = (int *)data;
+	int open_count = dm_get_opencount(name);
+
+	if (open_count)
+		return 1;
+	(*ret_count)++;
+	return 0;
+}
+
+int mpath_in_use(const char *name)
 {
-	int part_count, *ret_count = (int *)data;
 	int open_count = dm_get_opencount(name);
 
-	if (ret_count)
-		(*ret_count)++;
-	part_count = 0;
 	if (open_count) {
-		if (do_foreach_partmaps(name, partmap_in_use, &part_count))
-			return 1;
-		if (open_count != part_count) {
-			condlog(2, "%s: map in use", name);
+		int part_count = 0;
+
+		if (do_foreach_partmaps(name, count_partitions, &part_count)) {
+			condlog(4, "%s: %s has open partitions", __func__, name);
 			return 1;
 		}
+		condlog(4, "%s: %s: %d openers, %d partitions", __func__, name,
+			open_count, part_count);
+		return open_count > part_count;
 	}
 	return 0;
 }
@@ -976,7 +991,7 @@ int _dm_flush_map (const char *mapname, int flags, int retries)
 
 	/* If you aren't doing a deferred remove, make sure that no
 	 * devices are in use */
-	if (!(flags & DMFL_DEFERRED) && partmap_in_use(mapname, NULL))
+	if (!(flags & DMFL_DEFERRED) && mpath_in_use(mapname))
 			return DM_FLUSH_BUSY;
 
 	if ((flags & DMFL_SUSPEND) &&
@@ -1314,7 +1329,7 @@ do_foreach_partmaps (const char *mapname,
 	char map_uuid[DM_UUID_LEN];
 	struct dm_info info;
 
-	if (libmp_mapinfo(DM_MAP_BY_NAME,
+	if (libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_CHECK_UUID,
 			  (mapid_t) { .str = mapname },
 			  (mapinfo_t) { .uuid = map_uuid, .dmi = &info }) != DMP_OK)
 		return 1;
@@ -1381,12 +1396,9 @@ remove_partmap(const char *name, void *data)
 {
 	struct remove_data *rd = (struct remove_data *)data;
 
-	if (dm_get_opencount(name)) {
-		dm_remove_partmaps(name, rd->flags);
-		if (!(rd->flags & DMFL_DEFERRED) && dm_get_opencount(name)) {
-			condlog(2, "%s: map in use", name);
-			return DM_FLUSH_BUSY;
-		}
+	if (!(rd->flags & DMFL_DEFERRED) && dm_get_opencount(name)) {
+		condlog(2, "%s: map in use", name);
+		return DM_FLUSH_BUSY;
 	}
 	condlog(4, "partition map %s removed", name);
 	dm_device_remove(name, rd->flags);
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index d01f9f2..6eb5ab9 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -149,7 +149,7 @@ enum {
 	DM_FLUSH_BUSY,
 };
 
-int partmap_in_use(const char *name, void *data);
+int mpath_in_use(const char *name);
 
 enum {
 	DMFL_NONE      = 0,
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 54b5a23..649c1cb 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -139,10 +139,10 @@ global:
 	libmultipath_exit;
 	libmultipath_init;
 	load_config;
+	mpath_in_use;
 	need_io_err_check;
 	orphan_path;
 	parse_prkey_flags;
-	partmap_in_use;
 	pathcount;
 	path_discovery;
 	path_get_tpgs;
diff --git a/multipathd/main.c b/multipathd/main.c
index 536974c..13af94e 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -597,7 +597,7 @@ flush_map_nopaths(struct multipath *mpp, struct vectors *vecs) {
 		return false;
 	}
 	if (mpp->flush_on_last_del == FLUSH_UNUSED &&
-            partmap_in_use(mpp->alias, NULL) && is_queueing) {
+	    mpath_in_use(mpp->alias) && is_queueing) {
 		condlog(2, "%s: map in use and queueing, can't remove",
 			mpp->alias);
 		return false;
-- 
2.45.2


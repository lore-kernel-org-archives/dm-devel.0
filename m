Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9739C54F95
	for <dm-devel@lists.linux.dev>; Tue, 16 Jul 2024 20:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721163250; cv=none; b=hHxXGZXvqA5+Q4JUyIH2BqTfsqHudLKd2eluSlW3itQIlPN1p6yxY5rtSx0jexp+h1JWzMcp/r7HPnL7jF5eucugsWl4DFfGohWMyke5LXXqE+w2Yu1KCyaJP9S/rb+GBirEja6HI4036dRelbAYUQ7EQJ2a2/e+2K2tl+NECh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721163250; c=relaxed/simple;
	bh=P3+BNHif6v8HpjvP6t7ikHMQ1mjMG+MSMGWRDKp1fus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jG1GyvCSrgdwUvxl6A4CR8O46KTH8T6exvJLK4lAKiqZVWQk550IhlH4hmS8hzliPRaFp38Cxu0ZGa8TKgjAx7Kt+DcUHXtHHlSG0gMkFCcWZW7OtH0T/pFsCkleVpTaEIl/F9w+cOdjwrNkjXkyH6uEkzNoLSKfQTaie6b5MiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CcnhvmlH; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CcnhvmlH"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3678f36f154so3593953f8f.2
        for <dm-devel@lists.linux.dev>; Tue, 16 Jul 2024 13:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721163247; x=1721768047; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uZlmDkSNB5/rTWFnOqgq7eKBBSYe3/9yGQfVskFcDZA=;
        b=CcnhvmlHOBwajQ3I/6adh61bLWjjrzG42YvfFYAfxuk5ZetXEamiuNMN9R1hjbnr/x
         szOjoePBDbkRnFjManYSIuPw+MCnNNgssBJ4GPzjhKrkMgGrcWZouxJFvgvKNZ07Scuf
         ij5s1CM87GqEB+RaDI1Hs63WD0VCLep8gdGvrK5UFmoIghgVBqTTdDv4Yhe71SgN3TQu
         qhBv7qfi8Z3LIsV0G8mJUmwep+YxVVYHpJQxddIzXx7BaqgIgVz3sY5X9H7BQPn+LqmH
         YfDH7yjqczUz4no5mvuRtNMQ9I+/ejqErIrpWIXDa4lWiqtynKSY1TE/i+T9TFvK0ydi
         zhZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721163247; x=1721768047;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uZlmDkSNB5/rTWFnOqgq7eKBBSYe3/9yGQfVskFcDZA=;
        b=uoVsZxHanXvnLQrY5+HNYszv3bWXMndJ1b7i8bhHBLja9cTwPDiS4GQDDWYHiLZiCY
         ZQvRcPqlNDxiBZXxzuJu0yJxpFeIrwIhBJW6m0Jb/ZIE3Fz3EWpNq9Y+874KILsTnXOY
         o5r5JC6nK+cKg5Y5ZYFK2Hp6uim6SVL+q+8y92rRHhVTiGNb6M6xYd3fMS95rJKBUv9l
         7U8L1X2RLzNFCzZmjR0bRWuyvYhgWSScm606uVnOAjQasFwpzlymUNFBFV3t2fuBNBx3
         ZRLPsXkGj1bL3x/B+ofikchH6Y01AXeMMbti7dsMEC16Adclx7AYIOn5Ohl8q6EISKrc
         W/dQ==
X-Gm-Message-State: AOJu0Yz+Qwlnztk6xge834KCfiYB8pf5tDUTTLdEjeC1M8YJvraSacdB
	x4Z20ccEsdYJLVSwZXFHFE2w3d+FynnDZH5RQrTaTseGWeJQKCvFnppqWuLHSc0=
X-Google-Smtp-Source: AGHT+IHBcivsKQMyy/xlTwaT3091kWdx/T5IsXhq6CKBaH4069k9/suTRfrIyjTUyUj0/yf7TL8Ypw==
X-Received: by 2002:a5d:6143:0:b0:367:9877:750e with SMTP id ffacd0b85a97d-3682609b526mr2060241f8f.25.1721163246652;
        Tue, 16 Jul 2024 13:54:06 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-59b24a76ef7sm5473453a12.10.2024.07.16.13.54.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jul 2024 13:54:06 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH v3 48/49] libmultipath: don't call do_foreach_partmaps() recursively
Date: Tue, 16 Jul 2024 22:53:44 +0200
Message-ID: <20240716205344.146310-7-mwilck@suse.com>
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
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c          | 48 +++++++++++++++++++------------
 libmultipath/devmapper.h          |  2 +-
 libmultipath/libmultipath.version |  2 +-
 multipathd/main.c                 |  2 +-
 4 files changed, 33 insertions(+), 21 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 455905a..3b2e8ac 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -929,22 +929,37 @@ has_partmap(const char *name __attribute__((unused)),
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
@@ -968,7 +983,7 @@ int _dm_flush_map (const char *mapname, int flags, int retries)
 
 	/* If you aren't doing a deferred remove, make sure that no
 	 * devices are in use */
-	if (!(flags & DMFL_DEFERRED) && partmap_in_use(mapname, NULL))
+	if (!(flags & DMFL_DEFERRED) && mpath_in_use(mapname))
 			return DM_FLUSH_BUSY;
 
 	if ((flags & DMFL_SUSPEND) &&
@@ -1305,7 +1320,7 @@ do_foreach_partmaps (const char *mapname,
 	char map_uuid[DM_UUID_LEN];
 	struct dm_info info;
 
-	if (libmp_mapinfo(DM_MAP_BY_NAME,
+	if (libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_CHECK_UUID,
 			  (mapid_t) { .str = mapname },
 			  (mapinfo_t) { .uuid = map_uuid, .dmi = &info }) != DMP_OK)
 		return 1;
@@ -1372,12 +1387,9 @@ remove_partmap(const char *name, void *data)
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
index 7a551d9..f6d0017 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -150,7 +150,7 @@ enum {
 	DM_FLUSH_BUSY,
 };
 
-int partmap_in_use(const char *name, void *data);
+int mpath_in_use(const char *name);
 
 enum {
 	DMFL_NONE      = 0,
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 292a330..959f675 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -138,10 +138,10 @@ global:
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
index 833c1e2..13ed6d0 100644
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


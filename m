Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24140664DB
	for <dm-devel@lists.linux.dev>; Thu,  2 May 2024 19:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714676410; cv=none; b=W31cjtu+ZDgCVK1S2yyB5gpQ4ttp+ucQFZ7m8CEOWy0BZxAUXG+5P5ecHp+VdDM0e8FpNe82yB2lDzC89QZ4lzuvtkUidrhz62feW/z0v2/IEjD+1hSFTzKJuoSEAlgUL4SGWNYwQqEsODpN4JalSlHL3CRaRN/FThSqp0tKgdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714676410; c=relaxed/simple;
	bh=kIH3s5sv5jp1Yhd0hh4rKC/FX7edizNcHKbsGPg23SE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RJPYpJ8SW1MQYsXjdpEWFnk9Q+YV6VM2TA+CpcXrDSYpfR3KcA6XaRtctBbV1nKRB784ch7LvB+M0vmtXGMg2g5c7n05NsWk68kwQ5S0cDspLgi2jKOxRdu6SRpZ+7EVfvuwCzAnWwUZG/T8HI6lsPyUshhTmyUtba1Hpy1+sjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=W0lZa0D4; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="W0lZa0D4"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-572babec735so1166460a12.0
        for <dm-devel@lists.linux.dev>; Thu, 02 May 2024 12:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1714676406; x=1715281206; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7DdC07DBta9RVKmErjlht6S0Wd6hy5Ip/EqYIQTURRQ=;
        b=W0lZa0D4XWYgDIbC48+1cHLpN/nEMG12b1XF9QYPM9QaPklqN1QgyeV6SeCmTNNhrf
         KSXEXUUdVhh0WNVd1h7Oo9uBCoohaSfCZ6djyP3EjwyLSmHtIVtpn9nD4BOzdQKwuer1
         +3Bl+okHfrGa2cdo+JBepY2wx63hGva1E1qlNHNAiYWgW8Hpid3o4DHO+jozn1b/SM4m
         sUP87VhQat1qkc1tKaLbIgMneojf2U1Wd0rOg8Atpz9gR7JqbaY740qC2gYsgDO4XqVA
         /Q3/234dmTalXl59SstDMLwnU6LH3if2MO/E2JOl9bBQASvxLcazZurERPhCMKHP2TSD
         IbaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714676406; x=1715281206;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7DdC07DBta9RVKmErjlht6S0Wd6hy5Ip/EqYIQTURRQ=;
        b=dSSi9iVuwczeqFFlZ3kUUJrZIKcHdfO/4M3vI5S187m8aV4wkTNEfoQ6vMdN/QauJ+
         uYZrO7riXs0nyL8ijLx3bWDUZ14sU0iyJvRhKUEEfYi6X3wfnjxfpgBoe0fa3y4axOut
         mti1PoN+FG/QwBmSNXqReHGcjJmUNT/J3LsaMifUd5wcXY1q7hBt/kqaRHFHdFxn+m6K
         Va2Qdp1NAkgmLfMPNdpqmGUFD7OzfxjVPlr2rywLRvrJlabxW9HiW3jKvfJVgngvuVLb
         fRf/JOd21qlwAPFRq2AnQhLRuFzrx6Q6nB3B8TpBohF9S7o0Sh7Dqba7+x7oMsNyukpk
         +u2g==
X-Gm-Message-State: AOJu0YyZubdP67jGDsm+MmRd1PERjibtuBKjkFpdDUGZ3ywf5ap7zIiw
	XGdFg04OBobCMPbcM9maycSgTn+yjqYVcSuqlNKuEmjEZ/WeFgTQ4FHlCGZlwKgZChyb+GJTuAF
	q
X-Google-Smtp-Source: AGHT+IEcjQY2/tIeKQ8fN1hHo8EIyYWyrbf6XWFZSBOeMzImHaG0nwWCPiU8TuVFpnVi9vRK/GXxNg==
X-Received: by 2002:a17:906:bc52:b0:a58:eb9a:420d with SMTP id s18-20020a170906bc5200b00a58eb9a420dmr2480647ejv.17.1714676406269;
        Thu, 02 May 2024 12:00:06 -0700 (PDT)
Received: from localhost (p200300de373edc00b298a6be282c8242.dip0.t-ipconnect.de. [2003:de:373e:dc00:b298:a6be:282c:8242])
        by smtp.gmail.com with UTF8SMTPSA id n25-20020a1709061d1900b00a5906b4e417sm841039ejh.98.2024.05.02.12.00.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 May 2024 12:00:06 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 1/3] libmultipath: use bitwise flags for map flushing API
Date: Thu,  2 May 2024 20:59:44 +0200
Message-ID: <20240502185946.31192-2-mwilck@suse.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240502185946.31192-1-mwilck@suse.com>
References: <20240502185946.31192-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rather than passing 3 separate bool variables to _dm_flush_map(),
define bitwise flags to modify the function's behavior, and pass
these flags to called functions accordingly.

This improves the readability of the code, function calls are
more expressive.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 72 +++++++++++++++++-----------------------
 libmultipath/devmapper.h | 18 +++++++---
 2 files changed, 43 insertions(+), 47 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 2e7b2c6..a6a9c2b 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -53,9 +53,8 @@ static int dm_cancel_remove_partmaps(const char * mapname);
 #define __DR_UNUSED__ __attribute__((unused))
 #endif
 
-static int dm_remove_partmaps (const char * mapname, int need_sync,
-			       int deferred_remove);
-static int do_foreach_partmaps(const char * mapname,
+static int dm_remove_partmaps (const char *mapname, int flags);
+static int do_foreach_partmaps(const char *mapname,
 			       int (*partmap_func)(const char *, void *),
 			       void *data);
 static int _dm_queue_if_no_path(const char *mapname, int enable);
@@ -439,9 +438,9 @@ int dm_simplecmd_noflush (int task, const char *name, uint16_t udev_flags)
 }
 
 static int
-dm_device_remove (const char *name, int needsync, int deferred_remove) {
-	return dm_simplecmd(DM_DEVICE_REMOVE, name, 0, needsync, 0,
-			    deferred_remove);
+dm_device_remove (const char *name, int flags) {
+	return dm_simplecmd(DM_DEVICE_REMOVE, name, 0, flags & DMFL_NEED_SYNC, 0,
+			    flags & DMFL_DEFERRED);
 }
 
 static int
@@ -1061,8 +1060,7 @@ partmap_in_use(const char *name, void *data)
 	return 0;
 }
 
-int _dm_flush_map (const char * mapname, int need_sync, int deferred_remove,
-		   int need_suspend, int retries)
+int _dm_flush_map (const char *mapname, int flags, int retries)
 {
 	int r;
 	int queue_if_no_path = 0;
@@ -1080,10 +1078,10 @@ int _dm_flush_map (const char * mapname, int need_sync, int deferred_remove,
 
 	/* If you aren't doing a deferred remove, make sure that no
 	 * devices are in use */
-	if (!deferred_remove && partmap_in_use(mapname, NULL))
+	if (!(flags & DMFL_DEFERRED) && partmap_in_use(mapname, NULL))
 			return DM_FLUSH_BUSY;
 
-	if (need_suspend &&
+	if ((flags & DMFL_SUSPEND) &&
 	    dm_get_map(mapname, &mapsize, &params) == DMP_OK &&
 	    strstr(params, "queue_if_no_path")) {
 		if (!_dm_queue_if_no_path(mapname, 0))
@@ -1095,22 +1093,22 @@ int _dm_flush_map (const char * mapname, int need_sync, int deferred_remove,
 	free(params);
 	params = NULL;
 
-	if ((r = dm_remove_partmaps(mapname, need_sync, deferred_remove)))
+	if ((r = dm_remove_partmaps(mapname, flags)))
 		return r;
 
-	if (!deferred_remove && dm_get_opencount(mapname)) {
+	if (!(flags & DMFL_DEFERRED) && dm_get_opencount(mapname)) {
 		condlog(2, "%s: map in use", mapname);
 		return DM_FLUSH_BUSY;
 	}
 
 	do {
-		if (need_suspend && queue_if_no_path != -1)
+		if ((flags & DMFL_SUSPEND) && queue_if_no_path != -1)
 			dm_simplecmd_flush(DM_DEVICE_SUSPEND, mapname, 0);
 
-		r = dm_device_remove(mapname, need_sync, deferred_remove);
+		r = dm_device_remove(mapname, flags);
 
 		if (r) {
-			if (deferred_remove && dm_map_present(mapname)) {
+			if ((flags & DMFL_DEFERRED) && dm_map_present(mapname)) {
 				condlog(4, "multipath map %s remove deferred",
 					mapname);
 				return DM_FLUSH_DEFERRED;
@@ -1124,7 +1122,7 @@ int _dm_flush_map (const char * mapname, int need_sync, int deferred_remove,
 		} else {
 			condlog(2, "failed to remove multipath map %s",
 				mapname);
-			if (need_suspend && queue_if_no_path != -1) {
+			if ((flags & DMFL_SUSPEND) && queue_if_no_path != -1) {
 				dm_simplecmd_noflush(DM_DEVICE_RESUME,
 						     mapname, udev_flags);
 			}
@@ -1139,27 +1137,18 @@ int _dm_flush_map (const char * mapname, int need_sync, int deferred_remove,
 	return DM_FLUSH_FAIL;
 }
 
+int
+dm_flush_map_nopaths(const char *mapname, int deferred_remove __DR_UNUSED__)
+{
+	int flags = DMFL_NEED_SYNC;
+
 #ifdef LIBDM_API_DEFERRED
-
-int
-dm_flush_map_nopaths(const char * mapname, int deferred_remove)
-{
-	return _dm_flush_map(mapname, 1,
-			     (deferred_remove == DEFERRED_REMOVE_ON ||
-			      deferred_remove == DEFERRED_REMOVE_IN_PROGRESS),
-			     0, 0);
-}
-
-#else
-
-int
-dm_flush_map_nopaths(const char * mapname,
-		     int deferred_remove __attribute__((unused)))
-{
-	return _dm_flush_map(mapname, 1, 0, 0, 0);
-}
-
+	flags |= ((deferred_remove == DEFERRED_REMOVE_ON ||
+		   deferred_remove == DEFERRED_REMOVE_IN_PROGRESS) ?
+		  DMFL_DEFERRED : 0);
 #endif
+	return _dm_flush_map(mapname, flags, 0);
+}
 
 int dm_flush_maps (int retries)
 {
@@ -1528,8 +1517,7 @@ out:
 }
 
 struct remove_data {
-	int need_sync;
-	int deferred_remove;
+	int flags;
 };
 
 static int
@@ -1538,21 +1526,21 @@ remove_partmap(const char *name, void *data)
 	struct remove_data *rd = (struct remove_data *)data;
 
 	if (dm_get_opencount(name)) {
-		dm_remove_partmaps(name, rd->need_sync, rd->deferred_remove);
-		if (rd->deferred_remove && dm_get_opencount(name)) {
+		dm_remove_partmaps(name, rd->flags);
+		if ((rd->flags & DMFL_DEFERRED) && dm_get_opencount(name)) {
 			condlog(2, "%s: map in use", name);
 			return DM_FLUSH_BUSY;
 		}
 	}
 	condlog(4, "partition map %s removed", name);
-	dm_device_remove(name, rd->need_sync, rd->deferred_remove);
+	dm_device_remove(name, rd->flags);
 	return DM_FLUSH_OK;
 }
 
 static int
-dm_remove_partmaps (const char * mapname, int need_sync, int deferred_remove)
+dm_remove_partmaps (const char * mapname, int flags)
 {
-	struct remove_data rd = { need_sync, deferred_remove };
+	struct remove_data rd = { flags };
 	return do_foreach_partmaps(mapname, remove_partmap, &rd);
 }
 
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 93caa2a..bb4a55a 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -58,12 +58,20 @@ enum {
 };
 
 int partmap_in_use(const char *name, void *data);
-int _dm_flush_map (const char *, int, int, int, int);
-int dm_flush_map_nopaths(const char * mapname, int deferred_remove);
-#define dm_flush_map(mapname) _dm_flush_map(mapname, 1, 0, 0, 0)
-#define dm_flush_map_nosync(mapname) _dm_flush_map(mapname, 0, 0, 0, 0)
+
+enum {
+	DMFL_NONE      = 0,
+	DMFL_NEED_SYNC = 1 << 0,
+	DMFL_DEFERRED  = 1 << 1,
+	DMFL_SUSPEND   = 1 << 2,
+};
+
+int _dm_flush_map (const char *mapname, int flags, int retries);
+#define dm_flush_map(mapname) _dm_flush_map(mapname, DMFL_NEED_SYNC, 0)
+#define dm_flush_map_nosync(mapname) _dm_flush_map(mapname, DMFL_NONE, 0)
 #define dm_suspend_and_flush_map(mapname, retries) \
-	_dm_flush_map(mapname, 1, 0, 1, retries)
+	_dm_flush_map(mapname, DMFL_NEED_SYNC|DMFL_SUSPEND, retries)
+int dm_flush_map_nopaths(const char * mapname, int deferred_remove);
 int dm_cancel_deferred_remove(struct multipath *mpp);
 int dm_flush_maps (int retries);
 int dm_fail_path(const char * mapname, char * path);
-- 
2.44.0


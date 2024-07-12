Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FBFA1DFE1
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804552; cv=none; b=Rx64BuOqdhsM43DPCnpt3pkX44wLA+mjCx6DvpYLVOSKbkZ8jRWKohpgv/Jj0tMZsAOFb6P4P8EnoQ6tnW2avSJ/Zg//ia+OIAQqaULxpi62bWOlVo/arLLm3sPSx/t+x3NgVbYs5GbjkcHYJ7U+CyHVUL4qOX2haSvw8TIkMGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804552; c=relaxed/simple;
	bh=a3Qomh7r+XQJv8AgJcSa7KEIG/bdVHWIY5lhTvSAKl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PB5EpvjXG/OsjDIR0mzq9hAS5U8wx2rk3JxVzgqlJcgdNl39Ya6AOD5glbw7ljsLBAyNbcn8ra9xZDxYXfpNqwPUeI4gjMa7HaDFcxDifyVpejX8Yoe3K84C13lES6c03dq4lmKsXqhpNryXDcCGPnY1rBwB5SX0EZBV5a1vD/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YabDJqTB; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YabDJqTB"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a77d85f7fa3so353681366b.0
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804548; x=1721409348; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xDRAEgksnrwrHraCLi40lP8JWJgvc8mA85ibNChiY8o=;
        b=YabDJqTByzXqxiH6R7xNVwVT/KmZdg4mYDAK8HKTe8m5IIeilV8OOjirTvDP7DbQnv
         AScoAlCjBjeA1RzY4/6ekPPQcaeVCNBdB8uoCoKjxvkTC72Cn6n4/zsFgep0/ACJrcN0
         pv43h54R57MLsRYmE8gKngmJNEvwhDCUFFNQB9iiPGJqwzWMj1S6qFMfDI1LYIe5tobg
         1U3MvBIChRc/ZwP2N+obESy5Fws/f5F/nyiwC+XhOynlZn1+KQjxaumNdJQc4grGntyJ
         8aAaCLKcsjos6QnJ1+e3tthmm6i4QNF2R83ky6rCwRU6Q+QQnZIfz1vdmcLRrmDrbrtU
         h5lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804548; x=1721409348;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xDRAEgksnrwrHraCLi40lP8JWJgvc8mA85ibNChiY8o=;
        b=hVguCq0cJflB1d9ZBO0agvkZ7qCCMuRWsPZ4sDHjC0F8LUsgYv/WK0TVeAvebR6aHT
         cGEBXFw+QCJUJ3aY4B/zxBNQSt1ixJxg/BKy+8Aa3A4E8J0ZvQYAHtpRV8LrKiQ47ng/
         IrjMZktuk/fY9YxhI/SBpKCs7PlK6/8w/kDB5v/0WiO793Igm76PvQndweC31gq0eGNo
         Iy/Os8MHt1pm/QyYWJONIYNyuqeIJk9IgXP3ctM39UkcIvfGsrtQCVOk5q6Jx9sSJaK3
         2roBN4g+F46LKqCFVptEgCJwzAPy4x9w3gaU4/lgHTfyz0qjvEfloYL6WGY8kwjmrDkS
         +QuA==
X-Gm-Message-State: AOJu0Yy+mbEywJ+XEK/1m7Waij/oh0B0DDXkn5yQcHtBdpX8b7KyCI7+
	F3MiD+YALhobjDUeKs4eWoiwzXxjylYy6VpALhl51F+dIywK9KEqIL3YbZ02oro=
X-Google-Smtp-Source: AGHT+IGC2ESdspVhmMapgBQ/Cl39AsiL2n3GdspjacJahGsK7qIXZHICFk1e9m+N9OJ3uweFr8dnsg==
X-Received: by 2002:a17:906:fe4b:b0:a6f:e7a0:91cf with SMTP id a640c23a62f3a-a799cd005ddmr300095866b.24.1720804548414;
        Fri, 12 Jul 2024 10:15:48 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-5959bd1d4bdsm4002966a12.88.2024.07.12.10.15.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:15:48 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 18/49] libmultipath: Use symbolic return values for dm_is_mpath()
Date: Fri, 12 Jul 2024 19:14:26 +0200
Message-ID: <20240712171458.77611-19-mwilck@suse.com>
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

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_persist_int.c |  2 +-
 libmultipath/devmapper.c            | 22 ++++++++--------------
 libmultipath/devmapper.h            |  6 ++++++
 multipath/main.c                    |  4 ++--
 multipathd/dmevents.c               | 19 +++++++++++++------
 multipathd/main.c                   |  2 +-
 6 files changed, 31 insertions(+), 24 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 178c2f5..6da0401 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -185,7 +185,7 @@ static int mpath_get_map(vector curmp, vector pathvec, int fd, char **palias,
 
 	condlog(3, "alias = %s", alias);
 
-	if (dm_map_present(alias) && dm_is_mpath(alias) != 1){
+	if (dm_map_present(alias) && dm_is_mpath(alias) != DM_IS_MPATH_YES) {
 		condlog(3, "%s: not a multipath device.", alias);
 		goto out;
 	}
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index a63154f..3abdc26 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -846,15 +846,9 @@ static int dm_type_match(const char *name, char *type)
 		return DM_TYPE_NOMATCH;
 }
 
-/*
- * returns:
- * 1  : is multipath device
- * 0  : is not multipath device
- * -1 : error
- */
 int dm_is_mpath(const char *name)
 {
-	int r = -1;
+	int r = DM_IS_MPATH_ERR;
 	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
 	struct dm_info info;
 	uint64_t start, length;
@@ -876,7 +870,7 @@ int dm_is_mpath(const char *name)
 	if (!dm_task_get_info(dmt, &info))
 		goto out;
 
-	r = 0;
+	r = DM_IS_MPATH_NO;
 
 	if (!info.exists)
 		goto out;
@@ -895,10 +889,10 @@ int dm_is_mpath(const char *name)
 	if (!target_type || strcmp(target_type, TGT_MPATH) != 0)
 		goto out;
 
-	r = 1;
+	r = DM_IS_MPATH_YES;
 out:
-	if (r < 0)
-		condlog(3, "%s: dm command failed in %s: %s", name, __FUNCTION__, strerror(errno));
+	if (r == DM_IS_MPATH_ERR)
+		condlog(3, "%s: dm command failed in %s: %s", name, __func__, strerror(errno));
 	return r;
 }
 
@@ -1039,7 +1033,7 @@ int _dm_flush_map (const char *mapname, int flags, int retries)
 	unsigned long long mapsize;
 	char *params = NULL;
 
-	if (dm_is_mpath(mapname) != 1)
+	if (dm_is_mpath(mapname) != DM_IS_MPATH_YES)
 		return DM_FLUSH_OK; /* nothing to do */
 
 	/* if the device currently has no partitions, do not
@@ -1086,7 +1080,7 @@ int _dm_flush_map (const char *mapname, int flags, int retries)
 			}
 			condlog(4, "multipath map %s removed", mapname);
 			return DM_FLUSH_OK;
-		} else if (dm_is_mpath(mapname) != 1) {
+		} else if (dm_is_mpath(mapname) != DM_IS_MPATH_YES) {
 			condlog(4, "multipath map %s removed externally",
 				mapname);
 			return DM_FLUSH_OK; /* raced. someone else removed it */
@@ -1316,7 +1310,7 @@ int dm_get_maps(vector mp)
 	}
 
 	do {
-		if (dm_is_mpath(names->name) != 1)
+		if (dm_is_mpath(names->name) != DM_IS_MPATH_YES)
 			goto next;
 
 		mpp = dm_get_multipath(names->name);
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index ff28575..9438c2d 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -46,6 +46,12 @@ int dm_map_present (const char *name);
 int dm_map_present_by_uuid(const char *uuid);
 int dm_get_map(const char *name, unsigned long long *size, char **outparams);
 int dm_get_status(const char *name, char **outstatus);
+
+enum {
+	DM_IS_MPATH_NO,
+	DM_IS_MPATH_YES,
+	DM_IS_MPATH_ERR,
+};
 int dm_is_mpath(const char *name);
 
 enum {
diff --git a/multipath/main.c b/multipath/main.c
index ce702e7..c82bc86 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -247,7 +247,7 @@ static int check_usable_paths(struct config *conf,
 		goto out;
 	}
 
-	if (dm_is_mpath(mapname) != 1) {
+	if (dm_is_mpath(mapname) != DM_IS_MPATH_YES) {
 		condlog(1, "%s is not a multipath map", devpath);
 		goto free;
 	}
@@ -1080,7 +1080,7 @@ main (int argc, char *argv[])
 		goto out;
 	}
 	if (cmd == CMD_FLUSH_ONE) {
-		if (dm_is_mpath(dev) != 1) {
+		if (dm_is_mpath(dev) != DM_IS_MPATH_YES) {
 			condlog(0, "%s is not a multipath device", dev);
 			r = RTVL_FAIL;
 			goto out;
diff --git a/multipathd/dmevents.c b/multipathd/dmevents.c
index 3fbdc55..af1e12e 100644
--- a/multipathd/dmevents.c
+++ b/multipathd/dmevents.c
@@ -168,9 +168,13 @@ static int dm_get_events(void)
 	while (names->dev) {
 		uint32_t event_nr;
 
-		/* Don't delete device if dm_is_mpath() fails without
-		 * checking the device type */
-		if (dm_is_mpath(names->name) == 0)
+		/*
+		 * Don't delete device if dm_is_mpath() fails without
+		 * checking the device type.
+		 * IOW, only delete devices from the event list for which
+		 *  we positively know that they aren't multipath devices.
+		 */
+		if (dm_is_mpath(names->name) == DM_IS_MPATH_NO)
 			goto next;
 
 		event_nr = dm_event_nr(names);
@@ -206,9 +210,12 @@ int watch_dmevents(char *name)
 	struct dev_event *dev_evt, *old_dev_evt;
 	int i;
 
-	/* We know that this is a multipath device, so only fail if
-	 * device-mapper tells us that we're wrong */
-	if (dm_is_mpath(name) == 0) {
+	/*
+	 * We know that this is a multipath device, so only fail if
+	 * device-mapper tells us that we're wrong
+	 * IOW, don't fail for DM generic errors.
+	 */
+	if (dm_is_mpath(name) == DM_IS_MPATH_NO) {
 		condlog(0, "%s: not a multipath device. can't watch events",
 			name);
 		return -1;
diff --git a/multipathd/main.c b/multipathd/main.c
index 58afe14..132bb2e 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -865,7 +865,7 @@ ev_add_map (char * dev, const char * alias, struct vectors * vecs)
 	int reassign_maps;
 	struct config *conf;
 
-	if (dm_is_mpath(alias) != 1) {
+	if (dm_is_mpath(alias) != DM_IS_MPATH_YES) {
 		condlog(4, "%s: not a multipath map", alias);
 		return 0;
 	}
-- 
2.45.2


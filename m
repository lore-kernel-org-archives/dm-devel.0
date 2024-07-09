Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F4F18562D
	for <dm-devel@lists.linux.dev>; Tue,  9 Jul 2024 21:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561206; cv=none; b=HIWszUN4h4dWBHr6lsbM1FkNj16Vy05dk7UoBT2dyvnMUQ8oIAnpxopDsayLtcNivoJprHXQ+XiNxE43ajp/J/gwvEzPaQwpGhjYPZ3KoJzc6fx3lvvE6CRbxnuH3LjZe7D3J5APrOMU7C17jbN8599wk7XJSPf/nhRyIuRDoRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561206; c=relaxed/simple;
	bh=BWzWrn4DF/tj9PUIMIV2uMHgfBFCDjQeUhVmLC9BLVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HOnSnexkt6zdjtjKlzG5wSZoHopxFt8H7Mmfu1yTy+twT5EcoLqdTOSZKVSXgk7KOuduS/0ty1bRFia1MltzLLhtbR4OGJK5bbxpbNosgUTKPlDo0n4nrBRRMeZXltODuamU1t8TnvzdVOER4NpN2BpOOfckGfhy3CdTaO7tMRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eYkM0BDY; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eYkM0BDY"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a77abe5c709so702747566b.2
        for <dm-devel@lists.linux.dev>; Tue, 09 Jul 2024 14:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720561203; x=1721166003; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XTYJDngICXIr2ezVvKYXSchmRJKnzoEJnmixHkgAzLQ=;
        b=eYkM0BDYJk/NzFKBlZnET57sB56mFYCMgc6Q8s7HRzd4z3UBfmo9BPVMC7QMxJHFZb
         r3mPZP2bnCdxgq8FBnvsLrywzXY3nLZTNG8ro2pZLrs1dvDMUl68EiHYxQb+no0Sm24h
         SUu1w+uksWzfgzyLJnQgEMY6GIgWIiwst+Jn4y+pgjPgIg4MH8nJavxVILXYaII5D3Ri
         wokk+biS9QbgfK9THDxwOlW/wHhwMfk0WUbejJbOIFQu/HSXp8X2LJQsF/cl4wohtFFa
         KkCHjG0J4oP69t1GYMSHQew/oOAqqHAZ0BIcdQWVaSOcCYuiQe1MT0V3IAhLrqTltkBC
         w/Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720561203; x=1721166003;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XTYJDngICXIr2ezVvKYXSchmRJKnzoEJnmixHkgAzLQ=;
        b=Dwn1mVxVby8uzyz1kwrkxj9xRftk0rPU2BWz/oO9IoqH541RoZUotZ4o496ZNJV3Cg
         BfoXs2rTCKv5BmX+MT11byD7IXZqpeO+71o8AQeKp/FXzxagfKF9T0xBBffqFiR1nTkR
         EHBc/ZNAspaQR8OGYwS63VZSBxjjj0oJ41USRAYP0hIV1SI26DCoVTadij9C6ulXWr3k
         SRBLr56kqRqzj9X7hKJeQMP8njW2I3PPgWOqRjbo1CYA9T/WWRAupOOrOm2xd6jsWWbK
         2XStvOsAGObnAKaXTyT6cxyF2yaKNTdMGf6vpAyE4zgm6G+TBZvo8gV5HV1FjpC/A/on
         f/zA==
X-Gm-Message-State: AOJu0YyjpbPAoAAotfDhH+CxdTE9fLfvcAV3aSzn4icd5tjCOINlOG57
	F4NP7IdiFcVJseNozJVctOk2vofaGfg0tI4egGIc++70TD7G4z6ZSmEiP2z2C5u6L+ua12UIdJ2
	Y
X-Google-Smtp-Source: AGHT+IFxES/60hFWtY5qojyjjecmMbxln5vJT2kdhHWAFMgbvg5v25zxqbHyV7ZCaJQCAl3ThKRfOg==
X-Received: by 2002:a17:906:3989:b0:a77:cd4f:e4f5 with SMTP id a640c23a62f3a-a780b89ca7dmr212765266b.68.1720561203082;
        Tue, 09 Jul 2024 14:40:03 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a871ec9sm106868866b.200.2024.07.09.14.40.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:40:02 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 19/44] libmultipath: implement dm_get_info() and dm_map_present() with new API
Date: Tue,  9 Jul 2024 23:39:10 +0200
Message-ID: <20240709213935.177028-20-mwilck@suse.com>
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

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c          | 54 ++++---------------------------
 libmultipath/devmapper.h          | 16 +++++++--
 libmultipath/libmultipath.version |  2 --
 multipathd/main.c                 |  4 +--
 4 files changed, 23 insertions(+), 53 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 5c9f9d8..bdeba48 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -783,45 +783,6 @@ int libmp_mapinfo(int flags, mapid_t id, mapinfo_t info)
 			       libmp_map_identifier(flags, id, idbuf));
 }
 
-int
-dm_get_info(const char *name, struct dm_info *info)
-{
-	int r = -1;
-	struct dm_task *dmt;
-
-	if (!name || !info)
-		return r;
-
-	if (!(dmt = libmp_dm_task_create(DM_DEVICE_INFO)))
-		return r;
-
-	if (!dm_task_set_name(dmt, name))
-		goto out;
-
-	if (!libmp_dm_task_run(dmt)) {
-		dm_log_error(3, DM_DEVICE_INFO, dmt);
-		goto out;
-	}
-
-	if (!dm_task_get_info(dmt, info))
-		goto out;
-
-	if (!info->exists)
-		goto out;
-
-	r = 0;
-out:
-	dm_task_destroy(dmt);
-	return r;
-}
-
-int dm_map_present(const char * str)
-{
-	struct dm_info info;
-
-	return (dm_get_info(str, &info) == 0);
-}
-
 int dm_get_map(const char *name, unsigned long long *size, char **outparams)
 {
 	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
@@ -1120,15 +1081,14 @@ out:
 	return r;
 }
 
-static int
-dm_dev_t (const char * mapname, char * dev_t, int len)
+static int dm_dev_t (const char *mapname, char *dev_t, int len)
 {
 	struct dm_info info;
 
-	if (dm_get_info(mapname, &info) != 0)
+	if (dm_get_info(mapname, &info) != DMP_OK)
 		return 1;
 
-	if (snprintf(dev_t, len, "%i:%i", info.major, info.minor) > len)
+	if (safe_snprintf(dev_t, len, "%i:%i", info.major, info.minor))
 		return 1;
 
 	return 0;
@@ -1169,7 +1129,7 @@ dm_get_major_minor(const char *name, int *major, int *minor)
 {
 	struct dm_info info;
 
-	if (dm_get_info(name, &info) != 0)
+	if (dm_get_info(name, &info) != DMP_OK)
 		return -1;
 
 	*major = info.major;
@@ -1515,7 +1475,7 @@ dm_geteventnr (const char *name)
 {
 	struct dm_info info;
 
-	if (dm_get_info(name, &info) != 0)
+	if (dm_get_info(name, &info) != DMP_OK)
 		return -1;
 
 	return info.event_nr;
@@ -1526,7 +1486,7 @@ dm_is_suspended(const char *name)
 {
 	struct dm_info info;
 
-	if (dm_get_info(name, &info) != 0)
+	if (dm_get_info(name, &info) != DMP_OK)
 		return -1;
 
 	return info.suspended;
@@ -1678,7 +1638,7 @@ dm_get_deferred_remove (const char * mapname)
 {
 	struct dm_info info;
 
-	if (dm_get_info(mapname, &info) != 0)
+	if (dm_get_info(mapname, &info) != DMP_OK)
 		return -1;
 
 	return info.deferred_remove;
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 269389b..0cdd757 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -99,6 +99,20 @@ typedef struct libmp_map_info {
  */
 int libmp_mapinfo(int flags, mapid_t id, mapinfo_t info);
 
+static inline int dm_get_info(const char *mapname, struct dm_info *info)
+{
+	return libmp_mapinfo(DM_MAP_BY_NAME,
+			     (mapid_t) { .str = mapname },
+			     (mapinfo_t) { .dmi = info });
+}
+
+static inline int dm_map_present(const char *mapname)
+{
+	return libmp_mapinfo(DM_MAP_BY_NAME,
+			     (mapid_t) { .str = mapname },
+			     (mapinfo_t) { .name = NULL }) == DMP_OK;
+}
+
 int dm_prereq(unsigned int *v);
 void skip_libmp_dm_init(void);
 void libmp_dm_exit(void);
@@ -108,7 +122,6 @@ int dm_simplecmd_flush (int task, const char *name, uint16_t udev_flags);
 int dm_simplecmd_noflush (int task, const char *name, uint16_t udev_flags);
 int dm_addmap_create (struct multipath *mpp, char *params);
 int dm_addmap_reload (struct multipath *mpp, char *params, int flush);
-int dm_map_present (const char *name);
 int dm_map_present_by_uuid(const char *uuid);
 int dm_get_map(const char *name, unsigned long long *size, char **outparams);
 int dm_get_status(const char *name, char **outstatus);
@@ -159,7 +172,6 @@ int dm_get_major_minor (const char *name, int *major, int *minor);
 char * dm_mapname(int major, int minor);
 int dm_get_uuid(const char *name, char *uuid, int uuid_len);
 bool has_dm_info(const struct multipath *mpp);
-int dm_get_info (const char * mapname, struct dm_info *dmi);
 int dm_rename (const char * old, char * new, char * delim, int skip_kpartx);
 int dm_reassign(const char * mapname);
 int dm_reassign_table(const char *name, char *old, char *new);
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 48c2b67..7a50349 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -78,14 +78,12 @@ global:
 	dm_flush_map_nopaths;
 	dm_flush_maps;
 	dm_geteventnr;
-	dm_get_info;
 	dm_get_major_minor;
 	dm_get_maps;
 	dm_get_multipath;
 	dm_get_uuid;
 	dm_is_mpath;
 	dm_mapname;
-	dm_map_present;
 	dm_prereq;
 	dm_queue_if_no_path;
 	dm_reassign;
diff --git a/multipathd/main.c b/multipathd/main.c
index 132bb2e..394ca7d 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -502,7 +502,7 @@ remove_maps_and_stop_waiters(struct vectors *vecs)
 
 int refresh_multipath(struct vectors *vecs, struct multipath *mpp)
 {
-	if (dm_get_info(mpp->alias, &mpp->dmi)) {
+	if (dm_get_info(mpp->alias, &mpp->dmi) != DMP_OK) {
 		/* Error accessing table */
 		condlog(2, "%s: cannot access table", mpp->alias);
 		goto out;
@@ -722,7 +722,7 @@ add_map_without_path (struct vectors *vecs, const char *alias)
 
 	mpp->alias = strdup(alias);
 
-	if (dm_get_info(mpp->alias, &mpp->dmi)) {
+	if (dm_get_info(mpp->alias, &mpp->dmi) != DMP_OK) {
 		condlog(3, "%s: cannot access table", mpp->alias);
 		goto out;
 	}
-- 
2.45.2


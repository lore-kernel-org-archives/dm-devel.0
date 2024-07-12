Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD1817BCD
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804556; cv=none; b=iFIJQsx3HzYR/18hVjEk6vg3LHOOk8xIp4R3bvhLfIfYMaLuhDzNT5N1uv+Oll6rOkE5agwXXKl4eE76WiI/d8YfC4fX77do77xrFHGnix3ICOtlMDKNLRRK2u/LDTjT1ROtJ4mJ1Gfaa9sbYoLxNO9NIMxFVlSmdUoiMQuOTms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804556; c=relaxed/simple;
	bh=oOWc/M484IeF9+mJU6e+I6+idN6xoVnSZYHEzXpquV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gmLzRpffjJdv9iObgr32mw+sJcxy4TmnrC/sgrcVcvRIHCklif8c8sQrZrxCsUjTXguC+dh/MswUls8Onrtagj2OqW9czgPucqM0Ph6BJJkDCxkhoSvy/3veyRRZKdmndx04kYZ85WHGneY2GcfCAqeyz/VmEGkvbKpMZwcHc84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NGAAW4Rb; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NGAAW4Rb"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a77e5929033so315997266b.0
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804552; x=1721409352; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1V8rDsIOutfB4ukS9az8eU485SujLHQxpe369D7FMZg=;
        b=NGAAW4Rb/6kICF/ZBod1/El6JNClOPQc8puYzoQ3slKtKm/qHkM/H1TkG0yI14247f
         7SCbO0Iwsf2wTGFup1wljjX6+4fqQbfMBRtk1RgnZLYV3qYXl1Y78S3rlaPadGSsIpdH
         Zv996Dc6GFEb4avgK4VQXvtQunyNUhRG91e37zFD2Kp3AnMlHYVas6crDT4R2dGU6/nx
         KoFGZa0jPuDdk5qyq9Y4fGdE1nHvHq6ck6i9MgooRqm4qI0b0FGGiwnHKs+FOJKoNaHU
         Bnrquw4KfeKqD877pu1fI8xwJoN7ZVSi0YA/nAf08wRZYQ1RdHzrjGbz9w0tcx8kMILg
         fJzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804552; x=1721409352;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1V8rDsIOutfB4ukS9az8eU485SujLHQxpe369D7FMZg=;
        b=UO8OwbnjmrnLu5/FMDCleqmHxG6DlTXTZfsKgCh6SnFYnjty+fHREp3ihSc9cbhzo9
         i73tMH5/UVmVWI3nio8EYZXj1XcrnsTm0achh8c2cvzwQomUqES+exrRpymHnvxubOml
         Ik5zpqPqxVi0NkfWK6XYc0NNC2vLYmJjqtpES0uz264T9T3/dPMMv7PD7Hbnlu6U/qS8
         1Am8epBM8M6fQGKGweRe9tiH3nFQf9PcKLISZlj5Z+lDr1sm0bi1BDE60TF/UBRrfYEg
         /MxjF4cOW6ncnZHEmWCCQQP8u3/9z3p3s3b14DDDjx9BQ4kzAv5fMV8hE2LhcFBpc8BU
         qHxw==
X-Gm-Message-State: AOJu0YyZ9vu/vYklRTBGFG6LuEllfNW6s7i8+fwUJYCb3KVTTrdrlS4b
	/3QsbUJpfIClnp9lHi6mi9JJxScFj/YA+7Rm99X7xzMYvzxUYgi9viZ7AUHuUc9TAVYE3zeoUyO
	+
X-Google-Smtp-Source: AGHT+IE0uCOvqv9C0B7zuFGQ+d1Y2nSHWRwlGIAczxewVu1t6E+OxTcZ8m7pM80cxCHlyzd0svC6sQ==
X-Received: by 2002:a17:907:94c5:b0:a6f:392d:51a9 with SMTP id a640c23a62f3a-a780b6883c2mr1030396966b.14.1720804551409;
        Fri, 12 Jul 2024 10:15:51 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a6e37ffsm359778166b.76.2024.07.12.10.15.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:15:51 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 21/49] libmultipath: implement dm_get_info() and dm_map_present() with new API
Date: Fri, 12 Jul 2024 19:14:29 +0200
Message-ID: <20240712171458.77611-22-mwilck@suse.com>
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
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c          | 54 ++++---------------------------
 libmultipath/devmapper.h          | 16 +++++++--
 libmultipath/libmultipath.version |  2 --
 multipathd/main.c                 |  4 +--
 4 files changed, 23 insertions(+), 53 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 4e6b5b2..754f45e 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -794,45 +794,6 @@ int libmp_mapinfo(int flags, mapid_t id, mapinfo_t info)
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
@@ -1131,15 +1092,14 @@ out:
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
@@ -1180,7 +1140,7 @@ dm_get_major_minor(const char *name, int *major, int *minor)
 {
 	struct dm_info info;
 
-	if (dm_get_info(name, &info) != 0)
+	if (dm_get_info(name, &info) != DMP_OK)
 		return -1;
 
 	*major = info.major;
@@ -1526,7 +1486,7 @@ dm_geteventnr (const char *name)
 {
 	struct dm_info info;
 
-	if (dm_get_info(name, &info) != 0)
+	if (dm_get_info(name, &info) != DMP_OK)
 		return -1;
 
 	return info.event_nr;
@@ -1537,7 +1497,7 @@ dm_is_suspended(const char *name)
 {
 	struct dm_info info;
 
-	if (dm_get_info(name, &info) != 0)
+	if (dm_get_info(name, &info) != DMP_OK)
 		return -1;
 
 	return info.suspended;
@@ -1689,7 +1649,7 @@ dm_get_deferred_remove (const char * mapname)
 {
 	struct dm_info info;
 
-	if (dm_get_info(mapname, &info) != 0)
+	if (dm_get_info(mapname, &info) != DMP_OK)
 		return -1;
 
 	return info.deferred_remove;
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 62f50de..6fa99be 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -104,6 +104,20 @@ typedef struct libmp_map_info {
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
@@ -113,7 +127,6 @@ int dm_simplecmd_flush (int task, const char *name, uint16_t udev_flags);
 int dm_simplecmd_noflush (int task, const char *name, uint16_t udev_flags);
 int dm_addmap_create (struct multipath *mpp, char *params);
 int dm_addmap_reload (struct multipath *mpp, char *params, int flush);
-int dm_map_present (const char *name);
 int dm_map_present_by_uuid(const char *uuid);
 int dm_get_map(const char *name, unsigned long long *size, char **outparams);
 int dm_get_status(const char *name, char **outstatus);
@@ -164,7 +177,6 @@ int dm_get_major_minor (const char *name, int *major, int *minor);
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


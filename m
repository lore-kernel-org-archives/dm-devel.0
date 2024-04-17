Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85303171A1
	for <dm-devel@lists.linux.dev>; Wed, 17 Apr 2024 18:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713379624; cv=none; b=pL2DBcp2rOTdDZ5z15Z4KeZG0vCVmN/xGJe/6TiUkDcg2pH+2MbMPZHPuFFpRNLxg9hrGSn8d3Ev81Qf3fgjNCWn+SDUS2Xyl+pH4YRDQvCG0Q5FNtRxFipXfO0cutLpomPrF+bLs2cS2pID89gaGUl9YKe95WMU86uMf55mQ3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713379624; c=relaxed/simple;
	bh=GxIkLGK4meWOas6k6Sxou561sZWWC4YMx/J8RDiA8vc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OljRoQNP6D2GyFH1L+dkoN+Aquj+6On6lYpg0AYn0NPqb0dkcqrDaxjMIP1N05v0YYdWCpHtzASyxpQ87LRamHVZI5f71/87tpmBqWihxPo4qzV9SEyWJzRz4cRCNINwtrzta9LFVN6+EirpQP//F3o50URRMums8gXbEndlPXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fRb/uZZ4; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fRb/uZZ4"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a53f131d9deso447019166b.3
        for <dm-devel@lists.linux.dev>; Wed, 17 Apr 2024 11:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1713379621; x=1713984421; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XOakQ0jXP3vq9GfDKq8+6tKevaMvcHeP6fQ6zmIuZjI=;
        b=fRb/uZZ4cnFCjKOkT7gDsMp6m668f5eArEzgtbto5VENOVBxtoUksBAgexQvZh7mm/
         vyTd01NVHf1F8k/OBKDlygYQxixzJkGFjymspyiVNURZI7kO2WacwpknXd3kR4rGzw8o
         JJ2GNDMqAb3A0Kpr4JUT84d4doaEwdUUt1GzSlDAoRQOzUU68q2FPa/IDWZVUghScrBL
         cXAqyPQTTBtMf2kadtbj1p8rIIWY++lty/7TyVDrvCeVetdfXTNRThNUdiR8Uy10EHw5
         bme2y5CIlMC5IHyGhmGw2a3qJihS1wYX/rF7/+aqjwz6dn9iWHLVr5bM3tq/Gq0+EMjC
         LSpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713379621; x=1713984421;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XOakQ0jXP3vq9GfDKq8+6tKevaMvcHeP6fQ6zmIuZjI=;
        b=R2VyHp+PsJNoMsZE6yclrOWPSGwRAObc5gueMxfgMwk/b4N+C1M9HOZENqFc/guAiD
         tJn8xr3GlGYh3pd32Vx46BRjBIuOrmTIycUUVc7q4b/M4IACjcwaz4VvAAogufxgKiy9
         nZGxy9Z+vUsIxUUmcUdDkbdqtASmMWJj3yzQD5geiwViVKBxNQq1pL29+aNLjIs+ElQY
         rRB1GjuD8JrAhnVn3xoYwCWkj1y+qo1pwSLlq/32H5I1EbA4Qo4bXYCXBNHTbzl9HPVD
         69oaNi97oHcS3JY9qLRxdk0uK+a5GfS358ryX4BoHBvKMoX1MpkzZPVqcz47pbrKs7cL
         uazQ==
X-Gm-Message-State: AOJu0YyXiiLTqGbNRa44Dh1eIO+U3un9YxAHLzL7IVAnlOKiXLTBy7KO
	j10fOVfTUl8JFhzjRO/7RYxmTz8cqWcRUY9TxP+gZP78FH29Dx04btxdifHbWqo=
X-Google-Smtp-Source: AGHT+IFLqit+ZLAT1uTp8llBkLukni+no3b72YMnIFsYOn5zkWGPhwfnPG3EOY4IYfGq/G34FqrHMg==
X-Received: by 2002:a17:906:c9c6:b0:a55:65e6:ce9f with SMTP id hk6-20020a170906c9c600b00a5565e6ce9fmr232716ejb.20.1713379620879;
        Wed, 17 Apr 2024 11:47:00 -0700 (PDT)
Received: from localhost (dslb-090-186-231-154.090.186.pools.vodafone-ip.de. [90.186.231.154])
        by smtp.gmail.com with UTF8SMTPSA id hs40-20020a1709073ea800b00a473362062fsm8390425ejc.220.2024.04.17.11.47.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Apr 2024 11:47:00 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Etienne AUJAMES <eaujames@ddn.com>
Subject: [PATCH 6/8] libmultipath: set max_sectors_kb in adopt_paths()
Date: Wed, 17 Apr 2024 20:46:42 +0200
Message-ID: <20240417184644.6193-7-mwilck@suse.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240417184644.6193-1-mwilck@suse.com>
References: <20240417184644.6193-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As explained in the previous commit, setting max_sectors_kb for
paths that are members of a live map is dangerous. But as long as
a path is not a member of a map, setting max_sectors_kb poses no risk.
Set the parameter in adopt_paths(), for paths that aren't members
of the map yet. In order to determine whether or not a path is currently
member of the map, adopt_paths() needs to passed the current member list. If
(and only if) it's called from coalesce_paths(), the passed struct multipath
does not represent the current state of the map; adopt_paths() must therefore
get a new argument current_mpp that represents the kernel state.

We must still call sysfs_set_max_sectors_kb() from domap() in the ACT_CREATE
case, because when adopt_paths is called from coalesce_paths() for a map that
doesn't exist yet, mpp->max_sectors_kb is not set.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c   |  2 +-
 libmultipath/structs_vec.c | 62 ++++++++++++++++++++++++++++++++++----
 libmultipath/structs_vec.h |  6 ++--
 multipathd/main.c          |  6 ++--
 tests/Makefile             |  2 +-
 tests/test-lib.c           |  9 +++++-
 6 files changed, 73 insertions(+), 14 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 8cbb2a8..b5c701f 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -1105,7 +1105,7 @@ int coalesce_paths (struct vectors *vecs, vector mpvec, char *refwwid,
 		/*
 		 * at this point, we know we really got a new mp
 		 */
-		mpp = add_map_with_path(vecs, pp1, 0);
+		mpp = add_map_with_path(vecs, pp1, 0, cmpp);
 		if (!mpp) {
 			orphan_path(pp1, "failed to create multipath device");
 			continue;
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 0fc608c..c0c5cc9 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -242,7 +242,38 @@ static bool update_pathvec_from_dm(vector pathvec, struct multipath *mpp,
 	return must_reload;
 }
 
-int adopt_paths(vector pathvec, struct multipath *mpp)
+static bool set_path_max_sectors_kb(const struct path *pp, int max_sectors_kb)
+{
+	char buf[11];
+	ssize_t len;
+	int ret, current;
+	bool rc = false;
+
+	if (max_sectors_kb == MAX_SECTORS_KB_UNDEF)
+		return rc;
+
+	if (sysfs_attr_get_value(pp->udev, "queue/max_sectors_kb", buf, sizeof(buf)) <= 0
+	    || sscanf(buf, "%d\n", &current) != 1)
+		current = MAX_SECTORS_KB_UNDEF;
+	if (current == max_sectors_kb)
+		return rc;
+
+	len = snprintf(buf, sizeof(buf), "%d", max_sectors_kb);
+	ret = sysfs_attr_set_value(pp->udev, "queue/max_sectors_kb", buf, len);
+	if (ret != len)
+		log_sysfs_attr_set_value(3, ret,
+					 "failed setting max_sectors_kb on %s",
+					 pp->dev);
+	else {
+		condlog(3, "%s: set max_sectors_kb to %d for %s", __func__,
+			max_sectors_kb, pp->dev);
+		rc = true;
+	}
+	return rc;
+}
+
+int adopt_paths(vector pathvec, struct multipath *mpp,
+		const struct multipath *current_mpp)
 {
 	int i, ret;
 	struct path * pp;
@@ -285,9 +316,28 @@ int adopt_paths(vector pathvec, struct multipath *mpp)
 				continue;
 			}
 
-			if (!find_path_by_devt(mpp->paths, pp->dev_t) &&
-			    store_path(mpp->paths, pp))
-				goto err;
+			if (!find_path_by_devt(mpp->paths, pp->dev_t)) {
+
+				if (store_path(mpp->paths, pp))
+					goto err;
+				/*
+				 * Setting max_sectors_kb on live paths is dangerous.
+				 * But we can do it here on a path that isn't yet part
+				 * of the map. If this value is lower than the current
+				 * max_sectors_kb and the map is reloaded, the map's
+				 * max_sectors_kb will be safely adjusted by the kernel.
+				 *
+				 * We must make sure that the path is not part of the
+				 * map yet. Normally we can check this in mpp->paths.
+				 * But if adopt_paths is called from coalesce_paths,
+				 * we need to check the separate struct multipath that
+				 * has been obtained from map_discovery().
+				 */
+				if (!current_mpp ||
+				    !mp_find_path_by_devt(current_mpp, pp->dev_t))
+					mpp->need_reload = mpp->need_reload ||
+						set_path_max_sectors_kb(pp, mpp->max_sectors_kb);
+			}
 
 			pp->mpp = mpp;
 			condlog(3, "%s: ownership set to %s",
@@ -693,7 +743,7 @@ find_existing_alias (struct multipath * mpp,
 }
 
 struct multipath *add_map_with_path(struct vectors *vecs, struct path *pp,
-				    int add_vec)
+				    int add_vec, const struct multipath *current_mpp)
 {
 	struct multipath * mpp;
 	struct config *conf = NULL;
@@ -721,7 +771,7 @@ struct multipath *add_map_with_path(struct vectors *vecs, struct path *pp,
 		goto out;
 	mpp->size = pp->size;
 
-	if (adopt_paths(vecs->pathvec, mpp) || pp->mpp != mpp ||
+	if (adopt_paths(vecs->pathvec, mpp, current_mpp) || pp->mpp != mpp ||
 	    find_slot(mpp->paths, pp) == -1)
 		goto out;
 
diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
index 3253f1b..dbc4305 100644
--- a/libmultipath/structs_vec.h
+++ b/libmultipath/structs_vec.h
@@ -13,7 +13,8 @@ struct vectors {
 
 void set_no_path_retry(struct multipath *mpp);
 
-int adopt_paths (vector pathvec, struct multipath * mpp);
+int adopt_paths (vector pathvec, struct multipath *mpp,
+		 const struct multipath *current_mpp);
 void orphan_path (struct path * pp, const char *reason);
 void set_path_removed(struct path *pp);
 
@@ -28,7 +29,8 @@ void remove_maps (struct vectors * vecs);
 
 void sync_map_state (struct multipath *);
 struct multipath * add_map_with_path (struct vectors * vecs,
-				struct path * pp, int add_vec);
+				      struct path * pp, int add_vec,
+				      const struct multipath *current_mpp);
 void update_queue_mode_del_path(struct multipath *mpp);
 void update_queue_mode_add_path(struct multipath *mpp);
 int update_multipath_table (struct multipath *mpp, vector pathvec, int flags);
diff --git a/multipathd/main.c b/multipathd/main.c
index dd17d5c..d8518a9 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -636,7 +636,7 @@ update_map (struct multipath *mpp, struct vectors *vecs, int new_map)
 
 retry:
 	condlog(4, "%s: updating new map", mpp->alias);
-	if (adopt_paths(vecs->pathvec, mpp)) {
+	if (adopt_paths(vecs->pathvec, mpp, NULL)) {
 		condlog(0, "%s: failed to adopt paths for new map update",
 			mpp->alias);
 		retries = -1;
@@ -1231,7 +1231,7 @@ rescan:
 	if (mpp) {
 		condlog(4,"%s: adopting all paths for path %s",
 			mpp->alias, pp->dev);
-		if (adopt_paths(vecs->pathvec, mpp) || pp->mpp != mpp ||
+		if (adopt_paths(vecs->pathvec, mpp, NULL) || pp->mpp != mpp ||
 		    find_slot(mpp->paths, pp) == -1)
 			goto fail; /* leave path added to pathvec */
 
@@ -1245,7 +1245,7 @@ rescan:
 			return 0;
 		}
 		condlog(4,"%s: creating new map", pp->dev);
-		if ((mpp = add_map_with_path(vecs, pp, 1))) {
+		if ((mpp = add_map_with_path(vecs, pp, 1, NULL))) {
 			mpp->action = ACT_CREATE;
 			/*
 			 * We don't depend on ACT_CREATE, as domap will
diff --git a/tests/Makefile b/tests/Makefile
index d1d52dd..4005204 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -45,7 +45,7 @@ dmevents-test_OBJDEPS = $(multipathdir)/devmapper.o
 dmevents-test_LIBDEPS = -lpthread -ldevmapper -lurcu
 hwtable-test_TESTDEPS := test-lib.o
 hwtable-test_OBJDEPS := $(multipathdir)/discovery.o $(multipathdir)/blacklist.o \
-	$(multipathdir)/structs.o $(multipathdir)/propsel.o
+	$(multipathdir)/structs_vec.o $(multipathdir)/structs.o $(multipathdir)/propsel.o
 hwtable-test_LIBDEPS := -ludev -lpthread -ldl
 blacklist-test_TESTDEPS := test-log.o
 blacklist-test_LIBDEPS := -ludev
diff --git a/tests/test-lib.c b/tests/test-lib.c
index cdb2780..88f35e9 100644
--- a/tests/test-lib.c
+++ b/tests/test-lib.c
@@ -152,6 +152,13 @@ int __wrap_sysfs_get_size(struct path *pp, unsigned long long *sz)
 	return 0;
 }
 
+int __wrap_sysfs_attr_set_value(struct udev_device *dev, const char *attr_name,
+			   const char * value, size_t value_len)
+{
+	condlog(5, "%s: %s", __func__, value);
+	return value_len;
+}
+
 void *__wrap_udev_device_get_parent_with_subsystem_devtype(
 	struct udev_device *ud, const char *subsys, char *type)
 {
@@ -400,7 +407,7 @@ struct multipath *__mock_multipath(struct vectors *vecs, struct path *pp)
 	/* pathinfo() call in adopt_paths */
 	mock_pathinfo(DI_CHECKER|DI_PRIO, &mop);
 
-	mp = add_map_with_path(vecs, pp, 1);
+	mp = add_map_with_path(vecs, pp, 1, NULL);
 	assert_ptr_not_equal(mp, NULL);
 
 	/* TBD: mock setup_map() ... */
-- 
2.44.0


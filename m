Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D70A185611
	for <dm-devel@lists.linux.dev>; Tue,  9 Jul 2024 21:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561213; cv=none; b=WdiG9jB5CP+WLBURCAod8ZxMJ8R6/FrbmBpNM29h6yJ8xOvAEVfVZzoUDemkWlPn3b8CTYXp6pAcKHKmpzmW5ZrBLuWBj0Neji2vT3S24BWha2XdxOX73RRaX0RBHRZhjeJgkRZhKtQB1M7TlBcdEl8blQJA2U4YV5oQJBMS/Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561213; c=relaxed/simple;
	bh=YEH3XQR0KDrAuALFPMVLKa+CKSuvbvo6D56AXw5W3hY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cDi4/BiLTWvNtLDLd3MjIy+gf2ppP4Njh4dzVq4iSa9VALd04qUQF3TgSC7EZZGVTDmkg8nPNp/LOIXtzXs9UTYm8+WQabH9hfWRo94z4Hj+XYl9fpqKUWWeB9ncOyV5rpEOJ5FnUmHDmpPSXxl7tbhy3CJO2jYXx09aGrQrtVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZM4ym6Ed; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZM4ym6Ed"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a77c25beae1so607670566b.2
        for <dm-devel@lists.linux.dev>; Tue, 09 Jul 2024 14:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720561210; x=1721166010; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f1kTpLELxl0LB7YFL2/B75rXHGI5oW5sgqVtvgnaTVk=;
        b=ZM4ym6Ed/DyKsA1pLa12uuXaYWs6Jhch3Wrx7rqGXB2eJ20N3Jx7HIMtJSzgJOYFYw
         8sw16hwq24CM9BE3FAakHPQGIS2KwLUwjPLZJ/ijTlq2HuVH6checsXGizSq+RtZbu60
         RSpCgBE+EfVGzdQvoL+OQfkG3fvy2VpS9CE3IjMt/1dxFqeFrbYpiI9qjPiMQlAN/iOg
         z2Rkwy4w2vavIQ7ToUjErOeGQ/kspJ9fm3vCrv7HtLiMvXJeKzZxTBywORbPCZ+VZdcT
         Y7nDEfIrFO4kN6ks/eS0deh+kDEnTL6okJ2o4KDxf6eR0HQYXCjU8keqhjnR8zV1iGXY
         qnmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720561210; x=1721166010;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f1kTpLELxl0LB7YFL2/B75rXHGI5oW5sgqVtvgnaTVk=;
        b=ibJHYsP4DiEFwpygjhwG77igRL6uvj6n1kaRy+pTtu6cNna+w88CE0R7q7K3kMLXTW
         StRKZJmQRYHIP36RkssGPHsWjJ1/e3S5WAmqaL9UNqxNzV8Fr0guvevKJHOBx8J3AI23
         wNc8uhZENBpijYmuXuWhlTHVBObs4hzZl52C2a7waB7cz7NkC/ba9hxNeluh4NI+ZmCO
         i5UmviMTL3JumAgibe2GyrEzsGvzTJN/KlCdRA8A4XlCbUXX7bvuEDdDOfnf8iHlXHWh
         4+nCy/BcxcC0sKsaY2I5VHyMspOdiRQ8sRg5KLbzKrByDWxu1vc67cxWv3SFfO89Dm1m
         W0Jw==
X-Gm-Message-State: AOJu0YztQryaV+iGAhuJCag2SQitwHvcefThu0aIDf+fcFkat3suhRyE
	qe1+67Co9p4bMOBviTlCn4mJv7D8R59NkePAL1h2Dq5uAqjLWFVtWbhtsJMkIq8=
X-Google-Smtp-Source: AGHT+IGUwwyul7usXfS5oCkgokqLYdnbYflTSuZstdnvll6SYPKIrThbuinxADbDcjgFz/5X/Fpx+g==
X-Received: by 2002:a17:906:4886:b0:a77:b5e7:ee7b with SMTP id a640c23a62f3a-a780b89cb94mr239460566b.71.1720561209849;
        Tue, 09 Jul 2024 14:40:09 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a7ff243sm108411566b.128.2024.07.09.14.40.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:40:09 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 23/44] libmultipath: improve dm_get_wwid() return value logic
Date: Tue,  9 Jul 2024 23:39:14 +0200
Message-ID: <20240709213935.177028-24-mwilck@suse.com>
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

Make dm_get_wwid() return different status codes for non-existing maps,
maps that exists but are not multipath maps, and generic error case,
and handle these return codes appropriately in callers.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/alias.c     |  5 +++--
 libmultipath/configure.c | 23 +++++++++++------------
 libmultipath/devmapper.c | 21 ++++++++++++++++-----
 libmultipath/wwids.c     |  2 +-
 tests/alias.c            | 10 +++++-----
 5 files changed, 36 insertions(+), 25 deletions(-)

diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index 10e58a7..2ab9499 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -408,13 +408,14 @@ static bool alias_already_taken(const char *alias, const char *map_wwid)
 {
 
 	char wwid[WWID_SIZE];
+	int rc = dm_get_wwid(alias, wwid, sizeof(wwid));
 
 	/* If the map doesn't exist, it's fine */
-	if (dm_get_wwid(alias, wwid, sizeof(wwid)) != 0)
+	if (rc == DMP_NOT_FOUND)
 		return false;
 
 	/* If both the name and the wwid match, it's fine.*/
-	if (strncmp(map_wwid, wwid, sizeof(wwid)) == 0)
+	if (rc == DMP_OK && strncmp(map_wwid, wwid, sizeof(wwid)) == 0)
 		return false;
 
 	condlog(3, "%s: alias '%s' already taken, reselecting alias",
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 666d4e8..565ea5c 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -845,18 +845,17 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
 
 	if (mpp->action == ACT_CREATE && dm_map_present(mpp->alias)) {
 		char wwid[WWID_SIZE];
+		int rc = dm_get_wwid(mpp->alias, wwid, sizeof(wwid));
 
-		if (dm_get_wwid(mpp->alias, wwid, sizeof(wwid)) == 0) {
-			if (!strncmp(mpp->wwid, wwid, sizeof(wwid))) {
-				condlog(3, "%s: map already present",
-					mpp->alias);
-				mpp->action = ACT_RELOAD;
-			} else {
-				condlog(0, "%s: map \"%s\" already present with WWID %s, skipping",
-					mpp->wwid, mpp->alias, wwid);
-				condlog(0, "please check alias settings in config and bindings file");
-				mpp->action = ACT_REJECT;
-			}
+		if (rc == DMP_OK && !strncmp(mpp->wwid, wwid, sizeof(wwid))) {
+			condlog(3, "%s: map already present",
+				mpp->alias);
+			mpp->action = ACT_RELOAD;
+		} else if (rc == DMP_OK || rc == DMP_NO_MATCH) {
+			condlog(1, "%s: map \"%s\" already present with WWID \"%s\", skipping\n"
+				   "please check alias settings in config and bindings file",
+				mpp->wwid, mpp->alias, wwid);
+			mpp->action = ACT_REJECT;
 		}
 	}
 
@@ -1320,7 +1319,7 @@ static int _get_refwwid(enum mpath_cmds cmd, const char *dev,
 		break;
 
 	case DEV_DEVMAP:
-		if (((dm_get_wwid(dev, tmpwwid, WWID_SIZE)) == 0)
+		if (((dm_get_wwid(dev, tmpwwid, WWID_SIZE)) == DMP_OK)
 		    && (strlen(tmpwwid)))
 			refwwid = tmpwwid;
 
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 94ef369..1eebcb5 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -829,19 +829,30 @@ int dm_get_map(const char *name, unsigned long long *size, char **outparams)
 	}
 }
 
+/**
+ * dm_get_wwid(): return WWID for a multipath map
+ * @returns:
+ *    DMP_OK if successful
+ *    DMP_NOT_FOUND if the map doesn't exist
+ *    DMP_NO_MATCH if the map exists but is not a multipath map
+ *    DMP_ERR for other errors
+ */
 int dm_get_wwid(const char *name, char *uuid, int uuid_len)
 {
 	char tmp[DM_UUID_LEN];
+	int rc = dm_get_dm_uuid(name, tmp);
 
-	if (dm_get_dm_uuid(name, tmp) != DMP_OK)
-		return 1;
+	if (rc != DMP_OK)
+		return rc;
 
 	if (!strncmp(tmp, UUID_PREFIX, UUID_PREFIX_LEN))
 		strlcpy(uuid, tmp + UUID_PREFIX_LEN, uuid_len);
-	else
+	else {
 		uuid[0] = '\0';
+		return DMP_NO_MATCH;
+	}
 
-	return 0;
+	return DMP_OK;
 }
 
 static int is_mpath_part(const char *part_name, const char *map_name)
@@ -1377,7 +1388,7 @@ struct multipath *dm_get_multipath(const char *name)
 	if (dm_get_map(name, &mpp->size, NULL) != DMP_OK)
 		goto out;
 
-	if (dm_get_wwid(name, mpp->wwid, WWID_SIZE) != 0)
+	if (dm_get_wwid(name, mpp->wwid, WWID_SIZE) != DMP_OK)
 		condlog(2, "%s: failed to get uuid for %s", __func__, name);
 	if (dm_get_info(name, &mpp->dmi) != 0)
 		condlog(2, "%s: failed to get info for %s", __func__, name);
diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c
index 7a4cb74..aac18c0 100644
--- a/libmultipath/wwids.c
+++ b/libmultipath/wwids.c
@@ -295,7 +295,7 @@ should_multipath(struct path *pp1, vector pathvec, vector mpvec)
 		struct multipath *mp = find_mp_by_wwid(mpvec, pp1->wwid);
 
 		if (mp != NULL &&
-		    dm_get_wwid(mp->alias, tmp_wwid, WWID_SIZE) == 0 &&
+		    dm_get_wwid(mp->alias, tmp_wwid, WWID_SIZE) == DMP_OK &&
 		    !strncmp(tmp_wwid, pp1->wwid, WWID_SIZE)) {
 			condlog(3, "wwid %s is already multipathed, keeping it",
 				pp1->wwid);
diff --git a/tests/alias.c b/tests/alias.c
index 1f78656..a95b308 100644
--- a/tests/alias.c
+++ b/tests/alias.c
@@ -84,7 +84,7 @@ int __wrap_dm_get_wwid(const char *name, char *uuid, int uuid_len)
 	check_expected(uuid_len);
 	assert_non_null(uuid);
 	ret = mock_type(int);
-	if (ret == 0)
+	if (ret == DMP_OK)
 		strcpy(uuid, mock_ptr_type(char *));
 	return ret;
 }
@@ -438,14 +438,14 @@ static void mock_unused_alias(const char *alias)
 {
 	expect_string(__wrap_dm_get_wwid, name, alias);
 	expect_value(__wrap_dm_get_wwid, uuid_len, WWID_SIZE);
-	will_return(__wrap_dm_get_wwid, 1);
+	will_return(__wrap_dm_get_wwid, DMP_NOT_FOUND);
 }
 
 static void mock_self_alias(const char *alias, const char *wwid)
 {
 	expect_string(__wrap_dm_get_wwid, name, alias);
 	expect_value(__wrap_dm_get_wwid, uuid_len, WWID_SIZE);
-	will_return(__wrap_dm_get_wwid, 0);
+	will_return(__wrap_dm_get_wwid, DMP_OK);
 	will_return(__wrap_dm_get_wwid, wwid);
 }
 
@@ -471,14 +471,14 @@ static void mock_self_alias(const char *alias, const char *wwid)
 	do {								\
 		expect_string(__wrap_dm_get_wwid, name, alias);		\
 		expect_value(__wrap_dm_get_wwid, uuid_len, WWID_SIZE);	\
-		will_return(__wrap_dm_get_wwid, 1);			\
+		will_return(__wrap_dm_get_wwid, DMP_NOT_FOUND);		\
 	} while (0)
 
 #define mock_used_alias(alias, wwid)					\
 	do {								\
 		expect_string(__wrap_dm_get_wwid, name, alias);		\
 		expect_value(__wrap_dm_get_wwid, uuid_len, WWID_SIZE);	\
-		will_return(__wrap_dm_get_wwid, 0);			\
+		will_return(__wrap_dm_get_wwid, DMP_OK);		\
 		will_return(__wrap_dm_get_wwid, "WWID_USED");		\
 		expect_condlog(3, USED_STR(alias, wwid));		\
 	} while(0)
-- 
2.45.2


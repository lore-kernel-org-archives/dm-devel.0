Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77503176AD0
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804559; cv=none; b=MeHAOI2n0KgCYKd3VD+XvYrChwZMvh/d4OpNht0Uqobp2LeG9vfwxZ3dkSqmI7PG9Hfd+pQJOuykTyyEDQz9+EHPmMtAWfBr/+PQjLgR88ToYDH9eqOTHwgBm/YWlUhcSHKbv5utM0hAijKLTSxqUV+ZvatcpQcK+KGtUws8nNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804559; c=relaxed/simple;
	bh=vL6K9xU7u9NuzWqPxV563zp9GYsPQ+Ub3RyB+N02w+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sJgR9THKpyLgdRA55bIwK2WAabvtZ4eepZaOdAODVbk89lYMeFMvh4M5ibFxj6EQhpZyioHwbS5nPcXu5qTlr7V8tqrDzqoS6YIbI/IxIUpA0X8THels3d8jbT4+4yxXFLOeOGQUbORXbLzd22PorQrCdC4DqlpKBU2ghNMaAys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fAaMNO+x; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fAaMNO+x"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a77e392f59fso300528766b.1
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804556; x=1721409356; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=30Dw1pELeKsdeaVqOTPPGfpXeD6RAm1zeeVh5PxW+Qs=;
        b=fAaMNO+xOYW+xLeB4w5ht6+T+CzeqjowADgdvMrHvgMJkyP+6QgIEkCaVTbjlXlJxB
         edJ+mxiEKqMnubEc3Ykf2SdNR8c77lf/tEzQHVjTqRR/TXphCFJmcJ06DWFEgKgGQM7f
         +PNXNsdLB21iGP0eYeMZerzXOKoPebtJrIfj8yu50B7sPGyb5t9QLhkBCO+CANk37n4C
         mZbDWKb1/xtOijkrL7h4PgwuklrT1rDJKDNgPRIj7q0hDsCpRCv2FR+8Zqp1PrOqLgmS
         F4mdDXPcjydua6Opc/BM4/bYpfLomj8KhGN3xK/mODDGilo7Jdvzk3gwSrI+E8xDECzr
         b3LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804556; x=1721409356;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=30Dw1pELeKsdeaVqOTPPGfpXeD6RAm1zeeVh5PxW+Qs=;
        b=IQbmKoX7OoHQuzEeyXERdAZBCwrx9a/M9Kc1JcN9ZqSK3MOoXmwchm6IQ9Tcr9QWY2
         wyZWs7lBvzVb4Q4Oyvllqe9ZpcJeWIKKXS0c+FES0ehBAGA/hZnlRNLz5ft4qLil3bUL
         ySIVjodkVYDbmBwjYEOgjcwdJCpAPSbakdOMeR7t56yTD53MTswIIhbDneeXtIbHO8Bc
         kLGD4WmRVR6iNw8ETiHt4rriTK9uyQwVnriKSewvYB0SjinAcua9Tso6HoptHrjlONos
         Yf9p/8d1ha1ztx+o8VQtaxQQ9rWzVATsnh4dNvkVnVAaL8POcBp9zoSF92NwEkGGgvJ8
         PMkw==
X-Gm-Message-State: AOJu0YwyxXT3UrT9P+cOZGTYaPSBq0XnCJKQpt7Ns+0Y5zjXfHuLtOPb
	Hq+dpXSFUkBqSTdNqPFbXh88WDQbOAtFJFL5HLR4UKyOc/Jw/I9TCp5GBLD0xgU=
X-Google-Smtp-Source: AGHT+IF262mL3kUSfcu3oNDv5e6U2KYsAr3ZePW2Wq8UHfeMo/UnLQVZJJpgGFmMW3z3gDqZPK7p1g==
X-Received: by 2002:a17:906:4fd0:b0:a79:7e8b:34c0 with SMTP id a640c23a62f3a-a797e8b4264mr644597566b.1.1720804555478;
        Fri, 12 Jul 2024 10:15:55 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a872e23sm362286766b.225.2024.07.12.10.15.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:15:55 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 24/49] libmultipath: rename dm_get_uuid() -> dm_get_wwid()
Date: Fri, 12 Jul 2024 19:14:32 +0200
Message-ID: <20240712171458.77611-25-mwilck@suse.com>
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

... to make the distinction between WWID (multipath) and
UUID (device mapper) a little more obvious.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/alias.c              |  2 +-
 libmultipath/configure.c          |  4 ++--
 libmultipath/devmapper.c          |  4 ++--
 libmultipath/devmapper.h          |  2 +-
 libmultipath/libmultipath.version |  2 +-
 libmultipath/wwids.c              |  2 +-
 multipathd/main.c                 |  2 +-
 tests/alias.c                     | 30 +++++++++++++++---------------
 8 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index a54616c..10e58a7 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -410,7 +410,7 @@ static bool alias_already_taken(const char *alias, const char *map_wwid)
 	char wwid[WWID_SIZE];
 
 	/* If the map doesn't exist, it's fine */
-	if (dm_get_uuid(alias, wwid, sizeof(wwid)) != 0)
+	if (dm_get_wwid(alias, wwid, sizeof(wwid)) != 0)
 		return false;
 
 	/* If both the name and the wwid match, it's fine.*/
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index b5c701f..666d4e8 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -846,7 +846,7 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
 	if (mpp->action == ACT_CREATE && dm_map_present(mpp->alias)) {
 		char wwid[WWID_SIZE];
 
-		if (dm_get_uuid(mpp->alias, wwid, sizeof(wwid)) == 0) {
+		if (dm_get_wwid(mpp->alias, wwid, sizeof(wwid)) == 0) {
 			if (!strncmp(mpp->wwid, wwid, sizeof(wwid))) {
 				condlog(3, "%s: map already present",
 					mpp->alias);
@@ -1320,7 +1320,7 @@ static int _get_refwwid(enum mpath_cmds cmd, const char *dev,
 		break;
 
 	case DEV_DEVMAP:
-		if (((dm_get_uuid(dev, tmpwwid, WWID_SIZE)) == 0)
+		if (((dm_get_wwid(dev, tmpwwid, WWID_SIZE)) == 0)
 		    && (strlen(tmpwwid)))
 			refwwid = tmpwwid;
 
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index f80fbdf..3fca08c 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -840,7 +840,7 @@ int dm_get_map(const char *name, unsigned long long *size, char **outparams)
 	}
 }
 
-int dm_get_uuid(const char *name, char *uuid, int uuid_len)
+int dm_get_wwid(const char *name, char *uuid, int uuid_len)
 {
 	char tmp[DM_UUID_LEN];
 
@@ -1388,7 +1388,7 @@ struct multipath *dm_get_multipath(const char *name)
 	if (dm_get_map(name, &mpp->size, NULL) != DMP_OK)
 		goto out;
 
-	if (dm_get_uuid(name, mpp->wwid, WWID_SIZE) != 0)
+	if (dm_get_wwid(name, mpp->wwid, WWID_SIZE) != 0)
 		condlog(2, "%s: failed to get uuid for %s", __func__, name);
 	if (dm_get_info(name, &mpp->dmi) != 0)
 		condlog(2, "%s: failed to get info for %s", __func__, name);
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 6fa99be..25e0504 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -175,7 +175,7 @@ int dm_geteventnr (const char *name);
 int dm_is_suspended(const char *name);
 int dm_get_major_minor (const char *name, int *major, int *minor);
 char * dm_mapname(int major, int minor);
-int dm_get_uuid(const char *name, char *uuid, int uuid_len);
+int dm_get_wwid(const char *name, char *uuid, int uuid_len);
 bool has_dm_info(const struct multipath *mpp);
 int dm_rename (const char * old, char * new, char * delim, int skip_kpartx);
 int dm_reassign(const char * mapname);
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 7a50349..7d3ff63 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -81,7 +81,7 @@ global:
 	dm_get_major_minor;
 	dm_get_maps;
 	dm_get_multipath;
-	dm_get_uuid;
+	dm_get_wwid;
 	dm_is_mpath;
 	dm_mapname;
 	dm_prereq;
diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c
index 591cd09..7a4cb74 100644
--- a/libmultipath/wwids.c
+++ b/libmultipath/wwids.c
@@ -295,7 +295,7 @@ should_multipath(struct path *pp1, vector pathvec, vector mpvec)
 		struct multipath *mp = find_mp_by_wwid(mpvec, pp1->wwid);
 
 		if (mp != NULL &&
-		    dm_get_uuid(mp->alias, tmp_wwid, WWID_SIZE) == 0 &&
+		    dm_get_wwid(mp->alias, tmp_wwid, WWID_SIZE) == 0 &&
 		    !strncmp(tmp_wwid, pp1->wwid, WWID_SIZE)) {
 			condlog(3, "wwid %s is already multipathed, keeping it",
 				pp1->wwid);
diff --git a/multipathd/main.c b/multipathd/main.c
index 394ca7d..442a154 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -727,7 +727,7 @@ add_map_without_path (struct vectors *vecs, const char *alias)
 		goto out;
 	}
 	if (!strlen(mpp->wwid))
-		dm_get_uuid(mpp->alias, mpp->wwid, WWID_SIZE);
+		dm_get_wwid(mpp->alias, mpp->wwid, WWID_SIZE);
 	if (!strlen(mpp->wwid))
 		condlog(1, "%s: adding map with empty WWID", mpp->alias);
 	conf = get_multipath_config();
diff --git a/tests/alias.c b/tests/alias.c
index 95ce994..1f78656 100644
--- a/tests/alias.c
+++ b/tests/alias.c
@@ -76,7 +76,7 @@ int WRAP_FUNC(mkstemp)(char *template)
 	return 10;
 }
 
-int __wrap_dm_get_uuid(const char *name, char *uuid, int uuid_len)
+int __wrap_dm_get_wwid(const char *name, char *uuid, int uuid_len)
 {
 	int ret;
 
@@ -436,17 +436,17 @@ static int test_scan_devname(void)
 
 static void mock_unused_alias(const char *alias)
 {
-	expect_string(__wrap_dm_get_uuid, name, alias);
-	expect_value(__wrap_dm_get_uuid, uuid_len, WWID_SIZE);
-	will_return(__wrap_dm_get_uuid, 1);
+	expect_string(__wrap_dm_get_wwid, name, alias);
+	expect_value(__wrap_dm_get_wwid, uuid_len, WWID_SIZE);
+	will_return(__wrap_dm_get_wwid, 1);
 }
 
 static void mock_self_alias(const char *alias, const char *wwid)
 {
-	expect_string(__wrap_dm_get_uuid, name, alias);
-	expect_value(__wrap_dm_get_uuid, uuid_len, WWID_SIZE);
-	will_return(__wrap_dm_get_uuid, 0);
-	will_return(__wrap_dm_get_uuid, wwid);
+	expect_string(__wrap_dm_get_wwid, name, alias);
+	expect_value(__wrap_dm_get_wwid, uuid_len, WWID_SIZE);
+	will_return(__wrap_dm_get_wwid, 0);
+	will_return(__wrap_dm_get_wwid, wwid);
 }
 
 #define USED_STR(alias_str, wwid_str) wwid_str ": alias '" alias_str "' already taken, reselecting alias\n"
@@ -469,17 +469,17 @@ static void mock_self_alias(const char *alias, const char *wwid)
 
 #define mock_failed_alias(alias, wwid)					\
 	do {								\
-		expect_string(__wrap_dm_get_uuid, name, alias);		\
-		expect_value(__wrap_dm_get_uuid, uuid_len, WWID_SIZE);	\
-		will_return(__wrap_dm_get_uuid, 1);			\
+		expect_string(__wrap_dm_get_wwid, name, alias);		\
+		expect_value(__wrap_dm_get_wwid, uuid_len, WWID_SIZE);	\
+		will_return(__wrap_dm_get_wwid, 1);			\
 	} while (0)
 
 #define mock_used_alias(alias, wwid)					\
 	do {								\
-		expect_string(__wrap_dm_get_uuid, name, alias);		\
-		expect_value(__wrap_dm_get_uuid, uuid_len, WWID_SIZE);	\
-		will_return(__wrap_dm_get_uuid, 0);			\
-		will_return(__wrap_dm_get_uuid, "WWID_USED");		\
+		expect_string(__wrap_dm_get_wwid, name, alias);		\
+		expect_value(__wrap_dm_get_wwid, uuid_len, WWID_SIZE);	\
+		will_return(__wrap_dm_get_wwid, 0);			\
+		will_return(__wrap_dm_get_wwid, "WWID_USED");		\
 		expect_condlog(3, USED_STR(alias, wwid));		\
 	} while(0)
 
-- 
2.45.2


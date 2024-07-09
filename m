Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C249C182A6D
	for <dm-devel@lists.linux.dev>; Tue,  9 Jul 2024 21:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561214; cv=none; b=isnKwRyjcmcz3exwSB9+zXReUmOu5JkkS1Qua1eJDlzHATyn3C3bjoScHtfXu1prtd7+lTSNh7BXlezmpQe/2Va7+DXq/MUx327ZffoTt/NqzgXyIbUt3tUSvwmNMdzY+r80f17DkiBK55eCopT8O0VSh2WsoSMYMWVCkKckzz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561214; c=relaxed/simple;
	bh=csylcke6BdbmZMFhkVXwRXn4wM1P+lh6Pa36kcUXHIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cv2vnvqJlfB85bTbuJGVYxrPaPWxtmjDQVMlx2OmWmBs7ta//M4tqPCcfc/6Ny/n/BLcgYIZH398TZY1P/PiFOaO4HzpltGV3xc/xccf48rbrg5k6pu7Hcu4HbJsEWdoziAwGDbiF+QaPmlCU9Aym0kqt96EXGiC9kQKmq0PEnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EKVC9Iv8; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EKVC9Iv8"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-58b966b41fbso7196438a12.1
        for <dm-devel@lists.linux.dev>; Tue, 09 Jul 2024 14:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720561209; x=1721166009; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8X9T97/PY+qt0a8zabI8us2VqRqOlmOTyAGmxnVWmvs=;
        b=EKVC9Iv8du52CwavJNmaswwf1wMSvp6E3kDpJZb7D35sKij7M/g9T/sqQ2+OldD0qN
         joHYmbuLg5uWld3KCrpRzkGNsCM4fjauH+vJux+PCql4GXvjaahzBqLafp5lgAkXtKk4
         kEeF6Jz6cSZQxLrTY9PjsldTxmxj4Gcyr4K/PSrKN1lCSswi4sh6oU3xM2O7j5UttKMw
         sbFMrzGo4iUIx2a78eEuJNmQLjwRCvEH35zQa+9kbsRV1DzZSaJiiE/NYOGmWkKD4KBr
         SgS3l25H8gbn/QHBWz5Vam53Mbfb0Ze+O2ieVN9quCG8uRBi6oSz0qCcSviPdr7T7CB+
         8IFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720561209; x=1721166009;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8X9T97/PY+qt0a8zabI8us2VqRqOlmOTyAGmxnVWmvs=;
        b=mTlhb1Ncb5PTvxrBrFgZbtSNq3srj3KqZYIpDZDJeOBF+UbCY6MRFS4VntyVaur93J
         2f5Z8ZS9wCH464lFKwcaJZYBPHjLhrc1jTMjWkg6kRUt9oNgiDOLDXpKkTpqve6zouOd
         RYswh9zKSsES9j+tlQ4I8VkIBglDZIS0HYvIOpS0G8qo4Gbiz60wCvyQGC/624Bccf/R
         GchEkFxcBBmCbqZDxCYc+3Gsrh8w/GuqXs2fFIN+pfOI0fyUnMF29ozn1WuUtgBskkZe
         hhzXOroPerLQTqRyq+j/r/l2BtrnrBwnrcwJ5AYlVJNvVDjlaa67gueIs6T9EeRu9oV2
         gz7w==
X-Gm-Message-State: AOJu0YxRJHOC3yvIGOJq2OhVX2onqjwQS7iNxkeNz8bcHS2vR/1UWqSb
	EtirWy53ntTG8KW8s93+YaPOaABLBrj602jIk7aEEMJh8GuIVU2ohfE4fM0iG9A=
X-Google-Smtp-Source: AGHT+IGs3umQNvjc1LauFv7zmtffMML8I71RXyJj+z3y7TwihsvSyKeyib000gtX+Hgo8JPsQfImGw==
X-Received: by 2002:a17:906:7147:b0:a77:dbe2:31ff with SMTP id a640c23a62f3a-a780b89a07dmr261195966b.66.1720561209066;
        Tue, 09 Jul 2024 14:40:09 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a6dfb19sm108812866b.66.2024.07.09.14.40.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:40:08 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 22/44] libmultipath: rename dm_get_uuid() -> dm_get_wwid()
Date: Tue,  9 Jul 2024 23:39:13 +0200
Message-ID: <20240709213935.177028-23-mwilck@suse.com>
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

... to make the distinction between WWID (multipath) and
UUID (device mapper) a little more obvious.

Signed-off-by: Martin Wilck <mwilck@suse.com>
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
index d62a7dd..94ef369 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -829,7 +829,7 @@ int dm_get_map(const char *name, unsigned long long *size, char **outparams)
 	}
 }
 
-int dm_get_uuid(const char *name, char *uuid, int uuid_len)
+int dm_get_wwid(const char *name, char *uuid, int uuid_len)
 {
 	char tmp[DM_UUID_LEN];
 
@@ -1377,7 +1377,7 @@ struct multipath *dm_get_multipath(const char *name)
 	if (dm_get_map(name, &mpp->size, NULL) != DMP_OK)
 		goto out;
 
-	if (dm_get_uuid(name, mpp->wwid, WWID_SIZE) != 0)
+	if (dm_get_wwid(name, mpp->wwid, WWID_SIZE) != 0)
 		condlog(2, "%s: failed to get uuid for %s", __func__, name);
 	if (dm_get_info(name, &mpp->dmi) != 0)
 		condlog(2, "%s: failed to get info for %s", __func__, name);
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 0cdd757..0043812 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -170,7 +170,7 @@ int dm_geteventnr (const char *name);
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


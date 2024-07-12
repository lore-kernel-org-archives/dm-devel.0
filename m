Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27473177980
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804560; cv=none; b=BtAc2OL7PtpKSLjpHoz52bBW2ZmqNq375lsvCp4XevM1ADCdhJBOdOBio0EpjptTe2FEyUzvxbCdGUab9yZb2R+Vg1YTbBT0gMlarcu6HDEeQq9pL5APbd4IDOf0EjuYgjMnLLjJeE+saIKmNLS+SeHkhkpWnP/8TJlNZLbl5CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804560; c=relaxed/simple;
	bh=DdlHN+lMe9H17G9yNb1kRBORW8GnkTPOhda2Rsx5OCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AHj3O2U8mBurewlzO/cq86rX/9f23gUmbI+3BDwO4aBiWbTnvxkZVn30UV6dfc2trI8rJCTKzlFHKPiXO/JWLhDGOH+NBli/ZSfZmglXN0sCBUFktYVAfRwEKBOk89HKxy8K4ycC9YSUvZ5U0FB5bWSlCWfkx5M6b1NqtrROLZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OOojQ2h4; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OOojQ2h4"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-58b0dddab63so3613110a12.3
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804556; x=1721409356; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8OgNsgrmPxw01pq/WkRg7H0dk7DF2OPmdmGbajJDocU=;
        b=OOojQ2h4OrFhRVNKAZ6qFabdDdoj3SoCqTBRk0rJtYwzcodi9LfDe50QgPjGh33a98
         vd1ch93qy605S+0StsHkjzVoA80KOE33EnE/EvygWx9TitSh9rHPVQoS4PTULb9hZU5h
         6foinTon6+2QAF8OItCzmzjmjTkuE3SIrVXA88PewQT4eBU7sbp5I/K4o13/iZjyn97w
         FHgz7Zb8UzbeJ3mxc3pAgDoj4KBvJM9S5ByPvnVcVGkYwpAgbOWr8+RBginFFlsL5I+V
         OMotL3VXrwMtG+VBvZCyVmqOkdb/LNHXKmCk1xsdc4CV9bDyv+KmO56gIPQgYRntNEIB
         uUxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804556; x=1721409356;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8OgNsgrmPxw01pq/WkRg7H0dk7DF2OPmdmGbajJDocU=;
        b=S/1BvnsA9WMSf7hQ76APXnJwxok5MBxfhdxVnBFfC6/Y75yvHl7eW5ku+HVMEq+lf+
         Ho8eoZJgs1GbQd25cl+WccHVObdwipZ4fhMKJYUJzXRprDumrsr+KD4wlIub7JD4vnK5
         s/Bv8MIaEv0TctJhkOYwXzs/w8FsXNO3BDctya2HkL7qzPheDkqWTNdSgbQ4deZyqGJM
         jIp94iR5N0cRDMKoprPMzXZgrff2mDLVCwz5+3dK9eJiWRdoeqJZFVduu04GJXPorAui
         Qi6F8oZ2UO0jByavIBQI/8Sl78/oghooZrZnaExQR1Ir8DqjoMQYaivTq6NoOMvpewRe
         TlFA==
X-Gm-Message-State: AOJu0Ywf+mFQs+ipfynmRP2CZNvueMK6lrku4TdYG4sv00xA2O/wFhJb
	mG6g/ki/iqQwzJH81F0ggxYIRtepiV5lICYFaJ3kmyQbgrSkSIMX3D2sKGDRo9A=
X-Google-Smtp-Source: AGHT+IHWM9rOX+QaXWPDHfoNHXan4UXnBWCvX4vSbYEuWi1GBa2jF8Uhp331CWL0BzvFTA7xNcTNEw==
X-Received: by 2002:a17:906:6948:b0:a77:d0a0:ea6d with SMTP id a640c23a62f3a-a780b6b1c55mr734260166b.24.1720804556474;
        Fri, 12 Jul 2024 10:15:56 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a86ed05sm362593766b.188.2024.07.12.10.15.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:15:56 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 25/49] libmultipath: improve dm_get_wwid() return value logic
Date: Fri, 12 Jul 2024 19:14:33 +0200
Message-ID: <20240712171458.77611-26-mwilck@suse.com>
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

Make dm_get_wwid() return different status codes for non-existing maps,
maps that exists but are not multipath maps, and generic error case,
and handle these return codes appropriately in callers.

The error handling is als changed; dm_get_wwid() doesn't take
care of making the ouput 0-terminated if anything fails. The
caller is responsible for that. Change callers accordingly.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/alias.c     | 11 ++++++++---
 libmultipath/configure.c | 27 +++++++++++++++------------
 libmultipath/devmapper.c | 22 +++++++++++++++++-----
 libmultipath/wwids.c     |  2 +-
 multipathd/main.c        |  7 +++++--
 tests/alias.c            | 10 +++++-----
 6 files changed, 51 insertions(+), 28 deletions(-)

diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index 10e58a7..c4eb5d8 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -408,13 +408,18 @@ static bool alias_already_taken(const char *alias, const char *map_wwid)
 {
 
 	char wwid[WWID_SIZE];
+	int rc = dm_get_wwid(alias, wwid, sizeof(wwid));
 
-	/* If the map doesn't exist, it's fine */
-	if (dm_get_wwid(alias, wwid, sizeof(wwid)) != 0)
+	/*
+	 * If the map doesn't exist, it's fine.
+	 * In the generic error case, assume that the device is not
+	 * taken, and try to proceed.
+	 */
+	if (rc == DMP_NOT_FOUND || rc == DMP_ERR)
 		return false;
 
 	/* If both the name and the wwid match, it's fine.*/
-	if (strncmp(map_wwid, wwid, sizeof(wwid)) == 0)
+	if (rc == DMP_OK && strncmp(map_wwid, wwid, sizeof(wwid)) == 0)
 		return false;
 
 	condlog(3, "%s: alias '%s' already taken, reselecting alias",
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 666d4e8..2fdaca8 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -845,18 +845,21 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
 
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
+		} else if (rc == DMP_OK) {
+			condlog(1, "%s: map \"%s\" already present with WWID \"%s\", skipping\n"
+				   "please check alias settings in config and bindings file",
+				mpp->wwid, mpp->alias, wwid);
+			mpp->action = ACT_REJECT;
+		} else if (rc == DMP_NO_MATCH) {
+			condlog(1, "%s: alias \"%s\" already taken by a non-multipath map",
+				mpp->wwid, mpp->alias);
+			mpp->action = ACT_REJECT;
 		}
 	}
 
@@ -1320,7 +1323,7 @@ static int _get_refwwid(enum mpath_cmds cmd, const char *dev,
 		break;
 
 	case DEV_DEVMAP:
-		if (((dm_get_wwid(dev, tmpwwid, WWID_SIZE)) == 0)
+		if (((dm_get_wwid(dev, tmpwwid, WWID_SIZE)) == DMP_OK)
 		    && (strlen(tmpwwid)))
 			refwwid = tmpwwid;
 
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 3fca08c..003d834 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -840,19 +840,29 @@ int dm_get_map(const char *name, unsigned long long *size, char **outparams)
 	}
 }
 
+/**
+ * dm_get_wwid(): return WWID for a multipath map
+ * @returns:
+ *    DMP_OK if successful
+ *    DMP_NOT_FOUND if the map doesn't exist
+ *    DMP_NO_MATCH if the map exists but is not a multipath map
+ *    DMP_ERR for other errors
+ * Caller may access uuid if and only if DMP_OK is returned.
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
 	else
-		uuid[0] = '\0';
+		return DMP_NO_MATCH;
 
-	return 0;
+	return DMP_OK;
 }
 
 static int is_mpath_part(const char *part_name, const char *map_name)
@@ -1388,8 +1398,10 @@ struct multipath *dm_get_multipath(const char *name)
 	if (dm_get_map(name, &mpp->size, NULL) != DMP_OK)
 		goto out;
 
-	if (dm_get_wwid(name, mpp->wwid, WWID_SIZE) != 0)
+	if (dm_get_wwid(name, mpp->wwid, WWID_SIZE) != DMP_OK) {
 		condlog(2, "%s: failed to get uuid for %s", __func__, name);
+		mpp->wwid[0] = '\0';
+	}
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
diff --git a/multipathd/main.c b/multipathd/main.c
index 442a154..1e7a6ac 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -726,8 +726,11 @@ add_map_without_path (struct vectors *vecs, const char *alias)
 		condlog(3, "%s: cannot access table", mpp->alias);
 		goto out;
 	}
-	if (!strlen(mpp->wwid))
-		dm_get_wwid(mpp->alias, mpp->wwid, WWID_SIZE);
+	if (!strlen(mpp->wwid) &&
+	    dm_get_wwid(mpp->alias, mpp->wwid, WWID_SIZE) != DMP_OK) {
+		condlog(3, "%s: cannot obtain WWID", mpp->alias);
+		goto out;
+	}
 	if (!strlen(mpp->wwid))
 		condlog(1, "%s: adding map with empty WWID", mpp->alias);
 	conf = get_multipath_config();
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


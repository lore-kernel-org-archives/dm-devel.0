Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E38B189F4F
	for <dm-devel@lists.linux.dev>; Tue,  9 Jul 2024 21:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561231; cv=none; b=dlKLEXz0pfVpGkGxyCuUsqDWjCRTcBOZTASLGfN28c+sHq403l0OGoOsePjBEvDtfGamzkDcWUT8fDxvmc1KHpDyeeob6HD0hnRh74mf1+9rwdBIpN4MA5yLbIiYXOCQFiQH9md0PYWgE4oO3In1aLUORyNIbLRjvyK6oq402oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561231; c=relaxed/simple;
	bh=9yPeYTyaES73Y0zvzexik6rdxaoE8fejNLQVUYBBf6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kUA6rQdiNgeHBLo4/33k2L6oaZf38uGol1X58CWa5lC1DCPWRs6CZ8v0N+FkgAHTgxaTfc8AzFC9izD/HqnGH7PUwJgWeqRqHJ//kaVq/Pkj8Xs9pwfNzjxyXG0Ntr1kIKPibXDHljfTwVrnSTYsY9iyMg56rGnQ90A+h4HmTDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=X76wYZyh; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="X76wYZyh"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-58b966b4166so6855853a12.1
        for <dm-devel@lists.linux.dev>; Tue, 09 Jul 2024 14:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720561228; x=1721166028; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YjplwhGsUUcOcz3UU0OLimLGXczxmpE6ecTou/suFyU=;
        b=X76wYZyh5+FTms3aKWMBPnpf4VdgFXgAnEY5QPn/gKgbqRq9fsrZJako5w7eRgGec4
         AeoXozNd530tQaTQPESj6bzwGSpU9wKPaDzjyZStx4WS+vfUNgt0LWQgy/Nh0PkvTR/f
         WZNhQz7HmCQ9ACUmzHf2OHtgoul2hR3T29EKHfkdF86KuuV4mp7fn9UWkCnfEGnZjGkK
         UTA/H+dd7eXneTVbZAAFrVmnpxskYkpRuJ6DtuXznbAWW/LIdeR3AtuFghC+HejGRsTF
         3Hn8PQ9p5zNiGPx526nqxAzxJOmU05uDtymo/VUnqoVDybx7l1zL+gILXvjBQokRdas2
         rIKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720561228; x=1721166028;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YjplwhGsUUcOcz3UU0OLimLGXczxmpE6ecTou/suFyU=;
        b=o9trLxFoNt15bKRgoyMDtgjJyIBrziRCjXjCtgzMgUR/QK/26KIuski9UJkT+VHty0
         U3/Ds6xDyIdEGpFxFeE49i+xGIe4r1Y1DS88a86UFKIKtM86BqSC2im4X6ia8a/Bm7Xp
         D6pXlBUa1hEUMgIahaAwLMwRTZdYUU/FfttZJv0Jbs2xIgfaIpJDWFQVG376RCfwc3U9
         WH0TF0cnCbxuDTwHbAeXShyMAytcgsWUD8kl1f5Z79dNHLl1ccKoD73rGWyP7emaSWR0
         njtgI677A4lknn3yI2I+U53l/kf69azr1dLZQV4BtbwVVkjlpo1n4C5D2KS+SRhdz0BL
         Johg==
X-Gm-Message-State: AOJu0Yz5eEc9SktPr47rKsxxQNkekwlNGwfw4Z8dljUl+RfoR5gEY868
	kEg+2P0RkZHeQiKsHmgng39mzbFaVWIxlnNkX4GMqAt9sWOlzRmuFSogg/Tu67s=
X-Google-Smtp-Source: AGHT+IHgigBg6T7npMedWT2WqkmUKKeEvlYqwbPd+eoNf5ZugcJiy5Fn915rtiYrtwjy0OplJLkopA==
X-Received: by 2002:aa7:da8b:0:b0:57c:5fcf:b570 with SMTP id 4fb4d7f45d1cf-594bc7ca0fbmr2312649a12.32.1720561227719;
        Tue, 09 Jul 2024 14:40:27 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-594bda310a4sm1469019a12.90.2024.07.09.14.40.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:40:27 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 43/44] libmpathpersist: use libmp_mapinfo() in get_mpvec()
Date: Tue,  9 Jul 2024 23:39:34 +0200
Message-ID: <20240709213935.177028-44-mwilck@suse.com>
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

When obtaining the map name, make sure right away that the map is a multipath
device. This saves an ioctl and slightly simplifies the function.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_persist_int.c | 51 ++++++++++++++---------------
 1 file changed, 24 insertions(+), 27 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 5a5ac3b..a3e7bd8 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -157,10 +157,9 @@ static int get_mpvec(vector curmp, vector pathvec, char *refwwid)
 static int mpath_get_map(vector curmp, vector pathvec, int fd, char **palias,
 			 struct multipath **pmpp)
 {
-	int ret = MPATH_PR_DMMP_ERROR;
+	int rc;
 	struct stat info;
-	int major, minor;
-	char *alias;
+	char alias[WWID_SIZE], uuid[DM_UUID_LEN];
 	struct multipath *mpp;
 
 	if (fstat(fd, &info) != 0){
@@ -172,47 +171,45 @@ static int mpath_get_map(vector curmp, vector pathvec, int fd, char **palias,
 		return MPATH_PR_FILE_ERROR;
 	}
 
-	major = major(info.st_rdev);
-	minor = minor(info.st_rdev);
-	condlog(4, "Device  %d:%d", major, minor);
-
 	/* get alias from major:minor*/
-	alias = dm_mapname(major, minor);
-	if (!alias){
-		condlog(0, "%d:%d failed to get device alias.", major, minor);
+	rc = libmp_mapinfo(DM_MAP_BY_DEV,
+			   (mapid_t) { ._u = { major(info.st_rdev), minor(info.st_rdev) } },
+			   (mapinfo_t) {
+				   .name = alias,
+				   .uuid = uuid,
+				   .tgt_type = TGT_MPATH,
+			   });
+
+	if (rc == DMP_NO_MATCH || !is_mpath_uuid(uuid)) {
+		condlog(3, "%s: not a multipath device.", alias);
+		return MPATH_PR_DMMP_ERROR;
+	} else if (rc != DMP_OK) {
+		condlog(1, "%d:%d failed to get device alias.",
+			major(info.st_rdev), minor(info.st_rdev));
 		return MPATH_PR_DMMP_ERROR;
 	}
 
-	condlog(3, "alias = %s", alias);
-
-	if (dm_is_mpath(alias) != DM_IS_MPATH_YES) {
-		condlog(3, "%s: not a multipath device.", alias);
-		goto out;
-	}
+	condlog(4, "alias = %s", alias);
 
 	/* get info of all paths from the dm device     */
-	if (get_mpvec(curmp, pathvec, alias)){
+	if (get_mpvec(curmp, pathvec, alias)) {
 		condlog(0, "%s: failed to get device info.", alias);
-		goto out;
+		return MPATH_PR_DMMP_ERROR;
 	}
 
 	mpp = find_mp_by_alias(curmp, alias);
 
 	if (!mpp) {
 		condlog(0, "%s: devmap not registered.", alias);
-		goto out;
+		return MPATH_PR_DMMP_ERROR;
 	}
 
-	ret = MPATH_PR_SUCCESS;
 	if (pmpp)
 		*pmpp = mpp;
-	if (palias) {
-		*palias = alias;
-		alias = NULL;
-	}
-out:
-	free(alias);
-	return ret;
+	if (palias && (*palias = strdup(alias)) == NULL)
+		return MPATH_PR_DMMP_ERROR;
+
+	return MPATH_PR_SUCCESS;
 }
 
 int do_mpath_persistent_reserve_in(vector curmp, vector pathvec,
-- 
2.45.2


Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB3E185625
	for <dm-devel@lists.linux.dev>; Tue,  9 Jul 2024 21:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561218; cv=none; b=o8qrPhj+AbYf7KWxVOiHI6as0Jar9xOruO2OxUr2GYD4/8RBhn2TqS+7hOBhsG8QyDkGYUcV8v4KmjAGZtl8Yz/sKcsiL/nRj2HJLHnGwjdy5XN8VGjGlAtIvZFa2iNmtX8k4FmiyCyFoSkU4mQeKjnGSv0uoxFqlCnRI8609o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561218; c=relaxed/simple;
	bh=si6qud0bTtWSzZslCxSMZtEmziiRhODXiAoVjmymvDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o2CMS1PBcptDRjQxsLgLaveA4e1AUHfq5DQuB8zVWTcp/1+fHypPZWAZbUY/1tjp1FbaWdecnaAzUJH7bCyqiDNSNsTYMdpBDrI3aJcSHw9weKs0V49fDI85uerX0WHZQDtu/ng/vjX9pJnQ2sqCbf4ohkmvt4kWY4R7qwGlIds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GerPURh7; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GerPURh7"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-595856e2336so295894a12.1
        for <dm-devel@lists.linux.dev>; Tue, 09 Jul 2024 14:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720561215; x=1721166015; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lV4Z4qTVYZpztp59W1/8szRn+xFAjI3AneEqP36t7aI=;
        b=GerPURh7poC9PElFknVmYp6moFiI7mS5rIS1JiwhhNjtRw676kQnUEF2LX/wF0JUKy
         cXUPTLEZdOSwWD0+qhhHoEfQDAgwMCylAfsKedGL4jwqqKI7PpYUox07MVzeoS0m2O65
         6c16nKVNpY/IYkIt6zAQ6lmvuNG2OihOSz7KYyLmsnDm64vefUdm1vi+57EJ607XVpCq
         YPKOMdngXg21B8ztWbux/lrs7FcX9FY7xnPtJhV2b+D2FjZf/geXcjJVMXLm6bmwm5nP
         VA1Qqq5ooKUngBrbd+JWsJW0QaaIRUrameHigO/TCo4hVaE0tT2sAvUxAZeti8srCdks
         YO8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720561215; x=1721166015;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lV4Z4qTVYZpztp59W1/8szRn+xFAjI3AneEqP36t7aI=;
        b=in0MZbo6DvzF8j7Ohga0SnYOtCquCKBiHwvYYRzK4ebEqMi/i86CuyxP2xrloOcocS
         4d1Rp9wmq4OLevuAJuckaidatSiFJrJguTtsMNuOKgrl2ZRvIiaqnq9JQgtoF6dsuAIC
         gkbijX1i1uCEfYACi3Vev4WDpNvPDwiI0GbY1C8vbKD51aS0jdLJjoTTHena2N/uJ4DM
         Sfwll+BjRb1M+O//9jiPGGPsp4sIkjBSmADg3nY//Qm6OZdzkSGVe1QaP0LmPZEZ1uSo
         JvG424FGDjHOdwqAyN9HqDX2iGuS38hYvzMVEhfycAu/+XxSjTnAql/PQu01kdkbJN38
         YP8g==
X-Gm-Message-State: AOJu0YxMcOP6K663lmvDAAAsulk82NBKu3LbX3kY4gVM41dUIzIfHpdo
	UuMYjz85ULJ9AJ9owSvuu/R7yw8wh8MAHe9tgUHp6Ryi6JmhqjaQn/Wfx8D8Ol0=
X-Google-Smtp-Source: AGHT+IH0AvKrjFYXJOtxxwonBbYtEDuUqT2DW0ZEfURrdycSDnw4DplZKjhTd6C5comoKkr3YqV2tA==
X-Received: by 2002:a05:6402:502:b0:57d:3df:ba2d with SMTP id 4fb4d7f45d1cf-594dc4ae5d2mr2562184a12.2.1720561214634;
        Tue, 09 Jul 2024 14:40:14 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-594bc7c9e78sm1485660a12.57.2024.07.09.14.40.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:40:14 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 28/44] libmultipath: implement dm_is_mpath() with new API
Date: Tue,  9 Jul 2024 23:39:19 +0200
Message-ID: <20240709213935.177028-29-mwilck@suse.com>
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
 libmultipath/devmapper.c | 53 ++++++----------------------------------
 1 file changed, 8 insertions(+), 45 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 859a861..6276041 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -965,52 +965,15 @@ static int dm_type_match(const char *name, char *type)
 
 int dm_is_mpath(const char *name)
 {
-	int r = DM_IS_MPATH_ERR;
-	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
-	struct dm_info info;
-	uint64_t start, length;
-	char *target_type = NULL;
-	char *params;
-	const char *uuid;
+	char uuid[DM_UUID_LEN];
+	int rc = libmp_mapinfo(DM_MAP_BY_NAME,
+			       (mapid_t) { .str = name },
+			       (mapinfo_t) { .uuid = uuid, .tgt_type = TGT_MPATH });
 
-	if (!(dmt = libmp_dm_task_create(DM_DEVICE_TABLE)))
-		goto out;
-
-	if (!dm_task_set_name(dmt, name))
-		goto out;
-
-	if (!libmp_dm_task_run(dmt)) {
-		dm_log_error(3, DM_DEVICE_TABLE, dmt);
-		goto out;
-	}
-
-	if (!dm_task_get_info(dmt, &info))
-		goto out;
-
-	r = DM_IS_MPATH_NO;
-
-	if (!info.exists)
-		goto out;
-
-	uuid = dm_task_get_uuid(dmt);
-
-	if (!uuid || strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN) != 0)
-		goto out;
-
-	/* Fetch 1st target */
-	if (dm_get_next_target(dmt, NULL, &start, &length, &target_type,
-			       &params) != NULL)
-		/* multiple targets */
-		goto out;
-
-	if (!target_type || strcmp(target_type, TGT_MPATH) != 0)
-		goto out;
-
-	r = DM_IS_MPATH_YES;
-out:
-	if (r < 0)
-		condlog(3, "%s: dm command failed in %s: %s", name, __func__, strerror(errno));
-	return r;
+	if (rc != DMP_OK || strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN))
+		return DM_IS_MPATH_NO;
+	else
+		return DM_IS_MPATH_YES;
 }
 
 int dm_map_present_by_wwid(const char *wwid)
-- 
2.45.2


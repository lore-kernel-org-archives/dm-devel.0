Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6EE18784E
	for <dm-devel@lists.linux.dev>; Tue,  9 Jul 2024 21:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561228; cv=none; b=T8CczOiibPBf8P/yZqGGlSmb0KJcP4uU54GHcHK/WaJddNurTOt8aetoMu4cvIGhXkqIkFdt8S8kjZOWxPH2p5CVisTkebWQxlVHfeH+9dccYeNqZykrcYcTiO8XvO6EWt5d6z3wgjgiE2EPBJepYcwjZ6rlxMyjNxcnWwD/nnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561228; c=relaxed/simple;
	bh=gJM19D/gbSuAv2vACOFJZTNNjFUbxhbhkXHCNMcC6cI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V2btjUN3CHL//7FMNsafhMSZLJXaydooJPVdTFR3UjOh/Wz9U2vPi6WtFmaK4Idzrqns3BLjqtHTdaGxq5ayYX6utUztz40EHgfe/8bNqntkLOv8cbHi4NYFG2OiaiLyTrmHsouiBajlALQjzIYtX4H6sQrp5onFZhfwA8Gy0lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KWyJH3vF; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KWyJH3vF"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-58b0dddab63so8509554a12.3
        for <dm-devel@lists.linux.dev>; Tue, 09 Jul 2024 14:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720561224; x=1721166024; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hSrUArh8y3ySJGuRIWUGDizUATKxu3tyCHQw+iYkXdI=;
        b=KWyJH3vF9/4j0cb+fKgRRIRaLGEqTjHV4ZFjicmYHCXemh7P2f//mItv5C7dCuLcnb
         RLkyqvWQSGk+2kaXwzyuVuAipadIIrgrZkMWuxlRoPHL6zV0tYkATgz8gGNunAJCkDWk
         V7CoSozXdANQigK8/yJWt4pYGoqAQudTiaRqLPVHN/wnvcbYZZOuB28AheTHwV3AgURB
         r/h6a8bo5OaEUUY60tTImyna5M9nx4kFOuHv9jth4h+2NbB/u8+g9ccrjdGG+oAAUorD
         cTYeL+cONusRImpE4tSz1BfzNcMakSAVaVvx4Dw0xPsh79pytzKKmIbYcDrfaSW6/0Rm
         ocAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720561224; x=1721166024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hSrUArh8y3ySJGuRIWUGDizUATKxu3tyCHQw+iYkXdI=;
        b=ZAV5MLnFOyuIE8g2li3RnaqScTIyuFZvGugTg9Xkicb50dlVMiLSKIuX4K7lvHoyKs
         P4kDeqzlDLKeQnuFpQGcquvOfgRFCNdtAz3IPRJDF17FHH50U9A4wLNMZ4TIFdx9oi61
         OKJxJkcp+Jgh4lLwzCw/pbAS5c1fD+97qhUKc8mA0uXxZgp7B+hkngP0CooheAxTfrjl
         UdkJCmE4qq8+wHPHg7d+jIYPu3iOUdI93y7kZrZQjL9zcQitwDkFodDrUMxifiN7JZ8y
         VvYioN5+UJolm1adpGPonwkRjuO88LxRsL6UQxVtRZNk/I26aX+xpnKfm+OnhKFwQUr0
         POLg==
X-Gm-Message-State: AOJu0Yz5rdqLdb2JifZbqr2/p4B5PHRI8WyPyGVFMhGcPa0wbCHqWYiy
	OrkVK8S+5+mECxZ8M8D8dz+NusEp5qCNwxLhw9HpLKP4qcsVyz09QGqpfKpCANP6sPEDX+wnT6R
	J
X-Google-Smtp-Source: AGHT+IFfohKZPaESoDba7crIhpDFQfmZFRqulgaU3/oKobK1aImg0Pv53OlR4XQy+vF3H9QSD9MDEA==
X-Received: by 2002:a17:907:d93:b0:a77:b3c4:cd28 with SMTP id a640c23a62f3a-a780b68a287mr339528966b.9.1720561224339;
        Tue, 09 Jul 2024 14:40:24 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a7ff052sm108499466b.105.2024.07.09.14.40.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:40:24 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 39/44] multipath: implement check_usable_paths() with libmp_pathinfo()
Date: Tue,  9 Jul 2024 23:39:30 +0200
Message-ID: <20240709213935.177028-40-mwilck@suse.com>
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

... and use cleanup attributes. We need to call the disassemble...()
functions from multipath directly now, but we fetch exactly the data
we need from the kernel.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/main.c | 58 ++++++++++++++++++++++++++----------------------
 1 file changed, 31 insertions(+), 27 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index c82bc86..b3b6c81 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -222,12 +222,14 @@ get_dm_mpvec (enum mpath_cmds cmd, vector curmp, vector pathvec, char * refwwid)
 static int check_usable_paths(struct config *conf,
 			      const char *devpath, enum devtypes dev_type)
 {
-	struct udev_device *ud = NULL;
-	struct multipath *mpp = NULL;
+	struct udev_device __attribute__((cleanup(cleanup_udev_device))) *ud = NULL;
+	struct multipath __attribute__((cleanup(cleanup_multipath_and_paths))) *mpp = NULL;
 	struct pathgroup *pg;
 	struct path *pp;
-	char *mapname;
-	vector pathvec = NULL;
+	char __attribute__((cleanup(cleanup_charp))) *params = NULL;
+	char __attribute__((cleanup(cleanup_charp))) *status = NULL;
+	vector __attribute((cleanup(cleanup_vector))) pathvec = NULL;
+	char uuid[DM_UUID_LEN];
 	dev_t devt;
 	int r = 1, i, j;
 
@@ -238,31 +240,39 @@ static int check_usable_paths(struct config *conf,
 	devt = udev_device_get_devnum(ud);
 	if (!dm_is_dm_major(major(devt))) {
 		condlog(1, "%s is not a dm device", devpath);
-		goto out;
+		return r;
 	}
 
-	mapname = dm_mapname(major(devt), minor(devt));
-	if (mapname == NULL) {
-		condlog(1, "dm device not found: %s", devpath);
-		goto out;
-	}
-
-	if (dm_is_mpath(mapname) != DM_IS_MPATH_YES) {
-		condlog(1, "%s is not a multipath map", devpath);
-		goto free;
-	}
+	mpp = alloc_multipath();
+	if (!mpp)
+		return r;
+	if (!(mpp->alias = malloc(WWID_SIZE)))
+		return r;
 
 	/* pathvec is needed for disassemble_map */
 	pathvec = vector_alloc();
 	if (pathvec == NULL)
-		goto free;
+		return r;
 
-	mpp = dm_get_multipath(mapname);
-	if (mpp == NULL)
-		goto free;
+	if (libmp_mapinfo(DM_MAP_BY_DEV,
+			  (mapid_t) { ._u = { major(devt), minor(devt) } },
+			  (mapinfo_t) {
+			      .name = mpp->alias,
+			      .uuid = uuid,
+			      .dmi = &mpp->dmi,
+			      .tgt_type = TGT_MPATH,
+			      .target = &params,
+			      .status = &status,
+		      }) != DMP_OK)
+		return r;
 
-	if (update_multipath_table(mpp, pathvec, 0) != DMP_OK)
-		    goto free;
+	if (!is_mpath_uuid(uuid))
+		return r;
+
+	strlcpy(mpp->wwid, uuid + UUID_PREFIX_LEN, sizeof(mpp->wwid));
+
+	if (update_multipath_table__(mpp, pathvec, 0, params, status) != DMP_OK)
+		return r;
 
 	vector_foreach_slot (mpp->pg, pg, i) {
 		vector_foreach_slot (pg->paths, pp, j) {
@@ -284,12 +294,6 @@ static int check_usable_paths(struct config *conf,
 found:
 	condlog(r == 0 ? 3 : 2, "%s:%s usable paths found",
 		devpath, r == 0 ? "" : " no");
-free:
-	free(mapname);
-	free_multipath(mpp, FREE_PATHS);
-	vector_free(pathvec);
-out:
-	udev_device_unref(ud);
 	return r;
 }
 
-- 
2.45.2


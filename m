Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2685A176240
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804579; cv=none; b=l7cu2obx7PrBfDnikqiYVhXNzwIF7S+10RkKqpBfs0Al1/4O2X6gn9guxGPHvQj632MBEarJlXjPWAW+iDMLPr/thaItCT8WLLm6wXWoFJMafTcKVuo6xrRVLrgwX1phGcYf8/20HQV7wPPSL6tXuXHxOVmpX54Db5JPHxiUUj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804579; c=relaxed/simple;
	bh=hma3/4Dy7UQTOuiP+1h8onTKqDe18yTEJMCV/y2zkcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/Qvg/mfYPk0vvDTWwebQ/+PN2C30sqApZ+ykmON57NjODPo6MsQvtOjgPmEUSDXNljXPcqneqeYpr7JKzxpCsvJoXwTU8Ytuu1ZGyTPyEMAWNamMB6rByAMWO2hDtQ5FvICCvsNlKiZ4pnlmK4W7BL8kqiqsRWuzpjdhH3bVyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QTaCNgWP; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QTaCNgWP"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2eeb2d60efbso26565251fa.1
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804575; x=1721409375; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bsuNKbvHcKi2RQYjrHttssRResADhWilo+piqecnAFE=;
        b=QTaCNgWPCNGFPlf9JHFpyYtnk7CrPVPG41L+coAR0yWjp0inLnBaFjWZsaL+QebY5N
         hM+AXeeZQDPwuThnr98jffb/ijsuk67lMeot89Sqbk1jXLBKux8dAQlR+hdumoAwPrQG
         MYZv+vgRf7uDQQrihBOPypSpjwWKw7aCVYEba2t+I7Ri4vlP/kF+ptaDDtEQiCa53zn7
         /uLOlRHxz00JvvB44szZILePNnrO1KMBzCfijYaxYuNXzvX3r6oxC9hwPyY/w3nSDo2X
         q0V4E4Z7CVCYhYu4CkU4GuhEudoQLrjZeZY60D6iuxLvYH71rJUhAgxe09EqWZ3bPky4
         D8qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804575; x=1721409375;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bsuNKbvHcKi2RQYjrHttssRResADhWilo+piqecnAFE=;
        b=qILpcdzHDBiwVHF/M8Fw0n8bRxpdZYk367Q7kT4or2bIyE+/otv3WWT3rkAgZhV69J
         mu/YQnJxc2vZcEr9YWTTmQ/ohME9CpkZxv1eYTNHnQDLMNl+bXEeEuBfeYZV7cHY5aD2
         RmZyTEdJVrdITAW+0wmgUDkyS7Cib9xUCgeAyqgQkgAZNO1HgO3jOemSbNTXYqtfJ7S/
         8Iduyp3qX2G4Dj62NW1cN3z+OeQxgdpbP4bftR1Kj8uzmaOmax9JaguXlKhxGOUpqVtv
         +KjaMh/utrUWyFxDg+6reWdv/Ss8E0H6eogwAv5Da3HnbHf1QPpaqsdrbODzhWO3X9JJ
         hkNg==
X-Gm-Message-State: AOJu0YyaQ9LIIgHzHh7eJDJQF6SbWcQhvHNSscEDoDPnSdYoL46m/bX7
	CKy+veMtNuZUbdAFG/8ajJvJ4J7Rf40wT6ginrX7XH5GKOzAUJIeCI/sbRHc7fk=
X-Google-Smtp-Source: AGHT+IHgFjfL3pvPdLpzBeOETNV8gEqr5LyDn1DuZnawZJFN2JhEzFz3fmr1ElQKaal5U0DNYu+odg==
X-Received: by 2002:a2e:9dd3:0:b0:2ec:51b5:27c8 with SMTP id 38308e7fff4ca-2eeb3171537mr82069961fa.32.1720804574217;
        Fri, 12 Jul 2024 10:16:14 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-594bb96062bsm4778225a12.12.2024.07.12.10.16.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:16:14 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 41/49] multipath: implement check_usable_paths() with libmp_pathinfo()
Date: Fri, 12 Jul 2024 19:14:49 +0200
Message-ID: <20240712171458.77611-42-mwilck@suse.com>
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

... and use cleanup attributes. We need to call the disassemble...()
functions from multipath directly now, but we fetch exactly the data
we need from the kernel.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/main.c | 58 ++++++++++++++++++++++++++----------------------
 1 file changed, 31 insertions(+), 27 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index c82bc86..0d989dc 100644
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
+	if (libmp_mapinfo(DM_MAP_BY_DEVT | MAPINFO_MPATH_ONLY,
+			  (mapid_t) { .devt = devt },
+			  (mapinfo_t) {
+			      .name = mpp->alias,
+			      .uuid = uuid,
+			      .dmi = &mpp->dmi,
+			      .size = &mpp->size,
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


Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D938E17836D
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804581; cv=none; b=hqGWy4xBuvbS+yUEA9LlM9q2Wtt1S/EssaAEWKNTMOsREZccRy/DU+G0Cg7zwEG9u9IwlnIgL6CMjh7NeqcJM4GQ6Bjt2EUoPAz/EMtHwkDwk4dGHsFUNgpDaw0af/WZZ78xUMDCZqSgRtQ0gCXV3GNvdDnCmuWIfkcJrvEJtfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804581; c=relaxed/simple;
	bh=f2JTr815TCS6+nJIBCP4hYuee6KXnXSt/5jF41M5RHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K1KoE1+9bIxqXJQZO4HcLo3kkFT3cWYUHWDuBSWLzpuS1R5Ucaooty1fZCvtxcvc6bXozLm2f/dH1bl5Ki6G/CQPQL73nZ1sliHWTH8grmw04/jKfGQegJ14LcTB8fyJoKNz/UboQjlWV6aHddD+sgcCxGZRyhxbYUrgfPJyLHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KQJpKLRt; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KQJpKLRt"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a77c7d3e8bcso306383566b.1
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804578; x=1721409378; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7+TvFQr5nyA4cZeO4x8JTdlMHR3KS2yjqm6y50qNAuI=;
        b=KQJpKLRtjjxj8O9aYv7j4lft+aVTZkJuT481sjCpJtXbw5XvfYnAo5B1qNobq5Pc1z
         LOV+Rufx0xzmO2HInRz2Wpa1JZmg5LE11J2ln2jF+A5dXuTXkH8OzTnCqe7Em4TTPmk9
         W1BZTWz0681NcOqPHDqr2nK+IyfG3nk0fNLeja4DT9GnmmJNWh6AJUwsweCmQhrDsK26
         +RSsyCEUlBETYoTUA2+eoYSsAvPrDEmJ3yii3pImaAmN6ir/IJiA08YZfmFYwHDoWhNq
         NSoRLW5oU/2xFovVe7ksUfcS1Pudqo5dirLY9YPYO74tPSTKdp2+H0fvYI/zaWgmQp0B
         6S5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804578; x=1721409378;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7+TvFQr5nyA4cZeO4x8JTdlMHR3KS2yjqm6y50qNAuI=;
        b=n6PheZjpd5KlkLPR/4NawY8eBWgCc6w6YXT1ZJh8uxiQ6bRN7TcgY7RPRFx1DzbxXE
         +XqhQCYoxUxFLsYAP1umTrfZTjQTgLn7avCPJG3chWWWEiAAm+e9JxxeiqlQ7Qqj162U
         ck/rB6xCM1wxcC/B7D0//9RgTywwlZSRoZeS7kohNqk0RQGfGAbKSf2Ggd/XjubCr2HS
         U0G6vm2zOY1tr+vIk/DE4tswRh0OKsL015fPjRpHeg0bi4jq9oThGMGt6neDD5Rynibj
         B8/Prbecn8a0d4i/iP1NPxG2fnuYU8w3XSeHeC1fHrDxihltZ7K3pV8wn5v3ahnFUF+y
         x3ng==
X-Gm-Message-State: AOJu0YyIuFof6rT9ckfi7hi4HjB2DSxwd2kXKWEMdvD0arowAQNHeLwJ
	mzIQsnYCLNKB1zjrYivx2zTU90Bsh8CcOVsrr4qra5k9ROAzadTVRALF1h10n/R/Y6RMm7dGtYu
	N
X-Google-Smtp-Source: AGHT+IGad0Mmu9h3vfSb4X0hI82sm+KUmekR6rb7qAB8E3qxYBqp/J4szx0maaVFaonufaBQAeEN/w==
X-Received: by 2002:a17:907:e9f:b0:a77:cb7d:f362 with SMTP id a640c23a62f3a-a780b705276mr1039038166b.40.1720804578188;
        Fri, 12 Jul 2024 10:16:18 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a7ff7e0sm365232866b.98.2024.07.12.10.16.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:16:18 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 44/49] libmpathpersist: use libmp_mapinfo() in mpath_get_map()
Date: Fri, 12 Jul 2024 19:14:52 +0200
Message-ID: <20240712171458.77611-45-mwilck@suse.com>
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

When obtaining the map name, make sure right away that the map is a multipath
device. This saves an ioctl and slightly simplifies the function.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_persist_int.c | 50 +++++++++++++----------------
 1 file changed, 23 insertions(+), 27 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 5a5ac3b..a3eb80a 100644
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
@@ -172,47 +171,44 @@ static int mpath_get_map(vector curmp, vector pathvec, int fd, char **palias,
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
+	rc = libmp_mapinfo(DM_MAP_BY_DEVT | MAPINFO_MPATH_ONLY,
+			   (mapid_t) { .devt = info.st_rdev },
+			   (mapinfo_t) {
+				   .name = alias,
+				   .uuid = uuid,
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


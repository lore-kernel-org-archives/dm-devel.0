Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFFB30F95D
	for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 21:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766006498; cv=none; b=S5NXJdLZBIOMZSeIpK8romeR9BZXznu3a/0v5QGRv0/8y6l/ClNebiMRZVuLpA/4HBWDuSmUou/GzOQI1Eea3YPOYlwzYhvXUosRaGXyzvVfzvRvljEey8CShtWRRTk1o5WSScHAbh+ixNeZ9UR3P02WILg876LNv0w60Tzlxqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766006498; c=relaxed/simple;
	bh=k11BgGkp1mInbho0Fojgh8pIDf84rbezlmZpTOrs9kE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TuRvO3amOpGO5rs5Tp0WwyrQYUXJTBbgKmsCNn+b9DZ+NC/NYwq+TXcJ+MGFc99nvzTte+S76utmBm8XJA39FejKJ+v+6NZ2zsXh9JG/1kCH484bnME6NkrZhz0CdAQbh8O6urXFbXsNp794TPMFc09S0mmd/ou1EXZTh+3UtgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TkxsvrCg; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TkxsvrCg"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-63c489f1e6cso2281992a12.1
        for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 13:21:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766006494; x=1766611294; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+kd1DzfwkMmpB1Qyu2tXWA83LTDqlaYjO2LsLpcpLRE=;
        b=TkxsvrCgsx06awe25lOxc7vLAG9AyK1SnesSRT0bM5O3sdc79vkkccL8tcu8GzWr6h
         CTa1DH1shb9KkkRTvxHw6XYC2L7SMWEj8+Nkm94D7wn09CD2akOikTA4mux226oklvVm
         KslMk7o01OMxAMTKKVAA3t0S0eNlDtj1vhzuekWhShKRRCF5uHkbNyen0wGE5C3S09cI
         Z4TvfSw9EHetshMGHrSc0iyNUtSIreAiM4M+8+bmsf5kakO+VLSVYtfdKFYRYwOS/3v5
         7R5PwkpfGpUMi8gciwDMGlb93I1xSYhgaObutIW7aWTq5gRw/XCBegMqB1j6FFIiDxMr
         T2Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766006494; x=1766611294;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+kd1DzfwkMmpB1Qyu2tXWA83LTDqlaYjO2LsLpcpLRE=;
        b=Yjxt8qqOlS9xLYouB3i+A+njOffMuwrKFn67nYcVug43znUP5XJKGCedxUV/1G4dO7
         2sQcGXfcAzAYGwYA8zZYYlm6I4Q79N5QObGMZ3aPN/4GO9M5fFk6xl1OHjLiuWr4NDsY
         DpGNEPHjcsPqucdlYrXjEpHYzP4a9SlCMgaNEozUVkRw9VJH0JrGG5dYrMbPVpC3obve
         NDthwKJICgZsZxd6Zrwxn5rDlxZTmKTuZXxUTF64VNxsDmJwLIfvH/nqdRWiGSM0hpSP
         RTgUcdk1SvlviyJn+yneMUWHvffJOs+/kAZdhO9vRlsDIhglHwSSJt9yncnJPdpiS11j
         WjKg==
X-Gm-Message-State: AOJu0YxjNvIvoZgAnR0mtqWBAUmwyISqCFNUkSkUGaP8rjwjzBQEY3Tf
	JBh07quDaw3DF3cS0uE4go6lQ9JM8Vi9x70zTFlV4MN6F8WpktkFpvcOMtNwZVdWjRk=
X-Gm-Gg: AY/fxX4wwLyOj48ZTU+nyhl8ls1NLvbb1PXvgZuWjBEf68bRAvHF5vTKCt6dMZdWh6X
	U3jKom9ZifwIr87a4wzse9Il4yn7ADmywEmfRJIfdp9KRDFvwK1LOGceL2CEmv+mYycCzSgtBwb
	Wq66FeElXEM5zXURih2wfrvrmvWXZmtRqwUUv8qXJNkDRsJ4TvVz35iLNrOzadp703kl3N+9fsD
	ZF6ajCFJUcy0rV6gBtnYmlhkjiXvE3qrt3Kj1mYycejLCUubhHzQLE7r1bJ0cfnN5w41wu3uVJL
	RVWE2+2MZ8E9UmNqrfBFblbSCiLd9JgCRU+occqkrvBogN2g9wtt2e+tNSUR+OVUCdZwbn5j/p9
	Pm+1Mf5i8QDPMkOY8EFZS3ObuSYNe7bBA96hHyIkBVuqUyGEOUXxVIbITa2EqYNghliBhccPr1c
	dkR+EupYwSjQDpcIrv7DpDxggAj27LL3VR+N3sdDnz2DXPJoz2TVpm7BSoeOHtyW/nApglZuES+
	VK6/eO1EBHA
X-Google-Smtp-Source: AGHT+IE5y/M//bgtkMYhCl22HS57IrDL7OjGQhUqv9D12zYOlx9EjGzHlsH55pFT+bRIyLl+c0tiLA==
X-Received: by 2002:a05:6402:1bd0:b0:640:92eb:aa24 with SMTP id 4fb4d7f45d1cf-64b584ec823mr535526a12.15.1766006494404;
        Wed, 17 Dec 2025 13:21:34 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-64b5887d4a0sm510507a12.23.2025.12.17.13.21.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 13:21:33 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 12/21] libmultipath: free_multipath: fix FREE_PATHS case
Date: Wed, 17 Dec 2025 22:21:04 +0100
Message-ID: <20251217212113.234959-13-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251217212113.234959-1-mwilck@suse.com>
References: <20251217212113.234959-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

free_multipath was passing FREE_PATHS to both free_pgvec() and
free_pathvec(), which was wrong because a path could be referenced
in both structures. This can't happen any more now, as free_pgvec()
has lost the ability to free paths.

In general, free_multipath can't make any assumptions about whether
a given path is referenced in mpp->paths, mpp->pg, or both. Therefore
look first for paths that are referenced in mpp->pg but not in mpp->paths,
clean them, and finally loop over mpp->paths.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs.c | 44 +++++++++++++++++++++++++++++-------------
 1 file changed, 31 insertions(+), 13 deletions(-)

diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 1ee29f6..29b62e4 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -298,8 +298,12 @@ void free_multipath_attributes(struct multipath *mpp)
 }
 
 void
-free_multipath (struct multipath * mpp, enum free_path_mode free_paths)
+free_multipath (struct multipath *mpp, enum free_path_mode free_paths)
 {
+	struct pathgroup *pgp;
+	struct path *pp;
+	int i, j;
+
 	if (!mpp)
 		return;
 
@@ -310,22 +314,36 @@ free_multipath (struct multipath * mpp, enum free_path_mode free_paths)
 		mpp->alias = NULL;
 	}
 
-	if (free_paths == KEEP_PATHS && mpp->pg) {
-		struct pathgroup *pgp;
-		struct path *pp;
-		int i, j;
-
-		/*
-		 * Make sure paths carry no reference to this mpp any more
-		 */
-		vector_foreach_slot(mpp->pg, pgp, i) {
-			vector_foreach_slot(pgp->paths, pp, j)
-				if (pp->mpp == mpp)
+	/*
+	 * If free_paths == FREE_PATHS, free all paths.
+	 * Otherwise, make sure no references to this mpp remain.
+	 *
+	 * First loop over mpp->pg and clean the paths that might
+	 * be missing in mpp->paths. Then clean the rest
+	 * by looping over mpp->paths.
+	 */
+	vector_foreach_slot(mpp->pg, pgp, i) {
+		vector_foreach_slot(pgp->paths, pp, j) {
+			if (find_slot(mpp->paths, pp) == -1) {
+				if (free_paths == FREE_PATHS)
+					free_path(pp);
+				else
 					pp->mpp = NULL;
+			}
 		}
 	}
 
-	free_pathvec(mpp->paths, free_paths);
+	vector_foreach_slot(mpp->paths, pp, i) {
+		if (free_paths == FREE_PATHS)
+			free_path(pp);
+		else
+			pp->mpp = NULL;
+	}
+
+	/*
+	 * We've freed paths above already, use KEEP_PATHS here
+	 */
+	free_pathvec(mpp->paths, KEEP_PATHS);
 	free_pgvec(mpp->pg);
 	if (mpp->hwe) {
 		vector_free(mpp->hwe);
-- 
2.52.0


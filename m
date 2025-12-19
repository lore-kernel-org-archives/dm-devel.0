Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1293F324700
	for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 14:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766155296; cv=none; b=PJisB+7z5lH9shmg88P8BkJwuwRZ7EOo10rGbBarYJLfmOmXxkQPlVL/13/xF3axbpN4DLci+26t5DIaRaja28GhcqaPUmMI5vrtheEglUvHQcIZcr/3VRxGF8vWc4cTAYkeQhiTs4bdD1vZAfIlOinMCFJdCiwRUEy0Wupb1jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766155296; c=relaxed/simple;
	bh=kqOxJYMusxpC/gxSeefbZuJNwaOgwXhgRcagkFXRJdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dGrz+pkU7bmrUt7GW1MIId3PwY0D4/Os9H3jz8kJ98SI10YtE5qPyVwvIC2Hgdzw4tiyC6wdrz+d5n/iPC2rnm+B/cfMzI7R3aO2sbRCUu76WW728yrJ53/kVUeNtqoGxAfTYXjFHPQ9zCh5ZPPrC1OX48i5mESMOPQKnEAHT8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JA4dZvxN; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JA4dZvxN"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b7cf4a975d2so256518066b.2
        for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 06:41:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766155293; x=1766760093; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/BeP/WxiNfHILCRjycytyknar28sM+2PWjpiNg9bW/A=;
        b=JA4dZvxNOgfV/CdSwk7uDZyzg7Pjy7IBvn9EjlGP6QQ0RMGutMsHvkmP0L40X7ExQb
         mtB0jAVR+tFBHW9xSJDOe31cBS7bhm3uNUvgqvdEMYbb9vL/ouq9NkXNA8z/WJzw5N3m
         Rrr2+VtiUbiGeRSVQt7IulxJYAhZDmhbPVQ/Wvd9BMk4bWgSe0Q4eLArcLyCC/YOG29a
         LpCRvZYFOxKsaKZZ/fb4c/3igRgqPjn/ihK+tuh0ZvVXaEqWyEgSVtwv2EmlbGiJ5Kuf
         oopwC1SKFfH7aaSAABG0zD0ueiyLBOhetd3Du4Gu+SS+UAbVjCuEw77GRN2O+cWlV26u
         rDUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766155293; x=1766760093;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/BeP/WxiNfHILCRjycytyknar28sM+2PWjpiNg9bW/A=;
        b=AxNt/bf/SWFwFtNEaHu9TEqFj9488RLXhw37pbLUz7Ov+xRjJPd3s3UlULdV9SbVmO
         FVJZOF5BK/mnuDHbT/AZmn0itDwFOMy690fptdcE63MRw4Pt9DUvtqPIHR+tX3F51TLr
         uH8e9d4e2pLHoQHU4arirHh/IjLlY7eIRli5ulNSoiEJDGRtK1i8/+NOQdCHj4rFl2KU
         s9BspssQPGnMQT1m+V+wSbNnJ5fqy5DNJaZxvNotB6OCvJ3w1j4cU3LQEW0iXGFHZrVK
         BpEd40jw91fiNbURd4Xo6J3Q5KKEpI+/uPFKUVG4ttL/zcmKL1z+MMUVuyaXF/xbNHCq
         //7A==
X-Gm-Message-State: AOJu0Yx2+pNhTUZZie92AfaIj8y7OX7TK8mDriYqVSLm5FO9TXH4cUYO
	5IJNqm48ildrSW54eFcdBGel2O0CP36qtTlhisrV4ZBSD9pviskHOZzDn2CLeDKVNHEZBwbA7Qi
	d/EEq
X-Gm-Gg: AY/fxX64ZgDfqts+bG8seoazOchXIO/3dQJ31Ybr9A9I9TtQS/32WZV5v+1cC94iNou
	OAVYYFK+TxsldI6wtdhDPucTTpJMpVsCIY93sNbZCyUSykp+85zw8SLypafTKY4PtKNto8mCvsR
	+8otC2sf7m8EdK6zolzDyUlui3MX8MyjIqd+7G+rxZjVW99IjfdX0e+hXNFPLpbeCsP0y1C88eh
	lUGuCgjUvDa/sl+na7TUxHJvNL/hQsYB+Hac1Ac6Wu7szjfaTlJ/a5god54caK4yxmTm+VWCz9Z
	KmGna1675+WSqEbVRSD4cW7IQ1ReZev8rBJAZrjJobLMf1oTJmm6XhN2E5bbME1ipY+jFUFlUdJ
	S4rI5hXWyCtuB3KH4c5PxQgoEg6IZ/erXyNxIsgF8so04nIHxkqeOBRDHMe6J2ICZNpdfGpgdNP
	U0AZhmQx1HRIfHNDjkt4KPAebTG3rSP7GELUxHb/qFyTKSVDQNp3/nq+oJ00BVLr49MBAROuTS1
	w==
X-Google-Smtp-Source: AGHT+IG8FtaIQ0/KiKGess8LIFiO47p6f+KAIqjvTWHsOytqitTwmF6Kpm8i9qa53WHeHQdEZPbflg==
X-Received: by 2002:a17:907:9622:b0:b45:66f6:6a0a with SMTP id a640c23a62f3a-b80371801eemr323513066b.44.1766155293323;
        Fri, 19 Dec 2025 06:41:33 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b8037f0cc52sm242485866b.52.2025.12.19.06.41.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Dec 2025 06:41:33 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 15/26] libmultipath: remove free_paths argument from free_multipath()
Date: Fri, 19 Dec 2025 15:40:57 +0100
Message-ID: <20251219144108.237928-16-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251219144108.237928-1-mwilck@suse.com>
References: <20251219144108.237928-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

free_multipath() is now always called with free_paths == KEEP_PATHS.
Remove the argument and the code for freeing paths.

Suggested-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c   |  2 +-
 libmultipath/structs.c     | 26 +++++---------------------
 libmultipath/structs.h     |  2 +-
 libmultipath/structs_vec.c |  2 +-
 multipath/main.c           |  2 +-
 5 files changed, 9 insertions(+), 25 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 8e632ba..e3870f5 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1279,7 +1279,7 @@ int dm_get_maps(vector mp)
 		switch (dm_get_multipath(names->name, &mpp)) {
 		case DMP_OK:
 			if (!vector_alloc_slot(mp)) {
-				free_multipath(mpp, KEEP_PATHS);
+				free_multipath(mpp);
 				return 1;
 			}
 			vector_set_slot(mp, mpp);
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index ec8779c..9e1734d 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -296,8 +296,7 @@ void free_multipath_attributes(struct multipath *mpp)
 	}
 }
 
-void
-free_multipath (struct multipath * mpp, enum free_path_mode free_paths)
+void free_multipath(struct multipath *mpp)
 {
 	if (!mpp)
 		return;
@@ -309,22 +308,7 @@ free_multipath (struct multipath * mpp, enum free_path_mode free_paths)
 		mpp->alias = NULL;
 	}
 
-	if (!free_paths && mpp->pg) {
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
-					pp->mpp = NULL;
-		}
-	}
-
-	free_pathvec(mpp->paths, free_paths);
+	free_pathvec(mpp->paths, KEEP_PATHS);
 	free_pgvec(mpp->pg);
 	if (mpp->hwe) {
 		vector_free(mpp->hwe);
@@ -337,13 +321,13 @@ free_multipath (struct multipath * mpp, enum free_path_mode free_paths)
 void cleanup_multipath(struct multipath **pmpp)
 {
 	if (*pmpp)
-		free_multipath(*pmpp, KEEP_PATHS);
+		free_multipath(*pmpp);
 }
 
 void cleanup_multipath_and_paths(struct multipath **pmpp)
 {
 	if (*pmpp)
-		free_multipath(*pmpp, FREE_PATHS);
+		free_multipath(*pmpp);
 }
 
 void free_multipathvec(vector mpvec)
@@ -355,7 +339,7 @@ void free_multipathvec(vector mpvec)
 		return;
 
 	vector_foreach_slot (mpvec, mpp, i)
-		free_multipath(mpp, KEEP_PATHS);
+		free_multipath(mpp);
 
 	vector_free(mpvec);
 }
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index b16bd9e..a637af7 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -580,7 +580,7 @@ void free_pathvec (vector vec, enum free_path_mode free_paths);
 void cleanup_pathvec_and_free_paths(vector *vec);
 void free_pathgroup(struct pathgroup *pgp);
 void free_pgvec(vector pgvec);
-void free_multipath (struct multipath *, enum free_path_mode free_paths);
+void free_multipath(struct multipath *mpp);
 void cleanup_multipath(struct multipath **pmpp);
 void cleanup_multipath_and_paths(struct multipath **pmpp);
 void free_multipath_attributes(struct multipath *);
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 8d9c0be..62ee450 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -432,7 +432,7 @@ void remove_map(struct multipath *mpp, vector pathvec)
 	 */
 	orphan_paths(pathvec, mpp, "map removed internally");
 
-	free_multipath(mpp, KEEP_PATHS);
+	free_multipath(mpp);
 }
 
 void
diff --git a/multipath/main.c b/multipath/main.c
index d28628b..5557732 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -1069,7 +1069,7 @@ main (int argc, char *argv[])
 			printf("successfully reset wwids\n");
 		vector_foreach_slot_backwards(curmp, mpp, i) {
 			vector_del_slot(curmp, i);
-			free_multipath(mpp, KEEP_PATHS);
+			free_multipath(mpp);
 		}
 		vector_free(curmp);
 		goto out;
-- 
2.52.0


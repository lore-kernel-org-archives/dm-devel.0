Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75192337BBF
	for <dm-devel@lists.linux.dev>; Wed,  7 Jan 2026 20:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767817139; cv=none; b=vDvx/P/2mlXAwc7i8AXt5ul6shGtxoahN4EA7z9CWQnaRqZAto1moHiFfZGvtE23Qwfhqmael7wySyPK4azgh7bG8XzND21vffQUNgTew8HttJOec6uwrNbPrOtXw/i7Q/6p+6SKARc39vC/Tpe3swLEImIZbhB4V94liGsn7v0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767817139; c=relaxed/simple;
	bh=5Vy+CRCyFYhVTSpgdiWyJ2xkDVuwk3DwKkjKx1Xcibo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UVSOvYfRT3CMpsgiIqheiRY5FpKOwsRfdlWbolJ7tqRseIEWlULQcF4Xn2TI61EjHUFlnAhzLxEK1DVU9Tuz7yznxB8ippDBht4+8BQsIT+cxJWtzBhrS0FRYJmofMPULNTwCatHu1mTGpuTFDEdK7lSbVeURwTBXGqe7PRYV60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=P9KIYg7w; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="P9KIYg7w"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-64d02c01865so3857385a12.1
        for <dm-devel@lists.linux.dev>; Wed, 07 Jan 2026 12:18:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767817133; x=1768421933; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jR8hxa/rxhDlYaDJOAsgWoMNfmKSu64Zdb9nIWeQP/A=;
        b=P9KIYg7wIWK3YJjWO7ayFrodOZeHtOHeWd2U3L11ui/e7rvYEfRA5saxIjll/tUSSc
         gySvGLPgObRx4coQ36v0iNJT+zrVGmoLxkX/eAyhfMhT3EECVPeTf3GYbatNhVCA4CAT
         3WroTCiDG/SHtyDjReIlHi+4IRIq/86jgklYHKcUKGEto72gYQWAKRtWDbM6h/D1bsKR
         Hq5yq7Dx7rJlLxbTJzeJWhKbDVInYH1lzcROVYEIafL1aOF9ZIRF2n5mcTpwBMk6I/9E
         MJj5bcERB057wbh7SGltrYjzX1oILxM5M3CiIp9njy3oFkfsuZWx5uqjUftaaX4D2/nJ
         R+/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767817133; x=1768421933;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jR8hxa/rxhDlYaDJOAsgWoMNfmKSu64Zdb9nIWeQP/A=;
        b=ivh7vrQ9JDCHTz9PoTz4B7JiuJPAa5xyIZ3DQgtePtFO9GSRG7ciVu3NVH11s637ko
         6DCoJJadkibv03bbvfzhcD73TYNHJS5Rqo6luBwwPptqpuw++yE7KMpyE4ql/MNvg7lo
         D2vAVrG+oa4WPyPgp7+K34tkuu3dRi43giT5iV3hm3SFeQNyUwzTp2Vjx2+kH8O6uHMf
         1IxcTn1tMJ+RxAeoy+s57ijFTgSXYFPLUvQ+uO2opc62KEfZUhNgw+SkH8GPpLdhEKpx
         wpF7QCOK8ng6PuVpghx4IqaYSa4ZPcuSxJI2tMnarlw0MD5tRBeglWRwnT8yvVZep702
         AYUA==
X-Gm-Message-State: AOJu0YzwPWpT8ywxoZ8bOCcPFmHZQGox+VdlvedYvr5dkhZ46EI9vZ0z
	HYk5N3aU+YXblOMfq1SUNOMa3usVirKzSazAZnO6d7JT2sX2xK2gIWd4lTUqWdOYoeoo4PgrVV5
	uK8WH
X-Gm-Gg: AY/fxX63xTF2P5pQZb5O+rG3VsLnGx+bipuvKaHsJT7TkUNdPIM5gKqrpXlCcuLG/XI
	gE1Nzry9xt1PewAG72jxpf4eANyYkqymjrXCCMJ8yVswudnmMcoamWuaMhf11NXQybiK8YmgU8x
	wZgIGELMsaNsBIyvZIgewknouT440yIxttvXh4I6ka4VQRHSuGuwqi23CAFPJKPMsthuPFFAkg3
	S4e9njQNuVFNJ9zA34Vg84spAs9Sji0xiNHL3M/lUDi2OlxEaCPjVis0cTTCZb3WivMI67FkbmU
	lX2QTven0zjEsI1etRanDmHVYn61jlj7N2nWh0IeMSBOZHufHZO++cNbeW6CMCi8bOFiYE918tW
	64Ylk/+Y6LZL2hVZrrQIxMh48cI4BEX3ifHB9R2Iq/SF7RjBB3+r0P+Mrbo0+pFLr2/LCuroMdx
	DiAlsdOchpzyHhgo0WvpeKHLGxMFYbcxTkvTyM4Gy7Vrur47BcYPrXXVWsTI6ecibyFHfmHTSvK
	A==
X-Google-Smtp-Source: AGHT+IHmJXfBCuuIvWnUzmCLZ7OdqXXlIYN4zb8SLj4KcOVZE79kYmt51B7sUF8gHlHiosnXP90M7g==
X-Received: by 2002:a17:906:fe05:b0:b75:7b39:847a with SMTP id a640c23a62f3a-b8445216dccmr383969066b.60.1767817132805;
        Wed, 07 Jan 2026 12:18:52 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b844e46ee63sm204979166b.15.2026.01.07.12.18.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jan 2026 12:18:52 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH v3 12/26] libmultipath: remove free_paths argument from free_multipath()
Date: Wed,  7 Jan 2026 21:18:12 +0100
Message-ID: <20260107201826.323977-13-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260107201826.323977-1-mwilck@suse.com>
References: <20260107201826.323977-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

free_multipath() is now always called with free_paths == KEEP_PATHS.
Remove the argument and the code for freeing paths.

We must make sure that if we free a struct mpp, no references remain to
it in any of the paths that are referenced by it. However, this means
that we must always free struct multipath before freeing any paths
that it links to.

orphan_paths() clears possible references in other paths, which
are not referenced from mpp->pg and mpp->paths, which we do mostly
for safety. But orphan_paths() also handles the add_when_online
logic, and must thus be called before free_multipath() in remove_map().

Suggested-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c   |  2 +-
 libmultipath/structs.c     | 37 ++++++++++++++++---------------------
 libmultipath/structs.h     |  2 +-
 libmultipath/structs_vec.c |  6 ++++--
 multipath/main.c           |  2 +-
 5 files changed, 23 insertions(+), 26 deletions(-)

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
index ec8779c..6f2468d 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -296,9 +296,12 @@ void free_multipath_attributes(struct multipath *mpp)
 	}
 }
 
-void
-free_multipath (struct multipath * mpp, enum free_path_mode free_paths)
+void free_multipath(struct multipath *mpp)
 {
+	struct pathgroup *pg;
+	struct path *pp;
+	int i, j;
+
 	if (!mpp)
 		return;
 
@@ -308,23 +311,15 @@ free_multipath (struct multipath * mpp, enum free_path_mode free_paths)
 		free(mpp->alias);
 		mpp->alias = NULL;
 	}
-
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
+	vector_foreach_slot (mpp->pg, pg, i) {
+		vector_foreach_slot (pg->paths, pp, j)
+			if (pp->mpp == mpp)
+				pp->mpp = NULL;
 	}
-
-	free_pathvec(mpp->paths, free_paths);
+	vector_foreach_slot (mpp->paths, pp, i)
+		if (pp->mpp == mpp)
+			pp->mpp = NULL;
+	free_pathvec(mpp->paths, KEEP_PATHS);
 	free_pgvec(mpp->pg);
 	if (mpp->hwe) {
 		vector_free(mpp->hwe);
@@ -337,13 +332,13 @@ free_multipath (struct multipath * mpp, enum free_path_mode free_paths)
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
@@ -355,7 +350,7 @@ void free_multipathvec(vector mpvec)
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
index 814d477..54280a9 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -428,11 +428,13 @@ void remove_map(struct multipath *mpp, vector pathvec)
 	mpp->paths = mpp->pg = NULL;
 
 	/*
-	 * clear references to this map
+	 * clear references to this map.
+	 * This needs to be called before free_multipath(),
+	 * because of the add_when_online logic.
 	 */
 	orphan_paths(pathvec, mpp, "map removed internally");
 
-	free_multipath(mpp, KEEP_PATHS);
+	free_multipath(mpp);
 }
 
 void
diff --git a/multipath/main.c b/multipath/main.c
index 4b8d7dd..e3123e5 100644
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


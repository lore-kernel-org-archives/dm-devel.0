Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610A530F945
	for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 21:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766006497; cv=none; b=E9nlczPot9MeffiggIOWfVDhh8OlAfc7q6ui8iHcZ+AVvMnWwIYKuNw5hF+S0Kzp2TF/H8azOQEo5RU4hvNJkd9iIsKvNaTa4keBEfMkzHcplGcBVx/UZFMxyc9qEhL86l6jGDzPu+f8CDc7miVszv77JnmxBNNtTdwypOsaZkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766006497; c=relaxed/simple;
	bh=ZmuuoiALpERO86eefCm2qlat3NvNqyG8jH1YgTvtZeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=thrhjbC5OV3TD+dP3+MhmRqSrHBiDJNiP7MKOWRl+hwKlbMqQjMf1amU7mEoaqXf6m+itmgytfs3FD4Jr1RIzKLL7Er1iQAJ+MAKAp/azugu0PIJOstgKK1Qij6JE8+AgEYU/5fXj+1M/7S0YaXLFVtJUjTpM8iJ8JAxeIxl4FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Fw8IPuOM; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Fw8IPuOM"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-649820b4b3aso4802536a12.3
        for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 13:21:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766006493; x=1766611293; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3fQoUvjceraUkFfH5MK0jvE38ZbDXECEddZ2sEayAU4=;
        b=Fw8IPuOMNg/bC0JgTKqkcL6fo9K10OQPSI3T8VRMDojK+Tudos/p6qYO8g3qDmg1n0
         DTcPPUDPzD65HtpzNDUZTiQy1BBGLYUI29CKIuYqEICyIjvjOrImqBagtw2fM4yhnANC
         8ScYC/NQrJCof5utgvv1y0/3aizjP/BIPR2sXFMfrJ8fPC1R0HIsTHZhWbPJtqjVPJDm
         P6SWrrafOrmdhAp/fw3ZDIQ/Ozh2IVw/3H0Ou9fXvFaGjlQy5jovYTVU2Yd0GW0BziMu
         RM1rlJwxU833Knu/SJz8b/jm+X/FWMqNriszdcKE1ADMr0+dTX5/lK04aw1C7Amdj8RQ
         YNvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766006493; x=1766611293;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3fQoUvjceraUkFfH5MK0jvE38ZbDXECEddZ2sEayAU4=;
        b=Y5/3whr/TLExkCVvWhudXW34E/wLN+WKNt2kfELNHAmZDY4ekakF3hIWJJmuZ9rW8X
         wLoORAawXUrnZjM9gsZg4/Pw9zRQQg7i+yJZhnrpqVBSvzm4PRpUehMGdGcg/TBU2sLj
         FTGeX+GrufHl1bvwAZgCGBkIKVCgCOymkC2VvoNwQxfM8v1LY1nHqWDQK9/JEbccK+cS
         /tn8UO4CzYyX8N2g/MWwnwCMsjDmATlEj+6uxlhDMzMRsVixIrnynSsC55ZgSQPqrNxI
         LEFD+ENYXD1ppES+JfO3SKsBGQv72P2HSrvSU5BZJTge1t3hCW8se1Vlr9pGPlEj3SGc
         x0XA==
X-Gm-Message-State: AOJu0YytlzBBxdCvVjDQJeSghtFrmM57CjImMqfAiRqLmZd8G2RfxquX
	TYA+4aIqW9b0oEGd+K7XOv5ag1ubF7867x10y39hk8yuggBdhybGmDZV2oARSY9A8bc=
X-Gm-Gg: AY/fxX5R4+xJm5boX1a9jz9tvLFL//zIrcoImgUlbm5v4P4Xv5lvj+ntjYsic/N8+wg
	b1UiOpUWNQ622aPkkkQRQmkgO9FZhsSJtiIfvY5i5YQK/GphIYBray8pMDKup/NE2DsRnuzp9C0
	SNJhJOU3ECwk8h1d2HfmLg9ZIeKUmsFpdZeVPpNeSvrOjQ4V/6YK7R+hPqA6jnHXrCiBInerhxG
	BS+2l2a4bBn/+YDckjqtzis9Y0u9glVxOJXTJgAS7J/vidCLK8xg4MhCUdbwTXAWemAM+7gtUkG
	HlXPohLae/UAHGDWoZ/juDkMmenIsajqRlg3CE6vw/Kud4W0hiSzL0+XXPaBEI6GTzwuwRjhxFF
	Eza+W/bhGnmnRbYmRmIoJtVM+0+34DnBpN1KHLCXJGR4g2bss1QV8pGTgQGXxF2lkKGRV6+5+52
	JGTk8nhs8jE3oNGScMTWUNicM4Pb5N9Yq2LJB6CqUzidF9zH+EoMBKYmWt+PRqOvlouAKMqjfra
	w==
X-Google-Smtp-Source: AGHT+IGlYk/eb+4d9hfAlZ1sALP3oB0r9inO9Os8tQCrZipnh65NKmqwVczN+apvTODt/kEr2b1reQ==
X-Received: by 2002:a17:907:1c0a:b0:b40:b54d:e687 with SMTP id a640c23a62f3a-b7d23ad8ce8mr1853639866b.47.1766006493230;
        Wed, 17 Dec 2025 13:21:33 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b802351a335sm28011266b.66.2025.12.17.13.21.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 13:21:32 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 11/21] libmultipath: remove free_paths argument from free_multipathvec()
Date: Wed, 17 Dec 2025 22:21:03 +0100
Message-ID: <20251217212113.234959-12-mwilck@suse.com>
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

free_multipathvec() is always called with KEEP_PATHS=free_paths.
Remove the argument.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_persist.c | 2 +-
 libmultipath/structs.c          | 4 ++--
 libmultipath/structs.h          | 2 +-
 multipath/main.c                | 6 +++---
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index f5267eb..e786e91 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -76,7 +76,7 @@ static vector pathvec;
 
 static void mpath_persistent_reserve_free_vecs__(vector curmp, vector pathvec)
 {
-	free_multipathvec(curmp, KEEP_PATHS);
+	free_multipathvec(curmp);
 	free_pathvec(pathvec, FREE_PATHS);
 }
 
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 7b5b483..1ee29f6 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -348,7 +348,7 @@ void cleanup_multipath_and_paths(struct multipath **pmpp)
 }
 
 void
-free_multipathvec (vector mpvec, enum free_path_mode free_paths)
+free_multipathvec (vector mpvec)
 {
 	int i;
 	struct multipath * mpp;
@@ -357,7 +357,7 @@ free_multipathvec (vector mpvec, enum free_path_mode free_paths)
 		return;
 
 	vector_foreach_slot (mpvec, mpp, i)
-		free_multipath(mpp, free_paths);
+		free_multipath(mpp, KEEP_PATHS);
 
 	vector_free(mpvec);
 }
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 3a52c01..738bea6 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -583,7 +583,7 @@ void free_multipath (struct multipath *, enum free_path_mode free_paths);
 void cleanup_multipath(struct multipath **pmpp);
 void cleanup_multipath_and_paths(struct multipath **pmpp);
 void free_multipath_attributes (struct multipath *);
-void free_multipathvec (vector mpvec, enum free_path_mode free_paths);
+void free_multipathvec(vector mpvec);
 
 struct adapter_group * alloc_adaptergroup(void);
 struct host_group * alloc_hostgroup(void);
diff --git a/multipath/main.c b/multipath/main.c
index 58db288..4b8d7dd 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -436,7 +436,7 @@ static bool released_to_systemd(void)
 static struct vectors vecs;
 static void cleanup_vecs(void)
 {
-	free_multipathvec(vecs.mpvec, KEEP_PATHS);
+	free_multipathvec(vecs.mpvec);
 	free_pathvec(vecs.pathvec, FREE_PATHS);
 }
 
@@ -580,9 +580,9 @@ out:
 	if (refwwid)
 		free(refwwid);
 
-	free_multipathvec(curmp, KEEP_PATHS);
+	free_multipathvec(curmp);
 	vecs.mpvec = NULL;
-	free_multipathvec(newmp, KEEP_PATHS);
+	free_multipathvec(newmp);
 	free_pathvec(pathvec, FREE_PATHS);
 	vecs.pathvec = NULL;
 
-- 
2.52.0


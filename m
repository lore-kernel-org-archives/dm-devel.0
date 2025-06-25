Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14131FECB0
	for <dm-devel@lists.linux.dev>; Wed, 25 Jun 2025 11:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750850363; cv=none; b=vGj8WjwVdWlEmkDj6KKOs/n0fp6PPrtblegxt7BWU0liSTwCnjGZ1pY5caOqbrD8mCQPi1BbGCNNz+RiuSrblMPW8m0I4gP9x4F40NCEZZTFwxkG0mmbnxMhi2k/EeJ3lO4MX6CfRQxMprxEnZfNFtU5OUHYSNxaxsgrDwH26Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750850363; c=relaxed/simple;
	bh=Yn+Uw3F8Aeu9FJ2zUTBCbf6Watq+POFEVZDSuY2dlLI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Dwgk2/gbAP65wX0Gqjbifu+8mpz0/pH7i6wPqys4UNHl4fqYoVoEvScI4CmBrtC/Rj3IuYT05DFq33M4+HhO4YiHrJUWT/K3l4NAVcI8VaZpcnXd8MFHawV/39MwDDDL9yIAF1HPZmh1GjCHMcbtUYjHM5wDfkmTwL8pxBbILKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=amLWNWWT; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="amLWNWWT"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-45362642f3bso8356665e9.2
        for <dm-devel@lists.linux.dev>; Wed, 25 Jun 2025 04:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750850360; x=1751455160; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MXIv0XettpdAI4jwxWTZQeEL22gyJlgqWQ7Y5JAnB4k=;
        b=amLWNWWTBwEZe7F+9vCzoXb26N4iHumI0fnkXjqoIlVwfI3yMk81lKsJyaBs5CY/8a
         RmLILukJQgNyyX/dinwgyFDT4yjZS07vGMiG+VRE3qlZgKf6j6CDMNcxLq86gFNSNkru
         Yt6ui7C5nrnX6MO1KE3JKMr+44h5ZWN5HrwNGD5w0QN9UdwxGJ10RVzu5GUR1SS0Iw6o
         DpENz0JfB7xItuj+GTydiCr+6qKmdBCBnkHCAuybVYiI2enXJKXdqMwyJIM3X7tij/AK
         RUomut6ltQ1YQRc6OWx4VDXFV3/Sigd5aIKNKdTOka1i4nm/eKCGYjlri1A9G1wa0+Of
         4Rlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750850360; x=1751455160;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MXIv0XettpdAI4jwxWTZQeEL22gyJlgqWQ7Y5JAnB4k=;
        b=KG21lLxRWC6MQmpbsp+YHzY1aEwWELxlDsRuZOEwonhHSfARQiyVtrFxFE8S0TeHnS
         MdggcVmvS1BzOtVok0pfO4AWBXWa3wjz69so6uvCH4wauMHRwCodliWqJ3jIWXL0qatF
         kEmlxaCNFMPdnRg4Hm0pQ9dHmCkbcc2VFrsvHz5GZKuZkEHeqi1L3kohkugmCCA0byk8
         UWxuuxiWCshKvylSayKR43YEuIbGUmJHQvhsqsxKWILvX1p5l+nSDfyGKHf4uOD0nBN2
         foldZ92DB1+FJKVKTuVS74RTPx9rjbQBJzpOxdnxkA8nYuTTlhRwAvNVxKNG6DoO6cUF
         +YMA==
X-Forwarded-Encrypted: i=1; AJvYcCVYLmhgweMgDPjEwubLdlCsUfu7qFHtBfLyCc4HZ1ZxJ3Npdq+R4QfWs9Wv9XJ+VWD4KjlG3TTCug==@lists.linux.dev
X-Gm-Message-State: AOJu0YwvTe7lfOiK/JajbqCIG73uZ96siqmzZU9tJcWQASoL3eh2iVD1
	wmkVxmv4bUDhdQYsPScBfM6qPuVEAmcI11K1AV7VPmv5MipGAB6EbAc=
X-Gm-Gg: ASbGncs5JaEql1K5j8N/Cjykt8P5/GwHOWNw+DWOPnlJjh/mXIfoypCSwWQBfymSkvp
	4etflFx2D3LKoajJiXs632aSrQ5bOfdzBVpCnHgfyu9xAIk3kdvYhKVHTsB8zZHDlKnhONvRnJi
	glaRPVQHMKor/3ufYG7Rw6HjSdtjOggGATkVH5pRM+uDkwfqJwBGUNuiJitc2nEgclZsJM1/dsa
	XZD66vImNJCN59RuXjiYdkOIGeSB2Xg1CuU7Rpy/iXV/e9d/wFhMryLxCQGdE61akFk0ZMVvhSr
	cDRCNl9Xjv3xQuSvjEiA+bJtXhSC4Isw1whbiK+9USf7OrKwgBZs+Quz+De1JpUDdsh4tezSSif
	fpYtlGCaXmiPipzCmeHjRu9Q56tvZEA==
X-Google-Smtp-Source: AGHT+IGHTnF7TVzc/y3RmjC3RGXNZ7iqbbY+2BZ8tb5JuTvXsaT0TSwN0EnOkqSORUarGuSZ8p2X9g==
X-Received: by 2002:a05:600c:c174:b0:451:dee4:cd07 with SMTP id 5b1f17b1804b1-45381a68442mr10584375e9.0.1750850359686;
        Wed, 25 Jun 2025 04:19:19 -0700 (PDT)
Received: from localhost (238.red-80-39-144.dynamicip.rima-tde.net. [80.39.144.238])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-453823c57d7sm17613245e9.40.2025.06.25.04.19.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jun 2025 04:19:19 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: [PATCH] md: dm-ps-*: delete version strings
Date: Wed, 25 Jun 2025 13:19:17 +0200
Message-ID: <20250625111918.219963-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Reminiscent of ancient times, when modules were developed outside the kernel.
Pretty useless nowadays for code included in the official kernel repo, with constant
changes and without updating the version number.

Cc: Alasdair Kergon <agk@redhat.com> (maintainer:DEVICE-MAPPER  (LVM))
Cc: Mike Snitzer <snitzer@kernel.org> (maintainer:DEVICE-MAPPER  (LVM))
Cc: Mikulas Patocka <mpatocka@redhat.com> (maintainer:DEVICE-MAPPER  (LVM))
Cc: DM-DEVEL ML <dm-devel@lists.linux.dev> (open list:DEVICE-MAPPER  (LVM))
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
BTW, MODULE_VERSION should be removed from the entire tree.
___
 drivers/md/dm-ps-historical-service-time.c | 3 +--
 drivers/md/dm-ps-queue-length.c            | 3 +--
 drivers/md/dm-ps-round-robin.c             | 3 +--
 drivers/md/dm-ps-service-time.c            | 3 +--
 4 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-ps-historical-service-time.c b/drivers/md/dm-ps-historical-service-time.c
index b49e10d76d03..fa6198c0276b 100644
--- a/drivers/md/dm-ps-historical-service-time.c
+++ b/drivers/md/dm-ps-historical-service-time.c
@@ -31,7 +31,6 @@
 
 #define DM_MSG_PREFIX	"multipath historical-service-time"
 #define HST_MIN_IO 1
-#define HST_VERSION "0.1.1"
 
 #define HST_FIXED_SHIFT 10  /* 10 bits of decimal precision */
 #define HST_FIXED_MAX (ULLONG_MAX >> HST_FIXED_SHIFT)
@@ -544,7 +543,7 @@ static int __init dm_hst_init(void)
 	if (r < 0)
 		DMERR("register failed %d", r);
 
-	DMINFO("version " HST_VERSION " loaded");
+	DMINFO(" loaded");
 
 	return r;
 }
diff --git a/drivers/md/dm-ps-queue-length.c b/drivers/md/dm-ps-queue-length.c
index e305f05ad1e5..31decbef9837 100644
--- a/drivers/md/dm-ps-queue-length.c
+++ b/drivers/md/dm-ps-queue-length.c
@@ -25,7 +25,6 @@
 
 #define DM_MSG_PREFIX	"multipath queue-length"
 #define QL_MIN_IO	1
-#define QL_VERSION	"0.2.0"
 
 struct selector {
 	struct list_head	valid_paths;
@@ -263,7 +262,7 @@ static int __init dm_ql_init(void)
 	if (r < 0)
 		DMERR("register failed %d", r);
 
-	DMINFO("version " QL_VERSION " loaded");
+	DMINFO(" loaded");
 
 	return r;
 }
diff --git a/drivers/md/dm-ps-round-robin.c b/drivers/md/dm-ps-round-robin.c
index d1745b123dc1..67f7f5ec5428 100644
--- a/drivers/md/dm-ps-round-robin.c
+++ b/drivers/md/dm-ps-round-robin.c
@@ -19,7 +19,6 @@
 
 #define DM_MSG_PREFIX "multipath round-robin"
 #define RR_MIN_IO     1
-#define RR_VERSION    "1.2.0"
 
 /*
  *---------------------------------------------------------------
@@ -223,7 +222,7 @@ static int __init dm_rr_init(void)
 	if (r < 0)
 		DMERR("register failed %d", r);
 
-	DMINFO("version " RR_VERSION " loaded");
+	DMINFO(" loaded");
 
 	return r;
 }
diff --git a/drivers/md/dm-ps-service-time.c b/drivers/md/dm-ps-service-time.c
index 969d31c40272..cbb0ac63bb7a 100644
--- a/drivers/md/dm-ps-service-time.c
+++ b/drivers/md/dm-ps-service-time.c
@@ -20,7 +20,6 @@
 #define ST_MAX_RELATIVE_THROUGHPUT	100
 #define ST_MAX_RELATIVE_THROUGHPUT_SHIFT	7
 #define ST_MAX_INFLIGHT_SIZE	((size_t)-1 >> ST_MAX_RELATIVE_THROUGHPUT_SHIFT)
-#define ST_VERSION	"0.3.0"
 
 struct selector {
 	struct list_head valid_paths;
@@ -344,7 +343,7 @@ static int __init dm_st_init(void)
 	if (r < 0)
 		DMERR("register failed %d", r);
 
-	DMINFO("version " ST_VERSION " loaded");
+	DMINFO(" loaded");
 
 	return r;
 }
-- 
2.50.0


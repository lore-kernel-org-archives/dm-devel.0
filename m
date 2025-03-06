Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACCC20F09C
	for <dm-devel@lists.linux.dev>; Thu,  6 Mar 2025 16:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741279170; cv=none; b=FAYi4578fbnMXBfXGa8741+3Hjyvl2cO/GqfreIbornW+gNfnQV1rlXRe9LFlN329zdcXElE5aAUWwE9CCxi67EOdL5wIHxTn+CB3iMuhqA5id/TE0y5x1qAn9OM96CTuyCDl94GqKBuYNilBnFzLduTgE8CLAWsI9sx4Z9/sig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741279170; c=relaxed/simple;
	bh=hBky8ia+EbqGBvNUNc1IBc6JDa6VNABbAjKAGzTMbDs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iUY4Xf4ysA1Lli1IRGiGBaJTmnxcUVRI2Kddj7m41NRgde8IY+VWRznvzbStZ9ggbw18u9Dh//4rJPW37EsHxOJAnen8DJY+RKj16RPEJYyhf2QfzpPYMc1/s8y36rM6siakcQvtn/VqoOlJf90qrVuTZjG+xtjcY4ifwGwLnhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JZY+iphn; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JZY+iphn"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-43bc21f831bso947365e9.1
        for <dm-devel@lists.linux.dev>; Thu, 06 Mar 2025 08:39:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741279166; x=1741883966; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6k4T/xy2N7Cf9SUSyeW9NXW7sgOV9mizTaarT7o6yU0=;
        b=JZY+iphnjSXTq20Ai8zzJt/v7uS5RgYY/ObOE8DP31fQJQhsJLfJK2hfgzN5tyTnVv
         Ev4R5c3tg/MoQC8PsMErJh5UHkxjjHbW1PGFigvNEcyvWn1v0RwTW/fa2Ek8LdC7Ij9R
         jpX4pWtq9C+MEzg5KsYLcUzwtq5BnmnZmY3Z2roo06BmT76DalxZFOYEh7/zxbfbxMRL
         /SOk5iZ0H1HDZTM6ZE77LJdrKxjHOCce7aln5zCreIpmMB31FL6jqHf5f8Z8fX8JTaU1
         UspLrhATy7lrHMUYdQNQHeZv3f56zXBht7z2RGQ8Vg9R1akDdsD/hDJLt4E6ve2DlJkq
         6h0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741279166; x=1741883966;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6k4T/xy2N7Cf9SUSyeW9NXW7sgOV9mizTaarT7o6yU0=;
        b=VUb3F2ADbIECGcj+rzZfJYCKRTbN3H2d3R9LIkEdJKcGO3bcxEGyzetJgXoiHg1L5m
         Zk2gqz0I02mhfn6Fn+ig+piHIFF+k9dniRG9D7LBJFYmMYSgxAkED4rspJALjll/Icts
         OpjSpQ89Rad8e4tBkkcq7IipuxBugvjBYvOQJH7Ud1U7+Zm1heW6EPMviQ6xzHkgLLJJ
         Wy438u3MLiicZ/OJxy3LBS11vlFd6VPbE3hbsKMmWk98Aj3QyDQ3j4Y+OMQ4hr71Tpfx
         e0M0sH1MymjTTiJDdGVwTpI7GAKnaYxukxEZwX0qXKzeYkE4N35Gh86p7anB0xCFeYBc
         kiYg==
X-Forwarded-Encrypted: i=1; AJvYcCUbPvL5BYALV78nw/xpXX0pqHy+LIJhiF075Tpi7N+Ji4L7p7ZpNNVM0xkSm6X9/U4LdqvKubGXQg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxh+ocAcE6xCxFmxjUbAXHff/MgroSbVmqiBMOKQ3W4k5knYPrI
	BuPxKHREgaet8VlAz7pHtlpzscQ02rHVcyP6EvTcUi22oWRaEw/W2vV/1ztwTQ==
X-Gm-Gg: ASbGncs9WFt7cO9JTltGcN0rJJxwXGlONgiAWbRCr7A1jdSSVrm402B6Cxb8/+6nBZQ
	xwwQbIig49PyRhwsW+cr1WieakYXn5oGtWHMs0sqrPwRVjzgJu4rYHh0azdc0aBknBltOPkawzU
	y5C7zP5PkErc34SB2moV40ul25DioW4GTLAZY5XDgPGV8gzdAqmnjU4bLwaBVE5zyFSHJYf1JeE
	UY8SGjapillGazZd1qhKNv/5mOUVAQ1LVhXMSVf772/hM3/jKC43YeTo8Ix6A0Ht9kjk2Ba2PH/
	FUaX+MRugRrGZE+n+SgTjz4371t0FsDf+06o3YzA2o7QSacjyypQm4F5UFyTMsRnlkf6ZtpCtjr
	WMenYBkC3L2AU
X-Google-Smtp-Source: AGHT+IFUYDLQ20TQZr9QIjsV9p4/Kosoth1xbIs/mLZ8FcdDEdnia+FmN9THxGnv97AShLZEfPleAQ==
X-Received: by 2002:a05:600c:1909:b0:439:9a40:aa1a with SMTP id 5b1f17b1804b1-43c6871c298mr347105e9.6.1741279165955;
        Thu, 06 Mar 2025 08:39:25 -0800 (PST)
Received: from localhost (235.red-80-39-161.dynamicip.rima-tde.net. [80.39.161.235])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bd435c9c7sm53683345e9.38.2025.03.06.08.39.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Mar 2025 08:39:25 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: [PATCH] multipath-tools: delete unreachable maintainers
Date: Thu,  6 Mar 2025 17:39:24 +0100
Message-ID: <20250306163924.459944-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

email bounced:
Shyam Sundar <g.shyamsundar@yahoo.co.in>
PJ Waskiewicz <pj.waskiewicz@netapp.com>
Srinivasan Ramani <srinivas.ramani@oracle.com>
Arnon Yaari <arnony@infinidat.com>

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 543f0bc1..f8cf3fa9 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -97,8 +97,6 @@ static struct hwentry default_hw[] = {
 	},
 	/*
 	 * Apple
-	 *
-	 * Maintainer: Shyam Sundar <g.shyamsundar@yahoo.co.in>
 	 */
 	{
 		/* Xserve RAID */
@@ -827,8 +825,6 @@ static struct hwentry default_hw[] = {
 	{
 		/*
 		 * SolidFir family
-		 *
-		 * Maintainer: PJ Waskiewicz <pj.waskiewicz@netapp.com>
 		 */
 		.vendor        = "SolidFir",
 		.product       = "SSD SAN",
@@ -857,8 +853,6 @@ static struct hwentry default_hw[] = {
 	 */
 		/*
 		 * Pillar Data / Oracle FS
-		 *
-		 * Maintainer: Srinivasan Ramani <srinivas.ramani@oracle.com>
 		 */
 	{
 		/* Axiom */
@@ -1123,8 +1117,6 @@ static struct hwentry default_hw[] = {
 	},
 	/*
 	 * Infinidat
-	 *
-	 * Maintainer: Arnon Yaari <arnony@infinidat.com>
 	 */
 	{
 		/* InfiniBox */
-- 
2.48.1


Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0E92419E2
	for <dm-devel@lists.linux.dev>; Thu, 16 Jan 2025 23:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737068674; cv=none; b=HPtrOhljn8ma2wbZ/Tixr4+klOxrRkT3xjuuoiLTaa+p5jnqj5xvZZ+f/7Lp2RwqoR38CoodLlrlQXu29ZQNkfpe7gWTzn4HK1naRotME1rOBw293v0nzNf6dp/RoMK8aSwaFVoYSobWFHUET/ZX/F9Txo+xLB8eoVNI8GcqP/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737068674; c=relaxed/simple;
	bh=hKjA797WcJv6yR3X7coZ2NHVzaXFvowlmzS4c2PsvXI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HIjjVTx3bJ9cC8m+/QkcgaZbPJRqLvzGGWn8HmIQlmDH1vRN3SMmavmhfIXUMHlzZRCZrbStQOLejvF0MIvVB8pJYcEG98ea3b8A+ALZrNAC42COePiuaOdnjnK2jJOMaaka9Yek3i73BWgDlVOlSkm5DlSmZGA7dCj//CHU6ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gI/D4J/j; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gI/D4J/j"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4361f09be37so1877225e9.1
        for <dm-devel@lists.linux.dev>; Thu, 16 Jan 2025 15:04:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737068671; x=1737673471; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QW0j5Zu2cHpu67hAXUYJ9Odw8QjX7lk5ntuwB5ZGLWg=;
        b=gI/D4J/jmlnA3T9S3Ux1Y+0ANbxVOx7Ysufre2Lzbqsx6XLS/JYjisg1o/3CpDam94
         zoDczXvizEUqjSb1TobPR9jQTx0NcDsCOZB3Hhx47oBq4g+Ms2ErHtQVjPtFPXBB0Piw
         71V1PNKOrfdEqJwbadeJGd+Vjg442kYeRTRM4ZbkfX6flDCsKaze3Gusz3inVdNYXqAg
         Rhf2t9DleXBMg8XgyiWAbRQfgATHRvp65x5eHWNk2Lmmu2VZWEvJVSqC2hTH0e4IoMNb
         xscIy4iWwpG9ML+4QNV8cDXHy8RhMbyvG+6FiEcFncsGhyUmR9/ppfIGEG1KBPb/Ijrw
         kU/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737068671; x=1737673471;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QW0j5Zu2cHpu67hAXUYJ9Odw8QjX7lk5ntuwB5ZGLWg=;
        b=LXf7l2E5YM4ypbHNI5XWIEwDN5nvLnDc2PIX5E9+vkyFHqOvaNAdvjY+Xs4q17kPER
         9ANdmAEaKigIj9+Yas8lu7bHXhVAuImuN3PAWphJZ3E9TiuOBaCFGYfnKUYD6I/NhHqi
         uT14OeteQoiKVVtbglf+wqD8AXlWxogbwzlhfMQF/dV4A9YW2hWDmvFd262FyRDGP0x2
         FOiSohBF+i+TORbslrfQZPbVBo/XGE7DtA37KR0wV7cRvfsBoax3bozLtwQYEwHrpvn9
         coWxob9WnGujSC/S/mpuAWZSwF1uay3i7IhbhDjYuaLEZ3NiMBcYsXsc87XzkIjzX8zW
         c73Q==
X-Forwarded-Encrypted: i=1; AJvYcCWRHWfEteoX89kmWPyN712i1Sd/Jl8mM7A2G7Xr5VkCng9N3HTpMSNpBKuwx2yyaLx4T86gcBlOgQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yyl2p8wwckB8hPX30j9h/VVvczGYVA3wumcjJvm0X0UmYUjjhWX
	wQ+W19V149JfPwFzVUxCX2ewzYrEtP+a+94relHHY+516Qlow34=
X-Gm-Gg: ASbGncvnPvGrF32ppxAvCYXpjMV4DeZsiMl0PFJ5GNr75EO7oyReM+mP6+xw/8S9WjD
	+DkL1c1Q5FJ45zcgHZXnva4r7Jr3MejI6kwdxgjJUrZIMw/Dw5oNBGou1p8e7HqLd73wbiBFyW+
	ZIl62g5QB6j/4lIwEIoydXAn2P0FuSiApozefqNcXQm1IFJzdn6NqyBfB11RYo2weXt6X39rQ6j
	ZP1e5G9Vj5xrO9yTtiY+HW3QBRBMNcvWgqOo0vJtZoOZOalAZFsTw==
X-Google-Smtp-Source: AGHT+IHGyQ8z8icM0C+dKx37GRI7/l5BAPn8MaE1WfMlVK9sWjdmItwjFv1BasSTR5uFEef/+LxTBw==
X-Received: by 2002:a5d:5d11:0:b0:38a:a037:a5fa with SMTP id ffacd0b85a97d-38bf566b46dmr96704f8f.5.1737068670545;
        Thu, 16 Jan 2025 15:04:30 -0800 (PST)
Received: from localhost ([84.39.177.14])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf3221b7fsm951249f8f.27.2025.01.16.15.04.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2025 15:04:29 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: [PATCH] multipath-tools: Merge Infinidat with Lenovo in hwtable
Date: Fri, 17 Jan 2025 00:04:26 +0100
Message-ID: <20250116230427.17740-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Lenovo to acquire Infinidat:
https://www.infinidat.com/en/news/press-releases/lenovo-acquire-infinidat-further-expanding-enterprise-storage-portfolio

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 37 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 543f0bc1..2c26b42a 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -788,6 +788,24 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 30,
 	},
+	{
+		/*
+		 * Infinidat InfiniBox
+		 *
+		 * Maintainer: Arnon Yaari <arnony@infinidat.com>
+		 */
+		.vendor        = "NFINIDAT",
+		.product       = "InfiniBox",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = 30,
+		.prio_name     = PRIO_ALUA,
+		.selector      = "round-robin 0",
+		.rr_weight     = RR_WEIGHT_PRIO,
+		.no_path_retry = NO_PATH_RETRY_FAIL,
+		.minio         = 1,
+		.minio_rq      = 1,
+		.fast_io_fail  = 15,
+	},
 	/*
 	 * NetApp
 	 */
@@ -1121,25 +1139,6 @@ static struct hwentry default_hw[] = {
 		.product       = "XPD",
 		.pgpolicy      = MULTIBUS,
 	},
-	/*
-	 * Infinidat
-	 *
-	 * Maintainer: Arnon Yaari <arnony@infinidat.com>
-	 */
-	{
-		/* InfiniBox */
-		.vendor        = "NFINIDAT",
-		.product       = "InfiniBox",
-		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = 30,
-		.prio_name     = PRIO_ALUA,
-		.selector      = "round-robin 0",
-		.rr_weight     = RR_WEIGHT_PRIO,
-		.no_path_retry = NO_PATH_RETRY_FAIL,
-		.minio         = 1,
-		.minio_rq      = 1,
-		.fast_io_fail  = 15,
-	},
 	/*
 	 * Kaminario
 	 */
-- 
2.48.1


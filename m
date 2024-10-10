Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F422A1D3
	for <dm-devel@lists.linux.dev>; Thu, 10 Oct 2024 16:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728577102; cv=none; b=B03Ou007oQBvMozfIWyG0Y2199r3Rr9vDgJFPF/Gl5D1FzYeoIRAAMJOocypEGbxhNq++ufAycWbioBW6ZP5JXVFPOQANtQ4C4X6Xy95aMCWufB/gu8HKahlj96Ytqd0KqskDyxvRFSKn62T/nz60XueYu6PxrTx9YFFSyPXUOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728577102; c=relaxed/simple;
	bh=/6O9Wj76an5y3+2rWGUnrDNx+xgD2dlind8dW6J1bOg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HYI/gvsy1+hG1nYWjms4GDOrePLUSLG6IsssFfkcH6HAYovRxiCphghZoUK5ZJZkD+3qHXUOo5DyC+PUVAdqXKOlX4F9kvkeClFUvHi/UAm+O5m0EOn2UU8qdUgIOf/ng00iCE6AVVMaJhSi9/3X3YzRkdYnrPk2IXpQja36rCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cGkPCleK; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cGkPCleK"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-43111bdd54cso1730725e9.1
        for <dm-devel@lists.linux.dev>; Thu, 10 Oct 2024 09:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728577099; x=1729181899; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=a+hjqgmaqVks8EgYvRTo9UGRbThd+10iiz7ECf2eUOU=;
        b=cGkPCleKILEVNY82ECzcfkdk5eOzd1/XyT0OTEfFl3Jhv/IG3iPSn4GHBULJ467oGh
         KTBMafTZfgDcEH51i58FwMNoStf5YkrrfACNqj3/H6orUhasyXhu+N10DrmBWPBlAGcD
         cQaZUubArzBEReVEPM+Ycz36ZCAzkWrKXtMfcTIElEpvBfwUgXgSr5I6fwXzwb8LzXdF
         vQa/ft6928+5qvmZ4lbsXWA39S1Oofe7EshdaWNnThoQ7lOBXW2JXeB3yxgX8KDxlaQo
         2SNunM9ERaaPBK91+FfmojqMw2pwUz4LY4XzmRlD4uc6Y7Mt8q16weFUMtseiTyRFfVL
         du6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728577099; x=1729181899;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a+hjqgmaqVks8EgYvRTo9UGRbThd+10iiz7ECf2eUOU=;
        b=wChQvLNqW6jrAex8/eBX2ahsCRbKnMrFA3OKcT9kUha4tiqXcxpJtaN3lQb6cY/Rfq
         eF9fgWztFRbRDwlKmWRBWhffrOpf//qB5sc2SAs/VV/e9l21aOqY8USoLhIQY1KNBLld
         VJ/NxMXblHPoXBXMOsTQiDXbevq0tli8k33I5OVqkdNlAKI3zzO/qoh+STRm/wYfx+3Y
         G3izzKsyKPYlC5TUgi5LDeYP+v3Q/nHU3vY8seuOItDm4GRKHf/HxfFwkppOfn+6QiMs
         au9i2GDz+znubgEyYJOeRH/VLle37fOCJBi7r9Flp1sAWCkQwMFz+x1Klr/zCuIOBBbN
         JrqQ==
X-Forwarded-Encrypted: i=1; AJvYcCVfUe2bgMG/xNpwpcwiw2lHh0oaUhbFjNUz6c4g6tnCVAkXghVG3SSguYXQZv3jpe9lxDzWIF0MZA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxS3tqrgg+q+LzpY2OMfnh/fwRuls5cvcXdVI/ggcVtonCCrU51
	b9z+xUo+5d430xbKWniVIuVEFxTIpRFLHICVQrErgBh8/3wA1Ic=
X-Google-Smtp-Source: AGHT+IFCKMiaSxQseZEL0I06OrtUhIDoXs44kOxD/ByhQvMHccrQ48yLoD5QyfQW22lv1vMd427SqQ==
X-Received: by 2002:a5d:5982:0:b0:37d:50a3:f35e with SMTP id ffacd0b85a97d-37d50a3f7f0mr695420f8f.10.1728577098914;
        Thu, 10 Oct 2024 09:18:18 -0700 (PDT)
Received: from localhost (106.red-88-28-26.dynamicip.rima-tde.net. [88.28.26.106])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d4b6a859fsm1921931f8f.2.2024.10.10.09.18.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2024 09:18:08 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: [PATCH] multipath-tools: remove hwhandler from all hwtable configs
Date: Thu, 10 Oct 2024 18:18:06 +0200
Message-ID: <20241010161806.14950-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Useless, automatically handled by the kernel since 4.3.
(4.3 was released nine years ago)

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 44 ------------------------------------------
 1 file changed, 44 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 74575eb1..cf39a50d 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -115,7 +115,6 @@ static struct hwentry default_hw[] = {
 		.product       = "VV",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
-		.hwhandler     = "1 alua",
 		.prio_name     = PRIO_ALUA,
 		.no_path_retry = 18,
 		.fast_io_fail  = 10,
@@ -134,7 +133,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "DEC",
 		.product       = "HSG80",
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
-		.hwhandler     = "1 hp_sw",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.checker_name  = HP_SW,
 		.prio_name     = PRIO_HP_SW,
@@ -150,7 +148,6 @@ static struct hwentry default_hw[] = {
 		/* MSA 1000/1500 and EVA 3000/5000, with old firmware */
 		.vendor        = "(COMPAQ|HP)",
 		.product       = "(MSA|HSV)1[01]0",
-		.hwhandler     = "1 hp_sw",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.no_path_retry = 12,
 		.checker_name  = HP_SW,
@@ -203,7 +200,6 @@ static struct hwentry default_hw[] = {
 		/* SAN Virtualization Services Platform */
 		.vendor        = "HP",
 		.product       = "(HSVX700|HSVX740)",
-		.hwhandler     = "1 alua",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 12,
@@ -238,7 +234,6 @@ static struct hwentry default_hw[] = {
 		/* Nimble Storage / HPE Alletra 5000/6000 */
 		.vendor        = "Nimble",
 		.product       = "Server",
-		.hwhandler     = "1 alua",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.prio_name     = PRIO_ALUA,
@@ -259,7 +254,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.checker_name  = RDAC,
 		.features      = "2 pg_init_retries 50",
-		.hwhandler     = "1 rdac",
 		.prio_name     = PRIO_RDAC,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 30,
@@ -272,7 +266,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.checker_name  = RDAC,
 		.features      = "2 pg_init_retries 50",
-		.hwhandler     = "1 rdac",
 		.prio_name     = PRIO_RDAC,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 30,
@@ -326,7 +319,6 @@ static struct hwentry default_hw[] = {
 		/* Tegile IntelliFlash */
 		.vendor        = "TEGILE",
 		.product       = "(ZEBI-(FC|ISCSI)|INTELLIFLASH)",
-		.hwhandler     = "1 alua",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.prio_name     = PRIO_ALUA,
@@ -353,7 +345,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "^DGC",
 		.product       = "^(RAID|DISK|VRAID)",
 		.bl_product    = "LUNZ",
-		.hwhandler     = "1 emc",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = (300 / DEFAULT_CHECKINT),
@@ -391,7 +382,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.checker_name  = RDAC,
 		.features      = "2 pg_init_retries 50",
-		.hwhandler     = "1 rdac",
 		.prio_name     = PRIO_RDAC,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 30,
@@ -402,7 +392,6 @@ static struct hwentry default_hw[] = {
 		.product       = "PowerStore",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.prio_name     = PRIO_ALUA,
-		.hwhandler     = "1 alua",
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 3,
 		.fast_io_fail  = 15,
@@ -419,7 +408,6 @@ static struct hwentry default_hw[] = {
 		.product       = "^ME",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.prio_name     = PRIO_ALUA,
-		.hwhandler     = "1 alua",
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 	},
 	/*
@@ -474,7 +462,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.checker_name  = RDAC,
 		.features      = "2 pg_init_retries 50",
-		.hwhandler     = "1 rdac",
 		.prio_name     = PRIO_RDAC,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 30,
@@ -524,7 +511,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.checker_name  = RDAC,
 		.features      = "2 pg_init_retries 50",
-		.hwhandler     = "1 rdac",
 		.prio_name     = PRIO_RDAC,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 30,
@@ -537,7 +523,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.checker_name  = RDAC,
 		.features      = "2 pg_init_retries 50",
-		.hwhandler     = "1 rdac",
 		.prio_name     = PRIO_RDAC,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 30,
@@ -550,7 +535,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.checker_name  = RDAC,
 		.features      = "2 pg_init_retries 50",
-		.hwhandler     = "1 rdac",
 		.prio_name     = PRIO_RDAC,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 30,
@@ -563,7 +547,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.checker_name  = RDAC,
 		.features      = "2 pg_init_retries 50",
-		.hwhandler     = "1 rdac",
 		.prio_name     = PRIO_RDAC,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 30,
@@ -576,7 +559,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.checker_name  = RDAC,
 		.features      = "2 pg_init_retries 50",
-		.hwhandler     = "1 rdac",
 		.prio_name     = PRIO_RDAC,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 30,
@@ -589,7 +571,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.checker_name  = RDAC,
 		.features      = "2 pg_init_retries 50",
-		.hwhandler     = "1 rdac",
 		.prio_name     = PRIO_RDAC,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 30,
@@ -602,7 +583,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.checker_name  = RDAC,
 		.features      = "2 pg_init_retries 50",
-		.hwhandler     = "1 rdac",
 		.prio_name     = PRIO_RDAC,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 30,
@@ -615,7 +595,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.checker_name  = RDAC,
 		.features      = "2 pg_init_retries 50",
-		.hwhandler     = "1 rdac",
 		.prio_name     = PRIO_RDAC,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 30,
@@ -628,7 +607,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.checker_name  = RDAC,
 		.features      = "2 pg_init_retries 50",
-		.hwhandler     = "1 rdac",
 		.prio_name     = PRIO_RDAC,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 30,
@@ -641,7 +619,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.checker_name  = RDAC,
 		.features      = "2 pg_init_retries 50",
-		.hwhandler     = "1 rdac",
 		.prio_name     = PRIO_RDAC,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 30,
@@ -654,7 +631,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.checker_name  = RDAC,
 		.features      = "2 pg_init_retries 50",
-		.hwhandler     = "1 rdac",
 		.prio_name     = PRIO_RDAC,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 30,
@@ -724,7 +700,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "IBM",
 		.product       = "^IPR",
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
-		.hwhandler     = "1 alua",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.prio_name     = PRIO_ALUA,
@@ -789,7 +764,6 @@ static struct hwentry default_hw[] = {
 		/* AIX NVDISK */
 		.vendor        = "AIX",
 		.product       = "NVDISK",
-		.hwhandler     = "1 alua",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = (300 / DEFAULT_CHECKINT),
@@ -810,7 +784,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.checker_name  = RDAC,
 		.features      = "2 pg_init_retries 50",
-		.hwhandler     = "1 rdac",
 		.prio_name     = PRIO_RDAC,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 30,
@@ -847,7 +820,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.checker_name  = RDAC,
 		.features      = "2 pg_init_retries 50",
-		.hwhandler     = "1 rdac",
 		.prio_name     = PRIO_RDAC,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 30,
@@ -876,7 +848,6 @@ static struct hwentry default_hw[] = {
 		/* M-Series */
 		.vendor        = "NEC",
 		.product       = "DISK ARRAY",
-		.hwhandler     = "1 alua",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.prio_name     = PRIO_ALUA,
@@ -914,7 +885,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.checker_name  = RDAC,
 		.features      = "2 pg_init_retries 50",
-		.hwhandler     = "1 rdac",
 		.prio_name     = PRIO_RDAC,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 30,
@@ -927,7 +897,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.checker_name  = RDAC,
 		.features      = "2 pg_init_retries 50",
-		.hwhandler     = "1 rdac",
 		.prio_name     = PRIO_RDAC,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 30,
@@ -940,7 +909,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.checker_name  = RDAC,
 		.features      = "2 pg_init_retries 50",
-		.hwhandler     = "1 rdac",
 		.prio_name     = PRIO_RDAC,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 30,
@@ -959,7 +927,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.checker_name  = RDAC,
 		.features      = "2 pg_init_retries 50",
-		.hwhandler     = "1 rdac",
 		.prio_name     = PRIO_RDAC,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 30,
@@ -972,7 +939,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.checker_name  = RDAC,
 		.features      = "2 pg_init_retries 50",
-		.hwhandler     = "1 rdac",
 		.prio_name     = PRIO_RDAC,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 30,
@@ -985,7 +951,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.checker_name  = RDAC,
 		.features      = "2 pg_init_retries 50",
-		.hwhandler     = "1 rdac",
 		.prio_name     = PRIO_RDAC,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 30,
@@ -998,7 +963,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.checker_name  = RDAC,
 		.features      = "2 pg_init_retries 50",
-		.hwhandler     = "1 rdac",
 		.prio_name     = PRIO_RDAC,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 30,
@@ -1011,7 +975,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.checker_name  = RDAC,
 		.features      = "2 pg_init_retries 50",
-		.hwhandler     = "1 rdac",
 		.prio_name     = PRIO_RDAC,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 30,
@@ -1054,7 +1017,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "(Intel|INTEL)",
 		.product       = "Multi-Flex",
 		.bl_product    = "VTrak V-LUN",
-		.hwhandler     = "1 alua",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
@@ -1067,7 +1029,6 @@ static struct hwentry default_hw[] = {
 		/* Linux-IO (LIO) Target */
 		.vendor        = "(LIO-ORG|SUSE)",
 		.product       = ".*",
-		.hwhandler     = "1 alua",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 12,
@@ -1105,7 +1066,6 @@ static struct hwentry default_hw[] = {
 		.product       = "FlashArray",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
-		.hwhandler     = "1 alua",
 		.prio_name     = PRIO_ALUA,
 		.detect_prio   = DETECT_PRIO_OFF,
 		.fast_io_fail  = 10,
@@ -1206,7 +1166,6 @@ static struct hwentry default_hw[] = {
 		/* NST / UNITY */
 		.vendor        = "Nexsan",
 		.product       = "(NestOS|NST5000)",
-		.hwhandler     = "1 alua",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.prio_name     = PRIO_ALUA,
@@ -1224,7 +1183,6 @@ static struct hwentry default_hw[] = {
 		/* 3000 / 6000 Series (ALUA mode) */
 		.vendor        = "VIOLIN",
 		.product       = "SAN ARRAY ALUA",
-		.hwhandler     = "1 alua",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.prio_name     = PRIO_ALUA,
@@ -1275,7 +1233,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "Promise",
 		.product       = "VTrak",
 		.bl_product    = "VTrak V-LUN",
-		.hwhandler     = "1 alua",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.prio_name     = PRIO_ALUA,
@@ -1286,7 +1243,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "Promise",
 		.product       = "Vess",
 		.bl_product    = "Vess V-LUN",
-		.hwhandler     = "1 alua",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.prio_name     = PRIO_ALUA,
-- 
2.47.0


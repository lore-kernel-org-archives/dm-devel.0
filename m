Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5FBF190475
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 15:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130821; cv=none; b=Xyz20G/mPPLVPE/VYL0X90FBXxEh3CA3BUullSaDkw5sXVGN7UU+VeWBtiTjumdlZi8PZjJXMDT60fJEhcujmqSFhnFyF1Gr8Y9EO7x/rZOVHb1FCxQQila8zir7jXxNwVfZOf9xaJ3T6eRpWntEUXcL0wUgUnLJ+OzenXJ7Tp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130821; c=relaxed/simple;
	bh=Acwc7K6VUtkipSQ+y5yJIKDM51C7wu1tVtZwh54RkfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rw4WZqxTKmmbp/mEAz8T+0517DiiAkB4EGbnT3DOPeGM81Pm1gTWlN+AhGIu4MOx2ycbKVStYoalV2WlvVL0o0UEJuic8G1tqX3cQTyaQ2eSF9Ir6nNjof+UJ/Q1my3/P1BbmfYiCwbdyBzWOVOzp4EwTcDol+X8CcIkQd5LRPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SzvvYGj/; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SzvvYGj/"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a7aa4bf4d1eso141512866b.0
        for <dm-devel@lists.linux.dev>; Thu, 08 Aug 2024 08:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723130818; x=1723735618; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pKWkBe/yzdeS/gkunkSE4OuaqidURsKkkxDKM/IXAjc=;
        b=SzvvYGj/ObyfjiD/Tu+NJGA6+ZQnsnLTpDsozB74G244/zooFmLQTEuWt5Cs9nlvzV
         M/JL80/l1h+uIpnZ8ofPHms8jrPUtIoCQDoXWfqld8quSWzUXhOmPEqBkL4MzAlMUm5j
         nNDFoXT53Vo9AZ1Y+IkLfLP4C6YAmvSWJjOO9vvV1hvAkMf+verYFuyjStOH65aSeenj
         jnqWPb5yiJ6UKRyBkY3SlrdLXDNXa/+zLpC0IA8LvM1NmrzIsX7cAnCEh7mIjvLCIHiR
         AvcLPlx3ziHlxGFPArR6MbiOUjvPn0V5rJsMtc94PTTgNenaeIsMMoZUAEbsENMRQn/h
         WhOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723130818; x=1723735618;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pKWkBe/yzdeS/gkunkSE4OuaqidURsKkkxDKM/IXAjc=;
        b=dp48GiRk9BU9qWuwlagOS7wo9iE2zZUpZckLFTJeuZ8Moa3hcPI8mBcrHXJO7SqBdv
         Y5aJdSRm7ufnBBF+8jlklbMfupb/AKXL5Pyb7k2eUqSKvzCxhgpvtTq8aVjEYduxmbYV
         z0p6WQF6T5c/IFNBqGapgbFJUi4qwPltkVrO0yoNrntqhFd/Jfr4nodEpK9EYYPPOiFW
         zOo0REzp1AypCBgAi96vXjBGPEubgDeTEUWYAd2vfBnRCmKUEChF9nMovjjs/0QcB94+
         7DM4bYj3p73P5R3bK2v+ndw4abqoCxjvrOHURIdLAcP6QmyGzo2oB61/XhLTMz1Ba4L/
         ZL4g==
X-Gm-Message-State: AOJu0Yy+iQqSG3knWsBxZKUH2QYf4oG3wCZu4YWFg4CpNZtZ8H1QdO0A
	27ntKna4qQ8sEY8H7OgQdLggGAPmlhtksmB6QxYL1QwVYnAFhfhyQVm2czha4ak=
X-Google-Smtp-Source: AGHT+IGbOR89BeLDTSkG7bZbRWo7K8S5XUqhV9EQGIeLBQa4aAsJ/+U39rm05dAUPewJM7lA8GLXNg==
X-Received: by 2002:a17:907:3f16:b0:a7a:a2b7:93ff with SMTP id a640c23a62f3a-a8090eabebfmr190193566b.57.1723130817905;
        Thu, 08 Aug 2024 08:26:57 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a7dc9e80e6asm754068266b.165.2024.08.08.08.26.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 08:26:57 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 24/41] libmultipath: rename macros starting with underscore
Date: Thu,  8 Aug 2024 17:26:03 +0200
Message-ID: <20240808152620.93965-25-mwilck@suse.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240808152620.93965-1-mwilck@suse.com>
References: <20240808152620.93965-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/checkers/directio.c     |  8 ++++----
 libmultipath/checkers/emc_clariion.c | 20 ++++++++++----------
 libmultipath/checkers/rdac.c         | 20 ++++++++++----------
 libmultipath/checkers/tur.c          | 10 +++++-----
 libmultipath/foreign/nvme.c          | 26 +++++++++++++-------------
 5 files changed, 42 insertions(+), 42 deletions(-)

diff --git a/libmultipath/checkers/directio.c b/libmultipath/checkers/directio.c
index 12b8be4..8e87878 100644
--- a/libmultipath/checkers/directio.c
+++ b/libmultipath/checkers/directio.c
@@ -49,11 +49,11 @@ enum {
 	MSG_DIRECTIO_BLOCKSIZE,
 };
 
-#define _IDX(x) (MSG_DIRECTIO_##x - CHECKER_FIRST_MSGID)
+#define IDX_(x) (MSG_DIRECTIO_##x - CHECKER_FIRST_MSGID)
 const char *libcheck_msgtable[] = {
-	[_IDX(UNKNOWN)] = " is not available",
-	[_IDX(PENDING)] = " is waiting on aio",
-	[_IDX(BLOCKSIZE)] = " cannot get blocksize, set default",
+	[IDX_(UNKNOWN)] = " is not available",
+	[IDX_(PENDING)] = " is waiting on aio",
+	[IDX_(BLOCKSIZE)] = " cannot get blocksize, set default",
 	NULL,
 };
 
diff --git a/libmultipath/checkers/emc_clariion.c b/libmultipath/checkers/emc_clariion.c
index 04635b5..bf0baab 100644
--- a/libmultipath/checkers/emc_clariion.c
+++ b/libmultipath/checkers/emc_clariion.c
@@ -57,20 +57,20 @@ enum {
 	MSG_CLARIION_PASSIVE_GOOD,
 };
 
-#define _IDX(x) (MSG_CLARIION_ ## x - CHECKER_FIRST_MSGID)
+#define IDX_(x) (MSG_CLARIION_ ## x - CHECKER_FIRST_MSGID)
 const char *libcheck_msgtable[] = {
-	[_IDX(QUERY_FAILED)] = ": sending query command failed",
-	[_IDX(QUERY_ERROR)] = ": query command indicates error",
-	[_IDX(PATH_CONFIG)] =
+	[IDX_(QUERY_FAILED)] = ": sending query command failed",
+	[IDX_(QUERY_ERROR)] = ": query command indicates error",
+	[IDX_(PATH_CONFIG)] =
 	": Path not correctly configured for failover",
-	[_IDX(UNIT_REPORT)] =
+	[IDX_(UNIT_REPORT)] =
 	": Path unit report page in unknown format",
-	[_IDX(PATH_NOT_AVAIL)] =
+	[IDX_(PATH_NOT_AVAIL)] =
 	": Path not available for normal operations",
-	[_IDX(LUN_UNBOUND)] = ": Logical Unit is unbound or LUNZ",
-	[_IDX(WWN_CHANGED)] = ": Logical Unit WWN has changed",
-	[_IDX(READ_ERROR)] = ": Read error",
-	[_IDX(PASSIVE_GOOD)] = ": Active path is healthy",
+	[IDX_(LUN_UNBOUND)] = ": Logical Unit is unbound or LUNZ",
+	[IDX_(WWN_CHANGED)] = ": Logical Unit WWN has changed",
+	[IDX_(READ_ERROR)] = ": Read error",
+	[IDX_(PASSIVE_GOOD)] = ": Active path is healthy",
 	NULL,
 };
 
diff --git a/libmultipath/checkers/rdac.c b/libmultipath/checkers/rdac.c
index 9a3860f..87b8872 100644
--- a/libmultipath/checkers/rdac.c
+++ b/libmultipath/checkers/rdac.c
@@ -234,19 +234,19 @@ enum {
 	RDAC_MSGID_INQUIRY_FAILED,
 };
 
-#define _IDX(x) (RDAC_MSGID_##x - CHECKER_FIRST_MSGID)
+#define IDX_(x) (RDAC_MSGID_##x - CHECKER_FIRST_MSGID)
 const char *libcheck_msgtable[] = {
-	[_IDX(NOT_CONN)] = MSG_RDAC_DOWN_TYPE("lun not connected"),
-	[_IDX(IN_STARTUP)] = MSG_RDAC_DOWN_TYPE("ctlr is in startup sequence"),
-	[_IDX(NON_RESPONSIVE)] =
+	[IDX_(NOT_CONN)] = MSG_RDAC_DOWN_TYPE("lun not connected"),
+	[IDX_(IN_STARTUP)] = MSG_RDAC_DOWN_TYPE("ctlr is in startup sequence"),
+	[IDX_(NON_RESPONSIVE)] =
 	MSG_RDAC_DOWN_TYPE("non-responsive to queries"),
-	[_IDX(IN_RESET)] = MSG_RDAC_DOWN_TYPE("ctlr held in reset"),
-	[_IDX(FW_DOWNLOADING)] =
+	[IDX_(IN_RESET)] = MSG_RDAC_DOWN_TYPE("ctlr held in reset"),
+	[IDX_(FW_DOWNLOADING)] =
 	MSG_RDAC_DOWN_TYPE("ctlr firmware downloading"),
-	[_IDX(QUIESCED)] = MSG_RDAC_DOWN_TYPE("ctlr quiesced by admin request"),
-	[_IDX(SERVICE_MODE)] = MSG_RDAC_DOWN_TYPE("ctlr is in service mode"),
-	[_IDX(UNAVAILABLE)] = MSG_RDAC_DOWN_TYPE("ctlr is unavailable"),
-	[_IDX(INQUIRY_FAILED)] = MSG_RDAC_DOWN_TYPE("inquiry failed"),
+	[IDX_(QUIESCED)] = MSG_RDAC_DOWN_TYPE("ctlr quiesced by admin request"),
+	[IDX_(SERVICE_MODE)] = MSG_RDAC_DOWN_TYPE("ctlr is in service mode"),
+	[IDX_(UNAVAILABLE)] = MSG_RDAC_DOWN_TYPE("ctlr is unavailable"),
+	[IDX_(INQUIRY_FAILED)] = MSG_RDAC_DOWN_TYPE("inquiry failed"),
 	NULL,
 };
 
diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index 2800446..a2905af 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -35,12 +35,12 @@ enum {
 	MSG_TUR_TRANSITIONING,
 };
 
-#define _IDX(x) (MSG_ ## x - CHECKER_FIRST_MSGID)
+#define IDX_(x) (MSG_ ## x - CHECKER_FIRST_MSGID)
 const char *libcheck_msgtable[] = {
-	[_IDX(TUR_RUNNING)] = " still running",
-	[_IDX(TUR_TIMEOUT)] = " timed out",
-	[_IDX(TUR_FAILED)] = " failed to initialize",
-	[_IDX(TUR_TRANSITIONING)] = " reports path is transitioning",
+	[IDX_(TUR_RUNNING)] = " still running",
+	[IDX_(TUR_TIMEOUT)] = " timed out",
+	[IDX_(TUR_FAILED)] = " failed to initialize",
+	[IDX_(TUR_TRANSITIONING)] = " reports path is transitioning",
 	NULL,
 };
 
diff --git a/libmultipath/foreign/nvme.c b/libmultipath/foreign/nvme.c
index 6f2d880..9b26764 100644
--- a/libmultipath/foreign/nvme.c
+++ b/libmultipath/foreign/nvme.c
@@ -955,18 +955,18 @@ void release_paths(__attribute__((unused)) const struct context *ctx,
 }
 
 /* compile-time check whether all methods are present and correctly typed */
-#define _METHOD_INIT(x) .x = x
+#define METHOD_INIT(x) .x = x
 static struct foreign __methods __attribute__((unused)) = {
-	_METHOD_INIT(init),
-	_METHOD_INIT(cleanup),
-	_METHOD_INIT(change),
-	_METHOD_INIT(delete),
-	_METHOD_INIT(delete_all),
-	_METHOD_INIT(check),
-	_METHOD_INIT(lock),
-	_METHOD_INIT(unlock),
-	_METHOD_INIT(get_multipaths),
-	_METHOD_INIT(release_multipaths),
-	_METHOD_INIT(get_paths),
-	_METHOD_INIT(release_paths),
+	METHOD_INIT(init),
+	METHOD_INIT(cleanup),
+	METHOD_INIT(change),
+	METHOD_INIT(delete),
+	METHOD_INIT(delete_all),
+	METHOD_INIT(check),
+	METHOD_INIT(lock),
+	METHOD_INIT(unlock),
+	METHOD_INIT(get_multipaths),
+	METHOD_INIT(release_multipaths),
+	METHOD_INIT(get_paths),
+	METHOD_INIT(release_paths),
 };
-- 
2.46.0


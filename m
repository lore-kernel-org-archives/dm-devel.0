Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2E219046C
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 15:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130834; cv=none; b=j/GdXXBbIo/6msh+wpn9pCxr0VswoK2Xs2D5pwBaZB2fDp3hMaK0oInarjVlyL1CumFd63TUS0j58GpAnl5ekV9ZY0SQtMYh9mBGfElIeSnPmpUXMHfRM9giFctEL0YkzNyNayURA5H8veF2F/NC2ig5Y5cV1Ac/qqIZP2n+rkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130834; c=relaxed/simple;
	bh=6mMPXeCvVJ2goGbCus+K4rYvAjUIf/cKbrCtgzqE3Ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WdNht0STEemqdVgm+e+J9opHEtxP44zKHroT9cqBiFh6P5cm6Qjw9rWBeRbPi5mdHdoSdh/HvSXOzrCoVNORlYYrTzx7pSztfphUue0NRnzUaW+PhrgpHCotSdazGbRPY7WK5LpbRwT2j4pr7K3NVGrtz6Se6i8zABLbg2yB+EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OjnOlwBm; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OjnOlwBm"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5a10835487fso1474054a12.1
        for <dm-devel@lists.linux.dev>; Thu, 08 Aug 2024 08:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723130830; x=1723735630; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hl9z3Kv7VvQbdoOUQwTGJl7h/Tz+6ItN6aWF5tvGMOA=;
        b=OjnOlwBmNWSBghhnDOFs9Bpu2yQNdC6R+rLe6vU0QwyaWfF57rYkX63VBueRt8aSfJ
         dhaMgtZDgJAV+6d6iwO0nhU80wHzQjlToqdGqAgBRcHZBkrgQhmXx/H7mg/zC4sEpa5M
         OGh97m+PN8s2d9VC+tLkSYKan3A52XmoybXlKa9GJnyuK6iI2vutFCy6x/2pDwLDamOJ
         1sMQNolw9Br3fsT5cqBCHDtlbGo+glCO0Tso1C7wJKst8k9HNR4/aXk5Jr77NBWLTcqZ
         5XRBxhIZrkRZRHKq2kAzruap7FpmmelA5c1n+etCUvK/iJiq4sHBojC78RS4BRn2b5HO
         ByTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723130830; x=1723735630;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hl9z3Kv7VvQbdoOUQwTGJl7h/Tz+6ItN6aWF5tvGMOA=;
        b=qFgeMCOe2o8ikUVuErNmRkJoRO1iZN1iOpdFrkdBy7Fp3Foi2ZKHQ0xStrwXBEhGye
         s58A+CsEgpijLoMCyTfCLj6KlfgxhGZKgKYKh/6q/h23eZLu+1hRi/8iN4ZurzxGZqCl
         yWO1EhGUVU1e6CSAlsHireAQAOa8SBZZwQwXmrP7uCAKN5FzYPTC13tM0rqrDegPkMU9
         Dzruj8Vqhu0Rq5JU6Q1WLoE+YAuT1+qEoIVF7LVeyBAfRv1HJbPIpRjg34VnAzH/KL43
         LHJhDA0VChOQYtX+sXWpMhcBmLDmpi25+70cP4jZqSPLRCu/sTKHsEfeP7xk6Lb62QiE
         rGNw==
X-Gm-Message-State: AOJu0YzfoBHzrMbh0SntvFVYvKGxiB4n69jUF5xUFkxV8v0OXojka4+P
	KeP0cIZOySwUdaiRgdn94ztu3zLtMrQ+pI8l4TUBaYFHJXnLd523vS4Zq9GJSsxW+T3OFWjGLsl
	eiVo=
X-Google-Smtp-Source: AGHT+IFRhAJt5mt4+73wcZHiGsgQJuSVRdgPSzqiDgzP9mw7iMTCo16KUHcgN6RudIktiTpcUM4Q0Q==
X-Received: by 2002:a17:907:f743:b0:a7a:952b:95b4 with SMTP id a640c23a62f3a-a8090e929d5mr160474266b.47.1723130830116;
        Thu, 08 Aug 2024 08:27:10 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a7dc9ec8855sm756275366b.199.2024.08.08.08.27.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 08:27:09 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 35/41] libdmmp: rename enum values and variables starting with _DMMP_
Date: Thu,  8 Aug 2024 17:26:14 +0200
Message-ID: <20240808152620.93965-36-mwilck@suse.com>
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
 libdmmp/libdmmp_path.c | 14 +++++++-------
 libdmmp/libdmmp_pg.c   | 18 +++++++++---------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/libdmmp/libdmmp_path.c b/libdmmp/libdmmp_path.c
index 21714b1..0650f8d 100644
--- a/libdmmp/libdmmp_path.c
+++ b/libdmmp/libdmmp_path.c
@@ -27,17 +27,17 @@
 #include "libdmmp/libdmmp.h"
 #include "libdmmp_private.h"
 
-#define _DMMP_SHOW_PS_INDEX_BLK_NAME	0
-#define _DMMP_SHOW_PS_INDEX_STATUS	1
-#define _DMMP_SHOW_PS_INDEX_WWID	2
-#define _DMMP_SHOW_PS_INDEX_PGID	3
+#define DMMP_SHOW_PS_INDEX_BLK_NAME	0
+#define DMMP_SHOW_PS_INDEX_STATUS	1
+#define DMMP_SHOW_PS_INDEX_WWID	2
+#define DMMP_SHOW_PS_INDEX_PGID	3
 
 struct dmmp_path {
 	char *blk_name;
 	uint32_t status;
 };
 
-static const struct _num_str_conv _DMMP_PATH_STATUS_CONV[] = {
+static const struct _num_str_conv DMMP_PATH_STATUS_CONV[] = {
 	{DMMP_PATH_STATUS_UNKNOWN, "undef"},
 	{DMMP_PATH_STATUS_UP, "ready"},
 	{DMMP_PATH_STATUS_DOWN, "faulty"},
@@ -49,10 +49,10 @@ static const struct _num_str_conv _DMMP_PATH_STATUS_CONV[] = {
 };
 
 _dmmp_str_func_gen(dmmp_path_status_str, uint32_t, path_status,
-		   _DMMP_PATH_STATUS_CONV);
+		   DMMP_PATH_STATUS_CONV);
 _dmmp_str_conv_func_gen(_dmmp_path_status_str_conv, ctx, path_status_str,
 			uint32_t, DMMP_PATH_STATUS_UNKNOWN,
-			_DMMP_PATH_STATUS_CONV);
+			DMMP_PATH_STATUS_CONV);
 
 _dmmp_getter_func_gen(dmmp_path_blk_name_get, struct dmmp_path, dmmp_p,
 		      blk_name, const char *);
diff --git a/libdmmp/libdmmp_pg.c b/libdmmp/libdmmp_pg.c
index 6be2316..42e87fe 100644
--- a/libdmmp/libdmmp_pg.c
+++ b/libdmmp/libdmmp_pg.c
@@ -28,12 +28,12 @@
 #include "libdmmp/libdmmp.h"
 #include "libdmmp_private.h"
 
-#define _DMMP_SHOW_PGS_CMD "show groups raw format %w|%g|%p|%t|%s"
-#define _DMMP_SHOW_PG_INDEX_WWID	0
-#define _DMMP_SHOW_PG_INDEX_PG_ID	1
-#define _DMMP_SHOW_PG_INDEX_PRI		2
-#define _DMMP_SHOW_PG_INDEX_STATUS	3
-#define _DMMP_SHOW_PG_INDEX_SELECTOR	4
+#define DMMP_SHOW_PGS_CMD "show groups raw format %w|%g|%p|%t|%s"
+#define DMMP_SHOW_PG_INDEX_WWID	0
+#define DMMP_SHOW_PG_INDEX_PG_ID	1
+#define DMMP_SHOW_PG_INDEX_PRI		2
+#define DMMP_SHOW_PG_INDEX_STATUS	3
+#define DMMP_SHOW_PG_INDEX_SELECTOR	4
 
 struct dmmp_path_group {
 	uint32_t id;
@@ -45,7 +45,7 @@ struct dmmp_path_group {
 	struct dmmp_path **dmmp_ps;
 };
 
-static const struct _num_str_conv _DMMP_PATH_GROUP_STATUS_CONV[] = {
+static const struct _num_str_conv DMMP_PATH_GROUP_STATUS_CONV[] = {
 	{DMMP_PATH_GROUP_STATUS_UNKNOWN, "undef"},
 	{DMMP_PATH_GROUP_STATUS_ACTIVE, "active"},
 	{DMMP_PATH_GROUP_STATUS_DISABLED, "disabled"},
@@ -53,10 +53,10 @@ static const struct _num_str_conv _DMMP_PATH_GROUP_STATUS_CONV[] = {
 };
 
 _dmmp_str_func_gen(dmmp_path_group_status_str, uint32_t, pg_status,
-		   _DMMP_PATH_GROUP_STATUS_CONV);
+		   DMMP_PATH_GROUP_STATUS_CONV);
 _dmmp_str_conv_func_gen(_dmmp_path_group_status_str_conv, ctx, pg_status_str,
 			uint32_t, DMMP_PATH_GROUP_STATUS_UNKNOWN,
-			_DMMP_PATH_GROUP_STATUS_CONV);
+			DMMP_PATH_GROUP_STATUS_CONV);
 
 _dmmp_getter_func_gen(dmmp_path_group_id_get, struct dmmp_path_group, dmmp_pg,
 		      id, uint32_t);
-- 
2.46.0


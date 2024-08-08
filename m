Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA7418FDDB
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 15:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130811; cv=none; b=cmxD5HWWA95dPpaNL/6I/eHODwclcI8pBUx3GnPL6zMjHDAHv43y9NJIWDIKOfyfg/Bxc1ZpKe5v5hUnqLZG+m7EQfxKnXh++RpYncPOIw12evPCQOwQ7hWTqZbrYcwejEuRUsBJ4LnoxsV6qEAiRGvec21CL6BRJCOtaftKyn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130811; c=relaxed/simple;
	bh=pFkA9n8z+3S2anTb9UuuJEIalZ4kJkP2QyC8DRFGKP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hF9kEAXS5brNpE1qsWnKipVhoTO/oae6EptsjnsvXi1vy+20lblUPFgUThoeQIGx0zJIe1nQ0qpwQf9xoImb9zb9GNHuutm7MKI+RnT86ZjN6H5B/5TPBruV2V+XdbudLYTA64JNCsEMKclo+PTNDmRlkHgEWIizQ/iBuGtmaxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dQ9xWJGb; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dQ9xWJGb"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5a3b866ebc9so1262273a12.3
        for <dm-devel@lists.linux.dev>; Thu, 08 Aug 2024 08:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723130808; x=1723735608; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QziZkA2s4fb9S6w/uSt5qvNjZl3XGXOwewRbaetDqKE=;
        b=dQ9xWJGb3HIyLXQt1TJ8Amc8oKmHyYLC0H3QhG0ZOHAE7Mfk+wEEVimOaQLpEt43ts
         uYT6kCdNAtV6qUSA79QeN6sfTt3ZF1k8OpxVFQdx/X7dgnCeshod8VUDXrUsrAHnuOwt
         rW2fqPrW37pVjA25A7Dp2EaN8aM4Rai5fKYqJUSoTvzJisSTL322ubLog4pQIJccu4tp
         UO5M44pr9fC01MUyuSlnNCK0r1IAz8TbIyJDoAa9u9YN4/mtv4i91vn5AC44N3Z7+6KW
         Zwh2kPlVx3jXCGNgrkTeIkXUQc+IoxKrR1HVT+xgr8h15q12XJ6dMf3biHHucy+4ZlRE
         yG9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723130808; x=1723735608;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QziZkA2s4fb9S6w/uSt5qvNjZl3XGXOwewRbaetDqKE=;
        b=nA9s1TfOA9VbgT0rSsEdFyGNM0bEuk6cHO9Z68T2jCfhmqNeJKoiip9B95OzXidHvU
         9kHkmSxSrDZfouDJAv4YOS2Vox4RuQ3FakuFuXgDC4ZwqWKT95EPa1L16AaTY4ck5Oxq
         QrX1Z6ZkWyXbrimfnkBw1aiIdlK37c9tuiiAbhBSI+lAg7NAxmkXsaqRgZ02c2+OPOIM
         nrkfUyhS5+WG5M5dxtZ2IQqREf8iV3U8ijeEAESJO/n7Rbt8ehtussvbXzIBJKdxSBbP
         cE12I+ZCv6f3F7b2YCSK0+XnuvNCYpRrfU9PYVnOPh7eyLtvb9kWudtDpAopOfghUUzn
         1+jA==
X-Gm-Message-State: AOJu0YyYqtngAUsuDYDAtBy48i+Hh8Qm9vNUQ7jgpCrZnjAz0MeTu7bF
	Q/N7PFJrKShVAABamnDylDpiGodS5kUqHCadAiY3R3WF7Jpr0tAu6++z0jJy3mOLRGDTp9r2jeG
	JsYY=
X-Google-Smtp-Source: AGHT+IG+vigWrCWroeqqTS0ulqk5Ds8tdFEZLRHpr7Ch2BbJB2L6zMO+Slj+pzigWYHRbQb+RZfK0w==
X-Received: by 2002:a17:907:845:b0:a77:e55a:9e8c with SMTP id a640c23a62f3a-a8090e9e24dmr184455466b.47.1723130808031;
        Thu, 08 Aug 2024 08:26:48 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a7dc9ec4875sm748437866b.191.2024.08.08.08.26.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 08:26:47 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 14/41] libmultipath: rename _NVME_LIB_C
Date: Thu,  8 Aug 2024 17:25:53 +0200
Message-ID: <20240808152620.93965-15-mwilck@suse.com>
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
 libmultipath/nvme-lib.c | 2 +-
 libmultipath/nvme-lib.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/nvme-lib.c b/libmultipath/nvme-lib.c
index f30e769..0c2be4f 100644
--- a/libmultipath/nvme-lib.c
+++ b/libmultipath/nvme-lib.c
@@ -1,6 +1,6 @@
 #include <sys/types.h>
 /* avoid inclusion of standard API */
-#define _NVME_LIB_C 1
+#define NVME_LIB_C 1
 #include "nvme-lib.h"
 #include "nvme-ioctl.c"
 #include "debug.h"
diff --git a/libmultipath/nvme-lib.h b/libmultipath/nvme-lib.h
index 059dca8..6aa9bd2 100644
--- a/libmultipath/nvme-lib.h
+++ b/libmultipath/nvme-lib.h
@@ -16,7 +16,7 @@ int libmp_nvme_ana_log(int fd, void *ana_log, size_t ana_log_len, int rgo);
  */
 int nvme_id_ctrl_ana(int fd, struct nvme_id_ctrl *ctrl);
 
-#ifndef _NVME_LIB_C
+#ifndef NVME_LIB_C
 /*
  * In all files except nvme-lib.c, the nvme functions can be called
  * by their usual name.
-- 
2.46.0


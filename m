Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D044048A2CD
	for <dm-devel@lists.linux.dev>; Tue,  5 May 2026 15:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777995846; cv=none; b=X8+sR2dFJ4ajuTWVpi9BjxiaaShJvOX+3s416Jkx9owRdSBdzpBvciofFLTfKEIEokDCdmTdAyT7H8PA4WymMXEevgYoLO7eEWAXX3AenBa/RMCDvAjJfnsD+a4uakmRMOMi14ikZqr+0iSMsfYHVL9n9FonzxtByjaxtyiLnMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777995846; c=relaxed/simple;
	bh=LTHnZ/o/ZuLLzEwFG/rcloAicrQU2lKH9wYY+P6dzHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KOnWLz7GeZzwGtYZ3VeigdWCh4I6VJZE7iqg0u+mKCsFYGonZnTtbedMmvBkz16hdbM9lvx0mGCLRJiSUS3o+7LdVLDcEnyW4kmAWmcDY5TxOz1y8rZg0cTJYheNTlhcJ/gzNgHV9O9C9ihhKQEvlmORXdmd/FpTPpIKz+phlOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BjG/RGW3; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BjG/RGW3"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-48984d29fe3so78559725e9.0
        for <dm-devel@lists.linux.dev>; Tue, 05 May 2026 08:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777995843; x=1778600643; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/RdSIn1RRplQLuqRM0kteEP4T32YGvE4m+LZT5nuI/Y=;
        b=BjG/RGW3c4dJjaZV6Xe57WkZ9YjFKp4exPx03xZIAcVy9uj5Np89f4XElyWYqeoI/9
         SoGmiCgZWm4iEbYnOgOxUQG8/BHJ8UD6W0+uGsQN5MxnlQ2mvF+epqeWwR1ljMrwdMlQ
         aZrrRADCUoGvAbuoYObql6nXd3KAZF8jduycLRpZJum46eqPXSy1JV7o2Um7xG04N7/P
         Na50yTHJoIoDC6kaJg86lQg63yLajeq1l/J3eeD2Vs2Obi/4d3gS+Im0mpttXLa/pVAe
         qraShDw2R7WzNspcmooFM2G32UVza0hHV3lIeugsNOj4Ftwt5PvZiBW73UHYScfgGS82
         Mf3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777995843; x=1778600643;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/RdSIn1RRplQLuqRM0kteEP4T32YGvE4m+LZT5nuI/Y=;
        b=K140PzuW9dJQ88inwI7vdPDgyFfXWk77UupKxid3ZMTVxsL87Ps01Je+Jg/4U1iYSU
         RJ8P0sE2COOnsy65C8+4zL0WUB95oBHbUZ3g6euDzVwKYgWi2pJkPXHLQggR/gwpfZM0
         VMgKwiRPAsCmqyaQdED8WJ4LPcCt5tD8MIMSajYS3aH4pIfw9Ud30rzQQtpk54PMsb62
         TdL6zq9+OOzJpnPOmb+lcDbXm8k+YbBmax0isUznLC1slrlMmlNowzOWb3mW5JnqNUYC
         4x8y99nlFu/2tHeWAr/AM6GaNRz9n1sL6mnWyIHFMTg4TAIZBe1VTtnINsPjPBBzEKFC
         /dqg==
X-Forwarded-Encrypted: i=1; AFNElJ/Z6/i8HMTMDv3nKDWFindeSZpaU35YlVQOPl+S0Dw/5ykx5YL5Bx2bXTsQPU7X4z2EsFN7wR+QzQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz/u6ngf1PEmVum4wQ92NW1HRWAixFzp2qgXueuK68FTwv1HXBZ
	pIpPMXOoNNWfVwIMLYI/n22HK08zbpIEaNOLVxjV+Vum7NAsOpi64weYYFD/tFiclcU=
X-Gm-Gg: AeBDievkFloHJIhjs5Ndcn5J0J5bwmgNrLuLjBDMFdCr5XDSQavrlkLZi95dCscD8DQ
	+01OtvA18tmxPWapyZKMGra8/AlI9Axbnh3vvTtfh1P/lzbUiskiQxYvLMICQWR5WSCPs6X/JCh
	M2xkZL8/QSAcPwARxQhx8iJUN3hzyfvz2ASHQVteALVfNzMUKbeHO/OC8PdYaHBE+Lhj0aCD3L2
	mEI9sGKC8llKk8itFmGPizQcH4oD3qmaZUhDe9Anq7atRfbXUguuF/bXll34XwhfIquO2IIAmub
	KNFm58uyCc8MxLHPM3TW46Qsi37IvDAextCaYPy/qBKFJtTuHbI/jqnmKqOoeC9pw98D4+p6DYc
	WFLuZMF1WxHBan/rZxreYmb1wosPRhZemry9GKeZfnPuLbaPZ7KT5nr1RE+vFW28YbM4Ul/mHTG
	Pjy0/15je2YiMX4jXe1vteAQPpF7DVfwwnznYYNhQGp+pYiFR+1RUTz+J66QLveFwPa8fBA81Df
	65TJ/7knV6nCaE6eK0eGiX5
X-Received: by 2002:a05:600c:c10b:b0:488:9ed3:1492 with SMTP id 5b1f17b1804b1-48d188e7990mr45574365e9.10.1777995843134;
        Tue, 05 May 2026 08:44:03 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-4511d8cd160sm867991f8f.8.2026.05.05.08.44.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2026 08:44:02 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 14/18] libmultipath: convert readsector0 checker to async checker
Date: Tue,  5 May 2026 17:43:28 +0200
Message-ID: <20260505154332.448054-15-mwilck@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260505154332.448054-1-mwilck@suse.com>
References: <20260505154332.448054-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make the readsector0 checker use the async checker framework.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/checkers/readsector0.c | 28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

diff --git a/libmultipath/checkers/readsector0.c b/libmultipath/checkers/readsector0.c
index b041f11..fcc4ad1 100644
--- a/libmultipath/checkers/readsector0.c
+++ b/libmultipath/checkers/readsector0.c
@@ -1,41 +1,27 @@
 /*
  * Copyright (c) 2004, 2005 Christophe Varoqui
  */
-#include <stdio.h>
-
+#include <sys/types.h>
 #include "checkers.h"
 #include "libsg.h"
+#include "async_checker.h"
 
-struct readsector0_checker_context {
-	void * dummy;
-};
-
-int libcheck_init (__attribute__((unused)) struct checker * c)
-{
-	return 0;
-}
-
-void libcheck_free (__attribute__((unused)) struct checker * c)
-{
-	return;
-}
-
-int libcheck_check (struct checker * c)
+int libcheck_async_func(struct runner_data *rdata)
 {
 	unsigned char buf[4096];
 	unsigned char sbuf[SENSE_BUFF_LEN];
 	int ret;
 
-	ret = sg_read(c->fd, &buf[0], 4096, &sbuf[0],
-		      SENSE_BUFF_LEN, c->timeout);
+	ret = sg_read(rdata->fd, &buf[0], 4096, &sbuf[0], SENSE_BUFF_LEN,
+		      rdata->timeout);
 
 	switch (ret)
 	{
 	case PATH_DOWN:
-		c->msgid = CHECKER_MSGID_DOWN;
+		rdata->msgid = CHECKER_MSGID_DOWN;
 		break;
 	case PATH_UP:
-		c->msgid = CHECKER_MSGID_UP;
+		rdata->msgid = CHECKER_MSGID_UP;
 		break;
 	default:
 		break;
-- 
2.54.0


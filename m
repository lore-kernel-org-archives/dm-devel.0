Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58B948A2CD
	for <dm-devel@lists.linux.dev>; Tue,  5 May 2026 15:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777995844; cv=none; b=eMj4AQEt2Fc+dVSLpEdysSPghtif5wfiPJrPm1r0JP1gh9boozQhZVn+s6/LHD447dKoIGdUqoK/TbWoV6v/zW0ls00Le7Nn8n96on/FwxfVwwqQ5HGPQuevDYGRWdkETt6AYnzZFeWzILiC6v+ZQyjsQT57dW5d/jlMxleS5Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777995844; c=relaxed/simple;
	bh=He/00QN3itgV8ERawk7avQSk+zWz5uXWXrsjq2XJ6E4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HxM/oEo08S1Uf9AoqjAnGQPsTlN6dYj/Fu8NNrkndJzrgzmLzLBUhDIcZpsl/nxwlsYqlltSz7yFfOoTajU7M6NSny/8ucmTjyzAHH5vrO/5ucCgAzR8JIUi2PYog4TH4xxcZYtNyPn5t3wbsl4duh1hx+cYc05lfywEfkiGnhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PQmoNgCR; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PQmoNgCR"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-44e1ebb3122so1201098f8f.2
        for <dm-devel@lists.linux.dev>; Tue, 05 May 2026 08:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777995841; x=1778600641; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qmZuDxKKfi2pJuDyvAf6UoEy8xFsLDFkTbdO8KXHwqc=;
        b=PQmoNgCRjuqAqVWdF6c9sq5EM+zLdTKVaR13GWHDlvNXE8DrTlLftKb45Wo/fHGwbe
         UqGMyaeTS0cnKiHUseJoDxJURrLqwNKDCEXU9rW7dXESOW8ExrezP/n1zIr+DR5gpzY/
         gFXxcdnj9bt7cluev4Evx6Ruqc6MwfHEXEKWXBpK6lHwi+f0eK1qgJPV79lDNCtzaPrO
         XyReJI3E+jGSsim5ntlKV9RzU7aK1b//r4tAIosOYCLY4uzLiwzbi0K6dYoC6c05lZOC
         IsG8OQrUiUhrvnabyhZCYZZvSFAYDLeVUalOjq5G0cwQBUrT9kbeQ6Gg5ck7EAY/GMW+
         9rCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777995841; x=1778600641;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qmZuDxKKfi2pJuDyvAf6UoEy8xFsLDFkTbdO8KXHwqc=;
        b=Z9/e98FTQARI78jHBKEna/YVTCOsFMuvd14JCAeCBH2mn+sZDixL8TVGNcBm0Hxm7g
         b1FO3ZAIrUE29v7SnhGrRGd6WnGB5yxyG3boOUXnBvXtZOE5cl8t1afMVerOlEl9cSJD
         Dw+HlrvFKF5I3c1zLsHiECsjuJFtUAnqlVUoiydnMtk8axKRKGO2WZY6WTwn5pri0Li1
         0uEYG/7u75/EmtzdMPF+VWbrOgVhAwqiYBxYu2aKZ5rJ6pKEHX/+txFELuP3KU7McOex
         yH7zSg69mb7ZTK1WFdLfoX0W9+v7grX+/T0LMheOfSRwsIfM+qZSP/5JD/qkreMwmK7j
         O9DA==
X-Forwarded-Encrypted: i=1; AFNElJ+JR4KpEkkoSJBxSE8YQWduHH2cx4Zdre5TbmZ17ruJ7fmi2/BAkhnYsCOWUpieaevACCfWNJ6iZg==@lists.linux.dev
X-Gm-Message-State: AOJu0YxwnJqut72BfsI+xFLDrG35VYtXmMcGYJL6LKgG/te0qEcncA2b
	3XZVMeCObF2O+HFxSjEnJR/oE9Bd48PJ5L64YVdtu6k4Xg1dQqAvXlBWY38pYTlKfy0=
X-Gm-Gg: AeBDiesgWCi2ddZm085WIcLBiQSa93VJjti3Z3/UF+XUahi0OQIYv1BNwN1a33o8fXD
	FxH3jbY/HdOnS8W6iCdbX13HL89Th/8717+qe8q01j6CKaZRgvmY9Bi/bYTL61lsm+IW5cCl0Ii
	Ma/FgECDu6JgKyjiq/rI3o6CAh+noschtjQHK7FKyI7mZfLjocwsZ352JDS4QsDYlkhrtBU6r5y
	831Ob6dcG0bX3BRhrhBQB6brWulmcI5L9EJkcEsV2JeW2OuAW+HKJEoKpBsKd/waSYDFvpeGC7D
	YUdBcueV0lbP4hnY/X8WPpDXBfw0pQyT3Kv8YxER14nhFHWEEbmbmO1Ua4Y0fCKh0sSF5tC3WPF
	rfQ3by2mLeTI+cLnwA/tuiuSmI9z4Gg9hfcmIbE8FL7yNxlpBQoLK8wPdezx8bJSE+UTNPsc4av
	BX8+GwYJrlHLPtfkR1g0X24lR5+eBHVW9ffOKRafApzdwBxgtuaFCyUP5NBHNDJ5557CURK5vT/
	Y2wEGgc7eP01EGa/sO1dxeh
X-Received: by 2002:a05:6000:1acf:b0:43d:7ba4:6b5a with SMTP id ffacd0b85a97d-45005a97569mr6502790f8f.22.1777995840948;
        Tue, 05 May 2026 08:44:00 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-45055960022sm5508897f8f.26.2026.05.05.08.44.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2026 08:44:00 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 12/18] libmultipath: convert RDAC checker to async checker
Date: Tue,  5 May 2026 17:43:26 +0200
Message-ID: <20260505154332.448054-13-mwilck@suse.com>
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

Make the RDAC checker use the async checker framework.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/checkers/rdac.c | 30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff --git a/libmultipath/checkers/rdac.c b/libmultipath/checkers/rdac.c
index 87b8872..a477fb5 100644
--- a/libmultipath/checkers/rdac.c
+++ b/libmultipath/checkers/rdac.c
@@ -1,8 +1,6 @@
 /*
  * Copyright (c) 2005 Christophe Varoqui
  */
-#include <stdio.h>
-#include <stdlib.h>
 #include <string.h>
 #include <sys/types.h>
 #include <sys/stat.h>
@@ -15,6 +13,7 @@
 #include "debug.h"
 
 #include "sg_include.h"
+#include "async_checker.h"
 
 #define INQUIRY_CMDLEN		6
 #define INQUIRY_CMD		0x12
@@ -55,11 +54,7 @@ struct control_mode_page {
 	unsigned char dontcare1[6];
 };
 
-struct rdac_checker_context {
-	void * dummy;
-};
-
-int libcheck_init (struct checker * c)
+int libcheck_init(struct checker *c)
 {
 	unsigned char cmd[MODE_SEN_SEL_CMDLEN];
 	unsigned char sense_b[SENSE_BUFF_LEN];
@@ -133,11 +128,6 @@ out:
 	return 0;
 }
 
-void libcheck_free(__attribute__((unused)) struct checker *c)
-{
-	return;
-}
-
 static int
 do_inq(int sg_fd, unsigned int pg_op, void *resp, int mx_resp_len,
        unsigned int timeout)
@@ -288,15 +278,15 @@ checker_msg_string(const struct volume_access_inq *inq)
 	}
 }
 
-int libcheck_check(struct checker * c)
+int libcheck_async_func(struct runner_data *rdata)
 {
 	struct volume_access_inq inq;
 	int ret, inqfail;
 
 	inqfail = 0;
 	memset(&inq, 0, sizeof(struct volume_access_inq));
-	ret = do_inq(c->fd, 0xC9, &inq, sizeof(struct volume_access_inq),
-		     c->timeout);
+	ret = do_inq(rdata->fd, 0xC9, &inq, sizeof(struct volume_access_inq),
+		     rdata->timeout);
 	if (ret != PATH_UP) {
 		inqfail = 1;
 		goto done;
@@ -340,17 +330,17 @@ int libcheck_check(struct checker * c)
 done:
 	switch (ret) {
 	case PATH_WILD:
-		c->msgid = CHECKER_MSGID_UNSUPPORTED;
+		rdata->msgid = CHECKER_MSGID_UNSUPPORTED;
 		break;
 	case PATH_DOWN:
-		c->msgid = (inqfail ? RDAC_MSGID_INQUIRY_FAILED :
-			    checker_msg_string(&inq));
+		rdata->msgid = (inqfail ? RDAC_MSGID_INQUIRY_FAILED
+					: checker_msg_string(&inq));
 		break;
 	case PATH_UP:
-		c->msgid = CHECKER_MSGID_UP;
+		rdata->msgid = CHECKER_MSGID_UP;
 		break;
 	case PATH_GHOST:
-		c->msgid = CHECKER_MSGID_GHOST;
+		rdata->msgid = CHECKER_MSGID_GHOST;
 		break;
 	}
 
-- 
2.54.0


Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6BC48B368
	for <dm-devel@lists.linux.dev>; Tue,  5 May 2026 15:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777995845; cv=none; b=JZA5kG0zal6jGA7xvdise9lLdLSitFQ/tEzSwMrNlA6qGdgczIqBvSgWWZZYcIklkN3L+Iy8OSEjqX2oAMyye8EyBVD60gK62hmjcAldy8asqb/xtGGXKipykj+X8HJAc5i32wFBB8D4YKhLBr1kvd1vcQhw5QLLGuMAvX/0BDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777995845; c=relaxed/simple;
	bh=p42WcEKaJCXj3KYFFzlpJPCpVSCXyEN5HHVPbn4Vnm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E7HnvrI0DTnU4giNf+PIqCubVWtebvoxHPDGKd549xU8F93tf64GiB1x0+TQ+iFBUinppwvkADSomCjhYqHnozUYB0H06xO7jXYrDX8kGt/l012DQveMR/QX6Z7oncH7TNwspo5OaE0Lz2yTUh2i2DmfZ6y44HxpKDyMEpSUkfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fQo+0h5I; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fQo+0h5I"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4896c22fcbaso41560485e9.0
        for <dm-devel@lists.linux.dev>; Tue, 05 May 2026 08:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777995842; x=1778600642; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OfaY6BqvEp6+OAy3cAHgfq93pAkYu8YjYs9Q3WdKfrg=;
        b=fQo+0h5I4+jRQ60cXT0zlDMkYHpe/BR3PjcYF19Eiiso1nEIgE5gZ7SeSVfQzDMUBE
         aOA/X9E5xlfSjujBTI8xcyFtCogiqXQCUVmpiPmhQeXBP3L+9RhdRjg02obrBNHnMavG
         lP5ofSQxU/4RSVgTExwB3Ha1DbiTKe+MahohNlmb89AhC6Va0TwsR+k3Fy+vYi72CSgg
         xZCVBwICLLuG5l3T0QRu1zLyuWrkciLNZnZ9vecM5rb+QOtc9TGxw1ewORzUPsyDLIyO
         nuHPQrx/vw3WCOtfAM6RTL1OqYXtNecHd45hOrE0DCUAVSHuPuvBRVWZp4MKyxD7dMNt
         PIcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777995842; x=1778600642;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OfaY6BqvEp6+OAy3cAHgfq93pAkYu8YjYs9Q3WdKfrg=;
        b=WsLWJWadNjkpRsZMOLLflxkiWMTQcy6Dqxlk8F97BYWz2TDFxlFXmTZuYutWkdZx+0
         E+JD3dEyIVTt/c/jf0N70/VaoeCo00hHDxVSet0GKph76yMmQ2jdKlahDWpVrAf78yef
         T5JkSaprZ/hW786Sbfah1v3Agt+4qzgvvRmPIuSEp7+1+rCTuCjfN+8NaJJJEf+qHFnp
         fWsxlVf1elbBcYvu/yq6JVMkSk8CsISrmW/AznnpL5tllVkmaL6Z1jPIb+60h3SHGmup
         xYr75GGHsvOwIuVtt4CXF57y+29sEjDG/i2tlVYSoakAMnsp7jLgo1IAJYSNVBbky+zC
         RjDQ==
X-Forwarded-Encrypted: i=1; AFNElJ8WA7Z7L2+lzdf4zc7Z82LlmvK9QfU34neFwGG1Wo/uiRtS+deXwGvqP3I17VxFpKFyNeU0HChDkQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy9E5LdJmpmTKqtnu1rx+F89f0TZAVzn4fbq2gQ7KyB3+LPWuHE
	jdaUSU7VObNYGtlD31kBOIdXl1WPtrojNaInIU4/pLARyJdwhH9SIOJ6WducsbJb7dY=
X-Gm-Gg: AeBDieughWWvc02MUjjxxbi6HD0A+EJLZ1d0PLv66eD59sJS0V1oVn7DUYDFCMKKi0H
	XN7GJPCpanJMfWjC2LRQsZccJ/hlJA0bA9Qtn5Zsub9hKuCirLZeCCQpUr0IaFTXXr3xYiFoDv9
	A0ttarpbGjZqai0xCNVTiz/luUm0WgaA2tBsefH1Gl5QIZCYoYoBe54cgz8ZWEwstF4TOCheCwH
	+y8zcpsQ3KfPJH7GYoBk52BACN1Ko7HaRCf2wdKbAc8/6Z/qRJYvVHleB7D9ej1Ix9F08U+kI2A
	YdtYMW9HMCc1gq34zK9/vHnZQllZ5OyQ/xqABEJ7EPc4xQUmHIXvRjRZHCTX41yvqIKnyBX2XTY
	v2un/XXCEL6Udd1d1BCyEOsMoWs6bNdyo+Hvpcqc1i6dFP5xHPSj6ysf6yd6ua+YyrTNsFyBugH
	d8JtfL3UP3WDsg6uvBQ8DO6xvDQm+Kp3BIretPD117mh2eb0Nr2e43OFgCz/c+PaoYpqspda5Ut
	nE2m+RXNJHLMUTPolguGQz1
X-Received: by 2002:a05:600c:a00a:b0:487:219e:42d with SMTP id 5b1f17b1804b1-48a98638d07mr238057925e9.11.1777995842126;
        Tue, 05 May 2026 08:44:02 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-48a82301adesm399095015e9.10.2026.05.05.08.44.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2026 08:44:01 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 13/18] libmultipath: convert cciss_tur checker to async checker
Date: Tue,  5 May 2026 17:43:27 +0200
Message-ID: <20260505154332.448054-14-mwilck@suse.com>
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

Make the cciss_tur checker use the async checker framework.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/checkers/cciss_tur.c | 41 ++++++++-----------------------
 1 file changed, 10 insertions(+), 31 deletions(-)

diff --git a/libmultipath/checkers/cciss_tur.c b/libmultipath/checkers/cciss_tur.c
index c89fe5e..b859138 100644
--- a/libmultipath/checkers/cciss_tur.c
+++ b/libmultipath/checkers/cciss_tur.c
@@ -24,47 +24,33 @@
 #include <errno.h>
 
 #include "checkers.h"
+#include "async_checker.h"
 
 #include "cciss.h"
 
 #define TUR_CMD_LEN 6
 #define HEAVY_CHECK_COUNT       10
 
-struct cciss_tur_checker_context {
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
-int libcheck_check(struct checker * c)
+int libcheck_async_func(struct runner_data *rdata)
 {
 	int rc;
 	int ret;
 	unsigned int lun = 0;
-	struct cciss_tur_checker_context * ctxt = NULL;
 	LogvolInfo_struct    lvi;       // logical "volume" info
 	IOCTL_Command_struct cic;       // cciss ioctl command
 
-	if ((c->fd) < 0) {
-		c->msgid = CHECKER_MSGID_NO_FD;
+	if ((rdata->fd) < 0) {
+		rdata->msgid = CHECKER_MSGID_NO_FD;
 		ret = -1;
 		goto out;
 	}
 
-	rc = ioctl(c->fd, CCISS_GETLUNINFO, &lvi);
+	rc = ioctl(rdata->fd, CCISS_GETLUNINFO, &lvi);
 	if ( rc != 0) {
 		perror("Error: ");
 		fprintf(stderr, "cciss TUR  failed in CCISS_GETLUNINFO: %s\n",
 			strerror(errno));
-		c->msgid = CHECKER_MSGID_DOWN;
+		rdata->msgid = CHECKER_MSGID_DOWN;
 		ret = PATH_DOWN;
 		goto out;
 	} else {
@@ -87,31 +73,24 @@ int libcheck_check(struct checker * c)
 	cic.Request.CDB[4] = 0;
 	cic.Request.CDB[5] = 0;
 
-	rc = ioctl(c->fd, CCISS_PASSTHRU, &cic);
+	rc = ioctl(rdata->fd, CCISS_PASSTHRU, &cic);
 	if (rc < 0) {
 		fprintf(stderr, "cciss TUR  failed: %s\n",
 			strerror(errno));
-		c->msgid = CHECKER_MSGID_DOWN;
+		rdata->msgid = CHECKER_MSGID_DOWN;
 		ret = PATH_DOWN;
 		goto out;
 	}
 
 	if ((cic.error_info.CommandStatus | cic.error_info.ScsiStatus )) {
-		c->msgid = CHECKER_MSGID_DOWN;
+		rdata->msgid = CHECKER_MSGID_DOWN;
 		ret = PATH_DOWN;
 		goto out;
 	}
 
-	c->msgid = CHECKER_MSGID_UP;
+	rdata->msgid = CHECKER_MSGID_UP;
 
 	ret = PATH_UP;
 out:
-	/*
-	 * caller told us he doesn't want to keep the context :
-	 * free it
-	 */
-	if (!c->context)
-		free(ctxt);
-
 	return(ret);
 }
-- 
2.54.0


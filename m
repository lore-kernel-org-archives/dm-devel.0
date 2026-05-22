Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D63027A47F
	for <dm-devel@lists.linux.dev>; Fri, 22 May 2026 16:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779468301; cv=none; b=mkGOMs5WxcUguukZJwbbsO2WkOl8tUhYHMG2nqubda+5wMUbX1Ebflq/36d+pdeADjXBHDN9L6mlHFBlE4bizChwGEQJgztwIUfgn43scGqsJTTF8YFhuwCOYFQFctZNcG+Qe73+anRqiZHNHiIuKXpeunf8JwKJrkURAlQU5e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779468301; c=relaxed/simple;
	bh=CG1TM01wxlr322LfxmE4sIeR6GTo4VWHK5IIE4ant6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fc2hLRV0NN8bl0JZ0Jjy0lYUmxYliLSlfNSdleAXHHcLUuExL7u8w7oZtFq/CKXXQkobDLUe+BURTKXEHxueCIwlJtiaLBKfc5p8wis1CP2UkkhDcetQFQzl+3K+F37Sur+gm1p7hXg80sQGe+nauaGLy41y048veZqX9wuj6Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=c0rPkEpT; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="c0rPkEpT"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-49041e84237so9514535e9.1
        for <dm-devel@lists.linux.dev>; Fri, 22 May 2026 09:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779468297; x=1780073097; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PD6S7RN73UcBnIu5bbI6GbSOjhevtNo2EyUxasawQfc=;
        b=c0rPkEpTa/RTH8a91z6iRYMmDLJgynqEQ+KLAd5dfI7hB40/gdB0W3gMolXLe823Ek
         BMvG9s+tr2+qjhWmb9x/8qOuDSazbejeDY8Kg0101DnCOcPmsDcqXmIaFYOQsPQDwo7s
         ZK7dSSS2K4YWU8IsjRbvfHxt+2/JmuTh1Hm6jQ8A4b0KmoY5juIvaE+jgb/j8nvrmoVc
         dz9G8HVrZKpG/49dYCL6GtR+8sfgmwvQ//0fMDSfmqV7NSOIevNXrBvy7B6zd23CIcnz
         G7D0kh83atv8kJ/qA1p3tGhlOU+kCwoIAH46aTPlWD3v7Hkqc54QcPRKCcAUFm1ll5AM
         9zuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779468297; x=1780073097;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PD6S7RN73UcBnIu5bbI6GbSOjhevtNo2EyUxasawQfc=;
        b=OMtooWYH1RKHzcByTNfgEQQSZ1NQiiDCw4uSJ0OX6AdgadfmTuZ/ZUi/N8b9Mpo+qm
         50olcMqeHhmkg0Pj0wTS2EGV1D1+VpUfmznMFtM9TYw1V0XTdJZxZoKXKvX5yMGygZ9e
         Per3bm2m5iwoFfH4SPiKMzBSsVFEdSLXEgJNMDIO7s17Dt8VTBPFmZqMyQAO6/aot3Lg
         VOn6e+6fe9y87S+5evALHOKSrziDJdIBfBh3UAZmWvAQX8XvTikVQxzSR1H8g65GrkwO
         vy5Y2XHcIIeFd59jQDDy5MepnL0UXHKpKjlH9sJQ6JIWN8yPlBEPzYoWtsAlUwPNCejw
         oEMw==
X-Forwarded-Encrypted: i=1; AFNElJ/jAGfTNxEdg9BdyEyk3EObKiISmoHand9fyq/7JJuz4AJPiNCq5hmEJ7RPH3qCkdUdy6CRGNBRHA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw278AAu2DoCTqQZZ1QhTKcpUPA3qu9mQpORRrfpF9Bbip23+w5
	zernWz+LJd76/TrlvyW7Z7Y/FZi8GLWuxDbycHnOIdjD0vnzA0THouwJKHVaq5k+yAQ=
X-Gm-Gg: Acq92OFHnOvYWovBVUC9wEcqOXw2KPUtEPpea99lNJO4Ij/E47sjT0Lk5cJsYX2c1H2
	MRkTbYfPeICzgKRBrYX4Mvbo/oJvTXjp32fe6Z1YQoQdFrlSsGjR7P8Q3UrtBTLVaBJAI+t3wOq
	IB+j5s7/xF3iVaHq26WsvgOPhTUpvFm1auF2Cv2rN426TAmEey/faCGDKuDepkm/GTtcZNtobbN
	OjiA5EZnFfIb4FJVb6eSHR/jXGU4xLakdLhkTZVn/3E7vvCvYbwLBUfbzw3SJ9/4SybCDbhWf6a
	dAsPPu3L0DaYHuy59I5GRsZBJ2ZbkeyyveialPQ+z5Zdpi1CfEadUJ5WQQB7gKzd9cA6A1Kl0kJ
	ql+buh3A61Eha662x8u3krlu9n+aXFmex6HHZ5aMK24/JSwuc2jfUfpfqN8e55/yo+goIpmmVwL
	8QpyhYpt4e1aylSg+/dHTns+S+x8q8T0Z4pPMGcFsVrxm9ogwMYTrLERbqJkhH3dki157kTJMWy
	tio0GBaoA6eiQ==
X-Received: by 2002:a05:600c:3e12:b0:48a:5339:a46 with SMTP id 5b1f17b1804b1-49042481066mr53561305e9.9.1779468297390;
        Fri, 22 May 2026 09:44:57 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4904d239184sm5471965e9.2.2026.05.22.09.44.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2026 09:44:56 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 13/19] libmultipath: convert cciss_tur checker to async checker
Date: Fri, 22 May 2026 18:44:09 +0200
Message-ID: <20260522164415.846589-14-mwilck@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260522164415.846589-1-mwilck@suse.com>
References: <20260522164415.846589-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make the cciss_tur checker use the async checker framework.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
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


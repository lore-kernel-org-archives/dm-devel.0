Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3ED440DFD8
	for <dm-devel@lists.linux.dev>; Fri, 22 May 2026 16:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779468303; cv=none; b=ExV8tj6ZQ1qgKoHelX6/ff0GXnutFsXSXlZ2L9BgfZ44O8ZBrTWYvxEYa9UbW/34CKfFFjn8LNZd0ItOOykwh7/Ux5Btt8gij8/SEFrwjMeVbb6Ki+WbfcX6dXGCrAU5FqnGN4lMquAwSfCUaxT8h/14BIwiqHm8jQ2+unBECiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779468303; c=relaxed/simple;
	bh=VAJq1z3MYeq4vUafCTlToEIxhU6FRgJ6dkimGbb7caY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=llGi7R5v12cR7iCT43Bq20t8qbNYHDFuGzH6gLVz2c2tvT7HRlf3oFJcRjtFZfJdzACXyPP3feq3pV74TdfnwIVBxGOvkmS7yWlQX5AY9kg5FzsxsU8IdcU+91LEEQ1dFWb1In3WZApJ7hcmvSqnB/yKwcTUGtMnIlff0Y0ntBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MVMkcx3U; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MVMkcx3U"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4903fd19957so15308815e9.1
        for <dm-devel@lists.linux.dev>; Fri, 22 May 2026 09:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779468300; x=1780073100; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qmp6tK+hFLBSHuKvGxB07qBVfN3EUQoODyDx5V2if/U=;
        b=MVMkcx3UoByUeQSemtRikJviwxWyvopGb7O7EnQ34aVmKEMZnPT+sxUt67+Sa5NpT1
         +DScMzytr70RHP7cSwomRu7aO2p2ZJMnt5DKaQkvoVVhBE6Hk1tguShuz/XaGarjRiLF
         haR/tsL+VvFltCV3t64CmbVApuDpqdlU1LkmY5S/AngI+fhqq72vu3uHrlU+a+Q39ZDL
         dGJnTeCZb8FOXdBYdFgNTJMmhUcz3jvdI6/npVIMktUFsUP9/dUHPDFDQ+00KL26YUbl
         dzPySlUHiTZlwv/HSTpMWheXsuFElEyo25vFiuexIGdsWSDsMLCG5RPIR51I4Wzoonte
         Xzxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779468300; x=1780073100;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qmp6tK+hFLBSHuKvGxB07qBVfN3EUQoODyDx5V2if/U=;
        b=smUaN9Yv0s1H77ywja8SIgA3yMor/v6Znvn9SHdL6RUNrEAw46FGHvN57zbIIPl06G
         zNsMpt3rB6i8wsI8ukFzZ4+FpWCrrLLQ9U5XnvZyyF0fr/cXeKZGuDfEIUFIbthumxgR
         ThjSmsfTxn5/yX6Zpy2JyZRypERdkDj6YLude5NUa/bfTLdphpHnhtmVp/1MM9pkjbTX
         eWLmz/W0Wkmv9epQDIIVe2GknpPeLknwiljUjRFvV4T1AQtkEgraWtSc8bKZLn13aaus
         tMtiY9dObou3ZSIkebhIdbJBCll0Jpv7Jt2NfY2y4zZgmkaGbVYBMHDwj46rQLO93NpA
         T9xA==
X-Forwarded-Encrypted: i=1; AFNElJ/368L2wF6WObbSFO1Zu2k3s8L3Um47EfV/pWehVNyQbJ/H/rsY1R/+MOWYALAAYxQPBo/ThMfCKA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwTtYeiFXH6/ZwJden6ewKKF5HHGhmJv3nevobKHwVFzjbKf6aV
	dZV66u+mRacr5xkAc5xtDPjAMqd3lvztkF49J77FkANyvLZ59ucnnEfIvD/UPTFRlpg=
X-Gm-Gg: Acq92OFpCEhu1e1W4nQy6iEfeJkv0FRA6Uyt9E5u5Qz7tLi9RuN9AtI50fyAl+YrZN/
	dxMrTFj3IWunJw3Iqudbwe4Xf45vul+WPVOAmZKs3EDOEo28lkdVZt0mC9nXfOARqUKQ7f+elmM
	Btu/z8NaAZpWyFzeyFyrrCVcY5sdPyufYr9EJOOc65v+1mkSfW1quDgRHiwRUc5zCOmkf0muDxW
	Yfzo5qKpKLpRfeu/qmcoUthuCcobFScZ8tv26sABiWCoq+Msc6bHIzfZCzhPXiqZrp7znIjU674
	DTCuxbuhn7wmJ+r4LgStFACF1ONlD4AgG13Rfza8IyTtgriVV3Ydp9VNfqMZPQcarhg3fgC+C4N
	jwOtX9WlZKGqVvpnCb0LaG5RuzBHgb4Hj8gA77Bygw6Qa+XqePQmpv9haOJEnoSkFGMpBozS2b7
	iYM7vIdqmyRghxWb9ahRsvwAfv0YwksblAkxak1vSRH0o+GwyF7Lez7LwU6xUraTKzCU9kavU4f
	c6XvOELmc62pmpRpJJ5Vt78
X-Received: by 2002:a05:600c:3547:b0:48a:7b55:12a6 with SMTP id 5b1f17b1804b1-4904224b05emr66965195e9.0.1779468299991;
        Fri, 22 May 2026 09:44:59 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-49045284855sm47438885e9.0.2026.05.22.09.44.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2026 09:44:59 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 15/19] libmultipath: convert hp_sw checker to async checker
Date: Fri, 22 May 2026 18:44:11 +0200
Message-ID: <20260522164415.846589-16-mwilck@suse.com>
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

Make the hp_sw checker use the async checker framework.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers/hp_sw.c | 32 ++++++++------------------------
 1 file changed, 8 insertions(+), 24 deletions(-)

diff --git a/libmultipath/checkers/hp_sw.c b/libmultipath/checkers/hp_sw.c
index 1ab7909..770221f 100644
--- a/libmultipath/checkers/hp_sw.c
+++ b/libmultipath/checkers/hp_sw.c
@@ -1,8 +1,6 @@
 /*
  * Copyright (c) 2005 Christophe Varoqui
  */
-#include <stdio.h>
-#include <stdlib.h>
 #include <string.h>
 #include <sys/types.h>
 #include <sys/stat.h>
@@ -12,7 +10,7 @@
 #include <errno.h>
 
 #include "checkers.h"
-
+#include "async_checker.h"
 #include "sg_include.h"
 #include "unaligned.h"
 
@@ -28,20 +26,6 @@
 #define MX_ALLOC_LEN		255
 #define HEAVY_CHECK_COUNT       10
 
-struct sw_checker_context {
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
 static int
 do_inq(int sg_fd, int cmddt, int evpd, unsigned int pg_op,
        void *resp, int mx_resp_len, unsigned int timeout)
@@ -127,24 +111,24 @@ do_tur (int fd, unsigned int timeout)
 	return 0;
 }
 
-int libcheck_check(struct checker * c)
+int libcheck_async_func(struct runner_data *rdata)
 {
 	char buff[MX_ALLOC_LEN];
-	int ret = do_inq(c->fd, 0, 1, 0x80, buff, MX_ALLOC_LEN, c->timeout);
+	int ret = do_inq(rdata->fd, 0, 1, 0x80, buff, MX_ALLOC_LEN, rdata->timeout);
 
 	if (ret == PATH_WILD) {
-		c->msgid = CHECKER_MSGID_UNSUPPORTED;
+		rdata->msgid = CHECKER_MSGID_UNSUPPORTED;
 		return ret;
 	}
 	if (ret != PATH_UP) {
-		c->msgid = CHECKER_MSGID_DOWN;
+		rdata->msgid = CHECKER_MSGID_DOWN;
 		return ret;
 	};
 
-	if (do_tur(c->fd, c->timeout)) {
-		c->msgid = CHECKER_MSGID_GHOST;
+	if (do_tur(rdata->fd, rdata->timeout)) {
+		rdata->msgid = CHECKER_MSGID_GHOST;
 		return PATH_GHOST;
 	}
-	c->msgid = CHECKER_MSGID_UP;
+	rdata->msgid = CHECKER_MSGID_UP;
 	return PATH_UP;
 }
-- 
2.54.0


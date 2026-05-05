Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BA8481FD4
	for <dm-devel@lists.linux.dev>; Tue,  5 May 2026 15:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777995847; cv=none; b=dd+u/99K35lAhnGRaUk86yZz+VrKa/eaxowsc0VpR3CmoJrg8B4DaE83SkIH7pkKEPdDDerNfWsWorYJhckIC+LQSHoL+8QsFWM9Ia+ZK6ZfROpsb5ijDqTbA7sq3ZCf8xJoBcUdKZrNLCw+2gwy9EG/QVZXhWrY4aLkPPOAqUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777995847; c=relaxed/simple;
	bh=ztd24/ryESOlXr0sJiebU4Z/iVSFUBK5r9NEhXz25Zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xtnvo7O+0ThSx0FyIlQ5cvRNN6cXG/D9eAxlJWVzN3V3JRIn/t2Rp55dGoho2FD6sUf8qo0YuKIi0bkRSYCcYVug7KtOA6SUC7I2yTNmFs8bTssNceKiaamlQLX2FQEB85nWWXqF9tK9jPy1eb0mx6Y7oe7TZZp6vXQUyZuHjWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=X2puhuJD; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="X2puhuJD"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-43d7e23defbso3081073f8f.0
        for <dm-devel@lists.linux.dev>; Tue, 05 May 2026 08:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777995844; x=1778600644; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X7cU/QgOKi8bhmf9Zudxy5M2a55eUM7JU5Z2NnqGNQU=;
        b=X2puhuJD1l1k4E5A3WQh4+mlnhYfACeYsn5voCQaP9tMnfs9N4Ar3Ih0eauwEMdYap
         MshIWzt8ThSsBPqXNHCHOpkWwqggkWJ7Fm/wytb2R59p9QRmISZggREW1a3iXf4hXm/1
         HikiHHZIzRm7KC/GtjLvI7du2oWF6RUFCyOJzJzPP2iAht/IidoCXhwAdDUTU+8yky5O
         LCopAhYrv0LM43SJEsvE7KEiib3/Rhj/cKxGlbTvjZXLx+D3kvYsuowjXew8s5TGtUBL
         PDnORSOsF6g510WPsTUL61ECalFreaythMbziIhyjFIjMdJklVpJG27moBG3eftbL61L
         yqRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777995844; x=1778600644;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=X7cU/QgOKi8bhmf9Zudxy5M2a55eUM7JU5Z2NnqGNQU=;
        b=eBgkVAd15k/BNQaOiE9egyJvQhfeOcGw6tmtqeYJNswulFzINoca5UBtg3PVPvgk0+
         ysk009weoIKbX4aMLbWyw7aRwRcC1saU7ot2ekl2G33poWHEDTMriKuPflv7VdXBBWSP
         BKKLT8VMCIwvtM542f6pxf6EWEW7m7HATs3mrDcxbdAnbG3kO6EuoQLJn3Q9v/6WzZdN
         SfpaIdCi54puUQHEhYsnf1KhFeggvBJbYCWHei34R6wR6JactAxWnO1emxewQNkpbNRj
         SDXvcBJpBWtVl7VXYPJ3vDWi4/iW09kjk2dqGPkFd9P3uyBB2jC/9Xfy4KFSkbDPqlSI
         WC5A==
X-Forwarded-Encrypted: i=1; AFNElJ8F6P9pbwIcVrTnQ5hnq6P07ezOz+mIbi3wkHz9ubP5GoTilX84BCHT5/KD7AMAvA6tiVKLUMc4QA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy5+sOvIau/qSQGqUxa3czmRMFIM2VWSY4YSYKMgCJTSPl7LEyo
	ts+tSFDmRVXeKH86B01pjTfqT7a/H1cXerhwthor0evhpWhPWXEhMeLGO6prDtQIL38=
X-Gm-Gg: AeBDietT5t1Rz859oZac12pPc6JrSPg8nsSlvYbI0MZ4DynWJAxkDsk3Alntv9QhGHf
	Ag3iVkUBZucPS+aDJFVossHwjSwqmcDV26Ta6gld3NFuubSl+Op+ogcU403owLuhM2U5BGrZ17l
	8PV928Rs180ZrRMNoNQn+klow5EWT4pAuwe/rx1e1XTcchsTxCXYaicms2NMdt3Q2fiD4r9fLXU
	GUFacAPTyZdSDFHYxdOreeCnBKYty/74PXkt3drzjR91mriQQgysGx1GOuBSQiwNTTWoFC8xw+i
	0y762iKh82YdPBbZM5DKKC9eK9ZovXTk5H3ZXt+DQE0xx/hx3SHccySJ71fgw8V7GgDMi3jNGad
	+MdTa5SQ7pQygsHBYgUVNk65LFSx727/XjlD00m2AK8M3ouNLCFV3X+Hb2RTZSwP7Jedo+MuxDB
	Xg6idIxhssFmBtzNBenDmEBlRPh+7Du6UJurRutBTb+SKP1aPJeYQn/9MJlX+GYLXX9P8dQFUXl
	1UdTxXUD65YBqutJ+Y2DCk6M2sIyCWBeqY=
X-Received: by 2002:a05:6000:1889:b0:43d:242:b9bb with SMTP id ffacd0b85a97d-44bb481766emr24851545f8f.18.1777995844130;
        Tue, 05 May 2026 08:44:04 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-45054b03d4csm5769649f8f.22.2026.05.05.08.44.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2026 08:44:03 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 15/18] libmultipath: convert hp_sw checker to async checker
Date: Tue,  5 May 2026 17:43:29 +0200
Message-ID: <20260505154332.448054-16-mwilck@suse.com>
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

Make the hp_sw checker use the async checker framework.

Signed-off-by: Martin Wilck <mwilck@suse.com>
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


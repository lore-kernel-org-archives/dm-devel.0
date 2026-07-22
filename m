Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C944399C8
	for <dm-devel@lists.linux.dev>; Wed, 22 Jul 2026 21:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784754576; cv=none; b=n8Tl1lTt4bGRVUYjLUa9ZD1Li2Jl8COR0k4wQc9O1HYJpmPq/pMVjvsvmqDkW00JijOdMVsFOwzErkKhgX9v0vYrmR1GNfF7mkgl32+5H+wZKv1BD0f4s3RvNP0+H3+xDh/DoahvjU9hjpxZ8BoAj4g5uCpE8QIqglZo5arpJhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784754576; c=relaxed/simple;
	bh=VGvOKuMMQJrTxogZFUUgVFhJ+sQu1xCmZi3yMjvmAQk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pMBtEfzZMJTyAlcGgDlphl/C69tFbIf/4YTJxgXCcZPhEtx+n9rVIFN8ysjF1gnG2Q4QYZYXfYJByMkd+B2KC/0ErfVkxcuOk7CE0x/6EjuLQBkTOOU4RPW/oCTJP7DP5os51qU+2gcQ2jJF0RmsWN82BlBySx/MLrZGhew+5uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BlpWwlAV; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BlpWwlAV"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4954aff6088so39118665e9.3
        for <dm-devel@lists.linux.dev>; Wed, 22 Jul 2026 14:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784754572; x=1785359372; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KPxigAoXKLE73ZVxDWujt50jYJitIiat/S2+RyUqYz8=;
        b=BlpWwlAVsPAu5cq0O4wFyrTCkHnbnoZl5N/2yc0OPSdrv9RFK4IGIoehY+jdeEw/zW
         gkfl/8jUangP9WjUTvVjDKluy4EvniKSRut7iUz6NjcZBdQqrQpPrrB9wbwmQnF1CyCA
         3uXTPfG/3bBzaGryZfFwP/DAleoSw4zQZQdEI4wqBOahq3lmmJ5tcpDo8vSUQz3yxj/4
         TWlz20WYcaTpUYR7/DKQ6Jrjdcs8a1b3MkJdvanQZFiCj+IEw1wH+WWqPaJA7KatbT9l
         wadjAIYQ32U+WiDSywzFTX3tzMR7OimOeAXFaNO+p5p5Sv5XuMBz0W+IHNh8XunSGUmx
         pusQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784754572; x=1785359372;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KPxigAoXKLE73ZVxDWujt50jYJitIiat/S2+RyUqYz8=;
        b=HPrR+9Yj5cgIcMHZTAZ9XVv3wjySppgHLDjFd09NUGuavbJlF1hvhjWIPOTbqI5f0t
         yl7BPfhRu5yTfVBZBWCEI+RLa+ke/7YKtuPeSl5zFZxIlwwGO161N3yJSs2E9e6WtvE9
         MjQJK6vFwFwuQNGMQXNb+MbGUnLRWw95EZHe/KRHgHqMYSRR/RaTc/RzUKr33Q7XDsQ9
         ZNQJHOmXtpNlW0jNAC5KM0Easn9DMxwRODDQvQIbek/V0/sH0PiXCSK7TwLxyfk6yHKH
         ECrR/PZC4KOUa6JNqvaldxmginC+PMc0zamvVV0PMGcHhTPnaxxq9zN0F8jXpFP1Z3Yf
         pAjQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp5OCXVRWmTfLZ15KI37Qkf2byDaGeIwCo2eMwdC9E7aD84HvR1OyqKBertVDa1dnX3LTLQvsDIkQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz7jUbU6P+0do515J1CVXe1B8UOdnaZbbtGRep4NFN+IeWbwJfj
	3qm8arIluvmrTE7R6uf7vuRZLv5CtMUbzsVuxpsR520SBu/3fvS31Ggmr4+Dkz8TnJs=
X-Gm-Gg: AR+sD10mlqmD1i+hbNx6mCpLT0+UxX7Ca2jpWJgTv4+lhY8sLnFTsOe34XVirEXx/X1
	mMI7g63nmgbnKDHwNb1ojk+Lvkn3iKbhLFIsihOnqXkXiw8YftgoS4S6mMVyan/KjrzRTatntTq
	3wa0XJF/ouI5xwglgXEWelj/MD8vVYkCGV38FWimqxoQbVo+u2lJ3FFmsoBEpwQRb2IvbhEdmK1
	cdWBEHoK+gAg1RRzV3cZoYMaqQnFK75B7whtiELm5TqLyuIdmwN64CyoB2pHBkpo4X/KzKplQhN
	KhuWb/cYjVCXxKbERRO+qBOgRgGRNlwYr8PlQb7IG/8ZcDLXFIZHTSCqRyPlVvNr51Nh99QZEDf
	PkV9EhvBTIyf/jGnWZWAKAhIDVPddXBbqGGAoWFijES95icDfcBnVLrlZm2ZGEeVk/PgcL7rEP6
	cL9hHF9O3rG5gvBSKQGdfAcckYLL6wnl0uARs5WFzjk9C6vpkmrVGmiSFk44CsQ14GqQ==
X-Received: by 2002:a05:600c:2105:b0:495:69bd:17f7 with SMTP id 5b1f17b1804b1-49573cf1544mr1707825e9.32.1784754572569;
        Wed, 22 Jul 2026 14:09:32 -0700 (PDT)
Received: from localhost (p200300de37461100f390c52e1c249082.dip0.t-ipconnect.de. [2003:de:3746:1100:f390:c52e:1c24:9082])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-495653bfed7sm187197995e9.11.2026.07.22.14.09.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2026 14:09:32 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH] libmultipath: async_checker: fix sync checker case
Date: Wed, 22 Jul 2026 23:09:26 +0200
Message-ID: <20260722210926.507674-1-mwilck@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the synchronous case (e.g. if called from multipath), the async_checker
code called the async callback before initializing the rdata struct.
Fix it.

Fixes: 474682e ("libmultipath: add generic async path checker code")
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/async_checker.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/libmultipath/async_checker.c b/libmultipath/async_checker.c
index 89b7241..066b009 100644
--- a/libmultipath/async_checker.c
+++ b/libmultipath/async_checker.c
@@ -174,13 +174,6 @@ int async_check_check(struct checker *c, union checker_mpcontext *mpc)
 	if (mpc && !IS_INVALID_MPCONTEXT(*mpc))
 		acc->rdata.mpc = *mpc;
 
-	if (checker_is_sync(c)) {
-		int rc = acc->rdata.afunc(&acc->rdata);
-
-		if (mpc && !IS_INVALID_MPCONTEXT(acc->rdata.mpc))
-			*mpc = acc->rdata.mpc;
-		return rc;
-	}
 	/* Handle the case that the checker just completed */
 	if (acc->rtx)
 		return async_check_pending(c, mpc);
@@ -192,6 +185,15 @@ int async_check_check(struct checker *c, union checker_mpcontext *mpc)
 	acc->rdata.state = PATH_PENDING;
 	acc->rdata.msgid = CHECKER_MSGID_RUNNING;
 	acc->rdata.afunc = c->cls->async_func;
+
+	if (checker_is_sync(c)) {
+		int rc = acc->rdata.afunc(&acc->rdata);
+
+		if (mpc && !IS_INVALID_MPCONTEXT(acc->rdata.mpc))
+			*mpc = acc->rdata.mpc;
+		return rc;
+	}
+
 	condlog(4, "%d:%d : starting checker", major(acc->rdata.devt),
 		minor(acc->rdata.devt));
 	acc->rtx = get_runner(runner_callback, &acc->rdata, rdata_size(acc),
-- 
2.55.0


Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764AF39B498
	for <dm-devel@lists.linux.dev>; Thu, 25 Jun 2026 16:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782403341; cv=none; b=mq3Fhcn9NRZ0leuPnhABzT2O1BwzwmiUCnq2m3cnoOEhqgtuO01C0Dz/zZfMid0fZXnX0FavoU9PABKwFnbzj5OLpJhAfsr/n1Eb3k8SpQ58bh3xVF6dHuqQjSSaTknJc+p4Y45JocoFN0S4+G87QfFUcqj4msClSQjdHQ/qCVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782403341; c=relaxed/simple;
	bh=eaqj8URKfq8DmYfsaslkfb03lqZZJVtsZR19R3MEXUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AkwCfL3ZjGVqEHG+rmmHHJ6n3eSQ/NCOGwN6OraRS8MW5ynnAecKfCjKtKPn1YD2eashxwMHMHlZa0mO9yxaTg088snXnlDH1U0hehBh4bwlzH15OaKUY0fYCZzjJVUJ5JvKZiJof2kctV13iN2bPP0weBT0gsBYygJEHapW/j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fHz/LSLQ; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fHz/LSLQ"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-461edb387ddso2654836f8f.3
        for <dm-devel@lists.linux.dev>; Thu, 25 Jun 2026 09:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782403338; x=1783008138; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YdLKgYvbOGsenCXaI0lEAwsNcjNLorIPcJYalTWcGTk=;
        b=fHz/LSLQ0fZZXvddUwmdXG2e36JtsKHfen+Ox33VMDjfQlysIdKZJdfQdw9Ea3+ZRb
         dUiDnPfPl5CI5J4rSvvn7XUX1+SYe8Efy1Qp5SWqq0UGfNprgznE8i4/41gSvwjiMI91
         rlWKbM6NVnIUKJH/W79C25RvWkB24b6J4jQRfYmh6O4IF2YNULBpL2VkPrDEOLmGvvn7
         Bx6Mv9geHJX/uQOMWgR0cM5m9Of/q2yvUjzfaigmDBKrd1nDFKEnpZYdpieKWat1G5uO
         RXEzA6rZtfncB9K1W9jSMFU60G4XNeqfAYxFnE4uvuUGkhyZeoxdSz4m1l/z5WgwleZg
         JPxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782403338; x=1783008138;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YdLKgYvbOGsenCXaI0lEAwsNcjNLorIPcJYalTWcGTk=;
        b=B2NgMJVV6UrOH5GzkUNO12QNITHHI0ANG5uXi/ISM3mI7Mc9CrgpDQOGS50uunzC30
         xX6DqvWGK7ZJtyNdL+4gDlHUYZVB2qr4aL26olEiOuT8BjE1WxXtlOgPbv/o6ZWj3elX
         xZ5Ciq3NNyMIhmwv8bhqM8d1M6JkpVktqewQGyK+mnAlhMZZQgy/9bXSKUJhVMPZiBl/
         kLaKD85YQk2gTtudKnBPhQtv/Y7PHVn4JOa28b1wFEdrEEMGnERaVEuNLheynunizqDD
         Ao9ghzSSOMVx8T0WnUcgBJlTfjyfTqf1FOVpbnHFZPunYL7OnekwkInNc56gzTzJVFyh
         Mlmg==
X-Gm-Message-State: AOJu0YzTlFT2TyFj5HJ9l9WRciS84AwEBBxQViOTBiWxdJVWmGcbZaVI
	GAQV5oPcv4SgNAP8Q3jyixVLsc85CQZ2JIFgwhdo/AybPQgI/O3Ikhw6AT6cis2V9ow=
X-Gm-Gg: AfdE7cleHtsW3ll8bR0bEDyEDDwwzUtymmz6UBewbRXla0rFPPS0JQ1RFjv+YBwu3Ci
	uFEv88iJNnryBtG6jcK52NZRjfRp9M+Q3fkBIhodqcLVhB0gvQTlby8xdSR4N0iB2ServPwYWGG
	WnKSaWX83uXyClzM4cYq+UDnt/td6dw68aht3pTtIHwcvBB0pZie/TDC7jN0/nom/djNDBNrEo/
	2lHk5kApXRNHYQokZg6slqn3BlZu31IWda1e0AsLd0AS9hXEEeaboCTNzTYK31CcJ4GAE/a/UrG
	KjrqgdmYehMDcabIedCt+HYiN04gPAXJEBz6T3gO4qdB1Jm4XQLY7cGKh6uljuXqrS0MRltfva7
	/cmrv7W/a0cBz0u9u6rIBxtd4KX2tXXe6rmMxq8V9LAGL21yiwYQMlxTlP924MxPoqCRSa1aKrw
	9L/mSSzOA9NCmxZEmCZ/4ObOPQIiiruCpu9BLgSx/1/nVuKfCNRGFHna5fGOTArwSAD58r3N/Ms
	SrRHfRtC+Dn6Q==
X-Received: by 2002:a05:6000:420a:b0:46e:47a:dcbf with SMTP id ffacd0b85a97d-46e047add1fmr4366171f8f.1.1782403337504;
        Thu, 25 Jun 2026 09:02:17 -0700 (PDT)
Received: from localhost (p200300de374611012220024a9e5877d9.dip0.t-ipconnect.de. [2003:de:3746:1101:2220:24a:9e58:77d9])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-46de7effe5bsm5160761f8f.5.2026.06.25.09.02.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 09:02:16 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 2/4] libmpathutil: runner: avoid segmentation violation in pthread_cancel()
Date: Thu, 25 Jun 2026 18:01:58 +0200
Message-ID: <20260625160200.3318088-3-mwilck@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625160200.3318088-1-mwilck@suse.com>
References: <20260625160200.3318088-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SISEGV has been observed in the runner test in our Gitlab CI with
MUSL libc. It can happen that a thread terminates before pthread_cancel()
is called, causing the error. Avoid it by waiting until the thread has
actually been cancelled.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathutil/runner.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/libmpathutil/runner.c b/libmpathutil/runner.c
index 56abd03..459af13 100644
--- a/libmpathutil/runner.c
+++ b/libmpathutil/runner.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 // Copyright (c) 2026 SUSE LLC
 #include <assert.h>
+#include <sched.h>
 #include <time.h>
 #include <pthread.h>
 #include <urcu/uatomic.h>
@@ -47,9 +48,24 @@ static void cleanup_context(struct runner_context **prctx)
 		return;
 
 	st = uatomic_cmpxchg(&rctx->status, RUNNER_RUNNING, RUNNER_DONE);
+	/*
+	 * If it finds the thread in RUNNER_RUNNING state, cancel_runner() sets
+	 * the state to RUNNER_CANCELLED before actually cancelling it.
+	 * If the thread terminates between these two points in time,
+	 * pthread_cancel() may access a pthread_t for an already cleaned-up
+	 * thread. Therefore wait here until the thread has actually been
+	 * cancelled, after which cancel_runner() will set the state to
+	 * RUNNER_DEAD. Whether the thread will actually see this value is
+	 * implementation-dependent.
+	 */
+	if (st == RUNNER_CANCELLED) {
+		do
+			sched_yield();
+		while (uatomic_read(&rctx->status) == RUNNER_CANCELLED);
+	}
 	if (st != RUNNER_RUNNING) {
 		uatomic_cmpxchg(&rctx->status, st, RUNNER_DEAD);
-		condlog(st == RUNNER_CANCELLED ? 3 : 2,
+		condlog(st == RUNNER_DEAD || st == RUNNER_CANCELLED ? 3 : 2,
 			"%s: runner %p finished in state '%s'", __func__, rctx,
 			runner_state_name(st));
 	}
@@ -116,6 +132,8 @@ repeat:
 		break;
 	case RUNNER_RUNNING:
 		pthread_cancel(rctx->thr);
+		assert(uatomic_cmpxchg(&rctx->status, RUNNER_CANCELLED,
+				       RUNNER_DEAD) == RUNNER_CANCELLED);
 		st_new = RUNNER_CANCELLED;
 		/* fallthrough */
 	case RUNNER_CANCELLED:
-- 
2.54.0


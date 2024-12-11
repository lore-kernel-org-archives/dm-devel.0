Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967D61F2394
	for <dm-devel@lists.linux.dev>; Wed, 11 Dec 2024 22:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733957985; cv=none; b=SIeXfVoHpHE+zYCOiXPFYnMPeKr71Xnq3VIxiqXX4wJYtJETTQonq5oDWdwjEiNAZvryHDP7ktCmlgEA1ANO0AHVJQ1VNChVlB8BR85jDO7WhQIo6qusACTruUeAX/S9rzjj8KkVULOwoWixpkZaAduGM3Rh4N0ETyLAUfIsSgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733957985; c=relaxed/simple;
	bh=zncBeVa8SJWxODCBY1Fx2i3v0RYUtVqoIOxZUS7scL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YRr9vwEidFzyLXI2ZL8BWFLwigxXVKxnWPpKpG/ses0pTXw9T82QwWFrA50zQ7vu0vYwWHLw6e+vhd0u8CheB25J8gfh7Pf8LrY18gDRFpDcEB1CrWG72Vtud0gzK8OQk6aCoG1oG7h+w4ErgrSHSbP3K55TcrteIUI3uV++8Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NIqjiL8g; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NIqjiL8g"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-aa6c0dbce1fso85264066b.2
        for <dm-devel@lists.linux.dev>; Wed, 11 Dec 2024 14:59:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733957982; x=1734562782; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tQjmMhXldlZfCr+r3PXIrFVNcMpsrmW+liwWSbOQGIU=;
        b=NIqjiL8g+VPzk5KP6+Bqjmcg73buPZnl+y9lVz8iZxLTx8bPtxmlBAJgrVlzr9XxXV
         JLQn7JNiGKt1lZ+rwkvh0ffJMH3w/e1tmjXPyD/IJVGibj0Fx6m9YKgISIRhiDljQ0ZL
         swfSnj43MFGhfYbknpsxJJH4srPScksaC9BDs9WT6Su72uhc8PVB1SEJRRMbCuq2uL81
         Ld+upCn9+hBSO7+MTuhTwU6Kct0vIC2JvI0cI+teZV0sUB9HYNBcxVtu9wKbe7s19D32
         eUMJ/EMxqBvpmEaR0OpMvBLhF7r8uXcAYiZwVbB8HLD/1g2s1NpsCAfM3zJS83lPujel
         cTxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733957982; x=1734562782;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tQjmMhXldlZfCr+r3PXIrFVNcMpsrmW+liwWSbOQGIU=;
        b=sZapi/vCNEedAmL6vCwun9QWdP9o3zmLJdApJP2LpxfqYiyXs0m6s/wew5wd5ZJD3W
         RUL+2yHfloJjeV0m4b5xUlzcazJN0DeDA/LpIlfnJkhJvWaSY5PVJC9/Vb22HwKQzh1g
         Kjs5WqUJyNzLUo+8LF8XB2h26NeM4lV2yrlMtlPN/xD6YwP6NuPCF5hP/fJHKY1NAlb+
         deJfAw5TjwtiVuTgGHOCFsaHd3RlTWqX2Un7TMCmQbBvnWaKxQOgtpYuG+XCasWswBo/
         bSCRTrWOrW8zRezB7g8Ytu88myOUGgxqGxpDPNjD7EmgttAWy6pklWIUhhHnXyiL9kdq
         3dEA==
X-Gm-Message-State: AOJu0YxGGGyu0SUEf9HA89WevUtxKcZrSZJJ6g9I6h3kbPOVOndN/ei3
	KmB9WyBFTABpOgr6UtCtvvRgOCoAy8mDU53KtsBsJOcEl0SZJ7sDR3Gg5PVCrqk=
X-Gm-Gg: ASbGncvT1kWPAHf/IzuyKnNNeDzjBetUgQYnH6u4N7HpnGKBL9B3TY6rflcPNpT4MCM
	wYhG6L+D+4+M32CA6E2LqohY8YUwRcsIBy9NGe6QjVdz9q1LryG1wU+t8Pwg5sb0yuqMH5dPuf7
	eGJ6Fs7AIsWJkCdslf0Ga5CrNMNIHD+RUsKNzUIIc+kUJAbt+0D25TNK9mJzpmyb7q4xJ/5wpeA
	wAXKmzi2a9VoyoKCUvP3QUK1I21NG+HHFWNkWfwkzvj3TN8buGusIqLvLDeZdYdlzfz+ldC3MBU
	wzhZ0XCu8x3+nvc9gZ+bo90tHeqW4SzBGy2jw4fK
X-Google-Smtp-Source: AGHT+IH6AC0NxXfdEUTsALHhZnmVa8WPlU7QU++eNJ9JLA9Dmam2jCM/pOutRC7HEBf4MrVWVkhVGw==
X-Received: by 2002:a05:6402:1d4f:b0:5d0:d91d:c197 with SMTP id 4fb4d7f45d1cf-5d43314d454mr8722180a12.27.1733957981459;
        Wed, 11 Dec 2024 14:59:41 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-aa69964876csm413299566b.49.2024.12.11.14.59.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2024 14:59:41 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 04/14] multipathd: quickly re-sync if a map is inconsistent
Date: Wed, 11 Dec 2024 23:58:59 +0100
Message-ID: <20241211225909.298770-5-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241211225909.298770-1-mwilck@suse.com>
References: <20241211225909.298770-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After reading the kernel device-mapper table, update_pathvec_from_dm()
sets the mpp->need_reload flag if an inconsistent state was found (often a
path with wrong WWID). We expect reload_and_sync_map() to fix this situation.
However, schedule a quick resync in this case, to be double-check that the
inconsistency has been fixed.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index e4e6bf7..178618c 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -3026,13 +3026,22 @@ checkerloop (void *ap)
 							     start_time.tv_sec);
 			if (checker_state == CHECKER_FINISHED) {
 				vector_foreach_slot(vecs->mpvec, mpp, i) {
+					bool inconsistent;
+
 					sync_mpp(vecs, mpp, ticks);
-					if ((update_mpp_prio(mpp) || mpp->need_reload) &&
+					inconsistent = mpp->need_reload;
+					if ((update_mpp_prio(mpp) || inconsistent) &&
 					    reload_and_sync_map(mpp, vecs) == 2) {
 						/* multipath device deleted */
 						i--;
 						continue;
 					}
+					/*
+					 * If we reloaded due to inconsistent state,
+					 * schedule another sync at the next tick.
+					 */
+					if (inconsistent)
+						mpp->sync_tick = 1;
 				}
 			}
 			lock_cleanup_pop(vecs->lock);
-- 
2.47.0


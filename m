Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6262E1F2C2D
	for <dm-devel@lists.linux.dev>; Wed, 11 Dec 2024 22:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733957990; cv=none; b=T6SYbhvhoShOT4K1tnc2ssPDa3k1V0HNfXi2z5kpG3UFzRuNH7k/IneHVUkrNymWlvBEqzN9M8YWcAiDwf5LAhUUa+FtbhUb5HLTu04Do49kriwWkzqoMXIMKtTQqAWNOGjjt2GXpEoVULJJlV6a9hGlRo+EYSCOfBw5vlh7nUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733957990; c=relaxed/simple;
	bh=7ZUl6FgR/tl5QNU+kXQEL7okRsYOu8qCL+A3EsrOLtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1H9YhnhccStbFRG9n2r17+2gF1Cs1/u5SOAEep4YfHCH/G1iIVY2Cdr+lCAg/3WZ0mRmcAzcUfh5TCrbfFmq2mHsIqHuZazU12icF31rnueb0gWM59TInNFQ5V/wcjntIgOryGi7kg/Ua8xWos53eXLaxv3mlu0e9V/VvLNkvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FINHeXbm; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FINHeXbm"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5d3d479b1e6so6801923a12.2
        for <dm-devel@lists.linux.dev>; Wed, 11 Dec 2024 14:59:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733957987; x=1734562787; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e14Lv8nc4fRhxyCBghAJKcrG0BjGt30r8PrfS67+ltM=;
        b=FINHeXbmmb2PqTGk5JxzqIRnT2Z3kf8T4ZHNl7uZD39pKu22sudNfYGKCWarj0Uv61
         gPQicgwj66Mj6IWA8fIxAJgb0z0LtqMxk3S4D+7+iteNIl/YfY2UgWgMc217cAhDfOwx
         SXoFwVFLrZHE0SakmBuXzr6YIrDgEQfexnZizZOvVc1wMIsybLKDm/jKZTEakRcBwjbF
         BeBsCWTxBAKQr9lGDcTX1u7Z+zM0sYj6veKDyt3G51F6kCgxYCPmt1fPMvVuKV5y8FNA
         wbkiWJnYeRRqmSeKgCcfsRyz0cSKbTFghSE8zjqQZtay7FcQC0b/qCfWBHlwBoMYOdQk
         shaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733957987; x=1734562787;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e14Lv8nc4fRhxyCBghAJKcrG0BjGt30r8PrfS67+ltM=;
        b=j6WXREn5zKblCnmJaN0bMVB9VJZDSXwhnPPspBpCmoZ6oL8QrWiD86fvDq0zTnblQ0
         7lmJVHHhbi/dIc1XSP9vVE0sJfvb4TXqGnmNcEaX2HQfH0VQD40cfLTve41Aat1Tzrdd
         tAawX1bAFfVBuwNlkQbzkBgOzJ1f1LWbNJ6SJPJhzHluHrhVBA2iztw8pxSmNl0eFRve
         Cz07YJ4ibRH+MbbSTN/sVCz0hSdehvX2t3N4w+Es/BW1gxredqRezqtOySbTQ8sC+6of
         mz2xr9lgku1/3f1Zdki1Oo1zI4jkyM6e1HiA+nRXxPD02FR10Vjd4VaXWtDcqbjTF3Hg
         MSxw==
X-Gm-Message-State: AOJu0Yys5v5x2DQh/KgGlzdu/qCEOJkEgl9dNb1y4fwbqUzYvZpFC1yd
	rhSoq5n8NXADNXQ8wBMFQBg4U7n8aKh/O3h3t01bPFZprjwAF4ahwruxFOFR5q8=
X-Gm-Gg: ASbGncuTkqiRw8IKL0lZuUjSdqMhbzJgSKV4EOOD8COttY9TtwFcICQg9rQzFnrNePR
	n+bOkRN3DvJFWcWKSh7n4TK2Aw9y/rEVI3t3VMeojhy9kLX54DnOLGfhlSzi3ju1I5jimG3lT11
	iPC4v4LMViO96lfHHtlVJDjvBMFDLHZAHtgGS8tavjZwjtN+EzZAvxNeJmZKGEQ2OGjpnq4DS96
	teqTz7wf+sZtxj+XaPeWrgp3iX6P2RlqlKmRr5C6p2SGexIBZeAp+kWYKGYBjhlJKAMtCaZG0G+
	hnJ/Hz0PSxRDjJF8q7CASgUagfBd3SeE32OEjAkp
X-Google-Smtp-Source: AGHT+IGfcmb0XIXsFy0Chghso6WzsNp71Y82/UYQbt1LEeU6gn/cQVSAdYX8AzHynyFLUQYkqugykg==
X-Received: by 2002:a05:6402:1ed5:b0:5d3:da65:ff26 with SMTP id 4fb4d7f45d1cf-5d433164c3emr9318824a12.31.1733957986349;
        Wed, 11 Dec 2024 14:59:46 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-aa685b6cf77sm535863966b.83.2024.12.11.14.59.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2024 14:59:45 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 08/14] multipathd: don't call reload_and_sync_map() from deferred_failback_tick()
Date: Wed, 11 Dec 2024 23:59:03 +0100
Message-ID: <20241211225909.298770-9-mwilck@suse.com>
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

Instead, move the call inside the existing loop over vecs->mpvec and call
reload_and_sync_map() from checker_finished(). Note that we can't simply
put the call deferred_failback_tick() in the "if" condition, because we
need to adjust the ticks even if update_mpp_prio() returns true. For
consistency, use separate bool variables for each condition that would
necessitate a reload.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 39 ++++++++++++++-------------------------
 1 file changed, 14 insertions(+), 25 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index b045f8b..b1f0f81 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2076,32 +2076,20 @@ ghost_delay_tick(struct vectors *vecs)
 	}
 }
 
-static void
-deferred_failback_tick (struct vectors *vecs)
+static bool deferred_failback_tick(struct multipath *mpp)
 {
-	struct multipath * mpp;
-	int i;
 	bool need_reload;
 
-	vector_foreach_slot (vecs->mpvec, mpp, i) {
-		/*
-		 * deferred failback getting sooner
-		 */
-		if (mpp->pgfailback > 0 && mpp->failback_tick > 0) {
-			mpp->failback_tick--;
+	if (mpp->pgfailback <= 0 || mpp->failback_tick <= 0)
+		return false;
 
-			if (!mpp->failback_tick &&
-			    need_switch_pathgroup(mpp, &need_reload)) {
-				if (need_reload) {
-					if (reload_and_sync_map(mpp, vecs) == 2) {
-						/* multipath device removed */
-						i--;
-					}
-				} else
-					switch_pathgroup(mpp);
-			}
-		}
-	}
+	mpp->failback_tick--;
+	if (!mpp->failback_tick &&
+	    need_switch_pathgroup(mpp, &need_reload) &&
+	    need_reload)
+		return true;
+	else
+		return false;
 }
 
 static void
@@ -2973,11 +2961,13 @@ static void checker_finished(struct vectors *vecs, unsigned int ticks)
 	int i;
 
 	vector_foreach_slot(vecs->mpvec, mpp, i) {
-		bool inconsistent;
+		bool inconsistent, prio_reload, failback_reload;
 
 		sync_mpp(vecs, mpp, ticks);
 		inconsistent = mpp->need_reload;
-		if (update_mpp_prio(mpp) || inconsistent)
+		prio_reload = update_mpp_prio(mpp);
+		failback_reload = deferred_failback_tick(mpp);
+		if (prio_reload || failback_reload || inconsistent)
 			if (reload_and_sync_map(mpp, vecs) == 2) {
 				/* multipath device deleted */
 				i--;
@@ -2990,7 +2980,6 @@ static void checker_finished(struct vectors *vecs, unsigned int ticks)
 		if (inconsistent)
 			mpp->sync_tick = 1;
 	}
-	deferred_failback_tick(vecs);
 	retry_count_tick(vecs->mpvec);
 	missing_uev_wait_tick(vecs);
 	ghost_delay_tick(vecs);
-- 
2.47.0


Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FA01A9B52
	for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 20:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737145682; cv=none; b=uf4fd1ibxiMSy4SoX+4t3EXiAN2PO+v0TTltcLVTLuc0YFPpiSlc80iM/etp6cvCQ8/B4m+zMciK/XzhT72IDr3CNL/jLYUzHeGuebvLWEGMwAzZL1SH6I/jybaW4hkHgNehcvSexB2eDcD/Mi3QYEq3nintG/Yx9ofBSLOyaqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737145682; c=relaxed/simple;
	bh=2xmApSNY73wVcjIg9Xipl58QMg975cjU+ilKCEQbUW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=klSj3/ZbXh0DscXf1SWyo5+qs1VIUodzMuTLoKTqZvl8vb9/0THVR2xALfRkvVfILOYM30oqAtpUSQr9BJY8yskFg8E2hD6sQlaiQ+qHc4efz3Q4kF3xcAZ9McMn33Hqpi6ePBlZNGw5qtm9DPyo16363i5EoT2Jxl/F73hoA6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=X2xVyPCh; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="X2xVyPCh"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-38637614567so1265699f8f.3
        for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 12:28:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1737145679; x=1737750479; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z/lHZv7D6PTcIHR09f+jlqhvya3sYOoetOQz0YobJJg=;
        b=X2xVyPChvlMRgmPQtfdC8wsqPpN4fhwoDEtr+Ob7M92LtzPAJj5gI9w7OEcydTj60I
         U2bnabESsUSbSrp5ym8FCmiILRgd2hNx9w+0HkwA87okvUmlN4I9+kClGcRNNA8hYE8c
         fFv515mMB4lfI/3qdXt8oj1MHQmc2IubFOo9m2hmNUJreBBcQZE/mE4My4f60X3XyH/4
         cebMkozEWffJeJfBSC0SIKvtBjyLKOt100iGCUH5NaI8CVHfckoYEG/e3cZbUXIalfV7
         OBypwYCKfmDSTlABfdFrJk31oE9/lDOTnSF1NyJWpvxQi8ae1AEm6NEFXZ9NhNIteoVc
         I9ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737145679; x=1737750479;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z/lHZv7D6PTcIHR09f+jlqhvya3sYOoetOQz0YobJJg=;
        b=eqqo/Dj6kGwvw8b5fMV18sTTy0KE+Gi5klf69ApTPdRxtBb7yX62qXXwFt3lQjRFF9
         r13orACOhGsJAnsi9H7etWlPTAFFVATSwlTDCRkS7LwrR2nNRxgbQpZOqjzWpzxsq19s
         6tYQS1eOJQZZPaM0kO+tYHqq10rM1Y08OLSQOMewJjpSgj6yPdIORajqO8ElDagF3ldf
         V8LwEjjlGP2r0EDj+h+QAkV+vn7+JJqUXCbCGBcasFtpCZ4a3T2GqjRVvXVmPc9IF/Oi
         /6wZ2j2DYce9ckFf7UirtKtx+1dUCRB4t9NGFdBJqucgPsS47m24/WTDyEpaQk6xHpqh
         2avg==
X-Gm-Message-State: AOJu0YxWKenD2MROTx7cRw5tB99gWyZFgjqKuWAp+fkxcjknTlWQIi5J
	rkv1FXm0tDQL6PHDe8lZbw/HW5p3zVLf35Q5Vh793TwQM/XHZyOpbLm3PTCZYOE=
X-Gm-Gg: ASbGncvW4DUkY9F0YILECFHb+Y9Jj87D3T8ZfnCEBfeamaTm1rcaETysEYhMBisWk0U
	4j2br5FpvNqbX9qqheBKYLMDsy1DEE5EF+i/2IGiTDw4n9eOW8WqshH84v9FAoE/cSRRH5HD/I8
	wuTsHR0J98GLWwiagWb0ckozjNsI/TrGxzwJ7IXko6iXAGN3ptJ02IpmZ8TTWwMAxPIxVL4T4zm
	g/lSS7YuO6sN4Qz/TQ6DNaq3LAHQAYp28RMiu51IIODIT0sHdwzvEYSiNUwBZAE5qG1lgHn/Z2S
	RA5TqQJRe++mq6YaXpP7coQD7JYgScvveqrncguQbvc=
X-Google-Smtp-Source: AGHT+IHVbQcyKhboT2hSLsr992t2n3c53v31iLA1IgGzpbKGwT9AF9jjG5+nD2NMTTjLkRPLyR6cNA==
X-Received: by 2002:adf:f4d0:0:b0:38b:f4dc:44a9 with SMTP id ffacd0b85a97d-38bf57b3ba6mr3651376f8f.41.1737145678990;
        Fri, 17 Jan 2025 12:27:58 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-38bf322ace8sm3374808f8f.53.2025.01.17.12.27.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2025 12:27:58 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 07/15] multipathd: move "tick" calls into checker_finished()
Date: Fri, 17 Jan 2025 21:27:30 +0100
Message-ID: <20250117202738.126196-8-mwilck@suse.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250117202738.126196-1-mwilck@suse.com>
References: <20250117202738.126196-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The various "tick" functions will only be called after CHECKER_FINISHED
is reached. So we might as well move them into the respective code block
into checker_finished(). This way don't have to drop and re-take he lock
when all paths have been checked.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 988c82c..6df8769 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2988,6 +2988,11 @@ static void checker_finished(struct vectors *vecs, unsigned int ticks)
 			condlog(1, "BUG: %s; map remained in inconsistent state after reload",
 				mpp->alias);
 	}
+	deferred_failback_tick(vecs);
+	retry_count_tick(vecs->mpvec);
+	missing_uev_wait_tick(vecs);
+	ghost_delay_tick(vecs);
+	partial_retrigger_tick(vecs->pathvec);
 }
 
 static void *
@@ -3062,16 +3067,6 @@ checkerloop (void *ap)
 			lock_cleanup_pop(vecs->lock);
 		}
 
-		pthread_cleanup_push(cleanup_lock, &vecs->lock);
-		lock(&vecs->lock);
-		pthread_testcancel();
-		deferred_failback_tick(vecs);
-		retry_count_tick(vecs->mpvec);
-		missing_uev_wait_tick(vecs);
-		ghost_delay_tick(vecs);
-		partial_retrigger_tick(vecs->pathvec);
-		lock_cleanup_pop(vecs->lock);
-
 		if (count)
 			count--;
 		else {
-- 
2.47.1


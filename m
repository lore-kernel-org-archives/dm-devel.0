Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875821C548E
	for <dm-devel@lists.linux.dev>; Fri,  6 Dec 2024 23:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528217; cv=none; b=eY9w3TscfZAupth1lQV7bSH8r8ifU8ph4gIUp52b+BSdJH+EacMzMtZuDXamDM4cfQYkacsqlJtD6eZ0ZDonh01uSeYBRE2xS66uXUZU+BBflyMUUTgi4HZToJ1bpAepPR+zbutnaMhIoY3c7Oe0VtCsAOAhh7+0R683+PmoPXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528217; c=relaxed/simple;
	bh=pMVMuBzDze1MWK15sIgadvckJC/NFQmCszLmIKyLMBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=trj3/EZdmRBgt86MixwCa/FgLEZt1KC8EWkOcybkIVGdyN+SP1AxV9YCuGZTMpcqoeBJMiCMul7xinZHmgaPN7RGUJly4RfIjh0FklogJj997nCT/dwjdYYMROjWNGoG64P4EgHrVdhRztR/QJ2M/0fmSGoMkRNN0Y6lnD3H05I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gtYqZwk2; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gtYqZwk2"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5d1265ba5a8so2873906a12.3
        for <dm-devel@lists.linux.dev>; Fri, 06 Dec 2024 15:36:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733528214; x=1734133014; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HiNL2RQ+pkTynN7quJ/s9dBLGd1J9lVKVh86hlt8Mm0=;
        b=gtYqZwk2/t2gEaXK3t/kzZPpBIljQLoqCzy5EIXv02Vr9aK57uAIJka3I2gIsOIvq5
         8HdlDA+PGzBZ7SeHGOA7d4W0xzpX1QGxjb30xD9AjWJTailfWWQVe6wAhzZ/icdZn8eL
         Rnn+7eZ7B5P2nE1nwB7dml2rJlElz9iK1e9I9WnGKGD/6c2nCQXyBAchYqnECzx6SWVs
         WGuLVI7H8CP/t3mB+WkNGyR0jwfrt9ribUruvkfSzRBTpR/GP5GlxOl6C4aHqS64dhUJ
         ck8+tlPKaSpviTsuY8yvZzw7X+Wtze1KYafwgr66b9bkR9keJAN1IEggEnELeXAQNL5l
         bW+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733528214; x=1734133014;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HiNL2RQ+pkTynN7quJ/s9dBLGd1J9lVKVh86hlt8Mm0=;
        b=w9pi0Y0HBzxBtPo1DFaylQmkn6B78kGBrECMGE7sWwG5uAlb8MwnW2x+PkxjnXR30v
         +sQlSqjCOTqfFdVQFAlPguyKLBZIXh86VWaBxV8aaNlUnaDwLWC4B503i79l3kg+hCFi
         hb1ZCnsUrhBlLPj6UaWTMCxJ0/pDUxt2f+LixoX592dL/1MhPJhmWpGKk7htXePy/P/a
         sUP7Z+Jzs6r81iT/zsypCi5wT7mxrRVcJyMNrLreumpyNleL9mt0ficdzoANnUhtIsXf
         B6XoBh4fogO+3XMlhqkRscJuTBZ0Wf6L+gBmFtROGpb993sHK7b57xYC5awqPoc/+gxI
         HKjA==
X-Gm-Message-State: AOJu0Yw7tZEBgMlgCEcN8iPoItRhaDg+e/5tGAeXXOAg/AxdDov/idbz
	A0Z/tCTJAcSGC/K2Jv+rA5SeRyH+6L2ym4EFt7/F70f9gTbO0fZnojfMDuv1BYs=
X-Gm-Gg: ASbGncvxCNi19B2TnoL2i/ZCF7Yhr/UscE0KvrRspUxmgxB8Rpngrfts5+4Nv9CY9xw
	ufwzg7f2CD3PySvzSnc7otyJRneajuaLpAcT7SwHaRjFptoIxuJnK9FGOn4a4f+o07SefYFrLXO
	J549Wlj2CDbufCztm0Wn5hyNLUr7gI4V+78zinI153RIXOrWBsw1MYL2IDjiaXvqUGImbe4eeec
	TNQBdfgzxGzQyQDDD4lZ4RKoH8SI2ixWvCieLW+ol+1VDwNDrPJwAq7wavDlJxI7TXyHhGzQMAq
	r4b8JgkMOHrWXLzba8+JfexgHj+Ak+kYbiK4
X-Google-Smtp-Source: AGHT+IHSAbrQQnEnp+0CE1G8V6XR/LmWF+w06c5oy/GyyraD/m/5A8qlf2xqq68mVNKwkbjmmeY6Rw==
X-Received: by 2002:a50:9fcf:0:b0:5d3:ba42:e9f4 with SMTP id 4fb4d7f45d1cf-5d3be6fbcc0mr2862900a12.23.1733528213669;
        Fri, 06 Dec 2024 15:36:53 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-5d3be740b07sm1622616a12.70.2024.12.06.15.36.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Dec 2024 15:36:53 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 09/13] multipathd: don't call reload_and_sync_map() from deferred_failback_tick()
Date: Sat,  7 Dec 2024 00:36:13 +0100
Message-ID: <20241206233617.382200-10-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241206233617.382200-1-mwilck@suse.com>
References: <20241206233617.382200-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead, move the call inside the existing loop over vecs->mpvec and call
reload_and_sync_map() from checker_finished().

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 36 ++++++++++++------------------------
 1 file changed, 12 insertions(+), 24 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 43f6cc8..8425354 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2058,32 +2058,20 @@ ghost_delay_tick(struct vectors *vecs)
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
@@ -2967,12 +2955,12 @@ static void checker_finished(struct vectors *vecs)
 
 	vector_foreach_slot(vecs->mpvec, mpp, i) {
 		if ((update_mpp_prio(mpp) ||
-		     (mpp->need_reload && mpp->synced_count > 0)) &&
+		     (mpp->need_reload && mpp->synced_count > 0) ||
+		     deferred_failback_tick(mpp)) &&
 		    reload_and_sync_map(mpp, vecs) == 2)
 			/* multipath device deleted */
 			i--;
 	}
-	deferred_failback_tick(vecs);
 	retry_count_tick(vecs->mpvec);
 	missing_uev_wait_tick(vecs);
 	ghost_delay_tick(vecs);
-- 
2.47.0


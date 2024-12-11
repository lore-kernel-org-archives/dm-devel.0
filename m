Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45CD1F237B
	for <dm-devel@lists.linux.dev>; Wed, 11 Dec 2024 22:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733957987; cv=none; b=mgkQ1me/un/gcmCRrUtkrkiHkadWa7nLA9Y8Z5yWl6L85KE/hfooA5pJvj1MkaYamSyLqWsJeZQIMWOVCRBKj/W/1L73zEoaAAM2dKzZS2AcsailhYYvNd1sAIPURdBDu4Fgw1p6cpk64Sk1lm/0MLcCtGhPJV5cjDY+UMN0eRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733957987; c=relaxed/simple;
	bh=dXbSmVFD+OCsfSnEHPgUcLDJ2lRwGmi0hIwPKwQDYe0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H+cCzeveIQNtSpKL3xaHi8aTiPjYVGuUZ6PT+co1cYi+9EhQQ5HJkglwtNi/3SrT6LLia+NXwPAVpSAGu46dekGin5ot1th0OlSm1bZPrwbuGCUueTmubs+RgJY2KVVgjw0Ls9Vk/kYNgh19vgdoxK4/gUn0/sgWEaYAdcZuHe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eWIjlPd/; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eWIjlPd/"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5d3e9f60bf4so6986150a12.3
        for <dm-devel@lists.linux.dev>; Wed, 11 Dec 2024 14:59:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733957984; x=1734562784; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0b1Skwh0zMCLAR/VwxPp8d+MzrppHPyTF7ZMEGSIKUQ=;
        b=eWIjlPd/BdCEL35Y55fMT3B+Lrh8jq7XnE/FxOOKbBlgmGEy1PStuYGzwPqwBcZ8Jg
         G1VcxvNBXNdylGVQYxNywslqVOuAC1qOj69hijxlQ2NXch859Exg1dcvK2ZF7NMSD2Kw
         nqmoUYn5gNxV47xlaAFJ1OW6ROr8Cmojcv7zmRijqisZmCeFeG1TOlcsXnIYPNeQAwsq
         CPJ3oj14Lg5kO57LJoPomQYIegZwlc5A4IPJ53dZopkkUV7DXmRtArhDUZW36tjCfX3P
         UrYbav9Xnc0R0lPLHKiy/DS+NPctFn3n8e1mgtAJ0LUYcxjTo18PDdQjKncXBHjLKIZb
         v43w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733957984; x=1734562784;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0b1Skwh0zMCLAR/VwxPp8d+MzrppHPyTF7ZMEGSIKUQ=;
        b=GHV2wmvgQfGL9UnP7vprBidbA3bs5pYhpWgPKDfN8khpphyQLVMUlFMYm3RH//pbSC
         6WaHdxrFxap6m7lmAa6JrMpu/BQ/Ik4GiLy7mWqSgcO051En63ddCENDShplHlgml10w
         7dMvlCnL6M+zhAaN2dAmaaidoCJjn3lZFfuuPeeOx08fK4XsvpyY8OqVRHb8kfuziDkI
         C/TFGDUJk/MJhTFlxxDG9v4pkQTBBTYpT+0IclIR42j/DJAWTNfYxjfispvVFfCZL8+H
         hulAfiPK51J49+ppxA5bL3SVzJSDeEhh3sa1HXn7zH1onOPrKtwa0fAZFvTjMb9DV2WM
         oTMQ==
X-Gm-Message-State: AOJu0YzEbBd1B5S/CMJSuICPOMtdZs1MXDsE8PLpf2HbsFRDRbC0lK5S
	15hisQz1PY/HJgLOOi8ZSejWIWlon+qx5eUozS+zfNO/QAhgD4Ok9cOxGu+IVkw=
X-Gm-Gg: ASbGncuEHsqXyREb7Mv598H0YTb6fZzceXANIQIjAbYbjSq4h3AnbWpv1lTCOXjagv4
	wLOTeRVHwsQ48Hr01ZSvz42CybiRMLmRviNPZEXbJMAXlUUxlbmcHe72kJ7OoRpEvqXimiHySBy
	b05Iaoq3SJMSMUDvWTi/uiEESbsUgzL6q76LWA+ErHYOxGUu0CFsUD4Usa7PJAE12z3+wrv23Kj
	XH8EZWrWUkLSEeBCxNQZ/EMTnjVG5MtN4o/ui89Axz1clgxFefOhQpmg7qYdi/K+t84vaL1gciz
	ouAPDCsVBr1Hf8TwTzLyct21PvSsTzasfIL/B1D9B/I=
X-Google-Smtp-Source: AGHT+IFEnhuBEYmVhqr5dcwli0yHAlguX5BTORORCTGq0MBfhyG8tPW5XrCMp/RY5ouSlcA2qdnNcg==
X-Received: by 2002:a05:6402:5109:b0:5d1:2631:b897 with SMTP id 4fb4d7f45d1cf-5d445b3afcdmr1218849a12.14.1733957983822;
        Wed, 11 Dec 2024 14:59:43 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-5d3cc95e26esm8145232a12.20.2024.12.11.14.59.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2024 14:59:43 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 06/14] multipathd: add checker_finished()
Date: Wed, 11 Dec 2024 23:59:01 +0100
Message-ID: <20241211225909.298770-7-mwilck@suse.com>
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

Move the code that handles the checker_state == CHECKER_FINISHED state
into a separate function for better readability. Subsequent patches will
add code to this function.

Replace the "&& reload_and_sync_map()" conditional by a subordinate if
statement, as this expresses the logic of the code better.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 47 +++++++++++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 20 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index be542f6..0823484 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2967,6 +2967,31 @@ update_paths(struct vectors *vecs, int *num_paths_p, time_t start_secs)
 	return CHECKER_FINISHED;
 }
 
+static void checker_finished(struct vectors *vecs, unsigned int ticks)
+{
+	struct multipath *mpp;
+	int i;
+
+	vector_foreach_slot(vecs->mpvec, mpp, i) {
+		bool inconsistent;
+
+		sync_mpp(vecs, mpp, ticks);
+		inconsistent = mpp->need_reload;
+		if (update_mpp_prio(mpp) || inconsistent)
+			if (reload_and_sync_map(mpp, vecs) == 2) {
+				/* multipath device deleted */
+				i--;
+				continue;
+			}
+		/*
+		 * If we reloaded due to inconsistent state,
+		 * schedule another sync at the next tick.
+		 */
+		if (inconsistent)
+			mpp->sync_tick = 1;
+	}
+}
+
 static void *
 checkerloop (void *ap)
 {
@@ -3034,26 +3059,8 @@ checkerloop (void *ap)
 			if (checker_state == CHECKER_UPDATING_PATHS)
 				checker_state = update_paths(vecs, &num_paths,
 							     start_time.tv_sec);
-			if (checker_state == CHECKER_FINISHED) {
-				vector_foreach_slot(vecs->mpvec, mpp, i) {
-					bool inconsistent;
-
-					sync_mpp(vecs, mpp, ticks);
-					inconsistent = mpp->need_reload;
-					if ((update_mpp_prio(mpp) || inconsistent) &&
-					    reload_and_sync_map(mpp, vecs) == 2) {
-						/* multipath device deleted */
-						i--;
-						continue;
-					}
-					/*
-					 * If we reloaded due to inconsistent state,
-					 * schedule another sync at the next tick.
-					 */
-					if (inconsistent)
-						mpp->sync_tick = 1;
-				}
-			}
+			if (checker_state == CHECKER_FINISHED)
+				checker_finished(vecs, ticks);
 			lock_cleanup_pop(vecs->lock);
 		}
 
-- 
2.47.0


Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26221DCB24
	for <dm-devel@lists.linux.dev>; Tue,  9 Jun 2026 00:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780965377; cv=none; b=pkfgbIUqkEnvvXg/HlglZ5I31AK+MZLJsE6EzY1T6nF/5VZQvNqKFhTHqscAbDzBIGxPPGKlqhPPtguduktuTBrUB5FmqlkTzpcAwVCty7sUZU0Vaow5S7+x0wJHzsFkRHw+BgAML9mcODpGOzRD4Ux0qA1V3ra8eQLJv9SlxFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780965377; c=relaxed/simple;
	bh=YAWQNnMq1vx88cYLRYaghzw4gHEoqXHkkf8sX+H9Zo4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X5S9HgXzP3ZOzxKjeHf1epdllH23qCK005JltLUjqYhwtP4/IYg6SZzaD459Ms4jObt4zDgySKl4hrGJ8K+6sRYt7zHD9Pw/oqMy0+91KHG4zbP4Qfu6WG6IV2PMJZLELMoIeET8BENR8s47htlqbdXO+Btn1FFu1E+nDdl61g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=ZHVWNvLJ; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="ZHVWNvLJ"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-5174a3a025aso50518171cf.3
        for <dm-devel@lists.linux.dev>; Mon, 08 Jun 2026 17:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1780965375; x=1781570175; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TGpyLAnG03HuDNFbpW2SIRNjJ+Qv89bCpHi5SrXn4FM=;
        b=ZHVWNvLJXFHsJZ8yXb3Hc3qbBZu9D7gLZ3e84d1W0OQDQdY5BRN4lynNNMOmAyJSUj
         nYNfFL5RWn5EBKCPjkZTWbpPiurVtZ+cMRH+5E845/NOaZ/ljldBzL4o9PS6k1GmXprW
         gzgwZjdZtxnXgyiMgyI2g7KNa3YE5LOxRl2ZSF9HmHWJ4Pzr6lHdDqiETKr7tGmLV9tR
         qRtG4ltRzYbxrKfSWQEMbH2jejX61tBHebGPYFcSxAwobdE9wwGWm3fFqNtU/B7b1xpM
         bvlyCjNjJMqU7FDYQ71DXLXgbrHQPwMqPkxTJTxEMmd5ajqXNwuwIP6PJ9Kp7y/wdQgP
         YY5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780965375; x=1781570175;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TGpyLAnG03HuDNFbpW2SIRNjJ+Qv89bCpHi5SrXn4FM=;
        b=bc2NhuB2oc7tX0qmsGLvmNSSGjgKnVLv/ZiVQaUR9qtROF20xK6d4idtRs2UC5BrSp
         LoFOgciQYGi2J47ezgXJoH4rlt0trEYcCznFouRiEX2VEcDwR6T4vm2C2DICY8rXwk3V
         2HKZyFQfawzeQabedsv34ZSogO3nP9+YWHfU3e+8AOfUIPH0zfmMpDf3GI8Eq8koJG9J
         A90KEOlDigZW2Zx0CiYUqbEyzEmNf1mcUUiFEf7C0mlzVcg9uBNF0UBhqRAvthm3VxkP
         muw4uRZ8XQkMPOmIXt3xcMQq3xah8xT/ajQ7Vs8fLxnC46uTlqr14rnBjm6/9UfnZvOA
         eGyA==
X-Forwarded-Encrypted: i=1; AFNElJ9yUEnpFoah0MG4/Vy6xpCw3bKSnUgeXXiTMJWP0C9qwln18zyQZUhc7DHhtefIILa30ss/MRqH1w==@lists.linux.dev
X-Gm-Message-State: AOJu0YyB4uYUw46frcjzwBKs0E+5ujh7Vs5I1T7p3hqA9Eg0EkWXaYdi
	VphTFubYQN4JbhNvubmhJPe35YUoPnALN5e0w33YZtIwjQtqJS6YVPoGU0J8eHSKFW47b4mTb0B
	7wev+8Zg=
X-Gm-Gg: Acq92OGaLHEbegezyQa1BaFLnYCmclCOcG4WyCdYXLlTj1LMJ0CdJ9iktAAD5VIqcgV
	3oCb+gMD8GDYjeVX1Jl0cIIdyG3M9V6yCVRPDSF6ycqQ/sTRt39GkN605ThVJV2HztmFuVcbHb6
	QwY3ma0iqBkQp9unqbiOLsSVmsl6ANZJ5+0lY3GxQX5CpNQKRxncKpAfcNVCfxV08XuaRaquRqt
	7J1ciLCBKdU9RuqgvagWhyh60/R6dH22P/GF/4x5c0r0/u/fpPdzLWHztbB9kpkRLTYglIFonNK
	GjJOGDjASxBZ7tLcBlKHkYL3PWuzA+vUMruO7hqyXm+E2wlEyFd1wk7kTYee/okUk6q5f9SbStg
	lgZpe8EgY4c9thYawSEFjT/LlVolLkrkEZkfWW4d0hQrTKF2L+yMA8kAVR5jZPKXIFrE4RP2KCM
	bWxPw/MxxtgKPRNI5sEV2LxQXvTcMedoLujTxk8+NbPt/pbWZf
X-Received: by 2002:a05:622a:98e:b0:517:760d:48ea with SMTP id d75a77b69052e-51795ae8443mr254148151cf.18.1780965374864;
        Mon, 08 Jun 2026 17:36:14 -0700 (PDT)
Received: from localhost ([161.35.96.86])
        by smtp.gmail.com with UTF8SMTPSA id 6a1803df08f44-8ceccdb915csm184542656d6.14.2026.06.08.17.36.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2026 17:36:13 -0700 (PDT)
From: Samuel Moelius <sam.moelius@trailofbits.com>
To: Alasdair Kergon <agk@redhat.com>
Cc: Samuel Moelius <sam.moelius@trailofbits.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev (open list:DEVICE-MAPPER  (LVM)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] dm verity: avoid duplicate tasklet static-key references
Date: Tue,  9 Jun 2026 00:35:26 +0000
Message-ID: <20260609003526.1237608.fab64a07d85e.dm-verity-tasklet-static-key-leak@trailofbits.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dm-verity parses optional arguments twice during target construction.
When `try_verify_in_tasklet` is present, each parse pass increments the
`use_bh_wq_enabled` static key, but the target destructor decrements it
only once.

Creating and removing such a target can therefore leave the static key
enabled after the target is gone.

Only increment the static key when the option first enables tasklet
verification for the target.

Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
---
 drivers/md/dm-verity-target.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 9a9847f94c46..c06ccf7ee1b9 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1262,8 +1262,10 @@ static int verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
 			continue;
 
 		} else if (!strcasecmp(arg_name, DM_VERITY_OPT_TASKLET_VERIFY)) {
-			v->use_bh_wq = true;
-			static_branch_inc(&use_bh_wq_enabled);
+			if (!v->use_bh_wq) {
+				v->use_bh_wq = true;
+				static_branch_inc(&use_bh_wq_enabled);
+			}
 			continue;
 
 		} else if (verity_is_fec_opt_arg(arg_name)) {
-- 
2.43.0


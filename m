Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92AEB1CD1E4
	for <dm-devel@lists.linux.dev>; Thu,  2 Jul 2026 00:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782952079; cv=none; b=c9OC2toEFo/t7Po0FQqvuX1CvRVc20eXPt+lrRjG80GsydIrwrbx0H8fWfH38Gs4fdmOpsajvWFoB/K0u8wF1/OwQqacDLvOQkrdoxkdbfxWdcEPcjtqlUgPTFtfU4f99NMGwU+WDiPmQolO9pQT0Palo3CiprDnJTzMGdCf8BU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782952079; c=relaxed/simple;
	bh=2x6snhgPBzODMuiOrPsNtoXQfy2qZJQ6ZuzrUXutBGc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qHoo6oLOe8zG1WG7/Vrv9WJV8+kdBKYDloWUh/fKyeCt29gsx/77ji2/GTUe53qo7PTHsMVXPn0TKXQKWguPSf2JMDpaeA1J3O337Z/yhr91DsGLUrZxJNwNbDpGIKoGPlUQcukMU8Mcj+fA0sV0XS1vkx4FAn5veTL6Er5yuNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=fY4H0OK5; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="fY4H0OK5"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-92e622cc874so70344085a.0
        for <dm-devel@lists.linux.dev>; Wed, 01 Jul 2026 17:27:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1782952077; x=1783556877; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=10xR8D1jrX271Q7er0MPHzQpF+RH0yaA/wjyq+B3CY4=;
        b=fY4H0OK5Yjm868b+qw3brgbfKJhayv5QyI7q62mgRUGiMo8KmnoOHptwc3PGRigJHB
         mG5w/QIS10rdpqDNKAK5SHF4DiLtm/pEcEsPEe9pMo156i/9IDDtckZjTX7UeMkSAk8d
         wWfbLp190+xSi3IhHZcY0t9ig/zakM/RrvqYgFCNwuwJGsj7GsynHC2opWfobFukPDOA
         8gAuoAbTVY46xuYYL6mR2nEG8mJ3M9daB2MoUQhjjimWySJruJUbpnecTNGCRZmwyhPW
         J3EZArDdbJc9Gq5x1pXsAxckr8UBN5+aID9et5QfWyJx08lVpUbouzAmJ4ZHcKKVKdGD
         8S/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782952077; x=1783556877;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=10xR8D1jrX271Q7er0MPHzQpF+RH0yaA/wjyq+B3CY4=;
        b=WNCQRB6hGubgwn7SK+FnXchhbTo3W1/Dn6muxnryRM96BPDeVwCSmJBD92sjmlchyx
         /LBOR4cDWMMsupteTKwulIPERrF05h1Z29i8s8FSt7IpjIOIWBTxTGyLO/GRl6zoEfzf
         lPqC7c0ItdzuQJky+vuwUYPvch8EXr1dFNNa/M376vMFX5jGm8ya6kW31vADoM9aNrm+
         SZhU6FeOlbCgXcwzqulVw3L691uOZdjn9iONCPRf1xHmeyhds7nvOLSmLcgGK1Uk5nRG
         ggczEi7n1ph2TZTnp6CMldIbVmF41k1csK0Zh0qislcF2QJXEtffOLupU0OoAR+enMg1
         iajw==
X-Forwarded-Encrypted: i=1; AFNElJ/pJBpiftTkRhnLGS53a9Tl/AxpVkucKVQRKorGGHYLScyup/15dgs5vIZUl1Ej/spZW7PwYxtC+Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YyS7wD+/78XeQ+o2q+41Ii4zoQ/uhygK+c2Pecwr/0WllQT8iaO
	Y5EpmVKA2SOwKrbru3jpor8DAGufqB2fLKmnvll7N8EzgG7QBm35wsADmwNXY1rmYcs=
X-Gm-Gg: AfdE7ckSIgilT0jiBQnpTZtD57zgkFj8hzFo/uHc/oi/swaykmppYZ1oG1cDULTNQIZ
	OV2y2UiEeP59rDnOajknTQc1zaeMv+pwkAfmmCqjoBc7Mxca3nNoiCze4vLDSF45IkfGBxgjV8A
	dG1MAcIjN7udmd1Qh7BpfV8shQzqaxHMUrkEUpy9BnyfZhwm4eQX7agn4nqBaQhtY2dsvzOmWO5
	S3LSDHrqIjtf/lWieqVaJ8QeXR5ikGVm3AO6ui37mnGJkI0rtooT+Q8kvXlrBdaIyK4Xc2H2F4q
	8p8irYtqxwd5/Enm2GQtMShqQDuxYWM2xZpAWjA1zHfXCGrqdJEJtt6uOCJXS18ARw8RIffxHy/
	iWjmcvMmdQv6FQE+bP4nu+x9lMDf8sIRnldropz0i65hfTGsPTSCZUw385L9hXRQjP8L/Wm2ayT
	vtUyMGy08Zo5C1LkO+
X-Received: by 2002:a05:620a:6498:b0:92e:520a:ffab with SMTP id af79cd13be357-92e783ce9ebmr576278285a.38.1782952077488;
        Wed, 01 Jul 2026 17:27:57 -0700 (PDT)
Received: from localhost ([161.35.96.86])
        by smtp.gmail.com with UTF8SMTPSA id af79cd13be357-92e800405b2sm86730085a.20.2026.07.01.17.27.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jul 2026 17:27:56 -0700 (PDT)
From: Samuel Moelius <sam.moelius@trailofbits.com>
To: Alasdair Kergon <agk@redhat.com>
Cc: Samuel Moelius <sam.moelius@trailofbits.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev (open list:DEVICE-MAPPER  (LVM)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] dm era: fix out-of-bounds memory access for non-zero start sector
Date: Thu,  2 Jul 2026 00:27:35 +0000
Message-ID: <20260702002734.300353.794e3849918e.dm-era-target-offset-mapping@trailofbits.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dm-era tracks writes in target-relative blocks, but era_map() calculates
the writeset block before applying the target offset.  Tables with a
non-zero start sector can therefore pass an absolute mapped-device block
to metadata_current_marked().

If the absolute block is beyond the current writeset size,
writeset_marked() tests past the end of the in-core bitset.  KASAN reports
this as a vmalloc-out-of-bounds access.

Apply the target offset before calculating the era block so writeset
lookups use the target-relative block number.

Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
---
 drivers/md/dm-era-target.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index 05285c04ff2c..18aed0e2a508 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -1229,6 +1229,7 @@ static dm_block_t get_block(struct era *era, struct bio *bio)
 static void remap_to_origin(struct era *era, struct bio *bio)
 {
 	bio_set_dev(bio, era->origin_dev->bdev);
+	bio->bi_iter.bi_sector = dm_target_offset(era->ti, bio->bi_iter.bi_sector);
 }
 
 /*
@@ -1560,7 +1561,7 @@ static void era_dtr(struct dm_target *ti)
 static int era_map(struct dm_target *ti, struct bio *bio)
 {
 	struct era *era = ti->private;
-	dm_block_t block = get_block(era, bio);
+	dm_block_t block;
 
 	/*
 	 * All bios get remapped to the origin device.  We do this now, but
@@ -1568,6 +1569,7 @@ static int era_map(struct dm_target *ti, struct bio *bio)
 	 * block is marked in this era.
 	 */
 	remap_to_origin(era, bio);
+	block = get_block(era, bio);
 
 	/*
 	 * REQ_PREFLUSH bios carry no data, so we're not interested in them.
-- 
2.43.0


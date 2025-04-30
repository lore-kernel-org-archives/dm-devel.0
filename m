Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6C91EDA0E
	for <dm-devel@lists.linux.dev>; Wed, 30 Apr 2025 08:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746000361; cv=none; b=RZzTWB1yC0VzJuiX6awlIOlhUr2m/U4PtfII8vLU9jNaevLu+PsAvWzO3jDhOvmOi1wlyhfRu6bWJw2bBHA/fnLPZozqmsFQUuhJbWeaI5Vp8PXgCbV1S3vNIofXlgbQEa2Vntt+R8ClWyBhAfAwJVTHpHGdCpSdxQ4d6KUmGPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746000361; c=relaxed/simple;
	bh=DUHxlAwhz09uoCCY/km3TFaTU24WnD8mv0hKD36WSmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=GC5vveeC8DhCfRaT7GygtMbaG9SqsAg3DMfbQXNrnX8JqmIT0KNdunTBCUbcvpCwqwSLOayke9iOoWfUG1hNSCTm6LxeJ8SvZIg034I7qWC+eKquQJegUOwxdOSS5YDl4thf9u8CslHZoqQlFjM7tDcptPwJ1BqROszGLkJ4c7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UAf1cbXU; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UAf1cbXU"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-43cfe574976so47924565e9.1
        for <dm-devel@lists.linux.dev>; Wed, 30 Apr 2025 01:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746000358; x=1746605158; darn=lists.linux.dev;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZYENxwyZq0Q3qL0QvqAbL/WUtfShupQ9hB5wEZFyU3M=;
        b=UAf1cbXUsB/M/TYWeZZz0COypTAtxGgqqBybu7jdq6Un6z7Mp0No9G2qNa+G9LcCK6
         BVOa/KEq62vQWjiSNAP1C9AU4sm+W/tHOpJyXY4OQV9tWJShj/wxohC2/uVOgAYnewJ1
         FnGH2SlF6CFQWrZjgrD2LH8ZZss5tXeHyITTSBNL2Grm13VA9PuE/VTYhlHXEuCHamQp
         fERaYObitszlFEGjiLp4JRDooT3/Lw4lfKMQuSNgsZkN+Iqv4gRl2D+vzqzwSatafZ7i
         bV7L3PsXws5QAplvromZUQJKud7RQc8qnepmq5fWSjrOaiikVhvl37yd0d0A+CAgmNXK
         CTRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746000358; x=1746605158;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZYENxwyZq0Q3qL0QvqAbL/WUtfShupQ9hB5wEZFyU3M=;
        b=EFJi0yoJX4ig4H1oTDnf9mERGir+tfrkbxCY6G63wJdVb7xZpOhWITTKvE/DJPPC5w
         Z2w68ly+9XRoMJRyPs4vnefosXOAkH/23nl4uNKjZJ5ww2zGTsFFKovVsMJEWsWKYKlX
         yObvrBLGGK6qIc9Qi1u4YDoCqs/To7NxivWiG2lLfEaMNsSWumWh3tUNMRwyTT69cyab
         2OlJTzsOGTboAvAXEXLrgPdX5I51x8WXhxii5OV5KKZOhRaLBBr+pJWq/W8iI6OdfyVL
         AyIUzi9Pqlki6Zn42Ag5+QczC3+QLH93t+vN8mEfjTS60+T3O9gA2TyPgoNLHSUmiYbd
         pteg==
X-Forwarded-Encrypted: i=1; AJvYcCX1nRafI5KmpXS+hw5GH3zQPX7npOQV6VNby4sYxt9Yn4U9Bx//K1RaT3G70pitG+4veKOgR3uTkw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx+jPRE1+H4z1PmJf5MVKgyxCWwbdpFcq7JSNv5NVRk7E8D8azx
	+Sl3az/43iHn6j1NMC8WlPK1JSv9QMICaZFBi9GDQpK8rLTNuYEOSsuZI+2XK/c=
X-Gm-Gg: ASbGncvFs6ontrBt8liIm8CBm8h3eu2UAFgU6SasqSzCtYdNttrAYpGYXhig0MjyBGm
	v4J7ej+J7TqdHaaI3yQnUODj1JEKYMVJcizAQ043Piuj61dCz3RTRWKygBisl6Ppnws84cEe245
	MziNaxWilxzoTUqK8OAh11N7JRXoqGu6l1saia0Myw7zRAkfihnygG0ES413fg+zMd8XMxt4RkU
	yM2A7G43rOa1TMO6x8rBrQ5VEbUsz9ZGbAB4ZEaL4wUiICovYORQhxlxVM6TZ0lOyQ1IO5xCZF0
	4/TKzTTDR3g1AEAmBSZDT7NzBMniE9yA3bcveRljCDmVAP66kC0Ak3Ze
X-Google-Smtp-Source: AGHT+IE/vJgkReHfU0yex981z0mRRJKC7iIQUf/5YtQH4VoE02PsQEx8EvbLqs3gYSEqbq0UVxslLw==
X-Received: by 2002:a05:6000:430b:b0:3a0:8429:a2e2 with SMTP id ffacd0b85a97d-3a08f7a2776mr1682112f8f.32.1746000358002;
        Wed, 30 Apr 2025 01:05:58 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3a07a5ed2e0sm13777037f8f.39.2025.04.30.01.05.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 01:05:57 -0700 (PDT)
Date: Wed, 30 Apr 2025 11:05:54 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Satya Tangirala <satyat@google.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Eric Biggers <ebiggers@google.com>, dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] dm: add missing unlock on in dm_keyslot_evict()
Message-ID: <aBHZ4puON8GNK0vw@stanley.mountain>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

We need to call dm_put_live_table() even if dm_get_live_table() returns
NULL.

Fixes: 9355a9eb21a5 ("dm: support key eviction from keyslot managers of underlying devices")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 drivers/md/dm-table.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 933e01f3fab4..1a7e2623069b 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1177,7 +1177,7 @@ static int dm_keyslot_evict(struct blk_crypto_profile *profile,
 
 	t = dm_get_live_table(md, &srcu_idx);
 	if (!t)
-		return 0;
+		goto put_live_table;
 
 	for (unsigned int i = 0; i < t->num_targets; i++) {
 		struct dm_target *ti = dm_table_get_target(t, i);
@@ -1188,6 +1188,7 @@ static int dm_keyslot_evict(struct blk_crypto_profile *profile,
 					  (void *)key);
 	}
 
+put_live_table:
 	dm_put_live_table(md, srcu_idx);
 	return 0;
 }
-- 
2.47.2


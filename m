Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6193C4F68AD
	for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 12:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895188; cv=none; b=RnN31kMCFtGvLPZh2jKGqIObdVHGyNJJJSn7AM3nLRh/Jv2SjBVeiJBUakscfyq27ENZ090XLwaGwuADS2nNGDT3PqLMjEEGCLVwxoSVXVzFuaSR4F2f6JlBmVX/pZRkpgOcDOpu0GuksQKmNWroU7GF+UiDutCG38rWfG0g+1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895188; c=relaxed/simple;
	bh=sA+c0WYN2bPE37DjivosiMzZqIXScnG8RZ8vm73mDVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kbgSW1YHQ2y4eByj7uY0IM9ev49fHj19fGiJJ3BHtTRmmTzuFydboz/zTjsEmLf+btwa2HAhMpzOLn+000jot1pe/V+PlJP0D1K+L/W21kge//1En8qUMcPIu54QBRTG1/7o3l1TFXuntmvgE6gbwF1xg2X5xrOOwe7bFsxXlQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X9nHFh1d; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X9nHFh1d"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-48b0d19cf7eso3339978f8f.1
        for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 05:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791895185; x=1792499985; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2TF+nw/u3d0JmPL6ecEUe1KLmlN203omllzFb/e1Krk=;
        b=X9nHFh1dH3aeqHl4cKqdNqSDps0IR135rFGC2Vg5LAAj3XnQRP4jgV5nmnwFNW9zPn
         dvrMRzzLGjssgAcM8lzTMFxEY9vdbAKWZsuR+BuFzcgB1TKHrnETiFBl6M3JYEFKL1G/
         5G/wM+P+Vb0gkoAHGe7qDTdFwFxf/M2BOBO/K4sxK/Mhn3uwCOC2cEYkacvD/uGBjr4e
         Wzk5Z9NERX58kgWiEyLK+Hj84QQhxlRAk+Qw/92UyJATa5LExWkZclE3M/qCLLY4dENq
         32m+FojlGabYuNSx7wml0sc/zvSRfNyH2A7h2/0sqc3Rb4OOgR1HUbSP6XDOjrWvBWyW
         MJbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791895185; x=1792499985;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2TF+nw/u3d0JmPL6ecEUe1KLmlN203omllzFb/e1Krk=;
        b=ptmx2+u5ksKXqXko018COGQhdargM3tLu0YY4fqw1jJtlPD2bGKchIaHRuCc4f3NKr
         K5Pyf78By6t9ELewklakQFMDIXk+d5roGMrYL3reACavlin8CKvmrEroKwmULe/H+2j0
         3I0OxD4AV6kIqhmaRowdVevQywrhwqgVzItzsx2QElj05NfmPaH8tiQj8TbWDyF5d2Bg
         pYNL3ll1AnnODMlve0nkEW2tjYxX0UbTQsfdfOArRzj8ZKL+vtpvEYJ0sGJt5tECt0+K
         5N51mqli3r32ueiMLUnSH9AoRQ1qj9yM6yaOg0nHyJysA/BIcdfd5hQUNN+82feaOIsv
         uYgA==
X-Gm-Message-State: AFq9FYKQ1olSta/+LBY3fV/Df2MpOimxUZOJG1Lu69ky9YbhsNhnR7Ww
	cSZQy1giLREzdWJUaeMDagg0Nsb6QvSO7piZtCKRFGorfg+5kvbsumBLMBwL14Z2
X-Gm-Gg: AYBFou3D63/+BDb6zRP+tNXXGgeNnO0PuZZ61UqIoVRUu184Cudn3j7sO5WI/u6s4P6
	XuAO+lgKS9O+YGiVGPoPWMwizYCgf4pVeIG5H66OFeaP51Bmdb8GIPMB2JgQBvfdyEfjQ8feTMt
	sRSl1TniuctlzHTjfhtBcWz+mHUK4QQlwHaNNucGGpD62KAPQFk47uEm+9VrAcmLgh/w/KWbSfF
	Xiuz22Le5H80LRPejrVvkcBJRpYPVB1oDkfKEkcdXQzKje5bqQ8blmeB7RFh4lvuqg3WKRWFh9i
	yJaXCj69ZUY8DpS068R7zg8IE7qWGiaFwxRLfcyGB7X7efWADDTdZ3YjUw49LZSh/NpluqtaqD7
	lTRBXrzXN9yqrjp3eaKofmp9dQdCBTvv2QIuBhNe6+TfRpFDOh6er09S6PvxanyutL3hNq1DkpU
	CTA1O4/DD1DXaCkd2vi1bZedRvXckv/OGMNZ31x47eYb+Z4mSIYtH/opMkghmyUzaxPA5bmG57L
	3fXAFQDpwul5Htd+CQIqYyGokXm0dvHMXmQzwK326icprU=
X-Received: by 2002:a05:6000:188a:b0:48c:72fc:3644 with SMTP id ffacd0b85a97d-48dbacf555bmr28162303f8f.22.1791895185415;
        Tue, 13 Oct 2026 05:39:45 -0700 (PDT)
Received: from localhost.localdomain (87-205-122-125.dynamic.inetia.pl. [87.205.122.125])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0bc7299sm4179440f8f.53.2026.10.13.05.39.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 05:39:45 -0700 (PDT)
From: Kyrylo Biryuk <illofspeed@gmail.com>
To: dm-devel@lists.linux.dev
Cc: mpatocka@redhat.com,
	snitzer@kernel.org,
	agk@redhat.com,
	bmarzins@redhat.com,
	dlemoal@kernel.org,
	hare@suse.de,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/3] dm zoned: back off when reclaim finds no destination zone
Date: Tue, 13 Oct 2026 14:39:38 +0200
Message-ID: <20261013123940.952-2-illofspeed@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261013123940.952-1-illofspeed@gmail.com>
References: <20261013123940.952-1-illofspeed@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When dmz_do_reclaim() fails with -ENOSPC because no free zone is
available to copy the data into, dmz_reclaim_work() still ends with
dmz_schedule_reclaim(). If the target is idle, dmz_should_reclaim()
keeps returning true, the work is queued again with no delay and the
worker spins on the same failing pass.

Re-arm the idle poll instead, so that reclaim is retried after
DMZ_IDLE_PERIOD. The next patch makes -ENOSPC the expected result when
an idle target has random zones but no free sequential zone.

Tested on 7.3-rc7 together with the next two patches, on emulated
host-managed drives (scsi_debug zbc=managed, and the tcmu-runner ZBC
handler under md RAID5). Earlier versions of the series ran on 7.2.6 on
three 27 TB host-managed drives used as md RAID5 members.

Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target")
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Assisted-by: LLM
Signed-off-by: Kyrylo Biryuk <illofspeed@gmail.com>
---
 drivers/md/dm-zoned-reclaim.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
index c041413c729..315f0da99f3 100644
--- a/drivers/md/dm-zoned-reclaim.c
+++ b/drivers/md/dm-zoned-reclaim.c
@@ -540,6 +540,14 @@ static void dmz_reclaim_work(struct work_struct *work)
 	if (ret && ret != -EINTR) {
 		if (!dmz_check_dev(zmd))
 			return;
+		if (ret == -ENOSPC) {
+			/*
+			 * No zone to copy into: nothing can progress now.
+			 * Rescheduling immediately would spin; poll instead.
+			 */
+			mod_delayed_work(zrc->wq, &zrc->work, DMZ_IDLE_PERIOD);
+			return;
+		}
 	}
 
 	dmz_schedule_reclaim(zrc);
-- 
2.43.0


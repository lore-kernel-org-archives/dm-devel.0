Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3FF86353
	for <dm-devel@lists.linux.dev>; Fri,  9 Jan 2026 22:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767999183; cv=none; b=o0reY2SnFkj4IH4EfJ0PYuK/b7g2OEHS9xjZ0yRn70TWslc8Yn6vRtrKSQv4O8PF7UtPyWc9h/7WqnYKKIvl3muVd2Z9F9dzlb2W77A9KDoSt/eA+XEtfJSmHNfgR4ij7qNaZAmP+2JaJ1Aakol4ozPcdi06spvrMlbsyKUSsuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767999183; c=relaxed/simple;
	bh=Uof0hsJLzgi6olNyPmme0s0a909wom4Pj4EMkvI3XOQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kVfHwZ6l7A4jieK5vvaj9upD2mLMAO/ugsLc8MGHh8d7rLUKk4m2UuvHVdlFmMDKSnKouBUi+SRLWLT6s283AZpdn7Z/Hnrwh6KRoUTW2HDm1w8E9k6OcqhwdHwZc8zobAuKqLKkyH8GOwH1QMu49G9sm1kOIQvZ/pX3Y43ih2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=cIZWRZxZ; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="cIZWRZxZ"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-64ba9a00b5aso6881804a12.2
        for <dm-devel@lists.linux.dev>; Fri, 09 Jan 2026 14:53:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1767999180; x=1768603980; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Agyfq9gmMc7YEBEnkhUYiC8N4EAGz8jV8lWmjTPGfe4=;
        b=cIZWRZxZpPiF2dsR32O/DKe3sFiXA8+RAO2nmNWxn9ifcQ8V6ztINMIIhOgP/jH0e+
         F3thcxrYZ3FBdu6eyEsuLZ4Yj9XgsPMUbP8X7mTBITVk1Z2D2cTvyNiXeUsk839mpOdF
         syUNDWzYcybcO2CQZfhdsVkqy6D2LMUlQ1UzPr/oLwquJ9xmkpF12f+E18Ec63aKSA01
         v0/Wio711+VBofxfD6FUwysJGMVhe+zJDmREoRs5cJ+zSti7gTUaKoBOf8gTZUWRp1Ky
         zxVQL3k5uSiBOx7B26ngigaQCrU9kJqTIKf7U2GVGOHk496S5PPd2hk6qyvoU5xDjCPR
         dckQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767999180; x=1768603980;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Agyfq9gmMc7YEBEnkhUYiC8N4EAGz8jV8lWmjTPGfe4=;
        b=R8CyYMCGZaVisoArlqzL5Nz+2dOLAqWXtbwGl+sWm7KC6WyUK/K8+MerJ+JxynHzX4
         7YczhAmZJjzix0gMWIstHWBnk/BbPnb7fhkYChayLKXa1ozAgF7ok+wDp8SalYPjWuRs
         eS+iWVGippGhW//jy8VNZPgS8SLUxbrKf9jLFnqPDboUIZl5X4Jkk32hyiJjKLmz3Obj
         rfC89k4WMX00f9RXUOMYiGqSEPb0fKm2+ZwWDA4kHG0RuW+I2JpP15rUsANX3uXIZgfH
         /9eEpQHM2umyUTvblOtsKDumhb8UoCpqb1Spxb23ePV309A68rCVEkhN4PlzIIVnPUlj
         Jvxw==
X-Gm-Message-State: AOJu0YyomeanIXjI0KOREuIl0imfOrM6KPgkeLOk3r533dTdsjJFoJXX
	5MSDcwKunjS2MYHiYklSr1FpEIMC/AZI5+tiqkjRqLuyXpZpeotSwArzIDkztp7APCOd7QnmmsG
	MTjds/oFNAALkI25S3ZRrUNsJaBuYUNh3Q6tw8dhfNRV2kdux4Bg1OUJMcTlmm4ukks7w7RmccC
	EFvxc3FL7XY8oVXedesNQp1VuMXZfhmuTG+NWLhrD07LH1JA==
X-Gm-Gg: AY/fxX7tgqNlZVRWjSmHnuwljCrGKXu2bZo5mdvogHd8B+HYr3kLOaNoPILMBGeQkuX
	Y9Ih8KoHdcDjXGzBJGDRCXtWjLadYT8AGUSgWy8mRakFB3tFO4kzObkOOMTazpnak1Dlb91JGEY
	9bWyYJZOpyJCJe3QY+c22OGYREfniQPyImm/diobpwz5cB4Ww88GOIzNBYBeCaVSLK3hYz/B8Np
	QQsIUXGJ4yUqc7EL7ivTpZzaKnoXzG1prmM3e6+xq+91eg8sSyON8Zes8oqvPvJudle4ewXMd1w
	J2cPrK53qiKNAGavSdnZoSuiTnBw0kqQjcZhNW8dbZeIy7ifN+GxphCnpAYmwqsWDhzTfTqFAaK
	Ez93Ejp6B9e0plXpxdH07imYYZJO9FBwQcrjZ5Y435Ks/KyeJ61OLJX1xNoe38WrAmFrFgiduEx
	1Xa5UpHF5Virreqk4uHaMl7mG8Yi6mTcXjWG0CCZ8R2swWJSSG
X-Google-Smtp-Source: AGHT+IEHNteY24s1cIy3qe4bEPSYzo3gHBZCWmzPzgK4JWCLDWOo0shzntvw6fRXDAj0XF1mErxp1w==
X-Received: by 2002:a05:6402:34c2:b0:64d:2769:8460 with SMTP id 4fb4d7f45d1cf-65097dd1197mr10669257a12.6.1767999179634;
        Fri, 09 Jan 2026 14:52:59 -0800 (PST)
Received: from dev-mliang.dev.purestorage.com ([208.88.159.129])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6507be658b3sm11282857a12.18.2026.01.09.14.52.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 14:52:59 -0800 (PST)
From: Michael Liang <mliang@purestorage.com>
To: dm-devel@lists.linux.dev
Cc: mliang@purestorage.com,
	Mohamed Khalfella <mkhalfella@purestorage.com>
Subject: [PATCH] dm: clear cloned request bio pointer when last clone bio completes
Date: Fri,  9 Jan 2026 15:52:54 -0700
Message-Id: <20260109225254.3609160-1-mliang@purestorage.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Stale rq->bio values have been observed to cause double-initialization of
cloned bios in request-based device-mapper targets, leading to
use-after-free and double-free scenarios.

One such case occurs when using dm-multipath on top of a PCIe NVMe
namespace, where cloned request bios are freed during
blk_complete_request(), but rq->bio is left intact. Subsequent clone
teardown then attempts to free the same bios again via
blk_rq_unprep_clone().

The resulting double-free path looks like:

  nvme_pci_complete_batch()
    nvme_complete_batch()
      blk_mq_end_request_batch()
        blk_complete_request()        // called on a DM clone request
          bio_endio()                 // first free of all clone bios
          ...
        rq->end_io()                  // end_clone_request()
          dm_complete_request(tio->orig)
            dm_softirq_done()
              dm_done()
                dm_end_request()
                  blk_rq_unprep_clone()  // second free of clone bios

Fix this by clearing the clone request's bio pointer when the last cloned
bio completes, ensuring that later teardown paths do not attempt to free
already-released bios.

Signed-off-by: Michael Liang <mliang@purestorage.com>
Reviewed-by: Mohamed Khalfella <mkhalfella@purestorage.com>
---
 drivers/md/dm-rq.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index a6ca92049c10..ce7e6e9a2510 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -109,14 +109,21 @@ static void end_clone_bio(struct bio *clone)
 	 */
 	tio->completed += nr_bytes;
 
+	if (!is_last)
+		return;
+	/*
+	 * At this moment we know this is the last bio of the cloned request,
+	 * and all cloned bios have been released, so reset the clone request's
+	 * bio pointer to avoid double free.
+	 */
+	tio->clone->bio = NULL;
+ exit:
 	/*
 	 * Update the original request.
 	 * Do not use blk_mq_end_request() here, because it may complete
 	 * the original request before the clone, and break the ordering.
 	 */
-	if (is_last)
- exit:
-		blk_update_request(tio->orig, BLK_STS_OK, tio->completed);
+	blk_update_request(tio->orig, BLK_STS_OK, tio->completed);
 }
 
 static struct dm_rq_target_io *tio_from_request(struct request *rq)
-- 
2.34.1


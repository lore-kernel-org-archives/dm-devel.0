Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077A0C2E3
	for <dm-devel@lists.linux.dev>; Sun, 22 Sep 2024 16:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727023631; cv=none; b=nfG4QZ4GTxcX+3QAhudaVb7959gUMBJzrwS88x82t9n3r5vOAfVhOgMzVKXiVFMFTCab+S6IDlnkE4tJ0xudlV5epcBfQoPli/98g44lVvzt0zMUhEm+6XU3bTTLfWT+Z7Tiv4wqEffHx8oxYpwWRUS0NI546xKcyzCjLHiHpK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727023631; c=relaxed/simple;
	bh=dkNJ6/prmp2vy+3tS7W6THOe+jSCd89VFA9zzONhQbI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Enq1OIWDY+gBE0HuOOLaSeqfF/Ei4Bdz6lYOZUe04AEkDgWMyIFxHacb6J4Ecu0VCqwbrLzneU8T5uo26Txf9uQKXL+o6nBhkWcnRwiVDtu6UJG3ZzpFrbh++V3BYgf//irTL0f1S+XkWgiFafAXNXdpA3zRlEgtMp6a6w9KanU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YKCPYiM8; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YKCPYiM8"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-205659dc63aso29195005ad.1
        for <dm-devel@lists.linux.dev>; Sun, 22 Sep 2024 09:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727023628; x=1727628428; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iVq0KkFUULdiukIr/KzH52cv4+OSTUO7xPO7UKIE7DY=;
        b=YKCPYiM85SeXG4CMuHL0C1HfDRb2cYf5VzOHJLB+H+l3tZPh5D1KZuozDnn2fdanKy
         hH9v4q7WtwmAtEv+EjY3k8RGWaV6/R4gdddBt6ckIYSvO1hl4c+6dRQJxminDbVU7p0/
         nTnzRh18b8wSl5ycBI+Dz6mLaXZCeG5sv8rhgqvsRgcIOHn/K2r9PWmFYXMs5XQr/s3m
         vsR2ZXIZCMNYXDvSbEv1Ar8Ua/hnXnydiJijdxEyYQm4Pi0AyNUlOAsHY7x5wMIStsJb
         LqE97fUM/zUt/5pzrL6NxX7w9kICRyKHQE+PIfYpsN0kI4sL9vf8T9UNGSqXFH6iSEFy
         Xw/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727023628; x=1727628428;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iVq0KkFUULdiukIr/KzH52cv4+OSTUO7xPO7UKIE7DY=;
        b=pu+o4M/xlAVh0JfVG9OqWaXgi5E+tbfAOpzznhERZbEUgPvGkoxa9e7Wt+ABcJQs//
         jo3gbSa27bWWiqdDLv1PROkCUfy/i6Bb9YANosSRnicmk0ZSrqq62GAYZ8tjj88s1k0/
         aYZOpGgtBqQpcriBiogid5VUL56/K41YsPkQrXbs1fpwThN2Qu7+/fpXdmpJGAzdrXNX
         xjOLy9Uww+XLJWRo9Nw7g152L2xDaFxtMP7R1PXq34rjakTsVnpVAolx3G7yZUSLY81+
         gz0hpUc3Ji46A0QAQY/1Aj/5aEfc0jQ/ol9d9l7jFj1zYLUkuQPpg6KFnZ7BzKvjczSG
         3d/w==
X-Forwarded-Encrypted: i=1; AJvYcCX7dbplmuPF/mQPYE28NaqjkZdStFL+iFFU2a7sJKeMJGRRcD1p6pvtjWaqTuyt3LV0jlBtpmPazA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzd4rm9UteITwEoTeHbk37S4DBcfgHaSNZa3jhEbEdpzcTJf1Fk
	RquTbf120LFzLvGvzzoGByUQsdXahm5ebcwmmj5pTpf/v5k2/gRL
X-Google-Smtp-Source: AGHT+IGvAUWEgL+fGNlGelLLJ2knKac5i+E1zkKjfdK8TeOCO7+h12L2GXlVZYW+3If9tWhfc8+yKw==
X-Received: by 2002:a17:903:41c4:b0:207:816:6b7c with SMTP id d9443c01a7336-208d98078fdmr99566335ad.13.1727023628224;
        Sun, 22 Sep 2024 09:47:08 -0700 (PDT)
Received: from ubuntu.worldlink.com.np ([27.34.65.190])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-207945da9absm121079855ad.51.2024.09.22.09.47.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Sep 2024 09:47:07 -0700 (PDT)
From: Dipendra Khadka <kdipendra88@gmail.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com
Cc: Dipendra Khadka <kdipendra88@gmail.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] Return error code for failure input for sscanf in parse_cblock_range()
Date: Sun, 22 Sep 2024 16:47:01 +0000
Message-ID: <20240922164702.49615-1-kdipendra88@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Smatch reported following:
'''
drivers/md/dm-cache-target.c:3204 parse_cblock_range() warn: sscanf doesn't return error codes
drivers/md/dm-cache-target.c:3217 parse_cblock_range() warn: sscanf doesn't return error codes
'''

Since, the only negative value that is returned by sscanf is -1.
Returning -ENVAL when sscanf returns -1.

Signed-off-by: Dipendra Khadka <kdipendra88@gmail.com>
---
 drivers/md/dm-cache-target.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 17f0fab1e254..c35d65e310d6 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -3200,8 +3200,8 @@ static int parse_cblock_range(struct cache *cache, const char *str,
 	 * Try and parse form (ii) first.
 	 */
 	r = sscanf(str, "%llu-%llu%c", &b, &e, &dummy);
-	if (r < 0)
-		return r;
+	if (r == -1)
+		return -EINVAL;
 
 	if (r == 2) {
 		result->begin = to_cblock(b);
@@ -3213,8 +3213,8 @@ static int parse_cblock_range(struct cache *cache, const char *str,
 	 * That didn't work, try form (i).
 	 */
 	r = sscanf(str, "%llu%c", &b, &dummy);
-	if (r < 0)
-		return r;
+	if (r == -1)
+		return -EINVAL;
 
 	if (r == 1) {
 		result->begin = to_cblock(b);
-- 
2.43.0


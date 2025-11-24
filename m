Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A04F298987
	for <dm-devel@lists.linux.dev>; Mon, 24 Nov 2025 02:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763953067; cv=none; b=ZZ2KumVokDHHwr0GV+yx0rYito8FWpdyygSOZAvPcyYoEio05xrAE/l9CzAmBwq9iDmAXSCisN4pTbpXqNEdKNNumEv2uyrhQWMrH5Re0EV3EqydSKTW0ird37py6WpPITfNjcxae9DkDLfulXkLr/yShqtxF/3jJJZ9uYy0kH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763953067; c=relaxed/simple;
	bh=W39EvEsOKZnDPgVc3vjL1URC280/rs9OxMSKpDWz+C0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GBaHX6QiqeQg5/PWSEmxlN5jJKEwz0gtGup8IUV8AfTZd7YwazWkcxTZUH1+oCtOoPqoE2Q+02U7YqCGXm4xzNTg5OCbKpzPPb7YaLFOaXuQ5LQUulT59DVhAPLC4wb+d6wEv0YGDHGeobOlE8W2kGWJwRSizNhp1a4tXX6admY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XpWlbck3; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XpWlbck3"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7baf61be569so4528820b3a.3
        for <dm-devel@lists.linux.dev>; Sun, 23 Nov 2025 18:57:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763953064; x=1764557864; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RkWhYF4f1lhsSHEbmYsrWUEDoM/XD4r0C+XpnxkiI8c=;
        b=XpWlbck3jB+MEGaYnNpkPtKzPO1VwgUWMF34RM5vuIJ0j2+GtXXHuCMOqrX/JKo1cv
         X9DcABM2+1/qcVS4og7fnI4t28VocYB5q678uteKzng4f3rPMbq1KYW8zVcUgYCyQ3GF
         IOE6kPpYY6tWL2kbgm+ZkMQekqo30ii1w4UaHd5np1CTIJl7GwptpRkeuKvg0BaRdPt4
         Uy53ZP2rRxwGVDR0b9Jr4hNR98UDvSnJBf7ds8nQ1hDXJsT9Z/PVi37xDCQqGQp81Im4
         dYVYBJCCafg5MupNdJgKp+y0WfTE2FkJmt48hVRIhCbuI1uISjrT5lYq5DXZlyaiaxvO
         eeqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763953064; x=1764557864;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RkWhYF4f1lhsSHEbmYsrWUEDoM/XD4r0C+XpnxkiI8c=;
        b=kpqxC0YOXSNy30SFXaqxaiCTyOsTsm44QVuUPMM5kIsH13YsEppQ27pGtjU8SD8Ynn
         MOFP1GQDsGa5iRGK43zHvEcPXwK3/TnRceg3/BRATHYBre5gn59yoMSik3OyxZFqVRjv
         sbWG1681thJJDe6wk0oBj6NmlZQey/QwHer0025lZ5wAvcDKynUW805Ocu0bc+jxm+/I
         diA0x33mT2unPRR+iVnzKRNeCcctCPHro6tOoX1rhzPT/8Fcis8kjVtfRqXbtJbo6zgc
         p5KceWpoR4HDySUPnib+ME0LRQN3dhtebcxMsEA9bD0zPESv/TJ8Sos8pXf39x1k6z3U
         efFw==
X-Forwarded-Encrypted: i=1; AJvYcCXo9evXcC6Dg0v1sjrhlfPjer3tIvWoeGz4pw93fu/PDLRdxcGoBoW7gxPtk5rc8gy0TNT3OhFxXw==@lists.linux.dev
X-Gm-Message-State: AOJu0YzBG/UYm2CNd4SGxhliY4p/NbPNKLXx8zbq/UIUGONu0ZhfViHO
	ugbFkDocY0xqQtcxYR2caGGDMrmlVKQlcqhC0uYgJY6VN4ykfKMiHghN
X-Gm-Gg: ASbGnctGFHxy/sRuadlY+pM3zllxSMEYrE9rhBaIxEPnJZzVFATQEoMFZu7Knk0lNU5
	UVO5z6uM0mm+a4nNHurAbXeQ5nRCKRU6RmIZLkREEoJaG9aVvlcVxRawCYCtRR1r+5xz7H2C2y7
	tYxBYPGZpQIdYedyTUz5H19PK6pqNTlh5OUlisF+FMSvbLGLY9UQaAjAOo07h6eTmG1PukUg45o
	d+ayXS5khdZaUiiRxqxjT3eCccJA1kAy8CG3qceegA5Zr5zDtysFt/8uiVTevQFSHzxwNQju9f9
	wCUoxITcmB+jA0fhp/HT3+CZ/bKJqRSYUu4neEBZizYC2azzkRVUuklxKt50esBst0I3eV7PxG7
	QLFLxQdnDqN3OC99Bto06TtI+iEd0GWa+c0lafXs+7LrYY5ZEK0D0lpXX5aBwg8Z79nEJ1OCVQH
	NqKAA0pCUDb8aNBQ47k06ZijRhfXD1vmOi/27nJuX9pGxAOIc=
X-Google-Smtp-Source: AGHT+IH2vl9a4qHa0wFFFsUNbzMzey1IZwx6tJlzdt+jREZgI3T8WYYR2vo3qAu15ZJ2v/Ev109wPg==
X-Received: by 2002:a05:701b:2803:b0:11b:2138:476a with SMTP id a92af1059eb24-11c9d8539eamr4726588c88.27.1763953064432;
        Sun, 23 Nov 2025 18:57:44 -0800 (PST)
Received: from localhost (ip70-175-132-216.oc.oc.cox.net. [70.175.132.216])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11c93e6dbc8sm65938624c88.10.2025.11.23.18.57.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Nov 2025 18:57:44 -0800 (PST)
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
To: axboe@kernel.dk,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	yukuai@fnnas.com,
	hch@lst.de,
	sagi@grimberg.me,
	kch@nvidia.com,
	jaegeuk@kernel.org,
	chao@kernel.org,
	cem@kernel.org
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-xfs@vger.kernel.org,
	bpf@vger.kernel.org,
	Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
Subject: [PATCH V2 1/5] block: ignore discard return value
Date: Sun, 23 Nov 2025 18:57:33 -0800
Message-Id: <20251124025737.203571-2-ckulkarnilinux@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20251124025737.203571-1-ckulkarnilinux@gmail.com>
References: <20251124025737.203571-1-ckulkarnilinux@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__blkdev_issue_discard() always returns 0, making the error check
in blkdev_issue_discard() dead code.

In function blkdev_issue_discard() initialize ret = 0, remove ret
assignment from __blkdev_issue_discard(), rely on bio == NULL check to
call submit_bio_wait(), preserve submit_bio_wait() error handling, and
preserve -EOPNOTSUPP to 0 mapping.

Signed-off-by: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
---
 block/blk-lib.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 3030a772d3aa..19e0203cc18a 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -87,11 +87,11 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 {
 	struct bio *bio = NULL;
 	struct blk_plug plug;
-	int ret;
+	int ret = 0;
 
 	blk_start_plug(&plug);
-	ret = __blkdev_issue_discard(bdev, sector, nr_sects, gfp_mask, &bio);
-	if (!ret && bio) {
+	__blkdev_issue_discard(bdev, sector, nr_sects, gfp_mask, &bio);
+	if (bio) {
 		ret = submit_bio_wait(bio);
 		if (ret == -EOPNOTSUPP)
 			ret = 0;
-- 
2.40.0


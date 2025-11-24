Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12A9298CA5
	for <dm-devel@lists.linux.dev>; Mon, 24 Nov 2025 02:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763953068; cv=none; b=a/L5GmITgQxFcU6XaQWIrDBaKbZsa48X5QEILyqMPtHQ3bq8K0QCKmoBbHuSu1FyWV8kzE5+vZrWW38Xj3D2Sh3JGuw7hK5ZsnOpASZbPgQzUjJYmLRl1as7AJEpa0e8w/CntQGOCkaaqDneKjBVe9m9Dy0+MNyk4q8fGUzAX3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763953068; c=relaxed/simple;
	bh=2HTt3IkiR546p3idCOAeAAYwiLr2TwU90SfwMF9g4b8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cmxmgBNxKvAXX9Fkr1v5PY039rBsXWs6FO/QGbSPd2vXZm2nypKwrW8wrkpGmGcdKgswy56QjWTFIxSh4IclNr3KB2WNdPZJXc/254p4LQ5goPyGLzavUf1x0YLh+womi/5vZzISlaicOaSCHD2Bki9OCQ7Fq2WbKO29llpf8PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jEL4TTt2; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jEL4TTt2"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7a9cdf62d31so4653918b3a.3
        for <dm-devel@lists.linux.dev>; Sun, 23 Nov 2025 18:57:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763953066; x=1764557866; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4v5MRSjdziMsNVvfMkn8flY57vC+Pu/WImeTNAJo+ww=;
        b=jEL4TTt2aSpiNOvv4gEK4yO4HmZHkORbRW4/C9oqt1j700JRFja9vW9YGertXiQNdw
         AHCkSFRn180I5Qnz3Xom29tPDyiMpPXLTPTkVUf4eLVLgdUJKq7KspavGA7WUv37AcYe
         wmJJztZpApTaWREawh2tAjaXc5UyWOWUJfgSd6M9URKedt6viCBjVq5MiBywFY5F3Ans
         9fFl3i44dT54s6DyI3Mau85Eyb/SePC8PXyvTwvuQOwEoxAmEEk1Io7VH3g6cvtrJB7Q
         tqJprqlDIx2kBRyFRCh5gEGhttg0SkPl/W3oBwhfqs9mKFTdyS9vNX6fR8indBDiZgY6
         1dLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763953066; x=1764557866;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4v5MRSjdziMsNVvfMkn8flY57vC+Pu/WImeTNAJo+ww=;
        b=I7EwQDFfZP4iA55OQ6KauBLiLtqgt5VfXb81mDJVuh7xEPr7LSx8V525+K8Dj7FQNc
         jN+mjhmuQiEchWKb3wL/QeRD2Jdq3fuyEfo0zdM3Hy95LGWK+Hytjq9C1FiJFaICdGKW
         ImsbXiGjTYGWOPWR/Hq3J4QzLXgN7KIEP7SHVflX8znuHzQ08jbs41uGbJihv72DMwR3
         SfFOW8lJ0wzXGnl/5Vut+FPZh628jwpNDOy5e+yH2vGHG/3hm8Rqic43t2MgSK+hdEc6
         0cRUfpcEA29TjUzdtw6RxtXPmXhDTTZiGruvPrP+A2gbWnJNEDlee3Qf/QbLnzNst14V
         es3w==
X-Forwarded-Encrypted: i=1; AJvYcCXYybzy4LNI4X6zkfjD0mLJpQHhvNz5mQfLdTuBtZCLutHWopE8NT45AeEpoR/NTWAViryEWHH2Zw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzo/vmFAXVBVmCZGKx2PLbaxFuOYenvTqQjtOsIQt0EJKIq/70f
	P4mQb4pHh7o6SJLTlSCxtjvmTPxt7dBxGXZnVvFLJVg6UP9Dt1d6T6CE
X-Gm-Gg: ASbGnct8CZ9QY/VBLZH2Q1tNihZEXf0ETdY0/dkWVY5RUa4SlW69zG2+Esg7QkoZlel
	1/pejEEwHA7PYcBUPOOguwZ9+t6RSMJOkWn2JAVpBDgSmRJe7MUsIG6Ep9pOllzVW8gOM4CYTWz
	mSoutrkFvA6P9NPQxa0VaUg1Fw3Bi/Vzdqf4F7VaMesWhjGA89slrP8qcK7A1MgfN8OkwxS1eLl
	iWc+AWSSdV6vgcjM3fvm6/UUFl70E1Nccym+i0bHDO7GfmVrGr6K2zUFPItzW9uEuEueYbmJ7+q
	Csmpuw8ONdXSl7bL1D651rEyKLavaqLVehdQQl/0DXFqF04MAps+N5Z7yNRB5AG9pjFzIjpA2Gx
	9MxIuX7OgKkwSOzbUngD1Kv0z3/ZqYIiTSwHOp9EjcHYGzsAGX0ryXDPhFkalvrYgr3yeFBCLLr
	I+bE5mMLsVkDDIOWQczAk8/FrqXpm/1jbCPaBZsNl5x4aUar0=
X-Google-Smtp-Source: AGHT+IE2F0nLiNeIHq2g4zMVJnIfiBv34S3msVGeqkx0u3CUtdU5YuLkC01czcghjZ+E6ydM6GCvrQ==
X-Received: by 2002:a05:7022:6391:b0:11b:79f1:847 with SMTP id a92af1059eb24-11c9d712bd4mr5835461c88.12.1763953065943;
        Sun, 23 Nov 2025 18:57:45 -0800 (PST)
Received: from localhost (ip70-175-132-216.oc.oc.cox.net. [70.175.132.216])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11c93de6d5csm43367228c88.4.2025.11.23.18.57.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Nov 2025 18:57:45 -0800 (PST)
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
Subject: [PATCH V2 2/5] dm: ignore discard return value
Date: Sun, 23 Nov 2025 18:57:34 -0800
Message-Id: <20251124025737.203571-3-ckulkarnilinux@gmail.com>
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

__blkdev_issue_discard() always returns 0, making all error checking
at call sites dead code.

For dm-thin change issue_discard() return type to void, in
passdown_double_checking_shared_status() remove the r assignment from
return value of the issue_discard(), for end_discard() hardcod value
of r to 0 that matches only value returned from
__blkdev_issue_discard().

md part is simplified to only check !discard_bio by ignoring the
__blkdev_issue_discard() value.

Signed-off-by: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
---
 drivers/md/dm-thin.c | 12 +++++-------
 drivers/md/md.c      |  4 ++--
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index c84149ba4e38..77c76f75c85f 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -395,13 +395,13 @@ static void begin_discard(struct discard_op *op, struct thin_c *tc, struct bio *
 	op->bio = NULL;
 }
 
-static int issue_discard(struct discard_op *op, dm_block_t data_b, dm_block_t data_e)
+static void issue_discard(struct discard_op *op, dm_block_t data_b, dm_block_t data_e)
 {
 	struct thin_c *tc = op->tc;
 	sector_t s = block_to_sectors(tc->pool, data_b);
 	sector_t len = block_to_sectors(tc->pool, data_e - data_b);
 
-	return __blkdev_issue_discard(tc->pool_dev->bdev, s, len, GFP_NOIO, &op->bio);
+	__blkdev_issue_discard(tc->pool_dev->bdev, s, len, GFP_NOIO, &op->bio);
 }
 
 static void end_discard(struct discard_op *op, int r)
@@ -1113,9 +1113,7 @@ static void passdown_double_checking_shared_status(struct dm_thin_new_mapping *m
 				break;
 		}
 
-		r = issue_discard(&op, b, e);
-		if (r)
-			goto out;
+		issue_discard(&op, b, e);
 
 		b = e;
 	}
@@ -1188,8 +1186,8 @@ static void process_prepared_discard_passdown_pt1(struct dm_thin_new_mapping *m)
 		struct discard_op op;
 
 		begin_discard(&op, tc, discard_parent);
-		r = issue_discard(&op, m->data_block, data_end);
-		end_discard(&op, r);
+		issue_discard(&op, m->data_block, data_end);
+		end_discard(&op, 0);
 	}
 }
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7b5c5967568f..aeb62df39828 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9132,8 +9132,8 @@ void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
 {
 	struct bio *discard_bio = NULL;
 
-	if (__blkdev_issue_discard(rdev->bdev, start, size, GFP_NOIO,
-			&discard_bio) || !discard_bio)
+	__blkdev_issue_discard(rdev->bdev, start, size, GFP_NOIO, &discard_bio);
+	if (!discard_bio)
 		return;
 
 	bio_chain(discard_bio, bio);
-- 
2.40.0


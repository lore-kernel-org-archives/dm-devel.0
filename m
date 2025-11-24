Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DA5314A80
	for <dm-devel@lists.linux.dev>; Mon, 24 Nov 2025 23:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764028110; cv=none; b=dBJcwxJqvdXG8oR7qpvfTP1ZSRpf88Q5neieVzynOGxZqawipmhE6zSpBSARwZquOrMr/HIWYVA+xXkoSNVf7gyQa0hmwsnlNCHglV6h00vuJsjSGbGeu926MwMfdWouQfzAQ3e8M4lddxntlcyIXPC9SrsmMotRX2aOeoH2YqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764028110; c=relaxed/simple;
	bh=AU6gZMWoUejzxWtNerSxKMr0ZxfAoqmaTtwAxnvaFgQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dhrF5tlXA5vUBGZ7hXfTcQwqxtwXj3Jg/UiH3rkokko2rWexTdz5UPUY526Hipubhc9vZkYseL960Y8mxCEEPS4RYmxAkaiohsL6YLNnogzy2TdkD3PNpewG+amflbl7a+hjeOBfmyEUv92/tVy6L5NLulbSTPPor0ahb9+p5VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NEn1ACxl; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NEn1ACxl"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-29558061c68so66307565ad.0
        for <dm-devel@lists.linux.dev>; Mon, 24 Nov 2025 15:48:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764028107; x=1764632907; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KD9mOy62HqGMPaOYo+qJ4jLF6S4k7Y6n0q2fK45fvpw=;
        b=NEn1ACxllrSuoFE8EwXK8FJm06vhsY7Nm5n8RuyBN2TUqNNqGB+hJtMkw7Vd0LFGuo
         zQXYPYVzGR+NMYNZrGAnT3k4BHXNLYurl6zzk7tDRNWWL7FKDQetr8veAazF3+LmtKd9
         OhYADd/SiGveZ3l9VPoyggd/QTmPy0VjGgbMmro2RfLBd6UUJroJuPLTTi9mzioMOVVH
         hn0ydS3PuAWwYwiZdhpy5ln1pIaZic5mf25LEGcX+xy6KbP3nj9SpAtCvkbUQuyUvso5
         ObSODUTyZSymTzVac+AICwPU0rco4jp4yvH4HDWLpFfBeN1afGQqAZie+2DNsUyt6dMQ
         a5aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764028107; x=1764632907;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KD9mOy62HqGMPaOYo+qJ4jLF6S4k7Y6n0q2fK45fvpw=;
        b=K5qFJJCQpKrZKT39o54cS2cv4qdFUthWN/1r4ABpUBgrjdOBxlTYOa82m0c5uYSJhx
         jDEJa585lx92c50pWMLpft5soqEXWomsvhXFi5XgQlkisufMNTVE+7o2J52pt1aAb1Qd
         dTuR/glb5Xe542cOSikC6SWFTSQEWssLKKYSqnIGpUkgBpVH41u5oQBkyXokkhOVU1Sb
         aiLEbtfHRtLl1RRuj2UZhZWqREaShP8NOvdmAwTPECpoM9Uypmet1s98yRnpIX4uUSLY
         fgc+GHs7U6X7QPKPIR5BwAV46gA1NcojZvuh4ApnfhRQm/Xq2Fcn+mhY74SigzTsviys
         bJ4w==
X-Forwarded-Encrypted: i=1; AJvYcCVvwufM23PWxd3zob9LaT8+8/K3M+5LK8x1fxXfpXgbaEvo7th+OacsbGiwIl7ZU9RdPnMa1vPEeA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxcxPgFBRmPIqUez3wRqLJJ5Ekjizf890es2ii3ETe3iQsNfPpt
	CuLc1jYB5Mv/LXIwp7osl+3IrGx7Vp/c45l+R6l0Vl8NG1fYq2SxS6lD
X-Gm-Gg: ASbGncsO4EYQ/EzRWD48Nh0aD0tc2dPEl61mQXIj12YqA4WudnheZhMtbvdw5rBT5iP
	/TGaPehPceWHuPumyF7+0oY52yy8FPCjcHOZ3OWdaSgm26EQOnEJPHxE+yqpfGZ366lzlFP4WmI
	LnXDBVAJEZs+p9cKLv6vUbz+yWTki9jDXkJjDIDFjCCjToKQv0ip6gMn+NtlrxyITBHsxHtWdtP
	hcg280fOwKApnMOZ7LWqUB5jcF5ywIY/1wObdLfGyl43/52McZbD6jTB06sAKI5JmGxxuXk9eHi
	ZXPGV0igEvQnTh0j1nEeIoJFIbsXx9Sz7tPZViUnJjbN9/ehOtkFK1WpIXqadb2jm21H/dyozRF
	Q7xhP96M1O30rTD3OiRItnq6UR2OZmfFxsTM0L+zLsTK/4Sd2r4DOskuwrYnFreH3q0DfOtaRlK
	RojyF3a1aKpqdfVdRmBUpC7Zk59s0BuQiLuNz809m6Pc0RlcU=
X-Google-Smtp-Source: AGHT+IGqGWPp3dbaz9P/oMvxkH8tM768OBnx1ym9H6OndIwxHy5XjYnjyPQDBtMIVrKtoM7S3ehYMw==
X-Received: by 2002:a05:693c:810c:b0:2a4:3593:9697 with SMTP id 5a478bee46e88-2a719279965mr8848102eec.20.1764028106837;
        Mon, 24 Nov 2025 15:48:26 -0800 (PST)
Received: from localhost (ip70-175-132-216.oc.oc.cox.net. [70.175.132.216])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2a6fc5b122dsm56253333eec.5.2025.11.24.15.48.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 15:48:26 -0800 (PST)
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
	Chaitanya Kulkarni <ckulkarnilinux@gmail.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH V3 4/6] nvmet: ignore discard return value
Date: Mon, 24 Nov 2025 15:48:04 -0800
Message-Id: <20251124234806.75216-5-ckulkarnilinux@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
References: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__blkdev_issue_discard() always returns 0, making the error checking
in nvmet_bdev_discard_range() dead code.

Kill the function nvmet_bdev_discard_range() and call
__blkdev_issue_discard() directly from nvmet_bdev_execute_discard(),
since no error handling is needed anymore for __blkdev_issue_discard()
call.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
---
 drivers/nvme/target/io-cmd-bdev.c | 28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index 8d246b8ca604..ca7731048940 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -362,29 +362,14 @@ u16 nvmet_bdev_flush(struct nvmet_req *req)
 	return 0;
 }
 
-static u16 nvmet_bdev_discard_range(struct nvmet_req *req,
-		struct nvme_dsm_range *range, struct bio **bio)
-{
-	struct nvmet_ns *ns = req->ns;
-	int ret;
-
-	ret = __blkdev_issue_discard(ns->bdev,
-			nvmet_lba_to_sect(ns, range->slba),
-			le32_to_cpu(range->nlb) << (ns->blksize_shift - 9),
-			GFP_KERNEL, bio);
-	if (ret && ret != -EOPNOTSUPP) {
-		req->error_slba = le64_to_cpu(range->slba);
-		return errno_to_nvme_status(req, ret);
-	}
-	return NVME_SC_SUCCESS;
-}
-
 static void nvmet_bdev_execute_discard(struct nvmet_req *req)
 {
+	struct nvmet_ns *ns = req->ns;
 	struct nvme_dsm_range range;
 	struct bio *bio = NULL;
+	sector_t nr_sects;
 	int i;
-	u16 status;
+	u16 status = NVME_SC_SUCCESS;
 
 	for (i = 0; i <= le32_to_cpu(req->cmd->dsm.nr); i++) {
 		status = nvmet_copy_from_sgl(req, i * sizeof(range), &range,
@@ -392,9 +377,10 @@ static void nvmet_bdev_execute_discard(struct nvmet_req *req)
 		if (status)
 			break;
 
-		status = nvmet_bdev_discard_range(req, &range, &bio);
-		if (status)
-			break;
+		nr_sects = le32_to_cpu(range.nlb) << (ns->blksize_shift - 9);
+		__blkdev_issue_discard(ns->bdev,
+				nvmet_lba_to_sect(ns, range.slba), nr_sects,
+				GFP_KERNEL, &bio);
 	}
 
 	if (bio) {
-- 
2.40.0


Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807A92765ED
	for <dm-devel@lists.linux.dev>; Mon, 24 Nov 2025 23:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764028105; cv=none; b=kgD+MEG5hpsboQHqLkbBprQV01CZm2W1X2bCbKhOfcnOMfZ4Zv/y/YwCkuWYPakfu/Xikbu+gPAPLiHu6h/idzbaWX7RUEtYKsVNGXy8AuFr/ziXC8SAsh6/wUp5G2iVFePcKHJ4PpxTFX0D6qY0vAsu1DSdWaxbQwOpMxMJ8xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764028105; c=relaxed/simple;
	bh=O/JUDf1xQdyUKKqPMxOm/ySwho1/juV+ixb/yhr4OcA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PDboGCFA8WNoq4/K/fXZIZEUcHLP4J7T521TRshimn8F+YiIeahwSEcF8UB6bBopkjT1oNTRGYTnY9rzW2ypO7DNcNXJ6ogHXXRPvR7ysybY8nQYAqHhAuDF0lPlM3j9MffvNjnevpQhD8L4cqitX+biFL8mqbris4tcOHZaaMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i4zPyejK; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i4zPyejK"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-29808a9a96aso56281875ad.1
        for <dm-devel@lists.linux.dev>; Mon, 24 Nov 2025 15:48:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764028103; x=1764632903; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YcqbQ5S4JXXbau3fgh6ZbMU20qGzRcIfkGSPAKTqhkc=;
        b=i4zPyejKCERx6+6qf/3CNV6bmxom7VZLsfJCKwXMHXUpY7KwJyDE50qDQcD37AJX/X
         YoJD4SFlJLJGdCPXJH3h5u7JH8sKcULsTv3J6d9+SQ/pFWjsU4OtquILFJ40jUSoSzF6
         bzp5uIraDVFFTIfKvOC4F4uJaxCesWHirdo3Gw2e1V9xcbe+2YiJLtxOwVBxD54lNcL1
         zgrL93lcytumdXSmMylfsz+Rp2Fp0CuHBu3y84qftH+gpI4wmfBhDsrnx4hNu/Ts8032
         jztp4ef8XYqbE1BYeBhDoAtlYbrHKPaiN8AmKU3OMGPIpCbfrw7D9esSkUdTWsyY0+3h
         vNQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764028103; x=1764632903;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YcqbQ5S4JXXbau3fgh6ZbMU20qGzRcIfkGSPAKTqhkc=;
        b=vSvliGioO2kp4EAXRqNpglZ3v07plTxCVj2ocZaV/LKDLr44uuBQC/EtI/axBXv9fp
         8Qu+RIMAEndpXJF2QQ03rTWBJ6Z+wMGQC90EDpG5guZvxhS9kkkrD37a1bJfBfTgvkxs
         CZWUSIc4xOV7bb+EBZiLaDUrxqdbuhRoKWltEU3NR0/xqlTMQUqA9Oj3JhtQhngwsGFN
         zHFztLP3YyPWQL6IhIA6aC0CtFz1Eb4ukJFsH9F084s9lYgB9qMU8lSE75OS2mJ+Q2W5
         yBbFnHeGrL3+N4QtXa0ERqDBNa1MtyahoYDUVCC7Xf9j+ow3ZhV3CLI56ryf5g7fzPUE
         DG2A==
X-Forwarded-Encrypted: i=1; AJvYcCUtY8KdtFFrgMMm+sfhsV/XWBr5vTKNlzk6VjKzfLgSN2pq4zZIBQt+jT8X8ERIibX2/wqOmGRhuA==@lists.linux.dev
X-Gm-Message-State: AOJu0YziqsSQy7EdTZCIgjGdC9LQU5Jw21j5h33U0k6F0N7aQsBIRv5w
	ZZdPTuODhUjTPDrehmgKLtZsT5wVga82+5ADuUMglhavFTgW7SadSz96
X-Gm-Gg: ASbGncvBDH2IRv0EbkI+v0UrydL2x+NU/M3aC9cqr/ZXidEsoLY0mun5yK7xH6pFO4R
	5KooAWYYd3GltHW913ib26/WrDLyKH5ZQETEL4g2dDDbJ/iLgJcu/6kzkW3aYE+PVeuKXxu2SL7
	T+T2cZYA/0UZ94JgZTGBCiA8O4XBpdfvSAiCZaZ9wddLalgQ8L0xegnKaolTD3o+AjNgJniw4n5
	vqjIHyR+DsomTRUSdWFwqkHT7oI1JDBGzBCjbln4CZ7CvIB5/RlTfcgsPoSZBBH6xgPHHSUcGn3
	Bjg9a7ueDC8Jl/Egdp2bkLRSTl+ng26en985W6ifrEMt0NjzkRt3VpMsdtLPO/LvltNKdn6e40O
	ZKnztet4j0lm+IgGUd3yPOsEYWCsnH1mFgZzUm6dRX1Y9Umsp8WLTZL1VFYztfOTe/XmK227FL9
	d0DMPShhzty0nU9iYBHJClqKXfScKpIUi8Lv8kLt2cybz4pfg=
X-Google-Smtp-Source: AGHT+IH9F80PvdpBpbojg7Y02KngkDHXsfXBdGLUzofDSvSvFO71NKJ3uHp3bN/w9c26If04NsQEQQ==
X-Received: by 2002:a05:7022:d45:b0:11b:c1ab:bdd0 with SMTP id a92af1059eb24-11c9d863a0amr6183635c88.35.1764028102624;
        Mon, 24 Nov 2025 15:48:22 -0800 (PST)
Received: from localhost (ip70-175-132-216.oc.oc.cox.net. [70.175.132.216])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11c93cd457dsm72215056c88.0.2025.11.24.15.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 15:48:22 -0800 (PST)
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
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH V3 1/6] block: ignore discard return value
Date: Mon, 24 Nov 2025 15:48:01 -0800
Message-Id: <20251124234806.75216-2-ckulkarnilinux@gmail.com>
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

__blkdev_issue_discard() always returns 0, making the error check
in blkdev_issue_discard() dead code.

In function blkdev_issue_discard() initialize ret = 0, remove ret
assignment from __blkdev_issue_discard(), rely on bio == NULL check to
call submit_bio_wait(), preserve submit_bio_wait() error handling, and
preserve -EOPNOTSUPP to 0 mapping.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
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


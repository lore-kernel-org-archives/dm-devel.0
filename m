Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6D6381B19
	for <dm-devel@lists.linux.dev>; Mon, 11 May 2026 21:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778534647; cv=none; b=Q3jfUM4/DfSW64CxGTZII7fDKsq0NeDPSHOQShYc/l0YciQfJFw2pB7HQx40R/MMt6HOVGnR8q2a0DR553DTcZSao85rnqJLqRVMpvi7KsOtaqnet/UzsvS4TMRq9nxLcRoxm0qXmrD7s56qumXSxCsw0LxmY7oViqdX4BVLd5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778534647; c=relaxed/simple;
	bh=3thlf8owW1YrKqHXFc7okAlkd2LemVmenzlnMg4WkV4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=t8piohZOVEFJzvjNNa3EaXnbJZlmE+Ra6JumngBI/zFv2YshOVHIYlDigrzkTrdwF8FJx855RArIk7Nl7q7ElZmIonJ5qnUWKPj4gwTd7ZLDoZfzKUZsPpINV9CPLqYUL57ud4T0FZEYmLDJsrwuKGp+sAbCqI4lLmFcfkWZ2rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=OsQ4mDuY; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="OsQ4mDuY"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4891b02a0acso4468395e9.3
        for <dm-devel@lists.linux.dev>; Mon, 11 May 2026 14:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1778534644; x=1779139444; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LrtoJAjNIEskZcGprZzXovRMS9udKv5uVIH5xK3Q3Q0=;
        b=OsQ4mDuYdWfZAcS0J/M1qIxwz6h9sfv9J3NocjuEB/vC9u9tfuqQw5A3MzhVBhfU74
         y3RHm9RLtCIms2R1v06C49AVurUW89CvSZL1ybSjPSJe/I9u70Nv0Nso0sXaT8Ki9GRK
         G5BSUsk2+MlmkTMe/ZjusZhM7308WrIlqrmD3+pqdktxnAvT/Tb5XAJhtYSquJYW7X37
         WLIaZttTzW3MHISqnevGaXtpCimeG2cnU+qbil8DW7GKybb/GS/P5Ukd3/p9rOCuaqs1
         wrxxjr21PD835QInG3OYLcLxlJQ27nfzK6i2NBeOmvK+1FHgqlNEsYhPunpQHALs/KIC
         12Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778534644; x=1779139444;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LrtoJAjNIEskZcGprZzXovRMS9udKv5uVIH5xK3Q3Q0=;
        b=mdxdU3ZzNRrftZ8sf9qjTQt13IG71fx7st5eWnXclDBo+B0McwnY0vtF1jVAPHxgSq
         9i8jDyHjs23eSLvjtBrxkZ98H505zGWd9ntURPW7z0F03pCtNh3+TAO0F21KIk2aRF3P
         nRSjui2t8qs8iHIIBQT8Gs2ONMNCetu/RfHT5ZgRY3dSVndiV8aWZG6HskEmEyTc19Iu
         BRJMiU9cj8JG4ft7UnZC2H/DpXkfWVi/8rC4MBqLRdnx+7yuLL5q2hBUGhuS/uczsmHD
         PKDyAMgDfeCit6smukQaJuMTFrdiWDe2huQjGpDKm4pTZGDYlmZov79tLSDtZJL3DoIV
         tsUQ==
X-Forwarded-Encrypted: i=1; AFNElJ8XKFhInYhXUx5Ylkwksq3Enu6rZkiRJ2Sv1BQrhoyQcxxUcoITLLSIvPe/hdm/f80S3Bp+5nwB5g==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw9OIRCx3vNpFl0yWx8pEE/IeJH+MaDxBA2Uf3LL9FyIS1dtDSD
	bKGauPqMl4xKXDNp91H5OBQ/lK4rPznmhv+itQvAtRMKMPTiKC73dhN0QGrGl+PdlNs=
X-Gm-Gg: Acq92OGOuUQegaCVYgCgfKL8ZZeR2IqT3XdQOW9ivd35j6E2b+8pxHpPl8wamGPfCWR
	ZgMQCM2+tfzDjFSjIdkAhGzePsLThnihv41L0QS2AWqHJWrYrPMiqtoyhS7YdB+PWVV4PWvbp1i
	sXw7wHwbgK+HMoAthSfmqlDv/SebuigoXuoOqvWJim58k1lP64ictJ7h8vua5OthjgmdWauFAIc
	PkZdARe96P+rxkM3pBp3x1X1FxFuWuBVCV/JyhmtwRwJ489h9wP6es7fo9/wTEIDUpLVnlHxLzd
	+C7e9rwQE8Oi90+5GKKaHla2cL7X6vcpCnA4gcuMNnjw2OyEuXC/b9bPW4xA7IVkaGM0r9IGtWQ
	RJYIAq2JVcKHOcO1QzEzgcobWqFXfzcGdpVa3zbnupJbCXxFOkQ+kZHlj2CD6VHcX4h6/T5ZE9p
	3pux3lbOC80n8waV53UUk2q1FSNpQCqR5xpr3E+4ZJuDUzWHtV
X-Received: by 2002:a05:600c:3595:b0:48a:5664:f44a with SMTP id 5b1f17b1804b1-48e5325018dmr229880365e9.2.1778534644261;
        Mon, 11 May 2026 14:24:04 -0700 (PDT)
Received: from dev-cachen.dev.purestorage.com ([208.88.159.129])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-48e702e042dsm219069155e9.5.2026.05.11.14.24.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 14:24:03 -0700 (PDT)
From: Casey Chen <cachen@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	Casey Chen <cachen@purestorage.com>
Subject: [PATCH] block: recompute nr_integrity_segments in blk_insert_cloned_request
Date: Mon, 11 May 2026 15:22:30 -0600
Message-ID: <20260511212230.27511-1-cachen@purestorage.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

blk_insert_cloned_request() already recomputes nr_phys_segments
against the bottom queue, because "the queue settings related to
segment counting may differ from the original queue." The exact same
reasoning applies to integrity segments: a stacked driver's underlying
queue can have tighter virt_boundary_mask, seg_boundary_mask, or
max_segment_size than the top queue, in which case
blk_rq_count_integrity_sg() against the bottom queue produces a
different count than the cached rq->nr_integrity_segments inherited
from the source request by blk_rq_prep_clone().

When the cached count is lower than the bottom queue's actual count,
blk_rq_map_integrity_sg() trips

	BUG_ON(segments > rq->nr_integrity_segments);

on dispatch. The same families of stacked setups that motivated the
existing nr_phys_segments recompute -- dm-multipath fanning out to
nvme-rdma in particular -- can produce this.

Mirror the nr_phys_segments handling: when the request carries
integrity, recompute nr_integrity_segments against the bottom queue
and reject the request if it exceeds the bottom queue's
max_integrity_segments. blk_rq_count_integrity_sg() and
queue_max_integrity_segments() are both already available via
<linux/blk-integrity.h>, which blk-mq.c includes.

This closes a latent gap in the stacking contract and brings the
integrity-segment accounting in line with the existing
phys-segment accounting.

Fixes: 76c313f658d2 ("blk-integrity: improved sg segment mapping")
Signed-off-by: Casey Chen <cachen@purestorage.com>
---
 block/blk-mq.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 4c5c16cce4f8..d0c37daf568f 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3307,6 +3307,25 @@ blk_status_t blk_insert_cloned_request(struct request *rq)
 		return BLK_STS_IOERR;
 	}
 
+	/*
+	 * Integrity segment counting depends on the same queue limits
+	 * (virt_boundary_mask, seg_boundary_mask, max_segment_size) that
+	 * vary across stacked queues, so recompute against the bottom
+	 * queue just like nr_phys_segments above.
+	 */
+	if (blk_integrity_rq(rq) && rq->bio) {
+		unsigned short max_int_segs = queue_max_integrity_segments(q);
+
+		rq->nr_integrity_segments =
+			blk_rq_count_integrity_sg(rq->q, rq->bio);
+		if (rq->nr_integrity_segments > max_int_segs) {
+			printk(KERN_ERR "%s: over max integrity segments limit. (%u > %u)\n",
+				__func__, rq->nr_integrity_segments,
+				max_int_segs);
+			return BLK_STS_IOERR;
+		}
+	}
+
 	if (q->disk && should_fail_request(q->disk->part0, blk_rq_bytes(rq)))
 		return BLK_STS_IOERR;
 
-- 
2.50.1


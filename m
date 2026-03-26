Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DA11EEA31
	for <dm-devel@lists.linux.dev>; Thu, 26 Mar 2026 04:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774498454; cv=none; b=NRY0fqZXATauqgouvsE6eeRrzZuvYQdspU4Dl3LQBNv4dSLcdWoLkl+Lt5DBaAXePh1xhT7UMNfK58E8jkC8wCNc01jEuYO37kPzty6ioNZSSoZJBPF09yGxOq0pmuGBKYcVEmDrnaU7XzhAkGEmnTQ1qGzVQfLDy9gIOM2CpSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774498454; c=relaxed/simple;
	bh=DyQeCFKi9GZc/taP2lccAYrEAdGOXF5bfDvpSUu3F/4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=b3NsN/JoXy0TSPnL+dxXxUV33j+T+UiTBLkkhs2JtdBryEZsYQPVKTCRPw3dzxtPl5l4eGtNX2GRnL5+8uCGr+W+ucbj6u0FVB3mXgAeWwRx8yg9Nex+gkBH50zHMgAdtDhzCpFzGRfZl2wW/lAnS4KQHUDRpoXAUxjBB3+07/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HFXP5IaX; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HFXP5IaX"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-82c20b9f989so280512b3a.0
        for <dm-devel@lists.linux.dev>; Wed, 25 Mar 2026 21:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774498452; x=1775103252; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=22US7uthXpFUornciEIu45mKxTqm34WwP4xBdw3Eh7k=;
        b=HFXP5IaXGDOCQrRV1KUAn/RHZlHcVWie56LVkM2XcJxSUWhqML2SArptQ8evyareWM
         X4PdgB8tvl/lqBA2znBXXu9wPTDBPIOQ1CZld0SwluEGMbz1g1I8ygC67A8RqMAQmQUz
         We3jh+6hhz2T2W7PDK06BLEp86StiP1dxOwkKnslmjWVbkF/kVq75qvfbvY6Bnh6mv0w
         cQufylVOkAASe3TF1PT4csE0qATEuqj3KYafFJhymhKMO5WGYUZ6xPdxgPwvtqUmfWsS
         nTpqHys6W/+EhSfOJh/1FVOhyBGJu+wZbbSHIhbJXkCKvPgxQJ0HSmRYalhZ6jvhnp0/
         3TFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774498452; x=1775103252;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=22US7uthXpFUornciEIu45mKxTqm34WwP4xBdw3Eh7k=;
        b=gxnkIoltkIIVCccwBS/IAmRK+6W2TppYassuGNrJnJhNka5xW3ZhXncer4J5QqHhel
         WmTQW2qn+4kJiJzz5V6rZ8EoAcBVOCYWfp6ehIbHaRT/1o+ikqIKHyi50WH9kAnyndk2
         dInbjgCrkRIQsNICtSMgxnHQpojv0njQe3+T2lI4qle5/OBv98WWFU0bzqUpS8JM6Po1
         eKcRSpen2pkbgq1xlnpfnXhU0bd6tHZeZhxZ9qXViowe0wxhoT4EGfwV2t0aGm0hI1Y2
         eyAxdK6/0C1SSSyrhXOfH66vRRJB5sE+Es/uvRNOA5MWqZIukhCA8rVp5AJXzlBoFNyt
         quzQ==
X-Gm-Message-State: AOJu0Yw9opJlENa7PEGv+XRRKccsYGp1WwFCSBB+oTF3jn6dHAwbYKEq
	koIuULkMz4W2+LbkJ+29yPb+QEPuk/AwJmmJWiPpMrLtx3Wg1OJKfoFkQuIUMc68
X-Gm-Gg: ATEYQzy+VcDC6fw9r2Gix96eLIZipF2hAiYjnJoh9Ywhp13wf+k+SDnzd8A+98MBPQr
	p6juvhi4qEZCWmAkaXXlymbwclvB3BTn2pgwTffvFPkWsOVLjRvK/iBLRs19lCFftWxg6Vt+w1q
	qihHthyOP+PWISIR8NOr3oZIhyoBp61tJFy241H5B7Ff2DbQc5qW7zvpL4Gf4pngOGbTKzwhR0q
	bBwLkDLQeEMngmjvfEuywIMNu7Y4Jb/ZtrmnU6YMgtYR8pcEnyQUiUSJ+nCreC+Omgmv+sgDaeH
	HEUrhqsFmINuDxkzWRCQT5BE5RNM48hKu/tsvcVQ6e9Dr1ch97mxCsmKmf5EzcRAiR4u4UuofTK
	f4tsbtt28KJdQzG8Sg7JzGfBh0lzZh0OnOZJE8YuBpNRcG+pASEuZv3buEe6eeXdT7DJ5rHtyMU
	i4Qm1guktfNxnSYy7q7nedBo/WnD5uNUm1pevqby4btYXEOo7LzzXhS3E=
X-Received: by 2002:a05:6a00:3d0b:b0:824:188b:c173 with SMTP id d2e1a72fcca58-82c6de8582amr6139470b3a.5.1774498452427;
        Wed, 25 Mar 2026 21:14:12 -0700 (PDT)
Received: from ryzen ([2601:644:8000:5b5d::8bd])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82c7d3bf324sm1335527b3a.40.2026.03.25.21.14.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 21:14:11 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: dm-devel@lists.linux.dev
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-kernel@vger.kernel.org (open list),
	linux-hardening@vger.kernel.org (open list:KERNEL HARDENING (not covered by other areas):Keyword:\b__counted_by(_le|_be)?\b)
Subject: [PATCH] dm-bufio: use kzalloc_flex
Date: Wed, 25 Mar 2026 21:13:54 -0700
Message-ID: <20260326041354.70229-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Avoid manual size calculations and use the proper helper.

Add __counted_by for extra runtime analysis.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/md/dm-bufio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 60f7badec91f..26fedf5883ef 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -391,7 +391,7 @@ struct dm_buffer_cache {
 	 */
 	unsigned int num_locks;
 	bool no_sleep;
-	struct buffer_tree trees[];
+	struct buffer_tree trees[] __counted_by(num_locks);
 };
 
 static DEFINE_STATIC_KEY_FALSE(no_sleep_enabled);
@@ -2511,7 +2511,7 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 	}
 
 	num_locks = dm_num_hash_locks();
-	c = kzalloc(sizeof(*c) + (num_locks * sizeof(struct buffer_tree)), GFP_KERNEL);
+	c = kzalloc_flex(*c, cache.trees, num_locks);
 	if (!c) {
 		r = -ENOMEM;
 		goto bad_client;
-- 
2.53.0


Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BECA3D39A
	for <dm-devel@lists.linux.dev>; Wed, 21 Feb 2024 09:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708507083; cv=none; b=ei5ImQD5hSsmu+Sfu2xcbKkUPyRBBj+Pp1UjpYZAgotvrlauoKw9FCv3iQs+qBYIDSOX0ST1NNsp8Q+aVImcH09/CfEW34SNvmML3IvBY7R7DnK67yzF7ZEWASGNgx7midczgG9pFid4CkXgvr3qEdj+5tITd3OZYJPEP/fWFzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708507083; c=relaxed/simple;
	bh=wAQj5nvfCIOH1JW9X4ndLX9htm/n/DPR7gaftd4bR28=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uwBoGySKifXFAaJtfM0clpc7oLysEDgDweFeH8t6n74YOSzkvSMw4fFEgggpYep1GT7Oo56reIQxlT9IDOiQHR9AxIJi4cCrVizA4vVqkVzMsG9XwNoKdtn/SHB6lhp7y3Z4vBoKVYrRY5zvuqcvwNGZbJw9DTGaBQaytWrTZkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=bwpzQIri; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="bwpzQIri"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1708507072; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=vb2IT9WftsLMsivtOiIkK93g1bjf2OnNq4gtLguxxug=;
	b=bwpzQIrihbiGrIlF+xLcpm7X9capHY+FkTxLDtyGiUvm2O/nUtj448zqMZxZhCogvOwEGSDbHmkrk1Uv+dJ6umxxN1wOJiZj8/p1XEZo/YqmKbfVZ2n7SLEUswEDo19QEw+TzMlQg/EaMq5xvXzKmYpxQs0YudrTj01pAYdcYVU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0W0zR752_1708507069;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0W0zR752_1708507069)
          by smtp.aliyun-inc.com;
          Wed, 21 Feb 2024 17:17:52 +0800
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To: msakai@redhat.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH 7/8] dm vdo dedupe: Modify mismatched function name
Date: Wed, 21 Feb 2024 17:17:25 +0800
Message-Id: <20240221091731.7007-2-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
In-Reply-To: <20240221091731.7007-1-jiapeng.chong@linux.alibaba.com>
References: <20240221091731.7007-1-jiapeng.chong@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No functional modification involved.

drivers/md/dm-vdo/dedupe.c:2792: warning: expecting prototype for vdo_dump_hash_zone(). Prototype was for dump_hash_zone() instead.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=8279
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/md/dm-vdo/dedupe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-vdo/dedupe.c b/drivers/md/dm-vdo/dedupe.c
index a9b189395592..a2535e909a80 100644
--- a/drivers/md/dm-vdo/dedupe.c
+++ b/drivers/md/dm-vdo/dedupe.c
@@ -2785,7 +2785,7 @@ static const char *index_state_to_string(struct hash_zones *zones,
 }
 
 /**
- * vdo_dump_hash_zone() - Dump information about a hash zone to the log for debugging.
+ * dump_hash_zone() - Dump information about a hash zone to the log for debugging.
  * @zone: The zone to dump.
  */
 static void dump_hash_zone(const struct hash_zone *zone)
-- 
2.20.1.7.g153144c


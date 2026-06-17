Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD662E7390
	for <dm-devel@lists.linux.dev>; Wed, 17 Jun 2026 02:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781662294; cv=none; b=kPipDaLh+o5FLURlOS/X6ZnU41atirkyvsyDFlhqqTPQ4SDNPs5UPauXOblDrJw7G3vO960nPXhDq0VSK8fQkcQbJzLAErSBW7IFSA58HCbSVYge4YMWpeUrhMpRB0Osbr8j1xYpuCXEdkW+8bkNIUsdOwJ+ToVk0wtl0XfeL6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781662294; c=relaxed/simple;
	bh=EljJLluEGc0ho8fAeUApgB5OMbMmTVkm2t9KK5/bqsc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Mt3cTnBVZkc8NXXuRsWYwXLQrGDHAmeWGw7HbIMqOqoomL9TqIA0mMPUYupEnVYheBXSZhEUM9NQQjZNtanr36873hoNz+6kjs8g62tatg5Q4zxHlSlICfUUW/ycpySgBJQnL1bgvV+hEryh2ml71Aots4/ygt0/LJ+tulJ8b3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=UV1GbdyP; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="UV1GbdyP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=r5
	RDwkhjs4Y5rBiG7yrjf6iT6unRBSjoN7B9knkLfRQ=; b=UV1GbdyPTa3PbzD5+P
	i5wvCh+gacP9brUVbAURYH0BPTmPS5le9hRnhYTOGkg93QquhwoNeZWCZlxdAnVm
	R/BuOwpjUQNRFaLioEmDXLt0fJRN793hZ2Q1mtPcJ2WjNmCEM8KKhaBfnq3MNRho
	ESyIuaeJOHXee+GVnqc7/Zwhc=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wDnL2k_AjJqcPsZEA--.54106S2;
	Wed, 17 Jun 2026 10:11:11 +0800 (CST)
From: ghuicao@163.com
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Joe Thornber <ejt@redhat.com>,
	Cao Guanghui <caoguanghui@kylinos.cn>
Subject: [PATCH] dm cache policy smq: fix promote level threshold clamp
Date: Wed, 17 Jun 2026 10:11:09 +0800
Message-Id: <20260617021109.31595-1-ghuicao@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnL2k_AjJqcPsZEA--.54106S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7ArW5ZF47AF4rCFW7uF1xZrb_yoW8CryfpF
	W7Wr9Yyrn5XwnFq3ZxKa4UXF9Y93W7JayUuFWqkryUZ345XryUAr4Ikw4DJFyrtFnrXF43
	ZFnIvFWak34DCF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jO9NsUUUUU=
X-CM-SenderInfo: 5jkxxuldr6il2tof0z/xtbC4AC3SmoyAkBPmwAA3T

From: Cao Guanghui <caoguanghui@kylinos.cn>

In update_promote_levels(), the threshold_level is clamped against
NR_HOTSPOT_LEVELS (64) using max().  This is wrong: threshold_level is
later subtracted from NR_HOTSPOT_LEVELS to derive the actual promote
level, so a smaller threshold_level means a higher promote level (more
eager promotion).

The comment above explicitly states that when the cache has unused
entries, "we want to be really eager to promote".  default_promote_level()
returns values in the range 1..8 for this case, which would produce a
promote level of 56..63 -- but max(threshold_level, 64) forces
threshold_level to 64, making the promote level 0 regardless of the
allocator state and defeating the eager-promotion logic entirely.

Replace max() with min() so that threshold_level is properly capped at
NR_HOTSPOT_LEVELS while still allowing small values to produce high
promote levels as intended.

Fixes: b29d4986d0da ("dm cache: significant rework to leverage dm-bio-prison-v2")
Signed-off-by: Cao Guanghui <caoguanghui@kylinos.cn>
---
 drivers/md/dm-cache-policy-smq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-cache-policy-smq.c b/drivers/md/dm-cache-policy-smq.c
index dd77a93fd68d..b3e5f7a12345 100644
--- a/drivers/md/dm-cache-policy-smq.c
+++ b/drivers/md/dm-cache-policy-smq.c
@@ -1064,7 +1064,7 @@ static void update_promote_levels(struct smq_policy *mq)
 	unsigned int threshold_level = allocator_empty(&mq->cache_alloc) ?
 		default_promote_level(mq) : (NR_HOTSPOT_LEVELS / 2u);
 
-	threshold_level = max(threshold_level, NR_HOTSPOT_LEVELS);
+	threshold_level = min(threshold_level, NR_HOTSPOT_LEVELS);
 
 	/*
 	 * If the hotspot queue is performing badly then we have little
-- 
2.25.1


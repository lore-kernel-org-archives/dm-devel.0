Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99CF922324
	for <dm-devel@lists.linux.dev>; Wed, 29 May 2024 02:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716948764; cv=none; b=iRAW837wnjWvYuUYAc37gtfngivAu6QdZ/mCeMVssCaQJN+fSjX1ES1YR2aQijJwkcP/Ubb0Qx7KI5ZaUUjJRZ/MDghJ7XLZ81pnCaXwtk95K7ZcAiHqADoAiZtR0ldRhrXnrs4fkyGd9deTKMVha6HRUrM2aXVxw9Aot0nfA9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716948764; c=relaxed/simple;
	bh=QfND/PD5GrGnKbwK+0FJycGdhW/D1Jmpc9axx2H3JGg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=EtndBmHFdd6RYB6YqIcHeVWfzl/HO1Qc13CZ3LdVhAReqV0q433QAdN060MjnkmRyZFdT4vZJLYWu1jM5mONIKBrJWPGFKOZIlpqDyCNBCGnUZeFxfwduNEXLUPfFfS4SleQD/mpk4ZwQio2xA0rsg+UPJm/YPYY9YtILAqa49s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=HRSdr8mM; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="HRSdr8mM"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1716948758; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=diY8Yj7pHCeARPPadn/ZK5HGSeSyGpgtjlSUI3jYyZ0=;
	b=HRSdr8mMfWr05qLRrX6BLm+pP+7kF9OE4rSYN8i5m2jXnjGNEpNxfLwuBAkPWv1Z7k43UbydWcSeolENWNBZHXvPDJpvFAOYZdErGGB4PGc1HlQbxSRaagVMCli+y5f8j5vYWfe4lVCEAeGHnqN4RudTCFD001S7STNZ1GouTp4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032014031;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0W7RADWX_1716948752;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0W7RADWX_1716948752)
          by smtp.aliyun-inc.com;
          Wed, 29 May 2024 10:12:37 +0800
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To: msakai@redhat.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH v2] dm vdo indexer: Use swap() in swap_open_chapter()
Date: Wed, 29 May 2024 10:12:31 +0800
Message-Id: <20240529021231.21043-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use existing swap() function rather than duplicating its implementation.

./drivers/md/dm-vdo/indexer/index.c:207:43-44: WARNING opportunity for swap().

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=9173
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
Changes in v2:
  -Amend commit message to make it more clear.

 drivers/md/dm-vdo/indexer/index.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/md/dm-vdo/indexer/index.c b/drivers/md/dm-vdo/indexer/index.c
index 1ba767144426..df4934846244 100644
--- a/drivers/md/dm-vdo/indexer/index.c
+++ b/drivers/md/dm-vdo/indexer/index.c
@@ -197,15 +197,12 @@ static int finish_previous_chapter(struct uds_index *index, u64 current_chapter_
 static int swap_open_chapter(struct index_zone *zone)
 {
 	int result;
-	struct open_chapter_zone *temporary_chapter;
 
 	result = finish_previous_chapter(zone->index, zone->newest_virtual_chapter);
 	if (result != UDS_SUCCESS)
 		return result;
 
-	temporary_chapter = zone->open_chapter;
-	zone->open_chapter = zone->writing_chapter;
-	zone->writing_chapter = temporary_chapter;
+	swap(zone->open_chapter, zone->writing_chapter);
 	return UDS_SUCCESS;
 }
 
-- 
2.20.1.7.g153144c


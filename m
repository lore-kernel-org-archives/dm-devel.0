Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFF83D39F
	for <dm-devel@lists.linux.dev>; Wed, 21 Feb 2024 09:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708507104; cv=none; b=NmlLa+NpBxUyzrdPeUpHPJc4G6DqnE3RtEc3fYvjH3BwvimRJ8omzLIrawziiF+k2gDguQOImx/7htytd6Wzs/UPyOXCDR2BtxV0mYOyTdVOR9xawKfyczxaZpDhqvnzChcmh3cglz0MBssq/8k+skJt3uDKj5WhO2MZ+ESLpCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708507104; c=relaxed/simple;
	bh=DjgY7bAZ9T8xEy3KDoP6aacTCgTCIWYCv072iKBc3EM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZVmZU05OdQx2BzvAMUT8Ek/oUU/fDJCqfd5XkD5O6Rd+ux22/nestY41HaQjGH66/cDzvvAmqAHP4/uVgDq5H4vIVcQRhjBhXq+DuAxLUbtKean+A3r7DVYji4MSvBZFwfVLClhoKTXmC1k48dQAa97YCZg84EVrwaeslmeaos8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=kGS90Qyc; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="kGS90Qyc"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1708507100; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=H+yXYdlmM2cTVEG8BEGhhGpI8kjP2TWp0saBUxSR6gg=;
	b=kGS90QycrCo1qr4Qzh95aVh0fgyszTYUCBdZxhfhYcFDDvcVFoQ6yF64mKFdfbJ+8AwmFYFk4TxP2sg6ipvga/DE/9WpxCw5zMNPZwcU9x7FKrlVV1vRXFfAcmWzyBnnd4Tcr/YSUipdUmBofHxNoelCWkNTf65bGddQGQkXD4I=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R891e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0W0zOZwD_1708507098;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0W0zOZwD_1708507098)
          by smtp.aliyun-inc.com;
          Wed, 21 Feb 2024 17:18:20 +0800
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To: msakai@redhat.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH 2/8] dm vdo: Modify mismatched function name
Date: Wed, 21 Feb 2024 17:17:30 +0800
Message-Id: <20240221091731.7007-7-jiapeng.chong@linux.alibaba.com>
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

drivers/md/dm-vdo/slab-depot.c:2042: warning: expecting prototype for vdo_find_free_block(). Prototype was for find_free_block() instead.
drivers/md/dm-vdo/slab-depot.c:5036: warning: expecting prototype for get_depot_slab_journal_statistics(). Prototype was for get_slab_journal_statistics() instead.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=8274
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/md/dm-vdo/slab-depot.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-vdo/slab-depot.c b/drivers/md/dm-vdo/slab-depot.c
index b11972a8a08b..a85d2983800d 100644
--- a/drivers/md/dm-vdo/slab-depot.c
+++ b/drivers/md/dm-vdo/slab-depot.c
@@ -2029,7 +2029,7 @@ static inline slab_block_number find_zero_byte_in_word(const u8 *word_ptr,
 }
 
 /**
- * vdo_find_free_block() - Find the first block with a reference count of zero in the specified
+ * find_free_block() - Find the first block with a reference count of zero in the specified
  *                         range of reference counter indexes.
  * @slab: The slab counters to scan.
  * @index_ptr: A pointer to hold the array index of the free block.
@@ -5026,7 +5026,7 @@ get_ref_counts_statistics(const struct slab_depot *depot)
 }
 
 /**
- * get_depot_slab_journal_statistics() - Get the aggregated slab journal statistics for the depot.
+ * get_slab_journal_statistics() - Get the aggregated slab journal statistics for the depot.
  * @depot: The slab depot.
  *
  * Return: The aggregated statistics for all slab journals in the depot.
-- 
2.20.1.7.g153144c


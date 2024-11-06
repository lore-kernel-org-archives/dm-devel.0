Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB3917BEAD
	for <dm-devel@lists.linux.dev>; Wed,  6 Nov 2024 01:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855311; cv=none; b=X++dOi1cezLYelk+/qgXiGplp9L1L+IDw9dcDc132MSIet1Fvz5HIgBGNNQ1zQj1ouFgte42bJdK3cAnI2f8lY+CtfQNqqKfOHXs5BCtT+n9cpCqOTdu6zKpdnH4FkXksHNbeEU/zL0od92GCnZ//wBfcqZ14FlQYufKaa4QcyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855311; c=relaxed/simple;
	bh=l28cFNNid/5zlajvqOtiuLboz6CKLDPvHrqI0Mykwcg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cNLSVlLWb7tmBno2EUhw/k5hmEmuizXdwHBjRNKkiuDSXXHe4vllEJKq86aDk+BzcpGDwOoE9JMej6IRIKBAE/qa3aCMsRgLfAvSjXJZieJZt7w5uK+3c+9OnmirBm3xNe2ACQ4SND2pi5d/Sl1GoHZm3VIDEgyPi0o0Wd0CVUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Xjn905WcQz1jwZh;
	Wed,  6 Nov 2024 09:06:44 +0800 (CST)
Received: from dggpeml500024.china.huawei.com (unknown [7.185.36.10])
	by mail.maildlp.com (Postfix) with ESMTPS id 2751E14011B;
	Wed,  6 Nov 2024 09:08:25 +0800 (CST)
Received: from huawei.com (10.175.112.208) by dggpeml500024.china.huawei.com
 (7.185.36.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 6 Nov
 2024 09:08:24 +0800
From: Yuan Can <yuancan@huawei.com>
To: <agk@redhat.com>, <snitzer@kernel.org>, <mpatocka@redhat.com>,
	<ejt@redhat.com>, <dm-devel@lists.linux.dev>
CC: <yuancan@huawei.com>
Subject: [PATCH] dm thin: Add missing destroy_work_on_stack()
Date: Wed, 6 Nov 2024 09:03:12 +0800
Message-ID: <20241106010312.19697-1-yuancan@huawei.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500024.china.huawei.com (7.185.36.10)

This commit add missed destroy_work_on_stack() operations for pw->worker in
pool_work_wait().

Fixes: e7a3e871d895 ("dm thin: cleanup noflush_work to use a proper completion")
Signed-off-by: Yuan Can <yuancan@huawei.com>
---
 drivers/md/dm-thin.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 89632ce97760..c9f47d0cccf9 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2484,6 +2484,7 @@ static void pool_work_wait(struct pool_work *pw, struct pool *pool,
 	init_completion(&pw->complete);
 	queue_work(pool->wq, &pw->worker);
 	wait_for_completion(&pw->complete);
+	destroy_work_on_stack(&pw->worker);
 }
 
 /*----------------------------------------------------------------*/
-- 
2.17.1


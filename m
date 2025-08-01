Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F621FF61E
	for <dm-devel@lists.linux.dev>; Fri,  1 Aug 2025 07:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754032265; cv=none; b=UNSV1tAclAcFe9Pne5MupV3dE1UDNg+dR6ACJz2TDt8A068OIPlCsGBPxOib8Uv+dj5DUTiIGHj/wh3s0EVMC6oDMMGTfdN3OqtlataIRYC/HKHQpsl6UQ57EuSXM0HWC/PewASXmWTfXbOBCn/4bqEWY2rXwZEBXehJw4MV8z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754032265; c=relaxed/simple;
	bh=Qt2xzD2z6inJKKpVdi9jWcP+ZJ9yv8b3lmXrLMO2ERY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=m7maFuXyDGX0w40RWFgzFMScFKfp14PGMP39wMOpfX3XooaihHRJgh2hA+kZnlWARLKWUuSQkp309JFaBqPvi1zgiE3A77q2HZLTgiJI3L7yy//vFRpXYcKsx+h6R1abWtbgbCJHEXvDMdoVI2nua3Xj8+4tCE3u9ox11AOiwxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4btcYV4Zw9zYQv2Z
	for <dm-devel@lists.linux.dev>; Fri,  1 Aug 2025 15:10:54 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 51A591A06DF
	for <dm-devel@lists.linux.dev>; Fri,  1 Aug 2025 15:10:53 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDHjxByaIxoqAzACA--.18978S14;
	Fri, 01 Aug 2025 15:10:53 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: hch@lst.de,
	corbet@lwn.net,
	song@kernel.org,
	yukuai3@huawei.com,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	linan122@huawei.com,
	xni@redhat.com,
	hare@suse.de
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	dm-devel@lists.linux.dev,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH v5 10/11] md/md-bitmap: make method bitmap_ops->daemon_work optional
Date: Fri,  1 Aug 2025 15:03:45 +0800
Message-Id: <20250801070346.4127558-11-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250801070346.4127558-1-yukuai1@huaweicloud.com>
References: <20250801070346.4127558-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHjxByaIxoqAzACA--.18978S14
X-Coremail-Antispam: 1UD129KBjvJXoWrtFyUGryxCry7KF47Zw4xZwb_yoW8JrWrpa
	y3Ww1YvrW5Aa4a93W7XF97uFyF9FyDKFWqkrWxAw13W3s8Wr98Gr4fKFyqyr95Cr1SvFnx
	AF1FvryrA3W8tFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0pRQJ5wUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

daemon_work() will be called by daemon thread, on the one hand, daemon
thread doesn't have strict wake-up time; on the other hand, too much
work are put to daemon thread, like handle sync IO, handle failed
or specail normal IO, handle recovery, and so on. Hence daemon thread
may be too busy to clear dirty bits in time.

Make bitmap_ops->daemon_work() optional and following patches will use
separate async work to clear dirty bits for the new bitmap.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Li Nan <linan122@huawei.com>
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 69bf55d4a422..90b8f9a70152 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9897,7 +9897,7 @@ static void unregister_sync_thread(struct mddev *mddev)
  */
 void md_check_recovery(struct mddev *mddev)
 {
-	if (md_bitmap_enabled(mddev, false))
+	if (md_bitmap_enabled(mddev, false) && mddev->bitmap_ops->daemon_work)
 		mddev->bitmap_ops->daemon_work(mddev);
 
 	if (signal_pending(current)) {
-- 
2.39.2


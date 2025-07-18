Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5352BE051
	for <dm-devel@lists.linux.dev>; Fri, 18 Jul 2025 09:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752831000; cv=none; b=e+2gpk2txlpJBAjIoJ38V90LuE293LiQs3NJOi9CgXEL6fFRMwasxEMa8CfK4qK8RgTY+YdbBjNht+goikr+wqZdVgyMv0scDEM6I63ApCWZnnJApGIKxe3X3DPOfLRhu1h09QJ7txD+nY+ZN5GnR3ykRLJBJRUWOdv8mWyc0bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752831000; c=relaxed/simple;
	bh=QJT6PRmTtmG29tV8wUvbW5VVgbBnc5yxc1KYbIg0zRE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tUk4n7k0s8a688pr2dImLXEMECfl7pBJEF/NIitV9b2thEEezGeox+vb4PDO8xPFeHhsO58p5eDQo36bPV6++qjhWNnyb7/TtY1CUd0EDjn7FLAQ6p0FbgjOnpPeJHKIAFhlXRDBd4q9Sdh+4jbHHPo2QYEX4OdYss4Kpif59dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4bk4JK4mBtzYQvMZ
	for <dm-devel@lists.linux.dev>; Fri, 18 Jul 2025 17:29:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 688451A0CFD
	for <dm-devel@lists.linux.dev>; Fri, 18 Jul 2025 17:29:52 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDXUxQGFHpoDl6qAg--.5172S14;
	Fri, 18 Jul 2025 17:29:52 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: corbet@lwn.net,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	yukuai3@huawei.com,
	hare@suse.de
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH v3 10/11] md/md-bitmap: make method bitmap_ops->daemon_work optional
Date: Fri, 18 Jul 2025 17:23:35 +0800
Message-Id: <20250718092336.3346644-11-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250718092336.3346644-1-yukuai1@huaweicloud.com>
References: <20250718092336.3346644-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDXUxQGFHpoDl6qAg--.5172S14
X-Coremail-Antispam: 1UD129KBjvdXoWrtFyUGryxCry7KF47Zw4xZwb_yoWkKFcE9a
	yFyr9xWrW2vF9av3W3ua1fZrZaqw4kuwnrXF47tFySq348X348WFWkuw1DX3yxtFZaya47
	ArZxXrWjyr4DWjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbvAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAVCq3wA2048vs2
	IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28E
	F7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr
	1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
	M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
	v20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
	F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2
	IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY
	6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17
	CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r4j6ryUMIIF
	0xvE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsG
	vfC2KfnxnUUI43ZEXa7VUbPC7UUUUUU==
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
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 13c17c45dd45..1ab6bba63890 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9885,7 +9885,7 @@ static void unregister_sync_thread(struct mddev *mddev)
  */
 void md_check_recovery(struct mddev *mddev)
 {
-	if (md_bitmap_enabled(mddev, false))
+	if (md_bitmap_enabled(mddev, false) && mddev->bitmap_ops->daemon_work)
 		mddev->bitmap_ops->daemon_work(mddev);
 
 	if (signal_pending(current)) {
-- 
2.39.2


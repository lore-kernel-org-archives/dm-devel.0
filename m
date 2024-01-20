Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59AED2FA
	for <dm-devel@lists.linux.dev>; Sat, 20 Jan 2024 10:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705747283; cv=none; b=N6y3unfAxprhtjSJmaPfE2uZd3GgH7F49B9eRugfwc1QEHDmn1VZWvV0K8PSwyUBlkJ6mEC3JamepX5eqYCB6r28SJTAj2hoq5FpZiFAvLYXlVktnbjJ/fb7eNw+YHOaEkUIe/iFpsAZwSW/WN/Z5mzayjgnUuE3y7tHBDfM2sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705747283; c=relaxed/simple;
	bh=7f5Ea4YOXZsVcffF1Kp4uocWgltKhjuUuA7JtCWrFY0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=b6vQLOH1Knyg5dpJHaM/BZk8h3LuPtTLJFesZZ1LsEJey6+h/uWCKVkHigVgHdFXfPBfGyJ1RZ2MZdPyB/ksm1PMlbTaslsEBfQKX5iS7dDqF2p6uM7OdLtTJWNwR1nEOlLZj4Is4Z6SYPCSkGpD1WXUnjxEEPJuTGv/jHJex60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4THChC551xz4f3jql
	for <dm-devel@lists.linux.dev>; Sat, 20 Jan 2024 18:41:15 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id EAE071A0B3B
	for <dm-devel@lists.linux.dev>; Sat, 20 Jan 2024 18:41:17 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP1 (Coremail) with SMTP id cCh0CgAn+RFKo6tlY4mmBQ--.38494S7;
	Sat, 20 Jan 2024 18:41:17 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: mpatocka@redhat.com,
	dm-devel@lists.linux.dev,
	msnitzer@redhat.com,
	heinzm@redhat.com,
	song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH 3/5] md: make sure md_do_sync() will set MD_RECOVERY_DONE
Date: Sat, 20 Jan 2024 18:37:32 +0800
Message-Id: <20240120103734.4155446-4-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240120103734.4155446-1-yukuai1@huaweicloud.com>
References: <20240120103734.4155446-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAn+RFKo6tlY4mmBQ--.38494S7
X-Coremail-Antispam: 1UD129KBjvJXoW7WF48JF18KF45Gw4rCFy7GFg_yoW8Ar1kpa
	ykGF9IvrW8ArW3urW2qa4DXa45Aw1Ivry3CFyfuas8AF1fta1akFW5uF1UXaykta4fJayY
	va15JF9xZF95C3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBK14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
	8EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AI
	xVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20x
	vE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xv
	r2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04
	v7MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_
	Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x
	0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8
	JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIx
	AIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbJ73DUUUUU=
	=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

stop_sync_thread() will interrupt md_do_sync(), and md_do_sync() must
set MD_RECOVERY_DONE, so that follow up md_check_recovery() will
unregister sync_thread, clear MD_RECOVERY_RUNNING and wake up
stop_sync_thread().

Before this patch, if MD_RECOVERY_WAIT is set or the array is read-only,
md_do_sync() will return without setting MD_RECOVERY_DONE, hence use
stop_sync_thread() directly will hang because md_check_recovery() can't
clear MD_RECOVERY_RUNNING, which is possible for dm-raid.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6906d023f1d6..ba45c7be3dbe 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8788,12 +8788,13 @@ void md_do_sync(struct md_thread *thread)
 	int ret;
 
 	/* just incase thread restarts... */
-	if (test_bit(MD_RECOVERY_DONE, &mddev->recovery) ||
-	    test_bit(MD_RECOVERY_WAIT, &mddev->recovery))
+	if (test_bit(MD_RECOVERY_DONE, &mddev->recovery))
 		return;
-	if (!md_is_rdwr(mddev)) {/* never try to sync a read-only array */
+
+	if (test_bit(MD_RECOVERY_WAIT, &mddev->recovery) ||
+	    !md_is_rdwr(mddev)) {/* never try to sync a read-only array */
 		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-		return;
+		goto out;
 	}
 
 	if (mddev_is_clustered(mddev)) {
@@ -9171,6 +9172,7 @@ void md_do_sync(struct md_thread *thread)
 						mddev->array_sectors);
 	}
 
+out:
 	spin_lock(&mddev->lock);
 	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
 		/* We completed so min/max setting can be forgotten if used. */
-- 
2.39.2


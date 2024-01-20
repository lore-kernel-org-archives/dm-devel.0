Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668C0DDA7
	for <dm-devel@lists.linux.dev>; Sat, 20 Jan 2024 10:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705747283; cv=none; b=iJ0bXh/AbM0mKbnby5RhwFBrFPfzgzG28idao8kty2ed1kYJIrwwsBafcFS81+7Iwe8nHdk4Kofwu4qLNxf/fK6JPpKNA2L1hwbGux/9mP8ErdrX/VLaq11vaXs0O31CDLIhQ9jn3Abke6bTfL5KZhzGBBPH4i1B/dn4m+9mrQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705747283; c=relaxed/simple;
	bh=vYtge49+SIPK2TMqk3PqdGYdBsr5TMvfVLJDD/vFH2A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=vCYR0T6Eqi1skyQ+XbNOX8k1unN3+6fqS2H3s0Rt3+6nDcZ6huEVyTKhEdt6dUSn7DL8wZhr30I+TXeKe1OgCKC6VwTwWhhkCpzpAj6LvVMBAPuxwQ3nctVpjDZ+LY4NE3pJBj79X+OTGbIdqgaQxPnY1juSDVx0kLGbKY6zt0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4THCh84zn4z4f3lfH
	for <dm-devel@lists.linux.dev>; Sat, 20 Jan 2024 18:41:12 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id DD55F1A016E
	for <dm-devel@lists.linux.dev>; Sat, 20 Jan 2024 18:41:18 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP1 (Coremail) with SMTP id cCh0CgAn+RFKo6tlY4mmBQ--.38494S9;
	Sat, 20 Jan 2024 18:41:18 +0800 (CST)
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
Subject: [PATCH RFC 5/5] md: use md_reap_sync_thread() directly for dm-raid
Date: Sat, 20 Jan 2024 18:37:34 +0800
Message-Id: <20240120103734.4155446-6-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:cCh0CgAn+RFKo6tlY4mmBQ--.38494S9
X-Coremail-Antispam: 1UD129KBjvJXoWrtr1UWw1xZFWUJw4kWryDJrb_yoW8JrWDp3
	yfWFy5Cr15Crs7Ar17WFyDZFyrZw1S9rWqyr9xCay3Z3W5Jr47Cr1F9FyjgFyDuFWfJwsx
	XF4rJFWfCa48KrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPF14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E
	14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIx
	kGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAF
	wI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJV
	W8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUOBTY
	UUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Now that previous patch make sure that stop_sync_thread() can successfully
stop sync_thread, and lvm2 tests won't hang anymore. However, the test
lvconvert-raid-reshape.sh still fail and complain that ext4 is
corrupted.

The root cause is still not clear yet, however, let's convert dm-raid
back to use md_reap_sync_thread() directly. This is not safe but at
least there won't be new regressions. We can decide what to do after
figuring out the root cause.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7db749ba7e60..3e8dd020bf9f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4909,6 +4909,14 @@ static void stop_sync_thread(struct mddev *mddev, bool locked, bool check_seq)
 	if (work_pending(&mddev->sync_work))
 		flush_work(&mddev->sync_work);
 
+	if (!mddev->gendisk) {
+		mddev_lock_nointr(mddev);
+		md_reap_sync_thread(mddev);
+		if (!locked)
+			mddev_unlock(mddev);
+		return;
+	}
+
 	wait_event(resync_wait,
 		   !test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
 		   (check_seq && sync_seq != atomic_read(&mddev->sync_seq)));
-- 
2.39.2


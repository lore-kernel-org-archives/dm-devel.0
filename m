Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029FE21146D
	for <dm-devel@lists.linux.dev>; Fri, 28 Mar 2025 06:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743142498; cv=none; b=Wr2xAkXVjJaM9PNgNGshHuqU6yNN4J/6kZZjkTa0+SlbF0c0KjzB6Wu5v4qj2ihkkejK5sotB3AWwANSYnEVyOcFcB5DVxyunML3ftOr3SvSaQJN1l32j60MzNfeinICVf8Ng2hscYc6CDb1+0hqLTFMbHuU55jUuRWpBm2toPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743142498; c=relaxed/simple;
	bh=SsD+8NNJV8xyX2dHM1tE/ZLu1OwTErQXDjztCmQmlpI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n53aKPEbHNeFd+aMgG2QETF4O2MDfTtpCTtGgF8Aqwklled0Bx+4ydF9wEIpLCsPS9yhbYy8X6iCF3BDa8Ti1k7Mc1mJMKreJynjUgmoAoPAGYipjyFqONjbl0Vg49Z/TQOHluB79nTxUiJulbJY5K5TLIB5BN3CNTuNI5ILgZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4ZP9GX3Y3xz4f3m7H
	for <dm-devel@lists.linux.dev>; Fri, 28 Mar 2025 14:14:28 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 00ECD1A1C6A
	for <dm-devel@lists.linux.dev>; Fri, 28 Mar 2025 14:14:52 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDHK2BSPuZnfAUtHw--.25875S15;
	Fri, 28 Mar 2025 14:14:52 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: hch@lst.de,
	xni@redhat.com,
	colyli@kernel.org,
	axboe@kernel.dk,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	yukuai3@huawei.com
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC v2 11/14] md/md-llbitmap: implement APIs for sync_thread
Date: Fri, 28 Mar 2025 14:08:50 +0800
Message-Id: <20250328060853.4124527-12-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250328060853.4124527-1-yukuai1@huaweicloud.com>
References: <20250328060853.4124527-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHK2BSPuZnfAUtHw--.25875S15
X-Coremail-Antispam: 1UD129KBjvJXoW7Zr1rJF4xur4xAryfKFyUWrg_yoW8tw1UpF
	47Ww15Cr45J3yfX3y3Jr9rAF1rtF4kJr9FqF97Aa4rGF1jyrsxKFW8Ga48t3WUWr13JF1D
	Jwn8KryrCw18XFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUQFxUUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Include following APIs:
 - llbitmap_start_sync
 - llbitmap_end_sync
 - llbitmap_close_sync

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-llbitmap.c | 43 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 982ec868ce22..1692942942ff 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1071,6 +1071,45 @@ static void llbitmap_flush(struct mddev *mddev)
 	flush_work(&llbitmap->daemon_work);
 }
 
+static bool llbitmap_start_sync(struct mddev *mddev, sector_t offset,
+				sector_t *blocks, bool degraded)
+{
+	struct llbitmap *llbitmap = mddev->bitmap;
+	unsigned long p = offset >> llbitmap->chunkshift;
+
+	/*
+	 * Handle one bit at a time, this is much simpler. And it doesn't matter
+	 * if md_do_sync() loop more times.
+	 */
+	*blocks = llbitmap->chunksize - (offset & (llbitmap->chunksize - 1));
+	return llbitmap_state_machine(llbitmap, p, p, BitmapActionStartsync) == BitSyncing;
+}
+
+static void llbitmap_end_sync(struct mddev *mddev, sector_t offset,
+			      sector_t *blocks)
+{
+	struct llbitmap *llbitmap = mddev->bitmap;
+	unsigned long p = offset >> llbitmap->chunkshift;
+
+	*blocks = llbitmap->chunksize - (offset & (llbitmap->chunksize - 1));
+	llbitmap_state_machine(llbitmap, p, llbitmap->chunks - 1, BitmapActionAbortsync);
+}
+
+static void llbitmap_close_sync(struct mddev *mddev)
+{
+	struct llbitmap *llbitmap = mddev->bitmap;
+	int i;
+
+	for (i = 0; i < llbitmap->nr_pages; i++) {
+		struct llbitmap_barrier *barrier = &llbitmap->barrier[i];
+
+		/* let daemon_fn clear dirty bits immediately */
+		WRITE_ONCE(barrier->expire, jiffies);
+	}
+
+	llbitmap_state_machine(llbitmap, 0, llbitmap->chunks - 1, BitmapActionEndsync);
+}
+
 static struct bitmap_operations llbitmap_ops = {
 	.head = {
 		.type	= MD_BITMAP,
@@ -1087,4 +1126,8 @@ static struct bitmap_operations llbitmap_ops = {
 	.endwrite		= llbitmap_endwrite,
 	.unplug			= llbitmap_unplug,
 	.flush			= llbitmap_flush,
+
+	.start_sync		= llbitmap_start_sync,
+	.end_sync		= llbitmap_end_sync,
+	.close_sync		= llbitmap_close_sync,
 };
-- 
2.39.2


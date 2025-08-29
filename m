Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D32529D291
	for <dm-devel@lists.linux.dev>; Fri, 29 Aug 2025 08:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756455203; cv=none; b=SQAF0RnFpLEhCAw+cTe4Ewonhu9D5ND/aYjnsoxKzwAKTFkrQyExsBGPoQ+krAFr0dFJGuf07DyPNpSvo8y79f6IDRerGt0deLJUR8hTd3/9vS6yyI2uHFzQnHy7sTH4kP6F4Af4g08WdWEEhix4mEYMIRbbi1Mna3llwNRdogc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756455203; c=relaxed/simple;
	bh=RGBZynnur4cyQENYoo2wIGzEb5x7LlBsw6RCRwlfddk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ND+cC0zkHKhHhjLc/vt3BX5d955PeqT2LxYUu5O5lOSZGZTOe20cpseI9d+zqmNqwGJa979gFMxO9raDI2sYjurNO8oz67SCgJoNwyLI2FRnCkkmlZh9lBqLbX0RUIhXrSDgd/cplm12SkTKEb7KWHgKqrt4HTZmKsldvLd4nh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cCrcT2PsVzYQtvM
	for <dm-devel@lists.linux.dev>; Fri, 29 Aug 2025 16:13:13 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D3FED1A1286
	for <dm-devel@lists.linux.dev>; Fri, 29 Aug 2025 16:13:11 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgB3wY0RYbFohAO2Ag--.45648S6;
	Fri, 29 Aug 2025 16:13:11 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: hch@infradead.org,
	xni@redhat.com,
	colyli@kernel.org,
	linan122@huawei.com,
	corbet@lwn.net,
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
	johnny.chenyi@huawei.com,
	hailan@yukuai.org.cn
Subject: [PATCH v7 md-6.18 02/11] md: factor out a helper raid_is_456()
Date: Fri, 29 Aug 2025 16:04:17 +0800
Message-Id: <20250829080426.1441678-3-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250829080426.1441678-1-yukuai1@huaweicloud.com>
References: <20250829080426.1441678-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3wY0RYbFohAO2Ag--.45648S6
X-Coremail-Antispam: 1UD129KBjvJXoW7Kr47Kr4xtr4fZw1xCF4UJwb_yoW8Ar4fpa
	1fXFy3ZryUXFW3tw1DX3WkZa4Fgw1ftryqyrWxZ395XF1UJr1DKF1SqFZ2qryDWayrAFsI
	qa1jyr48C3W0gw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42
	IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIev
	Ja73UjIFyTuYvjTRNiSHDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

There are no functional changes, the helper will be used by llbitmap in
following patches.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Xiao Ni <xni@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Li Nan <linan122@huawei.com>
---
 drivers/md/md.c | 9 +--------
 drivers/md/md.h | 6 ++++++
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 74f876497c09..86cf97c0a77b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9121,19 +9121,12 @@ static sector_t md_sync_position(struct mddev *mddev, enum sync_action action)
 
 static bool sync_io_within_limit(struct mddev *mddev)
 {
-	int io_sectors;
-
 	/*
 	 * For raid456, sync IO is stripe(4k) per IO, for other levels, it's
 	 * RESYNC_PAGES(64k) per IO.
 	 */
-	if (mddev->level == 4 || mddev->level == 5 || mddev->level == 6)
-		io_sectors = 8;
-	else
-		io_sectors = 128;
-
 	return atomic_read(&mddev->recovery_active) <
-		io_sectors * sync_io_depth(mddev);
+	       (raid_is_456(mddev) ? 8 : 128) * sync_io_depth(mddev);
 }
 
 #define SYNC_MARKS	10
diff --git a/drivers/md/md.h b/drivers/md/md.h
index cadd9bc99938..5ef73109d14d 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -1033,6 +1033,12 @@ static inline bool mddev_is_dm(struct mddev *mddev)
 	return !mddev->gendisk;
 }
 
+static inline bool raid_is_456(struct mddev *mddev)
+{
+	return mddev->level == ID_RAID4 || mddev->level == ID_RAID5 ||
+	       mddev->level == ID_RAID6;
+}
+
 static inline void mddev_trace_remap(struct mddev *mddev, struct bio *bio,
 		sector_t sector)
 {
-- 
2.39.2


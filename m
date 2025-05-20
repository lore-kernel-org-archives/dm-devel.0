Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C873E211710
	for <dm-devel@lists.linux.dev>; Tue, 20 May 2025 06:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747723764; cv=none; b=qk3ActnyCe7yZScahkSBG1mfEXkLRPQG6myogLf3tsHEzX9NnWBUxs99YfIgL/63L5ilgwFG/Xp3XsVk/7JZRXU/b2yv6d8NdO1WjwoATTzsvnS0h9GrGszQx0fCEUIGNXmHCx3UnQFhUqlQphDVwAqW9l5s+AGWURCg7+mt6dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747723764; c=relaxed/simple;
	bh=6HHMQFl34N/CVnYTjfqtDcxyMzJz93t3zxhG+8i3ls0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tx2JS3Ybw1muzCevycjaddjjvV3IG78CCkQvOaDtbD3bmS0QCu5TUXLdCl4D2Qub4Iv45B6DEcvQM7S8rwpakIaQCWR/ZpzlBM7X+h24kt3lFU46jo7Iu8Cv1HK/hX7KmJ0/D4AB3WOvLd85BJkCygyfvG0glbn2aD1vtbLXgx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4b1lXG0tbNzKHMYv
	for <dm-devel@lists.linux.dev>; Tue, 20 May 2025 14:49:18 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A3FEA1A12FE
	for <dm-devel@lists.linux.dev>; Tue, 20 May 2025 14:49:16 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgD3W2DoJSxo9fzPMw--.47626S4;
	Tue, 20 May 2025 14:49:14 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: mpatocka@redhat.com,
	zdenek.kabelac@gmail.com,
	song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH] md/raid1,raid10: don't handle read ahead error
Date: Tue, 20 May 2025 14:44:25 +0800
Message-Id: <20250520064425.1726564-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3W2DoJSxo9fzPMw--.47626S4
X-Coremail-Antispam: 1UD129KBjvJXoW7Ww1xGw4UWr1ruFy8tr4xJFb_yoW8uFy5pa
	9rCFyavr98Kw1UJrnrXrW7ZayrG3W3tFW5CF95A3yrZa4avrW3AF4DKFZFgr4DJF4fWa42
	vF4qgr47GFy5XFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Y14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
	nIWIevJa73UjIFyTuYvjfUonmRUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Read ahead IO can fail early in the driver, even if the storage medium
is fine, hence record badblocks or remove the disk from array does not
make sense.

This problem if found by lvm2 test lvcreate-large-raid, where dm-zero
will fail read ahead IO directly.

Reported-and-tested-by: Mikulas Patocka <mpatocka@redhat.com>
Closes: https://lore.kernel.org/all/34fa755d-62c8-4588-8ee1-33cb1249bdf2@redhat.com/
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/raid1.c  | 11 +++++++----
 drivers/md/raid10.c |  3 +++
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 657d481525be..2e4e9de2cfd7 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -373,14 +373,17 @@ static void raid1_end_read_request(struct bio *bio)
 	 */
 	update_head_pos(r1_bio->read_disk, r1_bio);
 
-	if (uptodate)
+	if (uptodate) {
 		set_bit(R1BIO_Uptodate, &r1_bio->state);
-	else if (test_bit(FailFast, &rdev->flags) &&
-		 test_bit(R1BIO_FailFast, &r1_bio->state))
+	} else if (test_bit(FailFast, &rdev->flags) &&
+		   test_bit(R1BIO_FailFast, &r1_bio->state)) {
 		/* This was a fail-fast read so we definitely
 		 * want to retry */
 		;
-	else {
+	} else if (bio->bi_opf & REQ_RAHEAD) {
+		/* don't handle readahead error, which can fail at anytime. */
+		uptodate = 1;
+	} else {
 		/* If all other devices have failed, we want to return
 		 * the error upwards rather than fail the last device.
 		 * Here we redefine "uptodate" to mean "Don't want to retry"
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index dce06bf65016..4d51aaf3b39b 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -399,6 +399,9 @@ static void raid10_end_read_request(struct bio *bio)
 		 * wait for the 'master' bio.
 		 */
 		set_bit(R10BIO_Uptodate, &r10_bio->state);
+	} else if (bio->bi_opf & REQ_RAHEAD) {
+		/* don't handle readahead error, which can fail at anytime. */
+		uptodate = 1;
 	} else {
 		/* If all other devices that store this block have
 		 * failed, we want to return the error upwards rather
-- 
2.39.2


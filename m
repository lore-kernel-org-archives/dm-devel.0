Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FBE817CA0B
	for <dm-devel@lists.linux.dev>; Tue, 11 Jun 2024 13:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718112203; cv=none; b=QLwEhTZxTtK6v7EDwr9gi3yW7vDdotSRNwNVXLS7XqpxvO/cZJWb3ZawviPgLMOr6j3e0RrKAFJl7xltsH4ObTQ6jlIbsoNq0UPNzj4KCK1PpydJURiYLRhUI5jCZq/bFyV3AXflgv08YGajcQEmUwo3//8FKUsifJr0KQ2CTf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718112203; c=relaxed/simple;
	bh=mjjBPr7zcUx3hRkQpgOPrUXJOYYdSAW6kU2Y4uYCQxA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=a/t8Bd9YnNSgJw8ormzWAEo4aJKLFnBpRO1HMNSvUkNmXnFO0tTdlHecXJG63z+YHHOyFHZebKCSY812yQ8ezhOb4pUxUVOMEUSimjcg7/ALR/hO7m8wmsBJEAY9hLdK2o8VoK1Mv/6Sse0LeBJVRcVXAis/lsVcegu/FNQMJvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Vz8W02kwcz4f3jYC
	for <dm-devel@lists.linux.dev>; Tue, 11 Jun 2024 21:23:08 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 5E8501A0ED2
	for <dm-devel@lists.linux.dev>; Tue, 11 Jun 2024 21:23:18 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP1 (Coremail) with SMTP id cCh0CgDHlxDBT2hmsVPEPA--.1557S9;
	Tue, 11 Jun 2024 21:23:18 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	xni@redhat.com,
	mariusz.tkaczyk@linux.intel.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH v2 md-6.11 05/12] md: replace sysfs api sync_action with new helpers
Date: Tue, 11 Jun 2024 21:22:44 +0800
Message-Id: <20240611132251.1967786-6-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240611132251.1967786-1-yukuai1@huaweicloud.com>
References: <20240611132251.1967786-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgDHlxDBT2hmsVPEPA--.1557S9
X-Coremail-Antispam: 1UD129KBjvJXoWxGrW7ZF1UJr48Jw43tFy5urg_yoWrXw1fpa
	yfJan8Zr4DJFy3JFW7K3WDZFW5Cr12qFWDtFW3W34kJF1fta1rAFyj93W7Ar95Jas2kw4Y
	q39rJFW3uF4YkaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

To get rid of extrem long if else if usage, and make code cleaner.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 94 +++++++++++++++++++++++++++----------------------
 1 file changed, 52 insertions(+), 42 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index b34ae9fbd246..d035cd52e49a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4950,27 +4950,9 @@ const char *md_sync_action_name(enum sync_action action)
 static ssize_t
 action_show(struct mddev *mddev, char *page)
 {
-	char *type = "idle";
-	unsigned long recovery = mddev->recovery;
-	if (test_bit(MD_RECOVERY_FROZEN, &recovery))
-		type = "frozen";
-	else if (test_bit(MD_RECOVERY_RUNNING, &recovery) ||
-	    (md_is_rdwr(mddev) && test_bit(MD_RECOVERY_NEEDED, &recovery))) {
-		if (test_bit(MD_RECOVERY_RESHAPE, &recovery))
-			type = "reshape";
-		else if (test_bit(MD_RECOVERY_SYNC, &recovery)) {
-			if (!test_bit(MD_RECOVERY_REQUESTED, &recovery))
-				type = "resync";
-			else if (test_bit(MD_RECOVERY_CHECK, &recovery))
-				type = "check";
-			else
-				type = "repair";
-		} else if (test_bit(MD_RECOVERY_RECOVER, &recovery))
-			type = "recover";
-		else if (mddev->reshape_position != MaxSector)
-			type = "reshape";
-	}
-	return sprintf(page, "%s\n", type);
+	enum sync_action action = md_sync_action(mddev);
+
+	return sprintf(page, "%s\n", md_sync_action_name(action));
 }
 
 /**
@@ -5113,35 +5095,63 @@ static int mddev_start_reshape(struct mddev *mddev)
 static ssize_t
 action_store(struct mddev *mddev, const char *page, size_t len)
 {
+	int ret;
+	enum sync_action action;
+
 	if (!mddev->pers || !mddev->pers->sync_request)
 		return -EINVAL;
 
+	action = md_sync_action_by_name(page);
 
-	if (cmd_match(page, "idle"))
-		idle_sync_thread(mddev);
-	else if (cmd_match(page, "frozen"))
-		frozen_sync_thread(mddev);
-	else if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
-		return -EBUSY;
-	else if (cmd_match(page, "resync"))
-		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
-	else if (cmd_match(page, "recover")) {
-		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
-		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
-	} else if (cmd_match(page, "reshape")) {
-		int err = mddev_start_reshape(mddev);
-
-		if (err)
-			return err;
+	/* TODO: mdadm rely on "idle" to start sync_thread. */
+	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
+		switch (action) {
+		case ACTION_FROZEN:
+			frozen_sync_thread(mddev);
+			return len;
+		case ACTION_IDLE:
+			idle_sync_thread(mddev);
+			break;
+		case ACTION_RESHAPE:
+		case ACTION_RECOVER:
+		case ACTION_CHECK:
+		case ACTION_REPAIR:
+		case ACTION_RESYNC:
+			return -EBUSY;
+		default:
+			return -EINVAL;
+		}
 	} else {
-		if (cmd_match(page, "check"))
+		switch (action) {
+		case ACTION_FROZEN:
+			set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+			return len;
+		case ACTION_RESHAPE:
+			clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+			ret = mddev_start_reshape(mddev);
+			if (ret)
+				return ret;
+			break;
+		case ACTION_RECOVER:
+			clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+			set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
+			break;
+		case ACTION_CHECK:
 			set_bit(MD_RECOVERY_CHECK, &mddev->recovery);
-		else if (!cmd_match(page, "repair"))
+			fallthrough;
+		case ACTION_REPAIR:
+			set_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
+			set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
+			fallthrough;
+		case ACTION_RESYNC:
+		case ACTION_IDLE:
+			clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+			break;
+		default:
 			return -EINVAL;
-		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
-		set_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
-		set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
+		}
 	}
+
 	if (mddev->ro == MD_AUTO_READ) {
 		/* A write to sync_action is enough to justify
 		 * canceling read-auto mode
-- 
2.39.2


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07337C83F14
	for <dm-devel@archiver.kernel.org>; Mon, 28 Aug 2023 02:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693188317;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=7+WjgBM0dqszNR/AeSn45T7AZF95ZjHc5wAI7KPAHZ4=;
	b=BQ0W9kiCBkRfwaWdtBrAGtYJhFpD+OgzoxxFfFWNAEj5tts6IRwpg3uvpYtTk0GnbEYrdQ
	LSRfEIjRxzeF8rjOS58VjcXc0i3Uv4b7/kmCPoUf5oOhLAs5Ua9rE94HK2PKGeDhdoVORr
	B4FgW2Wfc7vQtyOO14kBtULrExMYUNM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-15-PAbF23qZPxGD89nmo-Jh-w-1; Sun, 27 Aug 2023 22:05:13 -0400
X-MC-Unique: PAbF23qZPxGD89nmo-Jh-w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A49C28D40A6;
	Mon, 28 Aug 2023 02:05:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 938631121319;
	Mon, 28 Aug 2023 02:05:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 807461946A68;
	Mon, 28 Aug 2023 02:05:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 59F4619465A8
 for <dm-devel@listman.corp.redhat.com>; Mon, 28 Aug 2023 02:05:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 30EDAC1602E; Mon, 28 Aug 2023 02:05:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 29731C1602B
 for <dm-devel@redhat.com>; Mon, 28 Aug 2023 02:05:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D7298D40B1
 for <dm-devel@redhat.com>; Mon, 28 Aug 2023 02:05:02 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-hHnkbJlsMOOgCBu8iAV3NQ-1; Sun, 27 Aug 2023 22:04:57 -0400
X-MC-Unique: hHnkbJlsMOOgCBu8iAV3NQ-1
Received: from mail02.huawei.com (unknown [172.30.67.169])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4RYv5H667Jz4f3mJS;
 Mon, 28 Aug 2023 10:04:51 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
 by APP4 (Coremail) with SMTP id gCh0CgAnBai7AOxk9qcCBw--.25880S22;
 Mon, 28 Aug 2023 10:04:53 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com, song@kernel.org,
 xni@redhat.com
Date: Mon, 28 Aug 2023 10:00:11 +0800
Message-Id: <20230828020021.2489641-19-yukuai1@huaweicloud.com>
In-Reply-To: <20230828020021.2489641-1-yukuai1@huaweicloud.com>
References: <20230828020021.2489641-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: gCh0CgAnBai7AOxk9qcCBw--.25880S22
X-Coremail-Antispam: 1UD129KBjvJXoWxAry5uF13ZrWruryfGw1rWFg_yoW5WrWkpa
 y2gFyYgr4DXry3Jw13G3s8Ga45tr10krZ2y34xCa4Yy3W3Krs8C3WrWa45trZrAFyYyF1a
 va15G3yDW3WxuFUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUPI14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
 kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
 z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
 4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
 3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
 IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
 M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
 kIc2xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E
 14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIx
 kGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAF
 wI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr
 0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUQ
 SdkUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH -next v2 18/28] md: quiesce before
 md_kick_rdev_from_array() for md-cluster
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: yi.zhang@huawei.com, yangerkun@huawei.com, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yukuai1@huaweicloud.com, yukuai3@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Yu Kuai <yukuai3@huawei.com>

md_kick_rdev_from_array() can be called from md_check_recovery() and
md_reload_sb() for md-cluster, it's very complicated to use new apis to
suspend the array before holding 'reconfig_mutex' in this case.

Fortunately, md-cluster is only supported for raid1 and raid10, and they
both impelement quiesce() callback that is safe to be called from daemon
thread. Hence use quiesce() callback to prevent io concurrent with
removing rdev from the array.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index a3bc4968fa0f..3343767882bb 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9609,6 +9609,21 @@ void md_check_recovery(struct mddev *mddev)
 
 		if (mddev_is_clustered(mddev)) {
 			struct md_rdev *rdev, *tmp;
+			bool suspended = false;
+
+			/*
+			 * md-cluster is used for raid1/raid10, and they both
+			 * implement quiesce() callback that is safe to be
+			 * called from daemon thread.
+			 */
+			rdev_for_each(rdev, mddev)
+				if (test_bit(ClusterRemove, &rdev->flags) &&
+				    rdev->raid_disk < 0) {
+					mddev->pers->quiesce(mddev, true);
+					suspended = true;
+					break;
+				}
+
 			/* kick the device if another node issued a
 			 * remove disk.
 			 */
@@ -9617,6 +9632,9 @@ void md_check_recovery(struct mddev *mddev)
 						rdev->raid_disk < 0)
 					md_kick_rdev_from_array(rdev);
 			}
+
+			if (suspended)
+				mddev->pers->quiesce(mddev, false);
 		}
 
 		if (try_set_sync && !mddev->external && !mddev->in_sync) {
@@ -9904,6 +9922,7 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
 {
 	struct mdp_superblock_1 *sb = page_address(rdev->sb_page);
 	struct md_rdev *rdev2, *tmp;
+	bool suspended = false;
 	int role, ret;
 
 	/*
@@ -9918,6 +9937,22 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
 			md_bitmap_update_sb(mddev->bitmap);
 	}
 
+	/*
+	 * md-cluster is used for raid1/raid10, and they both
+	 * implement quiesce() callback.
+	 */
+	rdev_for_each(rdev2, mddev) {
+		if (test_bit(Faulty, &rdev2->flags))
+			continue;
+		role = le16_to_cpu(sb->dev_roles[rdev2->desc_nr]);
+		if (test_bit(Candidate, &rdev2->flags) &&
+		    role == MD_DISK_ROLE_FAULTY) {
+			mddev->pers->quiesce(mddev, true);
+			suspended = true;
+			break;
+		}
+	}
+
 	/* Check for change of roles in the active devices */
 	rdev_for_each_safe(rdev2, tmp, mddev) {
 		if (test_bit(Faulty, &rdev2->flags))
@@ -9966,6 +10001,9 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
 		}
 	}
 
+	if (suspended)
+		mddev->pers->quiesce(mddev, false);
+
 	if (mddev->raid_disks != le32_to_cpu(sb->raid_disks)) {
 		ret = update_raid_disks(mddev, le32_to_cpu(sb->raid_disks));
 		if (ret)
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


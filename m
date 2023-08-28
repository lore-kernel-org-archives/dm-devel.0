Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61B42C83F10
	for <dm-devel@archiver.kernel.org>; Mon, 28 Aug 2023 02:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693188302;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=EfECF+aeihrcNr1cAfZNCA+K5HbnTrLmWEo+z/hPrxE=;
	b=UO56zou5pxS5Rrp36k61gh+mr4JGpavL31sBUswooIlXxF/beqwoT/Q0JHt7iWrtGsynxs
	JcR59y2st4TRNYuR22KuGTvHW5F7RP3Q/UXulbnZYx0azUb0AJWhG2SvxuMHvUqOfVcs0D
	ym75gqLi4qQiX8WyvOsFX53G4WQTLEY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-gKMwxifZMP6ak9DF5fVpnQ-1; Sun, 27 Aug 2023 22:04:59 -0400
X-MC-Unique: gKMwxifZMP6ak9DF5fVpnQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 08BC085D067;
	Mon, 28 Aug 2023 02:04:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E0D532166B25;
	Mon, 28 Aug 2023 02:04:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id ABC421946A40;
	Mon, 28 Aug 2023 02:04:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 605F719465A8
 for <dm-devel@listman.corp.redhat.com>; Mon, 28 Aug 2023 02:04:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3E4D840C6F4E; Mon, 28 Aug 2023 02:04:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 36BDA40C6F4C
 for <dm-devel@redhat.com>; Mon, 28 Aug 2023 02:04:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A0E5838149A1
 for <dm-devel@redhat.com>; Mon, 28 Aug 2023 02:04:53 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (hwsga01-in.huaweimarine.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-QRBTzJhBPSeug4MuXp9fcg-1; Sun, 27 Aug 2023 22:04:50 -0400
X-MC-Unique: QRBTzJhBPSeug4MuXp9fcg-1
Received: from mail02.huawei.com (unknown [172.30.67.169])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4RYv586nD4z4f3knx;
 Mon, 28 Aug 2023 10:04:44 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
 by APP4 (Coremail) with SMTP id gCh0CgAnBai7AOxk9qcCBw--.25880S5;
 Mon, 28 Aug 2023 10:04:45 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com, song@kernel.org,
 xni@redhat.com
Date: Mon, 28 Aug 2023 09:59:54 +0800
Message-Id: <20230828020021.2489641-2-yukuai1@huaweicloud.com>
In-Reply-To: <20230828020021.2489641-1-yukuai1@huaweicloud.com>
References: <20230828020021.2489641-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: gCh0CgAnBai7AOxk9qcCBw--.25880S5
X-Coremail-Antispam: 1UD129KBjvJXoW7CF4fAw13JF4xAFyfAF1DWrg_yoW8tw4rp3
 yIqFWYgw45Jas5A34Ut3WkCFy5XwsxKrWqyrZrWry7A3W7Gw1rGr15XF43XFyF9as7CFsx
 Gws8A3W8A348GFUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUBE14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
 x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
 Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
 A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
 0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
 IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
 Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
 xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
 6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2
 Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
 Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMI
 IF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JU2_M3UUUUU
 =
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH -next v2 01/28] md: use READ_ONCE/WRITE_ONCE for
 'suspend_lo' and 'suspend_hi'
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Yu Kuai <yukuai3@huawei.com>

Because reading 'suspend_lo' and 'suspend_hi' from md_handle_request()
is not protected, use READ_ONCE/WRITE_ONCE to prevent reading abnormal
value.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 46badd13a687..9d8dff9d923c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -359,11 +359,11 @@ static bool is_suspended(struct mddev *mddev, struct bio *bio)
 		return true;
 	if (bio_data_dir(bio) != WRITE)
 		return false;
-	if (mddev->suspend_lo >= mddev->suspend_hi)
+	if (READ_ONCE(mddev->suspend_lo) >= READ_ONCE(mddev->suspend_hi))
 		return false;
-	if (bio->bi_iter.bi_sector >= mddev->suspend_hi)
+	if (bio->bi_iter.bi_sector >= READ_ONCE(mddev->suspend_hi))
 		return false;
-	if (bio_end_sector(bio) < mddev->suspend_lo)
+	if (bio_end_sector(bio) < READ_ONCE(mddev->suspend_lo))
 		return false;
 	return true;
 }
@@ -5171,7 +5171,8 @@ __ATTR(sync_max, S_IRUGO|S_IWUSR, max_sync_show, max_sync_store);
 static ssize_t
 suspend_lo_show(struct mddev *mddev, char *page)
 {
-	return sprintf(page, "%llu\n", (unsigned long long)mddev->suspend_lo);
+	return sprintf(page, "%llu\n",
+		       (unsigned long long)READ_ONCE(mddev->suspend_lo));
 }
 
 static ssize_t
@@ -5191,7 +5192,7 @@ suspend_lo_store(struct mddev *mddev, const char *buf, size_t len)
 		return err;
 
 	mddev_suspend(mddev);
-	mddev->suspend_lo = new;
+	WRITE_ONCE(mddev->suspend_lo, new);
 	mddev_resume(mddev);
 
 	mddev_unlock(mddev);
@@ -5203,7 +5204,8 @@ __ATTR(suspend_lo, S_IRUGO|S_IWUSR, suspend_lo_show, suspend_lo_store);
 static ssize_t
 suspend_hi_show(struct mddev *mddev, char *page)
 {
-	return sprintf(page, "%llu\n", (unsigned long long)mddev->suspend_hi);
+	return sprintf(page, "%llu\n",
+		       (unsigned long long)READ_ONCE(mddev->suspend_hi));
 }
 
 static ssize_t
@@ -5223,7 +5225,7 @@ suspend_hi_store(struct mddev *mddev, const char *buf, size_t len)
 		return err;
 
 	mddev_suspend(mddev);
-	mddev->suspend_hi = new;
+	WRITE_ONCE(mddev->suspend_hi, new);
 	mddev_resume(mddev);
 
 	mddev_unlock(mddev);
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


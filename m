Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73B9BC4332F
	for <dm-devel@archiver.kernel.org>; Tue, 15 Nov 2022 15:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668525407;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=YlRp9VP/T3TStA1W+ZP06VKFMp+0DqAsEdn4txk8/io=;
	b=U90NLGgDfuqhHB7I4y1PDY+5r9c5M9dKOcFY0n5e/bEuo7QpSzX9vqyzmKYlo9S+m0ESO4
	oJyMV4et5B7HeFEC9jAb5h+inC4BHZ/lpJimjmgqKBDW7/oMs1Yd9VO2FbxR+vzbifU6aV
	m2WrZAleGbQ8rV7AM33lEkJfbREhoqs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-55-bISdDaCiM9aeJINSaqobDQ-1; Tue, 15 Nov 2022 10:15:58 -0500
X-MC-Unique: bISdDaCiM9aeJINSaqobDQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2E87718E52C5;
	Tue, 15 Nov 2022 15:15:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0C52C42236;
	Tue, 15 Nov 2022 15:15:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 975E21946A6B;
	Tue, 15 Nov 2022 15:15:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EF6B419465B8
 for <dm-devel@listman.corp.redhat.com>; Tue, 15 Nov 2022 13:49:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E0D68492B1A; Tue, 15 Nov 2022 13:49:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D915C492B05
 for <dm-devel@redhat.com>; Tue, 15 Nov 2022 13:49:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BFFB1833A0F
 for <dm-devel@redhat.com>; Tue, 15 Nov 2022 13:49:39 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (hwsga01-in.huaweimarine.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-508-WwRC0CfnOJ6ASHCr1aonyw-1; Tue, 15 Nov 2022 08:49:37 -0500
X-MC-Unique: WwRC0CfnOJ6ASHCr1aonyw-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4NBSGK5bVgz4f3k6g;
 Tue, 15 Nov 2022 21:49:29 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.127.227])
 by APP4 (Coremail) with SMTP id gCh0CgBni9jnmHNjrPFIAg--.61645S13;
 Tue, 15 Nov 2022 21:49:32 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: hch@lst.de, axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
 dm-devel@redhat.com
Date: Tue, 15 Nov 2022 22:10:53 +0800
Message-Id: <20221115141054.1051801-10-yukuai1@huaweicloud.com>
In-Reply-To: <20221115141054.1051801-1-yukuai1@huaweicloud.com>
References: <20221115141054.1051801-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: gCh0CgBni9jnmHNjrPFIAg--.61645S13
X-Coremail-Antispam: 1UD129KBjvJXoW7CFW3JryrJF17AF43CFW3Jrb_yoW8ZF1fpF
 Z8Xa48JrW8Ga1UWw4qqw4UGFy29rWUJ3WxGFyIkrWS9rW3Jr4kCF13Jr1UXFWrKrWxKrsI
 qF17X3yFyF4vkaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUP214x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
 kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
 z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
 4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
 3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
 IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
 M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
 kIc2xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E
 14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIx
 kGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAF
 wI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JV
 WxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7VUbmZ
 X7UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Tue, 15 Nov 2022 15:15:46 +0000
Subject: [dm-devel] [PATCH v3 09/10] block: store the holder kobject in
 bd_holder_disk
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
Cc: linux-block@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com,
 linux-kernel@vger.kernel.org, yukuai1@huaweicloud.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Yu Kuai <yukuai3@huawei.com>

We hold a reference to the holder kobject for each bd_holder_disk,
so to make the code a bit more robust, use a reference to it instead
of the block_device.  As long as no one clears ->bd_holder_dir in
before freeing the disk, this isn't strictly required, but it does
make the code more clear and more robust.

Orignally-From: Christoph Hellwig <hch@lst.de>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/holder.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/block/holder.c b/block/holder.c
index c8e462053f49..3332142bb867 100644
--- a/block/holder.c
+++ b/block/holder.c
@@ -4,7 +4,7 @@
 
 struct bd_holder_disk {
 	struct list_head	list;
-	struct block_device	*bdev;
+	struct kobject		*holder_dir;
 	int			refcnt;
 };
 
@@ -14,7 +14,7 @@ static struct bd_holder_disk *bd_find_holder_disk(struct block_device *bdev,
 	struct bd_holder_disk *holder;
 
 	list_for_each_entry(holder, &disk->slave_bdevs, list)
-		if (holder->bdev == bdev)
+		if (holder->holder_dir == bdev->bd_holder_dir)
 			return holder;
 	return NULL;
 }
@@ -94,8 +94,9 @@ int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
 	}
 
 	INIT_LIST_HEAD(&holder->list);
-	holder->bdev = bdev;
 	holder->refcnt = 1;
+	holder->holder_dir = bdev->bd_holder_dir;
+
 	ret = add_symlink(disk->slave_dir, bdev_kobj(bdev));
 	if (ret)
 		goto out_free_holder;
@@ -140,8 +141,8 @@ void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk)
 	holder = bd_find_holder_disk(bdev, disk);
 	if (!WARN_ON_ONCE(holder == NULL) && !--holder->refcnt) {
 		del_symlink(disk->slave_dir, bdev_kobj(bdev));
-		del_symlink(bdev->bd_holder_dir, &disk_to_dev(disk)->kobj);
-		kobject_put(bdev->bd_holder_dir);
+		del_symlink(holder->holder_dir, &disk_to_dev(disk)->kobj);
+		kobject_put(holder->holder_dir);
 		list_del_init(&holder->list);
 		kfree(holder);
 	}
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


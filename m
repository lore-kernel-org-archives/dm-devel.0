Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53E52C4332F
	for <dm-devel@archiver.kernel.org>; Tue, 15 Nov 2022 15:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668525391;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=NFemb664Rb1+NFKCQXvuOipW4k0//MBB5U3OLdKymL4=;
	b=OfNnCscNF3kpUvO3W9ZfJKbmthVOc2fRc/GCDc6Z2j28DXtfS9j9Je/QMvnt6hRdfZEHTr
	BRRtsrsy8OmlBTH8kKcYPAq1UprP3wyKeluSusrqFo75rpAuE7f/vBHD6YFb5q18lwjqSu
	x/Bcdo7VqPXJDg8VgD/KP+qOjYRZ+eE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-xo9gGLFwMdu7sVECKiO-mg-1; Tue, 15 Nov 2022 10:15:58 -0500
X-MC-Unique: xo9gGLFwMdu7sVECKiO-mg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2DCE01012468;
	Tue, 15 Nov 2022 15:15:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CDDE71121331;
	Tue, 15 Nov 2022 15:15:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E26981946A48;
	Tue, 15 Nov 2022 15:15:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2053E19465B7
 for <dm-devel@listman.corp.redhat.com>; Tue, 15 Nov 2022 13:49:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 05090492B0D; Tue, 15 Nov 2022 13:49:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F1E85492B05
 for <dm-devel@redhat.com>; Tue, 15 Nov 2022 13:49:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D71C5800B23
 for <dm-devel@redhat.com>; Tue, 15 Nov 2022 13:49:37 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-556-oE9ZfogNNK6tm6hVE9rQ6A-1; Tue, 15 Nov 2022 08:49:35 -0500
X-MC-Unique: oE9ZfogNNK6tm6hVE9rQ6A-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4NBSGJ0kRwz4f3vf4;
 Tue, 15 Nov 2022 21:49:28 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.127.227])
 by APP4 (Coremail) with SMTP id gCh0CgBni9jnmHNjrPFIAg--.61645S9;
 Tue, 15 Nov 2022 21:49:31 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: hch@lst.de, axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
 dm-devel@redhat.com
Date: Tue, 15 Nov 2022 22:10:49 +0800
Message-Id: <20221115141054.1051801-6-yukuai1@huaweicloud.com>
In-Reply-To: <20221115141054.1051801-1-yukuai1@huaweicloud.com>
References: <20221115141054.1051801-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: gCh0CgBni9jnmHNjrPFIAg--.61645S9
X-Coremail-Antispam: 1UD129KBjvJXoW7Zw43tFWkKF1ftF4rCr18AFb_yoW8Wr4UpF
 1YgrWavry5WrsrZw1UZr1Uuw15twsY93y8Jr9xGa4a9a4UZFy7ZFWIyF93X3WkJa97KF98
 WFW7trs5Gw48Kr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUPF14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
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
 wI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJV
 W8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUOBTY
 UUUUU
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
Subject: [dm-devel] [PATCH RFC v3 05/10] dm: make sure create and remove dm
 device won't race with open and close table
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Yu Kuai <yukuai3@huawei.com>

open_table_device() and close_table_device() is protected by
table_devices_lock, hence use it to protect add_disk() and
del_gendisk().

Prepare to track per-add_disk holder relations in dm.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/dm.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 2917700b1e15..3728b56b364b 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1952,7 +1952,14 @@ static void cleanup_mapped_device(struct mapped_device *md)
 		spin_unlock(&_minor_lock);
 		if (dm_get_md_type(md) != DM_TYPE_NONE) {
 			dm_sysfs_exit(md);
+
+			/*
+			 * Hold lock to make sure del_gendisk() won't concurrent
+			 * with open/close_table_device().
+			 */
+			mutex_lock(&md->table_devices_lock);
 			del_gendisk(md->disk);
+			mutex_unlock(&md->table_devices_lock);
 		}
 		dm_queue_destroy_crypto_profile(md->queue);
 		put_disk(md->disk);
@@ -2312,15 +2319,24 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
 	if (r)
 		return r;
 
+	/*
+	 * Hold lock to make sure add_disk() and del_gendisk() won't concurrent
+	 * with open_table_device() and close_table_device().
+	 */
+	mutex_lock(&md->table_devices_lock);
 	r = add_disk(md->disk);
+	mutex_unlock(&md->table_devices_lock);
 	if (r)
 		return r;
 
 	r = dm_sysfs_init(md);
 	if (r) {
+		mutex_lock(&md->table_devices_lock);
 		del_gendisk(md->disk);
+		mutex_unlock(&md->table_devices_lock);
 		return r;
 	}
+
 	md->type = type;
 	return 0;
 }
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


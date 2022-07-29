Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6E24C19F2B
	for <dm-devel@archiver.kernel.org>; Fri, 29 Jul 2022 06:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659075131;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LRPadfOiaScVqrFTTOOFgLxByjEpklaYUX8GzU/V7hI=;
	b=UD4AMKUIq3+yoFzVlGIxirXL1zrjqSth2DUNC/nOA523L8X4wyL36eZKpvB+Ek3M/WAOuh
	h4a1agkAaaYhzlVteCydmoXjOUdfsQfv11MQEPYhwaYEDaJXmavq7vN0FFDa92IyoAsfTU
	YKeWLCn6Cnfuo5MHTytUd45oIIaXzG4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-498-ibs-9LJ_N2aGxTPTmAHi3Q-1; Fri, 29 Jul 2022 02:12:08 -0400
X-MC-Unique: ibs-9LJ_N2aGxTPTmAHi3Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AAAF9101A59A;
	Fri, 29 Jul 2022 06:12:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9A253492C3B;
	Fri, 29 Jul 2022 06:12:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6CA05193211B;
	Fri, 29 Jul 2022 06:12:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D52951932118
 for <dm-devel@listman.corp.redhat.com>; Fri, 29 Jul 2022 06:12:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B91EB409B3EC; Fri, 29 Jul 2022 06:12:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B553C409B3E9
 for <dm-devel@redhat.com>; Fri, 29 Jul 2022 06:12:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9DDA8811E75
 for <dm-devel@redhat.com>; Fri, 29 Jul 2022 06:12:03 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (hwsga01-in.huaweimarine.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-424-kqA7TRz9OXmif7PbdCFnCg-1; Fri, 29 Jul 2022 02:11:59 -0400
X-MC-Unique: kqA7TRz9OXmif7PbdCFnCg-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4LvHFF4kKyzK7pk;
 Fri, 29 Jul 2022 14:10:41 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.127.227])
 by APP3 (Coremail) with SMTP id _Ch0CgCnCWkneuNiP6ZGBQ--.22656S7;
 Fri, 29 Jul 2022 14:11:54 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: stable@vger.kernel.org, hch@lst.de, axboe@kernel.dk, snitzer@redhat.com
Date: Fri, 29 Jul 2022 14:23:56 +0800
Message-Id: <20220729062356.1663513-4-yukuai1@huaweicloud.com>
In-Reply-To: <20220729062356.1663513-1-yukuai1@huaweicloud.com>
References: <20220729062356.1663513-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: _Ch0CgCnCWkneuNiP6ZGBQ--.22656S7
X-Coremail-Antispam: 1UD129KBjvJXoW7ZryxCw43Wr1fZryUZryxKrg_yoW5JF43pw
 sxW390vrWrGr4qvw4DXa1UZFy3tws5t34fZr1fCw1F934Fkr90v3W2kFy8ZFW5JFZ7XFsx
 JFWDtrWkC3W8tr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUU9m14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWUuVWrJwAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
 x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
 Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
 A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
 0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
 IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
 Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCF04k20xvY0x0EwIxGrwCFx2
 IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v2
 6r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67
 AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IY
 s7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr
 0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUd8n5UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: [dm-devel] [PATCH stable 5.10 3/3] dm: delay registering the gendisk
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
Cc: linux-block@vger.kernel.org, yukuai3@huawei.com, dm-devel@redhat.com,
 yi.zhang@huawei.com, yukuai1@huaweicloud.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

commit 89f871af1b26d98d983cba7ed0e86effa45ba5f8 upstream.

device mapper is currently the only outlier that tries to call
register_disk after add_disk, leading to fairly inconsistent state
of these block layer data structures.  Instead change device-mapper
to just register the gendisk later now that the holder mechanism
can cope with that.

Note that this introduces a user visible change: the dm kobject is
now only visible after the initial table has been loaded.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/dm.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index ab0e2338e47e..85efe2f1995f 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1795,7 +1795,12 @@ static void cleanup_mapped_device(struct mapped_device *md)
 		spin_lock(&_minor_lock);
 		md->disk->private_data = NULL;
 		spin_unlock(&_minor_lock);
-		del_gendisk(md->disk);
+		if (dm_get_md_type(md) != DM_TYPE_NONE) {
+			dm_sysfs_exit(md);
+			del_gendisk(md->disk);
+		} else {
+			md->disk->queue = NULL;
+		}
 		put_disk(md->disk);
 	}
 
@@ -1900,7 +1905,6 @@ static struct mapped_device *alloc_dev(int minor)
 		}
 	}
 
-	add_disk_no_queue_reg(md->disk);
 	format_dev_t(md->name, MKDEV(_major, minor));
 
 	md->wq = alloc_workqueue("kdmflush", WQ_MEM_RECLAIM, 0);
@@ -2098,19 +2102,12 @@ static struct dm_table *__unbind(struct mapped_device *md)
  */
 int dm_create(int minor, struct mapped_device **result)
 {
-	int r;
 	struct mapped_device *md;
 
 	md = alloc_dev(minor);
 	if (!md)
 		return -ENXIO;
 
-	r = dm_sysfs_init(md);
-	if (r) {
-		free_dev(md);
-		return r;
-	}
-
 	*result = md;
 	return 0;
 }
@@ -2188,8 +2185,14 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
 		return r;
 	}
 	dm_table_set_restrictions(t, md->queue, &limits);
-	blk_register_queue(md->disk);
 
+	add_disk(md->disk);
+	r = dm_sysfs_init(md);
+	if (r) {
+		del_gendisk(md->disk);
+		return r;
+	}
+	md->type = type;
 	return 0;
 }
 
@@ -2295,7 +2298,6 @@ static void __dm_destroy(struct mapped_device *md, bool wait)
 		DMWARN("%s: Forcibly removing mapped_device still in use! (%d users)",
 		       dm_device_name(md), atomic_read(&md->holders));
 
-	dm_sysfs_exit(md);
 	dm_table_destroy(__unbind(md));
 	free_dev(md);
 }
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


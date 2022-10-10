Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 337A8C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 11 Oct 2022 07:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1665472934;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=7oJR2WC79nFYGktiiBCCr1ckmZkNALUGMrMv6CsW5kg=;
	b=I29amUTEzpO3itHshEoHU9WllNf1sXIdBi94CduiCAVM4fvDZ78V7bKkDZd8e3DbmnZApJ
	T+mhIZQjblJ5Vip4EWLL7faP6y2UI8IjZlX4R8iMtGvDzviRwuh45azx8nocB7zsqg2Orf
	uAGYk0CMn1A8Agb4zF+QySR0wMbCQGE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-198-Ag-PNtUxMXCZ6T2WUFL3sg-1; Tue, 11 Oct 2022 03:22:10 -0400
X-MC-Unique: Ag-PNtUxMXCZ6T2WUFL3sg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DC15E101A528;
	Tue, 11 Oct 2022 07:22:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0AB34404CD98;
	Tue, 11 Oct 2022 07:22:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B491819465A3;
	Tue, 11 Oct 2022 07:22:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E54951946597
 for <dm-devel@listman.corp.redhat.com>; Mon, 10 Oct 2022 14:19:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D4077492B07; Mon, 10 Oct 2022 14:19:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CD205492B04
 for <dm-devel@redhat.com>; Mon, 10 Oct 2022 14:19:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 755513C025CE
 for <dm-devel@redhat.com>; Mon, 10 Oct 2022 14:19:28 +0000 (UTC)
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com
 [45.249.212.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-540-YJAEg1BgMZq8dSuDoAJCww-1; Mon, 10 Oct 2022 10:19:25 -0400
X-MC-Unique: YJAEg1BgMZq8dSuDoAJCww-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4MmLZm5DKnz6PY8k;
 Mon, 10 Oct 2022 22:17:04 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.127.227])
 by APP4 (Coremail) with SMTP id gCh0CgCHiMrbKURj8SI7AA--.44076S4;
 Mon, 10 Oct 2022 22:19:18 +0800 (CST)
From: Luo Meng <luomeng@huaweicloud.com>
To: agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com, ejt@redhat.com
Date: Mon, 10 Oct 2022 22:41:23 +0800
Message-Id: <20221010144123.252329-1-luomeng@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: gCh0CgCHiMrbKURj8SI7AA--.44076S4
X-Coremail-Antispam: 1UD129KBjvJXoWxXr4rKrW3Kr1rtFy5urWfKrg_yoWrZrW8pa
 15XF90kryrXFZFgw40vr40kry2gw4jk34YkryxC3y29w15u34rZFyrGFy5Za98AF9rWF13
 WFy7tr48CF48XF7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUgCb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
 6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
 vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
 xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
 0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
 x7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
 0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Y
 z7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zV
 AF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4l
 IxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVW3JVWrJr
 1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsG
 vfC2KfnxnUUI43ZEXa7IU189N3UUUUU==
X-CM-SenderInfo: 5oxrzvtqj6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Tue, 11 Oct 2022 07:22:04 +0000
Subject: [dm-devel] [dm-devel resend] dm mpath: fix UAF in
 multipath_message()
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
Cc: luomeng12@huawei.com, yukuai3@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Luo Meng <luomeng12@huawei.com>

If dm_get_device() create dd in multipath_message(),
and then call table_deps() after dm_put_table_device(),
it will lead to concurrency UAF bugs.

One of the concurrency UAF can be shown as below:

         (USE)                        |    (FREE)
                                      |  target_message
                                      |    multipath_message
                                      |      dm_put_device
                                      |        dm_put_table_device #
                                      |          kfree(td)  # table_device *td
ioctl # DM_TABLE_DEPS_CMD             |         ...
  table_deps                          |         ...
  dm_get_live_or_inactive_table       |         ...
    retrieve_dep                      |         ...
    list_for_each_entry               |         ...
      deps->dev[count++] =            |         ...
          huge_encode_dev             |         ...
          (dd->dm_dev->bdev->bd_dev)  |        list_del(&dd->list)
                                      |        kfree(dd) # dm_dev_internal

The root cause of UAF bugs is that find_device() failed in
dm_get_device() and will create dd and refcount set 1, kfree()
in dm_put_table() is not protected. When td, which there are
still pointers point to, is released, the concurrency UAF bug
will happen.

This patch add a flag to determine whether to create a new dd.

Fixes: 8215d6ec5fee(dm table: remove unused dm_get_device range parameters)
Signed-off-by: Luo Meng <luomeng12@huawei.com>
---
 drivers/md/dm-mpath.c         |  2 +-
 drivers/md/dm-table.c         | 43 +++++++++++++++++++++--------------
 include/linux/device-mapper.h |  2 ++
 3 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 0e325469a252..1f51059520ac 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -2001,7 +2001,7 @@ static int multipath_message(struct dm_target *ti, unsigned argc, char **argv,
 		goto out;
 	}
 
-	r = dm_get_device(ti, argv[1], dm_table_get_mode(ti->table), &dev);
+	r = __dm_get_device(ti, argv[1], dm_table_get_mode(ti->table), &dev, false);
 	if (r) {
 		DMWARN("message: error getting device %s",
 		       argv[1]);
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index d8034ff0cb24..ad18a41f1608 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -338,12 +338,8 @@ dev_t dm_get_dev_t(const char *path)
 }
 EXPORT_SYMBOL_GPL(dm_get_dev_t);
 
-/*
- * Add a device to the list, or just increment the usage count if
- * it's already present.
- */
-int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
-		  struct dm_dev **result)
+int __dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
+		    struct dm_dev **result, bool create_dd)
 {
 	int r;
 	dev_t dev;
@@ -367,19 +363,21 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
 
 	dd = find_device(&t->devices, dev);
 	if (!dd) {
-		dd = kmalloc(sizeof(*dd), GFP_KERNEL);
-		if (!dd)
-			return -ENOMEM;
-
-		if ((r = dm_get_table_device(t->md, dev, mode, &dd->dm_dev))) {
-			kfree(dd);
-			return r;
-		}
+		if (create_dd) {
+			dd = kmalloc(sizeof(*dd), GFP_KERNEL);
+			if (!dd)
+				return -ENOMEM;
 
-		refcount_set(&dd->count, 1);
-		list_add(&dd->list, &t->devices);
-		goto out;
+			if ((r = dm_get_table_device(t->md, dev, mode, &dd->dm_dev))) {
+				kfree(dd);
+				return r;
+			}
 
+			refcount_set(&dd->count, 1);
+			list_add(&dd->list, &t->devices);
+			goto out;
+		} else
+			return -ENODEV;
 	} else if (dd->dm_dev->mode != (mode | dd->dm_dev->mode)) {
 		r = upgrade_mode(dd, mode, t->md);
 		if (r)
@@ -390,6 +388,17 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
 	*result = dd->dm_dev;
 	return 0;
 }
+EXPORT_SYMBOL(__dm_get_device);
+
+/*
+ * Add a device to the list, or just increment the usage count if
+ * it's already present.
+ */
+int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
+		  struct dm_dev **result)
+{
+	return __dm_get_device(ti, path, mode, result, true);
+}
 EXPORT_SYMBOL(dm_get_device);
 
 static int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 04c6acf7faaa..ef4031a844b6 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -178,6 +178,8 @@ dev_t dm_get_dev_t(const char *path);
 int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
 		  struct dm_dev **result);
 void dm_put_device(struct dm_target *ti, struct dm_dev *d);
+int __dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
+		    struct dm_dev **result, bool create_dd);
 
 /*
  * Information about a target type
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


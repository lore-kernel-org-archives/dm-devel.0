Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DDA3C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 15 Apr 2022 08:42:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-217-T1W9zzPIOg2dyfDTXAuPxw-1; Fri, 15 Apr 2022 04:42:21 -0400
X-MC-Unique: T1W9zzPIOg2dyfDTXAuPxw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E6291875068;
	Fri, 15 Apr 2022 08:42:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7A749145B968;
	Fri, 15 Apr 2022 08:42:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0F41E194034A;
	Fri, 15 Apr 2022 08:42:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1966C19451EC
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Apr 2022 08:42:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EB1C6463ECA; Fri, 15 Apr 2022 08:42:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E720D43485D
 for <dm-devel@redhat.com>; Fri, 15 Apr 2022 08:42:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD6EF811E84
 for <dm-devel@redhat.com>; Fri, 15 Apr 2022 08:42:14 +0000 (UTC)
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com
 [45.249.212.255]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-355-Ty20pM9iM6Sx6tyGYamPWg-1; Fri, 15 Apr 2022 04:42:09 -0400
X-MC-Unique: Ty20pM9iM6Sx6tyGYamPWg-1
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.57])
 by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4KfqYg4k7zz1HC38;
 Fri, 15 Apr 2022 16:41:27 +0800 (CST)
Received: from dggpeml500006.china.huawei.com (7.185.36.76) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 15 Apr 2022 16:42:05 +0800
Received: from localhost.localdomain (10.175.127.227) by
 dggpeml500006.china.huawei.com (7.185.36.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 15 Apr 2022 16:42:05 +0800
From: Luo Meng <luomeng12@huawei.com>
To: <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>,
 <ejt@redhat.com>
Date: Fri, 15 Apr 2022 16:56:31 +0800
Message-ID: <20220415085631.3613813-1-luomeng12@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500006.china.huawei.com (7.185.36.76)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: [dm-devel] dm mpath: fix UAF in multipath_message()
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

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
index 6ed9d2731254..ad63d729ff81 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1995,7 +1995,7 @@ static int multipath_message(struct dm_target *ti, unsigned argc, char **argv,
 		goto out;
 	}
 
-	r = dm_get_device(ti, argv[1], dm_table_get_mode(ti->table), &dev);
+	r = __dm_get_device(ti, argv[1], dm_table_get_mode(ti->table), &dev, false);
 	if (r) {
 		DMWARN("message: error getting device %s",
 		       argv[1]);
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 03541cfc2317..9dbc0ba37ae6 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -339,12 +339,8 @@ dev_t dm_get_dev_t(const char *path)
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
@@ -368,19 +364,21 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
 
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
@@ -391,6 +389,17 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
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
index c2a3758c4aaa..6ea542e18048 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -168,6 +168,8 @@ dev_t dm_get_dev_t(const char *path);
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


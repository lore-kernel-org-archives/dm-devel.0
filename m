Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18FDDC0015E
	for <dm-devel@archiver.kernel.org>; Wed,  9 Aug 2023 10:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691577874;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=CP7oKyTvBkXtp8SUaa4R7WYBzW/6jSLpZTp4QgD9MI8=;
	b=EfSm3OQQLRW3q23vCo3OFqJtGV6sGVOV9KPVSOKTNxfbdVZdCeCoGczMN1SZRqs4XPjXH0
	ofVyGERXUTWcmMJnL1liNka6sByKUX+P/U5NpV961bS4joExRhCJPjCxjc/52BtqCKfVs4
	3MXbaKpNZ7KP8bB6N0AtLQtCPT1qKlg=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-156-09AyVfZAMy-UZxLfo0Z1vg-1; Wed, 09 Aug 2023 06:44:30 -0400
X-MC-Unique: 09AyVfZAMy-UZxLfo0Z1vg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AAD333C0F683;
	Wed,  9 Aug 2023 10:44:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8E5321121314;
	Wed,  9 Aug 2023 10:44:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 473061946589;
	Wed,  9 Aug 2023 10:44:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 702731946588
 for <dm-devel@listman.corp.redhat.com>; Wed,  9 Aug 2023 10:44:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0B970C15BB8; Wed,  9 Aug 2023 10:44:25 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown
 [10.11.5.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AB99AC15BAE;
 Wed,  9 Aug 2023 10:44:24 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix,
 from userid 12668)
 id E7C7230B9C07; Wed,  9 Aug 2023 10:44:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
 by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id
 65A673F7CF; Wed,  9 Aug 2023 12:44:21 +0200 (CEST)
Date: Wed, 9 Aug 2023 12:44:20 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <snitzer@kernel.org>
In-Reply-To: <a508359-734b-35c9-a393-42c27870a1fa@redhat.com>
Message-ID: <a8a3f458-d7d1-e5b6-d672-45c8a8c072ad@redhat.com>
References: <20221010144123.252329-1-luomeng@huaweicloud.com>
 <Y02zebNyn73/MN1d@redhat.com>
 <eb9e1d80-c62c-c62f-4fc2-5be21fc75472@huawei.com>
 <ZMqFVGX/ZbVABDJ6@redhat.com>
 <a508359-734b-35c9-a393-42c27870a1fa@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [dm-devel resend] dm mpath: fix UAF in
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
Cc: ejt@redhat.com, Luo Meng <luomeng@huaweicloud.com>, dm-devel@redhat.com,
 luomeng12@huawei.com, yukuai3@huawei.com,
 "lilingfeng \(A\)" <lilingfeng3@huawei.com>, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Tue, 8 Aug 2023, Mikulas Patocka wrote:

> On Wed, 2 Aug 2023, Mike Snitzer wrote:
> 
> > [Cc'ing Mikulas so he can take a look at this too.]
> 
> Hi
> 
> I suggest this patch (but it's only compile-tested, so please run some 
> testsuite on it).
> 
> Mikulas

I self-nack that patch - it doesn't work if there are multiple targets 
calling dm_table_set_devices_mutex in the same table. This is not an issue 
for multipath, but it will be a problem if other targets use this 
functionality.

Here I'm sending a better patch that doesn't need any modification to the 
targets at all.

Mikulas



From: Mikulas Patocka <mpatocka at redhat.com>
Subject: [PATCH] dm: fix a race condition in retrieve_deps

There's a race condition in the multipath target when retrieve_deps races
with multipath_message calling dm_get_device and dm_put_device.
retrieve_deps walks the list of open devices without holding any lock but
multipath may add or remove devices to the list while it is running. The
end result may be memory corruption or use-after-free memory access.

Fix this bug by introducing a new rw semaphore "devices_lock". We grab
devices_lock for read in retrieve_deps and we grab it for write in
dm_get_device and dm_put_device.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-core.h  |    1 +
 drivers/md/dm-ioctl.c |    7 ++++++-
 drivers/md/dm-table.c |   32 ++++++++++++++++++++++++--------
 3 files changed, 31 insertions(+), 9 deletions(-)

Index: linux-2.6/drivers/md/dm-core.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-core.h
+++ linux-2.6/drivers/md/dm-core.h
@@ -214,6 +214,7 @@ struct dm_table {
 
 	/* a list of devices used by this table */
 	struct list_head devices;
+	struct rw_semaphore devices_lock;
 
 	/* events get handed up using this callback */
 	void (*event_fn)(void *data);
Index: linux-2.6/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-ioctl.c
+++ linux-2.6/drivers/md/dm-ioctl.c
@@ -1630,6 +1630,8 @@ static void retrieve_deps(struct dm_tabl
 	struct dm_dev_internal *dd;
 	struct dm_target_deps *deps;
 
+	down_read(&table->devices_lock);
+
 	deps = get_result_buffer(param, param_size, &len);
 
 	/*
@@ -1644,7 +1646,7 @@ static void retrieve_deps(struct dm_tabl
 	needed = struct_size(deps, dev, count);
 	if (len < needed) {
 		param->flags |= DM_BUFFER_FULL_FLAG;
-		return;
+		goto out;
 	}
 
 	/*
@@ -1656,6 +1658,9 @@ static void retrieve_deps(struct dm_tabl
 		deps->dev[count++] = huge_encode_dev(dd->dm_dev->bdev->bd_dev);
 
 	param->data_size = param->data_start + needed;
+
+out:
+	up_read(&table->devices_lock);
 }
 
 static int table_deps(struct file *filp, struct dm_ioctl *param, size_t param_size)
Index: linux-2.6/drivers/md/dm-table.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-table.c
+++ linux-2.6/drivers/md/dm-table.c
@@ -135,6 +135,7 @@ int dm_table_create(struct dm_table **re
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&t->devices);
+	init_rwsem(&t->devices_lock);
 
 	if (!num_targets)
 		num_targets = KEYS_PER_NODE;
@@ -359,16 +360,20 @@ int __ref dm_get_device(struct dm_target
 	if (dev == disk_devt(t->md->disk))
 		return -EINVAL;
 
+	down_write(&t->devices_lock);
+
 	dd = find_device(&t->devices, dev);
 	if (!dd) {
 		dd = kmalloc(sizeof(*dd), GFP_KERNEL);
-		if (!dd)
-			return -ENOMEM;
+		if (!dd) {
+			r = -ENOMEM;
+			goto unlock_ret_r;
+		}
 
 		r = dm_get_table_device(t->md, dev, mode, &dd->dm_dev);
 		if (r) {
 			kfree(dd);
-			return r;
+			goto unlock_ret_r;
 		}
 
 		refcount_set(&dd->count, 1);
@@ -378,12 +383,17 @@ int __ref dm_get_device(struct dm_target
 	} else if (dd->dm_dev->mode != (mode | dd->dm_dev->mode)) {
 		r = upgrade_mode(dd, mode, t->md);
 		if (r)
-			return r;
+			goto unlock_ret_r;
 	}
 	refcount_inc(&dd->count);
 out:
+	up_write(&t->devices_lock);
 	*result = dd->dm_dev;
 	return 0;
+
+unlock_ret_r:
+	up_write(&t->devices_lock);
+	return r;
 }
 EXPORT_SYMBOL(dm_get_device);
 
@@ -419,9 +429,12 @@ static int dm_set_device_limits(struct d
 void dm_put_device(struct dm_target *ti, struct dm_dev *d)
 {
 	int found = 0;
-	struct list_head *devices = &ti->table->devices;
+	struct dm_table *t = ti->table;
+	struct list_head *devices = &t->devices;
 	struct dm_dev_internal *dd;
 
+	down_write(&t->devices_lock);
+
 	list_for_each_entry(dd, devices, list) {
 		if (dd->dm_dev == d) {
 			found = 1;
@@ -430,14 +443,17 @@ void dm_put_device(struct dm_target *ti,
 	}
 	if (!found) {
 		DMERR("%s: device %s not in table devices list",
-		      dm_device_name(ti->table->md), d->name);
-		return;
+		      dm_device_name(t->md), d->name);
+		goto unlock_ret;
 	}
 	if (refcount_dec_and_test(&dd->count)) {
-		dm_put_table_device(ti->table->md, d);
+		dm_put_table_device(t->md, d);
 		list_del(&dd->list);
 		kfree(dd);
 	}
+
+unlock_ret:
+	up_write(&t->devices_lock);
 }
 EXPORT_SYMBOL(dm_put_device);
 
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


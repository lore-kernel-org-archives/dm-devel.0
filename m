Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFB58C433FE
	for <dm-devel@archiver.kernel.org>; Fri, 11 Nov 2022 12:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668168345;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OeVlszlr+KIF3/df0rF2PZfap9hh4RB4rshVB1tJpAc=;
	b=aihB2xC2L5EbpYOn+EVAtNSrrE0IByzc9Xkx1u+jxP4CIEKX/LsT5aes4gyrbmvpGhDU0Y
	crCLcsGFO1STj8QirnksRg5jzy4ohtjrOAu96KgbXOEoZPjFE0fMQgbFEzJrn7cTqRIvHk
	rpHDreRRJlzZZFZ4lkmy+vfPBf1D7lg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-180-rv4g57TmOvKoxpi6BdgGwg-1; Fri, 11 Nov 2022 07:05:44 -0500
X-MC-Unique: rv4g57TmOvKoxpi6BdgGwg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 466833C0F66F;
	Fri, 11 Nov 2022 12:05:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 334712166B36;
	Fri, 11 Nov 2022 12:05:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0101E1946587;
	Fri, 11 Nov 2022 12:05:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5652B1946586
 for <dm-devel@listman.corp.redhat.com>; Fri, 11 Nov 2022 12:05:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 48F0063A55; Fri, 11 Nov 2022 12:05:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 40AE117582
 for <dm-devel@redhat.com>; Fri, 11 Nov 2022 12:05:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1F4E7185A79C
 for <dm-devel@redhat.com>; Fri, 11 Nov 2022 12:05:42 +0000 (UTC)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com
 [45.249.212.189]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-202-ZEMmhBYVONSPP65T7ZrNRA-1; Fri, 11 Nov 2022 07:05:37 -0500
X-MC-Unique: ZEMmhBYVONSPP65T7ZrNRA-1
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
 by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4N7xjj4lHszJnW5;
 Fri, 11 Nov 2022 19:46:01 +0800 (CST)
Received: from kwepemm600013.china.huawei.com (7.193.23.68) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 11 Nov 2022 19:49:05 +0800
Received: from huawei.com (10.175.127.227) by kwepemm600013.china.huawei.com
 (7.193.23.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 11 Nov
 2022 19:49:04 +0800
From: Zhihao Cheng <chengzhihao1@huawei.com>
To: <snitzer@kernel.org>, <Martin.Wilck@suse.com>, <ejt@redhat.com>,
 <jack@suse.cz>, <tytso@mit.edu>, <yi.zhang@huawei.com>,
 <chengzhihao1@huawei.com>
Date: Fri, 11 Nov 2022 20:10:28 +0800
Message-ID: <20221111121029.3985561-3-chengzhihao1@huawei.com>
In-Reply-To: <20221111121029.3985561-1-chengzhihao1@huawei.com>
References: <20221111121029.3985561-1-chengzhihao1@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600013.china.huawei.com (7.193.23.68)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: bulk
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [PATCH 2/3] dm bufio: Split main logic out of
 dm_bufio_client creation/destroy
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
Cc: dm-devel@redhat.com, linux-ext4@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Split main logic excepts shrinker register/unregister out of
dm_bufio_client creation/destroy, the extracted code is wrapped
into new helpers __do_init and __do_destroy.
This commit is prepare to support dm_bufio_client resetting.

Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
---
 drivers/md/dm-bufio.c    | 144 +++++++++++++++++++++++++++------------
 include/linux/dm-bufio.h |   4 +-
 2 files changed, 101 insertions(+), 47 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index bb786c39545e..5859d69d6944 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1731,31 +1731,17 @@ static unsigned long dm_bufio_shrink_count(struct shrinker *shrink, struct shrin
 	return count;
 }
 
-/*
- * Create the buffering interface
- */
-struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsigned block_size,
-					       unsigned reserved_buffers, unsigned aux_size,
-					       void (*alloc_callback)(struct dm_buffer *),
-					       void (*write_callback)(struct dm_buffer *),
-					       unsigned int flags)
-{
-	int r;
-	struct dm_bufio_client *c;
-	unsigned i;
+static int __do_init(struct dm_bufio_client *c, struct block_device *bdev,
+		     unsigned int block_size, unsigned int reserved_buffers,
+		     unsigned int aux_size,
+		     void (*alloc_callback)(struct dm_buffer *),
+		     void (*write_callback)(struct dm_buffer *),
+		     unsigned int flags)
+{
+	int r = 0;
+	unsigned int i;
 	char slab_name[27];
 
-	if (!block_size || block_size & ((1 << SECTOR_SHIFT) - 1)) {
-		DMERR("%s: block size not specified or is not multiple of 512b", __func__);
-		r = -EINVAL;
-		goto bad_client;
-	}
-
-	c = kzalloc(sizeof(*c), GFP_KERNEL);
-	if (!c) {
-		r = -ENOMEM;
-		goto bad_client;
-	}
 	c->buffer_tree = RB_ROOT;
 
 	c->bdev = bdev;
@@ -1829,6 +1815,63 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 	INIT_WORK(&c->shrink_work, shrink_work);
 	atomic_long_set(&c->need_shrink, 0);
 
+	return 0;
+
+bad:
+	while (!list_empty(&c->reserved_buffers)) {
+		struct dm_buffer *b = list_entry(c->reserved_buffers.next,
+						 struct dm_buffer, lru_list);
+		list_del(&b->lru_list);
+		free_buffer(b);
+	}
+	kmem_cache_destroy(c->slab_cache);
+	c->slab_cache = NULL;
+	kmem_cache_destroy(c->slab_buffer);
+	c->slab_buffer = NULL;
+	dm_io_client_destroy(c->dm_io);
+bad_dm_io:
+	c->dm_io = NULL;
+	mutex_destroy(&c->lock);
+	c->need_reserved_buffers = 0;
+	if (c->no_sleep) {
+		static_branch_dec(&no_sleep_enabled);
+		c->no_sleep = false;
+	}
+	return r;
+}
+
+/*
+ * Create the buffering interface
+ */
+struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev,
+					       unsigned int block_size,
+					       unsigned int reserved_buffers,
+					       unsigned int aux_size,
+					       void (*alloc_callback)(struct dm_buffer *),
+					       void (*write_callback)(struct dm_buffer *),
+					       unsigned int flags)
+{
+	int r;
+	struct dm_bufio_client *c;
+	char slab_name[27];
+
+	if (!block_size || block_size & ((1 << SECTOR_SHIFT) - 1)) {
+		DMERR("%s: block size not specified or is not multiple of 512b", __func__);
+		r = -EINVAL;
+		goto bad_client;
+	}
+
+	c = kzalloc(sizeof(*c), GFP_KERNEL);
+	if (!c) {
+		r = -ENOMEM;
+		goto bad_client;
+	}
+
+	r = __do_init(c, bdev, block_size, reserved_buffers, aux_size,
+		      alloc_callback, write_callback, flags);
+	if (r)
+		goto bad_do_init;
+
 	c->shrinker.count_objects = dm_bufio_shrink_count;
 	c->shrinker.scan_objects = dm_bufio_shrink_scan;
 	c->shrinker.seeks = 1;
@@ -1856,36 +1899,19 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 	kmem_cache_destroy(c->slab_cache);
 	kmem_cache_destroy(c->slab_buffer);
 	dm_io_client_destroy(c->dm_io);
-bad_dm_io:
 	mutex_destroy(&c->lock);
 	if (c->no_sleep)
 		static_branch_dec(&no_sleep_enabled);
+bad_do_init:
 	kfree(c);
 bad_client:
 	return ERR_PTR(r);
 }
 EXPORT_SYMBOL_GPL(dm_bufio_client_create);
 
-/*
- * Free the buffering interface.
- * It is required that there are no references on any buffers.
- */
-void dm_bufio_client_destroy(struct dm_bufio_client *c)
+static void __do_destroy(struct dm_bufio_client *c)
 {
-	unsigned i;
-
-	drop_buffers(c);
-
-	unregister_shrinker(&c->shrinker);
-	flush_work(&c->shrink_work);
-
-	mutex_lock(&dm_bufio_clients_lock);
-
-	list_del(&c->client_list);
-	dm_bufio_client_count--;
-	__cache_size_refresh();
-
-	mutex_unlock(&dm_bufio_clients_lock);
+	unsigned int i;
 
 	BUG_ON(!RB_EMPTY_ROOT(&c->buffer_tree));
 	BUG_ON(c->need_reserved_buffers);
@@ -1905,11 +1931,39 @@ void dm_bufio_client_destroy(struct dm_bufio_client *c)
 		BUG_ON(c->n_buffers[i]);
 
 	kmem_cache_destroy(c->slab_cache);
+	c->slab_cache = NULL;
 	kmem_cache_destroy(c->slab_buffer);
-	dm_io_client_destroy(c->dm_io);
+	c->slab_buffer = NULL;
+	if (c->dm_io) {
+		dm_io_client_destroy(c->dm_io);
+		c->dm_io = NULL;
+	}
 	mutex_destroy(&c->lock);
-	if (c->no_sleep)
+	if (c->no_sleep) {
 		static_branch_dec(&no_sleep_enabled);
+		c->no_sleep = false;
+	}
+}
+
+/*
+ * Free the buffering interface.
+ * It is required that there are no references on any buffers.
+ */
+void dm_bufio_client_destroy(struct dm_bufio_client *c)
+{
+	drop_buffers(c);
+
+	unregister_shrinker(&c->shrinker);
+	flush_work(&c->shrink_work);
+
+	mutex_lock(&dm_bufio_clients_lock);
+	list_del(&c->client_list);
+	dm_bufio_client_count--;
+	__cache_size_refresh();
+	mutex_unlock(&dm_bufio_clients_lock);
+
+	__do_destroy(c);
+
 	kfree(c);
 }
 EXPORT_SYMBOL_GPL(dm_bufio_client_destroy);
diff --git a/include/linux/dm-bufio.h b/include/linux/dm-bufio.h
index 15d9e15ca830..ee4f19c170ab 100644
--- a/include/linux/dm-bufio.h
+++ b/include/linux/dm-bufio.h
@@ -26,8 +26,8 @@ struct dm_buffer;
  * Create a buffered IO cache on a given device
  */
 struct dm_bufio_client *
-dm_bufio_client_create(struct block_device *bdev, unsigned block_size,
-		       unsigned reserved_buffers, unsigned aux_size,
+dm_bufio_client_create(struct block_device *bdev, unsigned int block_size,
+		       unsigned int reserved_buffers, unsigned int aux_size,
 		       void (*alloc_callback)(struct dm_buffer *),
 		       void (*write_callback)(struct dm_buffer *),
 		       unsigned int flags);
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


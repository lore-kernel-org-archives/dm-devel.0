Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82BD9C001DC
	for <dm-devel@archiver.kernel.org>; Wed, 19 Jul 2023 20:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689798035;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=045tEj1vhBfjQLldLd22FAY7cz/SNVzowk5OaUyaNLc=;
	b=ZoBQnme+q8tcDF/6q1571v1AQdv0aYV6HekwqZkfVt1akvl33F5Eq6JzRXsrQqnnlYgYgq
	F7/sBcysxqXg0/wLUX4XuOZJsibVs21ASF3sXo5lcYVcRNyw8GK9HFERr27O1pqU9vfuze
	FQstbm9dGaNjoV9EIyAXZD9IDPKDSrc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-317-qZA2K2YnMX-no_grAlB8Rw-1; Wed, 19 Jul 2023 16:20:32 -0400
X-MC-Unique: qZA2K2YnMX-no_grAlB8Rw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3ACA28F184A;
	Wed, 19 Jul 2023 20:20:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2A2F6C57969;
	Wed, 19 Jul 2023 20:20:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 07B6219465B9;
	Wed, 19 Jul 2023 20:20:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2884519465A4
 for <dm-devel@listman.corp.redhat.com>; Wed, 19 Jul 2023 20:19:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 129B540C2071; Wed, 19 Jul 2023 20:19:10 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown
 [10.11.5.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F3B1640C206F;
 Wed, 19 Jul 2023 20:19:09 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix,
 from userid 12668)
 id EDE063096A42; Wed, 19 Jul 2023 20:19:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
 by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id
 ECE523F7CF; Wed, 19 Jul 2023 22:19:09 +0200 (CEST)
Date: Wed, 19 Jul 2023 22:19:09 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Message-ID: <e8ac449-8bcb-b72e-7e50-31b4317b545d@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH 1/3] brd: extend the rcu regions to cover read
 and write
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
Cc: Christoph Hellwig <hch@infradead.org>, Li Nan <linan666@huaweicloud.com>,
 dm-devel@redhat.com, linux-block@vger.kernel.org,
 Zdenek Kabelac <zkabelac@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patch extends the rcu regions, so that lookup followed by a read or
write of a page is done inside rcu read lock. This is needed for the
following patch that enables discard.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/block/brd.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-2.6/drivers/block/brd.c
===================================================================
--- linux-2.6.orig/drivers/block/brd.c
+++ linux-2.6/drivers/block/brd.c
@@ -150,23 +150,27 @@ static void copy_to_brd(struct brd_devic
 	size_t copy;
 
 	copy = min_t(size_t, n, PAGE_SIZE - offset);
+	rcu_read_lock();
 	page = brd_lookup_page(brd, sector);
 	BUG_ON(!page);
 
 	dst = kmap_atomic(page);
 	memcpy(dst + offset, src, copy);
 	kunmap_atomic(dst);
+	rcu_read_unlock();
 
 	if (copy < n) {
 		src += copy;
 		sector += copy >> SECTOR_SHIFT;
 		copy = n - copy;
+		rcu_read_lock();
 		page = brd_lookup_page(brd, sector);
 		BUG_ON(!page);
 
 		dst = kmap_atomic(page);
 		memcpy(dst, src, copy);
 		kunmap_atomic(dst);
+		rcu_read_unlock();
 	}
 }
 
@@ -182,6 +186,7 @@ static void copy_from_brd(void *dst, str
 	size_t copy;
 
 	copy = min_t(size_t, n, PAGE_SIZE - offset);
+	rcu_read_lock();
 	page = brd_lookup_page(brd, sector);
 	if (page) {
 		src = kmap_atomic(page);
@@ -189,11 +194,13 @@ static void copy_from_brd(void *dst, str
 		kunmap_atomic(src);
 	} else
 		memset(dst, 0, copy);
+	rcu_read_unlock();
 
 	if (copy < n) {
 		dst += copy;
 		sector += copy >> SECTOR_SHIFT;
 		copy = n - copy;
+		rcu_read_lock();
 		page = brd_lookup_page(brd, sector);
 		if (page) {
 			src = kmap_atomic(page);
@@ -201,6 +208,7 @@ static void copy_from_brd(void *dst, str
 			kunmap_atomic(src);
 		} else
 			memset(dst, 0, copy);
+		rcu_read_unlock();
 	}
 }
 
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19A77C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 11 Jul 2022 20:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657571459;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4vZXS8kQAPxA9iotglulZgPV0TpuzJUI0fpC7oIODKk=;
	b=W+lOl8MPotHlZDRCXDl8WvFmMJcIj2SeCpObp9Ecpj/V1nHicXOgVToAv5FXZEPIikEt4g
	Q+N6AIZILdfVcb89skpXuC/2ZuKp92GnPhQQ78DvbfLxzyH8RGKdctUMooBOokEY3qnp80
	GdADkU69wslDfeHU+9MOPdFqIUey3Pc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-299-LTpLMztyPl6Iy9k9ZacS6A-1; Mon, 11 Jul 2022 16:30:57 -0400
X-MC-Unique: LTpLMztyPl6Iy9k9ZacS6A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D93E185A79C;
	Mon, 11 Jul 2022 20:30:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6A7BF1121314;
	Mon, 11 Jul 2022 20:30:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 52362194705C;
	Mon, 11 Jul 2022 20:30:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 85A53194705F
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Jul 2022 20:30:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 57FF618ECC; Mon, 11 Jul 2022 20:30:53 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4BFCC18EA8;
 Mon, 11 Jul 2022 20:30:53 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 26BKUrXb005616; Mon, 11 Jul 2022 16:30:53 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 26BKUqlo005612; Mon, 11 Jul 2022 16:30:53 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Mon, 11 Jul 2022 16:30:52 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Yu Kuai <yukuai1@huaweicloud.com>, Mike Snitzer <msnitzer@redhat.com>
In-Reply-To: <alpine.LRH.2.02.2207111627260.5249@file01.intranet.prod.int.rdu2.redhat.com>
Message-ID: <alpine.LRH.2.02.2207111630310.5249@file01.intranet.prod.int.rdu2.redhat.com>
References: <20220706093146.1961598-1-yukuai1@huaweicloud.com>
 <alpine.LRH.2.02.2207111627260.5249@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: [dm-devel] [PATCH 2/4] dm-writecache: count the number of blocks
 read, not the number of read bios
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
Cc: yukuai3@huawei.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org,
 agk@redhat.com, yi.zhang@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Change dm-writecache, so that it counts the number of blocks read instead
of the number of read bios. Bios can be split and requeued using the
dm_accept_partial_bio function, so counting of bios provided inaccurate
results.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Yu Kuai <yukuai1@huaweicloud.com>

Index: linux-2.6/drivers/md/dm-writecache.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-writecache.c
+++ linux-2.6/drivers/md/dm-writecache.c
@@ -1365,6 +1365,7 @@ read_next_block:
 		}
 	} else {
 		writecache_map_remap_origin(wc, bio, e);
+		wc->stats.reads += (bio->bi_iter.bi_size - wc->block_size) >> wc->block_size_bits;
 		map_op = WC_MAP_REMAP_ORIGIN;
 	}
 
Index: linux-2.6/Documentation/admin-guide/device-mapper/writecache.rst
===================================================================
--- linux-2.6.orig/Documentation/admin-guide/device-mapper/writecache.rst
+++ linux-2.6/Documentation/admin-guide/device-mapper/writecache.rst
@@ -78,8 +78,8 @@ Status:
 2. the number of blocks
 3. the number of free blocks
 4. the number of blocks under writeback
-5. the number of read requests
-6. the number of read requests that hit the cache
+5. the number of read blocks
+6. the number of read blocks that hit the cache
 7. the number of write requests
 8. the number of write requests that hit uncommitted block
 9. the number of write requests that hit committed block

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


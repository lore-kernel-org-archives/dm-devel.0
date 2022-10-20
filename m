Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CABA1C4332F
	for <dm-devel@archiver.kernel.org>; Thu, 20 Oct 2022 16:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666284864;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Qyx08Vy21+4ijaAqyb2w55Xje8Ooip3ABJoNAsYK2RU=;
	b=QnfjoJ33gpKREb3DVP6YYy1rOx44ppvAEAC0F+6R9tzjq1SmWNg8NrVrxosgvuvV0GOOKQ
	VAPMSzfsE+Mbp4DNH8NTESRnAEiJtQQKR+a75MQJ4NXq1XEiaU9PWj9Lekp5lbKI84udT5
	y+p7oNSe5HgrVGv7VuAkP/gHgwkaeHo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-pXPpB-CeOYKDYABtc0qvQA-1; Thu, 20 Oct 2022 12:54:21 -0400
X-MC-Unique: pXPpB-CeOYKDYABtc0qvQA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0CB58101E151;
	Thu, 20 Oct 2022 16:54:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AA42E477F5D;
	Thu, 20 Oct 2022 16:54:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5367B1946595;
	Thu, 20 Oct 2022 16:54:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4841E1946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 20 Oct 2022 16:54:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 39DB4111D7AE; Thu, 20 Oct 2022 16:54:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3222A111D7AD
 for <dm-devel@redhat.com>; Thu, 20 Oct 2022 16:54:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C20D129324B8
 for <dm-devel@redhat.com>; Thu, 20 Oct 2022 16:46:45 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-137-1ywEL4AeNJWC7E0EgSMdvg-1; Thu, 20 Oct 2022 12:46:43 -0400
X-MC-Unique: 1ywEL4AeNJWC7E0EgSMdvg-1
Received: from [205.220.129.26] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1olYgm-000WLG-2r; Thu, 20 Oct 2022 16:46:37 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>
Date: Thu, 20 Oct 2022 09:46:01 -0700
Message-Id: <20221020164605.1764830-3-hch@lst.de>
In-Reply-To: <20221020164605.1764830-1-hch@lst.de>
References: <20221020164605.1764830-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: [dm-devel] [PATCH 2/6] dm: remove free_table_devices
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
Cc: linux-block@vger.kernel.org, Yu Kuai <yukuai1@huaweicloud.com>,
 dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

free_table_devices just warns and frees all table_device structures when
the target removal did not remove them.  This should never happen, but
if it did, just freeing the structure without deleting them from the
list or cleaning up the resources would not help at all.  So just WARN on
a non-empty list instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 60549b65c799c..36189a32329aa 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -833,19 +833,6 @@ void dm_put_table_device(struct mapped_device *md, struct dm_dev *d)
 	mutex_unlock(&md->table_devices_lock);
 }
 
-static void free_table_devices(struct list_head *devices)
-{
-	struct list_head *tmp, *next;
-
-	list_for_each_safe(tmp, next, devices) {
-		struct table_device *td = list_entry(tmp, struct table_device, list);
-
-		DMWARN("dm_destroy: %s still exists with %d references",
-		       td->dm_dev.name, refcount_read(&td->count));
-		kfree(td);
-	}
-}
-
 /*
  * Get the geometry associated with a dm device
  */
@@ -2123,7 +2110,7 @@ static void free_dev(struct mapped_device *md)
 
 	cleanup_mapped_device(md);
 
-	free_table_devices(&md->table_devices);
+	WARN_ON_ONCE(!list_empty(&md->table_devices));
 	dm_stats_cleanup(&md->stats);
 	free_minor(minor);
 
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


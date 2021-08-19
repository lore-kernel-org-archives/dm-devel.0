Return-Path: <SRS0=6+Yd=NK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85811C4338F
	for <dm-devel@archiver.kernel.org>; Thu, 19 Aug 2021 18:06:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D87BF60F5E
	for <dm-devel@archiver.kernel.org>; Thu, 19 Aug 2021 18:06:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D87BF60F5E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-602-IEssl8gqOPOXQZKJ9L7qgQ-1; Thu, 19 Aug 2021 14:06:26 -0400
X-MC-Unique: IEssl8gqOPOXQZKJ9L7qgQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 432971082921;
	Thu, 19 Aug 2021 18:06:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F7836A908;
	Thu, 19 Aug 2021 18:06:19 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F197F181A0F8;
	Thu, 19 Aug 2021 18:06:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17JI6AVh006172 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 19 Aug 2021 14:06:11 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8793B21D0DB5; Thu, 19 Aug 2021 18:06:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 82FA621D0DB2
	for <dm-devel@redhat.com>; Thu, 19 Aug 2021 18:06:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E5E95858EEC
	for <dm-devel@redhat.com>; Thu, 19 Aug 2021 18:06:06 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-46-nZ7YHwpwNYm0ZMIGsReBmg-1;
	Thu, 19 Aug 2021 14:06:02 -0400
X-MC-Unique: nZ7YHwpwNYm0ZMIGsReBmg-1
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8BDED6736F; Thu, 19 Aug 2021 20:05:59 +0200 (CEST)
Date: Thu, 19 Aug 2021 20:05:59 +0200
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <20210819180559.GA14001@lst.de>
References: <20210804094147.459763-1-hch@lst.de> <YR5/wMEkr1TwV7FD@redhat.com>
MIME-Version: 1.0
In-Reply-To: <YR5/wMEkr1TwV7FD@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Tushar Sugandhi <tusharsu@linux.microsoft.com>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] holders not working properly,
 regression [was: Re: use regular gendisk registration in device
 mapper v2]
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Manually reverting "block: remove the extra kobject reference in
bd_link_disk_holder" as show below fixed the issue for me.  I'll spend
some more time tomorrow trying to fully understan the life time rules
tomorrow before sending a patch, though.

---
>From 6b94f5435900d23769db8d07ff47415aab4ac63e Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Thu, 19 Aug 2021 20:01:43 +0200
Subject: Revert "block: remove the extra kobject reference in
 bd_link_disk_holder"

This reverts commit fbd9a39542ecdd2ade55869c13856b2590db3df8.
---
 block/holder.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/block/holder.c b/block/holder.c
index 4568cc4f6827..ecbc6941e7d8 100644
--- a/block/holder.c
+++ b/block/holder.c
@@ -106,6 +106,12 @@ int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
 	}
 
 	list_add(&holder->list, &disk->slave_bdevs);
+	/*
+	 * bdev could be deleted beneath us which would implicitly destroy
+	 * the holder directory.  Hold on to it.
+	 */
+	kobject_get(bdev->bd_holder_dir);
+
 out_unlock:
 	mutex_unlock(&disk->open_mutex);
 	return ret;
@@ -138,6 +144,7 @@ void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk)
 	if (!WARN_ON_ONCE(holder == NULL) && !--holder->refcnt) {
 		if (disk->slave_dir)
 			__unlink_disk_holder(bdev, disk);
+		kobject_put(bdev->bd_holder_dir);
 		list_del_init(&holder->list);
 		kfree(holder);
 	}
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


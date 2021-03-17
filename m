Return-Path: <SRS0=F0YI=IP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09301C433E0
	for <dm-devel@archiver.kernel.org>; Wed, 17 Mar 2021 15:35:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4395664EFD
	for <dm-devel@archiver.kernel.org>; Wed, 17 Mar 2021 15:35:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4395664EFD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1615995298;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=j2bL1PmtXf+KyfqTza0FtXvVtEc4kBgvz6R+FYlPHCs=;
	b=Jg6WzPtCJvbdQQ7HBon/ENnXozy0XteqrAZeC0KgJ2F+kaFqbVhvkqhmnD6NILDT52k9vh
	qMoJ4iHndUhmKW52s9HwjhwQp9KCTlT0WHxxVqU+GP1ixlkYWVFY3/meOzI5vkQTN/ZRmT
	rjKau9PuaPb1G4EIA2ZQELqBbBaOVs4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-kRQWk-cZOe-7j5LCD-iDLw-1; Wed, 17 Mar 2021 11:34:56 -0400
X-MC-Unique: kRQWk-cZOe-7j5LCD-iDLw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3770480D686;
	Wed, 17 Mar 2021 15:34:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F353719C66;
	Wed, 17 Mar 2021 15:34:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8664B1809C83;
	Wed, 17 Mar 2021 15:34:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12HFYlrg021733 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 17 Mar 2021 11:34:47 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 4D6D05C1CF; Wed, 17 Mar 2021 15:34:47 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A0AE05C5DF;
	Wed, 17 Mar 2021 15:34:40 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 12HFYeMU029722; Wed, 17 Mar 2021 11:34:40 -0400
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 12HFYdrE029718; Wed, 17 Mar 2021 11:34:39 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Wed, 17 Mar 2021 11:34:39 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20210317134715.GA362913@infradead.org>
Message-ID: <alpine.LRH.2.02.2103171129550.2959@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2103170644080.32577@file01.intranet.prod.int.rdu2.redhat.com>
	<20210317134715.GA362913@infradead.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, ming.lei@redhat.com,
	Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: [dm-devel] [PATCH] block: remove the "detected capacity change"
	message
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Wed, 17 Mar 2021, Christoph Hellwig wrote:

> No, it is everything but useless.  It is not needed during device
> creation, but that is something that the GENHD_FL_UP check should catch.
> 
> You should probably audit the device mapper code why it sets the initial
> capacity when the gendisk is up already, as that can cause all kinds of
> problems.  If the setting of the initial capacity after add_disk is
> indeed intentional you can switch to set_capacity(), but you should
> probably document the rationale in a detailed comment.

BTW. the loop device has the same problem as device mapper - it also 
prints "loop0: detected capacity change from 0 to 2097152" when it is 
being activated.

Would you accept this patch?

Or do you think that we should change device mapper and the loopback 
driver to call "set_capacity" on the initial device creation?

Mikulas

---
 block/genhd.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/block/genhd.c
===================================================================
--- linux-2.6.orig/block/genhd.c	2021-03-17 16:26:11.000000000 +0100
+++ linux-2.6/block/genhd.c	2021-03-17 16:26:42.000000000 +0100
@@ -71,16 +71,16 @@ bool set_capacity_and_notify(struct gend
 	if (size == capacity ||
 	    (disk->flags & (GENHD_FL_UP | GENHD_FL_HIDDEN)) != GENHD_FL_UP)
 		return false;
-
-	pr_info("%s: detected capacity change from %lld to %lld\n",
-		disk->disk_name, capacity, size);
-
 	/*
 	 * Historically we did not send a uevent for changes to/from an empty
 	 * device.
 	 */
 	if (!capacity || !size)
 		return false;
+
+	pr_info("%s: detected capacity change from %lld to %lld\n",
+		disk->disk_name, capacity, size);
+
 	kobject_uevent_env(&disk_to_dev(disk)->kobj, KOBJ_CHANGE, envp);
 	return true;
 }

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


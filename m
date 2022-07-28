Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57A62C04A68
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jul 2022 15:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659020431;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=wJBjK4/uIkOwt/Q3indwP4bSgP7G0ompr3AkOnO3UCo=;
	b=RZnqS6XsHP0pUiyvx20i28AQASbdsWyHja4o+dgCs40dJ79x+J1zclJi7ww7S34/IdHWkq
	RNzuWqsYGJFoIHEZquf2RUg8Y/RP3J3OOF+bTuOe/cl4nZZTVrtJYjKPCn9+RSlfLslgk0
	YNmEOEnh9zhAMxKbU+YbJ/gLrruXdE4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-31-E6bDTjIDO4W_vZSm5FKeTw-1; Thu, 28 Jul 2022 11:00:28 -0400
X-MC-Unique: E6bDTjIDO4W_vZSm5FKeTw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8731A19705BC;
	Thu, 28 Jul 2022 15:00:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3043B492C3B;
	Thu, 28 Jul 2022 15:00:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E7DEE1945DA7;
	Thu, 28 Jul 2022 15:00:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6A4DB1945D85
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Jul 2022 15:00:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 56DC8492CA2; Thu, 28 Jul 2022 15:00:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 52CDD492C3B
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 15:00:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 366B6381A09A
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 15:00:23 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-347-pr6bvviSPTKidpi4MC52bQ-1; Thu, 28 Jul 2022 11:00:20 -0400
X-MC-Unique: pr6bvviSPTKidpi4MC52bQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 85B17619A0;
 Thu, 28 Jul 2022 15:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F19C433C1;
 Thu, 28 Jul 2022 15:00:18 +0000 (UTC)
Date: Thu, 28 Jul 2022 17:00:16 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <YuKkgPx2XF6rQnLq@kroah.com>
References: <20220718211226.506362-1-tadeusz.struk@linaro.org>
 <YtwM3uHugOOdDQZT@kroah.com> <YuKgW9BCNl8ChT/v@kroah.com>
 <20220728144520.GA18285@lst.de>
MIME-Version: 1.0
In-Reply-To: <20220728144520.GA18285@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH 5.10 1/2] block: split bio_kmalloc from
 bio_alloc_bioset
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
Cc: Jens Axboe <axboe@kernel.dk>, Damien Le Moal <damien.lemoal@wdc.com>,
 Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, stable@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 syzbot+4f441e6ca0fcad141421@syzkaller.appspotmail.com,
 Tadeusz Struk <tadeusz.struk@linaro.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Jul 28, 2022 at 04:45:20PM +0200, Christoph Hellwig wrote:
> On Thu, Jul 28, 2022 at 04:42:35PM +0200, Greg KH wrote:
> > > > Link: https://syzkaller.appspot.com/bug?id=a3416231e37024a75f2b95bd95db0d8ce8132a84
> > > 
> > > Both now queued up, thanks.
> > 
> > As was just reported, this breaks things all over the place:
> > 	https://lore.kernel.org/r/219030d8-3408-cc9d-7aec-1fb14ab891ce@roeck-us.net
> > 
> > Note, I also had to add lots of fix-up patches on top of these two that
> > you missed, so odds are there are other fix-ups that I also missed.
> > 
> > Please go and test this again, and submit ALL patches that are needed
> > after they pass the proper testing and I will be glad to reconsider them
> > again.
> 
> Why did this even get backported?  It was a cleanup that required a lot
> of prep work, and should not by itself fix anything.

Looks like syzkaller is reporting something odd...

Tadeusz, how was this tested?

thanks,

greg k-h

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


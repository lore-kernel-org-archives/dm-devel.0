Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8982C04A68
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jul 2022 14:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659019373;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=uu+4yf/W/LcdZrhHbF95axD0t+60uPoRczZzPT1Q81U=;
	b=Lou7CCLZcAF37bBryuLzJ71zFLVp++Tcp3csa0+Z6AI3svubxYv88BoxfDYp/o8cydfSDK
	fjAU6Q8vyUDJTHTLe3Cv/Z6qz7exZ8M0vWwGuSEto3IKsRr/yXOyxH/kETrt/dBMLQJD+U
	65Y2hnHvPMoKS4+iTgxUKULUfxY1U7U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-333--j-11KvjNSm46u6d_4LtTA-1; Thu, 28 Jul 2022 10:42:49 -0400
X-MC-Unique: -j-11KvjNSm46u6d_4LtTA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 965F28032F0;
	Thu, 28 Jul 2022 14:42:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2EB242026D64;
	Thu, 28 Jul 2022 14:42:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D78A31945DA7;
	Thu, 28 Jul 2022 14:42:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 22D921945DA7
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Jul 2022 14:42:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E932D40C1288; Thu, 28 Jul 2022 14:42:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E5B93403D0D9
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 14:42:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C9EF91C01B38
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 14:42:42 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-343-pRt5EtdnNOOcyJIgwu-NAA-1; Thu, 28 Jul 2022 10:42:41 -0400
X-MC-Unique: pRt5EtdnNOOcyJIgwu-NAA-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id D5D7CB82483;
 Thu, 28 Jul 2022 14:42:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D919C433D6;
 Thu, 28 Jul 2022 14:42:37 +0000 (UTC)
Date: Thu, 28 Jul 2022 16:42:35 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Tadeusz Struk <tadeusz.struk@linaro.org>
Message-ID: <YuKgW9BCNl8ChT/v@kroah.com>
References: <20220718211226.506362-1-tadeusz.struk@linaro.org>
 <YtwM3uHugOOdDQZT@kroah.com>
MIME-Version: 1.0
In-Reply-To: <YtwM3uHugOOdDQZT@kroah.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
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
 Christoph Hellwig <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Jul 23, 2022 at 04:59:42PM +0200, Greg KH wrote:
> On Mon, Jul 18, 2022 at 02:12:25PM -0700, Tadeusz Struk wrote:
> > From: Christoph Hellwig <hch@lst.de>
> > 
> > From: Christoph Hellwig <hch@lst.de>
> > 
> > Upstream commit: 3175199ab0ac ("block: split bio_kmalloc from bio_alloc_bioset")
> > 
> > This is backport to stable 5.10. It fixes an issue reported by syzbot.
> > Link: https://syzkaller.appspot.com/bug?id=a3416231e37024a75f2b95bd95db0d8ce8132a84
> 
> Both now queued up, thanks.

As was just reported, this breaks things all over the place:
	https://lore.kernel.org/r/219030d8-3408-cc9d-7aec-1fb14ab891ce@roeck-us.net

Note, I also had to add lots of fix-up patches on top of these two that
you missed, so odds are there are other fix-ups that I also missed.

Please go and test this again, and submit ALL patches that are needed
after they pass the proper testing and I will be glad to reconsider them
again.

thanks,

greg k-h

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28B20C43334
	for <dm-devel@archiver.kernel.org>; Sat, 23 Jul 2022 14:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658588398;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ALlWXG2fE+/6eP7hFKnKjRGZOxmFEDqAIbcFxYUrIo8=;
	b=Tw1FmC/SObWVYlheK4P/QrH10XjYIbcOB+cq9gdGf1iXixt4YkTZAVrOGNK9OKZsszEjgN
	hH02cHU3va5KICAhXtzrb63d8ajgphHopQu5sBRtKUhOrOxJmICGog1RLfMF2bCV3onLkX
	Bo7D+FxpzbzgXQ7pRVrqw8OtCOt51LY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-301-RBxf6pwWNuaR_RGrp4b0xA-1; Sat, 23 Jul 2022 10:59:55 -0400
X-MC-Unique: RBxf6pwWNuaR_RGrp4b0xA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 29D1E294EDCB;
	Sat, 23 Jul 2022 14:59:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 77C2B404C6EA;
	Sat, 23 Jul 2022 14:59:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 55CDB1945D81;
	Sat, 23 Jul 2022 14:59:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C87E41945D80
 for <dm-devel@listman.corp.redhat.com>; Sat, 23 Jul 2022 14:59:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A6BFE40CF8EA; Sat, 23 Jul 2022 14:59:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A2CA1400E894
 for <dm-devel@redhat.com>; Sat, 23 Jul 2022 14:59:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B740380406D
 for <dm-devel@redhat.com>; Sat, 23 Jul 2022 14:59:49 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-642-w2ozQWHHORWvzzytmfPjZw-1; Sat, 23 Jul 2022 10:59:47 -0400
X-MC-Unique: w2ozQWHHORWvzzytmfPjZw-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 92A3FB80AF0;
 Sat, 23 Jul 2022 14:59:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF125C341C0;
 Sat, 23 Jul 2022 14:59:44 +0000 (UTC)
Date: Sat, 23 Jul 2022 16:59:42 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Tadeusz Struk <tadeusz.struk@linaro.org>
Message-ID: <YtwM3uHugOOdDQZT@kroah.com>
References: <20220718211226.506362-1-tadeusz.struk@linaro.org>
MIME-Version: 1.0
In-Reply-To: <20220718211226.506362-1-tadeusz.struk@linaro.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Jul 18, 2022 at 02:12:25PM -0700, Tadeusz Struk wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> From: Christoph Hellwig <hch@lst.de>
> 
> Upstream commit: 3175199ab0ac ("block: split bio_kmalloc from bio_alloc_bioset")
> 
> This is backport to stable 5.10. It fixes an issue reported by syzbot.
> Link: https://syzkaller.appspot.com/bug?id=a3416231e37024a75f2b95bd95db0d8ce8132a84

Both now queued up, thanks.

greg k-h

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


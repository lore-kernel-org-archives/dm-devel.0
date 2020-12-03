Return-Path: <SRS0=8v/u=FH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59C76C4361A
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 20:07:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 95C5C221F4
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 20:07:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 95C5C221F4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-oq4p0wSpOBS88B5lkUTEtQ-1; Thu, 03 Dec 2020 15:06:55 -0500
X-MC-Unique: oq4p0wSpOBS88B5lkUTEtQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C47E107ACFE;
	Thu,  3 Dec 2020 20:06:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1777910013C0;
	Thu,  3 Dec 2020 20:06:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C9C4E4BB7B;
	Thu,  3 Dec 2020 20:06:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B3K6mrO025506 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Dec 2020 15:06:48 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9C0AB2026D49; Thu,  3 Dec 2020 20:06:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 95EF62026D12
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 20:06:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4D03E858EEC
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 20:06:46 +0000 (UTC)
Received: from mail-qv1-f68.google.com (mail-qv1-f68.google.com
	[209.85.219.68]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-88-CM6aamxzP0ylzSq-VE552w-1; Thu, 03 Dec 2020 15:06:44 -0500
X-MC-Unique: CM6aamxzP0ylzSq-VE552w-1
Received: by mail-qv1-f68.google.com with SMTP id 4so1633872qvh.1
	for <dm-devel@redhat.com>; Thu, 03 Dec 2020 12:06:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=TeMeD5rdK34kbYGDr2vSjgHIjgXKs5834n/PsXhZAI0=;
	b=VmW6+/OhNZztNStymRYNK4ahYS7is3CUjlIiRAyyui4a3i3CdCo1WoIWCCb6yeb3RS
	Btt+2UynY75ogRo18d0Ydwqb4kaMa6BWsb62dlara9a6obg9jHCOfiUoDOJJ8herOe5o
	8Oer4UueYc9dzZZ8SjXOxHR0B/jW+9zs5oRjcDHDAafielwsRUH3jGJAdiuNj1rM7dC7
	ewGm5wJPrhPPCISZFo3b3YgiYazHY2v2R8acdKPBztAe+F1nyk5ysHRCLVEeXnapr7RE
	txDh67Lf0BktLJaOtGHt1S6bG1Ccp052lGGa8852266q9aHFNvnZB73QLLjpA78X3+CU
	xhDQ==
X-Gm-Message-State: AOAM532xe8C+1WfpyB5CeskTDR2I7i25zWO4dyvu8e44b1/XFmzNOe1m
	Gd0LbamaArWN/2AzcJulMUlJRWqKVgcAIg==
X-Google-Smtp-Source: ABdhPJzdhBAvFjybZDFPWDvdm5XjZfh9aZCIfGATPe6fEcgPcDTiUY/TMes6fNsYkOvFlBs3V9wsBw==
X-Received: by 2002:a05:6214:17c1:: with SMTP id
	cu1mr749690qvb.32.1607026003661; 
	Thu, 03 Dec 2020 12:06:43 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:6aeb])
	by smtp.gmail.com with ESMTPSA id v4sm2556106qth.16.2020.12.03.12.06.42
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 03 Dec 2020 12:06:42 -0800 (PST)
Date: Thu, 3 Dec 2020 15:06:15 -0500
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <X8lFN2rjkPZ0OF+e@mtj.duckdns.org>
References: <20201203162139.2110977-1-hch@lst.de>
	<20201203162139.2110977-4-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201203162139.2110977-4-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org,
	Damien Le Moal <damien.lemoal@wdc.com>,
	linux-s390@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 3/5] block: remove the request_queue argument
 to the block_split tracepoint
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Dec 03, 2020 at 05:21:37PM +0100, Christoph Hellwig wrote:
> The request_queue can trivially be derived from the bio.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


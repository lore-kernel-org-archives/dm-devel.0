Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B408C433FE
	for <dm-devel@archiver.kernel.org>; Wed, 16 Nov 2022 20:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668629222;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=lfekDImIs/xeiQxpYhDi9QRrZUmVDrTVvA4QbXgst8U=;
	b=fmzD8MxZ3Tmp/PoCOXKJYUZPPB0aEOPScU7UPvapC6WGxcElwcFcJs5xw0d0sQ+1Q/KjpU
	iN/vuSKNCzs1IgVGQqHoyOhzEvJaMinbRgvGDPjZ4y6PjW81o008/uefNagVn4K++19Uj6
	N+aMawyup8tRByvmWWF554G0XBYmQ1w=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-GpFQbphTPNqT1L7NnFuedA-1; Wed, 16 Nov 2022 15:07:00 -0500
X-MC-Unique: GpFQbphTPNqT1L7NnFuedA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 40B9629AB3F8;
	Wed, 16 Nov 2022 20:06:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2F2352028E94;
	Wed, 16 Nov 2022 20:06:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F077D19465A3;
	Wed, 16 Nov 2022 20:06:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 63DB019465A2
 for <dm-devel@listman.corp.redhat.com>; Wed, 16 Nov 2022 20:06:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6EDE21415102; Wed, 16 Nov 2022 20:06:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 67780140EBF3
 for <dm-devel@redhat.com>; Wed, 16 Nov 2022 20:06:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B19D3C025BD
 for <dm-devel@redhat.com>; Wed, 16 Nov 2022 20:06:48 +0000 (UTC)
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-350-w2KFwiOnP_mXkl_RuakpGQ-1; Wed, 16 Nov 2022 15:06:46 -0500
X-MC-Unique: w2KFwiOnP_mXkl_RuakpGQ-1
Received: by mail-qk1-f198.google.com with SMTP id
 o13-20020a05620a2a0d00b006cf9085682dso18401333qkp.7
 for <dm-devel@redhat.com>; Wed, 16 Nov 2022 12:06:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=pyb9R3Z9t9f8WkvXA0nuu3YJepmBztVFz76Ik7BRpJA=;
 b=COBhM8d8ZezJPtKhw6BWi3KzoH8FsGHNvYxPoW3bTToLpGXnZZVsr4xnERWj03uYpZ
 q4AQ6c5l/GVQIU9WIt4+Phx1FOQ+zV6Gd5NDSNvebNjoOJG3xbY0G+iWtAHP2M1HwL+e
 aLLHJZdGZXzZRcPMhnRzzyxqXlM0o+7JbYcru4d0p3E+t/CXxYWIc8fbykeCVA5FAkXC
 R5dxlfTBc88QMHmgx/RCPW9BFq/Xu/8aQsXO1/PUMHjsB5am44kNte3o1/IcT5TCpARy
 kSf9S86oxzf3UzgyTDf4T7oDE2XfG0jOIb8L0yiI/uZMyAwG+k/8jgvdI5F7EMc2yICp
 ZEoQ==
X-Gm-Message-State: ANoB5pmGTCBTwBu7wYV608xIOYDpvJF07r7ehvZQl+dk07ui7DgH3IIb
 IAiTUkpswTs2Kgz2oCKBZ7tFaejIOsc1oTy1sHDJ3mcQ5IUSWwCqLuolc98SeM7Dk4LA2FBFoNH
 cH1ffep2C/XMkTQ==
X-Received: by 2002:ac8:709:0:b0:3a5:3553:7e67 with SMTP id
 g9-20020ac80709000000b003a535537e67mr22284476qth.221.1668629206204; 
 Wed, 16 Nov 2022 12:06:46 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4OWVuDBpLPO+fnhKT+wtMfNpmU489QKC5Tg7OxemVn4jr7/6riPzlClyiHZynUmVUayzpIGw==
X-Received: by 2002:ac8:709:0:b0:3a5:3553:7e67 with SMTP id
 g9-20020ac80709000000b003a535537e67mr22284453qth.221.1668629206022; 
 Wed, 16 Nov 2022 12:06:46 -0800 (PST)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 v14-20020ac873ce000000b003a5689134afsm9229620qtp.36.2022.11.16.12.06.45
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 16 Nov 2022 12:06:45 -0800 (PST)
Date: Wed, 16 Nov 2022 15:06:44 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Keith Busch <kbusch@meta.com>
Message-ID: <Y3VC1IPORgP4OBoy@redhat.com>
References: <20221110184501.2451620-1-kbusch@meta.com>
 <20221110184501.2451620-5-kbusch@meta.com>
MIME-Version: 1.0
In-Reply-To: <20221110184501.2451620-5-kbusch@meta.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [PATCHv2 4/5] dm-integrity: set dma_alignment limit
 in io_hints
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
Cc: axboe@kernel.dk, ebiggers@kernel.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, mpatocka@redhat.com, stefanha@redhat.com,
 Keith Busch <kbusch@kernel.org>, me@demsh.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Nov 10 2022 at  1:45P -0500,
Keith Busch <kbusch@meta.com> wrote:

> From: Keith Busch <kbusch@kernel.org>
> 
> This device mapper needs bio vectors to be sized and memory aligned to
> the logical block size. Set the minimum required queue limit
> accordingly.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>

Reviewed-by: Mike Snitzer <snitzer@kernel.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


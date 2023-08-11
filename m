Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1249EC0015E
	for <dm-devel@archiver.kernel.org>; Fri, 11 Aug 2023 21:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691789639;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=30X1IaclY6lnkHGCKJap8RR8VjuPw6e9XPdocLa0B/s=;
	b=JIWBZ1Kcfk+M01jLYX7NEGhFwkinU0RUeoo3CJ2LhIrkGoYTcXJPndVqo60jNScCtsW1eY
	5K0a/KnA0PFvZ5YqLHQ8NcLj7ZSNDRshnL8c4HPpLGPeGP88esvWVoaRMBhn7CzTBoB1mM
	F9YCCZg/tpDuLTXs6Wxb+/y6BKINTfA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-624-JKEcJTzXNl2aUskuSFexxg-1; Fri, 11 Aug 2023 17:33:56 -0400
X-MC-Unique: JKEcJTzXNl2aUskuSFexxg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A70F185A78B;
	Fri, 11 Aug 2023 21:33:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EDB9E40C6F4E;
	Fri, 11 Aug 2023 21:33:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AE0831946595;
	Fri, 11 Aug 2023 21:33:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BF3DC1946595
 for <dm-devel@listman.corp.redhat.com>; Fri, 11 Aug 2023 21:33:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B67C61121318; Fri, 11 Aug 2023 21:33:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AEFAB1121314
 for <dm-devel@redhat.com>; Fri, 11 Aug 2023 21:33:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 90728101A528
 for <dm-devel@redhat.com>; Fri, 11 Aug 2023 21:33:41 +0000 (UTC)
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com
 [209.85.214.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-100-OZgWKeKnM0qPaEN-FzwHqw-1; Fri, 11 Aug 2023 17:33:39 -0400
X-MC-Unique: OZgWKeKnM0qPaEN-FzwHqw-1
Received: by mail-pl1-f175.google.com with SMTP id
 d9443c01a7336-1bb7b8390e8so18347015ad.2; 
 Fri, 11 Aug 2023 14:33:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1691789618; x=1692394418;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=hL47jFFvDt7OXD+hxa5Uxt7WguECwOQyvoULO24VUWQ=;
 b=QDZkCTUiaDdgORnOwwwmhSYrcsWQ/XuRyJ+uORLz6Cn/B4qrxk/aeckHDQo5fWnw1L
 zG0kflYJJNADgVVsPCwgeT5vV5JBrpASXV9wOaandL0/AdLc6lEaGV5mWRtxQyv77ihi
 eZ/DmJaPjB2d37zY8AXoULx5CjnkZdIPEzWSCaa9ltSk5Dcxdo/NuYsaDYS9eYAQ5n6R
 UJRzSfCuPJUrSF/iAlKBJIYgg7tP6F+kaxSiiAfevlzik+/FJCrSAkd7reOLr9zLbD9s
 UEzvbZP2/mNeP8s2ADIgTbFtmHiq7jUbVkTsDi24mUs2dLDmnp4fAdJkPKfyNbqmnRsh
 J3aA==
X-Gm-Message-State: AOJu0YzatGvhTZkqDi9rbnZSRCoEDwVIIJnDjt0eG5jMIEIuPeDqxsuH
 iooPVH7yOTjT4rmGldn7y8Y=
X-Google-Smtp-Source: AGHT+IGAmnk9VKQD1Jo/hqmiveT5ZuVgUoMRBZbu5CA4433fTlsSPS9CN76yfuE6JEcmMaoZvr7xdA==
X-Received: by 2002:a17:902:e809:b0:1bb:de7f:a4d4 with SMTP id
 u9-20020a170902e80900b001bbde7fa4d4mr3429993plg.61.1691789618406; 
 Fri, 11 Aug 2023 14:33:38 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:cdd8:4c3:2f3c:adea?
 ([2620:15c:211:201:cdd8:4c3:2f3c:adea])
 by smtp.gmail.com with ESMTPSA id
 a4-20020a1709027d8400b001bc87e6e26bsm4378373plm.222.2023.08.11.14.33.36
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 11 Aug 2023 14:33:37 -0700 (PDT)
Message-ID: <0899ddc3-d9c1-3d9a-3649-2b1add9b2a7f@acm.org>
Date: Fri, 11 Aug 2023 14:33:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
To: Nitesh Shetty <nj.shetty@samsung.com>, Jens Axboe <axboe@kernel.dk>,
 Jonathan Corbet <corbet@lwn.net>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
References: <20230811105300.15889-1-nj.shetty@samsung.com>
 <CGME20230811105659epcas5p1982eeaeb580c4cb9b23a29270945be08@epcas5p1.samsung.com>
 <20230811105300.15889-4-nj.shetty@samsung.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230811105300.15889-4-nj.shetty@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v14 03/11] block: add copy offload support
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
Cc: martin.petersen@oracle.com, linux-doc@vger.kernel.org, gost.dev@samsung.com,
 Anuj Gupta <anuj20.g@samsung.com>, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, mcgrof@kernel.org,
 dlemoal@kernel.org, linux-fsdevel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: acm.org
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 8/11/23 03:52, Nitesh Shetty wrote:
> + * Description:
> + *	Copy source offset to destination offset within block device, using
> + *	device's native copy offload feature.

Offloading the copy operation is not guaranteed so I think that needs to 
be reflected in the above comment.

> + *	We perform copy operation by sending 2 bio's.
> + *	1. We take a plug and send a REQ_OP_COPY_SRC bio along with source
> + *	sector and length. Once this bio reaches request layer, we form a
> + *	request and wait for dst bio to arrive.

What will happen if the queue depth of the request queue at the bottom 
is one?

> +		blk_start_plug(&plug);
> +		dst_bio = blk_next_bio(src_bio, bdev, 0, REQ_OP_COPY_DST, gfp);

blk_next_bio() can return NULL so its return value should be checked.

> +		dst_bio->bi_iter.bi_size = chunk;
> +		dst_bio->bi_iter.bi_sector = pos_out >> SECTOR_SHIFT;
> +		dst_bio->bi_end_io = blkdev_copy_offload_dst_endio;
> +		dst_bio->bi_private = offload_io;

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


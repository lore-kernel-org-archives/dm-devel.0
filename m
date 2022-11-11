Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6772C433FE
	for <dm-devel@archiver.kernel.org>; Fri, 11 Nov 2022 18:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668190040;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=DA63HA5tt/e/UGt+8FbYHl6X8hVcZQTAGOoybV4nJgk=;
	b=MXtz2mpZlufqx9WAghx1k5hyNxgh6CvUW1uz5cHdjuJduD1vK9gFTOqBtGe2nwVkw5peUB
	csj+v2BUj28tOM1yuRz6qmWNoMofNSG/5kC6CFPpJMgNrZpSAINUgmlfxgS2ezyn9FMUxP
	CyxRS2Nqrg+hzxeOIIIYHp8PvOuQRBo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-487-JV8Ysqm8OCqbcmMahVYMLQ-1; Fri, 11 Nov 2022 13:07:17 -0500
X-MC-Unique: JV8Ysqm8OCqbcmMahVYMLQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1AD4129ABA0B;
	Fri, 11 Nov 2022 18:07:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CFC7EC15BA8;
	Fri, 11 Nov 2022 18:07:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 872E41946589;
	Fri, 11 Nov 2022 18:07:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 724861946586
 for <dm-devel@listman.corp.redhat.com>; Fri, 11 Nov 2022 18:07:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 520AEC15BA8; Fri, 11 Nov 2022 18:07:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4B02AC1908D
 for <dm-devel@redhat.com>; Fri, 11 Nov 2022 18:07:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0AFC3811E7A
 for <dm-devel@redhat.com>; Fri, 11 Nov 2022 18:07:09 +0000 (UTC)
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-440-hIxh3p26Mi2qAH2nsVfARQ-1; Fri, 11 Nov 2022 13:07:07 -0500
X-MC-Unique: hIxh3p26Mi2qAH2nsVfARQ-1
Received: by mail-qt1-f198.google.com with SMTP id
 cj6-20020a05622a258600b003a519d02f59so4073592qtb.5
 for <dm-devel@redhat.com>; Fri, 11 Nov 2022 10:07:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=80TYJDe6hNYBM09PGXA70+IGuQTIUVRClbkoMTJ8nZQ=;
 b=KTB7hXH9MHc3O4I+1wzrQXrROJOSDXDsz9U5Ly86gRnp/dlGZFYpGJ04nUpedA5VYd
 hLBAtKVfN6F5dkQ+anCe0lsNnETW38v0pogralJgoPI8ZNhmS+5He6cKsH/Hhfmddjjd
 STPFM5gY1+jjVA85x5JHYdBt61beD85AnABTjgbpFOZXl/5M3bKOieUQ5/+3zmPC1YY4
 jQ1hjPic0YXApPqnHTkac6FlYrRuCjeuZUQlLLsAfdkNovuUQLzWJ1c7XTEJAX9fGR77
 2fbHaqNilQlTju0y1DKmnRJgNB6PsquIvZwyzUEi/voEAFXuPbWfFAZrw2R82WIJERn7
 pWzQ==
X-Gm-Message-State: ANoB5plrr4HJEo2YXEYdMlSJTSOlP3G1atDIzx4NctCQgDH3XeOTqkjn
 +4NXP5HwLn6tAvPYHRMPELwa3bb/k8OzSblOEhIpb9VCkFDBbz3KFACb8NDkhLBNu+K+jgpSUoo
 zDtCyAyW8IuEqOQ==
X-Received: by 2002:ac8:4257:0:b0:3a5:26c3:22f4 with SMTP id
 r23-20020ac84257000000b003a526c322f4mr2380865qtm.681.1668190027400; 
 Fri, 11 Nov 2022 10:07:07 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7hoDB0jA1KI7h3boViFSMj/k4NHjJYIWttoM9rA6UOU1phvdLcQ47QpLgkD9SRefYi9kG5kQ==
X-Received: by 2002:ac8:4257:0:b0:3a5:26c3:22f4 with SMTP id
 r23-20020ac84257000000b003a526c322f4mr2380841qtm.681.1668190027174; 
 Fri, 11 Nov 2022 10:07:07 -0800 (PST)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 z2-20020ae9c102000000b006eeae49537bsm1727165qki.98.2022.11.11.10.07.06
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 11 Nov 2022 10:07:06 -0800 (PST)
Date: Fri, 11 Nov 2022 13:07:05 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Keith Busch <kbusch@meta.com>
Message-ID: <Y26PSYu2nY/AE5Xh@redhat.com>
References: <20221110184501.2451620-1-kbusch@meta.com>
MIME-Version: 1.0
In-Reply-To: <20221110184501.2451620-1-kbusch@meta.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCHv2 0/5] fix direct io device mapper errors
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Nov 10 2022 at  1:44P -0500,
Keith Busch <kbusch@meta.com> wrote:

> From: Keith Busch <kbusch@kernel.org>
> 
> The 6.0 kernel made some changes to the direct io interface to allow
> offsets in user addresses. This based on the hardware's capabilities
> reported in the request_queue's dma_alignment attribute.
> 
> dm-crypt, -log-writes and -integrity require direct io be aligned to the
> block size. Since it was only ever using the default 511 dma mask, this
> requirement may fail if formatted to something larger, like 4k, which
> will result in unexpected behavior with direct-io.
> 
> Changes since v1: Added the same fix for -integrity and -log-writes
> 
> The first three were reported successfully tested by Dmitrii Tcvetkov,
> but I don't have an official Tested-by: tag.
> 
>   https://lore.kernel.org/linux-block/20221103194140.06ce3d36@xps.demsh.org/T/#mba1d0b13374541cdad3b669ec4257a11301d1860
> 
> Keitio errors on Busch (5):
>   block: make dma_alignment a stacking queue_limit
>   dm-crypt: provide dma_alignment limit in io_hints
>   block: make blk_set_default_limits() private
>   dm-integrity: set dma_alignment limit in io_hints
>   dm-log-writes: set dma_alignment limit in io_hints
> 
>  block/blk-core.c           |  1 -
>  block/blk-settings.c       |  9 +++++----
>  block/blk.h                |  1 +
>  drivers/md/dm-crypt.c      |  1 +
>  drivers/md/dm-integrity.c  |  1 +
>  drivers/md/dm-log-writes.c |  1 +
>  include/linux/blkdev.h     | 16 ++++++++--------
>  7 files changed, 17 insertions(+), 13 deletions(-)
> 
> -- 
> 2.30.2
> 

There are other DM targets that override logical_block_size in their
.io_hints hook (writecache, ebs, zoned). Have you reasoned through why
those do _not_ need updating too?

Is there any risk of just introducing a finalization method in block
core (that DM's .io_hints would call) that would ensure limits that
are a funtion of another are always in sync?  Would avoid whack-a-mole
issues in the future.

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


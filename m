Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E8AEC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 17 Feb 2022 03:08:19 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-191-l9v7AOaKObamMbcHdAUrlA-1; Wed, 16 Feb 2022 22:08:14 -0500
X-MC-Unique: l9v7AOaKObamMbcHdAUrlA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 208BE801B0E;
	Thu, 17 Feb 2022 03:08:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2801F1036B4F;
	Thu, 17 Feb 2022 03:08:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 42B464BB7C;
	Thu, 17 Feb 2022 03:08:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21H385rh019345 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 16 Feb 2022 22:08:06 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8ABE3112131E; Thu, 17 Feb 2022 03:08:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 86075112131B
	for <dm-devel@redhat.com>; Thu, 17 Feb 2022 03:08:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7ACDB811E78
	for <dm-devel@redhat.com>; Thu, 17 Feb 2022 03:08:02 +0000 (UTC)
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com
	[209.85.214.176]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-16-o26Jj0VQOQeWTMwh1qyEfw-1; Wed, 16 Feb 2022 22:08:00 -0500
X-MC-Unique: o26Jj0VQOQeWTMwh1qyEfw-1
Received: by mail-pl1-f176.google.com with SMTP id 10so3564195plj.1
	for <dm-devel@redhat.com>; Wed, 16 Feb 2022 19:08:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
	:content-language:to:cc:references:from:in-reply-to
	:content-transfer-encoding;
	bh=m0P9N0WVb6AAY2j7DvviRpPpziBTQrcj2AKsHwgmWuw=;
	b=SQqFxks3oM0Rm3IlqeGiotVYHjNsJ+wUI7uXP8fJoLc6e7aBN03rJWzFnl7tverPAO
	wPNsmBAli1rMcsbLB6RHSxAmyzaKG0A86Aa1EzpFzm17P/QobQZcNraVaXnV3TDajSpu
	W/Bvt98Ub4L/0g814vLiscuOytup71fcpcVQoBTD8BOLpNkB3MUgi5ymKmd61RGf7Xko
	XS8AsLHsDRs1mtUhLOkSDgWNIXCQqylA8ZDLTPDKNJ6vqp+GpGB/xfG3MjRYggH4TTox
	dUIzI4Cx+U8ea1qxrWruR74vK7GXsN2bOvKrP8SgM6T5Aj9HYDzzbP/wP2rgKJt4Ey5h
	gf3w==
X-Gm-Message-State: AOAM530W2W17fW6GXn1URII2r3YZQiUzEGMT+8I/xNP8ZFahUTtVb186
	p3LluP9GKP8e5lP2VJWQRfLWWNmcOtwLXw==
X-Google-Smtp-Source: ABdhPJz0asluo8iIS9RrrQHu2lUE14mBYhmmL4kxvHAkUj2TEWV/p8/NhGuQnU8TsBWnkNPOevvXaQ==
X-Received: by 2002:a17:902:f787:b0:14f:43ba:55fc with SMTP id
	q7-20020a170902f78700b0014f43ba55fcmr979111pln.3.1645067279683; 
	Wed, 16 Feb 2022 19:07:59 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
	by smtp.gmail.com with ESMTPSA id
	lb18sm407819pjb.42.2022.02.16.19.07.57
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Wed, 16 Feb 2022 19:07:59 -0800 (PST)
Message-ID: <2f3f1c98-e013-ee03-2ffb-3a14730b13b9@kernel.dk>
Date: Wed, 16 Feb 2022 20:07:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
	Thunderbird/91.5.1
To: Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
References: <20220209082828.2629273-1-hch@lst.de>
	<yq1wni3sz4k.fsf@ca-mkp.ca.oracle.com> <20220210055151.GA3491@lst.de>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220210055151.GA3491@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: ukrishn@linux.ibm.com, target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org, philipp.reisner@linbit.com,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	manoj@linux.ibm.com, haris.iqbal@ionos.com,
	lars.ellenberg@linbit.com, drbd-dev@lists.linbit.com,
	jinpu.wang@ionos.com, mrochs@linux.ibm.com
Subject: Re: [dm-devel] remove REQ_OP_WRITE_SAME v2
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2/9/22 10:51 PM, Christoph Hellwig wrote:
> On Wed, Feb 09, 2022 at 01:00:26PM -0500, Martin K. Petersen wrote:
>>
>> Christoph,
>>
>>> Now that we are using REQ_OP_WRITE_ZEROES for all zeroing needs in the
>>> kernel there is very little use left for REQ_OP_WRITE_SAME.  We only
>>> have two callers left, and both just export optional protocol features
>>> to remote systems: DRBD and the target code.
>>
>> No particular objections from me. I had a half-baked series to do the
>> same thing.
>>
>> One thing I would like is to either pull this series through SCSI or do
>> the block pieces in a post merge branch because I'm about to post my
>> discard/zeroing rework and that's going to clash with your changes.
> 
> I'd be fine with taking this through the SCSI tree.  Or we can wait
> another merge window to make your life easier.

Let's just use the SCSI tree - I didn't check if it throws any conflicts
right now, so probably something to check upfront...

If things pan out, you can add my Acked-by to the series.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E3D4C4332F
	for <dm-devel@archiver.kernel.org>; Mon,  5 Dec 2022 20:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670272598;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=WpcBnbupHx675lUANr8av61XfJcCTZHWMdaYGrVkzoA=;
	b=ijp8zquA6sWUuYZ/2GTx4KETRngj/l3vZcyWTFwlGPpo5BA5ufwXmmKgStZbkYrWGFTf6N
	AFCkPfpTXB7oyyXN1exNb9wy9EY8sQXSfgplHB/behqvVKuqAtkafYaW3NztBLpAqvz8/0
	Li6ooowhhnNiMB3gkNt83eeW/FzEpHE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-318-Kcv3n9n8P9GkOpxTxRF7Xg-1; Mon, 05 Dec 2022 15:36:36 -0500
X-MC-Unique: Kcv3n9n8P9GkOpxTxRF7Xg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 180033C025D9;
	Mon,  5 Dec 2022 20:36:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EB55AC1908B;
	Mon,  5 Dec 2022 20:36:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C325C1946589;
	Mon,  5 Dec 2022 20:36:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2F1681946588
 for <dm-devel@listman.corp.redhat.com>; Mon,  5 Dec 2022 20:36:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E54172166B2A; Mon,  5 Dec 2022 20:36:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DE4342166B29
 for <dm-devel@redhat.com>; Mon,  5 Dec 2022 20:36:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C00373C0F7E3
 for <dm-devel@redhat.com>; Mon,  5 Dec 2022 20:36:30 +0000 (UTC)
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com
 [209.85.215.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-277-tbbkEwmlM36_SxmHR_nn_g-1; Mon, 05 Dec 2022 15:36:28 -0500
X-MC-Unique: tbbkEwmlM36_SxmHR_nn_g-1
Received: by mail-pg1-f176.google.com with SMTP id h33so11498513pgm.9
 for <dm-devel@redhat.com>; Mon, 05 Dec 2022 12:36:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=mFukHabHzU9nHDP00BQaLwWH/W2xDMgDd01lQ3KmF6E=;
 b=hhHFqF12zM8SgRDyjTYXTp3PbvBnSC8ZFtgBzoz4VJN6Zj0Q/4ua9rkt/TVNBSr/o8
 t1J3pIiiRqZi//OzeyUAHrf2DSLQTjDFo5DYpHZSfKuMq2Wj2hloK6u1P89AJnIpJNez
 n5bM6TqstOXVlFkKnsPAjYi6f6BgX0PLC6uIlzZsehgSOdjeDC92JuT9wzCRRpcRhDZc
 ModqAT+SIxqdpDjhM7Pv3A/4awEH+PW5olPg4l1GOjPMO1zFvFjM121HrLHjEQr/EOw3
 v5PHh4sYf0IM7VxCihAyMDMzjVmtF/mUQpeICNBUUysca/OKqFmBeTx4K5MDDqZHlC1Z
 267A==
X-Gm-Message-State: ANoB5pnHD/XwUXAk9ghgeWehF6HgFTcuCYKr6wuNhdPiz3MeMxlVBD/P
 2H4B5qSgRORMDv7tLsd2b3/98A==
X-Google-Smtp-Source: AA0mqf6f+5SrZjNmKrcYL9Lk5NtIaRvWLquHrmzDMU6yHBU3IEsPNFkTv5vSl/5woSgdox3nRtaQvw==
X-Received: by 2002:a63:191d:0:b0:46f:1cbd:261f with SMTP id
 z29-20020a63191d000000b0046f1cbd261fmr58570124pgl.329.1670272587255; 
 Mon, 05 Dec 2022 12:36:27 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
 by smtp.gmail.com with ESMTPSA id
 d24-20020a631d18000000b00478dad38eacsm183557pgd.38.2022.12.05.12.36.25
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 05 Dec 2022 12:36:26 -0800 (PST)
Message-ID: <c062d9cb-e8c6-543a-88be-016973058d43@kernel.dk>
Date: Mon, 5 Dec 2022 13:36:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
To: "Michael S. Tsirkin" <mst@redhat.com>
References: <20221205162035.2261037-1-alvaro.karsz@solid-run.com>
 <fe2800f1-aaae-33e8-aaf0-83fd034162d5@kernel.dk>
 <CAJs=3_AKOMWBpvKqvX6_c=zN1cwEM7x9dzGr7na=i-5_16rdEg@mail.gmail.com>
 <23c98c7c-3ed0-0d26-24c0-ed8a63266dcc@kernel.dk>
 <20221205152708-mutt-send-email-mst@kernel.org>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20221205152708-mutt-send-email-mst@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v3] virtio_blk: add VIRTIO_BLK_F_LIFETIME
 feature support
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
Cc: linux-scsi@vger.kernel.org, Alvaro Karsz <alvaro.karsz@solid-run.com>,
 Jason Wang <jasowang@redhat.com>, linux-nvme@lists.infradead.org,
 virtualization@lists.linux-foundation.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Enrico Granata <egranata@google.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 12/5/22 1:29?PM, Michael S. Tsirkin wrote:
> On Mon, Dec 05, 2022 at 11:53:51AM -0700, Jens Axboe wrote:
>> On 12/5/22 11:36?AM, Alvaro Karsz wrote:
>>> Hi,
>>>
>>>> Is this based on some spec? Because it looks pretty odd to me. There
>>>> can be a pretty wide range of two/three/etc level cells with wildly
>>>> different ranges of durability. And there's really not a lot of slc
>>>> for generic devices these days, if any.
>>>
>>> Yes, this is based on the virtio spec
>>> https://docs.oasis-open.org/virtio/virtio/v1.2/csd01/virtio-v1.2-csd01.html
>>> section  5.2.6
>>
>> And where did this come from?
> 
> 
> Here's the commit log from the spec:
> 	In many embedded systems, virtio-blk implementations are
> 	backed by eMMC or UFS storage devices, which are subject to
> 	predictable and measurable wear over time due to repeated write
> 	cycles.
> 
> 	For such systems, it can be important to be able to track
> 	accurately the amount of wear imposed on the storage over
> 	time and surface it to applications. In a native deployments
> 	this is generally handled by the physical block device driver
> 	but no such provision is made in virtio-blk to expose these
> 	metrics for devices where it makes sense to do so.
> 
> 	This patch adds support to virtio-blk for lifetime and wear
> 	metrics to be exposed to the guest when a deployment of
> 	virtio-blk is done over compatible eMMC or UFS storage.
> 
> 	Signed-off-by: Enrico Granata <egranata@google.com>
> 
> Cc Enrico Granata as well.

Alvaro sent me this one privately too. To be honest, I don't like this
patch very much, but that's mostly because the spec for this caters to a
narrow use case of embedded flash. It's not a generic storage thing,
it's just for mmc/ufs and the embedded space. That's a missed
opportunity. And either it'll become mostly unused, or it'll actually be
used and then extended at some point.

While I'm not a fan at all, if you guys are willing to take it in
virtio-blk, then I won't stand in your way. I would rename it though to
more specifically detail what it deals with.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF70BC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 13 Jan 2022 21:22:27 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-394-Az-yo2FjMdGUrZ0_erIUMQ-1; Thu, 13 Jan 2022 16:22:23 -0500
X-MC-Unique: Az-yo2FjMdGUrZ0_erIUMQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 39FBA100C661;
	Thu, 13 Jan 2022 21:22:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D7264BC42;
	Thu, 13 Jan 2022 21:22:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A27934BB7C;
	Thu, 13 Jan 2022 21:22:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20DLMDL4021068 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 13 Jan 2022 16:22:13 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id F3F1B76D0; Thu, 13 Jan 2022 21:22:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EEC3576CF
	for <dm-devel@redhat.com>; Thu, 13 Jan 2022 21:22:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 95D021C04B76
	for <dm-devel@redhat.com>; Thu, 13 Jan 2022 21:22:09 +0000 (UTC)
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com
	[209.85.214.173]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-328-bsTyU4mQPpCpUT9RvJZOyA-1; Thu, 13 Jan 2022 16:22:08 -0500
X-MC-Unique: bsTyU4mQPpCpUT9RvJZOyA-1
Received: by mail-pl1-f173.google.com with SMTP id g5so11431347plo.12
	for <dm-devel@redhat.com>; Thu, 13 Jan 2022 13:22:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
	:content-language:to:cc:references:from:in-reply-to
	:content-transfer-encoding;
	bh=P58pJIo6WXGCabngJa//gXPgDBHsrKLG6B0+/h9QvYw=;
	b=yPSzgWhDqkBfjtJyL7uCLV24+ZR33ku/8b0zcQZp9OJ66vfA2qzcpIPM23Ug2FH+49
	434j01fsHYIblSTfCC2q8kMNFI5hydrE5DBl5cwSRjovpAyQGghtFT4+2Wa7ROelqBCY
	L9YDnzUe+teHStm4pt1Zc+LZPAZAWK36ThQVVTM1dAKQuAyQoA/b/43TGw1rN5v4/T02
	R+t9mQpSPvTNuVHgSp9HDGwvFjK/B1HpzDehbfUeotkszEByOaM19sBqVZbzK1IMyaSy
	UV+KJygISYB2HE8fxGLNaJtY7hHouuv5BC8yAtNKtW8RjYc3JVdS04Ls5ASoRxUdg3hN
	FuLA==
X-Gm-Message-State: AOAM530yS2o+Vo3vZwHWjzbS8uwieK/AzbNOrsewFb7IvnL8o3mziVmN
	F/RaVlNTDzLNvUV6iwkgvXx4WHxtBnw=
X-Google-Smtp-Source: ABdhPJyExn+mrcs9jbuglQY7iy8WrfYX1sSx4R6lGC8Vc6C/lA1167h+wYtK8m2/lWy6Eu86OAch1Q==
X-Received: by 2002:a17:90a:6d61:: with SMTP id
	z88mr16326321pjj.165.1642108926589; 
	Thu, 13 Jan 2022 13:22:06 -0800 (PST)
Received: from [192.168.51.110] (c-73-241-217-19.hsd1.ca.comcast.net.
	[73.241.217.19]) by smtp.gmail.com with ESMTPSA id
	p10sm3712565pfo.95.2022.01.13.13.22.05
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Thu, 13 Jan 2022 13:22:05 -0800 (PST)
Message-ID: <8f2a832f-06de-d269-a24b-cce933a296f9@acm.org>
Date: Thu, 13 Jan 2022 13:22:03 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.4.1
To: Israel Rukshin <israelr@nvidia.com>, dm-devel <dm-devel@redhat.com>
References: <1642097341-6521-1-git-send-email-israelr@nvidia.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1642097341-6521-1-git-send-email-israelr@nvidia.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: Max Gurtovoy <mgurtovoy@nvidia.com>, Eric Biggers <ebiggers@kernel.org>,
	Nitzan Carmi <nitzanc@nvidia.com>
Subject: Re: [dm-devel] [RFC PATCH 0/1] Add inline encryption support for
 dm-crypt
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 1/13/22 10:09, Israel Rukshin wrote:
> I am working to add support for inline encryption/decryption
> at storage protocols like nvmf over RDMA. The HW that I am
> working with is ConnecX-6 Dx, which supports inline crypto
> and can send the data on the fabric at the same time.
> 
> This patchset is based on v5.16-rc4 with Eric Biggers patches
> of the HW wrapped keys.
> It can be retrieved from branch "wip-wrapped-keys" at
> https://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git
> 
> I tested this patch with modified nvme-rdma as the block device
> and created a DM crypt on top of it. I got performance enhancement
> compared to SW crypto. I tested the HW wrapped inline mode with
> the HW and the standard mode with a fallback algorithm.

Hi Israel,

Thank you for your work. For future patches related to inline 
encryption, please Cc Eric Biggers.

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


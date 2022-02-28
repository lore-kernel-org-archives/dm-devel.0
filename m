Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C30B8C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 28 Feb 2022 21:13:20 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-297-jTf5qI0KMaWnNTmxsSA41Q-1; Mon, 28 Feb 2022 16:13:15 -0500
X-MC-Unique: jTf5qI0KMaWnNTmxsSA41Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5565E5200;
	Mon, 28 Feb 2022 21:13:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EB95B2C92E;
	Mon, 28 Feb 2022 21:13:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5CEBA4ED79;
	Mon, 28 Feb 2022 21:13:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21SLD8hH010794 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 28 Feb 2022 16:13:08 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9B77957ECD9; Mon, 28 Feb 2022 21:13:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9748F57ECD4
	for <dm-devel@redhat.com>; Mon, 28 Feb 2022 21:13:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 78AE73804068
	for <dm-devel@redhat.com>; Mon, 28 Feb 2022 21:13:08 +0000 (UTC)
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com
	[209.85.218.47]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-399-H2GpLUn0PFCe2jcC8W03aA-1; Mon, 28 Feb 2022 16:13:06 -0500
X-MC-Unique: H2GpLUn0PFCe2jcC8W03aA-1
Received: by mail-ej1-f47.google.com with SMTP id d10so27406134eje.10
	for <dm-devel@redhat.com>; Mon, 28 Feb 2022 13:13:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
	:content-language:to:cc:references:from:in-reply-to
	:content-transfer-encoding;
	bh=YElPQ90MzgZ5t7UF5cUawb5iNATJs1V0tAe3h48q5Ic=;
	b=V3syZBElvR5oVzHB3Q49cZl6SYqTl2Ggw4YTYSOAkYL+GZY0+BlAWVTbE7NolYd4bz
	HBLSyqxGcAY89w0r+4Du3OIrO42NsmGswZpTVczh0kXUlTeYavlrTu7ghAyKO4kbGVEX
	9emejmGiM+6H9rG923EGdQHXpvXDqdXwcbsDKhj9sn4shU9Ugkbeg3JGMCkrGXHUD5ML
	8IK0utuZrw4l31vV4glssjcBQrlqM/imI8Q8BP+ok0TqC2bTPrg4nBx6xKrkkcWOkjHS
	srFhDOxrLA6mp5sl5MqyJcSUIIp7TA+kcpwkNIlDd/6EM1wiWwKQHZjoREk6zboWjoAs
	W44g==
X-Gm-Message-State: AOAM533dgXFP6yStjAyL22Cm7nz/y304QzGjik1TemNpz/UYsaC39oUw
	UhnFWjN2AL50qERHFmZiXDY=
X-Google-Smtp-Source: ABdhPJyoLznZAjc0gfKpSzx7Xn/iaaSpoiD3vjUv9rQSy6YLP//XFpDw0mqFQU2V9Q94Y/3Ca9VsJw==
X-Received: by 2002:a17:906:6b87:b0:6ce:537b:53bb with SMTP id
	l7-20020a1709066b8700b006ce537b53bbmr16409243ejr.51.1646082785050;
	Mon, 28 Feb 2022 13:13:05 -0800 (PST)
Received: from [192.168.2.27] (85-70-151-113.rcd.o2.cz. [85.70.151.113])
	by smtp.gmail.com with ESMTPSA id
	g11-20020a170906538b00b006ae38eb0561sm4677545ejo.195.2022.02.28.13.13.03
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Mon, 28 Feb 2022 13:13:04 -0800 (PST)
Message-ID: <91fe9f87-54d7-4140-4d1a-eac8e2081a7c@gmail.com>
Date: Mon, 28 Feb 2022 22:13:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.6.1
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Kyle Sanderson <kyle.leet@gmail.com>
References: <CACsaVZ+mt3CfdXV0_yJh7d50tRcGcRZ12j3n6-hoX2cz3+njsg@mail.gmail.com>
	<20220219210354.GF59715@dread.disaster.area>
	<CACsaVZ+LZUebtsGuiKhNV_No8fNLTv5kJywFKOigieB1cZcKUw@mail.gmail.com>
	<YhN76/ONC9qgIKQc@silpixa00400314>
	<CACsaVZJFane88cXxG_E1VkcMcJm8YVN+GDqQ2+tRYNpCf+m8zA@mail.gmail.com>
	<CAHk-=whVT2GcwiJM8m-XzgJj8CjytTHi_pmgmOnSpzvGWzZM1A@mail.gmail.com>
From: Milan Broz <gmazyland@gmail.com>
In-Reply-To: <CAHk-=whVT2GcwiJM8m-XzgJj8CjytTHi_pmgmOnSpzvGWzZM1A@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-loop: dm-devel@redhat.com
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Greg KH <gregkh@linuxfoundation.org>,
	Dave Chinner <david@fromorbit.com>, qat-linux@intel.com,
	Linux-Kernal <linux-kernel@vger.kernel.org>,
	linux-xfs <linux-xfs@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [dm-devel] Intel QAT on A2SDi-8C-HLN4F causes massive data
 corruption with dm-crypt + xfs
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 28/02/2022 20:25, Linus Torvalds wrote:
> On Mon, Feb 28, 2022 at 12:18 AM Kyle Sanderson <kyle.leet@gmail.com> wrote:
>>
>> Makes sense - this kernel driver has been destroying users for many
>> years. I'm disappointed that this critical bricking failure isn't
>> searchable for others.
> 
> It does sound like we should just disable that driver entirely until
> it is fixed.
> 
> Or at least the configuration that can cause problems, if there is
> some particular sub-case. Although from a cursory glance and the
> noises made in this thread, it looks like it's all of the 'qat_aeads'
> cases (since that uses qat_alg_aead_enc() which can return -EAGAIN),
> which effectively means that all of the QAT stuff.
> 
> So presumably CRYPTO_DEV_QAT should just be marked as
> 
>          depends on BROKEN || COMPILE_TEST
> 
> or similar?

Yes, please! Or at least disable it in stable for now.

During the last years, we had several reports of problems with this driver
for cryptsetup/LUKS (dm-crypt with qat driver; here it is skcipher, not aead, though).

The problem with the misunderstanding of the crypto API queue has been known
to authors for some time, at least since 2020
see https://lore.kernel.org/dm-devel/20200601160418.171851200@debian-a64.vm/
and it is apparently not fixed yet.

Thanks you,
Milan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


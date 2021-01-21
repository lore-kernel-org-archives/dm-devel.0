Return-Path: <SRS0=L0Bp=GY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE7E1C433E0
	for <dm-devel@archiver.kernel.org>; Thu, 21 Jan 2021 18:27:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2261E23A56
	for <dm-devel@archiver.kernel.org>; Thu, 21 Jan 2021 18:27:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2261E23A56
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-bqOuOOWxPZ-1Ur6c8okICQ-1; Thu, 21 Jan 2021 13:26:59 -0500
X-MC-Unique: bqOuOOWxPZ-1Ur6c8okICQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8EC8E423B8;
	Thu, 21 Jan 2021 18:26:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B9F460BF3;
	Thu, 21 Jan 2021 18:26:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AC5BA4A7C6;
	Thu, 21 Jan 2021 18:26:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10LINQns012148 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 21 Jan 2021 13:23:26 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E87EA2166B34; Thu, 21 Jan 2021 18:23:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E228E2166B32
	for <dm-devel@redhat.com>; Thu, 21 Jan 2021 18:23:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0E7AD858287
	for <dm-devel@redhat.com>; Thu, 21 Jan 2021 18:23:23 +0000 (UTC)
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com
	[209.85.218.48]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-113-eK78kCQzNUibozcvhdKXnQ-1; Thu, 21 Jan 2021 13:23:19 -0500
X-MC-Unique: eK78kCQzNUibozcvhdKXnQ-1
Received: by mail-ej1-f48.google.com with SMTP id a10so3980860ejg.10;
	Thu, 21 Jan 2021 10:23:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=gfKHhBWnllqV8aYIWdKy3xPP8GjYeDgbWRRf1nj3hU4=;
	b=OVzQfvInC0Cv7C2SPuO3DXSLgPYbX+H1tIoJxHFmsn54PxS1zy+pMZN0qz9P5/WjWZ
	IX3Fju8G+ldnbqQFVSF73WvXRvbozEhSvONGg9U44t9ZGypq7eGCdYQgG0ta3Wvn4CFS
	v5rRZ6mAzep4hSsiPZ2k+QKiBuHMzwqJ5pZ9FXC1o2DsKUYMmyuvsd/oBd+n79lOXoz/
	8KTxgwiXQm4GmqAkCO2f08RaxNGGO7vh6RRMR1TGqq7VYFN0ZSAHPQ0CH71fCQe/VsU5
	0ruJwusx3FQMD8YFOLGYpfAW1NOeZrjOKQDNYAEq59xOSKk8DBwlwrdEdJjnTtES2mou
	u+Tg==
X-Gm-Message-State: AOAM533U1pBm5gchbf0LfTUUp26bmBia+b7ah9yxu6CLWy5HBv1XdvTg
	ucMNCynUMSsBTN1cN37bLHWQalesB3XPkQ==
X-Google-Smtp-Source: ABdhPJxN19zAsqU9K27OZ22QxGfnOp2IjFjqXs8iYJ81v/hx0qvhnT+mheRm1N1MkjTRLuHyKGwotw==
X-Received: by 2002:a17:906:3999:: with SMTP id
	h25mr538652eje.146.1611253396600; 
	Thu, 21 Jan 2021 10:23:16 -0800 (PST)
Received: from [192.168.2.27] (39.35.broadband4.iol.cz. [85.71.35.39])
	by smtp.gmail.com with ESMTPSA id x9sm1144459eje.36.2021.01.21.10.23.15
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Thu, 21 Jan 2021 10:23:16 -0800 (PST)
To: Ard Biesheuvel <ardb@kernel.org>, Eric Biggers <ebiggers@kernel.org>,
	agk@redhat.com, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, 
	Mikulas Patocka <mpatocka@redhat.com>
References: <20210121130733.1649-1-ardb@kernel.org>
	<20210121130733.1649-6-ardb@kernel.org>
	<YAnCbnnFCQkyBpUA@sol.localdomain>
	<CAMj1kXEycOHSMQu2T1tdQrmapk+g0oQFDiWXDo0J0BKg4QgEuQ@mail.gmail.com>
From: Milan Broz <gmazyland@gmail.com>
Message-ID: <2f010ae0-b949-d9b8-c382-e02447b36166@gmail.com>
Date: Thu, 21 Jan 2021 19:23:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <CAMj1kXEycOHSMQu2T1tdQrmapk+g0oQFDiWXDo0J0BKg4QgEuQ@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [dm-devel] [PATCH 5/5] crypto: remove Salsa20 stream cipher
	algorithm
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 21/01/2021 19:09, Ard Biesheuvel wrote:
> On Thu, 21 Jan 2021 at 19:05, Eric Biggers <ebiggers@kernel.org> wrote:
>>
>> On Thu, Jan 21, 2021 at 02:07:33PM +0100, Ard Biesheuvel wrote:
>>> Salsa20 is not used anywhere in the kernel, is not suitable for disk
>>> encryption, and widely considered to have been superseded by ChaCha20.
>>> So let's remove it.
>>>
>>> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>>> ---
>>>  Documentation/admin-guide/device-mapper/dm-integrity.rst |    4 +-
>>>  crypto/Kconfig                                           |   12 -
>>>  crypto/Makefile                                          |    1 -
>>>  crypto/salsa20_generic.c                                 |  212 ----
>>>  crypto/tcrypt.c                                          |   11 +-
>>>  crypto/testmgr.c                                         |    6 -
>>>  crypto/testmgr.h                                         | 1162 --------------------
>>>  7 files changed, 3 insertions(+), 1405 deletions(-)
>>>
>>> diff --git a/Documentation/admin-guide/device-mapper/dm-integrity.rst b/Documentation/admin-guide/device-mapper/dm-integrity.rst
>>> index 4e6f504474ac..d56112e2e354 100644
>>> --- a/Documentation/admin-guide/device-mapper/dm-integrity.rst
>>> +++ b/Documentation/admin-guide/device-mapper/dm-integrity.rst
>>> @@ -143,8 +143,8 @@ recalculate
>>>  journal_crypt:algorithm(:key)        (the key is optional)
>>>       Encrypt the journal using given algorithm to make sure that the
>>>       attacker can't read the journal. You can use a block cipher here
>>> -     (such as "cbc(aes)") or a stream cipher (for example "chacha20",
>>> -     "salsa20" or "ctr(aes)").
>>> +     (such as "cbc(aes)") or a stream cipher (for example "chacha20"
>>> +     or "ctr(aes)").
>>
>> You should check with the dm-integrity maintainers how likely it is that people
>> are using salsa20 with dm-integrity.  It's possible that people are using it,
>> especially since the documentation says that dm-integrity can use a stream
>> cipher and specifically gives salsa20 as an example.
>>
> 
> Good point - cc'ed them now.

I would say - just remove it. I do not see any users, we do not even test this combination in userspace testsuite.
It is just an example in doc.

>From my POV these stream crypto ciphers should be never used there (but cc to Mikulas, it was his patch :-)

Milan

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


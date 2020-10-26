Return-Path: <SRS0=x48V=EB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E6C1C4363A
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 19:05:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5920B20720
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 19:05:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5920B20720
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-516-Yy_glhM6O1K7xBqpsZJdbw-1; Mon, 26 Oct 2020 15:05:01 -0400
X-MC-Unique: Yy_glhM6O1K7xBqpsZJdbw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AE28C186842B;
	Mon, 26 Oct 2020 19:04:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DEF0E10013C0;
	Mon, 26 Oct 2020 19:04:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 68496181A870;
	Mon, 26 Oct 2020 19:04:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09QJ4Nug013181 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 26 Oct 2020 15:04:24 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CD92D1140588; Mon, 26 Oct 2020 19:04:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C93F1114057A
	for <dm-devel@redhat.com>; Mon, 26 Oct 2020 19:04:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CB01E8726C9
	for <dm-devel@redhat.com>; Mon, 26 Oct 2020 19:04:20 +0000 (UTC)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
	[209.85.221.65]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-583-6ft02uObO_OE14iieqx3jw-1; Mon, 26 Oct 2020 15:04:16 -0400
X-MC-Unique: 6ft02uObO_OE14iieqx3jw-1
Received: by mail-wr1-f65.google.com with SMTP id t9so13920005wrq.11;
	Mon, 26 Oct 2020 12:04:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=Vv8QX0mXek+iVwa0PLmBZRi4t6g6SQqpZZ7vrfZ8LxM=;
	b=cKCx6RwQLDks5VJl/cVYedSjYYjnFpb7Ob0FYSwQAhIscSrw0f9qDnGytf3f2WZhB1
	D7t2TqxfCR4BTvJ/zj3xGFcR1FmIltBptgXA9ns+eZ/IC3bsH10XYJRvy/AWOn8kxnTf
	0w0vgaWpugAEceHM5RDk2c7JZNOk5oDiP7gL17hS55l+GciG3qjF5t2TLEOMMJhYcCfX
	RN+GW3h5thcUHWddFa7Gyo0a22IC7VeO5BJgIbrHIQqRLtxnt4mmpZfusKxray90F+Un
	vk6drD9NBWtc43nurLnA9IOKJfcaydRY4+ETmTRm04BppXHbC7r/i9d2OVq2D0siCgoe
	BBBA==
X-Gm-Message-State: AOAM531YC9NS5//a1dbPvgVNJFHUUYcQk8YKFzyS3q93ceNoKKEbuQND
	eJUrZUn4e7g7kXFfsF3hDyM=
X-Google-Smtp-Source: ABdhPJwxym73bt0NMXBaGG36oenzzsBNpxOTH9eF4YGx66Xb2iNsnijSuHGwKn8KQsb4LS1YGxys8w==
X-Received: by 2002:a5d:4010:: with SMTP id n16mr18635180wrp.97.1603739055074; 
	Mon, 26 Oct 2020 12:04:15 -0700 (PDT)
Received: from [192.168.2.28] (39.35.broadband4.iol.cz. [85.71.35.39])
	by smtp.gmail.com with ESMTPSA id
	t62sm22625877wmf.22.2020.10.26.12.04.13
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Mon, 26 Oct 2020 12:04:14 -0700 (PDT)
To: Eric Biggers <ebiggers@kernel.org>, Milan Broz <gmazyland@gmail.com>
References: <20201026130450.6947-1-gilad@benyossef.com>
	<20201026130450.6947-4-gilad@benyossef.com>
	<20201026175231.GG858@sol.localdomain>
	<d07b062c-1405-4d72-b907-1c4dfa97aecb@gmail.com>
	<20201026183936.GJ858@sol.localdomain>
From: Milan Broz <gmazyland@gmail.com>
Message-ID: <fd5e46ce-a4bf-8025-05ea-e20d35485446@gmail.com>
Date: Mon, 26 Oct 2020 20:04:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201026183936.GJ858@sol.localdomain>
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
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Mike Snitzer <snitzer@redhat.com>,
	Song Liu <song@kernel.org>, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	Gilad Ben-Yossef <gilad@benyossef.com>, dm-devel@redhat.com,
	linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Alasdair Kergon <agk@redhat.com>, Ofir Drang <ofir.drang@arm.com>
Subject: Re: [dm-devel] [PATCH 3/4] dm crypt: switch to EBOIV crypto API
	template
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
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On 26/10/2020 19:39, Eric Biggers wrote:
> On Mon, Oct 26, 2020 at 07:29:57PM +0100, Milan Broz wrote:
>> On 26/10/2020 18:52, Eric Biggers wrote:
>>> On Mon, Oct 26, 2020 at 03:04:46PM +0200, Gilad Ben-Yossef wrote:
>>>> Replace the explicit EBOIV handling in the dm-crypt driver with calls
>>>> into the crypto API, which now possesses the capability to perform
>>>> this processing within the crypto subsystem.
>>>>
>>>> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
>>>>
>>>> ---
>>>>  drivers/md/Kconfig    |  1 +
>>>>  drivers/md/dm-crypt.c | 61 ++++++++++++++-----------------------------
>>>>  2 files changed, 20 insertions(+), 42 deletions(-)
>>>>
>>>> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
>>>> index 30ba3573626c..ca6e56a72281 100644
>>>> --- a/drivers/md/Kconfig
>>>> +++ b/drivers/md/Kconfig
>>>> @@ -273,6 +273,7 @@ config DM_CRYPT
>>>>  	select CRYPTO
>>>>  	select CRYPTO_CBC
>>>>  	select CRYPTO_ESSIV
>>>> +	select CRYPTO_EBOIV
>>>>  	help
>>>>  	  This device-mapper target allows you to create a device that
>>>>  	  transparently encrypts the data on it. You'll need to activate
>>>
>>> Can CRYPTO_EBOIV please not be selected by default?  If someone really wants
>>> Bitlocker compatibility support, they can select this option themselves.
>>
>> Please no! Until this move of IV to crypto API, we can rely on
>> support in dm-crypt (if it is not supported, it is just a very old kernel).
>> (Actually, this was the first thing I checked in this patchset - if it is
>> unconditionally enabled for compatibility once dmcrypt is selected.)
>>
>> People already use removable devices with BitLocker.
>> It was the whole point that it works out-of-the-box without enabling anything.
>>
>> If you insist on this to be optional, please better keep this IV inside dmcrypt.
>> (EBOIV has no other use than for disk encryption anyway.)
>>
>> Or maybe another option would be to introduce option under dm-crypt Kconfig that
>> defaults to enabled (like support for foreign/legacy disk encryption schemes) and that
>> selects these IVs/modes.
>> But requiring some random switch in crypto API will only confuse users.
> 
> CONFIG_DM_CRYPT can either select every weird combination of algorithms anyone
> can ever be using, or it can select some defaults and require any other needed
> algorithms to be explicitly selected.
> 
> In reality, dm-crypt has never even selected any particular block ciphers, even
> AES.  Nor has it ever selected XTS.  So it's actually always made users (or
> kernel distributors) explicitly select algorithms.  Why the Bitlocker support
> suddenly different?
> 
> I'd think a lot of dm-crypt users don't want to bloat their kernels with random
> legacy algorithms.

Yes, but IV is in reality not a cryptographic algorithm, it is kind-of a configuration
"option" of sector encryption mode here.

We had all of disk-IV inside dmcrypt before - but once it is partially moved into crypto API
(ESSIV, EBOIV for now), it becomes much more complicated for user to select what he needs.

I think we have no way to check that IV is available from userspace - it
will report the same error as if block cipher is not available, not helping user much
with the error.

But then I also think we should add abstract dm-crypt options here (Legacy TrueCrypt modes,
Bitlocker modes) that will select these crypto API configuration switches.
Otherwise it will be only a complicated matrix of crypto API options...

Milan

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20306C388F9
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 18:30:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 64A2E2076A
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 18:30:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 64A2E2076A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-KRW5Yh43Ory7XVUG8zgO3Q-1; Mon, 26 Oct 2020 14:30:18 -0400
X-MC-Unique: KRW5Yh43Ory7XVUG8zgO3Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B96E7A0C04;
	Mon, 26 Oct 2020 18:30:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5CB085B4A4;
	Mon, 26 Oct 2020 18:30:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BB48E181A870;
	Mon, 26 Oct 2020 18:30:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09QIUAQI007633 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 26 Oct 2020 14:30:10 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 2FDEA82D07; Mon, 26 Oct 2020 18:30:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2771D82D0D
	for <dm-devel@redhat.com>; Mon, 26 Oct 2020 18:30:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 972A7811E90
	for <dm-devel@redhat.com>; Mon, 26 Oct 2020 18:30:06 +0000 (UTC)
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com
	[209.85.128.65]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-537-VFvqdd-gO32so_m2zEuLZw-1; Mon, 26 Oct 2020 14:30:01 -0400
X-MC-Unique: VFvqdd-gO32so_m2zEuLZw-1
Received: by mail-wm1-f65.google.com with SMTP id 13so12663794wmf.0;
	Mon, 26 Oct 2020 11:30:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=Uvxk0V+v5R+Ui18EWs/4gGZzPd6uaBwxyhilQrUITXg=;
	b=ULYs6kwycRrs1lwR3R++ARBqGyqiHLUOt5EjULWCXKerV/hHe+y3a/5o5hKUhMYZCO
	Pr4Fizjxli99kmYKwdxYA2PLpf8BLLPCPEUyMP+btbh9o6rms1ftCM9BpoCtbJZEdH9B
	mjNI8Ly3CRp0YvqT4kd3sdwck2eEhTFgBcOEeSaKLWhyL62FNy8YytB6VRJtT0KfKk9K
	nVAoYwDchC5DM5bjIokK1kgxcupC5SLYEe/uG6Y2e9vznJ7il/rPCr9GTp5y8LwUS+5T
	t+R9qWAcTK6SlKu1Rf03/+BU70mc3am/OCa97g/Xw4qtKO11wr0HTRXXJM32umltnMxO
	+Gjg==
X-Gm-Message-State: AOAM5303KldvoxBzJ3BLZmwivJSXune3svx4pXpvEyL5m/O/QQdDaDBK
	Dx041Jitb0BrOPRVzd9LsYY=
X-Google-Smtp-Source: ABdhPJxGuvImDDTPNUyAg2ANEUotzgD+NbaqgYewNtg3QdjYtiYNovB0ZP9faDoV/YdGSo52APdArQ==
X-Received: by 2002:a1c:9c41:: with SMTP id f62mr17094373wme.23.1603737000340; 
	Mon, 26 Oct 2020 11:30:00 -0700 (PDT)
Received: from [192.168.2.28] (39.35.broadband4.iol.cz. [85.71.35.39])
	by smtp.gmail.com with ESMTPSA id
	j17sm22999314wrw.68.2020.10.26.11.29.58
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Mon, 26 Oct 2020 11:29:59 -0700 (PDT)
To: Eric Biggers <ebiggers@kernel.org>, Gilad Ben-Yossef <gilad@benyossef.com>
References: <20201026130450.6947-1-gilad@benyossef.com>
	<20201026130450.6947-4-gilad@benyossef.com>
	<20201026175231.GG858@sol.localdomain>
From: Milan Broz <gmazyland@gmail.com>
Message-ID: <d07b062c-1405-4d72-b907-1c4dfa97aecb@gmail.com>
Date: Mon, 26 Oct 2020 19:29:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201026175231.GG858@sol.localdomain>
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
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Mike Snitzer <snitzer@redhat.com>,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 26/10/2020 18:52, Eric Biggers wrote:
> On Mon, Oct 26, 2020 at 03:04:46PM +0200, Gilad Ben-Yossef wrote:
>> Replace the explicit EBOIV handling in the dm-crypt driver with calls
>> into the crypto API, which now possesses the capability to perform
>> this processing within the crypto subsystem.
>>
>> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
>>
>> ---
>>  drivers/md/Kconfig    |  1 +
>>  drivers/md/dm-crypt.c | 61 ++++++++++++++-----------------------------
>>  2 files changed, 20 insertions(+), 42 deletions(-)
>>
>> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
>> index 30ba3573626c..ca6e56a72281 100644
>> --- a/drivers/md/Kconfig
>> +++ b/drivers/md/Kconfig
>> @@ -273,6 +273,7 @@ config DM_CRYPT
>>  	select CRYPTO
>>  	select CRYPTO_CBC
>>  	select CRYPTO_ESSIV
>> +	select CRYPTO_EBOIV
>>  	help
>>  	  This device-mapper target allows you to create a device that
>>  	  transparently encrypts the data on it. You'll need to activate
> 
> Can CRYPTO_EBOIV please not be selected by default?  If someone really wants
> Bitlocker compatibility support, they can select this option themselves.

Please no! Until this move of IV to crypto API, we can rely on
support in dm-crypt (if it is not supported, it is just a very old kernel).
(Actually, this was the first thing I checked in this patchset - if it is
unconditionally enabled for compatibility once dmcrypt is selected.)

People already use removable devices with BitLocker.
It was the whole point that it works out-of-the-box without enabling anything.

If you insist on this to be optional, please better keep this IV inside dmcrypt.
(EBOIV has no other use than for disk encryption anyway.)

Or maybe another option would be to introduce option under dm-crypt Kconfig that
defaults to enabled (like support for foreign/legacy disk encryption schemes) and that
selects these IVs/modes.
But requiring some random switch in crypto API will only confuse users.

Milan

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


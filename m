Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F272C433F5
	for <dm-devel@archiver.kernel.org>; Sat, 15 Jan 2022 09:22:47 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-OB4GNM8BM1CjGsag64E4mA-1; Sat, 15 Jan 2022 04:22:45 -0500
X-MC-Unique: OB4GNM8BM1CjGsag64E4mA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 453F4104;
	Sat, 15 Jan 2022 09:22:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9077A60C40;
	Sat, 15 Jan 2022 09:22:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F3B1E1809CB8;
	Sat, 15 Jan 2022 09:22:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20F9MVcF013920 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 15 Jan 2022 04:22:31 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7F38340CFD37; Sat, 15 Jan 2022 09:22:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 795D840CFD0F
	for <dm-devel@redhat.com>; Sat, 15 Jan 2022 09:22:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5F001185A794
	for <dm-devel@redhat.com>; Sat, 15 Jan 2022 09:22:31 +0000 (UTC)
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com
	[209.85.208.45]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-492-UvOf5I2mOSW6pboFT-7-6Q-1; Sat, 15 Jan 2022 04:22:29 -0500
X-MC-Unique: UvOf5I2mOSW6pboFT-7-6Q-1
Received: by mail-ed1-f45.google.com with SMTP id 30so43251619edv.3
	for <dm-devel@redhat.com>; Sat, 15 Jan 2022 01:22:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
	:content-language:to:cc:references:from:in-reply-to
	:content-transfer-encoding;
	bh=CoiA7DkZMSyjwEipOItTcy9FleGXgxmIP0bTHGNthUo=;
	b=acwMa/A54ApKQTZ0DsBxnWamcM5Jh0e81vHo3U/33x6Vg8XbE2Ctza9JZNZCI8ORut
	FNmThlEk6kI5ery28yONy2N3hu0mjXH0m5Io1h/pM/mlYLMHeIV/Huu/Btp2b9VHxt4D
	7Cd2NfiiEVXT4SUhXs8JNOmMD/tYf5W7YWrT9J2/5Q7Wluk/L0JfHXYrnihDhGBijuNg
	D3lwGDIOC9PENQIppzf73gcSo8pTVe6Sza6y8nuI3lDwIwtZ6cNNOe2olnP3w/hFqxb0
	kSfy8tGw2tKIjtP+pjXPGsrHJYnJw25pW5pKQr7ZEmlLtLteJJJdBk7s9b3uC1EPrhsI
	9Nww==
X-Gm-Message-State: AOAM530Z/ptvCkph8NwArts+qGSvrr9KvVy5M//T13qnIB06NGhuyFaV
	rOpSNAcwJleSJzKV3wdFh+6Nq9UEQ/0=
X-Google-Smtp-Source: ABdhPJzrbyDB1Y9yGkgJu78yVv2uibW+MMJ5KPBbbVGvfunLuMUctg6Aprfcy5F++DP6atNmgb5LIg==
X-Received: by 2002:a50:a6ce:: with SMTP id f14mr12215934edc.105.1642238548329;
	Sat, 15 Jan 2022 01:22:28 -0800 (PST)
Received: from [192.168.8.101] (89-24-44-210.nat.epc.tmcz.cz. [89.24.44.210])
	by smtp.gmail.com with ESMTPSA id
	qf18sm2412680ejc.124.2022.01.15.01.22.27
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Sat, 15 Jan 2022 01:22:27 -0800 (PST)
Message-ID: <139878d0-d1bb-02d9-30c2-9334ffb5b3b3@gmail.com>
Date: Sat, 15 Jan 2022 10:22:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.5.0
To: Eric Biggers <ebiggers@kernel.org>
References: <1642097341-6521-1-git-send-email-israelr@nvidia.com>
	<9ef95bbc-4eee-4c00-f199-0daa3cdd03ed@gmail.com>
	<YeH4yhy1FFGooOrR@sol.localdomain>
From: Milan Broz <gmazyland@gmail.com>
In-Reply-To: <YeH4yhy1FFGooOrR@sol.localdomain>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: Israel Rukshin <israelr@nvidia.com>, Max Gurtovoy <mgurtovoy@nvidia.com>,
	dm-devel <dm-devel@redhat.com>, Nitzan Carmi <nitzanc@nvidia.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 14/01/2022 23:27, Eric Biggers wrote:
> On Fri, Jan 14, 2022 at 09:51:20PM +0100, Milan Broz wrote:
>> On 13/01/2022 19:09, Israel Rukshin wrote:
>>> Hi,
>>>
>>> I am working to add support for inline encryption/decryption
>>> at storage protocols like nvmf over RDMA. The HW that I am
>>> working with is ConnecX-6 Dx, which supports inline crypto
>>> and can send the data on the fabric at the same time.
>>
>> This idea comes from time to time, and it makes dm-crypt bloated,
>> and mainly it moves responsibility for encryption to block layer
>> crypto.
>> It adds two completely different sector encryption paths there.
>>
>> Also, see my comments here (for similar patches)
>> https://lore.kernel.org/dm-devel/c94d425a-bca4-8a8b-47bf-451239d29ebd@gmail.com/
>>
>> I think dm-crypt should stay as SW crypto only (using kernel crypto API,
>> so HW acceleration is done through crypto drivers there).
>>
>> A cleaner solution is to write a much simpler new dm-crypt-inline target,
>> which will implement only inline encryption.
>> (And userspace can decide which target to use.)
>> Code should be just an extension to the dm-linear target, most
>> of dm-crypt complexity is not needed here.
>>
>> Also, please think about configuration - how do you want to configure it?
>>
>> Just my opinion, it is, of course, up to DM maintainer if he takes such patches.
>>
> 
> IMO, adding inline encryption support to dm-crypt would be fine.  Normally,
> blk-crypto is just an alternate implementation of encryption/decryption.  I'm
> not sure that a separate dm target is warranted just because of a different
> implementation, as opposed to different *behavior*.  (Support for wrapped keys
> does complicate things a bit, as they do change behavior.)  But, I'd also be
> fine with a separate dm target if the dm maintainers prefer that route.

I would expect some issues with FIPS people here (currently, it is handled
by enabling various crypto API drivers) about crypto boundaries and such stuff.
But it is up to the corporate people, not me.

Sadly, nobody did try to push some device-mapper functionality into the block layer.
Then inline encryption can be just a block device configuration or whatever....
(discussed in 2010 or so... https://lwn.net/Articles/400589/)
</sigh>

I would prefer to separate SW FDE (dm-crypt, as it is) and a target that delegates
encryption to the block layer (inline encryption).
But it is just cryptsetup's maintainer view, as we have already too complex
detection which features can be enabled on various kernel configs, etc.

> Note that in the Android Common Kernels, there is already a dm target called
> "dm-default-key" which uses dm-crypt compatible syntax but uses blk-crypto
> (inline encryption) rather than the crypto API:
> https://android.googlesource.com/kernel/common/+/refs/heads/android-mainline/drivers/md/dm-default-key.c

Any plans to submit this to mainline? Or it is just too controversial?

> 
> It differs slightly from what is being proposed here in that dm-default-key's
> purpose is to implement filesystem "metadata encryption", so it has logic to
> skip encrypting blocks that have their encryption controlled at the filesystem
> level due to being part of an encrypted file's contents.  I expect that logic
> would be unacceptable upstream, as it's a layering violation.  (The long-term
> plan is to handle metadata encryption entirely at the filesystem level instead.)

Well, I wish that we have strong authenticated encryption in filesystem even for
metadata, where it fits better in the fist place....
But fscrypt is still not here (or am I mistaken?)

Milan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


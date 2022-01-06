Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10A3FC433EF
	for <dm-devel@archiver.kernel.org>; Thu,  6 Jan 2022 16:25:51 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-350-TiFv3PSXPSOGUIS6d0yPzw-1; Thu, 06 Jan 2022 11:25:47 -0500
X-MC-Unique: TiFv3PSXPSOGUIS6d0yPzw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B7738015CD;
	Thu,  6 Jan 2022 16:25:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0816C838D0;
	Thu,  6 Jan 2022 16:25:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 789744BB7C;
	Thu,  6 Jan 2022 16:25:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 206GPd82004313 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 6 Jan 2022 11:25:39 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 49F9840F9D69; Thu,  6 Jan 2022 16:25:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4393F40F9D68
	for <dm-devel@redhat.com>; Thu,  6 Jan 2022 16:25:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2A50A1064FB0
	for <dm-devel@redhat.com>; Thu,  6 Jan 2022 16:25:39 +0000 (UTC)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com
	[209.85.221.45]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-45-tpjQA43zOXSCSV5aCZ_01Q-1; Thu, 06 Jan 2022 11:25:37 -0500
X-MC-Unique: tpjQA43zOXSCSV5aCZ_01Q-1
Received: by mail-wr1-f45.google.com with SMTP id l10so5828979wrh.7
	for <dm-devel@redhat.com>; Thu, 06 Jan 2022 08:25:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
	:content-language:to:cc:references:from:in-reply-to
	:content-transfer-encoding;
	bh=FHJg4hW/f88/Sk6mRnWtxmcYfEUH34oJVmaSAFiTGEY=;
	b=VTdUufavlxQfBpdHQKhIbvKre/8p7L+iYBCKhatu9QfAIoBUvrRtCSQUiydWzOTEe7
	sifwvVrk4iU9bZTEfD2ds5VALwl5h/Yv5Y6LSpMBSADUoIoz/HAiALXBvv5FWeCUAyVf
	S1TaJPlh4K9QhZRcNFtl/2Q45Kyia9SJf8nzcwbKUxyObtwgAdLqlXoZReb6lPqrB5Do
	IV40P+i5N4k03xOAQerNxppQtDqDEAQQwhFIZQMxbfSzv52YAqVN6JBlRVBtHtzv/seI
	wK0erbkEn+plSM2XB+kghJUlRnPlhKy18e3piC02Yf+abr6vHRJ86/mjHPPTyUwPf8VL
	eyBg==
X-Gm-Message-State: AOAM531eLk2w5k9PsGO7O9EGcaC+h+K87h+hTEXErN+vYd++/NhFTsA5
	dGZ+VjNCBisKftbFTvNY+ig=
X-Google-Smtp-Source: ABdhPJyImdMn57LWiiLC1zVWGweD/+JciRzkrHvu3/CDh0w1sIxu+Y9qdd/8NBYAS+HgC9+P9N+BsQ==
X-Received: by 2002:a5d:698c:: with SMTP id g12mr2589709wru.69.1641486336534; 
	Thu, 06 Jan 2022 08:25:36 -0800 (PST)
Received: from [172.22.36.87] (redhat-nat.vtp.fi.muni.cz. [78.128.215.6])
	by smtp.gmail.com with ESMTPSA id u3sm3105044wrs.0.2022.01.06.08.25.34
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Thu, 06 Jan 2022 08:25:35 -0800 (PST)
Message-ID: <120368dc-e337-9176-936c-4db2a8bf710e@gmail.com>
Date: Thu, 6 Jan 2022 17:25:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.4.1
To: "Bae, Chang Seok" <chang.seok.bae@intel.com>
References: <20211214005212.20588-1-chang.seok.bae@intel.com>
	<YbqRseO+TtuGQk5x@sol.localdomain>
	<4101B942-6327-49A9-BE8B-9E51F0427F50@intel.com>
	<YdZ5HrOKEffBrQIm@sol.localdomain>
From: Milan Broz <gmazyland@gmail.com>
In-Reply-To: <YdZ5HrOKEffBrQIm@sol.localdomain>
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
Cc: "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	the arch/x86 maintainers <x86@kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>, "Krishnakumar,
	Lalithambika" <lalithambika.krishnakumar@intel.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	"Lutomirski, Andy" <luto@kernel.org>, "Williams,
	Dan J" <dan.j.williams@intel.com>, Borislav Petkov <bp@suse.de>,
	Thomas Gleixner <tglx@linutronix.de>, "Gairuboyina,
	Charishma1" <charishma1.gairuboyina@intel.com>, "Dwarakanath,
	Kumar N" <kumar.n.dwarakanath@intel.com>
Subject: Re: [dm-devel] [PATCH v4 00/13] x86: Support Key Locker
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

On 06/01/2022 06:07, Eric Biggers wrote:
> On Wed, Jan 05, 2022 at 09:55:17PM +0000, Bae, Chang Seok wrote:
>>>> +-----------+---------------+---------------+
>>>> | Cipher    |   Encryption  | Decryption    |
>>>> | (AES-KL)  |    (MiB/s)    | (MiB/s)       |
>>>> +-----------+---------------+---------------+
>>>> | AES-CBC   |     505.3     |   2097.8      |
>>>> | AES-XTS   |     1130      |   696.4       |
>>>> +-----------+-------------------------------+
>>>
>>> Why is AES-XTS decryption so much slower than AES-XTS encryption?  They should
>>> be about the same.
>>
>> Analyzing and understanding this with specific hardware implementation takes
>> time for us. Will come back and update you when we have anything to share here.
> 
> Note that for disk encryption, decryption performance is usually more important
> than encryption performance.  So your performance results are strange.

If the test results are from "cryptsetup benchmark", it just run benchmark
through userspace crypto API (AF_ALG) - no dm-crypt is involved at all.

Proper test with dm-crypt should be run to get some numbers too.

(But the test results are really strange... there is no reason
decryption should be slower for XTS.)

Also you mention that
> Bare metal disk encryption is the only use case intended by these patches.
> Userspace usage is not supported because there is no ABI provided to
> communicate and coordinate wrapping-key restore failures to userspace.

The cryptsetup benchmark is userspace use (just with kernel netlink
access to kernel crypto). So I am not sure if these number are so important.

Milan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


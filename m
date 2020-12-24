Return-Path: <SRS0=pEeb=F4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C22F6C433DB
	for <dm-devel@archiver.kernel.org>; Thu, 24 Dec 2020 09:33:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3FDCD224B1
	for <dm-devel@archiver.kernel.org>; Thu, 24 Dec 2020 09:33:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3FDCD224B1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-60EuvVw2Nce7FYzAR2FGUA-1; Thu, 24 Dec 2020 04:33:46 -0500
X-MC-Unique: 60EuvVw2Nce7FYzAR2FGUA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3588B9CC09;
	Thu, 24 Dec 2020 09:33:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 85885100164C;
	Thu, 24 Dec 2020 09:33:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EDA0D180954D;
	Thu, 24 Dec 2020 09:33:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BO9XXos010882 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 24 Dec 2020 04:33:33 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 46CA52166B29; Thu, 24 Dec 2020 09:33:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 41C642166B2B
	for <dm-devel@redhat.com>; Thu, 24 Dec 2020 09:33:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C3F5F186E120
	for <dm-devel@redhat.com>; Thu, 24 Dec 2020 09:33:30 +0000 (UTC)
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com
	[209.85.128.53]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-23-9-06obQmOK6NX3tDPUEPdg-1; Thu, 24 Dec 2020 04:33:28 -0500
X-MC-Unique: 9-06obQmOK6NX3tDPUEPdg-1
Received: by mail-wm1-f53.google.com with SMTP id e25so1178578wme.0;
	Thu, 24 Dec 2020 01:33:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=4XfVxxDWXarYzvcm/E8/0oqF+lQgHrMQTnHY7kOdbxU=;
	b=Xvkio/KRWaL5TfBVMCqXoD54o4xJ3ccu8Prqg77hODFksTJVR/6cA7oeH54Xb66+6h
	FvcJOWiHVtVaSNXzb/e/WhLvA9GjYUxXmjNdnmIrqshdv/IGYRmvkG41AYRH/cpJrW2l
	2HTRFX1zf8P7/I0e1fVy0RIQnHwepnSqsPMw9qiYMaEaZnCSDS9M03Jdpg4vRwefxT0a
	rD7606S8i4SFZVk0qi750hf1ZP2WuFfAUO7Ka9Q3DmwJY3JhcMIcQDipwYKFQAkwQ9GW
	dU2GC2kjKGJAuKNnyn6Kncow9rBtuZHzRjDXTP65QU3VKqJB+nTbjx9aCEoiu0QsEjlE
	MLkQ==
X-Gm-Message-State: AOAM531+i1gcjpRzIV567utYX7qD4thPOf0U2DpIxlKYX0F1iBvbACRN
	lLM+ryooNzgbcgcwZNRdw0cxULjz7OI=
X-Google-Smtp-Source: ABdhPJw/j685Np+wpQh3jLyvME3Px5fOmP5hnCdjENEs90b/wPb1iw5PSrmNaSOdWcaI4p5yUr8o4Q==
X-Received: by 2002:a7b:c052:: with SMTP id u18mr2443719wmc.139.1608802406782; 
	Thu, 24 Dec 2020 01:33:26 -0800 (PST)
Received: from [192.168.2.27] (39.35.broadband4.iol.cz. [85.71.35.39])
	by smtp.gmail.com with ESMTPSA id
	o17sm39463525wrg.32.2020.12.24.01.33.25
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Thu, 24 Dec 2020 01:33:26 -0800 (PST)
To: Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org
References: <20201223223841.11311-1-ardb@kernel.org>
From: Milan Broz <gmazyland@gmail.com>
Message-ID: <dff974aa-4dcf-9f4a-83db-eb4883aa3376@gmail.com>
Date: Thu, 24 Dec 2020 10:33:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201223223841.11311-1-ardb@kernel.org>
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
Cc: Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com,
	Mike Snitzer <snitzer@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, Megha Dey <megha.dey@intel.com>
Subject: Re: [dm-devel] [RFC PATCH 00/10] crypto: x86 - remove XTS and CTR
 glue helper code
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

On 23/12/2020 23:38, Ard Biesheuvel wrote:
> After applying my performance fixes for AES-NI in XTS mode, the only
> remaining users of the x86 glue helper module are the niche algorithms
> camellia, cast6, serpent and twofish.
> 
> It is not clear from the history why all these different versions of these
> algorithms in XTS and CTR modes were added in the first place: the only
> in-kernel references that seem to exist are to cbc(serpent), cbc(camellia)
> and cbc(twofish) in the IPsec stack. The XTS spec only mentions AES, and
> CTR modes don't seem to be widely used either.

FYI: Serpent, Camellia and Twofish are used in TrueCrypt/VeraCrypt implementation;
cryptsetup and I perhaps even VeraCrypt itself tries to use native dm-crypt mapping.
(They also added Russian GOST Kuznyechik with XTS, but this is not in mainline,
but Debian packages it as gost-crypto-dkms).

Serpent and Twofish can be also used with LRW and CBC modes (for old containers only).

Cryptsetup uses crypto userspace API to decrypt the key from header, then it configures
dm-crypt mapping for data. We need both use and in-kernel API here.

For reference, see this table (my independent implementation of TrueCrypt/VeraCrypt modes,
it should be complete history though):
https://gitlab.com/cryptsetup/cryptsetup/-/blob/master/lib/tcrypt/tcrypt.c#L77

If the above still works (I would really like to have way to open old containers)
it is ok to do whatever you want to change here :-)

I have no info that CTR is used anywhere related to dm-crypt
(IIRC it can be tricked to be used there but it does not make any sense).

Thanks,
Milan

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


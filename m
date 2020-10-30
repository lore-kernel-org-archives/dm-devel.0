Return-Path: <SRS0=GC9A=EF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E089CC4363A
	for <dm-devel@archiver.kernel.org>; Fri, 30 Oct 2020 10:33:55 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2D53020704
	for <dm-devel@archiver.kernel.org>; Fri, 30 Oct 2020 10:33:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2D53020704
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-oJq65faBNpaqoIsrB7QFvQ-1; Fri, 30 Oct 2020 06:33:49 -0400
X-MC-Unique: oJq65faBNpaqoIsrB7QFvQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 00BD0805F03;
	Fri, 30 Oct 2020 10:33:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0DA465B4CE;
	Fri, 30 Oct 2020 10:33:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E8519181A06B;
	Fri, 30 Oct 2020 10:33:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09UAXcWr002442 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 30 Oct 2020 06:33:39 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C8885F49D8; Fri, 30 Oct 2020 10:33:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C3143F4EC3
	for <dm-devel@redhat.com>; Fri, 30 Oct 2020 10:33:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D937811E76
	for <dm-devel@redhat.com>; Fri, 30 Oct 2020 10:33:36 +0000 (UTC)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
	[209.85.221.67]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-508--ya66brMPwi_BnwXQMn9OA-1; Fri, 30 Oct 2020 06:33:33 -0400
X-MC-Unique: -ya66brMPwi_BnwXQMn9OA-1
Received: by mail-wr1-f67.google.com with SMTP id w1so5892563wrm.4;
	Fri, 30 Oct 2020 03:33:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=cilZ+udfA8JnGi8jWqanKiLiFvzSWTw4Z1ASaR4ui20=;
	b=aXculboFFJqLMFnvxT8mJLHbmvblKDP2JCxFgFXpfMVIAw3wqGQiNppwGewDLWZtHq
	mSs+SHS43d5gWscgzKJbPbhPcdNRy552fVGKWo3jokF0kCUw74fM/V3GzT68sMZ8evzv
	BcZttgtZdSxh4VDjtuR91B2MRrQuZKT030PyqU5dlbEQKvewSwFoJOTqRc+f9sF7VmMr
	qkIkuLYZWWvEqk/wmlo4ytav9kq9H823tHfzKuKwRAGvQdPtIyIkmRr+s88ta5fb88QK
	LxW0uhJXbOTHg2BFj5FfYPegMDXCTYuXP8giZ5jHuZ5T/qQkQ1ytzHHtEcHokK02F926
	NHFQ==
X-Gm-Message-State: AOAM530pSGRb6OIuzByRE2GCHtkdH47Euj+VWO+cQrEGOAKbTmqHWQAP
	r1V2eD3O1mEM6YQW1hC2WgU=
X-Google-Smtp-Source: ABdhPJwOA2WNkf2VuwSDmM8C2HAwpPF2FvWE7mqh3rpIOcZnF4uB8wWXxzxHmZnUkkMa5u/9iJH5oQ==
X-Received: by 2002:a5d:4612:: with SMTP id t18mr2205623wrq.307.1604054012411; 
	Fri, 30 Oct 2020 03:33:32 -0700 (PDT)
Received: from [192.168.2.27] (39.35.broadband4.iol.cz. [85.71.35.39])
	by smtp.gmail.com with ESMTPSA id
	d20sm10565162wra.38.2020.10.30.03.33.31
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Fri, 30 Oct 2020 03:33:31 -0700 (PDT)
To: Gilad Ben-Yossef <gilad@benyossef.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	dm-devel@redhat.com
References: <20201029100546.28686-1-gilad@benyossef.com>
	<20201029100546.28686-2-gilad@benyossef.com>
From: Milan Broz <gmazyland@gmail.com>
Message-ID: <3a4804a5-5d5c-1216-1503-c241cc24f3c2@gmail.com>
Date: Fri, 30 Oct 2020 11:33:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201029100546.28686-2-gilad@benyossef.com>
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
Cc: Eric Biggers <ebiggers@kernel.org>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>
Subject: Re: [dm-devel] [PATCH v3 1/4] crypto: add eboiv as a crypto API
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

On 29/10/2020 11:05, Gilad Ben-Yossef wrote:
>  
> +config CRYPTO_EBOIV
> +	tristate "EBOIV support for block encryption"
> +	default DM_CRYPT
> +	select CRYPTO_CBC
> +	help
> +	  Encrypted byte-offset initialization vector (EBOIV) is an IV
> +	  generation method that is used in some cases by dm-crypt for
> +	  supporting the BitLocker volume encryption used by Windows 8
> +	  and onwards as a backwards compatible version in lieu of XTS
> +	  support.
> +
> +	  It uses the block encryption key as the symmetric key for a
> +	  block encryption pass applied to the sector offset of the block.
> +	  Additional details can be found at
> +	  https://www.jedec.org/sites/default/files/docs/JESD223C.pdf

This page is not available. Are you sure this is the proper documentation?

I think the only description we used (for dm-crypt) was original Ferguson's Bitlocker doc:
https://download.microsoft.com/download/0/2/3/0238acaf-d3bf-4a6d-b3d6-0a0be4bbb36e/bitlockercipher200608.pdf

IIRC EBOIV was a shortcut I added to dm-crypt because we found no official terminology for this IV.
And after lunchtime, nobody invented anything better, so it stayed as it is now :-)

Milan

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


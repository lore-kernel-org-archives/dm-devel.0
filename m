Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 548E1C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 29 Jun 2022 19:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656531498;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=aRfMV/6Ple86cQrxHaJJHMXkCm9XDn0SQMAb9y2z6JU=;
	b=fILfFBCKGQMfLCXu7gBlBvYiuXht7Hp4gxPt3nBcTTGGcf3l37z38qKim8NL8pMpPjysUU
	uEVu2h/NcXTO4GlFKYt9W9t+I6qDeDo3BGJNK3xDlHUt1LIlPciZKvGamkUxSOnyr+jCxz
	h3KuC8pSdHavYP/PJfrqmrYXCo5XS24=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-275-27BmceIFN9a7nGaq_tnB4A-1; Wed, 29 Jun 2022 15:38:16 -0400
X-MC-Unique: 27BmceIFN9a7nGaq_tnB4A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0217B802C17;
	Wed, 29 Jun 2022 19:38:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A15ED40EC002;
	Wed, 29 Jun 2022 19:38:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4425B194705B;
	Wed, 29 Jun 2022 19:38:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 85F7E1947058
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Jun 2022 19:38:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 51C032166B29; Wed, 29 Jun 2022 19:38:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D8692166B26
 for <dm-devel@redhat.com>; Wed, 29 Jun 2022 19:38:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3207C85A581
 for <dm-devel@redhat.com>; Wed, 29 Jun 2022 19:38:07 +0000 (UTC)
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com
 [209.85.210.179]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-91-vxf1ZO4IOaSufpfOuJSvUw-1; Wed, 29 Jun 2022 15:38:03 -0400
X-MC-Unique: vxf1ZO4IOaSufpfOuJSvUw-1
Received: by mail-pf1-f179.google.com with SMTP id n12so16101599pfq.0;
 Wed, 29 Jun 2022 12:38:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=SowtfbQg4jm5t+ej3pjlmqBbS1c74VzCN39P2BqzCNE=;
 b=aB0Ijmuk2iN1x/GH+Q/BQsRPgaygOdi+w6SBTzQ8/cKxL8+JvuinzTfNfpJjFkpDKf
 5v/L4mmHlNLeCsmKCQmMR7tjownoU0yZw6u9BawRvt3qiSEKyx+X3vbVq0Mr3GqTeOpd
 TuaHuRRXL6/z+pWbUfrIsgpwHE3W2zvgKulRursThURUyJLdKqDDxpzGLKu4Af94JL1A
 Ky85Qg3MG0Um0moGenp6eJqEGlJtNIkkx5BCe3OVmuxDjgGhoOBCSNPEjUfA1ghL3oPw
 c/SrBrlKfX/LVTC8Hjmfkcpax0qCQ6VksNt8mA6fyF9LGJeR0JVFGIyia13QNN8jh9U3
 N2zw==
X-Gm-Message-State: AJIora/EA8ubrLwheFIMllghcGMI7wT7moDHLZeLA0raGK0WpIUEraQ5
 d5Mvcnl/wFEIiDS0aLXVaFE=
X-Google-Smtp-Source: AGRyM1t424M+1J58sV4QyJ9NvnUTQV6QYw4Zw29zbn+0fE9EJNQoENXKMKoiDA6uoHSHDZdhTUpSdw==
X-Received: by 2002:a63:ba07:0:b0:40d:77fd:9429 with SMTP id
 k7-20020a63ba07000000b0040d77fd9429mr4412803pgf.110.1656531481706; 
 Wed, 29 Jun 2022 12:38:01 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:3841:49ce:cba5:1586?
 ([2620:15c:211:201:3841:49ce:cba5:1586])
 by smtp.gmail.com with ESMTPSA id
 c4-20020a170902d90400b0016767ff327dsm11796560plz.129.2022.06.29.12.38.00
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 29 Jun 2022 12:38:00 -0700 (PDT)
Message-ID: <75aa2055-0f50-47ce-b9cc-8f79eba77807@acm.org>
Date: Wed, 29 Jun 2022 12:37:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
To: Kent Overstreet <kent.overstreet@gmail.com>
References: <20220624141255.2461148-1-ming.lei@redhat.com>
 <20220624141255.2461148-2-ming.lei@redhat.com>
 <20220626201458.ytn4mrix2pobm2mb@moria.home.lan> <Yrld9rLPY6L3MhlZ@T590>
 <20220628042016.wd65amvhbjuduqou@moria.home.lan>
 <3ad782c3-4425-9ae6-e61b-9f62f76ce9f4@kernel.dk>
 <20220628183247.bcaqvmnav34kp5zd@moria.home.lan>
 <6f8db146-d4b3-d17b-4e58-08adc0010cba@kernel.dk>
 <20220629184001.b66bt4jnppjquzia@moria.home.lan>
 <486ec9e2-d34d-abd5-8667-f58a07f5efad@acm.org>
 <20220629190540.fwspv66a4byzqxmg@moria.home.lan>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220629190540.fwspv66a4byzqxmg@moria.home.lan>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH 5.20 1/4] block: add bio_rewind() API
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
Cc: Jens Axboe <axboe@kernel.dk>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Mike Snitzer <snitzer@redhat.com>, Eric Biggers <ebiggers@google.com>,
 Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Dmitry Monakhov <dmonakhov@openvz.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 6/29/22 12:05, Kent Overstreet wrote:
> On Wed, Jun 29, 2022 at 11:51:27AM -0700, Bart Van Assche wrote:
>> On 6/29/22 11:40, Kent Overstreet wrote:
>>> But Jens, to be blunt - I know we have different priorities in the way we write code.
>>
>> Please stay professional in your communication and focus on the technical
>> issues instead of on the people involved.
>>
>> BTW, I remember that some time ago I bisected a kernel bug to one of your
>> commits and that you refused to fix the bug introduced by that commit. I had
>> to spend my time on root-causing it and sending a fix upstream.
> 
> I'd be genuinely appreciative if you'd refresh my memory on what it was. Because
> yeah, if I did that that was my fuckup and I want to learn from my mistakes.

I was referring to the following two conversations from May 2018:
* [PATCH] Revert "block: Add warning for bi_next not NULL in 
bio_endio()" 
(https://lore.kernel.org/linux-block/20180522235505.20937-1-bart.vanassche@wdc.com/)
* [PATCH v2] Revert "block: Add warning for bi_next not NULL in 
bio_endio()" 
(https://lore.kernel.org/linux-block/20180619172640.15246-1-bart.vanassche@wdc.com/)

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C1CFC433EF
	for <dm-devel@archiver.kernel.org>; Wed, 29 Jun 2022 19:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656529407;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=dlq04NxbxJw3JFBR6C4258zCxjsVi5cRjhsVY7mrE9k=;
	b=c9EZpNHOjQaG2YHAz6KA1VQ+PHagoXaw3/objeKcVQiScbVtEdZK8EKQ3HU8wYwyF2/y/y
	S8c+nZowdExuYLuEKoOxIF69u5v8x8BukZfirwkefoiDXRQP0FIvNaeDsu0F2njvfAkq12
	yWb/r2nLvSjZLYItTNsSPNtEt6eExmY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-136-3dkj9bvMP3S2SSrPfgT0cw-1; Wed, 29 Jun 2022 15:03:25 -0400
X-MC-Unique: 3dkj9bvMP3S2SSrPfgT0cw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0BE2981D9DA;
	Wed, 29 Jun 2022 19:03:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 01F9C1415108;
	Wed, 29 Jun 2022 19:03:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9A0D2194705B;
	Wed, 29 Jun 2022 19:03:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D92FD1947058
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Jun 2022 19:00:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C91FE2166B29; Wed, 29 Jun 2022 19:00:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C52C02166B26
 for <dm-devel@redhat.com>; Wed, 29 Jun 2022 19:00:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AAC35811E81
 for <dm-devel@redhat.com>; Wed, 29 Jun 2022 19:00:59 +0000 (UTC)
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com
 [209.85.214.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-368-Hna_B1gyPUW00mtjsl2aNg-1; Wed, 29 Jun 2022 15:00:55 -0400
X-MC-Unique: Hna_B1gyPUW00mtjsl2aNg-1
Received: by mail-pl1-f176.google.com with SMTP id l6so14925101plg.11
 for <dm-devel@redhat.com>; Wed, 29 Jun 2022 12:00:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=m3AG9RdQkKvq+okquL9cMs8wgYGcDdlD+r9O3qTKjIk=;
 b=Z5wiiCW9g/ANC+LZhmjJ00jcX7ieS042xzuEkADsnma64wLILjHAi70ItSdqEWsrUF
 30o7MBGWHFsy/lUwP/N48EXk8cs9/EqVH5tijLvfftlvdczQaZNbFGep8fTw/0Wj9Q5S
 B8cP7FrmXEiE1qV2tPqF6KUMh+gW5nnGpqDwyOZZRHj0HereRuATJh6mtXRWb9AFTXtk
 bS50qnAkUTVYP7p0g9ngiRzY4Zci46HUAIa/gtjizmIqIbIeVoRjlMUPhbejtI8pW4Dg
 mtl6tbrDjw+QDafdEHV4e1bB484uGlTAQNeeybeSV5LIpcnyWgEIJzhu00WeT2n/I62/
 IYbg==
X-Gm-Message-State: AJIora/SphM+8noRVVhnlFkluTsr7fZ9rVDlf4YOtW9i2L2XscZ0LEiO
 kSLHwHAqZ99Y7ok33UKKhBfA7A==
X-Google-Smtp-Source: AGRyM1vuUg9v9LRXc8uTqf92k9LYfHqZPSVlOEAAitzYpiY+LZKy6uPkHW5NHxFB8qV8uBBcrBjMgw==
X-Received: by 2002:a17:90a:404a:b0:1ea:e936:b69 with SMTP id
 k10-20020a17090a404a00b001eae9360b69mr5299705pjg.133.1656529254467; 
 Wed, 29 Jun 2022 12:00:54 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
 by smtp.gmail.com with ESMTPSA id
 pj4-20020a17090b4f4400b001ece6f492easm2602662pjb.44.2022.06.29.12.00.53
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 29 Jun 2022 12:00:53 -0700 (PDT)
Message-ID: <3e15e116-ea64-501d-1292-7b2936b19681@kernel.dk>
Date: Wed, 29 Jun 2022 13:00:52 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
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
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220629184001.b66bt4jnppjquzia@moria.home.lan>
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
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 Mike Snitzer <snitzer@redhat.com>, Eric Biggers <ebiggers@google.com>,
 Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Dmitry Monakhov <dmonakhov@openvz.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 6/29/22 12:40 PM, Kent Overstreet wrote:
> On Wed, Jun 29, 2022 at 11:16:10AM -0600, Jens Axboe wrote:
>> Not sure what Christoph change you are referring to, but all the ones
>> that I did to improve the init side were all backed by numbers I ran at
>> that time (and most/all of the commit messages will have that data). So
>> yes, it is indeed still very noticeable. Maybe not at 100K IOPS, but at
>> 10M on a core it most certainly is.
> 
> I was referring to 609be1066731fea86436f5f91022f82e592ab456. You
> signed off on it, you must remember it...?

I'm sure we all remember each and every commit that gets applied,
particularly with such a precise description of the change.

>> I'm all for having solid and maintainable code, obviously, but frivolous
>> bloating of structures and more expensive setup cannot be hand waved
>> away with "it doesn't matter if we touch 3 or 6 cachelines" because we
>> obviously have a disagreement on that.
> 
> I wouldn't propose inflating struct _bio_ like that. But Jens, to be
> blunt - I know we have different priorities in the way we write code.
> Your writeback throttling code was buggy for _ages_ and I had users
> hitting deadlocks there that I pinged you about, and I could not make
> heads or tails of how that code was supposed to work and not for lack
> of time spent trying!

OK Kent, you just wasted your 2nd chance here. Plonk. There are many
rebuttals that could be made here, but I won't waste my time on it, nor
would it be appropriate.

Come back when you know how to act professionally. Or don't come back
at all.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


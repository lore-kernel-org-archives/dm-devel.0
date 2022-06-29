Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0745FC43334
	for <dm-devel@archiver.kernel.org>; Wed, 29 Jun 2022 17:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656524309;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=z1E6N2la1gwH1sNsURFMv6dPGvrYlq3SfUnj7gDvQVQ=;
	b=g7jzEhCwn184SYlyio/97AHHlVb6+jEBaKwu3lRajmPipALGKL335OItx4W/5f/dpaGJ3N
	AvGuvK4bGBIlqS9Ta4VoOMdStzk23xxYil9piRpl6KZA5LWqBHareEIw1XgJ3WuD8yeqwC
	WIUAg54C4CuUoyzrwNZa6veDgHiP+Gc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-266-1QKJOSaGMIO33M4fGeZp2Q-1; Wed, 29 Jun 2022 13:38:26 -0400
X-MC-Unique: 1QKJOSaGMIO33M4fGeZp2Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 06538801231;
	Wed, 29 Jun 2022 17:38:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EEC4540CFD05;
	Wed, 29 Jun 2022 17:38:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 81371194705B;
	Wed, 29 Jun 2022 17:38:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E4EE91947058
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Jun 2022 17:16:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BC48440334D; Wed, 29 Jun 2022 17:16:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B812A40336E
 for <dm-devel@redhat.com>; Wed, 29 Jun 2022 17:16:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A12911C05146
 for <dm-devel@redhat.com>; Wed, 29 Jun 2022 17:16:15 +0000 (UTC)
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com
 [209.85.216.49]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-9bvrgEG6NZ-vWCU32amgdg-1; Wed, 29 Jun 2022 13:16:13 -0400
X-MC-Unique: 9bvrgEG6NZ-vWCU32amgdg-1
Received: by mail-pj1-f49.google.com with SMTP id
 w1-20020a17090a6b8100b001ef26ab992bso102511pjj.0
 for <dm-devel@redhat.com>; Wed, 29 Jun 2022 10:16:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=/+DA51ULPJFbE6Y+XCYKni6lHNUdKvUDD3ikKmPRkTc=;
 b=IcxKFyD/vYBRljDJUe3+mQM5l/UqXKHw/OfMz/rLPJfnBquAjq7CP0mo6YslDYmQAZ
 /1U7I2mw1gNk7ECVTdUxHeKYZLfOwU3uReCMIJGpYlv/yDdgCqM3FfnCSfOmAHTzpUnE
 wdSNCwmHtdPx9tnMVZAk7rw9OC5XaMQdcTPzFALk69s0tfu5rZ2m4j5HS7q8VvzlemQI
 u9pmFxafJsZnX2fr1wl/zXtTNAvHrbpAeNfvtX9fH6xyIoU2nObYuf8aSku5s48kSuZl
 ECDDHeFOHjEGkIc9J59XS8ImquFHm0hJwBaFcgK71HAjs28NaI5Ez8f3d7hAH1O+2KNi
 twOw==
X-Gm-Message-State: AJIora8hDs91Ki0cVCK6DS6tfUd1bADL+Dw8US3U7dIUqfYhbLgKqjze
 ggNA0WOp9e7jHft/i2vjkJSbhg==
X-Google-Smtp-Source: AGRyM1sYNbBYpPvY4Y2mmMGPN6ZIDBjC6tPIou6i47La2wx6f5mLpJ1OqrepCLDg5syxHJkuqTf4Sw==
X-Received: by 2002:a17:902:f813:b0:169:8f5d:c343 with SMTP id
 ix19-20020a170902f81300b001698f5dc343mr11359822plb.98.1656522972323; 
 Wed, 29 Jun 2022 10:16:12 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
 by smtp.gmail.com with ESMTPSA id
 t14-20020a17090340ce00b00163bddfb109sm11614197pld.10.2022.06.29.10.16.11
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 29 Jun 2022 10:16:11 -0700 (PDT)
Message-ID: <6f8db146-d4b3-d17b-4e58-08adc0010cba@kernel.dk>
Date: Wed, 29 Jun 2022 11:16:10 -0600
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
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220628183247.bcaqvmnav34kp5zd@moria.home.lan>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 6/28/22 12:32 PM, Kent Overstreet wrote:
> On Tue, Jun 28, 2022 at 12:13:06PM -0600, Jens Axboe wrote:
>> It's much less about using whatever amount of memory for inflight IO,
>> and much more about not bloating fast path structures (of which the
>> bio is certainly one). All of this gunk has to be initialized for
>> each IO, and that's the real issue.
>>
>> Just look at the recent work for iov_iter and why ITER_UBUF makes
>> sense to do.
>>
>> This is not a commentary on this patchset, just a general
>> observation. Sizes of hot data structures DO matter, and quite a bit
>> so.
> 
> Younger me would have definitely been in agreement; initializing these
> structs definitely tends to show up in profiles.

Older me still greatly cares :-)

> These days I'm somewhat less inclined towards that view - profiles
> naturally highlight where your cache misses are happening, and
> initializing a freshly allocated data structure is always going to be
> a cache miss. But the difference between touching 3 and 6 contiguous
> cachelines is practically nil...  assuming we aren't doing anything
> stupid like using memset (despite what Linus wants from the CPU
> vendors, rep stos _still_ sucks) and perhaps inserting prefetches
> where appropriate.
> 
> And I see work going by that makes me really wonder if it was
> justified - in particular I _really_ want to know if Christoph's bio
> initialization change was justified by actual benchmarks and what
> those numbers were, vs. looking at profiles. Wasn't anything in the
> commit log...

Not sure what Christoph change you are referring to, but all the ones
that I did to improve the init side were all backed by numbers I ran at
that time (and most/all of the commit messages will have that data). So
yes, it is indeed still very noticeable. Maybe not at 100K IOPS, but at
10M on a core it most certainly is.

I'm all for having solid and maintainable code, obviously, but frivolous
bloating of structures and more expensive setup cannot be hand waved
away with "it doesn't matter if we touch 3 or 6 cachelines" because we
obviously have a disagreement on that.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


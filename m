Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DE8FC43334
	for <dm-devel@archiver.kernel.org>; Tue, 28 Jun 2022 18:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656440000;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+jm0S0uuGEMixBY5TWGq0dxQX5hwMcLo1pW51VQvCSE=;
	b=Cwd9dTOTYe1iiPXftfztLnlJ5+B3K3gQoHQ0w5IcIDskO4JIOBrvDRQldxXM/bIKlnjacj
	TPnbKIOvRQactBfAThiIsS8KaQ7Ws1msXsEo4R7UVkRhJB9DdLsFNmwcIQzU2rp3J/BSi5
	KZgahEYlteVaajF2zkuopvLqfUeBwyU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-73-nzw57piRPYGcfk1rA9_sSA-1; Tue, 28 Jun 2022 14:13:16 -0400
X-MC-Unique: nzw57piRPYGcfk1rA9_sSA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BE027811E7A;
	Tue, 28 Jun 2022 18:13:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 670BD1415108;
	Tue, 28 Jun 2022 18:13:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2B70E1947056;
	Tue, 28 Jun 2022 18:13:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 939B919466DF
 for <dm-devel@listman.corp.redhat.com>; Tue, 28 Jun 2022 18:13:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6EE544619F3; Tue, 28 Jun 2022 18:13:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6ADDF41638B
 for <dm-devel@redhat.com>; Tue, 28 Jun 2022 18:13:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 522633C0E218
 for <dm-devel@redhat.com>; Tue, 28 Jun 2022 18:13:12 +0000 (UTC)
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com
 [209.85.216.52]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-9F3QsUB6MeGzKvN4gKWFQg-1; Tue, 28 Jun 2022 14:13:10 -0400
X-MC-Unique: 9F3QsUB6MeGzKvN4gKWFQg-1
Received: by mail-pj1-f52.google.com with SMTP id
 i8-20020a17090aee8800b001ecc929d14dso81370pjz.0
 for <dm-devel@redhat.com>; Tue, 28 Jun 2022 11:13:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=eRV2mthXWzua5Vvg+is/lVt+ATZoNwT5SgUu9s9+sz4=;
 b=eTQtL24Zeam5olx3DN6XEz7Rvidr2YaVTY+X82tzu1LJIOX/Y04rk0zFgBmrE3fAXs
 58w4tXRJuAMPVIbXhaUGIc56DKF0F9du80GJDiHwQ8NxcZLmsnTDDdm90ScyiC/GZ3ek
 R7EYHFQsQkSI0G3kczCWPUKP8E3AJ5V7yeq1irAygoM50X6tI5r/vcT+dDbx9lfzyHc2
 9ofe9aMWB/ZapOcWF1DHW53h7MLm5Qx+8/JCmp4g53ZE4QR8lMJEuSlLv6iDFHoLMKOd
 2PBtqngTIpdc2IC/zPNmAcO0wMb6uabuOSc7kXpktiwfwBl7nCdRlHlZhTzkFkJTR0A/
 qi6w==
X-Gm-Message-State: AJIora98FY36RBQdDCL9FKLFUi2f3FBjlTmzEcNUxheby0oVj8W/S1KJ
 AqNcDGebXqnXnpqv/Yov2oD83w==
X-Google-Smtp-Source: AGRyM1uMZ7NdVAghHFmlAGmUdbYwRNP14auAsN1XpcUfbuFSizOFZf0OcSnGAdprQG95gZ6W2OMkqQ==
X-Received: by 2002:a17:902:ce83:b0:16a:4a3e:4f8b with SMTP id
 f3-20020a170902ce8300b0016a4a3e4f8bmr6382849plg.41.1656439989081; 
 Tue, 28 Jun 2022 11:13:09 -0700 (PDT)
Received: from ?IPV6:2620:10d:c085:21e1::165b? ([2620:10d:c090:400::5:f46f])
 by smtp.gmail.com with ESMTPSA id
 v2-20020a056a00148200b00525343b5047sm9717910pfu.76.2022.06.28.11.13.07
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 28 Jun 2022 11:13:08 -0700 (PDT)
Message-ID: <3ad782c3-4425-9ae6-e61b-9f62f76ce9f4@kernel.dk>
Date: Tue, 28 Jun 2022 12:13:06 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
To: Kent Overstreet <kent.overstreet@gmail.com>, Ming Lei <ming.lei@redhat.com>
References: <20220624141255.2461148-1-ming.lei@redhat.com>
 <20220624141255.2461148-2-ming.lei@redhat.com>
 <20220626201458.ytn4mrix2pobm2mb@moria.home.lan> <Yrld9rLPY6L3MhlZ@T590>
 <20220628042016.wd65amvhbjuduqou@moria.home.lan>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220628042016.wd65amvhbjuduqou@moria.home.lan>
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
Cc: Mike Snitzer <snitzer@redhat.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Eric Biggers <ebiggers@google.com>, linux-block@vger.kernel.org,
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

On 6/27/22 10:20 PM, Kent Overstreet wrote:
> On Mon, Jun 27, 2022 at 03:36:22PM +0800, Ming Lei wrote:
>> On Sun, Jun 26, 2022 at 04:14:58PM -0400, Kent Overstreet wrote:
>>> On Fri, Jun 24, 2022 at 10:12:52PM +0800, Ming Lei wrote:
>>>> Commit 7759eb23fd98 ("block: remove bio_rewind_iter()") removes
>>>> the similar API because the following reasons:
>>>>
>>>>     ```
>>>>     It is pointed that bio_rewind_iter() is one very bad API[1]:
>>>>
>>>>     1) bio size may not be restored after rewinding
>>>>
>>>>     2) it causes some bogus change, such as 5151842b9d8732 (block: reset
>>>>     bi_iter.bi_done after splitting bio)
>>>>
>>>>     3) rewinding really makes things complicated wrt. bio splitting
>>>>
>>>>     4) unnecessary updating of .bi_done in fast path
>>>>
>>>>     [1] https://marc.info/?t=153549924200005&r=1&w=2
>>>>
>>>>     So this patch takes Kent's suggestion to restore one bio into its original
>>>>     state via saving bio iterator(struct bvec_iter) in bio_integrity_prep(),
>>>>     given now bio_rewind_iter() is only used by bio integrity code.
>>>>     ```
>>>>
>>>> However, it isn't easy to restore bio by saving 32 bytes bio->bi_iter, and saving
>>>> it only can't restore crypto and integrity info.
>>>>
>>>> Add bio_rewind() back for some use cases which may not be same with
>>>> previous generic case:
>>>>
>>>> 1) most of bio has fixed end sector since bio split is done from front of the bio,
>>>> if driver just records how many sectors between current bio's start sector and
>>>> the bio's end sector, the original position can be restored
>>>>
>>>> 2) if one bio's end sector won't change, usually bio_trim() isn't called, user can
>>>> restore original position by storing sectors from current ->bi_iter.bi_sector to
>>>> bio's end sector; together by saving bio size, 8 bytes can restore to
>>>> original bio.
>>>>
>>>> 3) dm's requeue use case: when BLK_STS_DM_REQUEUE happens, dm core needs to
>>>> restore to the original bio which represents current dm io to be requeued.
>>>> By storing sectors to the bio's end sector and dm io's size,
>>>> bio_rewind() can restore such original bio, then dm core code needn't to
>>>> allocate one bio beforehand just for handling BLK_STS_DM_REQUEUE which
>>>> is actually one unusual event.
>>>>
>>>> 4) Not like original rewind API, this one needn't to add .bi_done, and no any
>>>> effect on fast path
>>>
>>> It seems like perhaps the real issue here is that we need a real bio_iter,
>>> separate from bvec_iter, that also encapsulates iterating over integrity &
>>> fscrypt. 
>>
>> Not mention bio_iter, bvec_iter has been 32 bytes, which is too big to
>> hold in per-io data structure. With this patch, 8bytes is enough
>> to rewind one bio if the end sector is fixed.
> 
> Hold on though, does that check out? Why is that too big for per IO data
> structures?
> 
> By definition these structures are only for IOs in flight, and we don't _want_
> there to ever be very many of these or we're going to run into latency issues
> due to queue depth.

It's much less about using whatever amount of memory for inflight IO,
and much more about not bloating fast path structures (of which the bio
is certainly one). All of this gunk has to be initialized for each IO,
and that's the real issue.

Just look at the recent work for iov_iter and why ITER_UBUF makes sense
to do.

This is not a commentary on this patchset, just a general observation.
Sizes of hot data structures DO matter, and quite a bit so.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


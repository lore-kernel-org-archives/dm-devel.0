Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8768C433EF
	for <dm-devel@archiver.kernel.org>; Thu,  2 Jun 2022 08:19:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-380-wqjwEizSNdC3VkDwRBcRww-1; Thu, 02 Jun 2022 04:19:04 -0400
X-MC-Unique: wqjwEizSNdC3VkDwRBcRww-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BFE5F802804;
	Thu,  2 Jun 2022 08:19:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 170BD416366;
	Thu,  2 Jun 2022 08:19:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D45561947B84;
	Thu,  2 Jun 2022 08:19:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D47AC1947B83
 for <dm-devel@listman.corp.redhat.com>; Thu,  2 Jun 2022 08:18:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A1AB42166B33; Thu,  2 Jun 2022 08:18:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B7A52166B2C
 for <dm-devel@redhat.com>; Thu,  2 Jun 2022 08:18:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A18E1C04B63
 for <dm-devel@redhat.com>; Thu,  2 Jun 2022 08:18:59 +0000 (UTC)
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com
 [209.85.128.41]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614--18W3CgWN1iO3YYC9dgNcQ-1; Thu, 02 Jun 2022 04:18:57 -0400
X-MC-Unique: -18W3CgWN1iO3YYC9dgNcQ-1
Received: by mail-wm1-f41.google.com with SMTP id
 h62-20020a1c2141000000b0039aa4d054e2so4374760wmh.1
 for <dm-devel@redhat.com>; Thu, 02 Jun 2022 01:18:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=grBv/gpdLam/wFPbL6YIo2ry7eetDeeb1gTECl6N5a0=;
 b=gmUIo75TOUagv/DSWhj8yHlRmYmdvf8LUPjV8nBPqOebAwcWJg8l/3a9+uF1iivvT1
 yn2BoUg8DPm1WcfrTHon+TKPmsJ7SljZxKx5bhH5sVo23KIqPPCDjzIuxqL5DA9+YAPO
 jntJY6IcSXMH89U+Ey/2/tCM+AX/QujR3rJpuMvEi86SZXaWf8mlQPuhvxFaFbud57ho
 G3yKazhl/uqJSb3qcvYBCm39orqLAI31aZt6cQQl+K/uQAepjeLX7FGD/wI5qYBwoofD
 OVzERp7UjUzqnZPS10wMzYdEDbRprvyVt+1CfYmst8Qyf4sz5bAZNSGZIOV2BjVXTr5Z
 AQjA==
X-Gm-Message-State: AOAM531SIAoEmUelzdJ4SoqX4VQvResjvTGLfABRGYT4GmjN7LipTqEa
 +SvMANJje7hFYPA91cfImin4Fw==
X-Google-Smtp-Source: ABdhPJxPBSxtMAL0eFt5HtWjrSQGq6vvRTkHzimcZatsdY+SMZ31DPKqDNJcbU2ReLbfFuBYvhvQrA==
X-Received: by 2002:a05:600c:acf:b0:397:345f:fe10 with SMTP id
 c15-20020a05600c0acf00b00397345ffe10mr2909296wmr.15.1654157936135; 
 Thu, 02 Jun 2022 01:18:56 -0700 (PDT)
Received: from [10.40.36.78] ([193.52.24.5]) by smtp.gmail.com with ESMTPSA id
 a4-20020a5d5084000000b002102f2fac37sm3786342wrt.51.2022.06.02.01.18.55
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 02 Jun 2022 01:18:55 -0700 (PDT)
Message-ID: <7cf7a9ce-525d-3b90-2b49-6eae6189da6e@kernel.dk>
Date: Thu, 2 Jun 2022 02:18:54 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
To: Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>
References: <YpK7m+14A+pZKs5k@casper.infradead.org>
 <2523e5b0-d89c-552e-40a6-6d414418749d@kernel.dk>
 <YpZlOCMept7wFjOw@redhat.com> <YpcBgY9MMgumEjTL@infradead.org>
 <Ypd0DnmjvCoWj+1P@redhat.com> <Yphw2n3ERoFsWgEe@infradead.org>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Yphw2n3ERoFsWgEe@infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] bioset_exit poison from dm_destroy
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, david@fromorbit.com,
 Matthew Wilcox <willy@infradead.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 6/2/22 2:12 AM, Christoph Hellwig wrote:
> On Wed, Jun 01, 2022 at 10:13:34AM -0400, Mike Snitzer wrote:
>> Please take the time to look at the code and save your judgement until
>> you do.  That said, I'm not in love with the complexity of how DM
>> handles bioset initialization.  But both you and Jens keep taking
>> shots at DM for doing things wrong without actually looking.
> 
> I'm not taking shots.  I'm just saying we should kill this API.  In
> the worse case the caller can keep track of if a bioset is initialized,
> but in most cases we should be able to deduct it in a nicer way.

Yeah ditto, it's more an observation on needing something like
this_foo_was_initialized() is just a bad way to program it to begin
with. The caller should know this already, rather than us needing
functions and state in the struct to tell you about it.

>> DM uses bioset_init_from_src().  Yet you've both assumed double frees
>> and such (while not entirely wrong your glossing over the detail that
>> there is intervening reinitialization of DM's biosets between the
>> bioset_exit()s)
> 
> And looking at the code, that use of bioset_init_from_src is completely
> broken.  It does not actually preallocated anything as intended by
> dm (maybe that isn't actually needed) but just uses the biosets in
> dm_md_mempools as an awkward way to carry parameters.  And completely
> loses bringing over the integrity allocations.  And no, this is not
> intended as a "cheap shot" against Jens who did that either..
> 
> This is what I think should fix this, and will allow us to remove
> bioset_init_from_src which was a bad idea from the start:

Based on a quick look, seems good to me.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


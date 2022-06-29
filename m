Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18082C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 30 Jun 2022 07:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656574293;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=3d0EPfxP3l+2wK90B56EpaWlusjNaTzlGhgrPHwYVyY=;
	b=hEmSp85QyyGmjYlxbIV+KO2R3Zm0PUHob2fT2RCc1Fiojxdb5h67gEg18wXaoL3kW1AS6w
	jkmnpXZNE0Btq3lKsCcs6G0eAxHLOhTG9zYlaKhXt+2Lgcp3S30bVPzv7sLwk9d7RNLfT0
	TZJVjC5BbqP1u2ZoHwnXAVqlzEnDR5k=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-507-tv_FBB5MPECbphntFb0f1A-1; Thu, 30 Jun 2022 03:31:29 -0400
X-MC-Unique: tv_FBB5MPECbphntFb0f1A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 73C643C1172C;
	Thu, 30 Jun 2022 07:31:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5F9CE2166B29;
	Thu, 30 Jun 2022 07:31:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0A74A1947060;
	Thu, 30 Jun 2022 07:31:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2E0291947058
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Jun 2022 19:26:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E24E12166B29; Wed, 29 Jun 2022 19:26:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DE2F52166B26
 for <dm-devel@redhat.com>; Wed, 29 Jun 2022 19:26:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C2ADF8032EA
 for <dm-devel@redhat.com>; Wed, 29 Jun 2022 19:26:51 +0000 (UTC)
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com
 [209.85.222.179]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-220-smW767SlPimjpUvopbS-Bw-1; Wed, 29 Jun 2022 15:26:50 -0400
X-MC-Unique: smW767SlPimjpUvopbS-Bw-1
Received: by mail-qk1-f179.google.com with SMTP id k10so12789649qke.9;
 Wed, 29 Jun 2022 12:26:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=afkV4rBN6nn1zph/9YW9XobgOkkRmSqKCQvR6HQFXHE=;
 b=tQMT6kPuDks5mBLLUfEtQXxiUR+2MZtNb+qyvTQXDiPe++DxyaZeXOWzbOy7S0XL7h
 tTTfpa7yiafJNkkpvK2L1HCHEsXC/euv2P9n0FFpNOz6KbWAH8mS160LGh49CG1gHlSE
 xQNd3Li4ODxV5bq3knTMW2GvxMR4+xBigkXmpxVOK/u2CS31Fsnc8vJcyj91LpJ1EE2q
 z41YArzmg1qFYOeqVjzt3c72qFsUeMfUwhyH/V8rMpA6zk8ggVHe9kijSZTZi4qyRNMe
 fw16+KRWl+PfOKGZg2gu72QyHLRZEMmW5fYLnhA4Kj4amN+Wt/gSmeYOcqQB2VYOAnyX
 wraQ==
X-Gm-Message-State: AJIora9P5OXydkp35x86tPGr75jFVQ/4Nf/LuiRk0tIdT8XU6e3vcZFx
 kzpOrQpzs5WaAjG9dGnZUA==
X-Google-Smtp-Source: AGRyM1ubTa/2lTc8XS7wB4e3sKdA8mE1xOYnCVBR33J2Ga2S95V+hyWd5+9QdFDdDCsWGpF3v7llEQ==
X-Received: by 2002:a37:c50:0:b0:6af:46d:c373 with SMTP id
 77-20020a370c50000000b006af046dc373mr3461406qkm.659.1656530809118; 
 Wed, 29 Jun 2022 12:26:49 -0700 (PDT)
Received: from localhost (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
 by smtp.gmail.com with ESMTPSA id
 r8-20020a05620a298800b006a99088cd99sm15411713qkp.6.2022.06.29.12.26.47
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 29 Jun 2022 12:26:47 -0700 (PDT)
Date: Wed, 29 Jun 2022 15:26:46 -0400
From: Kent Overstreet <kent.overstreet@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Message-ID: <20220629192646.aoj5c7xdqkifwjdg@moria.home.lan>
References: <20220624141255.2461148-1-ming.lei@redhat.com>
 <20220624141255.2461148-2-ming.lei@redhat.com>
 <20220626201458.ytn4mrix2pobm2mb@moria.home.lan>
 <Yrld9rLPY6L3MhlZ@T590>
 <20220628042016.wd65amvhbjuduqou@moria.home.lan>
 <3ad782c3-4425-9ae6-e61b-9f62f76ce9f4@kernel.dk>
 <20220628183247.bcaqvmnav34kp5zd@moria.home.lan>
 <6f8db146-d4b3-d17b-4e58-08adc0010cba@kernel.dk>
 <20220629184001.b66bt4jnppjquzia@moria.home.lan>
 <3e15e116-ea64-501d-1292-7b2936b19681@kernel.dk>
MIME-Version: 1.0
In-Reply-To: <3e15e116-ea64-501d-1292-7b2936b19681@kernel.dk>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mailman-Approved-At: Thu, 30 Jun 2022 07:31:23 +0000
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jun 29, 2022 at 01:00:52PM -0600, Jens Axboe wrote:
> On 6/29/22 12:40 PM, Kent Overstreet wrote:
> > On Wed, Jun 29, 2022 at 11:16:10AM -0600, Jens Axboe wrote:
> >> Not sure what Christoph change you are referring to, but all the ones
> >> that I did to improve the init side were all backed by numbers I ran at
> >> that time (and most/all of the commit messages will have that data). So
> >> yes, it is indeed still very noticeable. Maybe not at 100K IOPS, but at
> >> 10M on a core it most certainly is.
> > 
> > I was referring to 609be1066731fea86436f5f91022f82e592ab456. You
> > signed off on it, you must remember it...?
> 
> I'm sure we all remember each and every commit that gets applied,
> particularly with such a precise description of the change.
> 
> >> I'm all for having solid and maintainable code, obviously, but frivolous
> >> bloating of structures and more expensive setup cannot be hand waved
> >> away with "it doesn't matter if we touch 3 or 6 cachelines" because we
> >> obviously have a disagreement on that.
> > 
> > I wouldn't propose inflating struct _bio_ like that. But Jens, to be
> > blunt - I know we have different priorities in the way we write code.
> > Your writeback throttling code was buggy for _ages_ and I had users
> > hitting deadlocks there that I pinged you about, and I could not make
> > heads or tails of how that code was supposed to work and not for lack
> > of time spent trying!
> 
> OK Kent, you just wasted your 2nd chance here. Plonk. There are many
> rebuttals that could be made here, but I won't waste my time on it, nor
> would it be appropriate.
> 
> Come back when you know how to act professionally. Or don't come back
> at all.

Jens, you're just acting like your code is immune to criticism, and I don't have
an eyeroll big enough for that. We all know how you care about chasing every
last of those 10 million iops - and not much else.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


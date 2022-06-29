Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9467C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 30 Jun 2022 07:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656574290;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ygDWGHuXYoZDQRfFh4xhvdiUV1FUDky8nye0IAD2SaQ=;
	b=BKotWdGPP9Io6qG20aUf2KKcw8rOVs6PvCx71OIyfrGG9Jo5IhEokmZklWUdNNTr52V7nD
	Blf8NG+6sLOs6iyc3HZk6InoxQEXekdmSkycazObuWmDR4bryy1miiUxzSUuJjGIcTRc87
	qsy5f0eNUnCWwbDmu4inl9AUD/4EgEc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-217-R-zEWi-YOaKNnsXthca6zw-1; Thu, 30 Jun 2022 03:31:27 -0400
X-MC-Unique: R-zEWi-YOaKNnsXthca6zw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1DC822919EC3;
	Thu, 30 Jun 2022 07:31:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E3A1A41637B;
	Thu, 30 Jun 2022 07:31:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 96D891947060;
	Thu, 30 Jun 2022 07:31:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 836171947058
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Jun 2022 19:59:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 65243492CA3; Wed, 29 Jun 2022 19:59:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5FDF6492C3B
 for <dm-devel@redhat.com>; Wed, 29 Jun 2022 19:59:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 47EE91019C89
 for <dm-devel@redhat.com>; Wed, 29 Jun 2022 19:59:20 +0000 (UTC)
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com
 [209.85.219.46]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-385-xbBB1n22NIyF5WRK-4PvCA-1; Wed, 29 Jun 2022 15:59:15 -0400
X-MC-Unique: xbBB1n22NIyF5WRK-4PvCA-1
Received: by mail-qv1-f46.google.com with SMTP id z1so9214495qvp.9;
 Wed, 29 Jun 2022 12:59:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=VC1d/RtUMcFNbbvAAhEUHb9go0eBXP9ttr+DE79ATiQ=;
 b=Xms0hG+6S325qWcXttQhjZ5qPEPKSJ8okvlY8Waw3g9oa7gCe9bLT/c8KTNkxvefAv
 /q31+bxaMKPeIFi/vKIHijbz68U/01rwjO5tM9ntJvq6l3bw49Fve43p4LyRb8YSXjQA
 /NEwjjfpLTN3f9mIISEWKNBQkiTJCJAcVOWhqZqwcoDohIhglpAdcWhK+RH4n2PBf/AJ
 7Zhmlz6EW8BSKK0D9e4EvsXAyldJm5kc69AH/6Ch/aWopS72N7wJ1I+hSgAdI3C+rXls
 OxFj2ZrLeEz8zeAl1fTt4WIeX515DkBynjVcZwf+rkvFkDYyNowDaofLLUkAOwZKfPPp
 QzaA==
X-Gm-Message-State: AJIora9Js/T6wstxYNNErflcXh+pP7RujDhl+9FpgJoXNceliBB+aeV9
 8jaqlXJRZGfvSAAzwLFpxA==
X-Google-Smtp-Source: AGRyM1uSdd9e1HeXILcCMJ3BPfsY+q4doaVEd0sI0eppLIPowfIBd2RkwQmcFci0vDsGg6DAH44Ytw==
X-Received: by 2002:a05:6214:29ef:b0:470:b680:ad6f with SMTP id
 jv15-20020a05621429ef00b00470b680ad6fmr9407023qvb.80.1656532752181; 
 Wed, 29 Jun 2022 12:59:12 -0700 (PDT)
Received: from localhost (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
 by smtp.gmail.com with ESMTPSA id
 k12-20020a05620a414c00b006aefe22d75bsm13576490qko.80.2022.06.29.12.59.11
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 29 Jun 2022 12:59:11 -0700 (PDT)
Date: Wed, 29 Jun 2022 15:59:10 -0400
From: Kent Overstreet <kent.overstreet@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>
Message-ID: <20220629195910.wi5u5pelescihorn@moria.home.lan>
References: <20220626201458.ytn4mrix2pobm2mb@moria.home.lan>
 <Yrld9rLPY6L3MhlZ@T590>
 <20220628042016.wd65amvhbjuduqou@moria.home.lan>
 <3ad782c3-4425-9ae6-e61b-9f62f76ce9f4@kernel.dk>
 <20220628183247.bcaqvmnav34kp5zd@moria.home.lan>
 <6f8db146-d4b3-d17b-4e58-08adc0010cba@kernel.dk>
 <20220629184001.b66bt4jnppjquzia@moria.home.lan>
 <486ec9e2-d34d-abd5-8667-f58a07f5efad@acm.org>
 <20220629190540.fwspv66a4byzqxmg@moria.home.lan>
 <75aa2055-0f50-47ce-b9cc-8f79eba77807@acm.org>
MIME-Version: 1.0
In-Reply-To: <75aa2055-0f50-47ce-b9cc-8f79eba77807@acm.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
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
Cc: Jens Axboe <axboe@kernel.dk>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Mike Snitzer <snitzer@redhat.com>, Eric Biggers <ebiggers@google.com>,
 Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Dmitry Monakhov <dmonakhov@openvz.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jun 29, 2022 at 12:37:59PM -0700, Bart Van Assche wrote:
> On 6/29/22 12:05, Kent Overstreet wrote:
> > On Wed, Jun 29, 2022 at 11:51:27AM -0700, Bart Van Assche wrote:
> > > On 6/29/22 11:40, Kent Overstreet wrote:
> > > > But Jens, to be blunt - I know we have different priorities in the way we write code.
> > > 
> > > Please stay professional in your communication and focus on the technical
> > > issues instead of on the people involved.
> > > 
> > > BTW, I remember that some time ago I bisected a kernel bug to one of your
> > > commits and that you refused to fix the bug introduced by that commit. I had
> > > to spend my time on root-causing it and sending a fix upstream.
> > 
> > I'd be genuinely appreciative if you'd refresh my memory on what it was. Because
> > yeah, if I did that that was my fuckup and I want to learn from my mistakes.
> 
> I was referring to the following two conversations from May 2018:
> * [PATCH] Revert "block: Add warning for bi_next not NULL in bio_endio()" (https://lore.kernel.org/linux-block/20180522235505.20937-1-bart.vanassche@wdc.com/)
> * [PATCH v2] Revert "block: Add warning for bi_next not NULL in bio_endio()" (https://lore.kernel.org/linux-block/20180619172640.15246-1-bart.vanassche@wdc.com/)

And also, why did you decide to just revert instead of fixing the issue within
DM? You had a WARN() printed, you shouldn't have needed to bisect, the commit
message explained what was going on - but you never explained that part?

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


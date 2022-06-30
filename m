Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00534C43334
	for <dm-devel@archiver.kernel.org>; Thu, 30 Jun 2022 07:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656574289;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=DvylYKNFhtZbgWYG4xTlAl+n4JAtATr/Y4PipRhllJw=;
	b=YjXonhri8dZwIIqO/aDWIizx0aDpuzBsPmHVF2Xi6LwtwYanbYZV/XlFnKV9PacJcHjDBq
	kJe2H/DGxkyuYGYgCfkH5u5qoxoI+P9j1tScWOmbKfmoq5CQOl2skxUxhUm5u6F04gogco
	oN0hJ6z+s8VPEsBSZ5OMyuUEgYK6q8U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-X8QQCQyuO96WYAfnQY9bQw-1; Thu, 30 Jun 2022 03:31:27 -0400
X-MC-Unique: X8QQCQyuO96WYAfnQY9bQw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 71F5080B70A;
	Thu, 30 Jun 2022 07:31:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5D439C26E98;
	Thu, 30 Jun 2022 07:31:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5A31F1947064;
	Thu, 30 Jun 2022 07:31:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 69F981947058
 for <dm-devel@listman.corp.redhat.com>; Thu, 30 Jun 2022 00:58:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5B8F42026D07; Thu, 30 Jun 2022 00:58:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 571032026D64
 for <dm-devel@redhat.com>; Thu, 30 Jun 2022 00:58:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 09DFA29324AA
 for <dm-devel@redhat.com>; Thu, 30 Jun 2022 00:58:47 +0000 (UTC)
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com
 [209.85.219.53]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-548-INIm11kJOIS7eZSzRMq7TA-1; Wed, 29 Jun 2022 20:58:43 -0400
X-MC-Unique: INIm11kJOIS7eZSzRMq7TA-1
Received: by mail-qv1-f53.google.com with SMTP id c1so27451323qvi.11;
 Wed, 29 Jun 2022 17:58:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=0uppB9ii0pBd7MXi+uA0KCh+Kd0vDpxw6l/NwutkF0s=;
 b=w70xzsDTMxC6L2PDs53M+EeBX5PcL3W6MuLRJLbXdj0D398SloJFPhO5q/HIY5QTFv
 f2fz7965Cb46jx4cK4RfwBaT7akcpm8wjkafFlVGh5suATRKidFbHu9iWPWQhbpzkKsJ
 Gih/vI/2lJ+xEJoEVfwv/TJaBzck1yFhMyiyM8+HbgqpPil9v4ALxrGyxwyv1uxSFyrh
 LmSxE7l2KSmwX9rtZHZj6hcVzXM5YaQoSZdrRc9207imwMNkodPsa6fMQ5uXxjw/qmDM
 iAOxNZBU/p2mEDF4yxyGb8aZQyNuaKzVnyamPnoxT1WZxykSxQuSP47Ad+A9dWPkl/Zz
 +KEQ==
X-Gm-Message-State: AJIora/gsiHydjTrD27itapXWofUfqB+46n6a824lpX3frObz8Hk0qAt
 /8juvJWePCri6Y9HQaPDi4EN3ZA4xyKbOSQ=
X-Google-Smtp-Source: AGRyM1t88mNCQuFnccSlpGOSCk9jgtxhHZcG6Sh8zLF13Wlmgeyxvv/qTSUsifWO8aJvXQitrAdhGg==
X-Received: by 2002:ad4:5e8b:0:b0:470:2e7f:ac1e with SMTP id
 jl11-20020ad45e8b000000b004702e7fac1emr9098439qvb.3.1656550722148; 
 Wed, 29 Jun 2022 17:58:42 -0700 (PDT)
Received: from localhost (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
 by smtp.gmail.com with ESMTPSA id
 ca12-20020a05622a1f0c00b00307c87b8239sm11545690qtb.46.2022.06.29.17.58.41
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 29 Jun 2022 17:58:41 -0700 (PDT)
Date: Wed, 29 Jun 2022 20:58:40 -0400
From: Kent Overstreet <kent.overstreet@gmail.com>
To: Ming Lei <ming.lei@redhat.com>
Message-ID: <20220630005840.s65j5vab6j2dsyq2@moria.home.lan>
References: <20220626201458.ytn4mrix2pobm2mb@moria.home.lan>
 <Yrld9rLPY6L3MhlZ@T590>
 <20220628042610.wuittagsycyl4uwa@moria.home.lan>
 <YrqyiCcnvPCqsn8F@T590>
 <20220628163617.h3bmq3opd7yuiaop@moria.home.lan>
 <Yrs9OLNZ8xUs98OB@redhat.com>
 <20220628175253.s2ghizfucumpot5l@moria.home.lan>
 <YrvsDNltq+h6mphN@redhat.com>
 <20220629181154.eejrlfhj5n4la446@moria.home.lan>
 <YrzykX0jTWpq5DYQ@T590>
MIME-Version: 1.0
In-Reply-To: <YrzykX0jTWpq5DYQ@T590>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Spam-Signature: yes
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Dmitry Monakhov <dmonakhov@openvz.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Jun 30, 2022 at 08:47:13AM +0800, Ming Lei wrote:
> What is the difference between bio_set_pos and bio_rewind()? Both have
> to restore bio->bi_iter(the sector part and the bvec part).
> 
> Also how to update ->bi_done which 'counts bytes advanced'? You meant doing it in
> very bio_advance()? then no, why do we have to pay the cost for very unusual
> bio_rewind()?

Yeah, we'll have to add a u32 to bvec_iter, and increment it in bio_advance().

This would us everything we want - you'll be able to restore a bio to an initial
state and you just have to save 8 bytes, not a whole bvec_iter, and unlike
bio_rewind it'll be safe to use after calling submit_bio(), _and_ it solves the
problem that stashing a copy of bvec_iter doesn't save state in integrity or
crypt context.

> Or if I misunderstood your point, please cook a patch and I am happy to
> take a close look, and posting one very raw idea with random data
> structure looks not helpful much for this discussion technically.

I can do that...

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


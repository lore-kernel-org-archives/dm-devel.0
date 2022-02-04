Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EB88C433EF
	for <dm-devel@archiver.kernel.org>; Fri,  4 Feb 2022 14:43:56 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-193-PIfQd34ZP_W-x4mAnFGY_w-1; Fri, 04 Feb 2022 09:43:51 -0500
X-MC-Unique: PIfQd34ZP_W-x4mAnFGY_w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6689E1093343;
	Fri,  4 Feb 2022 14:43:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D2D622E0A;
	Fri,  4 Feb 2022 14:43:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 004BC4BB7C;
	Fri,  4 Feb 2022 14:43:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 214EhfM1003427 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Feb 2022 09:43:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 471E24292C6; Fri,  4 Feb 2022 14:43:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 43553401E66
	for <dm-devel@redhat.com>; Fri,  4 Feb 2022 14:43:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2B63B3802AC5
	for <dm-devel@redhat.com>; Fri,  4 Feb 2022 14:43:41 +0000 (UTC)
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com
	[209.85.214.175]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-674-_22Nt1YSMbu6H_mOMl6hbA-1; Fri, 04 Feb 2022 09:43:39 -0500
X-MC-Unique: _22Nt1YSMbu6H_mOMl6hbA-1
Received: by mail-pl1-f175.google.com with SMTP id x3so5327044pll.3
	for <dm-devel@redhat.com>; Fri, 04 Feb 2022 06:43:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
	:message-id:date:mime-version:content-transfer-encoding;
	bh=WutBl0QBGx1pfuztZArDy53so35nYoGLBU641tHFA5E=;
	b=KAM5B76BzH53bXfqMejVx9o/DTdDgvvkiR1V4ebZ0nxY0MVgRDzn9ion1SG4iAC1O9
	n5QqenjTvGxYeTI6mwf/gyQ1x5Y3RyCvgWirkRUD8QOEWF13aJGXBZeEhWa0abuwBU90
	iaHfoYQknsP4QUp4swJDtZJTq1WI4Mlyzxc/Eapiffw2V7NedAb1/Tn1Meu99npX+H1t
	8UJSjS71RsGTRu8/+64G4qGcBwKb5DATp+xB1JZ27TBaZdrKJ1SRj7a1LwMxFOGi16d8
	+5zT9LCHDY8mW4gf3Lf+OUWplcytljKopCGshSStE5VyKS0XT97Xd5vv+H+AN9cOPPUS
	lGBA==
X-Gm-Message-State: AOAM5320tlZJFUrMG6gdRvuGqb4Ch8gKsGbenMzzdjWs0Dzx/W7KU0PZ
	SSvO4gDhpVa/RkHK/fXGALymaQ==
X-Google-Smtp-Source: ABdhPJyjdkHc+scNtjJ/hehBMbW1t656mFAyg1ZRbmeSiQlqVZ7Age59IT9W0N6D7yrhQorPc/BDeA==
X-Received: by 2002:a17:90a:741:: with SMTP id
	s1mr3528802pje.161.1643985818424; 
	Fri, 04 Feb 2022 06:43:38 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
	by smtp.gmail.com with ESMTPSA id
	pf4sm15474779pjb.35.2022.02.04.06.43.37
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 04 Feb 2022 06:43:37 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@lst.de>
In-Reply-To: <20220202160109.108149-1-hch@lst.de>
References: <20220202160109.108149-1-hch@lst.de>
Message-Id: <164398581785.446137.16953674702943074856.b4-ty@kernel.dk>
Date: Fri, 04 Feb 2022 07:43:37 -0700
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Pavel Begunkov <asml.silence@gmail.com>, drbd-dev@lists.linbit.com
Subject: Re: [dm-devel] improve the bio cloning interface v2
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 2 Feb 2022 17:00:56 +0100, Christoph Hellwig wrote:
> this series changes the bio cloning interface to match the rest changes
> to the bio allocation interface and passes the block_device and operation
> to the cloning helpers.  In addition it renames the cloning helpers to
> be more descriptive.
> 
> To get there it requires a bit of refactoring in the device mapper code.
> 
> [...]

Applied, thanks!

[01/13] drbd: set ->bi_bdev in drbd_req_new
        commit: c347a787e34cba0e5a80a04082dacaf259105605
[02/13] dm: add a clone_to_tio helper
        commit: 6c23f0bd7f16d88c774db37b30c5da82811c41be
[03/13] dm: fold clone_bio into __clone_and_map_data_bio
        commit: b1bee79237ce0ab43ef7fe66aa6e5c4783165012
[04/13] dm: fold __send_duplicate_bios into __clone_and_map_simple_bio
        commit: 8eabf5d0a7bd9226d6cc25402dde67f372aae838
[05/13] dm: move cloning the bio into alloc_tio
        commit: dc8e2021da71f6b2d5971f98ee3e528cf30c409c
[06/13] dm: pass the bio instead of tio to __map_bio
        commit: 1561b396106d759fdf5f9a71b412e068f74d2cc9
[07/13] dm: retun the clone bio from alloc_tio
        commit: 1d1068cecff70cb8e48c7cb0ba27cc3fd906eb31
[08/13] dm: simplify the single bio fast path in __send_duplicate_bios
        commit: 891fced644a7529bfd4b1436b2341527ce8f68ad
[09/13] dm-cache: remove __remap_to_origin_clear_discard
        commit: 3c4b455ef8acdacd0e5ecd33428d4f32f861637a
[10/13] block: clone crypto and integrity data in __bio_clone_fast
        commit: 56b4b5abcdab6daf71c5536fca2772f178590e06
[11/13] dm: use bio_clone_fast in alloc_io/alloc_tio
        commit: 92986f6b4c8a2c24d3a36b80140624f80fd93de4
[12/13] block: initialize the target bio in __bio_clone_fast
        commit: a0e8de798dd6710a69d69ec57b246a0e34c4a695
[13/13] block: pass a block_device to bio_clone_fast
        commit: abfc426d1b2fb2176df59851a64223b58ddae7e7

Best regards,
-- 
Jens Axboe


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


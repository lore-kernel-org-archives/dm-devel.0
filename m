Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 792DEC6FA82
	for <dm-devel@archiver.kernel.org>; Wed, 21 Sep 2022 17:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663781292;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=DuIw6nS0b8vdv0ArcFxVFfOnbGmwqLzxSD1tdIngqMA=;
	b=R1IQJXTRxLIZ9xum4ywbcNygWNOhuYKOGnSpXJ2FMrMk1rHjtG4CSe4xoiXrlmUIrYVixl
	bl9LUUEGoFTqTB9ZvXI0EPk5Jy++S+s3L6bGxpuSPfBqIb1ILXjbJqlHFXIXBJncgZ5JqN
	XskDug3XiWXookuPzH/vXvRFaDn99EY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-227-7fNnBfDpNsemesWTuAgU0Q-1; Wed, 21 Sep 2022 13:28:09 -0400
X-MC-Unique: 7fNnBfDpNsemesWTuAgU0Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0E045882825;
	Wed, 21 Sep 2022 17:28:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 96C3A49BB60;
	Wed, 21 Sep 2022 17:28:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 78E2F19465B1;
	Wed, 21 Sep 2022 17:28:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AB2B919465A4
 for <dm-devel@listman.corp.redhat.com>; Wed, 21 Sep 2022 17:27:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8D7DB1121315; Wed, 21 Sep 2022 17:27:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 86AC51121314
 for <dm-devel@redhat.com>; Wed, 21 Sep 2022 17:27:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 61663384C6C1
 for <dm-devel@redhat.com>; Wed, 21 Sep 2022 17:27:36 +0000 (UTC)
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-590-sE5fi8XxPvyOr1kyL-gOHg-1; Wed, 21 Sep 2022 13:27:35 -0400
X-MC-Unique: sE5fi8XxPvyOr1kyL-gOHg-1
Received: by mail-qv1-f69.google.com with SMTP id
 nm17-20020a0562143b1100b004a5a3002d87so4729774qvb.8
 for <dm-devel@redhat.com>; Wed, 21 Sep 2022 10:27:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=jf1FYXrDVaqqC4NbZ8fFAHL8bcgUOrwJH0z7ee3/534=;
 b=mNAvfxF5AIyCZvAptTxNASREiUJk77e1Do4Zn/FfgaMHsJ2hw45ioaSo/V82sbMY4c
 S4ZUFXCwfu5jjRp+aRcwj7HhfDNLQouIIN9wFuDALogsaMwQrAdLK4liQ6I2B4dqXZ4D
 V8H7bY5LqBmV17C97yXIoM2BFCbRbR69tZ2e/X8S1G9+QMTD2a+cSzTHhe8wtDN0jyX3
 VP61/4y/GMBpNTFRO/tIDKB/Vrkx7ZokegdXD+j4u2woJFB1hoI5V3d84U44LOPlTKSC
 ogj0Q+R/dgo1Lv8Qc1Q0nzn72qD7RFIiUEc7wOYm63frfUUxo7Os2IvTCj+wMmYTfZa1
 yzOA==
X-Gm-Message-State: ACrzQf1FAkxBxjk4puZYPa85uC+RxD9SuJUkHzdgLws8cWxUKw2AQr7G
 D0yyRQPSQFzQHRsLzcO4DYU7mH5QlPE5aV5HlA7uEA0gKex7quLeIFUPEP4+OwFuiK2Pe2Tx/jk
 J1On8S0hUzKlzkw==
X-Received: by 2002:a05:622a:414:b0:35c:f297:ebfc with SMTP id
 n20-20020a05622a041400b0035cf297ebfcmr10981930qtx.420.1663781254252; 
 Wed, 21 Sep 2022 10:27:34 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6z1zbB3AmadTPASo43OhmHFT6jpU/kArRwI7nXi7rFyLGyH8LCRodE1M4MYgySQ0l8v7sRqg==
X-Received: by 2002:a05:622a:414:b0:35c:f297:ebfc with SMTP id
 n20-20020a05622a041400b0035cf297ebfcmr10981905qtx.420.1663781253957; 
 Wed, 21 Sep 2022 10:27:33 -0700 (PDT)
Received: from localhost ([217.138.198.196]) by smtp.gmail.com with ESMTPSA id
 w23-20020a05620a0e9700b006cbdc9f178esm2196842qkm.25.2022.09.21.10.27.33
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 21 Sep 2022 10:27:33 -0700 (PDT)
Date: Wed, 21 Sep 2022 13:27:32 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: damien.lemoal@opensource.wdc.com, Pankaj Raghav <p.raghav@samsung.com>
Message-ID: <YytJhEywBhqcr7MX@redhat.com>
References: <CGME20220920091120eucas1p2c82c18f552d6298d24547cba2f70b7fc@eucas1p2.samsung.com>
 <20220920091119.115879-1-p.raghav@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20220920091119.115879-1-p.raghav@samsung.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: [dm-devel] Please further explain Linux's "zoned storage" roadmap
 [was: Re: [PATCH v14 00/13] support zoned block devices with non-power-of-2
 zone sizes]
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
Cc: axboe@kernel.dk, bvanassche@acm.org, pankydev8@gmail.com,
 gost.dev@samsung.com, snitzer@kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, matias.bjorling@wdc.com, Johannes.Thumshirn@wdc.com,
 jaegeuk@kernel.org, hch@lst.de, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Sep 20 2022 at  5:11P -0400,
Pankaj Raghav <p.raghav@samsung.com> wrote:

> - Background and Motivation:
> 
> The zone storage implementation in Linux, introduced since v4.10, first
> targetted SMR drives which have a power of 2 (po2) zone size alignment
> requirement. The po2 zone size was further imposed implicitly by the
> block layer's blk_queue_chunk_sectors(), used to prevent IO merging
> across chunks beyond the specified size, since v3.16 through commit
> 762380ad9322 ("block: add notion of a chunk size for request merging").
> But this same general block layer po2 requirement for blk_queue_chunk_sectors()
> was removed on v5.10 through commit 07d098e6bbad ("block: allow 'chunk_sectors'
> to be non-power-of-2").
> 
> NAND, which is the media used in newer zoned storage devices, does not
> naturally align to po2. In these devices, zone capacity(cap) is not the
> same as the po2 zone size. When the zone cap != zone size, then unmapped
> LBAs are introduced to cover the space between the zone cap and zone size.
> po2 requirement does not make sense for these type of zone storage devices.
> This patch series aims to remove these unmapped LBAs for zoned devices when
> zone cap is npo2. This is done by relaxing the po2 zone size constraint
> in the kernel and allowing zoned device with npo2 zone sizes if zone cap
> == zone size.
> 
> Removing the po2 requirement from zone storage should be possible
> now provided that no userspace regression and no performance regressions are
> introduced. Stop-gap patches have been already merged into f2fs-tools to
> proactively not allow npo2 zone sizes until proper support is added [1].
> 
> There were two efforts previously to add support to npo2 devices: 1) via
> device level emulation [2] but that was rejected with a final conclusion
> to add support for non po2 zoned device in the complete stack[3] 2)
> adding support to the complete stack by removing the constraint in the
> block layer and NVMe layer with support to btrfs, zonefs, etc which was
> rejected with a conclusion to add a dm target for FS support [0]
> to reduce the regression impact.
> 
> This series adds support to npo2 zoned devices in the block and nvme
> layer and a new **dm target** is added: dm-po2zoned-target. This new
> target will be initially used for filesystems such as btrfs and
> f2fs until native npo2 zone support is added.

As this patchset nears the point of being "ready for merge" and DM's
"zoned" oriented targets are multiplying, I need to understand: where
are we collectively going?  How long are we expecting to support the
"stop-gap zoned storage" layers we've constructed?

I know https://zonedstorage.io/docs/introduction exists... but it
_seems_ stale given the emergence of ZNS and new permutations of zoned
hardware. Maybe that isn't quite fair (it does cover A LOT!) but I'm
still left wanting (e.g. "bring it all home for me!")...

Damien, as the most "zoned storage" oriented engineer I know, can you
please kick things off by shedding light on where Linux is now, and
where it's going, for "zoned storage"?

To give some additional context to help me when you answer: I'm left
wondering what, if any, role dm-zoned has to play moving forward given
ZNS is "the future" (and yeah "the future" is now but...)?  E.g.: Does
it make sense to stack dm-zoned ontop of dm-po2zoned!?

Yet more context: When I'm asked to add full-blown support for
dm-zoned to RHEL my gut is "please no, why!?".  And if we really
should add dm-zoned is dm-po2zoned now also a requirement (to support
non-power-of-2 ZNS devices in our never-ending engineering of "zoned
storage" compatibility stop-gaps)?

In addition, it was my understanding that WDC had yet another zoned DM
target called "dm-zap" that is for ZNS based devices... It's all a bit
messy in my head (that's on me for not keeping up, but I think we need
a recap!)

So please help me, and others, become more informed as quickly as
possible! ;)

Thanks,
Mike

ps. I'm asking all this in the open on various Linux mailing lists
because it doesn't seem right to request a concall to inform only
me... I think others may need similar "zoned storage" help.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


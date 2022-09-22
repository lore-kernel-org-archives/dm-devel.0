Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37E3EC54EE9
	for <dm-devel@archiver.kernel.org>; Thu, 22 Sep 2022 19:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663875436;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=bUCYk+S/hipupqC202g/+kMDLbR9DhRtwVhrVCOhqqo=;
	b=AR2gKWTxbzE1HL5aSQYZ0iieFhI6Nfo+1QCeybnIZGUrtj03s1Z8aD1EntLWR1zYnwD+gE
	3k8hwv8ESwQ32TSL6qpP9d2oDI2i7oT9VWii7jJqxztfJ2wLmhazrffV6pSsw+DKpRLEBS
	p09/MJEuMy6HHVfBQO1Z/qoqTyOUfkc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-149-XIPH6XnQPWCdpadxtJOUIQ-1; Thu, 22 Sep 2022 15:37:12 -0400
X-MC-Unique: XIPH6XnQPWCdpadxtJOUIQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F294F1C0512F;
	Thu, 22 Sep 2022 19:37:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 38ACE477F5C;
	Thu, 22 Sep 2022 19:37:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F0CF919465B6;
	Thu, 22 Sep 2022 19:37:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8294519465A4
 for <dm-devel@listman.corp.redhat.com>; Thu, 22 Sep 2022 19:37:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 72F7C6352E; Thu, 22 Sep 2022 19:37:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6A9C54EA61
 for <dm-devel@redhat.com>; Thu, 22 Sep 2022 19:37:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A02D87B2A0
 for <dm-devel@redhat.com>; Thu, 22 Sep 2022 19:37:07 +0000 (UTC)
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-649--JuxA7SIMbeYVCxv7REFMQ-1; Thu, 22 Sep 2022 15:37:04 -0400
X-MC-Unique: -JuxA7SIMbeYVCxv7REFMQ-1
Received: by mail-qk1-f198.google.com with SMTP id
 h8-20020a05620a284800b006b5c98f09fbso7443634qkp.21
 for <dm-devel@redhat.com>; Thu, 22 Sep 2022 12:37:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=rERQeRLk6iWsos2UmkmvbVMjyj1EWySRrEtJrBO4h4Y=;
 b=CLHnSD5MG8q5FJ2G1aX31931Y2JOwwHYK2hLwi3baKhVgxjiSgCYJq9usg7Dd4ApwJ
 YQi8srUdzb/rTp/OPKLmyRgTDZ7aGWmGMc2WBrNTFHMbXsSi5quQMlXfgLZSk6IjQ3Gi
 GWkeESUgocVZ2THrSaaGYdS8xbwNxqwq9CvwGQYLahUSQif71I7GRAE3vFiSLCHSfGYa
 vGPoPBy+NepeVRztJ83pwBF/0BEbX3DiPsygBnM3hvBaPswRQpbHXcsIGGhDXWXieYqk
 9K2rso1/y8vrZnQ+MCT80MWZ4iphov535uK/hQP8wKroLGk8UX6UW3UVWR6YNxrtb9fE
 UPkg==
X-Gm-Message-State: ACrzQf1sE7sFLfJ/ZAo5/zI4bRQIZ/eMu9qvQc5LPVJRh0VIPHpenOJY
 JqmI+PfxwNy+7iHP38YZv5IerbzwnkXk2OxcyZQiIkpv1TSeQ/7vAE+wSXzWhU1txpWuTx2zQw+
 3Hb6HRY3o5yGckA==
X-Received: by 2002:a05:620a:15f2:b0:6ce:dea8:1d6d with SMTP id
 p18-20020a05620a15f200b006cedea81d6dmr3356148qkm.324.1663875423425; 
 Thu, 22 Sep 2022 12:37:03 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7Gh6yqO6EUXrtfv7UsM7htLnKxemapjlfZVl58O6Xzz8jniK66rHh4oKk3Qsil7SKcL3dprA==
X-Received: by 2002:a05:620a:15f2:b0:6ce:dea8:1d6d with SMTP id
 p18-20020a05620a15f200b006cedea81d6dmr3356136qkm.324.1663875423127; 
 Thu, 22 Sep 2022 12:37:03 -0700 (PDT)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 k16-20020a05620a415000b006cbe3be300esm4768662qko.12.2022.09.22.12.37.02
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 22 Sep 2022 12:37:02 -0700 (PDT)
Date: Thu, 22 Sep 2022 15:37:01 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Message-ID: <Yyy5XUUWGkU8B3IP@redhat.com>
References: <CGME20220920091120eucas1p2c82c18f552d6298d24547cba2f70b7fc@eucas1p2.samsung.com>
 <20220920091119.115879-1-p.raghav@samsung.com>
 <YytJhEywBhqcr7MX@redhat.com>
 <7dd9dbc0-b08b-fa47-5452-d448d86ca56b@opensource.wdc.com>
MIME-Version: 1.0
In-Reply-To: <7dd9dbc0-b08b-fa47-5452-d448d86ca56b@opensource.wdc.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] Please further explain Linux's "zoned storage"
 roadmap [was: Re: [PATCH v14 00/13] support zoned block devices with
 non-power-of-2 zone sizes]
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
Cc: Pankaj Raghav <p.raghav@samsung.com>, axboe@kernel.dk, bvanassche@acm.org,
 pankydev8@gmail.com, gost.dev@samsung.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, matias.bjorling@wdc.com,
 Johannes.Thumshirn@wdc.com, jaegeuk@kernel.org, hch@lst.de, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Sep 21 2022 at  7:55P -0400,
Damien Le Moal <damien.lemoal@opensource.wdc.com> wrote:

> On 9/22/22 02:27, Mike Snitzer wrote:
> > On Tue, Sep 20 2022 at  5:11P -0400,
> > Pankaj Raghav <p.raghav@samsung.com> wrote:
> > 
> >> - Background and Motivation:
> >>
> >> The zone storage implementation in Linux, introduced since v4.10, first
> >> targetted SMR drives which have a power of 2 (po2) zone size alignment
> >> requirement. The po2 zone size was further imposed implicitly by the
> >> block layer's blk_queue_chunk_sectors(), used to prevent IO merging
> >> across chunks beyond the specified size, since v3.16 through commit
> >> 762380ad9322 ("block: add notion of a chunk size for request merging").
> >> But this same general block layer po2 requirement for blk_queue_chunk_sectors()
> >> was removed on v5.10 through commit 07d098e6bbad ("block: allow 'chunk_sectors'
> >> to be non-power-of-2").
> >>
> >> NAND, which is the media used in newer zoned storage devices, does not
> >> naturally align to po2. In these devices, zone capacity(cap) is not the
> >> same as the po2 zone size. When the zone cap != zone size, then unmapped
> >> LBAs are introduced to cover the space between the zone cap and zone size.
> >> po2 requirement does not make sense for these type of zone storage devices.
> >> This patch series aims to remove these unmapped LBAs for zoned devices when
> >> zone cap is npo2. This is done by relaxing the po2 zone size constraint
> >> in the kernel and allowing zoned device with npo2 zone sizes if zone cap
> >> == zone size.
> >>
> >> Removing the po2 requirement from zone storage should be possible
> >> now provided that no userspace regression and no performance regressions are
> >> introduced. Stop-gap patches have been already merged into f2fs-tools to
> >> proactively not allow npo2 zone sizes until proper support is added [1].
> >>
> >> There were two efforts previously to add support to npo2 devices: 1) via
> >> device level emulation [2] but that was rejected with a final conclusion
> >> to add support for non po2 zoned device in the complete stack[3] 2)
> >> adding support to the complete stack by removing the constraint in the
> >> block layer and NVMe layer with support to btrfs, zonefs, etc which was
> >> rejected with a conclusion to add a dm target for FS support [0]
> >> to reduce the regression impact.
> >>
> >> This series adds support to npo2 zoned devices in the block and nvme
> >> layer and a new **dm target** is added: dm-po2zoned-target. This new
> >> target will be initially used for filesystems such as btrfs and
> >> f2fs until native npo2 zone support is added.
> > 
> > As this patchset nears the point of being "ready for merge" and DM's
> > "zoned" oriented targets are multiplying, I need to understand: where
> > are we collectively going?  How long are we expecting to support the
> > "stop-gap zoned storage" layers we've constructed?
> > 
> > I know https://zonedstorage.io/docs/introduction exists... but it
> > _seems_ stale given the emergence of ZNS and new permutations of zoned
> > hardware. Maybe that isn't quite fair (it does cover A LOT!) but I'm
> > still left wanting (e.g. "bring it all home for me!")...
> > 
> > Damien, as the most "zoned storage" oriented engineer I know, can you
> > please kick things off by shedding light on where Linux is now, and
> > where it's going, for "zoned storage"?
> 
> Let me first start with what we have seen so far with deployments in the
> field.

<snip>

Thanks for all your insights on zoned storage, very appreciated!

> > In addition, it was my understanding that WDC had yet another zoned DM
> > target called "dm-zap" that is for ZNS based devices... It's all a bit
> > messy in my head (that's on me for not keeping up, but I think we need
> > a recap!)
> 
> Since the ZNS specification does not define conventional zones, dm-zoned
> cannot be used as a standalone DM target (read: single block device) with
> NVMe zoned block devices. Furthermore, due to its block mapping scheme,
> dm-zoned does not support devices with zones that have a capacity lower
> than the zone size. So ZNS is really a big *no* for dm-zoned. dm-zap is a
> prototype and in a nutshell is the equivalent of dm-zoned for ZNS. dm-zap
> can deal with the smaller zone capacity and does not require conventional
> zones. We are not trying to push for dm-zap to be merged for now as we are
> still evaluating its potential use cases. We also have a different but
> functionally equivalent approach implemented as a block device driver that
> we are evaluating internally.
> 
> Given the above mentioned usage pattern we have seen so far for zoned
> storage, it is not yet clear if something like dm-zap for ZNS is needed
> beside some niche use cases.

OK, good to know.  I do think dm-zoned should be trained to _not_
allow use with ZNS NVMe devices (maybe that is in place and I just
missed it?).  Because there is some confusion with at least one
customer that is asserting dm-zoned is somehow enabling them to use
ZNS NVMe devices!

Maybe they somehow don't _need_ conventional zones (writes are handled
by some other layer? and dm-zoned access is confined to read only)!?
And might they also be using ZNS NVMe devices to do _not_ have a
zone capacity lower than the zone size?

Or maybe they are mistaken and we should ask more specific questions
of them?

> > So please help me, and others, become more informed as quickly as
> > possible! ;)
> 
> I hope the above helps. If you want me to develop further any of the
> points above, feel free to let me know.

You've been extremely helpful, thanks!

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


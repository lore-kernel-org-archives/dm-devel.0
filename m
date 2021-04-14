Return-Path: <SRS0=OBV6=JL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45660C433B4
	for <dm-devel@archiver.kernel.org>; Wed, 14 Apr 2021 07:00:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B2FCB61242
	for <dm-devel@archiver.kernel.org>; Wed, 14 Apr 2021 06:59:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B2FCB61242
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-539-dbuI5L_jNDus7hdCKjYYDw-1; Wed, 14 Apr 2021 02:59:56 -0400
X-MC-Unique: dbuI5L_jNDus7hdCKjYYDw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 082E56D241;
	Wed, 14 Apr 2021 06:59:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 88D1F19C78;
	Wed, 14 Apr 2021 06:59:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E157B1806D0F;
	Wed, 14 Apr 2021 06:59:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13E6wxbn009813 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 14 Apr 2021 02:58:59 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6D19A112CA3D; Wed, 14 Apr 2021 06:58:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6802C112CA3C
	for <dm-devel@redhat.com>; Wed, 14 Apr 2021 06:58:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9DFA985A5A8
	for <dm-devel@redhat.com>; Wed, 14 Apr 2021 06:58:56 +0000 (UTC)
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com
	[209.85.166.50]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-375-2aGMjCNVMa6ARO780Lap5g-1; Wed, 14 Apr 2021 02:58:52 -0400
X-MC-Unique: 2aGMjCNVMa6ARO780Lap5g-1
Received: by mail-io1-f50.google.com with SMTP id v123so12795353ioe.10;
	Tue, 13 Apr 2021 23:58:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=iPvXMTpUNl3IxdG2GdqWLZcBOjF3pDi559BGFj5cKe8=;
	b=ulDAiAjE/0UR9zxMewwrM8X4f6pejw2iYoe48++KfwpA7U2kJQsm/v5PSK5mWXwTEP
	2zZUJITL3rYykFePimGmxP8Qg0vgYIT2CtKvqxfX17OrCSC27zef/i3W3kyMCYJBug9c
	HfYjEj2bCQ4K7Vp1yNXSRNZK+e36EVEnYNtRgMihQ0tMvbSjYGJSOHjCjhBwBeRqezXB
	mD2Fgt609nLasL5KX3hprnH31dNY4aunCL47VBaWZ+3s1TYxE+1ej0IMi5FhP03TmUl6
	2t96/Pv6AmhJ5D3eHC5zkdUMos5VG6cVS+cvelUvE8j679v+tzZ4zH6iFp0rYiC1L4Lo
	of6g==
X-Gm-Message-State: AOAM533B0HUM1B4n4zbkAx7AhXx41Jyo+qUwlTiy8MOIMTgW0yQ8pmAt
	FJeHBS2DSqd3phtDM14fbFHLM2goHfC4osLx2Cg=
X-Google-Smtp-Source: ABdhPJxVn0379a/e+lrGuK9nJvBnaVZRkG+95gHH+6KyBvsrtfKcHhnhaQQ04D+xJ04y9zRQrXsU7onZw/arekICxKA=
X-Received: by 2002:a6b:f909:: with SMTP id j9mr30365082iog.138.1618383531741; 
	Tue, 13 Apr 2021 23:58:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210219124517.79359-1-selvakuma.s1@samsung.com>
	<CGME20210219124603epcas5p33add0f2c1781b2a4d71bf30c9e1ac647@epcas5p3.samsung.com>
	<20210219124517.79359-3-selvakuma.s1@samsung.com>
	<BL0PR04MB6514EA91680D33A5890ECE16E7839@BL0PR04MB6514.namprd04.prod.outlook.com>
	<CAHqX9vb6GgaU9QdTQaq3=dGuoNCuWorLrGCF8gC5LEdFBESFcA@mail.gmail.com>
	<BL0PR04MB6514B34000467FABFD6BF385E7709@BL0PR04MB6514.namprd04.prod.outlook.com>
	<CAHqX9vYvtOaVL4LG0gAGCMz+a8uha8czH==Dgg3eG+TWA+xeVQ@mail.gmail.com>
	<BL0PR04MB65146169A9C7527280C15D4AE74F9@BL0PR04MB6514.namprd04.prod.outlook.com>
In-Reply-To: <BL0PR04MB65146169A9C7527280C15D4AE74F9@BL0PR04MB6514.namprd04.prod.outlook.com>
From: Selva Jove <selvajove@gmail.com>
Date: Wed, 14 Apr 2021 12:28:39 +0530
Message-ID: <CAHqX9vYPVwYLT5Bdk_GqKZWxpJNib9fYidEmT0j+bRikwyLgKw@mail.gmail.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: bulk
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "kch@kernel.org" <kch@kernel.org>,
	SelvaKumar S <selvakuma.s1@samsung.com>,
	"sagi@grimberg.me" <sagi@grimberg.me>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"nj.shetty@samsung.com" <nj.shetty@samsung.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"joshi.k@samsung.com" <joshi.k@samsung.com>,
	"javier.gonz@samsung.com" <javier.gonz@samsung.com>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	"joshiiitr@gmail.com" <joshiiitr@gmail.com>, "hch@lst.de" <hch@lst.de>
Subject: Re: [dm-devel] [RFC PATCH v5 2/4] block: add simple copy support
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

I agree with you. Will remove BLKDEV_COPY_NOEMULATION.

On Tue, Apr 13, 2021 at 6:03 AM Damien Le Moal <Damien.LeMoal@wdc.com> wrote:
>
> On 2021/04/12 23:35, Selva Jove wrote:
> > On Mon, Apr 12, 2021 at 5:55 AM Damien Le Moal <Damien.LeMoal@wdc.com> wrote:
> >>
> >> On 2021/04/07 20:33, Selva Jove wrote:
> >>> Initially I started moving the dm-kcopyd interface to the block layer
> >>> as a generic interface.
> >>> Once I dig deeper in dm-kcopyd code, I figured that dm-kcopyd is
> >>> tightly coupled with dm_io()
> >>>
> >>> To move dm-kcopyd to block layer, it would also require dm_io code to
> >>> be moved to block layer.
> >>> It would cause havoc in dm layer, as it is the backbone of the
> >>> dm-layer and needs complete
> >>> rewriting of dm-layer. Do you see any other way of doing this without
> >>> having to move dm_io code
> >>> or to have redundant code ?
> >>
> >> Right. Missed that. So reusing dm-kcopyd and making it a common interface will
> >> take some more efforts. OK, then. For the first round of commits, let's forget
> >> about this. But I still think that your emulation could be a lot better than a
> >> loop doing blocking writes after blocking reads.
> >>
> >
> > Current implementation issues read asynchronously and once all the reads are
> > completed, then the write is issued as whole to reduce the IO traffic
> > in the queue.
> > I agree that things can be better. Will explore another approach of
> > sending writes
> > immediately once reads are completed and with  plugging to increase the chances
> > of merging.
> >
> >> [...]
> >>>>> +int blkdev_issue_copy(struct block_device *src_bdev, int nr_srcs,
> >>>>> +             struct range_entry *src_rlist, struct block_device *dest_bdev,
> >>>>> +             sector_t dest, gfp_t gfp_mask, int flags)
> >>>>> +{
> >>>>> +     struct request_queue *q = bdev_get_queue(src_bdev);
> >>>>> +     struct request_queue *dest_q = bdev_get_queue(dest_bdev);
> >>>>> +     struct blk_copy_payload *payload;
> >>>>> +     sector_t bs_mask, copy_size;
> >>>>> +     int ret;
> >>>>> +
> >>>>> +     ret = blk_prepare_payload(src_bdev, nr_srcs, src_rlist, gfp_mask,
> >>>>> +                     &payload, &copy_size);
> >>>>> +     if (ret)
> >>>>> +             return ret;
> >>>>> +
> >>>>> +     bs_mask = (bdev_logical_block_size(dest_bdev) >> 9) - 1;
> >>>>> +     if (dest & bs_mask) {
> >>>>> +             return -EINVAL;
> >>>>> +             goto out;
> >>>>> +     }
> >>>>> +
> >>>>> +     if (q == dest_q && q->limits.copy_offload) {
> >>>>> +             ret = blk_copy_offload(src_bdev, payload, dest, gfp_mask);
> >>>>> +             if (ret)
> >>>>> +                     goto out;
> >>>>> +     } else if (flags & BLKDEV_COPY_NOEMULATION) {
> >>>>
> >>>> Why ? whoever calls blkdev_issue_copy() wants a copy to be done. Why would that
> >>>> user say "Fail on me if the device does not support copy" ??? This is a weird
> >>>> interface in my opinion.
> >>>>
> >>>
> >>> BLKDEV_COPY_NOEMULATION flag was introduced to allow blkdev_issue_copy() callers
> >>> to use their native copying method instead of the emulated copy that I
> >>> added. This way we
> >>> ensure that dm uses the hw-assisted copy and if that is not present,
> >>> it falls back to existing
> >>> copy method.
> >>>
> >>> The other users who don't have their native emulation can use this
> >>> emulated-copy implementation.
> >>
> >> I do not understand. Emulation or not should be entirely driven by the device
> >> reporting support for simple copy (or not). It does not matter which component
> >> is issuing the simple copy call: an FS to a real device, and FS to a DM device
> >> or a DM target driver. If the underlying device reported support for simple
> >> copy, use that. Otherwise, emulate with read/write. What am I missing here ?
> >>
> >
> > blkdev_issue_copy() api will generally complete the copy-operation,
> > either by using
> > offloaded-copy or by using emulated-copy. The caller of the api is not
> > required to
> > figure the type of support. However, it can opt out of emulated-copy
> > by specifying
> > the flag BLKDEV_NOEMULATION. This is helpful for the case when the
> > caller already
> > has got a sophisticated emulation (e.g. dm-kcopyd users).
>
> This does not make any sense to me. If the user has already another mean of
> doing copies, then that user will not call blkdev_issue_copy(). So I really do
> not understand what the "opting out of emulated copy" would be useful for. That
> user can check the simple copy support glag in the device request queue and act
> accordingly: use its own block copy code when simple copy is not supported or
> use blkdev_issue_copy() when the device has simple copy. Adding that
> BLKDEV_COPY_NOEMULATION does not serve any purpose at all.
>
>
>
> --
> Damien Le Moal
> Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <SRS0=RcAx=E2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91F6BC63697
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 01:27:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F3AE022254
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 01:27:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AV+2px4T"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F3AE022254
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1605835651;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9wrLe8bVJHR/cFT1N7bizSBnPDhvXpHOIHrajP8iEyw=;
	b=AV+2px4Th5Sr5PO2/Kp1DlqfMYhCCKfKCGppwDPsdBz7ywg36OTt/23ZQW1GPtzTOCs4MF
	WWp2i31uriuiaJFSRN2CHR63AofuT4XjL/ZjlQlPlYgAjUoEf9RuXniPyj+3E8WlzydP3u
	6qfvJqAmRcomwdz3xfYhWZsgv3Qw7pM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-UWAP5J83N4imWQQTX1FL_A-1; Thu, 19 Nov 2020 20:27:29 -0500
X-MC-Unique: UWAP5J83N4imWQQTX1FL_A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 97B05107ACE3;
	Fri, 20 Nov 2020 01:27:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4575260BE2;
	Fri, 20 Nov 2020 01:27:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 16BC84A7C6;
	Fri, 20 Nov 2020 01:27:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AK1RLT3005933 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 19 Nov 2020 20:27:21 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id EFD2F2166B29; Fri, 20 Nov 2020 01:27:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E8DFD2166B2B
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 01:27:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5DD3885828C
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 01:27:16 +0000 (UTC)
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com
	[209.85.222.72]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-326-bfOI9NCBNuC1Ihkd0iPujQ-1; Thu, 19 Nov 2020 20:27:15 -0500
X-MC-Unique: bfOI9NCBNuC1Ihkd0iPujQ-1
Received: by mail-ua1-f72.google.com with SMTP id f6so2494297uao.5
	for <dm-devel@redhat.com>; Thu, 19 Nov 2020 17:27:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=DLIVQHvx6BWBfd7HmGxTRnB/+14KaYzo8H+szC2YlPI=;
	b=kZ4Qy71YzYMKO+thhjrfRW0H5VoinnGezRuk6AEarI42VZnRq7IvK+ueDlzyAmt5CF
	A7mwWnGnckn3ddy5MkiGh/VL8D8mI6NM6X5NXxm5aZD+kAYB0s3mbIt6HQitWHa/th3U
	320FSGUoUcBwF5q0W3OhuuMEFfIAQVYnvw9LZB9UOHynlk84N5o6h6B0gc7TKGMoD84Z
	vQ1bACBETbvtoQ1hSErmNkJ5bju+wCXp3qOmdsj4qS2xmdsxOpJf555AvZF3sZpcENUo
	PI/tEmd2tjDDPXSvZZKLR3NPfr7jX6+MVJKURwcKQJgtsROWpyhWR4bvaUz82XllBLVF
	J95w==
X-Gm-Message-State: AOAM530sfLhnl5hQsm04ubZPAUmSw7NN5Xgax7Ir5rlTbwnXfiYDOC0A
	3ioH70nIVx7Uy539HImVSwk764+0HYwSdZgpaPGD7ovpGTJyU10hkTf0UWl/lhUhi3DD1Ru960F
	OxxAFbta35HwUr0oWyH+DduuBrYrBp1w=
X-Received: by 2002:a67:ead4:: with SMTP id s20mr9956265vso.23.1605835633574; 
	Thu, 19 Nov 2020 17:27:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxAOprCn+MSLwpUL1KRNzUeNpOM1FggL7enU/sNOGdCf/2dwEQ+lfxQplsQG9tT32TFdvR6vVegizOMc4DLrrs=
X-Received: by 2002:a67:ead4:: with SMTP id s20mr9956250vso.23.1605835633366; 
	Thu, 19 Nov 2020 17:27:13 -0800 (PST)
MIME-Version: 1.0
References: <20200821020345.3358-1-thunder.leizhen@huawei.com>
	<b4643e74-aad9-385f-01f2-f8e48ba4dbef@suse.de>
	<ad100923-e479-faf0-f749-ac8e4cf87899@huawei.com>
	<8aa638b7-6cfd-bf3d-8015-fbe59f28f31f@suse.de>
	<c2f8cf50-d9f7-df19-40eb-0543e6208c0d@huawei.com>
In-Reply-To: <c2f8cf50-d9f7-df19-40eb-0543e6208c0d@huawei.com>
From: John Dorminy <jdorminy@redhat.com>
Date: Thu, 19 Nov 2020 20:27:02 -0500
Message-ID: <CAMeeMh_iBFpmSjgm8aC1WO-=iQPU5rQ2-Z6oe0L8nt5ke=+XQw@mail.gmail.com>
To: "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>, Coly Li <colyli@suse.de>,
	linux-block <linux-block@vger.kernel.org>, dm-devel <dm-devel@redhat.com>,
	linux-bcache <linux-bcache@vger.kernel.org>,
	Kent Overstreet <kent.overstreet@gmail.com>,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 1/1] block: move the PAGE_SECTORS definition
	into <linux/blkdev.h>
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Greetings;

There are a lot of uses of PAGE_SIZE/SECTOR_SIZE scattered around, and
it seems like a medium improvement to be able to refer to it as
PAGE_SECTORS everywhere instead of just inside dm, bcache, and
null_blk. Did this change progress forward somewhere?

Thanks!

John Dorminy


On Mon, Sep 7, 2020 at 3:40 AM Leizhen (ThunderTown)
<thunder.leizhen@huawei.com> wrote:
>
> Hi, Jens Axboe, Alasdair Kergon, Mike Snitzer:
>   What's your opinion?
>
>
> On 2020/8/21 15:05, Coly Li wrote:
> > On 2020/8/21 14:48, Leizhen (ThunderTown) wrote:
> >>
> >>
> >> On 8/21/2020 12:11 PM, Coly Li wrote:
> >>> On 2020/8/21 10:03, Zhen Lei wrote:
> >>>> There are too many PAGE_SECTORS definitions, and all of them are the
> >>>> same. It looks a bit of a mess. So why not move it into <linux/blkdev.h>,
> >>>> to achieve a basic and unique definition.
> >>>>
> >>>> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> >>>
> >>>
> >>> A lazy question about page size > 4KB: currently in bcache code the
> >>> sector size is assumed to be 512 sectors, if kernel page > 4KB, it is
> >>> possible that PAGE_SECTORS in bcache will be a number > 8 ?
> >>
> >> Sorry, I don't fully understand your question. I known that the sector size
> >> can be 512 or 4K, and the PAGE_SIZE can be 4K or 64K. So even if sector size
> >> is 4K, isn't it greater than 8 for 64K pages?
> >>
> >> I'm not sure if the question you're asking is the one Matthew Wilcox has
> >> answered before:
> >> https://www.spinics.net/lists/raid/msg64345.html
> >
> > Thank you for the above information. Currently bcache code assumes
> > sector size is always 512 bytes, you may see how many "<< 9" or ">> 9"
> > are used. Therefore I doubt whether current code may stably work on e.g.
> > 4Kn SSDs (this is only doubt because I don't have such SSD).
> >
> > Anyway your patch is fine to me. This change to bcache doesn't make
> > thins worse or better, maybe it can be helpful to trigger my above
> > suspicious early if people do have this kind of problem on 4Kn sector SSDs.
> >
> > For the bcache part of this patch, you may add,
> > Acked-by: Coly Li <colyli@suse.de>
> >
> > Thanks.
> >
> > Coly Li
> >
> >>>> ---
> >>>>  drivers/block/brd.c           | 1 -
> >>>>  drivers/block/null_blk_main.c | 1 -
> >>>>  drivers/md/bcache/util.h      | 2 --
> >>>>  include/linux/blkdev.h        | 5 +++--
> >>>>  include/linux/device-mapper.h | 1 -
> >>>>  5 files changed, 3 insertions(+), 7 deletions(-)
> >>>>
> >>>
> >>> [snipped]
> >>>
> >>>> diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
> >>>> index c029f7443190805..55196e0f37c32c6 100644
> >>>> --- a/drivers/md/bcache/util.h
> >>>> +++ b/drivers/md/bcache/util.h
> >>>> @@ -15,8 +15,6 @@
> >>>>
> >>>>  #include "closure.h"
> >>>>
> >>>> -#define PAGE_SECTORS              (PAGE_SIZE / 512)
> >>>> -
> >>>>  struct closure;
> >>>>
> >>>>  #ifdef CONFIG_BCACHE_DEBUG
> >>>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> >>>> index bb5636cc17b91a7..b068dfc5f2ef0ab 100644
> >>>> --- a/include/linux/blkdev.h
> >>>> +++ b/include/linux/blkdev.h
> >>>> @@ -949,11 +949,12 @@ static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
> >>>>   * multiple of 512 bytes. Hence these two constants.
> >>>>   */
> >>>>  #ifndef SECTOR_SHIFT
> >>>> -#define SECTOR_SHIFT 9
> >>>> +#define SECTOR_SHIFT              9
> >>>>  #endif
> >>>>  #ifndef SECTOR_SIZE
> >>>> -#define SECTOR_SIZE (1 << SECTOR_SHIFT)
> >>>> +#define SECTOR_SIZE               (1 << SECTOR_SHIFT)
> >>>>  #endif
> >>>> +#define PAGE_SECTORS              (PAGE_SIZE / SECTOR_SIZE)
> >>>>
> >>>>  /*
> >>>>   * blk_rq_pos()                   : the current sector
> >>> [snipped]
> >>>
> >>>
> >>
> >
> >
> > .
> >
>

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


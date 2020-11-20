Return-Path: <SRS0=RcAx=E2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	HTML_MESSAGE,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06853C388F9
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 01:00:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4578A2224D
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 01:00:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KkXdNPXO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4578A2224D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1605834011;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=QIqfusJEt3AsyaDIwf/u5fmZ9sM2R9oVnrAT9/zJtZ8=;
	b=KkXdNPXOIWt7PlvnLXFDAs+SpUstv2mtqqEoP4+MP16JggF4OXGliAt7/2juI7AFXkoesv
	33qEhwPlGxhDxusxlaD2FfYN6PI3vOYR3iC+aHrweKFLvklqhwcNLZa7MfbwflySiT1jCE
	I8Zl6Gi5W0YGBgllNkOdfXo96rQiQUs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-531-ypJV_nH4NqKHH90iT2Fpgw-1; Thu, 19 Nov 2020 20:00:06 -0500
X-MC-Unique: ypJV_nH4NqKHH90iT2Fpgw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CDED41005D4E;
	Fri, 20 Nov 2020 01:00:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 35AB05D6A8;
	Fri, 20 Nov 2020 01:00:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AD456180954D;
	Fri, 20 Nov 2020 00:59:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AK0xtDl032728 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 19 Nov 2020 19:59:55 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 65ACCE2A92; Fri, 20 Nov 2020 00:59:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F35AE2A76
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 00:59:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E8A37103B800
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 00:59:52 +0000 (UTC)
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com
	[209.85.221.197]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-312-WoT8ZrExO9GuNCrSfb30rg-1; Thu, 19 Nov 2020 19:59:51 -0500
X-MC-Unique: WoT8ZrExO9GuNCrSfb30rg-1
Received: by mail-vk1-f197.google.com with SMTP id s1so3386345vks.6
	for <dm-devel@redhat.com>; Thu, 19 Nov 2020 16:59:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=EfK/6FKj71lzBvN4hJXQtoqOxzgX84K25n3NBNB+dM8=;
	b=CHOBrQEpqiJR+oKf6QIxQpMX6lsfAQPsnfrn4lzQE1GhBa/Xx7WtO97QJPjXeKohd9
	UansHagrJJObXXs0qu/wo4k+AHm6PmF95BRBqcEAA76sMexj/+aFRUgH00/CIWt1yTrY
	KQokUI8LFpkpLvWiLvX7FYq0WSjY5hFeWjSbh6UH2XxjPnEWhX3BUEsLkPSKZEocztj0
	Sh54n0umfBo5cvW4GDDBQ25jNF5sSsvABl05q4MfptCcmBHnsVKJBLN6gcBxsTZebTjx
	NMuvGbdvHIO2DI5IK7JTQpM3Rg4QFmyz7j3oKgA1buWmKI7WAnWnboRCG1prjO8CJXPJ
	6n2w==
X-Gm-Message-State: AOAM533lJvpWDCQzTvvHt70HnVKbyTQLrbEsp5bCvsE/54Ync8nkMSjB
	qQT+L/Lzy3H5kyQNARHooHbbYKx/wv4GJ9FH9yCvCFq22D2kVugro3TteRVzbPLxoT/W9UZMtiD
	n3dmhyq7IUHPN7pAXHp2qQFRwAlvj7W4=
X-Received: by 2002:ab0:4d6a:: with SMTP id k42mr3988658uag.131.1605833990015; 
	Thu, 19 Nov 2020 16:59:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzeUcWkQMSCfm7W4baUu5aRVT25+mk3+q62IxRaFrgyf87SDXcaM/SQOKYGTLLUeCzq9rF61Nl+oJ8My7XWPzA=
X-Received: by 2002:ab0:4d6a:: with SMTP id k42mr3988649uag.131.1605833989827; 
	Thu, 19 Nov 2020 16:59:49 -0800 (PST)
MIME-Version: 1.0
References: <20200821020345.3358-1-thunder.leizhen@huawei.com>
	<b4643e74-aad9-385f-01f2-f8e48ba4dbef@suse.de>
	<ad100923-e479-faf0-f749-ac8e4cf87899@huawei.com>
	<8aa638b7-6cfd-bf3d-8015-fbe59f28f31f@suse.de>
	<c2f8cf50-d9f7-df19-40eb-0543e6208c0d@huawei.com>
In-Reply-To: <c2f8cf50-d9f7-df19-40eb-0543e6208c0d@huawei.com>
From: John Dorminy <jdorminy@redhat.com>
Date: Thu, 19 Nov 2020 19:59:38 -0500
Message-ID: <CAMeeMh_TTjdH_w30As+CY+8J7w+jDQep2+ohqGnSN5NdC9YmhQ@mail.gmail.com>
To: "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============0907096214290035234=="

--===============0907096214290035234==
Content-Type: multipart/alternative; boundary="000000000000884ad305b47f5cee"

--000000000000884ad305b47f5cee
Content-Type: text/plain; charset="UTF-8"

Greetings;

There are a lot of uses of PAGE_SIZE/SECTOR_SIZE scattered around, and it
seems like a medium improvement to be able to refer to it as PAGE_SECTORS
everywhere instead of just inside dm, bcache, and null_blk. Did this change
progress forward somewhere?

Thanks!

John Dorminy


On Mon, Sep 7, 2020 at 3:40 AM Leizhen (ThunderTown) <
thunder.leizhen@huawei.com> wrote:

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
> >>>> same. It looks a bit of a mess. So why not move it into
> <linux/blkdev.h>,
> >>>> to achieve a basic and unique definition.
> >>>>
> >>>> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> >>>
> >>>
> >>> A lazy question about page size > 4KB: currently in bcache code the
> >>> sector size is assumed to be 512 sectors, if kernel page > 4KB, it is
> >>> possible that PAGE_SECTORS in bcache will be a number > 8 ?
> >>
> >> Sorry, I don't fully understand your question. I known that the sector
> size
> >> can be 512 or 4K, and the PAGE_SIZE can be 4K or 64K. So even if sector
> size
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
> > suspicious early if people do have this kind of problem on 4Kn sector
> SSDs.
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
> >>>> @@ -949,11 +949,12 @@ static inline struct request_queue
> *bdev_get_queue(struct block_device *bdev)
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
>

--000000000000884ad305b47f5cee
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div>Greetings;<br><br></div>There are a lot of uses =
of PAGE_SIZE/SECTOR_SIZE scattered around, and it seems like a medium impro=
vement to be able to refer to it as PAGE_SECTORS everywhere instead of just=
 inside dm, bcache, and null_blk. Did this change progress forward somewher=
e?<br><br></div>Thanks!<br><div><div><div><div><div><br></div><div>John Dor=
miny<br><br></div></div></div></div></div></div><br><div class=3D"gmail_quo=
te"><div dir=3D"ltr" class=3D"gmail_attr">On Mon, Sep 7, 2020 at 3:40 AM Le=
izhen (ThunderTown) &lt;<a href=3D"mailto:thunder.leizhen@huawei.com">thund=
er.leizhen@huawei.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_qu=
ote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,20=
4);padding-left:1ex">Hi, Jens Axboe, Alasdair Kergon, Mike Snitzer:<br>
=C2=A0 What&#39;s your opinion?<br>
<br>
<br>
On 2020/8/21 15:05, Coly Li wrote:<br>
&gt; On 2020/8/21 14:48, Leizhen (ThunderTown) wrote:<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt; On 8/21/2020 12:11 PM, Coly Li wrote:<br>
&gt;&gt;&gt; On 2020/8/21 10:03, Zhen Lei wrote:<br>
&gt;&gt;&gt;&gt; There are too many PAGE_SECTORS definitions, and all of th=
em are the<br>
&gt;&gt;&gt;&gt; same. It looks a bit of a mess. So why not move it into &l=
t;linux/blkdev.h&gt;,<br>
&gt;&gt;&gt;&gt; to achieve a basic and unique definition.<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; Signed-off-by: Zhen Lei &lt;<a href=3D"mailto:thunder.leiz=
hen@huawei.com" target=3D"_blank">thunder.leizhen@huawei.com</a>&gt;<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; A lazy question about page size &gt; 4KB: currently in bcache =
code the<br>
&gt;&gt;&gt; sector size is assumed to be 512 sectors, if kernel page &gt; =
4KB, it is<br>
&gt;&gt;&gt; possible that PAGE_SECTORS in bcache will be a number &gt; 8 ?=
<br>
&gt;&gt;<br>
&gt;&gt; Sorry, I don&#39;t fully understand your question. I known that th=
e sector size<br>
&gt;&gt; can be 512 or 4K, and the PAGE_SIZE can be 4K or 64K. So even if s=
ector size<br>
&gt;&gt; is 4K, isn&#39;t it greater than 8 for 64K pages?<br>
&gt;&gt;<br>
&gt;&gt; I&#39;m not sure if the question you&#39;re asking is the one Matt=
hew Wilcox has<br>
&gt;&gt; answered before:<br>
&gt;&gt; <a href=3D"https://www.spinics.net/lists/raid/msg64345.html" rel=
=3D"noreferrer" target=3D"_blank">https://www.spinics.net/lists/raid/msg643=
45.html</a><br>
&gt; <br>
&gt; Thank you for the above information. Currently bcache code assumes<br>
&gt; sector size is always 512 bytes, you may see how many &quot;&lt;&lt; 9=
&quot; or &quot;&gt;&gt; 9&quot;<br>
&gt; are used. Therefore I doubt whether current code may stably work on e.=
g.<br>
&gt; 4Kn SSDs (this is only doubt because I don&#39;t have such SSD).<br>
&gt; <br>
&gt; Anyway your patch is fine to me. This change to bcache doesn&#39;t mak=
e<br>
&gt; thins worse or better, maybe it can be helpful to trigger my above<br>
&gt; suspicious early if people do have this kind of problem on 4Kn sector =
SSDs.<br>
&gt; <br>
&gt; For the bcache part of this patch, you may add,<br>
&gt; Acked-by: Coly Li &lt;<a href=3D"mailto:colyli@suse.de" target=3D"_bla=
nk">colyli@suse.de</a>&gt;<br>
&gt; <br>
&gt; Thanks.<br>
&gt; <br>
&gt; Coly Li<br>
&gt; <br>
&gt;&gt;&gt;&gt; ---<br>
&gt;&gt;&gt;&gt;=C2=A0 drivers/block/brd.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0| 1 -<br>
&gt;&gt;&gt;&gt;=C2=A0 drivers/block/null_blk_main.c | 1 -<br>
&gt;&gt;&gt;&gt;=C2=A0 drivers/md/bcache/util.h=C2=A0 =C2=A0 =C2=A0 | 2 --<=
br>
&gt;&gt;&gt;&gt;=C2=A0 include/linux/blkdev.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 | =
5 +++--<br>
&gt;&gt;&gt;&gt;=C2=A0 include/linux/device-mapper.h | 1 -<br>
&gt;&gt;&gt;&gt;=C2=A0 5 files changed, 3 insertions(+), 7 deletions(-)<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; [snipped]<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/=
util.h<br>
&gt;&gt;&gt;&gt; index c029f7443190805..55196e0f37c32c6 100644<br>
&gt;&gt;&gt;&gt; --- a/drivers/md/bcache/util.h<br>
&gt;&gt;&gt;&gt; +++ b/drivers/md/bcache/util.h<br>
&gt;&gt;&gt;&gt; @@ -15,8 +15,6 @@<br>
&gt;&gt;&gt;&gt;=C2=A0 <br>
&gt;&gt;&gt;&gt;=C2=A0 #include &quot;closure.h&quot;<br>
&gt;&gt;&gt;&gt;=C2=A0 <br>
&gt;&gt;&gt;&gt; -#define PAGE_SECTORS=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 (PAGE_SIZE / 512)<br>
&gt;&gt;&gt;&gt; -<br>
&gt;&gt;&gt;&gt;=C2=A0 struct closure;<br>
&gt;&gt;&gt;&gt;=C2=A0 <br>
&gt;&gt;&gt;&gt;=C2=A0 #ifdef CONFIG_BCACHE_DEBUG<br>
&gt;&gt;&gt;&gt; diff --git a/include/linux/blkdev.h b/include/linux/blkdev=
.h<br>
&gt;&gt;&gt;&gt; index bb5636cc17b91a7..b068dfc5f2ef0ab 100644<br>
&gt;&gt;&gt;&gt; --- a/include/linux/blkdev.h<br>
&gt;&gt;&gt;&gt; +++ b/include/linux/blkdev.h<br>
&gt;&gt;&gt;&gt; @@ -949,11 +949,12 @@ static inline struct request_queue *=
bdev_get_queue(struct block_device *bdev)<br>
&gt;&gt;&gt;&gt;=C2=A0 =C2=A0* multiple of 512 bytes. Hence these two const=
ants.<br>
&gt;&gt;&gt;&gt;=C2=A0 =C2=A0*/<br>
&gt;&gt;&gt;&gt;=C2=A0 #ifndef SECTOR_SHIFT<br>
&gt;&gt;&gt;&gt; -#define SECTOR_SHIFT 9<br>
&gt;&gt;&gt;&gt; +#define SECTOR_SHIFT=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 9<br>
&gt;&gt;&gt;&gt;=C2=A0 #endif<br>
&gt;&gt;&gt;&gt;=C2=A0 #ifndef SECTOR_SIZE<br>
&gt;&gt;&gt;&gt; -#define SECTOR_SIZE (1 &lt;&lt; SECTOR_SHIFT)<br>
&gt;&gt;&gt;&gt; +#define SECTOR_SIZE=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0(1 &lt;&lt; SECTOR_SHIFT)<br>
&gt;&gt;&gt;&gt;=C2=A0 #endif<br>
&gt;&gt;&gt;&gt; +#define PAGE_SECTORS=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 (PAGE_SIZE / SECTOR_SIZE)<br>
&gt;&gt;&gt;&gt;=C2=A0 <br>
&gt;&gt;&gt;&gt;=C2=A0 /*<br>
&gt;&gt;&gt;&gt;=C2=A0 =C2=A0* blk_rq_pos()=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0: the current sector<br>
&gt;&gt;&gt; [snipped]<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt;<br>
&gt;&gt;<br>
&gt; <br>
&gt; <br>
&gt; .<br>
&gt; <br>
<br>
</blockquote></div>

--000000000000884ad305b47f5cee--

--===============0907096214290035234==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
--===============0907096214290035234==--


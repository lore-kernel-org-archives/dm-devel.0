Return-Path: <SRS0=RcAx=E2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47476C63697
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 01:27:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A75A922254
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 01:27:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eNz2G0k2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A75A922254
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1605835677;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ASeydp9gK9Vt+M6l3+QguxNXLKEAF5k1/2MqWMRNrz0=;
	b=eNz2G0k2byH6IMavm361VSQO4Y/2ZO2VRxqL8oWGrqeY+lIlnOhQcVohYPHRMN9iABAOYK
	5j3y43e+hJfwbrQPwRJzDgBBcM84jay2+NFv9toQJbANCEJRMobMOb+yZFuojVXq0oSauA
	KaYq67ndawffgOUTt5bA05+la85zDPk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-lp4Mt6xhO66haJ4CuIwiVQ-1; Thu, 19 Nov 2020 20:27:55 -0500
X-MC-Unique: lp4Mt6xhO66haJ4CuIwiVQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 41A248143F3;
	Fri, 20 Nov 2020 01:27:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 20F2A60853;
	Fri, 20 Nov 2020 01:27:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EAEA4180954D;
	Fri, 20 Nov 2020 01:27:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AK1Rn3w006008 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 19 Nov 2020 20:27:49 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E8EC110F1CD7; Fri, 20 Nov 2020 01:27:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E516610F1CD4
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 01:27:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 85995811E85
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 01:27:45 +0000 (UTC)
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
	[209.85.222.70]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-31-Dk-JG_TbM7q6hRYxNPNzhA-1; Thu, 19 Nov 2020 20:27:43 -0500
X-MC-Unique: Dk-JG_TbM7q6hRYxNPNzhA-1
Received: by mail-ua1-f70.google.com with SMTP id w19so2490282uap.0
	for <dm-devel@redhat.com>; Thu, 19 Nov 2020 17:27:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=MYquISkn3nZV5YB0okA6VfbOmAn2onUZzzDzkWZvjkE=;
	b=GJcLu+wbBcKr9cv75YRRvKX4HFq4JsU37hqvfKbGO85Hm81SNhiZvuJ9WzUhTCEbBH
	Ebt2v8I9CJ8iuJyVcQ1a8c6yrQu/8rTzc6NafhIKlQ8U8qGb0gpswmfh6dqSjSHivy8l
	FNZ+U6r0Tt9DoM4GubV8mWAe27luSyDFyM9z3QQ7oXK/4Kw0vyt2pY1zCy83WC8cH+Jy
	DlqoT9DjU2SKApcgteNFlCwaneZESNxOoCqhL/DyhNOo0p1b6VO+85ZRr7nCnIczpjL6
	uchgw3kAHWpiQN+1nENamVu1iQQDlffwfoAK1DSfzbXx11YDcwwPOggOi9nI50Kz9spn
	D3yg==
X-Gm-Message-State: AOAM5330sdXiAJWRQEeyHx3m469ZvXAo6GdVP3WpjWi7jVfW9FYpuNxo
	Mf8s7eNQRcoXb17NZYwkAc4PstcN1MhL0QFWRpupddOIzAICuwK9LT6MedlMytouFMbwW9Ui/Lo
	thPcaeMqZyFl/yGMDIpORRMVbeFBku9k=
X-Received: by 2002:ab0:224b:: with SMTP id z11mr13378382uan.103.1605835663206;
	Thu, 19 Nov 2020 17:27:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzE8trd4VpMwa8E8M6LiMEVo96dOkpqmDZ8DGxXQs4TM+71O6XXrABn/oUZi7Sf+whezhrwuz2dhE2fWIxvft0=
X-Received: by 2002:ab0:224b:: with SMTP id z11mr13378372uan.103.1605835663000;
	Thu, 19 Nov 2020 17:27:43 -0800 (PST)
MIME-Version: 1.0
References: <20201118203127.GA30066@redhat.com>
	<20201118203408.GB30066@redhat.com>
	<fc7c4efd-0bb3-f023-19c6-54359d279ca8@redhat.com>
	<alpine.LRH.2.02.2011190810001.32672@file01.intranet.prod.int.rdu2.redhat.com>
	<20201119172807.GC1879@redhat.com>
	<alpine.LRH.2.02.2011191337180.588@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.2011191517360.10231@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.2011191517360.10231@file01.intranet.prod.int.rdu2.redhat.com>
From: John Dorminy <jdorminy@redhat.com>
Date: Thu, 19 Nov 2020 20:27:32 -0500
Message-ID: <CAMeeMh8uaZkOHGUsvfaM7Fyqov5wKNfCp_FfBy7S39EG3Ktc7w@mail.gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Heinz Mauelshagen <heinzm@redhat.com>,
	Marian Csontos <mcsontos@redhat.com>,
	linux-block <linux-block@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	David Teigland <teigland@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: [dm-devel] [PATCH] blk-settings: make sure that max_sectors is
 aligned on "logical_block_size" boundary.
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Greetings;

Might I suggest using SECTOR_SIZE instead of 512? Or, perhaps, >>
SECTOR_SHIFT instead of / 512.

I don't understand the three conditionals. I believe max_sectors is
supposed to be <= min(max_dev_sectors, max_hw_sectors), but I don't
understand why max_sectors being small should adjust max_hw_sectors
and max_dev_sectors. Are the conditions perhaps supposed to be
different, adjusting each max_*sectors up to at least PAGE_SIZE /
SECTOR_SIZE? Perhaps, like e.g. blk_queue_max_hw_sectors(), the
conditionals should log if they are adjusting max_*sectors up to the
minimum.

Thanks!

John Dorminy

On Thu, Nov 19, 2020 at 3:37 PM Mikulas Patocka <mpatocka@redhat.com> wrote:
>
> We get these I/O errors when we run md-raid1 on the top of dm-integrity on
> the top of ramdisk:
> device-mapper: integrity: Bio not aligned on 8 sectors: 0xff00, 0xff
> device-mapper: integrity: Bio not aligned on 8 sectors: 0xff00, 0xff
> device-mapper: integrity: Bio not aligned on 8 sectors: 0xffff, 0x1
> device-mapper: integrity: Bio not aligned on 8 sectors: 0xffff, 0x1
> device-mapper: integrity: Bio not aligned on 8 sectors: 0x8048, 0xff
> device-mapper: integrity: Bio not aligned on 8 sectors: 0x8147, 0xff
> device-mapper: integrity: Bio not aligned on 8 sectors: 0x8246, 0xff
> device-mapper: integrity: Bio not aligned on 8 sectors: 0x8345, 0xbb
>
> The ramdisk device has logical_block_size 512 and max_sectors 255. The
> dm-integrity device uses logical_block_size 4096 and it doesn't affect the
> "max_sectors" value - thus, it inherits 255 from the ramdisk. So, we have
> a device with max_sectors not aligned on logical_block_size.
>
> The md-raid device sees that the underlying leg has max_sectors 255 and it
> will split the bios on 255-sector boundary, making the bios unaligned on
> logical_block_size.
>
> In order to fix the bug, we round down max_sectors to logical_block_size.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org
>
> ---
>  block/blk-settings.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> Index: linux-2.6/block/blk-settings.c
> ===================================================================
> --- linux-2.6.orig/block/blk-settings.c 2020-10-29 12:20:46.000000000 +0100
> +++ linux-2.6/block/blk-settings.c      2020-11-19 21:20:18.000000000 +0100
> @@ -591,6 +591,16 @@ int blk_stack_limits(struct queue_limits
>                 ret = -1;
>         }
>
> +       t->max_sectors = round_down(t->max_sectors, t->logical_block_size / 512);
> +       if (t->max_sectors < PAGE_SIZE / 512)
> +               t->max_sectors = PAGE_SIZE / 512;
> +       t->max_hw_sectors = round_down(t->max_hw_sectors, t->logical_block_size / 512);
> +       if (t->max_sectors < PAGE_SIZE / 512)
> +               t->max_hw_sectors = PAGE_SIZE / 512;
> +       t->max_dev_sectors = round_down(t->max_dev_sectors, t->logical_block_size / 512);
> +       if (t->max_sectors < PAGE_SIZE / 512)
> +               t->max_dev_sectors = PAGE_SIZE / 512;
> +
>         /* Discard alignment and granularity */
>         if (b->discard_granularity) {
>                 alignment = queue_limit_discard_alignment(b, start);
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


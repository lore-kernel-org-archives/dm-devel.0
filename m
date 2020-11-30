Return-Path: <SRS0=s6zu=FE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28604C64E7B
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 20:52:32 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7C52E2073C
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 20:52:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q4HnOEuv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7C52E2073C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1606769550;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LUQalSQSUCRiWE6egcGkTlHYEgv89pVlvBrHhwLvShM=;
	b=Q4HnOEuv583Lx9qE1xt12qXPbj1taVSWl9Gl0EYnAKABBpDrh10PCFKyXKkir88/VaeD+b
	iWcEOMYk6yf6Gn4Q+V0+rTw5F/fsG8uwcaqEytKINLoSBWNjwRgtzVsTZACxAsZanNrXog
	kRd7J3qEomhWWQ3L27MBZbzMgGzi4LU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-edQGXKDlOIKbfI9EVdxtZA-1; Mon, 30 Nov 2020 15:52:27 -0500
X-MC-Unique: edQGXKDlOIKbfI9EVdxtZA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5A3901092BA0;
	Mon, 30 Nov 2020 20:52:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F81810016F4;
	Mon, 30 Nov 2020 20:52:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AE17A180954D;
	Mon, 30 Nov 2020 20:52:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AUKq6c4028730 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 30 Nov 2020 15:52:06 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B1FE22166B2C; Mon, 30 Nov 2020 20:52:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AD6232166B2B
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 20:52:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5BA2E185A7BC
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 20:52:04 +0000 (UTC)
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com
	[209.85.221.199]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-584-DBcKjpg4MEK6qqH2HGrTQA-1; Mon, 30 Nov 2020 15:52:02 -0500
X-MC-Unique: DBcKjpg4MEK6qqH2HGrTQA-1
Received: by mail-vk1-f199.google.com with SMTP id h22so4495311vkn.22
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 12:52:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=+b2Pp0coGV9j/d9ySwXiIZFcFYYUG+hnak08L/oevVY=;
	b=BQPZ2qzJcNup7itmD9IXRHz6SPm11wlQmXyPhdaeUaQvWZywtyf6NHGSxWP/E9E2+z
	MzxWXsjt08M5cjekM7Kmh0JBjfTYplLdr/KKYnSifjYu2IX+uDyQv+nZhcs5VFKikVkL
	em4RJGBbRiLNlvxiYr/3Szwg+IIaISVLJVBzR2Hn1YIOYHygta49KkJGKitwHumTJNO0
	bU6jH9KyS2JCXIZEWQ5Zc9rt8M8c5A4eqRk3M4cb5RbrO08oeOzJHwHoqE59HAjCFRkd
	JLAdijR/Bip7iitZrFycsOmTXBb7A/XN9TJBOP8AMURxH8hHkl2osb0I6Gi7MjxjNgRo
	T4EQ==
X-Gm-Message-State: AOAM531zkVIzXDgJVexIXEaTc+k9TASdKKkQAZg5ztQtUSpli3ZHhuFV
	7KBdJYI4fvBuZ0MNZbTS7X9xC5yuv8Vj/uG4rKA465nJk8/9bwXV3PqXTiLFPlhP/Nj1i6HuwVP
	D5HRYiIzIFaH15RSiX5g0BJDAxS0mplE=
X-Received: by 2002:ab0:74d1:: with SMTP id f17mr17280793uaq.30.1606769521905; 
	Mon, 30 Nov 2020 12:52:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzubma8STl3HCa0vJRhZbqsCE0aoJSMnrUX0e2pI7+Gruh20CEhyGGJL2n7aZ3aL+d5VLu/RCaAHOpASP6gnDQ=
X-Received: by 2002:ab0:74d1:: with SMTP id f17mr17280758uaq.30.1606769521581; 
	Mon, 30 Nov 2020 12:52:01 -0800 (PST)
MIME-Version: 1.0
References: <20201130171805.77712-1-snitzer@redhat.com>
In-Reply-To: <20201130171805.77712-1-snitzer@redhat.com>
From: John Dorminy <jdorminy@redhat.com>
Date: Mon, 30 Nov 2020 15:51:50 -0500
Message-ID: <CAMeeMh8fb2JEBmuSuTP8ys6Xr+GpFqcUr5Py73W4wCQb1MCuAw@mail.gmail.com>
To: Mike Snitzer <snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: linux-block <linux-block@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	Bruce Johnston <bjohnsto@redhat.com>
Subject: Re: [dm-devel] [PATCH] block: revert to using min_not_zero() when
	stacking chunk_sectors
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

I don't think this suffices, as it allows IOs that span max(a,b) chunk
boundaries.

Chunk sectors is defined as "if set, it will prevent merging across
chunk boundaries". Pulling the example from the last change:
It is possible, albeit more unlikely, for a block device to have a non
power-of-2 for chunk_sectors (e.g. 10+2 RAID6 with 128K chunk_sectors,
which results in a full-stripe size of 1280K. This causes the RAID6's
io_opt to be advertised as 1280K, and a stacked device _could_ then be
made to use a blocksize, aka chunk_sectors, that matches non power-of-2
io_opt of underlying RAID6 -- resulting in stacked device's
chunk_sectors being a non power-of-2).

Suppose the stacked device had a block size/chunk_sectors of 256k.
Then, with this change, some IOs issued by the stacked device to the
RAID beneath could span 1280k sector boundaries, and require further
splitting still. I think combining as the GCD is better, since any IO
of size gcd(a,b) definitely spans neither a a-chunk nor a b-chunk
boundary.

But it's possible I'm misunderstanding the purpose of chunk_sectors,
or there should be a check that the one of the two devices' chunk
sizes divides the other.

Thanks.

-John

On Mon, Nov 30, 2020 at 12:18 PM Mike Snitzer <snitzer@redhat.com> wrote:
>
> chunk_sectors must reflect the most limited of all devices in the IO
> stack.
>
> Otherwise malformed IO may result. E.g.: prior to this fix,
> ->chunk_sectors = lcm_not_zero(8, 128) would result in
> blk_max_size_offset() splitting IO at 128 sectors rather than the
> required more restrictive 8 sectors.
>
> Fixes: 22ada802ede8 ("block: use lcm_not_zero() when stacking chunk_sectors")
> Cc: stable@vger.kernel.org
> Reported-by: John Dorminy <jdorminy@redhat.com>
> Reported-by: Bruce Johnston <bjohnsto@redhat.com>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  block/blk-settings.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 9741d1d83e98..1d9decd4646e 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -547,7 +547,10 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
>
>         t->io_min = max(t->io_min, b->io_min);
>         t->io_opt = lcm_not_zero(t->io_opt, b->io_opt);
> -       t->chunk_sectors = lcm_not_zero(t->chunk_sectors, b->chunk_sectors);
> +
> +       if (b->chunk_sectors)
> +               t->chunk_sectors = min_not_zero(t->chunk_sectors,
> +                                               b->chunk_sectors);
>
>         /* Physical block size a multiple of the logical block size? */
>         if (t->physical_block_size & (t->logical_block_size - 1)) {
> --
> 2.15.0
>

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


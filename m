Return-Path: <SRS0=byOr=FF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FEFFC64E7A
	for <dm-devel@archiver.kernel.org>; Tue,  1 Dec 2020 17:43:44 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A01B020870
	for <dm-devel@archiver.kernel.org>; Tue,  1 Dec 2020 17:43:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aTmRmGZ2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A01B020870
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1606844622;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9y/xCCGpCMCZTJ4eNDrzkhXpAjteGt4qRErdVxUnCWk=;
	b=aTmRmGZ2GtcI6HAVi4i0V1cd5/h2SXH83+r2eD88zCEhY2oBv6vI3Hyao9YQOEDKJEK+Qy
	+QTb7rYFLGXKf0Ml9xybt5vtN2KzVees1nPDvmRHS0hwIkBbzApm4q8B+UEQfNEmp8xxU8
	TEOgYHuZD4fksfrIQRwhLfjB9I5npdA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-114-BFfNonrhNuGN0X8pCaucZw-1; Tue, 01 Dec 2020 12:43:38 -0500
X-MC-Unique: BFfNonrhNuGN0X8pCaucZw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 93C43107AD55;
	Tue,  1 Dec 2020 17:43:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1C67010016FB;
	Tue,  1 Dec 2020 17:43:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 15A8C180954D;
	Tue,  1 Dec 2020 17:43:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B1HhPSn003999 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 1 Dec 2020 12:43:25 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 726CD2026D47; Tue,  1 Dec 2020 17:43:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6DF872026D46
	for <dm-devel@redhat.com>; Tue,  1 Dec 2020 17:43:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F34B01871CC4
	for <dm-devel@redhat.com>; Tue,  1 Dec 2020 17:43:21 +0000 (UTC)
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com
	[209.85.217.72]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-509-Vxse6ixeNqOXTB6swd02vA-1; Tue, 01 Dec 2020 12:43:19 -0500
X-MC-Unique: Vxse6ixeNqOXTB6swd02vA-1
Received: by mail-vs1-f72.google.com with SMTP id u14so641413vsp.2
	for <dm-devel@redhat.com>; Tue, 01 Dec 2020 09:43:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=LZGhKypd6JdyTYRhn0b8NIkt9xhU4Eeu0l38PBqCdSE=;
	b=gbGeXaNvQt9w7CX44bdVqmY7Xq7KLE/9Sb/pr8Hue2uU5DJr7ELoXbFvXQGLIuA4vt
	L+wBgfEJ1tTF+7JIvH8YsMlivgwyeTTjlql4eIHPpM0cI+oDmDs+Fb1AI52vWYXqHgqh
	yvXFM5ltcKKsXtonjqsqrjn8lI6nkOP0qAj1ljdi/sBzWNRzTGKy/Mo0eAAybPyEDrIM
	3eEDbIa7+1s+WNZAMwu6035wodGC/xkcsoLYq+SBrJCQkLUMlsGh6YMZQedNS49Fv9hA
	BYm93L72jnympXEi4cnMBMrdWbbevi500GjcIdd0FJ4d+1c6QkiBKD/HpgDmLQKxbge8
	Tjiw==
X-Gm-Message-State: AOAM531Ji0Ct+Y9fQ6yjFRQv4+9q4CYiJW5X5ymfAPhXZOJG2yYTtpYy
	CM2oBzOKhWosei2MJAOtxcFPQF9szWzZ3YyOrefzoRXStk6KeRTRGDpBfE5YM2cz/BUgKFk9Fpr
	9W2Suq1sEiv6GdGyCiyE35JNYJnIKqb8=
X-Received: by 2002:a1f:1d50:: with SMTP id d77mr3576793vkd.18.1606844598895; 
	Tue, 01 Dec 2020 09:43:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwnkpGmhM9X2tcCMDc+Bsf0RYjwAyyMjh73nNDrRnmtU3BRg77ZC6gtKZdSWoW2mS780qIV2q6VRprf71ohd4g=
X-Received: by 2002:a1f:1d50:: with SMTP id d77mr3576751vkd.18.1606844598652; 
	Tue, 01 Dec 2020 09:43:18 -0800 (PST)
MIME-Version: 1.0
References: <20201130171805.77712-1-snitzer@redhat.com>
	<20201201160709.31748-1-snitzer@redhat.com>
In-Reply-To: <20201201160709.31748-1-snitzer@redhat.com>
From: John Dorminy <jdorminy@redhat.com>
Date: Tue, 1 Dec 2020 12:43:07 -0500
Message-ID: <CAMeeMh-dt91dJuwt+EpXPYbR-7Kfr6otBH+C7tBMqEF4toxS8w@mail.gmail.com>
To: Mike Snitzer <snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block <linux-block@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	Bruce Johnston <bjohnsto@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [dm-devel] [PATCH v2] block: use gcd() to fix chunk_sectors
	limit stacking
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

On Tue, Dec 1, 2020 at 11:07 AM Mike Snitzer <snitzer@redhat.com> wrote:
>
> commit 22ada802ede8 ("block: use lcm_not_zero() when stacking
> chunk_sectors") broke chunk_sectors limit stacking. chunk_sectors must
> reflect the most limited of all devices in the IO stack.
>
> Otherwise malformed IO may result. E.g.: prior to this fix,
> ->chunk_sectors = lcm_not_zero(8, 128) would result in
> blk_max_size_offset() splitting IO at 128 sectors rather than the
> required more restrictive 8 sectors.
>
> And since commit 07d098e6bbad ("block: allow 'chunk_sectors' to be
> non-power-of-2") care must be taken to properly stack chunk_sectors to
> be compatible with the possibility that a non-power-of-2 chunk_sectors
> may be stacked. This is why gcd() is used instead of reverting back
> to using min_not_zero().
>
> Fixes: 22ada802ede8 ("block: use lcm_not_zero() when stacking chunk_sectors")
> Fixes: 07d098e6bbad ("block: allow 'chunk_sectors' to be non-power-of-2")
> Cc: stable@vger.kernel.org
> Reported-by: John Dorminy <jdorminy@redhat.com>
> Reported-by: Bruce Johnston <bjohnsto@redhat.com>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  block/blk-settings.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> v2: use gcd(), instead of min_not_zero(), as suggested by John Dorminy
>
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 9741d1d83e98..659cdb8a07fe 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -547,7 +547,10 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
>
>         t->io_min = max(t->io_min, b->io_min);
>         t->io_opt = lcm_not_zero(t->io_opt, b->io_opt);
> -       t->chunk_sectors = lcm_not_zero(t->chunk_sectors, b->chunk_sectors);
> +
> +       /* Set non-power-of-2 compatible chunk_sectors boundary */
> +       if (b->chunk_sectors)
> +               t->chunk_sectors = gcd(t->chunk_sectors, b->chunk_sectors);
>
>         /* Physical block size a multiple of the logical block size? */
>         if (t->physical_block_size & (t->logical_block_size - 1)) {
> --
> 2.15.0
>

Reviewed-by: John Dorminy <jdorminy@redhat.com>

Thanks!

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


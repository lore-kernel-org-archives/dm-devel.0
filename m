Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2630EC433EF
	for <dm-devel@archiver.kernel.org>; Wed, 16 Feb 2022 06:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1644993013;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=WlP9w8LFQc/5j7iDV2eL0D3tJodHoqA9WPAroKsXl+g=;
	b=VEIW+PQ0IugyzZUC9+/IIbcIwdMdBe2WDWwscMk3MsWEdFLjiH+w1j6HSP+cjTkjghKhHq
	nK83tmh5kNLgS+wcX8g7aBrA8alRbBHj75e5ICQYXgTg5Y8RW21pO0gQBWD5oIdHEoGqCX
	XFj35j+M58iiBegAEQ3YWQ8j14QzVO8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-53-0EazANC2MguTW3Nk9RA0DQ-1; Wed, 16 Feb 2022 01:30:09 -0500
X-MC-Unique: 0EazANC2MguTW3Nk9RA0DQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 936171091DA3;
	Wed, 16 Feb 2022 06:30:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 70DCC62D46;
	Wed, 16 Feb 2022 06:30:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3649B50039;
	Wed, 16 Feb 2022 06:30:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21F8mdQH004447 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 15 Feb 2022 03:48:39 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A6378C3598D; Tue, 15 Feb 2022 08:48:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A2283C3598B
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 08:48:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 886311C05152
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 08:48:39 +0000 (UTC)
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
	[209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-669-fK8IflGzNoeEPRMXtJN8Ig-1; Tue, 15 Feb 2022 03:48:36 -0500
X-MC-Unique: fK8IflGzNoeEPRMXtJN8Ig-1
Received: by mail-pj1-f71.google.com with SMTP id
	y10-20020a17090a134a00b001b8b7e5983bso12673650pjf.6
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 00:48:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=cAghCw6nMXIP8DbPC2ZTmMjVdzgtfdV0Q4rDuIo9NkY=;
	b=Ww71Fh5QOqibn56HpRa4R6VQljTI9iMnWYsHqLYqRz7ooaZ3yiGEQGEXOBKVt5ic1B
	VfpWCfL31cLYDg+4FBXgkkRdNZW+uX0yOQw2YtNnTfzNxM/sCv/NQ4vIATRjYS+ouPrY
	SbJ6eyt8pkB1fLNcE4hc4wtjfjNIalejtXckdkjmTOwZLE5R7ig4dDcdS6c6mBsGuo4a
	dc1aX4Mi6MBjEOM9V2GMH4W6ve9dD32ap9NQ9PgPWnzCk7pJyWzCTfW8U4bzuonjZvOu
	tCXqmD2NF5AokvgrfnPXvxnKDGnVfArLMb6jdgxtJmKU12dmns0WAQqUSYRUGzR5ee+6
	qIfg==
X-Gm-Message-State: AOAM530IkTmHGuFTwDRV6Kt5fSvHDuLi07Yj+DhCoubIJkKqhu5nCJec
	kwLIloDndqD2olfnoxodegwclBgB52OOF7IwAbdLHeXdypun/z8p51xLs8W+U1t0ShFF3uFDVaB
	VymFEw5N22reLRkfUJXA8UJJ3AFcWkns=
X-Received: by 2002:a63:2bc5:: with SMTP id r188mr2644601pgr.363.1644914915604;
	Tue, 15 Feb 2022 00:48:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxNykZwzg4bf+5n8EbXDkY7JRsdOTnLNDPgNJlOcTDejNQ8sWs8DiYpM4W3ztHYleOanIdgFMhO3Rj6Rj63QAs=
X-Received: by 2002:a63:2bc5:: with SMTP id r188mr2644575pgr.363.1644914915393;
	Tue, 15 Feb 2022 00:48:35 -0800 (PST)
MIME-Version: 1.0
References: <1644890154-64915-1-git-send-email-wangqing@vivo.com>
	<1644890154-64915-7-git-send-email-wangqing@vivo.com>
In-Reply-To: <1644890154-64915-7-git-send-email-wangqing@vivo.com>
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date: Tue, 15 Feb 2022 09:48:24 +0100
Message-ID: <CAO-hwJLwomyHyjza8x3cEhR97HkK7Z7yPWVXwA4-1jmM=WKqeQ@mail.gmail.com>
To: Qing Wang <wangqing@vivo.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 16 Feb 2022 01:28:09 -0500
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Mike Snitzer <snitzer@redhat.com>, David Airlie <airlied@linux.ie>,
	Michael Turquette <mturquette@baylibre.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	dri-devel@lists.freedesktop.org,
	Hans Verkuil <hverkuil@xs4all.nl>, dm-devel@redhat.com,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	linux-clk@vger.kernel.org, Alasdair Kergon <agk@redhat.com>,
	amd-gfx@lists.freedesktop.org,
	"open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
	xen-devel@lists.xenproject.org, linux-media@vger.kernel.org,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	intel-gfx@lists.freedesktop.org, Jiri Kosina <jikos@kernel.org>,
	Jani Nikula <jani.nikula@linux.intel.com>, linux-block@vger.kernel.org,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Stephen Boyd <sboyd@kernel.org>,
	"Pan, Xinhui" <Xinhui.Pan@amd.com>, lkml <linux-kernel@vger.kernel.org>,
	Daniel Vetter <daniel@ffwll.ch>, Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
	=?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>
Subject: Re: [dm-devel] [PATCH V3 6/13] input: serio: use
 time_is_before_jiffies() instead of open coding it
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Feb 15, 2022 at 2:57 AM Qing Wang <wangqing@vivo.com> wrote:
>
> From: Wang Qing <wangqing@vivo.com>
>
> Use the helper function time_is_{before,after}_jiffies() to improve
> code readability.
>
> Signed-off-by: Wang Qing <wangqing@vivo.com>
> ---

Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Cheers,
Benjamin

>  drivers/input/serio/ps2-gpio.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/input/serio/ps2-gpio.c b/drivers/input/serio/ps2-gpio.c
> index 8970b49..7834296
> --- a/drivers/input/serio/ps2-gpio.c
> +++ b/drivers/input/serio/ps2-gpio.c
> @@ -136,7 +136,7 @@ static irqreturn_t ps2_gpio_irq_rx(struct ps2_gpio_data *drvdata)
>         if (old_jiffies == 0)
>                 old_jiffies = jiffies;
>
> -       if ((jiffies - old_jiffies) > usecs_to_jiffies(100)) {
> +       if (time_is_before_jiffies(old_jiffies + usecs_to_jiffies(100))) {
>                 dev_err(drvdata->dev,
>                         "RX: timeout, probably we missed an interrupt\n");
>                 goto err;
> @@ -237,7 +237,7 @@ static irqreturn_t ps2_gpio_irq_tx(struct ps2_gpio_data *drvdata)
>         if (old_jiffies == 0)
>                 old_jiffies = jiffies;
>
> -       if ((jiffies - old_jiffies) > usecs_to_jiffies(100)) {
> +       if (time_is_before_jiffies(old_jiffies + usecs_to_jiffies(100))) {
>                 dev_err(drvdata->dev,
>                         "TX: timeout, probably we missed an interrupt\n");
>                 goto err;
> --
> 2.7.4
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


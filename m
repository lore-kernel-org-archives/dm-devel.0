Return-Path: <SRS0=8v/u=FH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C788BC4361A
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 17:23:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 23C30207B0
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 17:23:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 23C30207B0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-552-PZeQ4bZaPQWaS1Y2QTn_RQ-1; Thu, 03 Dec 2020 12:23:21 -0500
X-MC-Unique: PZeQ4bZaPQWaS1Y2QTn_RQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A3B33107ACFA;
	Thu,  3 Dec 2020 17:23:16 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 835FD60854;
	Thu,  3 Dec 2020 17:23:15 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0EA90180954D;
	Thu,  3 Dec 2020 17:23:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B3HNAH3005015 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Dec 2020 12:23:10 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7ACAF2028E91; Thu,  3 Dec 2020 17:23:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 73F6E2027179
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 17:23:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 72AD2803DDE
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 17:23:04 +0000 (UTC)
Received: from mail-lf1-f68.google.com (mail-lf1-f68.google.com
	[209.85.167.68]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-591-pkGn_UJ7MfSSIzHJ6B4DtQ-1; Thu, 03 Dec 2020 12:23:02 -0500
X-MC-Unique: pkGn_UJ7MfSSIzHJ6B4DtQ-1
Received: by mail-lf1-f68.google.com with SMTP id j205so3857495lfj.6
	for <dm-devel@redhat.com>; Thu, 03 Dec 2020 09:23:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=MCo6dRdQYDIUbOIgel6fr+suiiVoJN9d04Uc6gUldrM=;
	b=J4WK/j9S6/s3GUYXXbSwma9Y9Sdvgs9Zq2JsZq+rfvWkmZw3gbVwX1eZUzIijeBEcj
	ZXxRzVKaVQBGIz6NpcB00DGJAFOyszC+uioZcCa1InHD1voTKLvDDJ8J8RFIXX4mYNdX
	72+Id2hZw5T60n4mXpAg4aTqzfp3xIg6SI2nFJXrLL1xmR2WIS/VI42dRcrBhrooKoXE
	wCUVNqv5IAquYxnEiJm4fP27tKN784vCjjkYohjFZNuzYwjwlGv4teMBJx7vm1oTaHqU
	v95ozXe/KJhfAw6uHhBggJflCy9cZ81QOXIg5wF8nQ1RQ+ts6rHGYGc40kDk2+UP1kP8
	OrpA==
X-Gm-Message-State: AOAM5339ZTd0zjhlXAbRsmeQkhPfgtYZLj30m3munv0XwiOAFlCya3xG
	J007YNcuvTyysaagjF3zDHKnlLrzqpIm/EeQCBEplg==
X-Google-Smtp-Source: ABdhPJxv5uR5vCh2l95ohsZtqwXnbIkzb0P9kpEh0ONH2dhLDQDAI3yvqCgYytQQZyW3xQYx5MV7kH4Z5NvYat0JXv4=
X-Received: by 2002:a19:8112:: with SMTP id c18mr1673014lfd.455.1607016180076; 
	Thu, 03 Dec 2020 09:23:00 -0800 (PST)
MIME-Version: 1.0
References: <20201203004659.95708-1-hyeongseok@gmail.com>
In-Reply-To: <20201203004659.95708-1-hyeongseok@gmail.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Thu, 3 Dec 2020 09:22:48 -0800
Message-ID: <CABCJKufCS+hbXkGyO9uU3EBscfCpU1f7pi77uzR_+cjo97g=YQ@mail.gmail.com>
To: Hyeongseok Kim <hyeongseok@gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	=?UTF-8?B?6rmA7ZiV7ISd?= <hyeongseok.kim@lge.com>,
	Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH] dm verity: skip verity work on I/O errors
 when system is shutting down
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

Hi,

On Wed, Dec 2, 2020 at 4:48 PM Hyeongseok Kim <hyeongseok@gmail.com> wrote:
>
> If emergency system shutdown is called, like by thermal shutdown,
> dm device could be alive when the block device couldn't process
> I/O requests anymore. In this status, the handling of I/O errors
> by new dm I/O requests or by those already in-flight can lead to
> a verity corruption state, which is misjudgment.
> So, skip verity work for I/O error when system is shutting down.

Thank you for the patch. I agree that attempting to correct I/O errors
when the system is shutting down, and thus generating more I/O that's
likely going to fail, is not a good idea.

>
> Signed-off-by: Hyeongseok Kim <hyeongseok@gmail.com>
> ---
>  drivers/md/dm-verity-target.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index f74982dcbea0..ba62c537798b 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -64,6 +64,15 @@ struct buffer_aux {
>         int hash_verified;
>  };
>
> +/*
> + * While system shutdown, skip verity work for I/O error.
> + */
> +static inline bool verity_is_system_shutting_down(void)
> +{
> +       return system_state == SYSTEM_HALT || system_state == SYSTEM_POWER_OFF
> +               || system_state == SYSTEM_RESTART;
> +}

Which of these states does the system get to during an emergency
shutdown? Can we simplify this by changing the test to system_state >
SYSTEM_RUNNING?

> +
>  /*
>   * Initialize struct buffer_aux for a freshly created buffer.
>   */
> @@ -564,7 +573,8 @@ static void verity_end_io(struct bio *bio)
>  {
>         struct dm_verity_io *io = bio->bi_private;
>
> -       if (bio->bi_status && !verity_fec_is_enabled(io->v)) {
> +       if (bio->bi_status &&
> +               (!verity_fec_is_enabled(io->v) || verity_is_system_shutting_down())) {
>                 verity_finish_io(io, bio->bi_status);
>                 return;
>         }

Otherwise, this looks good to me. However, I'm now wondering if an I/O
error should ever result in verity_handle_err() being called. Without
FEC, dm-verity won't call verity_handle_err() when I/O fails, but with
FEC enabled, it currently does, assuming error correction fails. Any
thoughts?

Sami

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


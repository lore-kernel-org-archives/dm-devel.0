Return-Path: <SRS0=4gQq=OD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BE73C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 13 Sep 2021 17:56:32 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E7022610CC
	for <dm-devel@archiver.kernel.org>; Mon, 13 Sep 2021 17:56:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E7022610CC
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-XCujaAdxMd6wxY0ihlNAKg-1; Mon, 13 Sep 2021 13:56:29 -0400
X-MC-Unique: XCujaAdxMd6wxY0ihlNAKg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7ED978A9F66;
	Mon, 13 Sep 2021 17:56:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B0B61043278;
	Mon, 13 Sep 2021 17:56:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E04D11800B9E;
	Mon, 13 Sep 2021 17:55:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18DHtuFf008565 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 13 Sep 2021 13:55:56 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6E261202DDFE; Mon, 13 Sep 2021 17:55:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 695F3202DCF8
	for <dm-devel@redhat.com>; Mon, 13 Sep 2021 17:55:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A7CA100B8C2
	for <dm-devel@redhat.com>; Mon, 13 Sep 2021 17:55:53 +0000 (UTC)
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com
	[209.85.219.177]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-206-cXLJopZrNymfa9TniWEUiA-1; Mon, 13 Sep 2021 13:55:49 -0400
X-MC-Unique: cXLJopZrNymfa9TniWEUiA-1
Received: by mail-yb1-f177.google.com with SMTP id k65so22248695yba.13
	for <dm-devel@redhat.com>; Mon, 13 Sep 2021 10:55:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=SGbC2JnK7TwelSJvfDA5bgXvsxFDfQ0hkGPy/EO3m7o=;
	b=13TPDlT99LJfWC3PpAMM0K2pLU0/bskYhUfLDffeQImg8mUeqBQsTHeII7guIWxLOp
	w5nnXNQgGg855Hp8SNT0BXyomQvqxLXkJmaA+abi3ywo9j714o6uSRVvE+5sfMMMLzR2
	s4QAX/f1DSOIVFQV0O7Qt/begxwhWi1kBnZ9YfyzHBNKXT+ZmmU93r61tc/0F5onTyMR
	58i4vSG5LHe7t/F2G0AkIG/gT1ANO0BZlaezXD7Wz2hbKTUjyUVafiLlf6n6vO1I5WcR
	4LqEI6D30cDAQU4nNKNkzEYiQpi3CQIpnBixccNetKcd4K5R4b0GDl1piiG8J45V6E8k
	VURw==
X-Gm-Message-State: AOAM530Jrg2fyxppZ/gh9imR/7hbd7gXECMl+zVntDqPboUpq5hE9CsD
	xdyZoEhIMpIAdGuuWPFoz1P/Eg0ZyhTgyjpqg+P5Cg==
X-Google-Smtp-Source: ABdhPJz3LLYMZr6RvoqOwmDO9q4BzrKuSIT+5HcOxJq902HpX5FGwjlnQINBmI8eFmOJzdDVe0P90aAeJE+wacsVGqk=
X-Received: by 2002:a25:1bc5:: with SMTP id
	b188mr16866816ybb.267.1631555748929; 
	Mon, 13 Sep 2021 10:55:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210913092642.3237796-1-akailash@google.com>
In-Reply-To: <20210913092642.3237796-1-akailash@google.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Mon, 13 Sep 2021 10:55:37 -0700
Message-ID: <CABCJKucJxi3CZU40LLg30fZx_YDsHBwA0fCB9fUMDY9rtqKczQ@mail.gmail.com>
To: Akilesh Kailash <akailash@google.com>
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
	Android Kernel Team <kernel-team@android.com>,
	Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH] dm-verity: skip verity_handle_error on I/O
	errors
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Akilesh,

On Mon, Sep 13, 2021 at 2:27 AM Akilesh Kailash <akailash@google.com> wrote:
>
> If there is an I/O error and FEC correction fails, return
> an error instead of calling verity_handle_error().
>
> Suggested-by: Sami Tolvanen <samitolvanen@google.com>
> Signed-off-by: Akilesh Kailash <akailash@google.com>
> ---
> This was discussed in [1] by Sami Tolvanen but was
> never implemented.
>
> [1] https://lore.kernel.org/dm-devel/b004e7c7-f795-77ed-19b9-983785780e92@gmail.com/T/#mec4df1ba3f3cb63846875fb2bfc1f8b3100f31f1

Great, thanks for the patch!

>  drivers/md/dm-verity-target.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index 22a5ac82446a..a6f7c452ee80 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -475,6 +475,7 @@ static int verity_verify_io(struct dm_verity_io *io)
>         struct bvec_iter start;
>         unsigned b;
>         struct crypto_wait wait;
> +       struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
>
>         for (b = 0; b < io->n_blocks; b++) {
>                 int r;
> @@ -529,9 +530,17 @@ static int verity_verify_io(struct dm_verity_io *io)
>                 else if (verity_fec_decode(v, io, DM_VERITY_BLOCK_TYPE_DATA,
>                                            cur_block, NULL, &start) == 0)
>                         continue;
> -               else if (verity_handle_err(v, DM_VERITY_BLOCK_TYPE_DATA,
> +               else {
> +                       if (bio->bi_status) {
> +                               /*
> +                                * Error correction failed; Just return error
> +                                */
> +                               return -EIO;
> +                       }
> +                       if (verity_handle_err(v, DM_VERITY_BLOCK_TYPE_DATA,
>                                            cur_block))
> -                       return -EIO;
> +                               return -EIO;
> +               }
>         }
>
>         return 0;

This looks correct to me. A non-zero bio->bi_status here means that
FEC must be enabled because otherwise we wouldn't have ended up in
verity_verify_io() in the first place, and returning -EIO when
verity_fec_decode() fails after attempting to correct an I/O error is
consistent with the non-FEC behavior of dm-verity.

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>

Sami

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


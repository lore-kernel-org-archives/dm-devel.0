Return-Path: <SRS0=c+In=IJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69422C433E0
	for <dm-devel@archiver.kernel.org>; Thu, 11 Mar 2021 22:35:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D956F64F8C
	for <dm-devel@archiver.kernel.org>; Thu, 11 Mar 2021 22:35:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D956F64F8C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-536-G6gSz15aP_eJiDs5K01qNA-1; Thu, 11 Mar 2021 17:35:26 -0500
X-MC-Unique: G6gSz15aP_eJiDs5K01qNA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3DEF0363A2;
	Thu, 11 Mar 2021 22:35:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C44AC19C47;
	Thu, 11 Mar 2021 22:35:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8792818155DE;
	Thu, 11 Mar 2021 22:35:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12BMZD2D021026 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Mar 2021 17:35:13 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9371D117C2CD; Thu, 11 Mar 2021 22:35:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8D9C7117C2D2
	for <dm-devel@redhat.com>; Thu, 11 Mar 2021 22:35:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B4C8101A531
	for <dm-devel@redhat.com>; Thu, 11 Mar 2021 22:35:11 +0000 (UTC)
Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com
	[209.85.217.45]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-325-z4KKwqp1MPegIBGvfqZUdw-1; Thu, 11 Mar 2021 17:35:08 -0500
X-MC-Unique: z4KKwqp1MPegIBGvfqZUdw-1
Received: by mail-vs1-f45.google.com with SMTP id z65so11522237vsz.12
	for <dm-devel@redhat.com>; Thu, 11 Mar 2021 14:35:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=Slj5ijAMQvQRxb1SS2xuWqvziQTtlap7wzaKqo38Ysg=;
	b=luPLP0oy0N9M4gys+PfA8KtYsHBxZlgJsZSE63gr21YYHH0XvX6IsrSCzcquGU4Wda
	TXXtKQI4+M/2cJVngv8siF7XiurW9myVxlOsjIU6n2KEBExxM69uHT8ForEVEkdcRt1V
	b7fyScg0VTDrhd/LbnrMiXnhMJI3VLx/uuiJNqdFKe+lzFG3WAfMMLbkP2cw3XvdEpwd
	bgBuzZgWPtljGgp8ZEN00VPcveLhylkuJDF0CJAvSKHy75vzj6HppjLhzOPYgaC1aQ7d
	lzQmYGdumvoOMdzV8J78zQdQTeEXUMWffmcugEBMFFMQyCwK12fw4CiWJJU+1W9d2mn0
	Gh/w==
X-Gm-Message-State: AOAM5327SaKkUy+ARIk9hiLEgrMZz6rCd/AOIGvwECz8WQI6h2jAMo9H
	75TjdiGRbjf3zt3ref/PBdEfsNpjlA29ZuT50UeQwQ==
X-Google-Smtp-Source: ABdhPJxS6e6HZ5CIYY3avBcnq6Cx3ijhGntj0qmtikKDEFki6YSCBlYrsrdkcr8uflsd08tLwKMsKfBnbWFmV0NM+F4=
X-Received: by 2002:a67:7384:: with SMTP id o126mr6898285vsc.23.1615502108020; 
	Thu, 11 Mar 2021 14:35:08 -0800 (PST)
MIME-Version: 1.0
References: <CGME20210311121850epcas1p493c255a586998916febfebaf994bc5dc@epcas1p4.samsung.com>
	<1615464651-23675-1-git-send-email-jhs2.lee@samsung.com>
	<1615464651-23675-2-git-send-email-jhs2.lee@samsung.com>
In-Reply-To: <1615464651-23675-2-git-send-email-jhs2.lee@samsung.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Thu, 11 Mar 2021 14:34:56 -0800
Message-ID: <CABCJKucMyQbtt-LACCRSk6bxAqmS05eVhv-5ou3_XZ1Nz+XYug@mail.gmail.com>
To: JeongHyeon Lee <jhs2.lee@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH 2/2] dm verity: allow only one verify mode
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

On Thu, Mar 11, 2021 at 4:19 AM JeongHyeon Lee <jhs2.lee@samsung.com> wrote:
>
> If there are multiple verity mode when parsing the verity mode of dm
> verity table, it will be set as the last one.
> So set to 'allow only once' to prevent it.

I agree that we shouldn't allow this, at least not without a warning,
but out of curiosity, do you actually have a situation where this
could happen? One ideally shouldn't be passing untrusted parameters to
dm-verity.

>
> Signed-off-by: JeongHyeon Lee <jhs2.lee@samsung.com>
> ---
>  drivers/md/dm-verity-target.c | 38 ++++++++++++++++++++++++++---------
>  1 file changed, 28 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index 808a98ef624c..b76431dc7721 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -893,6 +893,28 @@ static int verity_alloc_zero_digest(struct dm_verity *v)
>         return r;
>  }
>
> +static inline bool verity_is_verity_mode(const char *arg_name)
> +{
> +       return (!strcasecmp(arg_name, DM_VERITY_OPT_LOGGING) ||
> +               !strcasecmp(arg_name, DM_VERITY_OPT_RESTART) ||
> +               !strcasecmp(arg_name, DM_VERITY_OPT_PANIC));
> +}
> +
> +static int verity_parse_verity_mode(struct dm_verity *v, const char *arg_name)
> +{
> +       if (v->mode)
> +               return -EINVAL;
> +
> +       if (!strcasecmp(arg_name, DM_VERITY_OPT_LOGGING))
> +               v->mode = DM_VERITY_MODE_LOGGING;
> +       else if (!strcasecmp(arg_name, DM_VERITY_OPT_RESTART))
> +               v->mode = DM_VERITY_MODE_RESTART;
> +       else if (!strcasecmp(arg_name, DM_VERITY_OPT_PANIC))
> +               v->mode = DM_VERITY_MODE_PANIC;
> +
> +       return 0;
> +}
> +
>  static int verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
>                                  struct dm_verity_sig_opts *verify_args)
>  {
> @@ -916,16 +938,12 @@ static int verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
>                 arg_name = dm_shift_arg(as);
>                 argc--;
>
> -               if (!strcasecmp(arg_name, DM_VERITY_OPT_LOGGING)) {
> -                       v->mode = DM_VERITY_MODE_LOGGING;
> -                       continue;
> -
> -               } else if (!strcasecmp(arg_name, DM_VERITY_OPT_RESTART)) {
> -                       v->mode = DM_VERITY_MODE_RESTART;
> -                       continue;
> -
> -               } else if (!strcasecmp(arg_name, DM_VERITY_OPT_PANIC)) {
> -                       v->mode = DM_VERITY_MODE_PANIC;
> +               if (verity_is_verity_mode(arg_name)) {
> +                       r = verity_parse_verity_mode(v, arg_name);
> +                       if (r) {
> +                               ti->error = "Already verity mode set";

I don't have a strong opinion about this, but the documentation
doesn't talk about verity modes, so perhaps this could be reworded to
something like "Conflicting error handling parameters"?

> +                               return r;
> +                       }
>                         continue;
>
>                 } else if (!strcasecmp(arg_name, DM_VERITY_OPT_IGN_ZEROES)) {
> --
> 2.17.1
>

Sami

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


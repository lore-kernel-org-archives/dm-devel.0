Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B54FAC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 22 Mar 2022 00:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1647909319;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=cNxOvUm2ptO6gkqNTW2F+73A+capsrCxPLeW5aJqfMU=;
	b=UiQvyeRP/lp5HvNfQaiqC9WAqmVlF6S2PN/zrTnMlbMcRk5aJoWHF1JR1M30Qx0aL3cy95
	/mf74bnuAyz4GM8nml/n7oSMwpd02HxEzkGV9rynkG8+aYqfeSOl/gK8WVfekM4LBm2yKS
	s5VfQsmLuaxHZK44LLgbpH2GsQ6li+w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-100-W1OhRzzeP3a4MhpQhaoaOg-1; Mon, 21 Mar 2022 20:35:16 -0400
X-MC-Unique: W1OhRzzeP3a4MhpQhaoaOg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 28737100DE70;
	Tue, 22 Mar 2022 00:35:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 145F54B8D4D;
	Tue, 22 Mar 2022 00:35:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D3D041947BBE;
	Tue, 22 Mar 2022 00:35:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B7F051947BBC
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 00:35:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 974FDC26E9A; Tue, 22 Mar 2022 00:35:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 93888C07F5B
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 00:35:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7911628035E2
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 00:35:12 +0000 (UTC)
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-391-S1e9z4kgNCGSIJ43rooVww-1; Mon, 21 Mar 2022 20:35:11 -0400
X-MC-Unique: S1e9z4kgNCGSIJ43rooVww-1
Received: by mail-lf1-f69.google.com with SMTP id
 w25-20020a05651234d900b0044023ac3f64so4146459lfr.0
 for <dm-devel@redhat.com>; Mon, 21 Mar 2022 17:35:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=XJHjgsmc93savAddWWJt8mgNWCXQXW/lglxYL/+GsZQ=;
 b=lWEkkaBiqOT15vyRbBcrPWFVnGmq5TAS3eHvw0x9eWYeOaMIbjO+AskSMWgwcxiFmw
 eJ7ktp9LLeZx4B1uxbQmdGe+4dhiEtlW1r936o9fcFfXsN/+1SfU/4Dd1ckGsF1PIrpR
 JAQGMOO0QAjprOL7NLh5zc2Mv7knj7DoYgHa9nDLw8bIXoxH4d8brvRf2P8gzv+VQnqP
 puXmua2R3Y4XAOR/4VSD6j7wwZQjtJ0A2EmcbQAppPj/4eIBQXXdsGcHS2p9DmMoSF63
 Y1DTGWILdjwp6cjfRIiF+0XSb9yYZILZqEd7uU4T0Jtg3T51avJzYxwd38XPF1U0BSpP
 iC6Q==
X-Gm-Message-State: AOAM532eS/1SkhZK71KUKMUM4AyKcjto1teoCH2pXfjTGwVwOKa3QFen
 YChiICXNJop4srOstbtZl+J9L6fr6AHhgSA3Jck1pcgBLhhMusaVDgzO14Q5ONVkh3WG9XrrN1H
 5KDGnWpUZNq1UjVlli/gTSXfnNHHO5T8=
X-Received: by 2002:a05:651c:311:b0:23f:d9fc:9e89 with SMTP id
 a17-20020a05651c031100b0023fd9fc9e89mr17016395ljp.136.1647909309286; 
 Mon, 21 Mar 2022 17:35:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwRS2hMrxbpguaGT9VL1/UOX0l60p+a1uabg08kHp057j67oNZydprbv2s+jus96b10LbkNQW+d1kYZDaiDSoM=
X-Received: by 2002:a05:651c:311:b0:23f:d9fc:9e89 with SMTP id
 a17-20020a05651c031100b0023fd9fc9e89mr17016388ljp.136.1647909309126; Mon, 21
 Mar 2022 17:35:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220318223339.4226-1-mwilck@suse.com>
 <20220318223339.4226-9-mwilck@suse.com>
In-Reply-To: <20220318223339.4226-9-mwilck@suse.com>
From: Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 21 Mar 2022 19:34:58 -0500
Message-ID: <CAPt1nt7=WCGuGuwD8ue0_FSZ7VwSi_OUKgu0OvY5t6XbY8my8Q@mail.gmail.com>
To: mwilck@suse.com
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v2 08/11] libmultipath: warn only once about
 deprecated options
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com, Guozhonghua <guozh88@chinatelecom.cn>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Mar 18, 2022 at 5:33 PM <mwilck@suse.com> wrote:
>
> From: Martin Wilck <mwilck@suse.com>
>
> Signed-off-by: Martin Wilck <mwilck@suse.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> ---
>  libmultipath/dict.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
>
> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> index 2af9764..26cbe78 100644
> --- a/libmultipath/dict.c
> +++ b/libmultipath/dict.c
> @@ -279,7 +279,11 @@ static int                                                         \
>  def_ ## option ## _handler (struct config *conf, vector strvec,                \
>                             const char *file, int line_nr)              \
>  {                                                                      \
> -       condlog(2, "%s line %d, \"" #option "\" is deprecated and will be disabled in a future release", file, line_nr);                                \
> +       static bool warned;                                             \
> +       if (!warned) {                                                  \
> +               condlog(2, "%s line %d, \"" #option "\" is deprecated and will be disabled in a future release", file, line_nr); \
> +               warned = true;                                          \
> +       }                                                               \
>         return function (strvec, &conf->option, file, line_nr);         \
>  }
>
> @@ -829,14 +833,19 @@ static int
>  def_config_dir_handler(struct config *conf, vector strvec, const char *file,
>                        int line_nr)
>  {
> +       static bool warned;
> +
>         /* this is only valid in the main config file */
>         if (conf->processed_main_config) {
>                 condlog(1, "%s line %d, config_dir option only valid in /etc/multipath.conf",
>                         file, line_nr);
>                 return 0;
>         }
> -       condlog(2, "%s line %d, \"config_dir\" is deprecated and will be disabled in a future release",
> -               file, line_nr);
> +       if (!warned) {
> +               condlog(2, "%s line %d, \"config_dir\" is deprecated and will be disabled in a future release",
> +                       file, line_nr);
> +               warned = true;
> +       }
>         return set_path(strvec, &conf->config_dir, file, line_nr);
>  }
>  declare_def_snprint(config_dir, print_str)
> --
> 2.35.1
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


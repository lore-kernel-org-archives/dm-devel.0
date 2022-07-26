Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53229CCA48C
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jul 2022 08:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658823395;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=gWKL+nzVDBpw+2hRwfC7O3VDZong7Mz3pNjWEAMvFzw=;
	b=Cum2eNUVJw6dXfQEhzGU87hcnkNXhynfMqmFQ8/CuflXBj6OJ15yj490OIvFxhIl0FiC8p
	eEAV9XZENEjfxbfBxYwe+AELc+59PqDFzFVFcFAF/amFFFha/Vc8ZfyY7mY05JlyrjgPK5
	Pmw/zhV1hyHosRiV4Qxn6uYxW7uA2jk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-402-tPN5LhRPN1S8XPQ78Ib0fw-1; Tue, 26 Jul 2022 04:16:31 -0400
X-MC-Unique: tPN5LhRPN1S8XPQ78Ib0fw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2233B802E5C;
	Tue, 26 Jul 2022 08:16:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 10E82492CA2;
	Tue, 26 Jul 2022 08:16:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D15BB1945D88;
	Tue, 26 Jul 2022 08:16:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E9B711945D86
 for <dm-devel@listman.corp.redhat.com>; Tue, 26 Jul 2022 05:30:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CC2C040CFD0A; Tue, 26 Jul 2022 05:30:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C842C40CF8EE
 for <dm-devel@redhat.com>; Tue, 26 Jul 2022 05:30:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF3ED280D212
 for <dm-devel@redhat.com>; Tue, 26 Jul 2022 05:30:11 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-647-BkdAHSuJMa6f3ijNpz3KZA-1; Tue, 26 Jul 2022 01:30:07 -0400
X-MC-Unique: BkdAHSuJMa6f3ijNpz3KZA-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 5420361192;
 Tue, 26 Jul 2022 05:22:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8650C341C0;
 Tue, 26 Jul 2022 05:22:22 +0000 (UTC)
Received: by mail-yb1-f175.google.com with SMTP id 6so23612478ybc.8;
 Mon, 25 Jul 2022 22:22:22 -0700 (PDT)
X-Gm-Message-State: AJIora/w5U/RgGqf/gBGw7OGPoJH1MlEUWRS948hWCetPoV7GZd8IBlw
 fYJiIONuIa9m075cDo9q8vQtbdh9cVQo1buxA+o=
X-Google-Smtp-Source: AGRyM1vw5fldwq2G/6uN+ULfhs7C1fYN7F9NNcOeNwrpMD1x3IjGBRySS6pB0btKWfMQjZS0w4gXEZ15sDhuEQCCW7k=
X-Received: by 2002:a25:8611:0:b0:66e:d9e7:debc with SMTP id
 y17-20020a258611000000b0066ed9e7debcmr12121888ybk.257.1658812941844; Mon, 25
 Jul 2022 22:22:21 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LRH.2.02.2207241426320.26078@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.2207241426320.26078@file01.intranet.prod.int.rdu2.redhat.com>
From: Song Liu <song@kernel.org>
Date: Mon, 25 Jul 2022 22:22:11 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7-NtUDEqBCSnjQPW+Z8bcgMkaK6BsWUN4_fuULcpoCiw@mail.gmail.com>
Message-ID: <CAPhsuW7-NtUDEqBCSnjQPW+Z8bcgMkaK6BsWUN4_fuULcpoCiw@mail.gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mailman-Approved-At: Tue, 26 Jul 2022 08:16:26 +0000
Subject: Re: [dm-devel] [PATCH] md-raid10: fix KASAN warning
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
Cc: linux-raid <linux-raid@vger.kernel.org>,
 Heinz Mauelshagen <heinzm@redhat.com>, Mike Snitzer <msnitzer@redhat.com>,
 dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sun, Jul 24, 2022 at 11:29 AM Mikulas Patocka <mpatocka@redhat.com> wrote:
>
> There's a KASAN warning in raid10_remove_disk when running the lvm
> test lvconvert-raid-reshape.sh. We fix this warning by verifying that the
> value "number" is valid.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org

Could you please add the KASAN message to the commit log?

Thanks,
Song

>
> ---
>  drivers/md/raid10.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> Index: linux-2.6/drivers/md/raid10.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/raid10.c  2022-07-13 19:05:50.000000000 +0200
> +++ linux-2.6/drivers/md/raid10.c       2022-07-13 19:07:05.000000000 +0200
> @@ -2167,9 +2167,12 @@ static int raid10_remove_disk(struct mdd
>         int err = 0;
>         int number = rdev->raid_disk;
>         struct md_rdev **rdevp;
> -       struct raid10_info *p = conf->mirrors + number;
> +       struct raid10_info *p;
>
>         print_conf(conf);
> +       if (unlikely(number >= mddev->raid_disks))
> +               return 0;
> +       p = conf->mirrors + number;
>         if (rdev == p->rdev)
>                 rdevp = &p->rdev;
>         else if (rdev == p->replacement)
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


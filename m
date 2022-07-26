Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76A92C04A68
	for <dm-devel@archiver.kernel.org>; Wed, 27 Jul 2022 07:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658907549;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=rYqRf1B8CwkGGPeb2F8ya1T1dTJ68nonfqQWPYrIpIY=;
	b=ChDg50+BS71O8GMVdzPJGmvxzZKXvEwLcuMD//f0zZeFxDSSo77uKCkmZL++G6BmpJPV9+
	Hcpr5+vLrQIEouDwAmjTcMgW8AV8iLAbwnzZTrfEjOCSfCBQkQDAtXoT4Ek7yh8w7psdhi
	Jzb7s7jhyXEHUKPCK2gl27x2bujP4Eo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-457-oc3etdxQNuKZMyg9dLzTow-1; Wed, 27 Jul 2022 03:39:05 -0400
X-MC-Unique: oc3etdxQNuKZMyg9dLzTow-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2079E85A58A;
	Wed, 27 Jul 2022 07:39:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 533181415118;
	Wed, 27 Jul 2022 07:38:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 12C511945D8F;
	Wed, 27 Jul 2022 07:38:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 07B9B1945D86
 for <dm-devel@listman.corp.redhat.com>; Tue, 26 Jul 2022 17:24:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EB133C27D95; Tue, 26 Jul 2022 17:24:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E71BBC28118
 for <dm-devel@redhat.com>; Tue, 26 Jul 2022 17:24:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C5AA43801153
 for <dm-devel@redhat.com>; Tue, 26 Jul 2022 17:24:03 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-552-AtrXjGDVNRmA-YHZmnQxcQ-1; Tue, 26 Jul 2022 13:24:01 -0400
X-MC-Unique: AtrXjGDVNRmA-YHZmnQxcQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 61B0EB8189E;
 Tue, 26 Jul 2022 17:17:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F34AC433C1;
 Tue, 26 Jul 2022 17:17:50 +0000 (UTC)
Received: by mail-yw1-f175.google.com with SMTP id
 00721157ae682-31f443e276fso32029457b3.1; 
 Tue, 26 Jul 2022 10:17:50 -0700 (PDT)
X-Gm-Message-State: AJIora9l+Cr6cLWCmWQntP6K+eUjgJOnmZbJrk1T6MeubCvMRwG4Gvmf
 05GBhoViJbxx7Wh+egycc1/UFpbZzD94/WBS8kk=
X-Google-Smtp-Source: AGRyM1tvcUlxnozMqZOj2M+UgLLOpqSSYlQodtOmXRqnAOpIxmErwdXG6C5nMf6SxU6afKxpAYE0SM4ylD+JLCWhYHA=
X-Received: by 2002:a0d:f746:0:b0:31e:80dc:725f with SMTP id
 h67-20020a0df746000000b0031e80dc725fmr15917780ywf.460.1658855869156; Tue, 26
 Jul 2022 10:17:49 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LRH.2.02.2207241426320.26078@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPhsuW7-NtUDEqBCSnjQPW+Z8bcgMkaK6BsWUN4_fuULcpoCiw@mail.gmail.com>
 <alpine.LRH.2.02.2207260431020.32515@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.2207260431020.32515@file01.intranet.prod.int.rdu2.redhat.com>
From: Song Liu <song@kernel.org>
Date: Tue, 26 Jul 2022 10:17:38 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7rvXnOWz3YwtuD_Scj89RE=T4Ktb-xJ3v=fU_asbNy1g@mail.gmail.com>
Message-ID: <CAPhsuW7rvXnOWz3YwtuD_Scj89RE=T4Ktb-xJ3v=fU_asbNy1g@mail.gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mailman-Approved-At: Wed, 27 Jul 2022 07:38:58 +0000
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jul 26, 2022 at 1:33 AM Mikulas Patocka <mpatocka@redhat.com> wrote:
>
> There's a KASAN warning in raid10_remove_disk when running the lvm
> test lvconvert-raid-reshape.sh. We fix this warning by verifying that the
> value "number" is valid.
>

[...]

>  ffff889108f3d380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff889108f3d400: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org

Applied to md-next. Thanks!
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


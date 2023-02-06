Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDB1DC636D3
	for <dm-devel@archiver.kernel.org>; Mon,  6 Feb 2023 21:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675717459;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=QVdB5wxZ2DAoYXIIZ9GBcPJz+G/kzyoQ7i0TZU5Z9zw=;
	b=IpqAIspWBRohGI7KH3AiW6tYKnDOg53WAI7eOk7ML4+j0NsU9fH2sKcYf+iSrb+0yHer6Q
	kHSScn4iorlTAoC+sK2bWFEdDi7Pl9MkgJoNLod7AY/SVmTL+ym3rn0Lf795+tdhK47zYR
	2XZshR37F/1YIAoEhIUyCXMll9cAS1E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-85-23N69Lm5PeSnBM0ut2wgtw-1; Mon, 06 Feb 2023 16:04:18 -0500
X-MC-Unique: 23N69Lm5PeSnBM0ut2wgtw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B6961885621;
	Mon,  6 Feb 2023 21:04:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A480C40C83B6;
	Mon,  6 Feb 2023 21:04:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 50F9B194658C;
	Mon,  6 Feb 2023 21:04:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 291351946589
 for <dm-devel@listman.corp.redhat.com>; Mon,  6 Feb 2023 21:04:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 137F51410F36; Mon,  6 Feb 2023 21:04:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0BC34140EBF6
 for <dm-devel@redhat.com>; Mon,  6 Feb 2023 21:04:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF1DB2A59577
 for <dm-devel@redhat.com>; Mon,  6 Feb 2023 21:04:13 +0000 (UTC)
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com
 [209.85.160.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-347-ZpuSTBYlOZmclt8ghQ5kJg-1; Mon, 06 Feb 2023 16:03:46 -0500
X-MC-Unique: ZpuSTBYlOZmclt8ghQ5kJg-1
Received: by mail-qt1-f176.google.com with SMTP id m12so14503923qth.4
 for <dm-devel@redhat.com>; Mon, 06 Feb 2023 13:03:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=oSuSGckE2C1EffkcYLU7uPOxByUCgrfnKkzD4m2tvZc=;
 b=yagE4BnsETmZ0049C5Di59kMaw7/QkiLimPpzU2eHpXXuBup2meabLHz5+Osu0sb67
 Dd2kz/UsJPFCiXd4v4KtA5K/uYvY4anr3Y5tk1kFbRR9PIW2pgIcMt/fmHNIEARpc2RU
 Qa9Nurx7T63CQNzTez8sP0XNolncvE7M580a0BCQq3mTbYjeU14FGZKz3NV+0/DdRhly
 K36A+sVZ78N0edtmJZVKCEeCUEyucCZyteLsqtf3O1QNRKPW2CMgQENKAxOGNpjOsMcY
 1h2k+IhEzuTFG2W55jyKFnShPVJ9Fn5PcmmkvrHoxh100i/Hbk5JpyTYPzJqNVN509Ey
 Kk2Q==
X-Gm-Message-State: AO0yUKUB+UKqD6Dd9+xffwx5ATE2QG5Vo4EQyWW4LhhyV56n0a63YyIp
 f61zFK3ZRT8vO0z7770zOeYJ2g8=
X-Google-Smtp-Source: AK7set9ltDyUBg0Yk4tQF6bp/5fec5LHU/n8GtM/kmq1jFzcUrHIUm5pIjwwd/JRrTdvWA45P4H5Yw==
X-Received: by 2002:ac8:5bd6:0:b0:3b8:2eca:e6a5 with SMTP id
 b22-20020ac85bd6000000b003b82ecae6a5mr1368152qtb.29.1675717424083; 
 Mon, 06 Feb 2023 13:03:44 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 f3-20020ac84703000000b003b2d890752dsm7929401qtp.88.2023.02.06.13.03.43
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 06 Feb 2023 13:03:43 -0800 (PST)
Date: Mon, 6 Feb 2023 16:03:42 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Sergey Shtylyov <s.shtylyov@omp.ru>
Message-ID: <Y+FrLt8gt/Pff/zZ@redhat.com>
References: <c8c9df45-1d59-3195-7631-51b3a58148ee@omp.ru>
 <alpine.LRH.2.21.2301180658250.13031@file01.intranet.prod.int.rdu2.redhat.com>
 <b8269463-9f7e-4c28-2bfe-44663f3764c1@omp.ru>
MIME-Version: 1.0
In-Reply-To: <b8269463-9f7e-4c28-2bfe-44663f3764c1@omp.ru>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] md: dm-ioctl: drop always-false condition
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
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
 lvc-patches@linuxtesting.org, Alasdair Kergon <agk@redhat.com>,
 linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Feb 06 2023 at  3:58P -0500,
Sergey Shtylyov <s.shtylyov@omp.ru> wrote:

> On 1/18/23 2:59 PM, Mikulas Patocka wrote:
> 
> [...]
> 
> >> The expression 'indata[3] > ULONG_MAX' always evaluates to false since
> >> indata[] is declared as an array of *unsigned long* elements and #define
> >> ULONG_MAX represents the max value of that exact type...
> >>
> >> Note that gcc seems to be able to detect the dead code here and eliminate
> >> this check anyway...
> >>
> >> Found by Linux Verification Center (linuxtesting.org) with the SVACE static
> >> analysis tool.
> >>
> >> Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
> > 
> > Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
> 
>    Thank you!
> 
> >> ---
> >> This patch is atop of the 'for-next' branch of the device-mapper repo...
> >>
> >>  drivers/md/dm-ioctl.c |    3 +--
> >>  1 file changed, 1 insertion(+), 2 deletions(-)
> >>
> >> Index: linux-dm/drivers/md/dm-ioctl.c
> >> ===================================================================
> >> --- linux-dm.orig/drivers/md/dm-ioctl.c
> >> +++ linux-dm/drivers/md/dm-ioctl.c
> >> @@ -1073,8 +1073,7 @@ static int dev_set_geometry(struct file
> 
>    Returning to this patch, I think I should've added the name of the function
> in question in both the subject and and commit msg... I'll recast...

Not a big deal, I've already staged it so please don't resend.

See:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-6.3&id=151d812251202aa0dce1fdeabd64794292d40b75

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


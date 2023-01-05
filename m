Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3055C3DA7A
	for <dm-devel@archiver.kernel.org>; Thu,  5 Jan 2023 07:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1672904796;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=uexpQbcD0DiawlfCRcyUeA5h7DNzCtTs72Mrlmzv1oc=;
	b=dtl/Nh1/lEiQQ3CjpfqPAyxlGLNusAB8IYdD4aOMk0FSKcCvBUbKEtvx5tyofUdfPBQHfp
	rstJvxoUO3uQdgCJjGJb2wQ8uRdObLnzj4U970ZlF64QN7FpE8tIn8yGzljSUSAXvWBxIY
	vEhNn5+4A3PKBZuzQxICojhfR/yNybE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-235-hG7DjICSOZ-N-mAnguBteg-1; Thu, 05 Jan 2023 02:46:33 -0500
X-MC-Unique: hG7DjICSOZ-N-mAnguBteg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C318E18E5281;
	Thu,  5 Jan 2023 07:46:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ABB4DC15BAD;
	Thu,  5 Jan 2023 07:46:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0CB9C1946A79;
	Thu,  5 Jan 2023 07:46:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3DC061946589
 for <dm-devel@listman.corp.redhat.com>; Thu,  5 Jan 2023 00:53:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 114837AE5; Thu,  5 Jan 2023 00:53:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0970A51E5
 for <dm-devel@redhat.com>; Thu,  5 Jan 2023 00:53:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DDE692806042
 for <dm-devel@redhat.com>; Thu,  5 Jan 2023 00:53:01 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-445-q3iT633cMIK9e8Z9zOjugw-1; Wed, 04 Jan 2023 19:52:59 -0500
X-MC-Unique: q3iT633cMIK9e8Z9zOjugw-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 6681FB81980;
 Thu,  5 Jan 2023 00:44:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28C55C433D2;
 Thu,  5 Jan 2023 00:44:34 +0000 (UTC)
Received: by mail-lf1-f45.google.com with SMTP id bf43so52915661lfb.6;
 Wed, 04 Jan 2023 16:44:34 -0800 (PST)
X-Gm-Message-State: AFqh2kq1F4d/5LN5n08K579X1wJpn2fymsImkOR4cU6J/6C45YJY5nbB
 yKXMLp0Bcjr5VR3VLuRV0usjiX0naySgGHagRfc=
X-Google-Smtp-Source: AMrXdXtprpsBrqI3b3IFTlFhxNSRfwqsK8W3eL1jzaanesPzAA6Cg+EmGpeS+vdg9VSSspb9DeFkw6mWAHBLV8d6UoM=
X-Received: by 2002:a19:640f:0:b0:4b6:e71d:94a6 with SMTP id
 y15-20020a19640f000000b004b6e71d94a6mr3543316lfb.476.1672879472160; Wed, 04
 Jan 2023 16:44:32 -0800 (PST)
MIME-Version: 1.0
References: <20230105003759.GA1769545@paulmck-ThinkPad-P17-Gen-1>
 <20230105003813.1770367-14-paulmck@kernel.org>
In-Reply-To: <20230105003813.1770367-14-paulmck@kernel.org>
From: Song Liu <song@kernel.org>
Date: Wed, 4 Jan 2023 16:44:19 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6g4g_02iK3YwpkRQMwr8DBQSdVWnrOx0oYdaNWAWcX5g@mail.gmail.com>
Message-ID: <CAPhsuW6g4g_02iK3YwpkRQMwr8DBQSdVWnrOx0oYdaNWAWcX5g@mail.gmail.com>
To: "Paul E. McKenney" <paulmck@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Thu, 05 Jan 2023 07:46:22 +0000
Subject: Re: [dm-devel] [PATCH rcu 14/27] drivers/md: Remove "select SRCU"
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
Cc: linux-raid@vger.kernel.org, kernel-team@meta.com,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 rostedt@goodmis.org, rcu@vger.kernel.org, dm-devel@redhat.com,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jan 4, 2023 at 4:38 PM Paul E. McKenney <paulmck@kernel.org> wrote:
>
> Now that the SRCU Kconfig option is unconditionally selected, there is
> no longer any point in selecting it.  Therefore, remove the "select SRCU"
> Kconfig statements.
>
> Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> Cc: Song Liu <song@kernel.org>
> Cc: Alasdair Kergon <agk@redhat.com>
> Cc: Mike Snitzer <snitzer@kernel.org>
> Cc: <dm-devel@redhat.com>
> Cc: <linux-raid@vger.kernel.org>

Acked-by: Song Liu <song@kernel.org>

> ---
>  drivers/md/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index 998a5cfdbc4e9..5f1e2593fad7e 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -6,7 +6,6 @@
>  menuconfig MD
>         bool "Multiple devices driver support (RAID and LVM)"
>         depends on BLOCK
> -       select SRCU
>         help
>           Support multiple physical spindles through a single logical device.
>           Required for RAID and logical volume management.
> --
> 2.31.1.189.g2e36527f23
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


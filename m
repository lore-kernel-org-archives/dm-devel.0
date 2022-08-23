Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7CBFC00140
	for <dm-devel@archiver.kernel.org>; Wed, 24 Aug 2022 07:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661326624;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=8n9P4wHw4jhtWDbcygIbUwU1QVcu0ck5xz4krzx2QJQ=;
	b=T80KdCqHc7vyinqVCb/+TLd5oH45eSMxUwSzxD247JQB5YP70LcE6K2KrkN2WeRjfB9Xc7
	j0LUOWG00Wc9JqW4DWfUBPUL4lCDEbPnQ4p6djI+x94ZjW2WCl/A6VieFqP9vn1zR1lO/s
	voanH+Vu8lL69YTODyRYqVvu+H6w4TA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-wduPfh5SO3OX86kxwwM4nw-1; Wed, 24 Aug 2022 03:37:01 -0400
X-MC-Unique: wduPfh5SO3OX86kxwwM4nw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 34AC3294EDE4;
	Wed, 24 Aug 2022 07:36:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 23170492C3B;
	Wed, 24 Aug 2022 07:36:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F230E1946A42;
	Wed, 24 Aug 2022 07:36:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4B06A1946A40
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 Aug 2022 17:46:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3C9ED2026D64; Tue, 23 Aug 2022 17:46:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 390CD2026D4C
 for <dm-devel@redhat.com>; Tue, 23 Aug 2022 17:46:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1F9C829DD9A3
 for <dm-devel@redhat.com>; Tue, 23 Aug 2022 17:46:49 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-348-OoAKoDx8O2GvQLihJd1KdQ-1; Tue, 23 Aug 2022 13:46:47 -0400
X-MC-Unique: OoAKoDx8O2GvQLihJd1KdQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 73E2C61629;
 Tue, 23 Aug 2022 17:46:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2950C433D7;
 Tue, 23 Aug 2022 17:46:45 +0000 (UTC)
Received: by mail-yw1-f177.google.com with SMTP id
 00721157ae682-324ec5a9e97so398825117b3.7; 
 Tue, 23 Aug 2022 10:46:45 -0700 (PDT)
X-Gm-Message-State: ACgBeo2C0Xj0LWwNKuqqKew5l+F1VHy0WPFtF1qzzIA+5XcU0CDjbWhE
 8mNy7wOw356WDuCZMftnF3KGZ9ONX2h4Qz4udtA=
X-Google-Smtp-Source: AA6agR4p0U3TeJNvdFofG46Krctsvf0ACF0C/916DEUToOrwC9aXZqAetTciGDKMj6tXNUDVyBER7sgeu4ai4f5r3Q4=
X-Received: by 2002:a05:6902:725:b0:695:b0c7:a248 with SMTP id
 l5-20020a056902072500b00695b0c7a248mr10341711ybt.389.1661276804849; Tue, 23
 Aug 2022 10:46:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220818210027.6964-1-wsa+renesas@sang-engineering.com>
In-Reply-To: <20220818210027.6964-1-wsa+renesas@sang-engineering.com>
From: Song Liu <song@kernel.org>
Date: Tue, 23 Aug 2022 10:46:33 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6ve-1Y2ZCWrmQ7+U2u+X=oQSoDLso=PUDAGc_98y-v6A@mail.gmail.com>
Message-ID: <CAPhsuW6ve-1Y2ZCWrmQ7+U2u+X=oQSoDLso=PUDAGc_98y-v6A@mail.gmail.com>
To: Wolfram Sang <wsa+renesas@sang-engineering.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Mailman-Approved-At: Wed, 24 Aug 2022 07:36:57 +0000
Subject: Re: [dm-devel] [PATCH] md: move from strlcpy with unused retval to
 strscpy
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
Cc: linux-raid <linux-raid@vger.kernel.org>, dm-devel@redhat.com,
 Mike Snitzer <snitzer@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Aug 18, 2022 at 2:00 PM Wolfram Sang
<wsa+renesas@sang-engineering.com> wrote:
>
> Follow the advice of the below link and prefer 'strscpy' in this
> subsystem. Conversion is 1:1 because the return value is not used.
> Generated by a coccinelle script.
>
> Link: https://lore.kernel.org/r/CAHk-=wgfRnXz0W3D37d01q3JFkr_i_uTL=V6A6G1oUZcprmknw@mail.gmail.com/
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>

Looks good to me.

Alasdair and Mike,

This patch touches both dm and md code. Would you like me to take it
via the md tree?

Thanks,
Song

> ---
>  drivers/md/dm-ioctl.c | 4 ++--
>  drivers/md/md.c       | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> index 98976aaa9db9..6148fb73ccb4 100644
> --- a/drivers/md/dm-ioctl.c
> +++ b/drivers/md/dm-ioctl.c
> @@ -921,9 +921,9 @@ static struct hash_cell *__find_device_hash_cell(struct dm_ioctl *param)
>          * Sneakily write in both the name and the uuid
>          * while we have the cell.
>          */
> -       strlcpy(param->name, hc->name, sizeof(param->name));
> +       strscpy(param->name, hc->name, sizeof(param->name));
>         if (hc->uuid)
> -               strlcpy(param->uuid, hc->uuid, sizeof(param->uuid));
> +               strscpy(param->uuid, hc->uuid, sizeof(param->uuid));
>         else
>                 param->uuid[0] = '\0';
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index afaf36b2f6ab..4d019ac0a549 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5743,7 +5743,7 @@ static int add_named_array(const char *val, const struct kernel_param *kp)
>                 len--;
>         if (len >= DISK_NAME_LEN)
>                 return -E2BIG;
> -       strscpy(buf, val, len+1);
> +       strscpy(buf, val, len + 1);
>         if (strncmp(buf, "md_", 3) == 0)
>                 return md_alloc_and_put(0, buf);
>         if (strncmp(buf, "md", 2) == 0 &&
> --
> 2.35.1
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


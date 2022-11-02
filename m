Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1848C433FE
	for <dm-devel@archiver.kernel.org>; Thu,  3 Nov 2022 07:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667462245;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=F9aG2A5GQwrHbUcxyn/Efe90uUKEwH6KtBd8zxs4UAk=;
	b=Y7F3PRxJLPyTph+MLHljo0xlbzrgqgU10C3mr59Aly5dQAvYrFiqBY7tZC5KZONni8yIKD
	TMHn9tF14Uk6w1+U9+d5wFzkgUQxdy667aTtbel9R8Hi62Uje4rzB9pmxRrvRhpq9hk763
	wlguyeoeOH1NWXGySP6Xahi9SfFGIlM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-615-CQGeNitKPN6E0JTN1yBMTA-1; Thu, 03 Nov 2022 03:57:23 -0400
X-MC-Unique: CQGeNitKPN6E0JTN1yBMTA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A868E101A52A;
	Thu,  3 Nov 2022 07:57:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 974C840C6EC3;
	Thu,  3 Nov 2022 07:57:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8AF7B19465B3;
	Thu,  3 Nov 2022 07:57:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AF5821946594
 for <dm-devel@listman.corp.redhat.com>; Wed,  2 Nov 2022 17:10:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 985A61400C30; Wed,  2 Nov 2022 17:10:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 91965140EBF5
 for <dm-devel@redhat.com>; Wed,  2 Nov 2022 17:10:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1FCEE8027F5
 for <dm-devel@redhat.com>; Wed,  2 Nov 2022 17:10:33 +0000 (UTC)
Received: from hermod.demsh.org (hermod.demsh.org [45.140.147.175]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-596-j43ZuVWTOI6tevKBk9Zu3Q-1; Wed,
 02 Nov 2022 13:10:24 -0400
X-MC-Unique: j43ZuVWTOI6tevKBk9Zu3Q-1
Received: from xps.demsh.org (algiz.demsh.org [94.103.82.47])
 by hermod.demsh.org (OpenSMTPD) with ESMTPSA id 35dc3627
 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO) auth=yes user=me; 
 Wed, 2 Nov 2022 17:03:38 +0000 (UTC)
Date: Wed, 2 Nov 2022 20:03:45 +0300
From: Dmitrii Tcvetkov <me@demsh.org>
To: Keith Busch <kbusch@kernel.org>
Message-ID: <20221102200345.0800a8bf@xps.demsh.org>
In-Reply-To: <Y2KXfNZzwPZBJRTW@kbusch-mbp.dhcp.thefacebook.com>
References: <Y2Hf08vIKBkl5tu0@sol.localdomain>
 <Y2KEH6OZ0MDf5cSh@kbusch-mbp.dhcp.thefacebook.com>
 <Y2KXfNZzwPZBJRTW@kbusch-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Thu, 03 Nov 2022 07:57:17 +0000
Subject: Re: [dm-devel] Regression: wrong DIO alignment check with dm-crypt
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
Cc: Eric Biggers <ebiggers@kernel.org>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 2 Nov 2022 10:14:52 -0600
Keith Busch <kbusch@kernel.org> wrote:
> This is what I'm coming up with. Only compile tested (still setting up
> an enviroment to actually run it).
> 
> ---
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 159c6806c19b..9334e58a4c9f 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -43,6 +43,7 @@
>  #include <linux/device-mapper.h>
>  
>  #include "dm-audit.h"
> +#include "dm-core.h"
>  
>  #define DM_MSG_PREFIX "crypt"
>  
> @@ -3615,7 +3616,9 @@ static int crypt_iterate_devices(struct
> dm_target *ti, 
>  static void crypt_io_hints(struct dm_target *ti, struct queue_limits
> *limits) {
> +	struct mapped_device *md = dm_table_get_md(ti->table);
>  	struct crypt_config *cc = ti->private;
> +	struct request_queue *q = md->queue;
>  
>  	/*
>  	 * Unfortunate constraint that is required to avoid the
> potential @@ -3630,6 +3633,8 @@ static void crypt_io_hints(struct
> dm_target *ti, struct queue_limits *limits)
> limits->physical_block_size = max_t(unsigned,
> limits->physical_block_size, cc->sector_size); limits->io_min =
> max_t(unsigned, limits->io_min, cc->sector_size); +
> +	blk_queue_dma_alignment(q, limits->logical_block_size - 1);
>  }
>  
>  static struct target_type crypt_target = {
> --

Applied on top 6.1-rc3, the issue still reproduces.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


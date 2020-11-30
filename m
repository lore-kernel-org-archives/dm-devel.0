Return-Path: <SRS0=s6zu=FE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E86ACC63777
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 17:30:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 560BB20825
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 17:30:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NKr0UWc2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 560BB20825
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1606757438;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=1rvY6i5IovSit8IdO5vz9yhRdUzMHi+0Wqkk+bfa5xI=;
	b=NKr0UWc2OiQuRemzneJgJSV5eUyI9/zZlYaXD6Y25pYmCaKH/+Oj9ztOnANZl+v1/xOo0g
	rad9NOk2eC8GURbXCxIuDheAzZrAMzJABR2d3alrDtiKyO9KMEuqq55Ig1FbWjjjXcFNOJ
	0ok0xh0VbI3/MblA/KMrN/4mc1MkW9Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-_q7J5EJ4NeqCxpnlrxLzug-1; Mon, 30 Nov 2020 12:30:35 -0500
X-MC-Unique: _q7J5EJ4NeqCxpnlrxLzug-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2461F835DE2;
	Mon, 30 Nov 2020 17:30:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 04CE25D970;
	Mon, 30 Nov 2020 17:30:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C5B49180954D;
	Mon, 30 Nov 2020 17:30:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AUHUSxx004169 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 30 Nov 2020 12:30:28 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 875E62026D46; Mon, 30 Nov 2020 17:30:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 819C82026D49
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 17:30:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 49FA11871CC5
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 17:30:25 +0000 (UTC)
Received: from mail-qt1-f193.google.com (mail-qt1-f193.google.com
	[209.85.160.193]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-342-FCOvV0b6OOWn_1YbvC6nbA-1; Mon, 30 Nov 2020 12:30:20 -0500
X-MC-Unique: FCOvV0b6OOWn_1YbvC6nbA-1
Received: by mail-qt1-f193.google.com with SMTP id f15so8715058qto.13;
	Mon, 30 Nov 2020 09:30:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=2ujODu3GPu0HD446PLi4nC6Ve/9CjbsHnV5fvKNJVzI=;
	b=ItiZFmIcIxayHMsdCCEvm2EY80APhmj4AXTIwga12xL8ZrAPmkNcWe4/s9Go5qs6mI
	vHYLToJr3AnVLjJcNUWa0i70vMKtrs7nVNrSGmTbY8Um+qr4MyYXeB7m76XlUuclXku2
	2T2kOPCT0VZ+eXep3RHjmlC9u/d3IbBKru5G4Fi1Ce1psczODx44qkVFa5SnnMDPryv+
	r/1y0x/WgwJYttgbKLCFkWZrp/z7/w7TD8uw3A19J9xOM0EC+7btbZmx82YIHQ9Jnzyi
	ydORKpQrucwvNI2qEvTebZwK75K/vi1sBxpjWubQmYOwlFY+idwsSSciHcpy23LIk4lf
	Obgg==
X-Gm-Message-State: AOAM531UvnQ+r4obu3dVUmOeJc960qYBDVNa33mW/38xsFXsu+fT1qTt
	nZrCdZNVVPFIgLJpyOX336HB8kg4gK8=
X-Google-Smtp-Source: ABdhPJwPgqabZkm+GE8l02BWkkihXJ6szs7qbtAbSsbW4gFnNwvTcR4Vx6vAl80/D/yvAJ7YL5xBtw==
X-Received: by 2002:ac8:2a2a:: with SMTP id k39mr23516929qtk.232.1606757419804;
	Mon, 30 Nov 2020 09:30:19 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	k15sm15966746qke.75.2020.11.30.09.30.18
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Mon, 30 Nov 2020 09:30:19 -0800 (PST)
Date: Mon, 30 Nov 2020 12:30:18 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Kirill Tkhai <ktkhai@virtuozzo.com>
Message-ID: <20201130173018.GA77957@lobo>
References: <160633733483.339234.11951322983778059158.stgit@localhost.localdomain>
MIME-Version: 1.0
In-Reply-To: <160633733483.339234.11951322983778059158.stgit@localhost.localdomain>
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
Cc: dm-devel@redhat.com, Bruce Johnston <bjohnsto@redhat.com>,
	John Dorminy <jdorminy@redhat.com>, agk@redhat.com
Subject: Re: [dm-devel] dm: Devices not having .iterate_devices may want to
 set max_io_len
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Nov 25 2020 at  3:49pm -0500,
Kirill Tkhai <ktkhai@virtuozzo.com> wrote:

> After commit 5091cdec56fa "dm: change max_io_len() to use
> blk_max_size_offset()" my out-of-tree driver stopped to work.
> The reason is that now ti->max_io_len from such target is ignored:
> max_io_len() ignores ti->max_io_len, while
> dm_calculate_queue_limits() never stacks ti->chunk_sectors into
> ti_limits.chunk_sectors.
> 
> Here I see two possible solutions, both are in dm_calculate_queue_limits():
> 
> 1)Move ti_limits.chunk_sectors assignment down, so it will be made
> right under combine_limits label. Thus, every time ti->max_io_len
> will transform into chunk_sectors, even in case of device
> has no .iterate_devices method;
> 
> 2)Move io_hints call under the label (like it's made in this patch),
> so one can set desired chunk_sectors there.
> 
> First solution looks less clear, since in two drivers chunk_sectors
> are assigned in io_hints (see unstripe_io_hints() and dmz_io_hints()),
> and this rewrites, and we should not rewrite it.
> 
> Second solution does not break anything since we change only
> order with ->iterate_devices(device_area_is_invalid), while
> device_area_is_invalid never touches chunk_sectors. So I choosed it.
> 
> Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
> ---
>  drivers/md/dm-table.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 2073ee8d18f4..9994c767dc82 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -1453,10 +1453,6 @@ int dm_calculate_queue_limits(struct dm_table *table,
>  		if (ti->max_io_len)
>  			ti_limits.chunk_sectors = lcm_not_zero(ti->max_io_len,
>  							       ti_limits.chunk_sectors);
> -		/* Set I/O hints portion of queue limits */
> -		if (ti->type->io_hints)
> -			ti->type->io_hints(ti, &ti_limits);
> -
>  		/*
>  		 * Check each device area is consistent with the target's
>  		 * overall queue limits.
> @@ -1466,6 +1462,10 @@ int dm_calculate_queue_limits(struct dm_table *table,
>  			return -EINVAL;
>  
>  combine_limits:
> +		/* Set I/O hints portion of queue limits */
> +		if (ti->type->io_hints)
> +			ti->type->io_hints(ti, &ti_limits);
> +
>  		/*
>  		 * Merge this target's queue limits into the overall limits
>  		 * for the table.
> 
> 

Sorry for the slow response, just got back from PTO today.

So while I appreciate that commit 5091cdec56fa caused your DM target to
regress I don't think the proper solution is for your driver to take on
setting chunk_sectors based on the ti->max_io_len you've established.

The use of chunk_sectors is an implementation detail.  One that every DM
target that doesn't establish .iterate_devices should not need to take
on worrying about.

Your above proposed patch changes DM core to _start_ to fix the
regression you've reported but still requires your DM target to change
too.  Does you DM target have one or more data device(s)?  If so you
really should have it provide a .iterate_devices hook.  But that aside,
here is the fix I'll be staging in linux-next shortly and that I'll be
sending to Linus by the end of the week:

From: Mike Snitzer <snitzer@redhat.com>
Date: Mon, 30 Nov 2020 10:57:43 -0500
Subject: [PATCH] dm table: fix IO splitting

Commit 882ec4e609c1 ("dm table: stack 'chunk_sectors' limit to account
for target-specific splitting") caused a regression for a couple
reasons:

1) Using lcm_not_zero() instead of min_not_zero() when stacking
   chunk_sectors was a bug because chunk_sectors must reflect the most
   limited of all devices in the IO stack.
2) DM targets that set max_io_len but that do _not_ provide an
   .iterate_devices method no longer had there IO split properly.

dm_calculate_queue_limits() must establish the appropriate IO
splitting limits early, without any dependency on iterating
data_devices, otherwise IO will not be split as intended.

Fixes: 882ec4e609c1 ("dm table: stack 'chunk_sectors' limit to account for target-specific splitting")
Cc: stable@vger.kernel.org
Reported-by: John Dorminy <jdorminy@redhat.com>
Reported-by: Bruce Johnston <bjohnsto@redhat.com>
Reported-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-table.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 2073ee8d18f4..4e58f5c68ac0 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -18,7 +18,6 @@
 #include <linux/mutex.h>
 #include <linux/delay.h>
 #include <linux/atomic.h>
-#include <linux/lcm.h>
 #include <linux/blk-mq.h>
 #include <linux/mount.h>
 #include <linux/dax.h>
@@ -1431,6 +1430,10 @@ int dm_calculate_queue_limits(struct dm_table *table,
 
 		ti = dm_table_get_target(table, i);
 
+		/* Set appropriate limits if target-specific splitting is required */
+		if (ti->max_io_len)
+			ti_limits.chunk_sectors = ti->max_io_len;
+
 		if (!ti->type->iterate_devices)
 			goto combine_limits;
 
@@ -1449,10 +1452,6 @@ int dm_calculate_queue_limits(struct dm_table *table,
 			zone_sectors = ti_limits.chunk_sectors;
 		}
 
-		/* Stack chunk_sectors if target-specific splitting is required */
-		if (ti->max_io_len)
-			ti_limits.chunk_sectors = lcm_not_zero(ti->max_io_len,
-							       ti_limits.chunk_sectors);
 		/* Set I/O hints portion of queue limits */
 		if (ti->type->io_hints)
 			ti->type->io_hints(ti, &ti_limits);
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


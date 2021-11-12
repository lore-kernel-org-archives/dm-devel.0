Return-Path: <SRS0=25Tj=P7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E194BC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 12 Nov 2021 15:09:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 880CF60F4B
	for <dm-devel@archiver.kernel.org>; Fri, 12 Nov 2021 15:09:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 880CF60F4B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1636729796;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ac1DVF8uvRwygcWPd30F3qkFVmcLO4wV2ZNGEm9ACVU=;
	b=EoQRbSy4W28C6cx5M5oUzA7w5XiSsAQx0KcrvLNuwvthRF2iARQ7516sNDs4NAJjCx1YSj
	msPceR+yrOksIIdcPoP7/QHmJb/y2KJAJWyKijJ8UCvmDdL2X6DAEGYOHdHC/0BZvThkiG
	SmfZXzh21GNG3gm9/rS+6KHl2n7shwM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-573-6XwbQmZTMjyKhLydxCO2EA-1; Fri, 12 Nov 2021 10:09:55 -0500
X-MC-Unique: 6XwbQmZTMjyKhLydxCO2EA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D2FF87D542;
	Fri, 12 Nov 2021 15:09:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5E0BE5FC23;
	Fri, 12 Nov 2021 15:09:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 87F174E58F;
	Fri, 12 Nov 2021 15:09:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ACF9kjU013289 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 12 Nov 2021 10:09:46 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A6F804010FF7; Fri, 12 Nov 2021 15:09:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A057840CFD0E
	for <dm-devel@redhat.com>; Fri, 12 Nov 2021 15:09:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 841CF803D79
	for <dm-devel@redhat.com>; Fri, 12 Nov 2021 15:09:46 +0000 (UTC)
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
	[209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-432-n2U-mEX1NBKoT6JOclFFmg-1; Fri, 12 Nov 2021 10:09:45 -0500
X-MC-Unique: n2U-mEX1NBKoT6JOclFFmg-1
Received: by mail-qt1-f200.google.com with SMTP id
	k1-20020ac80c01000000b002a79e319399so7447566qti.8
	for <dm-devel@redhat.com>; Fri, 12 Nov 2021 07:09:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=m8wjvVSjO04BUbkKGsTBTVULT6cd2cgB0v+0Q9ngovI=;
	b=qZ8CjACRTJKQFLh2dtUPhIupyXETgrmN+6wpTPteOlXR4nMXJAAqKC++mCr8H33ErL
	Lzjloek3xyucB6jaABnqan3/xeY94CNnH+J7oMarX2z9XMEMnONXJTGyRG7jjlWVW8+p
	G5Ih1TODrTCZuzeQbQiKVqyfJufmL9gPUAs9SgB8tpYAD8QRdFBlXvbqaFEWkA7PB8VP
	o/3N+/UP3tFwfU37m6XCsGXvfSEdH2e86S+ciMGxpoyoZ/XlL8zkm3DXEPSEKAqBMTIs
	4SedT6b7qo/X3Ya0RMhaobIg4ePtck/TJ0c7xoU/6X3nHAHaGzzKuyJIsYhLBIeONThN
	XXLg==
X-Gm-Message-State: AOAM530WXJqP+tS9RAcyQbfA+aD2ooBlvFhEWl82azACs4XiOD5iVpRh
	y8W1K8xkUjq9h9SDR4uO0uIFIyrVcFEzBSTHxrFV869v2J/TyUWhRr2eS2iw7SMqpZMrDESrk/4
	46X65SVyEjbTzmw==
X-Received: by 2002:a05:620a:280d:: with SMTP id
	f13mr12862075qkp.31.1636729784794; 
	Fri, 12 Nov 2021 07:09:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyonI7are665jPN4yxD09tOYZibEQWeHpUqQ6sWWPo/7YEoc54YCv4QEI2cQ78SIsxGcGbCsQ==
X-Received: by 2002:a05:620a:280d:: with SMTP id
	f13mr12862056qkp.31.1636729784622; 
	Fri, 12 Nov 2021 07:09:44 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	s22sm2983160qko.88.2021.11.12.07.09.44
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 12 Nov 2021 07:09:44 -0800 (PST)
Date: Fri, 12 Nov 2021 10:09:43 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: cgel.zte@gmail.com
Message-ID: <YY6Dt+Wy4rfHwgXw@redhat.com>
References: <20211111075331.158061-1-ran.jianping@zte.com.cn>
MIME-Version: 1.0
In-Reply-To: <20211111075331.158061-1-ran.jianping@zte.com.cn>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, ran jianping <ran.jianping@zte.com.cn>,
	linux-kernel@vger.kernel.org, agk@redhat.com,
	Zeal Robot <zealci@zte.com.cn>
Subject: Re: [dm-devel] dm: remove unneeded variable
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Nov 11 2021 at  2:53P -0500,
cgel.zte@gmail.com <cgel.zte@gmail.com> wrote:

> From: ran jianping <ran.jianping@zte.com.cn>
> 
> Fix the following coccicheck review:
> ./drivers/md/dm-ps-round-robin.c:91:5-7:Unneeded variable
> 
> Remove unneeded variable used to store return value.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: ran jianping <ran.jianping@zte.com.cn>
> ---
>  drivers/md/dm-ps-round-robin.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-ps-round-robin.c b/drivers/md/dm-ps-round-robin.c
> index 27f44c5fa04e..455fc02af1cf 100644
> --- a/drivers/md/dm-ps-round-robin.c
> +++ b/drivers/md/dm-ps-round-robin.c
> @@ -88,7 +88,6 @@ static int rr_status(struct path_selector *ps, struct dm_path *path,
>  		     status_type_t type, char *result, unsigned int maxlen)
>  {
>  	struct path_info *pi;
> -	int sz = 0;
>  
>  	if (!path)
>  		DMEMIT("0 ");
> @@ -107,7 +106,7 @@ static int rr_status(struct path_selector *ps, struct dm_path *path,
>  		}
>  	}
>  
> -	return sz;
> +	return 0;
>  }
>  
>  /*
> -- 
> 2.25.1
> 

You clearly didn't even	compile	test this (hint: DMEMIT macro uses it).

Nacked-by: Mike Snitzer <snitzer@redhat.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


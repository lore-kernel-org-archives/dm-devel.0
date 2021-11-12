Return-Path: <SRS0=25Tj=P7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B328C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 12 Nov 2021 15:09:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B102761078
	for <dm-devel@archiver.kernel.org>; Fri, 12 Nov 2021 15:09:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B102761078
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1636729772;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=GM2RYC1u3SeT68ChdOn8VPddtQu/RHa3QmamRyipd90=;
	b=OyP6WPNjpWtSXNdZfPr9izwQb/PvVXaBf9jt5ZdbY9w/piXpKMqelKexd446yG78pwvMWe
	hLjpw+cNGTTv2r6kwQ7EXw4VNj76NmtOsL9JFEblJ/PIJBU+wXRQyPlHzY+k3RjVY5O6pH
	8hJhdTOt6LhFvvOZrZ0kvbsPd6RW85g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-XOv29_-qMo-ImROmtm4qWw-1; Fri, 12 Nov 2021 10:09:29 -0500
X-MC-Unique: XOv29_-qMo-ImROmtm4qWw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5AAD710151E2;
	Fri, 12 Nov 2021 15:09:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E905D18A50;
	Fri, 12 Nov 2021 15:09:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 47353181A1CF;
	Fri, 12 Nov 2021 15:09:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ACF9GAO013263 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 12 Nov 2021 10:09:16 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 75BD651E4; Fri, 12 Nov 2021 15:09:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7046751E3
	for <dm-devel@redhat.com>; Fri, 12 Nov 2021 15:09:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1971D802A59
	for <dm-devel@redhat.com>; Fri, 12 Nov 2021 15:09:11 +0000 (UTC)
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
	[209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-543-CN4qUlTfMd2RdTvEvgP2FQ-1; Fri, 12 Nov 2021 10:09:09 -0500
X-MC-Unique: CN4qUlTfMd2RdTvEvgP2FQ-1
Received: by mail-qk1-f197.google.com with SMTP id
	ay9-20020a05620a178900b00462db20ac02so6594923qkb.10
	for <dm-devel@redhat.com>; Fri, 12 Nov 2021 07:09:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=M10JDtvNwjvlnkeGVOpBppOKaiUG/M9CfxdoBw1FJ1Q=;
	b=tbYiiYxc0snb8k5X9K5R4sZv6EmXK8aR5Kk+Q8lsNfaPhXtqLVMIDDcjNAoNbS8QGW
	kWW107s9sob9Jnljkl46VgZh5wlqXBj5gkRAkqi2doAQvLItEx6FRHDzXFtEvEpxFzf2
	wIiwAvXQCeiz/BLtNIzqe9mze0NkgCOHwykzObNnkn7wYZMu1ihm3PKPHCYt9CMLvsqW
	b1eS7OA/NU6/sag5s4KmGNiSARHCtYGmEpitqqRODgHPcc/jVX0AwFY0TtsQXSaI233H
	q41djFGvvOU4KTCaYb5Jk7EeF07ryRDh8DO2EcvQu1Y3NRxwQooiJPNkUC+tpyxDG+9E
	Lupg==
X-Gm-Message-State: AOAM531lTDRA72TWfn9zTzyey0IICGPdq1a2XDM/WMjVf4xZ5Rs5cKdc
	gTlTqwTa8PunyGseElSk6umEID2BvN9OCqtf9mXCPKvyV//czTc51uPBTQCXzIWU+WX2nMWi9Gw
	Nad5GdMzoSku2kw==
X-Received: by 2002:a05:622a:178c:: with SMTP id
	s12mr4207074qtk.43.1636729749104; 
	Fri, 12 Nov 2021 07:09:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwmFsBQzyEWJpJEozEoeqjviaanWHxvfbd5LPTmTA2qoHP6BZRuewV/ctP4yDWvtHp2zQYKpQ==
X-Received: by 2002:a05:622a:178c:: with SMTP id
	s12mr4207040qtk.43.1636729748874; 
	Fri, 12 Nov 2021 07:09:08 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52])
	by smtp.gmail.com with ESMTPSA id b2sm2988808qtg.88.2021.11.12.07.09.08
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 12 Nov 2021 07:09:08 -0800 (PST)
Date: Fri, 12 Nov 2021 10:09:07 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: cgel.zte@gmail.com
Message-ID: <YY6Dk0TEQzorBlOU@redhat.com>
References: <20211111075659.158155-1-ran.jianping@zte.com.cn>
MIME-Version: 1.0
In-Reply-To: <20211111075659.158155-1-ran.jianping@zte.com.cn>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, ran jianping <ran.jianping@zte.com.cn>,
	linux-kernel@vger.kernel.org, agk@redhat.com,
	Zeal Robot <zealci@zte.com.cn>
Subject: Re: [dm-devel] dm snapshot: remove unneeded variable
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Nov 11 2021 at  2:56P -0500,
cgel.zte@gmail.com <cgel.zte@gmail.com> wrote:

> From: ran jianping <ran.jianping@zte.com.cn>
> 
> Fix the following coccicheck review:
> ./drivers/md/dm-snap-transient.c:91:10-12: Unneeded variable
> 
> Remove unneeded variable used to store return value.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: ran jianping <ran.jianping@zte.com.cn>
> ---
>  drivers/md/dm-snap-transient.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-snap-transient.c b/drivers/md/dm-snap-transient.c
> index 0e0ae4c36b37..d95b59855da0 100644
> --- a/drivers/md/dm-snap-transient.c
> +++ b/drivers/md/dm-snap-transient.c
> @@ -88,7 +88,6 @@ static unsigned transient_status(struct dm_exception_store *store,
>  				 status_type_t status, char *result,
>  				 unsigned maxlen)
>  {
> -	unsigned sz = 0;
>  
>  	switch (status) {
>  	case STATUSTYPE_INFO:
> @@ -101,7 +100,7 @@ static unsigned transient_status(struct dm_exception_store *store,
>  		break;
>  	}
>  
> -	return sz;
> +	return 0;
>  }
>  
>  static struct dm_exception_store_type _transient_type = {
> -- 
> 2.25.1
> 

You clearly didn't even compile test this.

Nacked-by: Mike Snitzer <snitzer@redhat.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


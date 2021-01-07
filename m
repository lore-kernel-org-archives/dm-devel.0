Return-Path: <SRS0=1Ivj=GK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 106ADC433E0
	for <dm-devel@archiver.kernel.org>; Thu,  7 Jan 2021 21:52:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 91BD923406
	for <dm-devel@archiver.kernel.org>; Thu,  7 Jan 2021 21:52:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 91BD923406
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1610056346;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=sGZxY8YDZLUhJTvltTHWqiseQJ/uWBSfJJfvYbasWk4=;
	b=IIErX+mC0Cqu7LeGFAEqxmZZaFlFW3AjEQo/nU37I6GgKCEIuuvqbkGxaUxOXQbGwIfx7j
	Go9Us6bMNu2e42dR5juBpfsZQy8YrosawEAW6IBcVOEvMooOZdmZQ46yH6tscQah3rPJar
	rVi8TRU+XrudGtomYoUhS7NeYk7RXHg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-313-UrVXo1-2M7acuIP1lM9Tfw-1; Thu, 07 Jan 2021 16:52:23 -0500
X-MC-Unique: UrVXo1-2M7acuIP1lM9Tfw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 216E2800D53;
	Thu,  7 Jan 2021 21:52:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C9EF66294D;
	Thu,  7 Jan 2021 21:52:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 80628180954D;
	Thu,  7 Jan 2021 21:52:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 107LqGOe024388 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 7 Jan 2021 16:52:16 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 04C6E60916; Thu,  7 Jan 2021 21:52:16 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 646AB60CC3;
	Thu,  7 Jan 2021 21:52:11 +0000 (UTC)
Date: Thu, 7 Jan 2021 16:52:10 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Jeffle Xu <jefflexu@linux.alibaba.com>
Message-ID: <20210107215210.GD21239@redhat.com>
References: <20201223112624.78955-1-jefflexu@linux.alibaba.com>
	<20201223112624.78955-5-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
In-Reply-To: <20201223112624.78955-5-jefflexu@linux.alibaba.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, io-uring@vger.kernel.org
Subject: Re: [dm-devel] [PATCH RFC 4/7] block: define blk_qc_t as uintptr_t
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Dec 23 2020 at  6:26am -0500,
Jeffle Xu <jefflexu@linux.alibaba.com> wrote:

> To support iopoll for bio-based device, the returned cookie is actually
> a pointer to an implementation specific object, e.g. an object
> maintaining all split bios.
> 
> In such case, blk_qc_t should be large enough to contain one pointer,
> for which uintptr_t is used here. Since uintptr_t is actually an integer
> type in essence, there's no need of type casting in the original mq
> path, while type casting is indeed needed in bio-based routine.
> 
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> ---
>  include/linux/types.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/types.h b/include/linux/types.h
> index da5ca7e1bea9..f6301014a459 100644
> --- a/include/linux/types.h
> +++ b/include/linux/types.h
> @@ -126,7 +126,7 @@ typedef u64 sector_t;
>  typedef u64 blkcnt_t;
>  
>  /* cookie used for IO polling */
> -typedef unsigned int blk_qc_t;
> +typedef uintptr_t blk_qc_t;
>  
>  /*
>   * The type of an index into the pagecache.

I'd just fold this into patch 6.. not seeing benefit to having this be
separate.

Patch 6's header needs a lot more detail anyway so..

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


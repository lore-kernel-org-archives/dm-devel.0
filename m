Return-Path: <SRS0=+b8E=IH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62BAFC433DB
	for <dm-devel@archiver.kernel.org>; Tue,  9 Mar 2021 20:15:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CF2666523A
	for <dm-devel@archiver.kernel.org>; Tue,  9 Mar 2021 20:15:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CF2666523A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1615320909;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=wNLEpokkkAtQoZ95yOfU8M4SSG76qTn0Sugl1e6LXjc=;
	b=F1QqeWNnxKFm5J99P67OSo9Cvw1egLFUcE/PyeUEdUpg8iEsnoqT51RQSKVZgqjEG26F4A
	xKzQSfaJ/53ilm5G1o0uUhCm+yqLh5lFD5K+joCwQcTDlshz86CiYlygwrVsepqmMYmw/v
	V1+B2So10Dc3wfRkKQ3fsrlL+F6hOvM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-445-gPPjnAq1MWePWIsMFpinSQ-1; Tue, 09 Mar 2021 15:15:07 -0500
X-MC-Unique: gPPjnAq1MWePWIsMFpinSQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1DAE58018A7;
	Tue,  9 Mar 2021 20:15:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E07719C46;
	Tue,  9 Mar 2021 20:14:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0FC9B1809C8B;
	Tue,  9 Mar 2021 20:14:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 129KEtaT025030 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 9 Mar 2021 15:14:55 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 77FBB5D9DE; Tue,  9 Mar 2021 20:14:55 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B15A5D9DB;
	Tue,  9 Mar 2021 20:14:50 +0000 (UTC)
Date: Tue, 9 Mar 2021 15:14:50 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Yang Li <yang.lee@linux.alibaba.com>
Message-ID: <20210309201449.GB16277@redhat.com>
References: <1615282320-28246-1-git-send-email-yang.lee@linux.alibaba.com>
MIME-Version: 1.0
In-Reply-To: <1615282320-28246-1-git-send-email-yang.lee@linux.alibaba.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, agk@redhat.com
Subject: Re: [dm-devel] dm: remove unneeded variable 'sz'
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Mar 09 2021 at  4:32am -0500,
Yang Li <yang.lee@linux.alibaba.com> wrote:

> Fix the following coccicheck warning:
> ./drivers/md/dm-ps-service-time.c:85:10-12: Unneeded variable: "sz".
> Return "0" on line 105
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>

This type of change gets proposed regaularly.  Would appreciate it if
you could fix coccicheck to not get this wrong.  The local 'sz' variable
is used by the DMEMIT macro (as the earlier reply to this email informed
you).

Also, had you tried to compile the code with your patch applied you'd
have quickly realized your patch wasn't correct.

Mike


> ---
>  drivers/md/dm-ps-service-time.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-ps-service-time.c b/drivers/md/dm-ps-service-time.c
> index 9cfda66..12dd5ce 100644
> --- a/drivers/md/dm-ps-service-time.c
> +++ b/drivers/md/dm-ps-service-time.c
> @@ -82,7 +82,6 @@ static void st_destroy(struct path_selector *ps)
>  static int st_status(struct path_selector *ps, struct dm_path *path,
>  		     status_type_t type, char *result, unsigned maxlen)
>  {
> -	unsigned sz = 0;
>  	struct path_info *pi;
>  
>  	if (!path)
> @@ -102,7 +101,7 @@ static int st_status(struct path_selector *ps, struct dm_path *path,
>  		}
>  	}
>  
> -	return sz;
> +	return 0;
>  }
>  
>  static int st_add_path(struct path_selector *ps, struct dm_path *path,
> -- 
> 1.8.3.1
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


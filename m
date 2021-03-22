Return-Path: <SRS0=txDK=IU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4FF3C433DB
	for <dm-devel@archiver.kernel.org>; Mon, 22 Mar 2021 14:38:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2B41E6191C
	for <dm-devel@archiver.kernel.org>; Mon, 22 Mar 2021 14:38:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2B41E6191C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1616423904;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=AUIVkvb9+dc0kP6hAaLlYP4b4ELSWf9Upu4cdczoNDw=;
	b=RJfm8NLXllMLamfGEG6Vpf5rWRLLAtbw0RgAjKOtFo7ngOLhVMcVVd3nTwJAIkodEdKE5T
	GYUWDGTIPy+lmY+cNBTRaw5XgfsVM5/wZB7b8XN4eifegmOCus+GDURPLKzSQlwZiUVD8i
	d2KDpqRLH3bNxbKT1368zySN8ae9ots=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-iBleQkPwMLu_8d5InoNOtg-1; Mon, 22 Mar 2021 10:38:22 -0400
X-MC-Unique: iBleQkPwMLu_8d5InoNOtg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 081DD87A826;
	Mon, 22 Mar 2021 14:38:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AE4495B6AD;
	Mon, 22 Mar 2021 14:38:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 54ECE4BB7C;
	Mon, 22 Mar 2021 14:38:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12MEbi5p032504 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 22 Mar 2021 10:37:45 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id EDDCD5B6AB; Mon, 22 Mar 2021 14:37:44 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 98E165B6A8;
	Mon, 22 Mar 2021 14:37:41 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 12MEbdcG012746; 
	Mon, 22 Mar 2021 09:37:40 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 12MEbdVV012745;
	Mon, 22 Mar 2021 09:37:39 -0500
Date: Mon, 22 Mar 2021 09:37:39 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20210322143739.GD15006@octiron.msp.redhat.com>
References: <20210319162647.25240-1-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20210319162647.25240-1-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH] Revert "multipath -U: reduce log level of
 "adding new path" message"
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Mar 19, 2021 at 05:26:47PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> After "11-dm-mpath.rules: run "multipath -U" with -v1", this patch isn't
> necessary any more. It's desirable to see these messages from multipathd,
> as they mean that a valid path had been found in a map that wasn't present
> in the udev db.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

And I'm fine with you rebasing the queue branch.

> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
> If this is approved, unless anyone objects, I'll simply drop the patch
> that this reverts in the "queue" branch, performing a rebase.
> 
> ---
>  libmultipath/structs_vec.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> index 0b069f4..d242c06 100644
> --- a/libmultipath/structs_vec.c
> +++ b/libmultipath/structs_vec.c
> @@ -192,7 +192,7 @@ bool update_pathvec_from_dm(vector pathvec, struct multipath *mpp,
>  						must_reload = true;
>  						continue;
>  					}
> -					condlog(3, "%s: adding new path %s",
> +					condlog(2, "%s: adding new path %s",
>  						mpp->alias, pp->dev);
>  					store_path(pathvec, pp);
>  					pp->tick = 1;
> -- 
> 2.30.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


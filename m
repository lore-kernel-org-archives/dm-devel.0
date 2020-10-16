Return-Path: <SRS0=cnJz=DX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93AE5C433E7
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 22:13:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CFDA1218AC
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 22:13:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AAZ0U9lE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CFDA1218AC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1602886404;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=seSFUk3GDOR4ZS55y/Mhz80t5Tb0wklsXDtIDyZiM+I=;
	b=AAZ0U9lEXxMXFpXngzk0ZtZCKz9L6CCz88tYFT+tKV/NJZORRbuEF1L2EXthshalLUsl/R
	CtsBRknS018zg13L6pyWPtcTqmwCQRdkSGfqdIdhsW8wwwRPePt6nHlhyCSTf8+TwtQ3sP
	J8A0UjxbSbBz6gkwo9cojuk/XPkh//4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-IdYgHUiENlOXWAPTLom8qA-1; Fri, 16 Oct 2020 18:13:22 -0400
X-MC-Unique: IdYgHUiENlOXWAPTLom8qA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F68D8030CD;
	Fri, 16 Oct 2020 22:13:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BCAB26EF50;
	Fri, 16 Oct 2020 22:13:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 254311800B72;
	Fri, 16 Oct 2020 22:13:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09GMDAwJ010473 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Oct 2020 18:13:10 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3FF925D9D5; Fri, 16 Oct 2020 22:13:10 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CD26A5D9CC;
	Fri, 16 Oct 2020 22:13:06 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 09GMD5v5027416; 
	Fri, 16 Oct 2020 17:13:05 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 09GMD4jE027415;
	Fri, 16 Oct 2020 17:13:04 -0500
Date: Fri, 16 Oct 2020 17:13:04 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20201016221304.GX3384@octiron.msp.redhat.com>
References: <20201016104239.8217-1-mwilck@suse.com>
	<20201016104239.8217-13-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20201016104239.8217-13-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v2 12/12] libmpathpersist: initialize
 mpp->hwe in get_mpvec()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Oct 16, 2020 at 12:42:39PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> In __mpath_persistent_reserve_out, we call select_all_tg_pt(),
> which requires mpp->hwe to be set. Initialize it in get_mpvec().
> 
> Fixes: 5b54e77 ("mpathpersist: add all_tg_pt option")
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmpathpersist/mpath_persist.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
> index 1f9817e..4b3f3e0 100644
> --- a/libmpathpersist/mpath_persist.c
> +++ b/libmpathpersist/mpath_persist.c
> @@ -341,11 +341,13 @@ get_mpvec (vector curmp, vector pathvec, char * refwwid)
>  			continue;
>  
>  		if (update_multipath_table(mpp, pathvec, DI_CHECKER) != DMP_OK ||
> -		    update_multipath_status(mpp) != DMP_OK) {
> +		    update_multipath_status(mpp) != DMP_OK ||
> +		    update_mpp_paths(mpp, pathvec)) {
>  			condlog(1, "error parsing map %s", mpp->wwid);
>  			remove_map(mpp, pathvec, curmp, PURGE_VEC);
>  			i--;
> -		}
> +		} else
> +			extract_hwe_from_path(mpp);
>  	}
>  	return MPATH_PR_SUCCESS ;
>  }
> -- 
> 2.28.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


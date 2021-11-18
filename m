Return-Path: <SRS0=dXIA=QF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1002FC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 17:03:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AF24161872
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 17:03:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AF24161872
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1637255012;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5AXJF6poV7O/mQc5jXZAzGPeL6fNZ3vXE6u4Z3OXRu0=;
	b=PERc0y1T33PZmnneQm0bwxLu8XYJhGiBRG7cpfJEUOXpMbmilOXAs7tTk82+McpsFcQI41
	8ptWjDjQAMpQqEwWTI3tb76LS1O8g0Kx+HDh9IlJuxjmsP4aIsT2IywZHUG+negSBUJQ40
	IQgMg3347oqIs2omyYkbYDzjrRKkhwc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-404-rjIixYYYNj6u5AQ7O6lxHQ-1; Thu, 18 Nov 2021 12:03:31 -0500
X-MC-Unique: rjIixYYYNj6u5AQ7O6lxHQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED315802E64;
	Thu, 18 Nov 2021 17:03:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C40C95BAE0;
	Thu, 18 Nov 2021 17:03:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E1FB04EA76;
	Thu, 18 Nov 2021 17:03:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AIGvbb1031658 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Nov 2021 11:57:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 34D6260C5F; Thu, 18 Nov 2021 16:57:37 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BF74C60C05;
	Thu, 18 Nov 2021 16:57:30 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1AIGvSHV011265; 
	Thu, 18 Nov 2021 10:57:28 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1AIGvRAh011264;
	Thu, 18 Nov 2021 10:57:27 -0600
Date: Thu, 18 Nov 2021 10:57:27 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <20211118165727.GH19591@octiron.msp.redhat.com>
References: <78637f61-851d-cf9d-d308-9c22396d2071@huawei.com>
	<adf675e0-1ed6-f395-e428-548fe145ea64@huawei.com>
MIME-Version: 1.0
In-Reply-To: <adf675e0-1ed6-f395-e428-548fe145ea64@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	dm-devel mailing list <dm-devel@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Subject: Re: [dm-devel] [PATCH 5/5] add prflag to path
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 16, 2021 at 10:01:15PM +0800, lixiaokeng wrote:
> The update_map will frequently be called and there will be
> unnecessary checks of reseravtion. We add prflag to path
> to avoid this.
> 
> The pp->state changes from others to up or ghost, the
> mpath_pr_event_handle should be called. The
> mpath_pr_event_handle in ev_add_path may not be called,
> so set pp->prkey PRKEY_NO when path is removed.

This patch kind of confuses me.  You only check pp->prkey before calling
mpath_pr_event_handle() in update_map(). I get from your commit message
that you are doing this to keep from frequent, unnecessary calls. But
isn't update_map() only called when a multipath device is first created,
or when multipathd stops waiting for something that it noticed during
device creation? I don't see how this can be frequently called on a
multipath device. What am I missing?

-Ben

> 
> Fix: 4db4fa
> Signed-off-by: Lixiaokeng <lixiaokeng>
> ---
>  libmpathpersist/mpath_persist.c |  2 +-
>  libmultipath/structs.c          |  1 +
>  libmultipath/structs.h          | 12 ++++++++++++
>  multipathd/cli_handlers.c       | 15 ++++++++++-----
>  multipathd/main.c               |  5 +++--
>  5 files changed, 27 insertions(+), 8 deletions(-)
> 
> diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
> index 803a2a28..f88a2e89 100644
> --- a/libmpathpersist/mpath_persist.c
> +++ b/libmpathpersist/mpath_persist.c
> @@ -924,7 +924,7 @@ int update_map_pr(struct multipath *mpp)
> 
>  	if (isFound)
>  	{
> -		mpp->prflag = 1;
> +		mpp->prflag = PRFLAG_OK;
>  		condlog(2, "%s: prflag flag set.", mpp->alias );
>  	}
> 
> diff --git a/libmultipath/structs.c b/libmultipath/structs.c
> index e8cacb4b..82dbd565 100644
> --- a/libmultipath/structs.c
> +++ b/libmultipath/structs.c
> @@ -122,6 +122,7 @@ uninitialize_path(struct path *pp)
>  	pp->dmstate = PSTATE_UNDEF;
>  	pp->uid_attribute = NULL;
>  	pp->getuid = NULL;
> +	pp->prflag = PRFLAG_NO;
> 
>  	if (checker_selected(&pp->checker))
>  		checker_put(&pp->checker);
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index 399540e7..5b77218b 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -249,6 +249,17 @@ enum recheck_wwid_states {
>  	RECHECK_WWID_ON = YNU_YES,
>  };
> 
> +/*
> + * PRFLAG_NO for path, it means reservation should be checked.
> + * PRFLAG_NO for multipath, it means mpp has no prkey.
> + * PRFLAG_OK for path, it means reservation has been checked.
> + * PRFLAG_OK for multipath, it means mpp has prkey.
> + */
> +enum prflag_states {
> +	PRFLAG_NO = 0,
> +	PRFLAG_OK = 1,
> +};
> +
>  struct vpd_vendor_page {
>  	int pg;
>  	const char *name;
> @@ -327,6 +338,7 @@ struct path {
>  	/* configlet pointers */
>  	vector hwe;
>  	struct gen_path generic_path;
> +	int prflag;
>  };
> 
>  typedef int (pgpolicyfn) (struct multipath *, vector);
> diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> index 6d3a0ae2..8662fad7 100644
> --- a/multipathd/cli_handlers.c
> +++ b/multipathd/cli_handlers.c
> @@ -1341,7 +1341,7 @@ cli_setprstatus(void * v, char ** reply, int * len, void * data)
>  		return 1;
> 
>  	if (!mpp->prflag) {
> -		mpp->prflag = 1;
> +		mpp->prflag = PRFLAG_OK;
>  		condlog(2, "%s: prflag set", param);
>  	}
> 
> @@ -1352,9 +1352,11 @@ cli_setprstatus(void * v, char ** reply, int * len, void * data)
>  int
>  cli_unsetprstatus(void * v, char ** reply, int * len, void * data)
>  {
> -	struct multipath * mpp;
> -	struct vectors * vecs = (struct vectors *)data;
> -	char * param = get_keyparam(v, MAP);
> +	int i;
> +	struct multipath *mpp;
> +	struct path *pp;
> +	struct vectors *vecs = (struct vectors *)data;
> +	char *param = get_keyparam(v, MAP);
> 
>  	param = convert_dev(param, 0);
>  	get_path_layout(vecs->pathvec, 0);
> @@ -1364,7 +1366,10 @@ cli_unsetprstatus(void * v, char ** reply, int * len, void * data)
>  		return 1;
> 
>  	if (mpp->prflag) {
> -		mpp->prflag = 0;
> +		mpp->prflag = PRFLAG_NO;
> +		vector_foreach_slot(mpp->paths, pp, i) {
> +			pp->prflag = PRFLAG_NO;
> +		}
>  		condlog(2, "%s: prflag unset", param);
>  	}
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 82ab3ed1..6ef6495b 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -506,7 +506,7 @@ retry:
> 
>  	if (mpp->prflag) {
>  		vector_foreach_slot(mpp->paths, pp, i) {
> -			if ((pp->state == PATH_UP)  || (pp->state == PATH_GHOST)) {
> +			if (!pp->prflag && ((pp->state == PATH_UP) || (pp->state == PATH_GHOST))) {
>  				/* persistent reseravtion check*/
>  				mpath_pr_event_handle(pp);
>  			}
> @@ -3570,7 +3570,8 @@ void *  mpath_pr_event_handler_fn (void * pathp )
>  	{
>  		condlog(0,"%s: Reservation registration failed. Error: %d", pp->dev, ret);
>  	}
> -	mpp->prflag = 1;
> +	mpp->prflag = PRFLAG_OK;
> +	pp->prflag = PRFLAG_OK;
> 
>  	free(param);
>  out:
> -- 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


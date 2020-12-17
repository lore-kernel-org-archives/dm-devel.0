Return-Path: <SRS0=NZHG=FV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98530C4361B
	for <dm-devel@archiver.kernel.org>; Thu, 17 Dec 2020 16:33:13 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0C8D4239ED
	for <dm-devel@archiver.kernel.org>; Thu, 17 Dec 2020 16:33:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0C8D4239ED
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1608222791;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=I59TlD0XIjXZgL0li7mbtnmFzEO3gSgYFWTYwaq1TeI=;
	b=IMaAIdJ1DENGyDBugtzssTQUuccRrS4x3GzVIHDyiJ7ukx+qEalV0OJXSfbw2tWNZFT/rT
	cZp7LFm6wbnUYqOXp1ZxJpfNiBvWptueZv5GXecUSx/HoZcJNdVmmeY1RaX9rwPd97//dw
	wSy2gN/wj2Yh8j1h50fBZMKpQhs332Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-s2aMVmytPHiYMremAV7sFw-1; Thu, 17 Dec 2020 11:33:10 -0500
X-MC-Unique: s2aMVmytPHiYMremAV7sFw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E498280364F;
	Thu, 17 Dec 2020 16:33:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4426A5F9C8;
	Thu, 17 Dec 2020 16:33:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AC193180954D;
	Thu, 17 Dec 2020 16:33:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BHGX1sv002354 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 17 Dec 2020 11:33:01 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9CD795D71D; Thu, 17 Dec 2020 16:33:01 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D03485D6DC;
	Thu, 17 Dec 2020 16:32:57 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 0BHGWuBn032354; 
	Thu, 17 Dec 2020 10:32:56 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 0BHGWtc5032353;
	Thu, 17 Dec 2020 10:32:55 -0600
Date: Thu, 17 Dec 2020 10:32:55 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20201217163255.GB3103@octiron.msp.redhat.com>
References: <20201217100444.16058-1-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20201217100444.16058-1-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v4 22/29] multipath: fix leaks in
	check_path_valid()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Dec 17, 2020 at 11:04:44AM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> There were two leaks in check_path_valid(): if path status was
> successfully determined before calling store_pathvec(), free_path()
> wasn't called. Also, if an error exit occured, neither cleanup
> function was called.
> 
> This patch fixes both, at the cost of using "static" for the pp and
> pathvec variables.
> 

I just noticed that your commit message doesn't totally match what the
patch does anymore. But the code looks fine. Feel free to change the
message when pushing to upstream-queue.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipath/main.c | 30 ++++++++++++++++++++----------
>  1 file changed, 20 insertions(+), 10 deletions(-)
> 
> diff --git a/multipath/main.c b/multipath/main.c
> index 1949a1c..043d8fa 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -93,7 +93,7 @@ void rcu_register_thread_memb(void) {}
>  void rcu_unregister_thread_memb(void) {}
>  
>  static int
> -filter_pathvec (vector pathvec, char * refwwid)
> +filter_pathvec (vector pathvec, const char *refwwid)
>  {
>  	int i;
>  	struct path * pp;
> @@ -594,8 +594,9 @@ static int
>  check_path_valid(const char *name, struct config *conf, bool is_uevent)
>  {
>  	int fd, r = PATH_IS_ERROR;
> -	struct path *pp = NULL;
> +	struct path *pp;
>  	vector pathvec = NULL;
> +	const char *wwid;
>  
>  	pp = alloc_path();
>  	if (!pp)
> @@ -664,14 +665,19 @@ check_path_valid(const char *name, struct config *conf, bool is_uevent)
>  
>  	if (store_path(pathvec, pp) != 0) {
>  		free_path(pp);
> +		pp = NULL;
>  		goto fail;
> +	} else {
> +		/* make sure path isn't freed twice */
> +		wwid = pp->wwid;
> +		pp = NULL;
>  	}
>  
>  	/* For find_multipaths = SMART, if there is more than one path
>  	 * matching the refwwid, then the path is valid */
>  	if (path_discovery(pathvec, DI_SYSFS | DI_WWID) < 0)
>  		goto fail;
> -	filter_pathvec(pathvec, pp->wwid);
> +	filter_pathvec(pathvec, wwid);
>  	if (VECTOR_SIZE(pathvec) > 1)
>  		r = PATH_IS_VALID;
>  	else
> @@ -679,21 +685,25 @@ check_path_valid(const char *name, struct config *conf, bool is_uevent)
>  
>  out:
>  	r = print_cmd_valid(r, pathvec, conf);
> -	free_pathvec(pathvec, FREE_PATHS);
>  	/*
>  	 * multipath -u must exit with status 0, otherwise udev won't
>  	 * import its output.
>  	 */
>  	if (!is_uevent && r == PATH_IS_NOT_VALID)
> -		return RTVL_FAIL;
> -	return RTVL_OK;
> +		r = RTVL_FAIL;
> +	else
> +		r = RTVL_OK;
> +	goto cleanup;
>  
>  fail:
> -	if (pathvec)
> -		free_pathvec(pathvec, FREE_PATHS);
> -	else
> +	r = RTVL_FAIL;
> +
> +cleanup:
> +	if (pp != NULL)
>  		free_path(pp);
> -	return RTVL_FAIL;
> +	if (pathvec != NULL)
> +		free_pathvec(pathvec, FREE_PATHS);
> +	return r;
>  }
>  
>  static int
> -- 
> 2.29.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


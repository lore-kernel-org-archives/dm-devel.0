Return-Path: <SRS0=g9U1=FU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EAD7C4361B
	for <dm-devel@archiver.kernel.org>; Wed, 16 Dec 2020 17:34:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9DB4723124
	for <dm-devel@archiver.kernel.org>; Wed, 16 Dec 2020 17:34:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9DB4723124
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-3VKk8ZgEPcyGkgeO-hYVRg-1; Wed, 16 Dec 2020 12:34:32 -0500
X-MC-Unique: 3VKk8ZgEPcyGkgeO-hYVRg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E8DC7180A086;
	Wed, 16 Dec 2020 17:34:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 71BC31820D;
	Wed, 16 Dec 2020 17:34:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 16625180954D;
	Wed, 16 Dec 2020 17:34:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BGHYHbc013802 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 16 Dec 2020 12:34:17 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 465542026D13; Wed, 16 Dec 2020 17:34:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4141E2026D11
	for <dm-devel@redhat.com>; Wed, 16 Dec 2020 17:34:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BCAC5858287
	for <dm-devel@redhat.com>; Wed, 16 Dec 2020 17:34:14 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-199-NwdUxICxNKyn3jkS0otpNg-1;
	Wed, 16 Dec 2020 12:34:08 -0500
X-MC-Unique: NwdUxICxNKyn3jkS0otpNg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 9D05DAC7B;
	Wed, 16 Dec 2020 17:34:06 +0000 (UTC)
Message-ID: <7af8e4c39c11eae413c92beef97c62b793a08aa6.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski
	<bmarzins@redhat.com>, lixiaokeng@huawei.com, dm-devel@redhat.com
Date: Wed, 16 Dec 2020 18:34:05 +0100
In-Reply-To: <20201016104501.8700-23-mwilck@suse.com>
References: <20201016104501.8700-1-mwilck@suse.com>
	<20201016104501.8700-23-mwilck@suse.com>
User-Agent: Evolution 3.36.5
MIME-Version: 1.0
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
Subject: Re: [dm-devel] [PATCH v2 22/29] multipath: fix leaks in
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, 2020-10-16 at 12:44 +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> There were two leaks in check_path_valid(): if path status was
> successfully determined before calling store_pathvec(), free_path()
> wasn't called. Also, if an error exit occured, neither cleanup
> function was called.
> 
> This patch fixes both, at the cost of using "static" for the pp and
> pathvec variables.

Looking at this again after 2 months, I think the on_exit() part of
this patch is wrong. First, we can't use on_exit() on every platform,
as e.g. musl libc doesn't have it. To replace this by the more portable
atexit(), we'd need to declare the two variables "pp" and "pathvec"
with file scope, which is very ugly. But more importantly, using static
variables here causes check_path_valid() to be non-reentrant. While it
doesn't have to be, it's still a coding pattern we haven't been using
anywhere else, just to avoid a "memory leak" for an irregular exit,
which isn't a real memory leak, actually.

One day we should remove the exit() calls somewhere deep down in our
libraries, and deal with the respective errors cleanly.

@lixiaokeng, I hope this is ok for you, as you brought the issue up
originally ("[QUESTION] memory leak in main (multipath)").

Regards
Martin

> 
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipath/main.c | 55 +++++++++++++++++++++++++++++++++++++---------
> --
>  1 file changed, 43 insertions(+), 12 deletions(-)
> 
> diff --git a/multipath/main.c b/multipath/main.c
> index 049a36f..9974993 100644
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
> @@ -592,12 +592,37 @@ out:
>  	return r;
>  }
>  
> +static void cleanup_pathvec(__attribute__((unused)) int dummy, void
> *arg)
> +{
> +	vector *ppv = arg;
> +
> +	if (ppv && *ppv) {
> +		free_pathvec(*ppv, FREE_PATHS);
> +		*ppv = NULL;
> +	}
> +}
> +
> +static void cleanup_path(__attribute__((unused)) int dummy, void
> *arg)
> +{
> +	struct path **ppp = arg;
> +
> +	if (ppp && *ppp) {
> +		free_path(*ppp);
> +		*ppp = NULL;
> +	}
> +}
> +
>  static int
>  check_path_valid(const char *name, struct config *conf, bool
> is_uevent)
>  {
>  	int fd, r = PATH_IS_ERROR;
> -	struct path *pp = NULL;
> -	vector pathvec = NULL;
> +	static struct path *pp = NULL;
> +	static vector pathvec = NULL;
> +	const char *wwid;
> +
> +	/* register these as exit handlers in case we exit irregularly
> */
> +	on_exit(cleanup_path, &pp);
> +	on_exit(cleanup_pathvec, &pathvec);
>  
>  	pp = alloc_path();
>  	if (!pp)
> @@ -667,13 +692,17 @@ check_path_valid(const char *name, struct
> config *conf, bool is_uevent)
>  	if (store_path(pathvec, pp) != 0) {
>  		free_path(pp);
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
> @@ -681,21 +710,23 @@ check_path_valid(const char *name, struct
> config *conf, bool is_uevent)
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
> -		free_path(pp);
> -	return RTVL_FAIL;
> +	r = RTVL_FAIL;
> +
> +cleanup:
> +	cleanup_path(0, &pp);
> +	cleanup_pathvec(0, &pathvec);
> +	return r;
>  }
>  
>  static int


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


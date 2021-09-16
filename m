Return-Path: <SRS0=t70f=OG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3FDFC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 02:19:52 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 51FD7611CA
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 02:19:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 51FD7611CA
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1631758791;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=mH9T6JGpjfAwASwJhSHnWhlWwDBBJtlq9U8Kw0sRIo0=;
	b=OQhvKGo7l3tHIf4E4lYmmtBYmWlr++opni/FXyhWd46CXSVURDkFsFBEZaCXBKtx30KwNo
	I5OvNhyPra/4Vy9WGhGVaNXmQ5P49FRucsltx3/CgAJnT6eJY59x9ECncwtdsuLOAh63gO
	e11dLRjQdrcJemiHPxjAioxEJmKQSe8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-498-rfSRIM9LP-Ofodax1PgI2Q-1; Wed, 15 Sep 2021 22:19:49 -0400
X-MC-Unique: rfSRIM9LP-Ofodax1PgI2Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 615721808301;
	Thu, 16 Sep 2021 02:19:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0D42A60C82;
	Thu, 16 Sep 2021 02:19:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8BD054E9F5;
	Thu, 16 Sep 2021 02:19:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18G2JhsP027849 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 15 Sep 2021 22:19:43 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3ADF95C1D1; Thu, 16 Sep 2021 02:19:43 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 71E395C1C5;
	Thu, 16 Sep 2021 02:19:39 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 18G2JbHC007363; 
	Wed, 15 Sep 2021 21:19:37 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 18G2Jbll007362;
	Wed, 15 Sep 2021 21:19:37 -0500
Date: Wed, 15 Sep 2021 21:19:36 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20210916021936.GG3087@octiron.msp.redhat.com>
References: <20210910114120.13665-1-mwilck@suse.com>
	<20210910114120.13665-22-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20210910114120.13665-22-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com,
	Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [dm-devel] [PATCH 21/35] multipathd: move parse_cmd() to
	uxlsnr.c
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Sep 10, 2021 at 01:41:06PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> parse_cmd() does more than the name says - it parses, executes
> handlers, and even provides reply strings for some cases. This doesn't
> work well with the state machine idea. Thus move it to uxlsnr.c,
> where later patches will move some functionality elsewhere.
> 
> No functional changes.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/cli.c    | 74 +++++----------------------------------------
>  multipathd/cli.h    |  5 ++-
>  multipathd/uxlsnr.c | 61 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 73 insertions(+), 67 deletions(-)
> 
> diff --git a/multipathd/cli.c b/multipathd/cli.c
> index f8c1dbd..29d6a6e 100644
> --- a/multipathd/cli.c
> +++ b/multipathd/cli.c
> @@ -256,8 +256,7 @@ find_key (const char * str)
>   * ESRCH: command not found
>   * EINVAL: argument missing for command
>   */
> -static int
> -get_cmdvec (char * cmd, vector *v)
> +int get_cmdvec (char *cmd, vector *v)
>  {
>  	int i;
>  	int r = 0;
> @@ -322,7 +321,7 @@ out:
>  }
>  
>  static uint64_t
> -fingerprint(vector vec)
> +fingerprint(const struct _vector *vec)
>  {
>  	int i;
>  	uint64_t fp = 0;
> @@ -337,6 +336,11 @@ fingerprint(vector vec)
>  	return fp;
>  }
>  
> +struct handler *find_handler_for_cmdvec(const struct _vector *v)
> +{
> +	return find_handler(fingerprint(v));
> +}
> +
>  int
>  alloc_handlers (void)
>  {
> @@ -415,8 +419,7 @@ do_genhelp(struct strbuf *reply, const char *cmd, int error) {
>  }
>  
>  
> -static char *
> -genhelp_handler (const char *cmd, int error)
> +char *genhelp_handler(const char *cmd, int error)
>  {
>  	STRBUF_ON_STACK(reply);
>  
> @@ -425,67 +428,6 @@ genhelp_handler (const char *cmd, int error)
>  	return steal_strbuf_str(&reply);
>  }
>  
> -int
> -parse_cmd (char * cmd, char ** reply, int * len, void * data, int timeout )
> -{
> -	int r;
> -	struct handler * h;
> -	vector cmdvec = NULL;
> -	struct timespec tmo;
> -
> -	r = get_cmdvec(cmd, &cmdvec);
> -
> -	if (r) {
> -		*reply = genhelp_handler(cmd, r);
> -		if (*reply == NULL)
> -			return EINVAL;
> -		*len = strlen(*reply) + 1;
> -		return 0;
> -	}
> -
> -	h = find_handler(fingerprint(cmdvec));
> -
> -	if (!h || !h->fn) {
> -		free_keys(cmdvec);
> -		*reply = genhelp_handler(cmd, EINVAL);
> -		if (*reply == NULL)
> -			return EINVAL;
> -		*len = strlen(*reply) + 1;
> -		return 0;
> -	}
> -
> -	/*
> -	 * execute handler
> -	 */
> -	if (clock_gettime(CLOCK_REALTIME, &tmo) == 0) {
> -		tmo.tv_sec += timeout;
> -	} else {
> -		tmo.tv_sec = 0;
> -	}
> -	if (h->locked) {
> -		int locked = 0;
> -		struct vectors * vecs = (struct vectors *)data;
> -
> -		pthread_cleanup_push(cleanup_lock, &vecs->lock);
> -		if (tmo.tv_sec) {
> -			r = timedlock(&vecs->lock, &tmo);
> -		} else {
> -			lock(&vecs->lock);
> -			r = 0;
> -		}
> -		if (r == 0) {
> -			locked = 1;
> -			pthread_testcancel();
> -			r = h->fn(cmdvec, reply, len, data);
> -		}
> -		pthread_cleanup_pop(locked);
> -	} else
> -		r = h->fn(cmdvec, reply, len, data);
> -	free_keys(cmdvec);
> -
> -	return r;
> -}
> -
>  char *
>  get_keyparam (vector v, uint64_t code)
>  {
> diff --git a/multipathd/cli.h b/multipathd/cli.h
> index dbb75be..eed606a 100644
> --- a/multipathd/cli.h
> +++ b/multipathd/cli.h
> @@ -138,7 +138,10 @@ int __set_handler_callback (uint64_t fp, cli_handler *fn, bool locked);
>  #define set_handler_callback(fp, fn) __set_handler_callback(fp, fn, true)
>  #define set_unlocked_handler_callback(fp, fn) __set_handler_callback(fp, fn, false)
>  
> -int parse_cmd (char * cmd, char ** reply, int * len, void *, int);
> +int get_cmdvec (char *cmd, vector *v);
> +struct handler *find_handler_for_cmdvec(const struct _vector *v);
> +char *genhelp_handler (const char *cmd, int error);
> +
>  int load_keys (void);
>  char * get_keyparam (vector v, uint64_t code);
>  void free_keys (vector vec);
> diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
> index 622aac1..cbbcb2c 100644
> --- a/multipathd/uxlsnr.c
> +++ b/multipathd/uxlsnr.c
> @@ -311,6 +311,67 @@ static void handle_inotify(int fd, struct watch_descriptors *wds)
>  		condlog(1, "Multipath configuration updated.\nReload multipathd for changes to take effect");
>  }
>  
> +static int parse_cmd (char *cmd, char **reply, int *len, void *data,
> +		      int timeout)
> +{
> +	int r;
> +	struct handler * h;
> +	vector cmdvec = NULL;
> +	struct timespec tmo;
> +
> +	r = get_cmdvec(cmd, &cmdvec);
> +
> +	if (r) {
> +		*reply = genhelp_handler(cmd, r);
> +		if (*reply == NULL)
> +			return EINVAL;
> +		*len = strlen(*reply) + 1;
> +		return 0;
> +	}
> +
> +	h = find_handler_for_cmdvec(cmdvec);
> +
> +	if (!h || !h->fn) {
> +		free_keys(cmdvec);
> +		*reply = genhelp_handler(cmd, EINVAL);
> +		if (*reply == NULL)
> +			return EINVAL;
> +		*len = strlen(*reply) + 1;
> +		return 0;
> +	}
> +
> +	/*
> +	 * execute handler
> +	 */
> +	if (clock_gettime(CLOCK_REALTIME, &tmo) == 0) {
> +		tmo.tv_sec += timeout;
> +	} else {
> +		tmo.tv_sec = 0;
> +	}
> +	if (h->locked) {
> +		int locked = 0;
> +		struct vectors * vecs = (struct vectors *)data;
> +
> +		pthread_cleanup_push(cleanup_lock, &vecs->lock);
> +		if (tmo.tv_sec) {
> +			r = timedlock(&vecs->lock, &tmo);
> +		} else {
> +			lock(&vecs->lock);
> +			r = 0;
> +		}
> +		if (r == 0) {
> +			locked = 1;
> +			pthread_testcancel();
> +			r = h->fn(cmdvec, reply, len, data);
> +		}
> +		pthread_cleanup_pop(locked);
> +	} else
> +		r = h->fn(cmdvec, reply, len, data);
> +	free_keys(cmdvec);
> +
> +	return r;
> +}
> +
>  static int uxsock_trigger(char *str, char **reply, int *len,
>  			  bool is_root, void *trigger_data)
>  {
> -- 
> 2.33.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


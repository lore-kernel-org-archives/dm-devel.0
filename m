Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 314D2C32772
	for <dm-devel@archiver.kernel.org>; Tue, 23 Aug 2022 21:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661290053;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=D69xSudDSmXizec4YKjTeVqCB0R4hpUTeDGz15ZrWOg=;
	b=NwZNZGIjJGobtomb3prnRrC10U6OrInL0Av4ZsymI1V9R0mAoUfoMFDrGsFzAkw0zEWqi9
	sO2487nmQ3pjENZaUvNp9uGkQi/5CWZhx8+xn7vZir6Mq/Xxnu47aEpgYzIuMqhtULLGsM
	LybNd0BGcs0P1A8JgaihrvzBx14ylhk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-671-HvTsdG5GMHKkgxY5SVBfsw-1; Tue, 23 Aug 2022 17:27:30 -0400
X-MC-Unique: HvTsdG5GMHKkgxY5SVBfsw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2629D1C0BC71;
	Tue, 23 Aug 2022 21:27:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 77235945D7;
	Tue, 23 Aug 2022 21:27:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 225CA1946A41;
	Tue, 23 Aug 2022 21:27:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2899E1946A40
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 Aug 2022 21:27:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CC7771121319; Tue, 23 Aug 2022 21:27:25 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B54381121315;
 Tue, 23 Aug 2022 21:27:25 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 27NLROqF015031;
 Tue, 23 Aug 2022 16:27:24 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 27NLRNjd015030;
 Tue, 23 Aug 2022 16:27:23 -0500
Date: Tue, 23 Aug 2022 16:27:23 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20220823212723.GY10602@octiron.msp.redhat.com>
References: <20220818210630.19395-1-mwilck@suse.com>
 <20220818210630.19395-3-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20220818210630.19395-3-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH 2/3] libmultipath: check_alias_settings():
 pre-sort mptable by alias
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Aug 18, 2022 at 11:06:29PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> add_binding() contains an optimization; it assumes that the list of
> bindings is alphabetically sorted by alias, and tries to maintain
> this order.
> 
> But conf->mptable is sorted by wwid. Therefore check_alias_settings() may take
> a long time if the mptable is large.
> 
> Create a copy of the mptable, sorted by alias, and use it for add_bindings().
> This speeds up check_alias_settings by roughly a factor of 10 (0.1s vs. 1s)
> for my test setup with 10000 entries in the mptable.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/alias.c | 29 ++++++++++++++++++++++++++++-
>  1 file changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/libmultipath/alias.c b/libmultipath/alias.c
> index 548a118..60428fe 100644
> --- a/libmultipath/alias.c
> +++ b/libmultipath/alias.c
> @@ -672,6 +672,26 @@ static void cleanup_fclose(void *p)
>  	fclose(p);
>  }
>  
> +static int alias_compar(const void *p1, const void *p2)
> +{
> +	const char *alias1 = (*(struct mpentry * const *)p1)->alias;
> +	const char *alias2 = (*(struct mpentry * const *)p2)->alias;
> +
> +	if (!alias1 && !alias2)
> +		return 0;
> +	if (!alias1)
> +		return 1;
> +	if (!alias2)
> +		return -1;
> +	return strcmp(alias1, alias2);
> +}
> +
> +static void cleanup_vector_free(void *arg)
> +{
> +	if  (arg)
> +		vector_free((vector)arg);
> +}
> +
>  /*
>   * check_alias_settings(): test for inconsistent alias configuration
>   *
> @@ -693,10 +713,16 @@ int check_alias_settings(const struct config *conf)
>  	int can_write;
>  	int rc = 0, i, fd;
>  	Bindings bindings = {.allocated = 0, };
> +	vector mptable = NULL;
>  	struct mpentry *mpe;
>  
>  	pthread_cleanup_push_cast(free_bindings, &bindings);
> -	vector_foreach_slot(conf->mptable, mpe, i) {
> +	pthread_cleanup_push(cleanup_vector_free, mptable);
> +	mptable = vector_convert(NULL, conf->mptable, struct mpentry *, identity);
> +	if (!mptable)
> +		return -1;

Are there other places in the code where we return without popping the
cleanup handler? According to the man page "POSIX.1 says that the effect
of using return, break, continue, or  goto to  prematurely  leave  a
block  bracketed pthread_cleanup_push() and pthread_cleanup_pop() is
undefined.  Portable applications should avoid doing this." It also says
that linux implements these as macros that expand to create code blocks.
So, I'm pretty sure this is safe in linux, but if we aren't already
doing it, we probably shouldn't start, especially since vector_convert()
doesn't have any pthread cancellation points, so we can just move the
push until after we are sure we successfully copied the vector.

> +	vector_sort(mptable, alias_compar);
> +	vector_foreach_slot(mptable, mpe, i) {
>  		if (!mpe->wwid || !mpe->alias)

Unless I'm missing something, merge_mptable() should have already
guaranteed that mpe->wwid must be non-NULL. Also, since mptable has all
of the entries with a NULL alias sorted to the end, as soon as we hit
one, we can stop checking.

-Ben

>  			continue;
>  		if (add_binding(&bindings, mpe->alias, mpe->wwid) ==
> @@ -710,6 +736,7 @@ int check_alias_settings(const struct config *conf)
>  	}
>  	/* This clears the bindings */
>  	pthread_cleanup_pop(1);
> +	pthread_cleanup_pop(1);
>  
>  	pthread_cleanup_push_cast(free_bindings, &bindings);
>  	fd = open_file(conf->bindings_file, &can_write, BINDINGS_FILE_HEADER);
> -- 
> 2.37.1
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


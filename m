Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F28AEE3F39
	for <dm-devel@archiver.kernel.org>; Tue, 12 Sep 2023 23:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694559663;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ZbZEwuZMN++h+rBtetkr0xR/W1WYhuFOCGzXwm/EhEA=;
	b=NAMf7nnzdN+TqhHKjJVABZk4QqxzQyj2xTg3rLTY5zpyzkAnNdgHfaNLCQzGR4U7XUh+EX
	+Cb08MMWxl3kEWb5cBxfW3vMO/BKvfVuJK2ur0GhQdC8n/WbOOxck9/yl2buO3rLRm//VK
	JvvlXbsQfzK0God6laUrIx5HPVyuHBg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-93-YL6qh204MWyRy6ex2Fs-Jw-1; Tue, 12 Sep 2023 19:01:01 -0400
X-MC-Unique: YL6qh204MWyRy6ex2Fs-Jw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B7C7C181A6E1;
	Tue, 12 Sep 2023 23:00:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A605F6B2AE;
	Tue, 12 Sep 2023 23:00:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 823CD19465A8;
	Tue, 12 Sep 2023 23:00:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 05140194658D
 for <dm-devel@listman.corp.redhat.com>; Tue, 12 Sep 2023 23:00:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E4FEE40C200A; Tue, 12 Sep 2023 23:00:57 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C53F140C2009;
 Tue, 12 Sep 2023 23:00:57 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 38CN0nHm031067;
 Tue, 12 Sep 2023 18:00:49 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 38CN0nXs031066;
 Tue, 12 Sep 2023 18:00:49 -0500
Date: Tue, 12 Sep 2023 18:00:48 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20230912230048.GR7412@octiron.msp.redhat.com>
References: <20230911163846.27197-1-mwilck@suse.com>
 <20230911163846.27197-23-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20230911163846.27197-23-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v2 22/37] libmultipath: sort aliases by
 length and strcmp
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Sep 11, 2023 at 06:38:31PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> The current sort order of aliases is alphabetical, which is does not match
> the actual order of aliases, where "mpathaa" > "mpathz". Change the ordering as
> follows: first sort by string length, then alphabetically. This will make
> sure that for aliases with the same prefix, alias order is correct ("mpathaaa"
> will be sorted after "mpathzz", etc). Even for mixed prefixes, the alias
> order will be correct for every individual prefix, even though aliases with
> different prefixes may alternate in the file.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/alias.c | 45 +++++++++++++++++++++++++++++++++-----------
>  1 file changed, 34 insertions(+), 11 deletions(-)
> 
> diff --git a/libmultipath/alias.c b/libmultipath/alias.c
> index 58436ec..af6565b 100644
> --- a/libmultipath/alias.c
> +++ b/libmultipath/alias.c
> @@ -117,6 +117,35 @@ static const struct binding *get_binding_for_wwid(const Bindings *bindings,
>  	return NULL;
>  }
>  
> +/*
> + * Sort order for aliases.
> + *
> + * The "numeric" ordering of aliases for a given prefix P is
> + * Pa, ..., Pz, Paa, ..., Paz, Pba, ... , Pzz, Paaa, ..., Pzzz, Paaaa, ...
> + * We use the fact that for equal prefix, longer strings are always
> + * higher than shorter ones. Strings of equal length are sorted alphabetically.
> + * This is achieved by sorting be length first, then using strcmp().
> + * If multiple prefixes are in use, the aliases with a given prefix will
> + * not necessarily be in a contiguous range of the vector, but they will
> + * be ordered such that for a given prefix, numercally higher aliases will
> + * always be sorted after lower ones.
> + */
> +static int alias_compar(const void *p1, const void *p2)
> +{

I'm confused as to why we need to pass p1 and p2 and pointers to
pointers to chars, instead of simply as pointers to chars. We always
derefence them immediately, and only use the dereferenced pointers. Am I
missing something?

-Ben

> +	const char *alias1 = *((char * const *)p1);
> +	const char *alias2 = *((char * const *)p2);
> +
> +	if (alias1 && alias2) {
> +		ssize_t ldif = strlen(alias1) - strlen(alias2);
> +
> +		if (ldif)
> +			return ldif;
> +		return strcmp(alias1, alias2);
> +	} else
> +		/* Move NULL alias to the end */
> +		return alias1 ? -1 : alias2 ? 1 : 0;
> +}
> +
>  static int add_binding(Bindings *bindings, const char *alias, const char *wwid)
>  {
>  	struct binding *bdg;
> @@ -128,7 +157,7 @@ static int add_binding(Bindings *bindings, const char *alias, const char *wwid)
>  	 * sorted already.
>  	 */
>  	vector_foreach_slot_backwards(bindings, bdg, i) {
> -		if ((cmp = strcmp(bdg->alias, alias)) <= 0)
> +		if ((cmp = alias_compar(&bdg->alias, &alias)) <= 0)
>  			break;
>  	}
>  
> @@ -657,16 +686,10 @@ static int _check_bindings_file(const struct config *conf, FILE *file,
>  	return rc;
>  }
>  
> -static int alias_compar(const void *p1, const void *p2)
> +static int mp_alias_compar(const void *p1, const void *p2)
>  {
> -	const char *alias1 = (*(struct mpentry * const *)p1)->alias;
> -	const char *alias2 = (*(struct mpentry * const *)p2)->alias;
> -
> -	if (alias1 && alias2)
> -		return strcmp(alias1, alias2);
> -	else
> -		/* Move NULL alias to the end */
> -		return alias1 ? -1 : alias2 ? 1 : 0;
> +	return alias_compar(&((*(struct mpentry * const *)p1)->alias),
> +			    &((*(struct mpentry * const *)p2)->alias));
>  }
>  
>  /*
> @@ -700,7 +723,7 @@ int check_alias_settings(const struct config *conf)
>  	pthread_cleanup_push_cast(free_bindings, &bindings);
>  	pthread_cleanup_push(cleanup_vector_free, mptable);
>  
> -	vector_sort(mptable, alias_compar);
> +	vector_sort(mptable, mp_alias_compar);
>  	vector_foreach_slot(mptable, mpe, i) {
>  		if (!mpe->alias)
>  			/*
> -- 
> 2.42.0
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


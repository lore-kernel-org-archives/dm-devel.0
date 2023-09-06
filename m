Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDD95EE14A9
	for <dm-devel@archiver.kernel.org>; Wed,  6 Sep 2023 22:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694040356;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0RtL0AyjpDCVlzVIvBcJL0ftIMgsNIVS4OQWBh37tMQ=;
	b=HQAS8MfRns+Rmyacjx1LAPjq9zEwIZ7yU4qadi+yWdbYg8UQL0+YtlUa964qG7HfCKzDs7
	pRfuIEC95dDDj8F+mGaloqhD7x6d74b84hFt8uNLq2WKz4EmH83OyJo+NgQ35mtOgzyhut
	aIO4uawWqcr77i19sP3SAljVBVrF1Gk=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-640-HD1_mqloNE6tIAMWOa_sUQ-1; Wed, 06 Sep 2023 18:45:53 -0400
X-MC-Unique: HD1_mqloNE6tIAMWOa_sUQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B6D3829AA3AC;
	Wed,  6 Sep 2023 22:45:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A47C8493110;
	Wed,  6 Sep 2023 22:45:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 626EE194658D;
	Wed,  6 Sep 2023 22:45:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B519D194658C
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Sep 2023 22:45:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 925E32026D2B; Wed,  6 Sep 2023 22:45:49 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7AD522026D76;
 Wed,  6 Sep 2023 22:45:49 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 386Mjf2b028998;
 Wed, 6 Sep 2023 17:45:41 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 386MjeoW028997;
 Wed, 6 Sep 2023 17:45:40 -0500
Date: Wed, 6 Sep 2023 17:45:40 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20230906224540.GB7412@octiron.msp.redhat.com>
References: <20230901180235.23980-1-mwilck@suse.com>
 <20230901180235.23980-18-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20230901180235.23980-18-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH 17/21] libmultipath: alias.c: factor out
 read_binding()
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Sep 01, 2023 at 08:02:30PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> This way we can test the parsing of input lines from the bindings
> file more easily.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/alias.c | 58 ++++++++++++++++++++++++++++++--------------
>  1 file changed, 40 insertions(+), 18 deletions(-)
> 
> diff --git a/libmultipath/alias.c b/libmultipath/alias.c
> index 9ca5da8..2f9bc82 100644
> --- a/libmultipath/alias.c
> +++ b/libmultipath/alias.c
> @@ -647,6 +647,43 @@ void cleanup_bindings(void)
>  	free_bindings(&global_bindings);
>  }
>  
> +enum {
> +	READ_BINDING_OK,
> +	READ_BINDING_SKIP,
> +};
> +
> +static int read_binding(char *line, unsigned int linenr, char **alias,
> +			char **wwid) {
> +	char *c, *saveptr;
> +
> +	c = strpbrk(line, "#\n\r");
> +	if (c)
> +		*c = '\0';
> +
> +	*alias = strtok_r(line, " \t", &saveptr);
> +	if (!*alias) /* blank line */
> +		return READ_BINDING_SKIP;
> +
> +	*wwid = strtok_r(NULL, " \t", &saveptr);
> +	if (!*wwid) {
> +		condlog(1, "invalid line %u in bindings file, missing WWID",
> +			linenr);
> +		return READ_BINDING_SKIP;
> +	}
> +	if (strlen(*wwid) > WWID_SIZE - 1) {
> +		condlog(3,
> +			"Ignoring too large wwid at %u in bindings file",
> +			linenr);
> +		return READ_BINDING_SKIP;
> +	}
> +	c = strtok_r(NULL, " \t", &saveptr);
> +	if (c)
> +		/* This is non-fatal */
> +		condlog(1, "invalid line %d in bindings file, extra args \"%s\"",
> +			linenr, c);
> +	return READ_BINDING_OK;
> +}
> +
>  static int _check_bindings_file(const struct config *conf, FILE *file,
>  				 Bindings *bindings)
>  {
> @@ -658,27 +695,12 @@ static int _check_bindings_file(const struct config *conf, FILE *file,
>  
>  	pthread_cleanup_push(cleanup_free_ptr, &line);
>  	while ((n = getline(&line, &line_len, file)) >= 0) {
> -		char *c, *alias, *wwid, *saveptr;
> +		char *alias, *wwid;
>  		const char *mpe_wwid;
>  
> -		linenr++;
> -		c = strpbrk(line, "#\n\r");
> -		if (c)
> -			*c = '\0';
> -		alias = strtok_r(line, " \t", &saveptr);
> -		if (!alias) /* blank line */
> +		if (read_binding(line, ++linenr, &alias, &wwid)
> +		    == READ_BINDING_SKIP)
>  			continue;
> -		wwid = strtok_r(NULL, " \t", &saveptr);
> -		if (!wwid) {
> -			condlog(1, "invalid line %d in bindings file, missing WWID",
> -				linenr);
> -			continue;
> -		}
> -		c = strtok_r(NULL, " \t", &saveptr);
> -		if (c)
> -			/* This is non-fatal */
> -			condlog(1, "invalid line %d in bindings file, extra args \"%s\"",
> -				linenr, c);
>  
>  		mpe_wwid = get_mpe_wwid(conf->mptable, alias);
>  		if (mpe_wwid && strcmp(mpe_wwid, wwid)) {
> -- 
> 2.41.0
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


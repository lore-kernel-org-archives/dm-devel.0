Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFD1BEE14AA
	for <dm-devel@archiver.kernel.org>; Wed,  6 Sep 2023 22:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694040319;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=URfqGKgX64f6QSbYo6CkM58mULBTq6vMfjmLRfNQkDI=;
	b=Zqx1gfyHaRQDDMLqc4Kyot5eM7bNgFIN81S6+cmOoxnsB2MQVRToGiqyZYsPYf1yiE34vX
	26TbVgjLMmcqM8uCtUNgx980RDYEosjkaqUZGyj41vsdqnFpQ64sO3PtBJjf7bOJxl87U8
	hHdD34uI/KLQ98yfG1B+874dnt8knvU=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-673-6VqetLozPfyzE7om5MZLtA-1; Wed, 06 Sep 2023 18:45:15 -0400
X-MC-Unique: 6VqetLozPfyzE7om5MZLtA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EFE2B1C07261;
	Wed,  6 Sep 2023 22:45:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E07342026D76;
	Wed,  6 Sep 2023 22:45:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CA190194658D;
	Wed,  6 Sep 2023 22:45:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4738A194658C
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Sep 2023 22:45:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2322A40411F; Wed,  6 Sep 2023 22:45:13 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 06502404119;
 Wed,  6 Sep 2023 22:45:12 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 386Mj4CR028979;
 Wed, 6 Sep 2023 17:45:05 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 386Mj4jx028978;
 Wed, 6 Sep 2023 17:45:04 -0500
Date: Wed, 6 Sep 2023 17:45:04 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20230906224504.GY7412@octiron.msp.redhat.com>
References: <20230901180235.23980-1-mwilck@suse.com>
 <20230901180235.23980-15-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20230901180235.23980-15-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH 14/21] libmultipath: update_bindings_file:
 take filename argument
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Sep 01, 2023 at 08:02:27PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> This function just uses the file name, no other configuration
> parameters. Also, pass the Bindings argument first to use the
> same convention as the other functions in this file.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/alias.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/libmultipath/alias.c b/libmultipath/alias.c
> index 5a6cdee..76d852f 100644
> --- a/libmultipath/alias.c
> +++ b/libmultipath/alias.c
> @@ -138,15 +138,15 @@ static int write_bindings_file(const Bindings *bindings, int fd)
>  	return 0;
>  }
>  
> -static int update_bindings_file(const struct config *conf,
> -				const Bindings *bindings)
> +static int update_bindings_file(const Bindings *bindings,
> +				const char *bindings_file)
>  {
>  	int rc;
>  	int fd = -1;
>  	char tempname[PATH_MAX];
>  	mode_t old_umask;
>  
> -	if (safe_sprintf(tempname, "%s.XXXXXX", conf->bindings_file))
> +	if (safe_sprintf(tempname, "%s.XXXXXX", bindings_file))
>  		return -1;
>  	/* coverity: SECURE_TEMP */
>  	old_umask = umask(0077);
> @@ -164,10 +164,10 @@ static int update_bindings_file(const struct config *conf,
>  		unlink(tempname);
>  		return rc;
>  	}
> -	if ((rc = rename(tempname, conf->bindings_file)) == -1)
> +	if ((rc = rename(tempname, bindings_file)) == -1)
>  		condlog(0, "%s: rename: %m", __func__);
>  	else
> -		condlog(1, "updated bindings file %s", conf->bindings_file);
> +		condlog(1, "updated bindings file %s", bindings_file);
>  	return rc;
>  }
>  
> @@ -778,7 +778,7 @@ int check_alias_settings(const struct config *conf)
>  			rc = _check_bindings_file(conf, file, &bindings);
>  			pthread_cleanup_pop(1);
>  			if (rc == -1 && can_write && !conf->bindings_read_only)
> -				rc = update_bindings_file(conf, &bindings);
> +				rc = update_bindings_file(&bindings, conf->bindings_file);
>  			else if (rc == -1)
>  				condlog(0, "ERROR: bad settings in read-only bindings file %s",
>  					conf->bindings_file);
> -- 
> 2.41.0
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


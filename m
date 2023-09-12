Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37973EE49A4
	for <dm-devel@archiver.kernel.org>; Tue, 12 Sep 2023 23:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694559640;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5Pw0569fgZL7VvOz4cZGyTfzgo7s5R2WWfuNrubUp+8=;
	b=IQD4fKpXus1f3KIOpS4VMYt3WIPvZxULVpDJ+FWPFaqcsrRXR4z8n72EqEIbiOfjQnGSMN
	FWxCEPrAoRyClaGnQ9UkMLYIAxlgZablLlqfCVVgQ7qtLBYzsGhSgEUiRXQ0tU6NjiFXhR
	AHFJjlUs9B5lPPYIlJx6Wb03hGIjOQo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-122-ylP7g30tP9ykiMzRfJ-umQ-1; Tue, 12 Sep 2023 19:00:34 -0400
X-MC-Unique: ylP7g30tP9ykiMzRfJ-umQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F1AF916FA5;
	Tue, 12 Sep 2023 23:00:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1D10340C6EA8;
	Tue, 12 Sep 2023 23:00:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 535B919465BA;
	Tue, 12 Sep 2023 23:00:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1F399194658D
 for <dm-devel@listman.corp.redhat.com>; Tue, 12 Sep 2023 23:00:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E5C142156722; Tue, 12 Sep 2023 23:00:19 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C52AA2156721;
 Tue, 12 Sep 2023 23:00:19 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 38CN0Bgr031048;
 Tue, 12 Sep 2023 18:00:11 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 38CN0BvW031047;
 Tue, 12 Sep 2023 18:00:11 -0500
Date: Tue, 12 Sep 2023 18:00:10 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20230912230010.GO7412@octiron.msp.redhat.com>
References: <20230911163846.27197-1-mwilck@suse.com>
 <20230911163846.27197-5-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20230911163846.27197-5-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v2 04/37] libmultipath: never allocate an
 alias that's already taken
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
Cc: dm-devel@redhat.com, David Bond <dbond@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Sep 11, 2023 at 06:38:13PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> If the bindings file is changed in a way that multipathd can't handle
> (e.g. by swapping the aliases of two maps), multipathd must not try
> to re-use an alias that is already used by another map. Creating
> or renaming a map with such an alias will fail. We already avoid
> this for some cases, but not for all. Fix it.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> Cc: David Bond <dbond@suse.com>
> ---
>  libmultipath/alias.c | 33 ++++++++++++++++++++++++---------
>  tests/alias.c        |  2 +-
>  2 files changed, 25 insertions(+), 10 deletions(-)
> 
> diff --git a/libmultipath/alias.c b/libmultipath/alias.c
> index 68f5d84..b5248f2 100644
> --- a/libmultipath/alias.c
> +++ b/libmultipath/alias.c
> @@ -120,7 +120,7 @@ static bool alias_already_taken(const char *alias, const char *map_wwid)
>  		if (dm_get_uuid(alias, wwid, sizeof(wwid)) == 0 &&
>  		    strncmp(map_wwid, wwid, sizeof(wwid)) == 0)
>  			return false;
> -		condlog(3, "%s: alias '%s' already taken, but not in bindings file. reselecting alias",
> +		condlog(3, "%s: alias '%s' already taken, reselecting alias",
>  			map_wwid, alias);
>  		return true;
>  	}
> @@ -359,32 +359,47 @@ char *get_user_friendly_alias(const char *wwid, const char *file, const char *al
>  	rlookup_binding(f, buff, alias_old);
>  
>  	if (strlen(buff) > 0) {
> -		/* if buff is our wwid, it's already
> -		 * allocated correctly
> -		 */
> +		/* If buff is our wwid, it's already allocated correctly. */
>  		if (strcmp(buff, wwid) == 0) {
>  			alias = strdup(alias_old);
>  			goto out;
> +
>  		} else {
>  			condlog(0, "alias %s already bound to wwid %s, cannot reuse",
>  				alias_old, buff);
> -			goto new_alias;

Double semicolon. Doesn't really hurt anything, and it gets removed
later in the patchset, so:

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> +			goto new_alias;		     ;
>  		}
>  	}
>  
> -	id = lookup_binding(f, wwid, &alias, NULL, 0);
> +	/*
> +	 * Look for an existing alias in the bindings file.
> +	 * Pass prefix = NULL, so lookup_binding() won't try to allocate a new id.
> +	 */
> +	lookup_binding(f, wwid, &alias, NULL, 0);
>  	if (alias) {
> -		condlog(3, "Use existing binding [%s] for WWID [%s]",
> -			alias, wwid);
> +		if (alias_already_taken(alias, wwid)) {
> +			free(alias);
> +			alias = NULL;
> +		} else
> +			condlog(3, "Use existing binding [%s] for WWID [%s]",
> +				alias, wwid);
>  		goto out;
>  	}
>  
> -	/* allocate the existing alias in the bindings file */
> +	/* alias_old is already taken by our WWID, update bindings file. */
>  	id = scan_devname(alias_old, prefix);
>  
>  new_alias:
>  	if (id <= 0) {
> +		/*
> +		 * no existing alias was provided, or allocating it
> +		 * failed. Try a new one.
> +		 */
>  		id = lookup_binding(f, wwid, &alias, prefix, 1);
> +		if (id == 0 && alias_already_taken(alias, wwid)) {
> +			free(alias);
> +			alias = NULL;
> +		}
>  		if (id <= 0)
>  			goto out;
>  		else
> diff --git a/tests/alias.c b/tests/alias.c
> index 3ca6c28..11f209e 100644
> --- a/tests/alias.c
> +++ b/tests/alias.c
> @@ -398,7 +398,7 @@ static void mock_self_alias(const char *alias, const char *wwid)
>  	will_return(__wrap_dm_get_uuid, wwid);
>  }
>  
> -#define USED_STR(alias_str, wwid_str) wwid_str ": alias '" alias_str "' already taken, but not in bindings file. reselecting alias\n"
> +#define USED_STR(alias_str, wwid_str) wwid_str ": alias '" alias_str "' already taken, reselecting alias\n"
>  
>  static void mock_failed_alias(const char *alias, char *msg)
>  {
> -- 
> 2.42.0
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


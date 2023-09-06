Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36BFDEE14A9
	for <dm-devel@archiver.kernel.org>; Wed,  6 Sep 2023 22:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694040185;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=NE7vhr5eBHm1Psotea+cso4ofyXvecG1WsOGaih1pnc=;
	b=N+c+J9dQgH2v70w0iikq2jifxyu1EEduCq91VtEDBRBTDkO0aPxpxcgoVSAd2e0gCz5y++
	ScfLBruUEWeszVo5B2ucnQodmDdFI7L76oo87n/OBUgfDQh6FgPXgwgOzPH/MOKVO/XQJW
	yVFwreEGgOb6jONliLaGEuyvDjY8Qhw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-294-Ee-nGsvEMaKjdvGOkSbjPw-1; Wed, 06 Sep 2023 18:43:02 -0400
X-MC-Unique: Ee-nGsvEMaKjdvGOkSbjPw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD09C8015AA;
	Wed,  6 Sep 2023 22:42:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B785F404119;
	Wed,  6 Sep 2023 22:42:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 876AB194658D;
	Wed,  6 Sep 2023 22:42:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0873C194658C
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Sep 2023 22:42:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DD833493112; Wed,  6 Sep 2023 22:42:57 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BDED8493110;
 Wed,  6 Sep 2023 22:42:57 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 386Mgn5r028917;
 Wed, 6 Sep 2023 17:42:49 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 386Mgn6Y028916;
 Wed, 6 Sep 2023 17:42:49 -0500
Date: Wed, 6 Sep 2023 17:42:48 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20230906224248.GO7412@octiron.msp.redhat.com>
References: <20230901180235.23980-1-mwilck@suse.com>
 <20230901180235.23980-5-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20230901180235.23980-5-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH 04/21] libmultipath: never allocate an alias
 that's already taken
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Sep 01, 2023 at 08:02:17PM +0200, mwilck@suse.com wrote:
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
>  libmultipath/alias.c | 36 +++++++++++++++++++++++++++++++-----
>  tests/alias.c        |  2 +-
>  2 files changed, 32 insertions(+), 6 deletions(-)
> 
> diff --git a/libmultipath/alias.c b/libmultipath/alias.c
> index 9b9b789..f7834d1 100644
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
> @@ -363,28 +363,54 @@ char *get_user_friendly_alias(const char *wwid, const char *file, const char *al
>  		 * allocated correctly
>  		 */
>  		if (strcmp(buff, wwid) == 0) {

I'm confused about this. We should only have alias_old set if there
already exists a device that matches this WWID, right? That's what I
though alias_old means. Am I missing some way that alias_old could get
set to something other than the alias of an already existing device with
a matching WWID? Otherwise, once we verify that that this mapping also
exists in the bindings file, we should be fine to use it?

> -			alias = strdup(alias_old);
> +			if (!alias_already_taken(alias_old, wwid))
> +				alias = strdup(alias_old);
> +			else
> +				condlog(0, "ERROR: old alias [%s] for wwid [%s] is used by other map",
> +					alias_old, wwid);
>  			goto out;
> +
>  		} else {
>  			condlog(0, "alias %s already bound to wwid %s, cannot reuse",
>  				alias_old, buff);
> -			goto new_alias;

extra semicolon.

> +			goto new_alias;		     ;
>  		}
>  	}
>  
> +	/*
> +	 * Look for an existing alias in the bindings file.
> +	 * Pass prefix = NULL, so lookup_binding() won't try to allocate a new id.
> +	 */

There's no point in saving the return value here. We don't use if for
anything.

>  	id = lookup_binding(f, wwid, &alias, NULL, 0);
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
>  	/* allocate the existing alias in the bindings file */
>  	id = scan_devname(alias_old, prefix);

Again, unless I'm overlooking something, I don't think we need to
check if the alias is already taken here. Since we know that a device
already exists with alias_old and the correct WWID, as long as alias_old
is a valid user_friendly_name we can just use it.

> +	if (id > 0 && id_already_taken(id, prefix, wwid)) {
> +		condlog(0, "ERROR: old alias [%s] for wwid [%s] is used by other map",
> +			alias_old, wwid);
> +		goto out;
> +	}
>  
>  new_alias:
>  	if (id <= 0) {
> +		/*
> +		 * no existing alias was provided, or allocating it
> +		 * failed. Try a new one.
> +		 */
>  		id = lookup_binding(f, wwid, &alias, prefix, 1);

If lookup_binding() was going to return (id == 0) it already would have
when we called it earlier in this function, so I don't think this check
is necessary either.

-Ben

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
> 2.41.0
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


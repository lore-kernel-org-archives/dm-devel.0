Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD024142E98
	for <dm-devel@lists.linux.dev>; Mon, 10 Jun 2024 17:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718039521; cv=none; b=VvuvQJ6yECJ3Cj6DEqQb3Qhj83elzpSMBnIPcMGl4cYfa2km6IqGNCU+RA3yMF1hyVP5Nq52WvDaPATGjUMEAhvxDPns+ViG4cBGr5yDPvIxHJkvxdmuaEsHmoFC9n/FJZJt1q1FgFmXcXckX4CrubyMaw7OCBllcfQT4a+sgYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718039521; c=relaxed/simple;
	bh=i7Mp3njgnUyN6z/w9Oq4Haw9SH5wnRUWpgAjai2AWow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pSHKiq6KngLmjPkg1uFdZ2nb3YGs7A9MTtwDWePGjRiEsFZTaai8zHP7Ji1BNT1U1GqIJ01jit7GMW99YciC61RZfB9UJQSwxamyBk+mrbdgS3usGt44W9m2JVrJmgqRckkC0ydIJHj9oVRN4FDThoOf4au2zHs8PWgTEWMU3iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aLjos4q0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aLjos4q0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718039518;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wXFcktEbxkN4ZgnPgOmnqMYkkKSi2uvyDdwHZMWpgWU=;
	b=aLjos4q0O2nbj600M3f13M3KV5Fr0857W4U8MZyfQknDotPkZ2p17zeANTwK1+MQZzhBlB
	xknbc+bsLBwDrzjpy0zCbmoe6RcZUqTBgRyMRqJghKjb/sZG5xGzFEl/ZuesNc+DPqBuOT
	ej89YauohPZrb1BjPwmYMUgkxkiHJns=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-589-sxKqSlOGN5ep_CpUqxr6UA-1; Mon,
 10 Jun 2024 13:11:55 -0400
X-MC-Unique: sxKqSlOGN5ep_CpUqxr6UA-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A61DF1955F35;
	Mon, 10 Jun 2024 17:11:53 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0889C1956051;
	Mon, 10 Jun 2024 17:11:52 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 45AHBdiG800812
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 10 Jun 2024 13:11:39 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 45AHBd0o800811;
	Mon, 10 Jun 2024 13:11:39 -0400
Date: Mon, 10 Jun 2024 13:11:39 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Abhinav Jain <jain.abhinav177@gmail.com>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        skhan@linuxfoundation.org, javier.carrasco.cruz@gmail.com
Subject: Re: [PATCH] dm: Add support for escaped characters in
 str_field_delimit()
Message-ID: <Zmczy8EijOK-D7ZE@redhat.com>
References: <20240609141721.52344-1-jain.abhinav177@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240609141721.52344-1-jain.abhinav177@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Sun, Jun 09, 2024 at 02:17:21PM +0000, Abhinav Jain wrote:
> Add a new variable for escaped characters.
> 
> If an escaped character (\) is found before the separator, and if the 
> separator is not found or if the escaped character is located before the
> separator, then move the separator ahead and continue searching for the
> next separator.
> 
> Return the pointer to remainder string after the delimiter. If the
> separator was found, return a pointer to the character immediately after
> the delimiter (s + 1). If the separator was not found, return NULL.

This doesn't do anything to the escape character. Presumably you want to
pass the field containing a separator down to dm_eary_create(). But you
don't want to pass the escape character itself.

To work correctly, this code needs to remove all those escape characters
that come before separators. It probably needs to do something like:

1. Find a next non-escaped separator and change it to NULL, so you have
your field string.

2. Find all the escaped separators in the field string, and shift the
rest of the string over to overwrite the escape character with the rest
of the string.

-Ben

> 
> Signed-off-by: Abhinav Jain <jain.abhinav177@gmail.com>
> ---
>  drivers/md/dm-init.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-init.c b/drivers/md/dm-init.c
> index 2a71bcdba92d..bef6a582a4ae 100644
> --- a/drivers/md/dm-init.c
> +++ b/drivers/md/dm-init.c
> @@ -87,11 +87,21 @@ static void __init dm_setup_cleanup(struct list_head *devices)
>   */
>  static char __init *str_field_delimit(char **str, char separator)
>  {
> -	char *s;
> +	char *s, *escaped;
>  
> -	/* TODO: add support for escaped characters */
>  	*str = skip_spaces(*str);
>  	s = strchr(*str, separator);
> +
> +	/* Check for escaped character */
> +	escaped = strchr(*str, '\\');
> +	if (escaped && (s == NULL || escaped < s)) {
> +		/*
> +		 * If escaped character comes before the separator, move
> +		 * the separator ahead & continue searching for next one.
> +		 */
> +		s = strchr(escaped + 1, separator);
> +	}
> +
>  	/* Delimit the field and remove trailing spaces */
>  	if (s)
>  		*s = '\0';
> -- 
> 2.34.1
> 


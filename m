Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AEE7145FF7
	for <dm-devel@lists.linux.dev>; Mon, 10 Jun 2024 17:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718040520; cv=none; b=sws+UGK45ASOv3ZmfngfmBfZCp+oeJiByk8H3MJPdQuAlQerhblBzG8hTCDyrpBprCpFGTkFm6Gvhi9diKckhsk7MxcA/o6S+Q2wdqfbLg6KgVEyIwE/cNarA+itVR+ny7xYPxyNdIkTDTNrHCuNCjBLbJhEx1S3V60o9gOAA6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718040520; c=relaxed/simple;
	bh=E9w89+B2B7+pHEOspQLd1KCD1iOqsKdjTUWoD8G4oyY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RSz9mZRrB8uHVXi1zFA8INp+7Lo2WLt3cjZUolwiHzUTm8tG0IP7239/qAx4w90JoveHeEJsZ0J26GmK37EJEOf15ljjxEs8EwvbjT+uS1Jv4gTdwj8k1+pYj5greWNtzmLDdNRb5HVjCq5crCXcoIhfVDVWpG/GeY1ZTzlrFsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ELHWu1KW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ELHWu1KW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718040518;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7Ss+jn32vMkFORsgEtb9NzBOj1J/8gbZRcW5oNqfgF8=;
	b=ELHWu1KWq00G1VBc1XmMB48jdW1oV7VqWU7D19vKJ5BoOrmv8LCV2s/lsJtkuSYdXki5uC
	aJuhgWGLh9KJOitv7v2M1WJdg+ZNyAc+mejo1kEoD17g9Vbhqtv4BS+TOxCQOtLu9lTPQx
	jnYddUUQKmDtO3VnpxBN048RQpR0GwY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-274-Z9pgwgGBNoeVKBMxF7Atag-1; Mon,
 10 Jun 2024 13:28:34 -0400
X-MC-Unique: Z9pgwgGBNoeVKBMxF7Atag-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 43AC219560B4;
	Mon, 10 Jun 2024 17:28:33 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6F6F619560AB;
	Mon, 10 Jun 2024 17:28:32 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 45AHSVBf801304
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 10 Jun 2024 13:28:31 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 45AHSUBI801303;
	Mon, 10 Jun 2024 13:28:30 -0400
Date: Mon, 10 Jun 2024 13:28:30 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Abhinav Jain <jain.abhinav177@gmail.com>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        skhan@linuxfoundation.org, javier.carrasco.cruz@gmail.com
Subject: Re: [PATCH] dm: Add support for escaped characters in
 str_field_delimit()
Message-ID: <Zmc3vrfFglYISw1P@redhat.com>
References: <20240609141721.52344-1-jain.abhinav177@gmail.com>
 <Zmczy8EijOK-D7ZE@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zmczy8EijOK-D7ZE@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Mon, Jun 10, 2024 at 01:11:40PM -0400, Benjamin Marzinski wrote:
> On Sun, Jun 09, 2024 at 02:17:21PM +0000, Abhinav Jain wrote:
> > Add a new variable for escaped characters.
> > 
> > If an escaped character (\) is found before the separator, and if the 
> > separator is not found or if the escaped character is located before the
> > separator, then move the separator ahead and continue searching for the
> > next separator.
> > 
> > Return the pointer to remainder string after the delimiter. If the
> > separator was found, return a pointer to the character immediately after
> > the delimiter (s + 1). If the separator was not found, return NULL.
> 
> This doesn't do anything to the escape character. Presumably you want to
> pass the field containing a separator down to dm_eary_create(). But you
> don't want to pass the escape character itself.
> 
> To work correctly, this code needs to remove all those escape characters
> that come before separators. It probably needs to do something like:
> 
> 1. Find a next non-escaped separator and change it to NULL, so you have
> your field string.

And by NULL, I mean '\0'.

-Ben

> 
> 2. Find all the escaped separators in the field string, and shift the
> rest of the string over to overwrite the escape character with the rest
> of the string.
> 
> -Ben
> 
> > 
> > Signed-off-by: Abhinav Jain <jain.abhinav177@gmail.com>
> > ---
> >  drivers/md/dm-init.c | 14 ++++++++++++--
> >  1 file changed, 12 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/md/dm-init.c b/drivers/md/dm-init.c
> > index 2a71bcdba92d..bef6a582a4ae 100644
> > --- a/drivers/md/dm-init.c
> > +++ b/drivers/md/dm-init.c
> > @@ -87,11 +87,21 @@ static void __init dm_setup_cleanup(struct list_head *devices)
> >   */
> >  static char __init *str_field_delimit(char **str, char separator)
> >  {
> > -	char *s;
> > +	char *s, *escaped;
> >  
> > -	/* TODO: add support for escaped characters */
> >  	*str = skip_spaces(*str);
> >  	s = strchr(*str, separator);
> > +
> > +	/* Check for escaped character */
> > +	escaped = strchr(*str, '\\');
> > +	if (escaped && (s == NULL || escaped < s)) {
> > +		/*
> > +		 * If escaped character comes before the separator, move
> > +		 * the separator ahead & continue searching for next one.
> > +		 */
> > +		s = strchr(escaped + 1, separator);
> > +	}
> > +
> >  	/* Delimit the field and remove trailing spaces */
> >  	if (s)
> >  		*s = '\0';
> > -- 
> > 2.34.1
> > 


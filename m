Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9507517548
	for <dm-devel@lists.linux.dev>; Mon, 25 Nov 2024 18:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732557935; cv=none; b=VpPKS0YG5R5zSS0JXeuEOs5p2xj6BZ+696zsOl04PW6Fk5YRq0cnqRWaoydrjytWNtd+AQWb/B91Ioyu1+2h4ASkPNcALvvKhkaxO9Y414mmsicepLP3qXC0AkDSBIlXUaCsf6Zt840ba5A4yQaQHu3tK6z/cL2rKHIuEEnNjus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732557935; c=relaxed/simple;
	bh=v/R1VM7mcGkcfAvAUUXadEoZSGRWhiw/WzRSzRWagdY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=XV55DIXCtBS4FPS5DsRQhLcW5WDc6VvF/JqQONHP3IdYILZNNzjhkIVgb+g+jv6r1Vh5QYg7Yh7uQXFZhF3VkOQ9ytLAUd9s/kV4rEY3ItHnpsU7PyfhmGOeD9lUyOf1Es9E0jHkdo0ZTjQx1yNz221ylar4EtAzyXox6KWOGts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UrMnnMf5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UrMnnMf5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732557932;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MNND5DUCah/LTo7+IHrH63le3wXj6M9Z9f05nmFL/yY=;
	b=UrMnnMf5lg67bfoijxfvKJQPwA19WgaadcejmK1jx9SM3kgd/1yTK270vXe+2QPUNfE53M
	PlIjPSFk4qxoVtRaV5ZJQIAzLyT1YqvH1lEEBetHpUogk9PGTKms4z/4mnyT2HxBq1MouH
	OH3pDDB3NxEss2Hy33HsQ9ZLZfv5Hgs=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-661-vG5OpdPjNB667T1cr6YHHQ-1; Mon,
 25 Nov 2024 13:05:29 -0500
X-MC-Unique: vG5OpdPjNB667T1cr6YHHQ-1
X-Mimecast-MFC-AGG-ID: vG5OpdPjNB667T1cr6YHHQ
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 54FF91956048;
	Mon, 25 Nov 2024 18:05:28 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C356330000DF;
	Mon, 25 Nov 2024 18:05:27 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4API5QTf759555
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 25 Nov 2024 13:05:26 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4API5QL9759554;
	Mon, 25 Nov 2024 13:05:26 -0500
Date: Mon, 25 Nov 2024 13:05:26 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH v2 06/13] libmultipath: handle a create corner case for
 empty devices
Message-ID: <Z0S8ZgQ4sI4gRvcQ@redhat.com>
References: <20241122211133.718861-1-bmarzins@redhat.com>
 <20241122211133.718861-7-bmarzins@redhat.com>
 <e1b620534c909d8ea01e193292ec5dd1ad652ab0.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <e1b620534c909d8ea01e193292ec5dd1ad652ab0.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UdmAjglpq187IQcOxWsr6jiMJt2saGfB3gIAwt51ELc_1732557928
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Nov 22, 2024 at 10:54:31PM +0100, Martin Wilck wrote:
> On Fri, 2024-11-22 at 16:11 -0500, Benjamin Marzinski wrote:
> > Multipath already notices if there is any empty device with the same
> > alias and wwid as a device it is trying to create, and switches to a
> > reload. However, if the empty device has a different alias but the
> > same
> > wwid, instead of reloading and renaming the device like it would for
> > a device with a table. multipath will attempt to create a new device
> > and fail.
> > 
> > Fix this by checking for these devices, and doing a reload and
> > rename.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/configure.c | 21 ++++++++++++++++++++-
> >  1 file changed, 20 insertions(+), 1 deletion(-)
> > 
> > diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> > index a7257981..d0e9c958 100644
> > --- a/libmultipath/configure.c
> > +++ b/libmultipath/configure.c
> > @@ -835,7 +835,6 @@ int domap(struct multipath *mpp, char *params,
> > int is_daemon)
> >  {
> >  	int r = DOMAP_FAIL;
> >  	struct config *conf;
> > -	char wwid[WWID_SIZE];
> >  
> >  	/*
> >  	 * last chance to quit before touching the devmaps
> > @@ -846,6 +845,7 @@ int domap(struct multipath *mpp, char *params,
> > int is_daemon)
> >  	}
> >  
> >  	if (mpp->action == ACT_CREATE) {
> > +		char wwid[WWID_SIZE];
> >  		int rc = dm_get_wwid(mpp->alias, wwid,
> > sizeof(wwid));
> >  
> >  		if (rc == DMP_OK && !strncmp(mpp->wwid, wwid,
> > sizeof(wwid))) {
> > @@ -863,7 +863,26 @@ int domap(struct multipath *mpp, char *params,
> > int is_daemon)
> >  			mpp->action = ACT_REJECT;
> >  		}
> >  	}
> > +	if (mpp->action == ACT_CREATE) {
> > +		char alias[WWID_SIZE];
> > +		int rc = dm_find_map_by_wwid(mpp->wwid, alias,
> > NULL);
> >  
> > +		if (rc == DMP_NO_MATCH) {
> > +			condlog(1, "%s: wwid \"%s\" already in use
> > by non-multipath map \"%s\"",
> > +				mpp->alias, mpp->wwid, alias);
> 
> Nitpick: This is almost the same message that dm_find_map_by_wwid() has
> printed immediately before. Similar messages are also printed in all
> other callers of dm_find_map_by_wwid(). I suggest that we either remove
> the log message in the callers or in dm_find_map_by_wwid() itself.
> Probably the latter, then we can decide on a case by case basis in the
> caller whether the situation needs to be logged.

I'm confused here. dm_find_map_by_wwid() doesn't print any message
itself. It calls libmp_mapinfo__(), which could print either:

condlog(lvl, "%s: map %s has multiple targets", fname__, map_id);

or:

condlog(lvl, "%s: target type mismatch: \"%s\" != \"%s\"",
        fname__, tgt_type, target_type);

in this case, but at level 4 verbosity, and these are used to
distinguish between the various reasons why DMP_NO_MATCH could be
returned, which seems like a reasonable thing at that verbosity. 

-Ben

> 
> Martin


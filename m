Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3682E374E7
	for <dm-devel@lists.linux.dev>; Wed,  8 Nov 2023 22:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SrUnVVj0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699481627;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0wOXfOJ8xR5GEEBlwqm/pjUlz/Uyng0TselNNOKYFiE=;
	b=SrUnVVj0n8k9igVWGAZ47qjleoohhiKvhzTOW29cRvBL4QDArm6vsglnaN+RMJZIXBqrvn
	9jbIuygiIUpzryjgKe0D69sCfMAKrSuk4kfWfRMLxYiEbYFGb0n8RDjhbqfGlgnKNVesLP
	9VfwBCfsBAZjYDjtohA6wvJHRbEgEC4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-657-nGofwTrTMQyg-vciMXlPQA-1; Wed,
 08 Nov 2023 17:13:44 -0500
X-MC-Unique: nGofwTrTMQyg-vciMXlPQA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 959B029AA398;
	Wed,  8 Nov 2023 22:08:43 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (bmarzins-01.fast.rdu2.eng.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8AD73C1290F;
	Wed,  8 Nov 2023 22:08:43 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1) with ESMTPS id 3A8M8gVc089860
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 8 Nov 2023 17:08:43 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1/Submit) id 3A8M8gfr089859;
	Wed, 8 Nov 2023 17:08:42 -0500
Date: Wed, 8 Nov 2023 17:08:42 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>,
        "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 1/7] libmultipath: Add max_retries config option
Message-ID: <ZUwG6iJU1xZ/S8WS@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231102221507.105371-1-bmarzins@redhat.com>
 <20231102221507.105371-2-bmarzins@redhat.com>
 <e704003e124116e72771d2b7ef90ca66ef242e1c.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <e704003e124116e72771d2b7ef90ca66ef242e1c.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Nov 08, 2023 at 03:36:14PM +0000, Martin Wilck wrote:
> On Thu, 2023-11-02 at 18:15 -0400, Benjamin Marzinski wrote:
> > This option lets multipath set a scsi disk's max_retries sysfs value.
> > Setting this can be helpful for cases where the path checker
> > succeeds,
> > but IO commands hang and timeout. By default, the SCSI layer will
> > retry
> > IOs 5 times. Reducing this value will allow multipath to retry the IO
> > down another path sooner.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> 2 nitpicks below. Please explain to me again why we recommend to
> activate shaky paths detection with this. What will go wrong if the
> user uses max_retries without shaky path detection?

In the case were the path_checker keeps succeeding, but the IOs keep
hanging, multipathd will just keep restoring this path over and over
again. That's the sort of path ping-ponging that shaky path detection
should be able to stop. I guess this is can speed up other cases for
failover as well, so I can leave that off.  Hopefully people know that
if they are seeing ping-ponging, shaky path detection can help with it.

> 
> > ---
> >  libmultipath/config.c         |  3 +++
> >  libmultipath/config.h         |  3 +++
> >  libmultipath/dict.c           | 34 ++++++++++++++++++++++++++++
> >  libmultipath/discovery.c      | 42
> > ++++++++++++++++++++++++++++++++++-
> >  libmultipath/propsel.c        | 18 +++++++++++++++
> >  libmultipath/propsel.h        |  1 +
> >  libmultipath/structs.h        |  7 ++++++
> >  multipath/multipath.conf.5.in | 22 ++++++++++++++++++
> >  8 files changed, 129 insertions(+), 1 deletion(-)
> > 
> > diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> > index 044067af..fc438947 100644
> > --- a/libmultipath/dict.c
> > +++ b/libmultipath/dict.c
> > @@ -1152,6 +1152,36 @@ declare_hw_snprint(eh_deadline,
> > print_undef_off_zero)
> >  declare_pc_handler(eh_deadline, set_undef_off_zero)
> >  declare_pc_snprint(eh_deadline, print_undef_off_zero)
> >  
> > +static int
> > +set_max_retries(vector strvec, void *ptr, const char *file, int
> > line_nr)
> > +{
> > +	char * buff;
> > +	int *int_ptr = (int *)ptr;
> > +
> > +	buff = set_value(strvec);
> > +	if (!buff)
> > +		return 1;
> > +
> > +	if (strcmp(buff, "off") == 0)
> > +		*int_ptr = UOZ_OFF;
> > +	else if (strcmp(buff, "0") == 0)
> > +		*int_ptr = UOZ_ZERO;
> 
> Why not use MAX_RETRIES_OFF and MAX_RETRIES_ZERO here?

No good reason. I can change that.

> > +	else
> > +		do_set_int(strvec, int_ptr, 1, 5, file, line_nr,
> > buff);
> > +
> > +	free(buff);
> > +	return 0;
> > +}
> > +
> 
> > diff --git a/multipath/multipath.conf.5.in
> > b/multipath/multipath.conf.5.in
> > index 226d0019..41f3927e 100644
> > --- a/multipath/multipath.conf.5.in
> > +++ b/multipath/multipath.conf.5.in
> > @@ -793,6 +793,22 @@ The default is: \fB<unset>\fR
> >  .
> >  .
> >  .TP
> > +.B max_retries
> > +Specify the maximum number of times the SCSI layer will retry IO
> > commands
> > +before returning failure. Setting this can be helpful for cases
> > where the path
> > +checker succeeds, but IO commands hang and timeout. By default, the
> > SCSI layer
> > +will retry IOs 5 times. Reducing this value will allow multipath to
> > retry the IO
> > +down another path sooner. \fBNote:\fR If it is necessary to set this
> 
> Maybe you should add "[retry IO commands] for some types of SCSI
> errors". Otherwise users might get their hopes too high. IIRC the main
> cases that matter here are DID_TRANSPORT_DISRUPTED and perhaps
> DID_BUS_BUSY (don't put that in the man page) ;-)

Sure.

-Ben

> 
> 
> > value, it
> > +is also recommended to set up shaky paths detection. See "Shaky
> > paths detection"
> > +below. Valid values are
> > +\fB0\fR through \fB5\fR.
> > +.RS
> > +.TP
> > +The default is: \fB<unset>\fR
> > +.RE
> 
> 


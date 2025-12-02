Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34951DDC35
	for <dm-devel@lists.linux.dev>; Tue,  2 Dec 2025 01:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764637217; cv=none; b=rQzNFUtGc0k7wWvmtCp7uK67RnVkWqNrkSFIPM7yaw3aVzIUVbrV+yoOQ3pAjWmIddNH5EhyZnxM5SE4o/z5Nuep3IpAlZIxcRgvQyLz6gzUpJcWZ0QAoZBLdhk7RhyODqQmMbJmmp66Jgz76/P0/kvKVcvqSd4z6sFvMGsPXOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764637217; c=relaxed/simple;
	bh=PxP6uKksKUzaWHty9yfcmnKTHhxY0xe7WiUUDcUvSbU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y2MxU0IAgKUAI3HK8+KIV6JI4uKDkPN/zvNYtEWTAqGBD+whcQoOhbdWWN9bmP9cq4vXhSK5pu9du3WMQuH6IH3JEDJhPUJ8AfQg80B5ACmYcRUNdgH8pIfj5/jz0IEOzEQBlsSKXdfrME1G/zm7Uq1nwqD0p1MHCHt2P0hIrMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eXsI8m7m; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eXsI8m7m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764637213;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BSXRUI4rYX7v7e12DwZA3WuUIB5pISkkj3j3RLO+rQQ=;
	b=eXsI8m7mwQFid6z6pdjXbH90NkbzhYLrO8SdzLcb5D4BEZ4ifbwir6YoVBzfyI1IkPYmrI
	00L7j5vreXPX0q0ihcGbt4yfdylX511YWeUjiviiR3gxJbqUJ9kvW+qmPpgGct6nrPHxb0
	agbNktPhFf4Anbaa4ebfVjiHBBXa9ns=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-151-ZBixc-R5PgycTpzbf1ZMkw-1; Mon,
 01 Dec 2025 20:00:07 -0500
X-MC-Unique: ZBixc-R5PgycTpzbf1ZMkw-1
X-Mimecast-MFC-AGG-ID: ZBixc-R5PgycTpzbf1ZMkw_1764637206
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 788E91955F2A;
	Tue,  2 Dec 2025 01:00:05 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 82B3A1955F24;
	Tue,  2 Dec 2025 01:00:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5B2103js1429478
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 1 Dec 2025 20:00:03 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5B21029A1429477;
	Mon, 1 Dec 2025 20:00:02 -0500
Date: Mon, 1 Dec 2025 20:00:02 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Cc: "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>, linux-scsi@vger.kernel.org,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH] scsi: scsi_dh: Return error pointer in
 scsi_dh_attached_handler_name
Message-ID: <aS46EpB6dijzABwA@redhat.com>
References: <20251121234834.1035028-1-bmarzins@redhat.com>
 <94bce7593f2980cef43860044e5b662c3d3c0ec7.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <94bce7593f2980cef43860044e5b662c3d3c0ec7.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Thu, Nov 27, 2025 at 04:26:51PM +0100, Martin Wilck wrote:
> On Fri, 2025-11-21 at 18:48 -0500, Benjamin Marzinski wrote:
> > If scsi_dh_attached_handler_name() fails to allocate the handler
> > name,
> > dm-multipath (its only caller) assumes there is no attached device
> > handler, and sets the device up incorrectly. Return an error pointer
> > instead, so multipath can distinguish between failure and success
> > where
> > there is no attached device handler.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  drivers/md/dm-mpath.c  | 8 ++++++++
> >  drivers/scsi/scsi_dh.c | 8 +++++---
> >  2 files changed, 13 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> > index c18358271618..063dc526fe04 100644
> > --- a/drivers/md/dm-mpath.c
> > +++ b/drivers/md/dm-mpath.c
> > @@ -950,6 +950,14 @@ static struct pgpath *parse_path(struct
> > dm_arg_set *as, struct path_selector *ps
> >  
> >  	q = bdev_get_queue(p->path.dev->bdev);
> >  	attached_handler_name = scsi_dh_attached_handler_name(q,
> > GFP_KERNEL);
> > +	if (IS_ERR(attached_handler_name)) {
> > +		if (PTR_ERR(attached_handler_name) == -ENODEV)
> > +			attached_handler_name = NULL;
> 
> What's the point of continuing here if we know that the SCSI device
> doesn't exist?

we just know that it's not a SCSI device, so we clear
attached_handler_name.  I suppose we could add another check to error
out here if m->hw_handler_name is set. But if it is, the setup_scsi_dh()
call just below will fail anyways, so there's not much difference.

But if you think adding that extra check makes things clearer, I'm fine
with that.

-Ben
 
> Thanks,
> Martin
> 
> > +		else {
> > +			r = PTR_ERR(attached_handler_name);
> > +			goto bad;
> > +		}
> > +	}
> >  	if (attached_handler_name || m->hw_handler_name) {
> >  		INIT_DELAYED_WORK(&p->activate_path,
> > activate_path_work);
> >  		r = setup_scsi_dh(p->path.dev->bdev, m,
> > &attached_handler_name, &ti->error);
> > diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
> > index 7b56e00c7df6..b9d805317814 100644
> > --- a/drivers/scsi/scsi_dh.c
> > +++ b/drivers/scsi/scsi_dh.c
> > @@ -353,7 +353,8 @@ EXPORT_SYMBOL_GPL(scsi_dh_attach);
> >   *      that may have a device handler attached
> >   * @gfp - the GFP mask used in the kmalloc() call when allocating
> > memory
> >   *
> > - * Returns name of attached handler, NULL if no handler is attached.
> > + * Returns name of attached handler, NULL if no handler is attached,
> > or
> > + * and error pointer if an error occurred.
> >   * Caller must take care to free the returned string.
> >   */
> >  const char *scsi_dh_attached_handler_name(struct request_queue *q,
> > gfp_t gfp)
> > @@ -363,10 +364,11 @@ const char
> > *scsi_dh_attached_handler_name(struct request_queue *q, gfp_t gfp)
> >  
> >  	sdev = scsi_device_from_queue(q);
> >  	if (!sdev)
> > -		return NULL;
> > +		return ERR_PTR(-ENODEV);
> >  
> >  	if (sdev->handler)
> > -		handler_name = kstrdup(sdev->handler->name, gfp);
> > +		handler_name = kstrdup(sdev->handler->name, gfp) ? :
> > +			       ERR_PTR(-ENOMEM);
> >  	put_device(&sdev->sdev_gendev);
> >  	return handler_name;
> >  }


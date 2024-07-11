Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC6126AEC
	for <dm-devel@lists.linux.dev>; Thu, 11 Jul 2024 18:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720723176; cv=none; b=M1rOvdJCrnsyif2W7yKvj3Y1JW/W9p8XNvDD8b4AwbnbA/CYjw59svBzAIEyi3o2ud/TFc+7YVIybEYVi8ITGkq9CDhh2yDBQtI5J7805vl9tsR/285KlzDj4arnHcK1JgoJ7TkVjIX3YDczUaWMJnhyDxflK9bQn9P2yWy3RNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720723176; c=relaxed/simple;
	bh=gqiu+ZfOsWm30JiovxbS6qQ855VR/deXEg1507QNY/E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=mZYgdUI7Ys/1vh/GHhFtJtr0JA3PbrgiCFmz7G63Z8HTjxJjXx1G9lB58hXS9Py6eUPJ7vDR0agUuL5XBxMyYgWlf+Ukr8ovDL6S3XlWPjSlKUjtl7eAol6WY7x2MSHxudCD+xDNUKdRz6GME1ZbP+91mH1BxRTFbX3f5/D8rZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J13X6ts5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J13X6ts5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720723173;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YoFfgKY6m5TYlIpWyQK6/R/8ZUfp4Q1NTgyMC1QCxkk=;
	b=J13X6ts5tHBIWiaubXzvlO9Pg2HgRE1SKQiRfRLloWUFDt2o2lpF1t0DcyCPexJ/hK/a30
	kcJ2zuRrKtYJ1j6JqW1x+BPCP0h5i4ZuJ59G+YTNSShmCVPnT6/IpAy9H/pPZRQ9uRZsg6
	71LgkQ55IkfO1ZYJsauHaE3WlF2WrXA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-209-BalbxC8MN6eTs4EmCMUp-A-1; Thu,
 11 Jul 2024 14:39:29 -0400
X-MC-Unique: BalbxC8MN6eTs4EmCMUp-A-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DA4CD19560BA;
	Thu, 11 Jul 2024 18:39:27 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 999E41955E85;
	Thu, 11 Jul 2024 18:39:27 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46BIdQ8X1950825
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 11 Jul 2024 14:39:26 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46BIdPP01950824;
	Thu, 11 Jul 2024 14:39:25 -0400
Date: Thu, 11 Jul 2024 14:39:25 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH 31/44] libmultipath: add is_mpath_uuid() helper
Message-ID: <ZpAm3ZXvPx21XHHO@redhat.com>
References: <20240709213935.177028-1-mwilck@suse.com>
 <20240709213935.177028-32-mwilck@suse.com>
 <Zo9TsqnZ3Zs6XD1w@redhat.com>
 <ed5136498c6ac428a5ee25d0c3af712ba57445d2.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ed5136498c6ac428a5ee25d0c3af712ba57445d2.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Jul 11, 2024 at 02:56:05PM +0200, Martin Wilck wrote:
> On Wed, 2024-07-10 at 23:38 -0400, Benjamin Marzinski wrote:
> > On Tue, Jul 09, 2024 at 11:39:22PM +0200, Martin Wilck wrote:
> > > Export it, as it will be used by multipathd and libmpathpersist.
> > > 
> > 
> > This is fine. But I was thinking that if you wanted to actually add
> > some optional flags to the flags argument of libmp_mapinfo(), this
> > would
> > be a good use. You could have a flag like DM_MAP_MPATH_WWID, which
> > would
> > verify that the device had a multipath UUID_PREFIX (and possibly
> > force a
> > check for a multipath target type) and then return the wwid without
> > the
> > multipath uuid prefix.
> > 
> > Just a thought.
> 
> Interesting idea. My thinking was that libmp_mapinfo() should only be
> an interface to libdevmapper, and should not interpret the data it
> returns in any way.
> 
> The only exception is the target type. In theory, the function could
> just have returned the target type, and left the interpretation to the
> caller. But then, it would have to perform several strdup()s for the
> results, and the caller would have to free() the data it wasn't
> interested in, which would lead to clumsy and inefficent code in the
> frequent case that we're just interested in "multipath" or "linear"
> targets. That's why I decided to pass the tgt_type field in, and return
> DMP_NO_MATCH if it didn't match, even though it's arguably odd in the
> mapinfo_t structure, which is otherwise only used for output fields.

I did wonder if it would make more sense to just pass a struct to
libmp_mapinfo() that contained all the input data, with the flags and
the identifiers (tgt_type just being an additional optional identier)
grouped together.  But I'm fine with the exiting interface so it didn't
seem worth commenting on.
 
> Your flag idea would work, too (an earlier version of this patch set
> used flags to indicate which output fields should be filled in; I
> discarded that because it was duplicated information, and more elegant
> to simply check it the respective output field was non-NULL).
> 
> Instead of tgt_type, we could also pass a "filter" callback function
> with which the caller could determine whether or not it was interested
> in a given map. But I wonder if that'd be over-engineered.
> 
> Whatever we eventually do, I think the is_mpath_uuid() helper will be
> useful. I am not sure whether we can unexport it even if we implement
> more sophisticated "filtering" in libmp_mapinfo().
> 
> In general, I wonder what multipath-tools should do if it encounters a
> map that has "multipath" target type, but the WWID of which doesn't
> conform to the mpath-XYZ convention, or vice versa. This can only
> happen if another tool like dmsetup had been used to create the map.
> IMO, if multipathd encounters such a situation, it should warn about it
> and keep its fingers off the map in question. But we might also play it
> simple and just assume that multipath maps always adhere to our
> convention. I don't think we currently behave consistently in this
> respect.

There was a time when there were users of the kernel multipath target
outside of the multipath-tools. To deal with them, the idea was that
multipathd would only manage devices that had a uuid with UUID_PREFIX.
That was a while ago, and we likely have been violating that condition,
but I haven't heard of any complaints. It might be worth auditing the
code to see if/where we aren't verifying new devices.

Obviously if we find a dm device that isn't a multipath target, we
shouldn't do anything with it, regardless of its UUID.
 
> AFAIU, both the WWID and the target type are immutable and can't be
> altered without destroying the map completely (because "multipath" is
> an "immutable target" in DM). Thus it should be sufficient to check the
> WWID when a map is first encountered.

Probably. Obviously, a multipath device could get removed outside of
multipathd and another device added with the same identifier that we're
using. There would be a window before we got the remove event where we
would be looking at the wrong device. But I can't really come up with
a way for this to happen that doesn't involve very creative stupidity on
the user's part, and since you need to be root to do this, I don't see
any security issues here.

This isn't exactly what you're asking about but the results are worse,
and I don't think there is a way to guarantee the following can't happen:

1. multipathd decides in needs to reload a multipath device that is not in
use and grabs the vecs lock so no events will get processed
2. user removes that device outside of multipathd (and likely outside of
multipath which should delegate the remove).
3. user creates a new multipath device outside of mulitpathd that has the
same name as the removed device. For this to happen by running multipath,
they either needed to be using user_friendly_names and haved removed the old
mapping from the bindings file, or they need to have editted multipath.conf
to set the alias of the new device to the alias of the old one.
4. multipathd reloads the table of the new device to point to old paths
5. user writes data to these old paths
6. multipathd gets the event and removes the device.

This results in data corruption, and there's no guarantee that
rechecking anything will always catch this. At some point we need to
just say "Sorry. You shot yourself in the foot."

But if we are just grabbing information about a device we already know
about, and it has switched so that its no longer a multipath device,
then multipathd can't really mess with it. All of our ioctls will fail,
and we will shortly clean it up anyway.

It's possible that we want to be more careful validating the WWID of
devices that we are looking up by major:minor, since it's much more
likely that a device got removed and a completey different dm device got
created and reused the same minor number, but I don't know why we would
ever be looking up a device we already know about by major:minor. So we
should always be checking these devices to verify that they are
multipath devices, and we currently are. 

> Thoughts?
> 
> Martin
> 
> > -Ben
> > 
> > > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > > ---
> > >  libmultipath/devmapper.c          | 13 +++++++++----
> > >  libmultipath/devmapper.h          |  2 ++
> > >  libmultipath/libmultipath.version |  1 +
> > >  3 files changed, 12 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> > > index 806ffb8..5f6c0c8 100644
> > > --- a/libmultipath/devmapper.c
> > > +++ b/libmultipath/devmapper.c
> > > @@ -829,6 +829,11 @@ int dm_get_map(const char *name, unsigned long
> > > long *size, char **outparams)
> > >  	}
> > >  }
> > >  
> > > +bool is_mpath_uuid(const char uuid[DM_UUID_LEN])
> > > +{
> > > +	return !strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN);
> > > +}
> > > +
> > >  /**
> > >   * dm_get_wwid(): return WWID for a multipath map
> > >   * @returns:
> > > @@ -845,7 +850,7 @@ int dm_get_wwid(const char *name, char *uuid,
> > > int uuid_len)
> > >  	if (rc != DMP_OK)
> > >  		return rc;
> > >  
> > > -	if (!strncmp(tmp, UUID_PREFIX, UUID_PREFIX_LEN))
> > > +	if (is_mpath_uuid(tmp))
> > >  		strlcpy(uuid, tmp + UUID_PREFIX_LEN, uuid_len);
> > >  	else {
> > >  		uuid[0] = '\0';
> > > @@ -970,7 +975,7 @@ int dm_is_mpath(const char *name)
> > >  			       (mapid_t) { .str = name },
> > >  			       (mapinfo_t) { .uuid = uuid,
> > > .tgt_type = TGT_MPATH });
> > >  
> > > -	if (rc != DMP_OK || strncmp(uuid, UUID_PREFIX,
> > > UUID_PREFIX_LEN))
> > > +	if (rc != DMP_OK || !is_mpath_uuid(uuid))
> > >  		return DM_IS_MPATH_NO;
> > >  	else
> > >  		return DM_IS_MPATH_YES;
> > > @@ -1065,7 +1070,7 @@ int _dm_flush_map (const char *mapname, int
> > > flags, int retries)
> > >  				  .uuid = uuid,
> > >  				  .tgt_type = TGT_MPATH,
> > >  				  .target = &params }) != DMP_OK
> > > -	    || strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN))
> > > +	    || !is_mpath_uuid(uuid))
> > >  		return DM_FLUSH_OK; /* nothing to do */
> > >  
> > >  	/* if the device currently has no partitions, do not
> > > @@ -1309,7 +1314,7 @@ struct multipath *dm_get_multipath(const char
> > > *name)
> > >  			  }) != DMP_OK)
> > >  		return NULL;
> > >  
> > > -	if (strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN))
> > > +	if (!is_mpath_uuid(uuid))
> > >  		return NULL;
> > >  
> > >  	strlcpy(mpp->wwid, uuid + UUID_PREFIX_LEN, sizeof(mpp-
> > > >wwid));
> > > diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
> > > index db5c5fd..a2b2837 100644
> > > --- a/libmultipath/devmapper.h
> > > +++ b/libmultipath/devmapper.h
> > > @@ -131,6 +131,8 @@ enum {
> > >  	DM_IS_MPATH_YES,
> > >  	DM_IS_MPATH_ERR,
> > >  };
> > > +
> > > +bool is_mpath_uuid(const char uuid[DM_UUID_LEN]);
> > >  int dm_is_mpath(const char *name);
> > >  
> > >  enum {
> > > diff --git a/libmultipath/libmultipath.version
> > > b/libmultipath/libmultipath.version
> > > index 7d3ff63..5b8f9e0 100644
> > > --- a/libmultipath/libmultipath.version
> > > +++ b/libmultipath/libmultipath.version
> > > @@ -127,6 +127,7 @@ global:
> > >  	init_foreign;
> > >  	init_prio;
> > >  	io_err_stat_handle_pathfail;
> > > +	is_mpath_uuid;
> > >  	is_path_valid;
> > >  	libmp_dm_task_create;
> > >  	libmp_get_version;
> > > -- 
> > > 2.45.2
> > 


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9B6155C94
	for <dm-devel@lists.linux.dev>; Mon, 18 Nov 2024 21:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731964991; cv=none; b=bAMULO8WMu8i0b4tW1Ehmk3NACebKpS9+9v3sLMUL4o/NqQiJJb84WOuCnlNsWkBts+bCv842+tB3em/U947ige0MTTMPSpH3/mM1WVvU+8F2e/nWxA/KP9nprIuCLAY02LuTMU4SYbrilyjf9Z8Z6GRpGrKMxjfyjsh26+J5OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731964991; c=relaxed/simple;
	bh=VkVj8e71a68J4/eVNd6Nt3ptpOakuRtWaMFWhecqOoY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=qsoSHryYlk2wK7HpviMBHJFY6gBM455qaHa4/kdPuhIGkejhmYSMk6turqgViPTS37x1K6x3dbH/p3zL/aLfQ9BKxgq6ez/GwG5T6H1yv/VzwK2aQG11ElbZG2UCXF1U1gO7QX6/77eZ0Kve5nq3fpF9TmI8+8Sm8gUJhB8A0aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KLnABM6Z; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KLnABM6Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731964988;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tjTl8KhzeNepaG5cD6ajRE2XkutnnCrG78EajGI0m0o=;
	b=KLnABM6Z4mpeiLCid1MxWtvGrhn2Umue4BH3yeOYN+sMWTr3vaRrEY+b/M3JIkXiOovfdL
	V6EMcG039RKNQL5LDCu2U9+FG1OQLPwTJkaqOXRyLmHxFcQoJPk6a9dgUegy6QQF1XD6L9
	NAGIP5Z6Hc0/jUZS/PQJA42w1qFUZZ8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-689-J-VVLNoKN-q3lqgZBtCtEA-1; Mon,
 18 Nov 2024 16:23:05 -0500
X-MC-Unique: J-VVLNoKN-q3lqgZBtCtEA-1
X-Mimecast-MFC-AGG-ID: J-VVLNoKN-q3lqgZBtCtEA
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 400D519560A1;
	Mon, 18 Nov 2024 21:23:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CF3A8195DF81;
	Mon, 18 Nov 2024 21:23:03 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4AILN2H5667952
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 18 Nov 2024 16:23:02 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4AILN2Td667951;
	Mon, 18 Nov 2024 16:23:02 -0500
Date: Mon, 18 Nov 2024 16:23:02 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 3/6] libmultipath: fix removing device after failed
 creation
Message-ID: <ZzuwNrL0o4Slfu-v@redhat.com>
References: <20241115232256.627933-1-bmarzins@redhat.com>
 <20241115232256.627933-4-bmarzins@redhat.com>
 <74d9cd1eb2dc39dfa5e365791ba000b480c73a09.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <74d9cd1eb2dc39dfa5e365791ba000b480c73a09.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gdhMsDKaTswMIpGBtnrqfVbHyYvhaeCtkYrFD1OPBfY_1731964984
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Nov 18, 2024 at 12:21:01PM +0100, Martin Wilck wrote:
> On Fri, 2024-11-15 at 18:22 -0500, Benjamin Marzinski wrote:
> > dm_flush_nap_nosync() only removes a device if it has a multipath
> > table.
> > On failed removes, there is no table, so this function does nothing.
> > Instead, if libmp_mapinfo() returns DMP_EMPTY, then there is an empty
> > map,
> > and it is removed using dm_device_remove().
> > 
> > Also, since there are no longer any callers of dm_flush_map_nosync(),
> > remove it.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/devmapper.c | 7 +++++--
> >  libmultipath/devmapper.h | 1 -
> >  2 files changed, 5 insertions(+), 3 deletions(-)
> > 
> > diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> > index b718dccf..842e7c80 100644
> > --- a/libmultipath/devmapper.c
> > +++ b/libmultipath/devmapper.c
> > @@ -557,9 +557,12 @@ int dm_addmap_create (struct multipath *mpp,
> > char * params)
> >  		 * Failing the second part leaves an empty map.
> > Clean it up.
> >  		 */
> >  		err = errno;
> > -		if (dm_map_present(mpp->alias)) {
> > +		if (libmp_mapinfo(DM_MAP_BY_NAME |
> > MAPINFO_MPATH_ONLY |
> > +				  MAPINFO_CHECK_UUID,
> > +				(mapid_t) { .str = mpp->alias },
> > +				(mapinfo_t) { .uuid = NULL }) ==
> > DMP_EMPTY) {
> >  			condlog(3, "%s: failed to load map (a path
> > might be in use)", mpp->alias);
> 
> This error message seems wrong for emtpy tables.

This code exists because if you fail to fully create a DM device, you
are (or were, I'm not sure if this issue still exists) sometimes left
with an empty device that needs cleaning up. Previously multipath would
just delete any device that existed with the name of the device you were
trying to create. The new code only deletes empty devices, to avoid
accidentally deleting a valid device that got set up at the same time as
you were doing the create. But these empty devices should only exist if
you failed to load the table for the new device, perhaps because a path
was in use.

So the message still makes sense here, as much as it ever did.

-Ben

> 
> Martin
> 


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228F019DF9A
	for <dm-devel@lists.linux.dev>; Tue, 16 Jul 2024 15:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721142947; cv=none; b=N/0jRzfUs7PMTGZIPGnYCV+bDaKzZBRi78yapv9GcJ9Cs8GaZs6Jx2q+qPWw+DTBv4e/0FfsRy51SC6JHxdHRbwVjGM/iCu2Mr48xsLfB3xfReq3CLhpk/ZsItrqcbw4MTddvkiMRVd3LZgYe6gIohjpqQySZlI1AW/9T+r0mUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721142947; c=relaxed/simple;
	bh=g/uFm0AIf7ehfxhsyHvbAwZ5vrkb7Kbn166VkXaMIug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=FmmkS6jaMrPsOQVoaT8jEfileN0L6xH1oVIHxXRYZwuv86HzWBNT3rmau0Td5a8a876z+pbJ1K3pgcKVID4RE0ubpYucoIlFi9a6U3GSUIx0Zhfn1U/xBTINrRcajt2Ui7M3KluPlfms2p9X3hK+ps+u5vNW13AKdwoZr3whIFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q8OAjyO1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q8OAjyO1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721142945;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jVB+YE0fk0leypDXKva6LId/kLZutJu01jNVUjbppmo=;
	b=Q8OAjyO11kLdbgj3/F1jcJ+x+bjGtV32a+dGHfVsoH8zX5vEIWosVxTH6MYwQ/sVp60low
	yDhF64mo9djRNGjnMMoJ4xWH8VqkKQrXBNEA4fXR+NmbN71TBQwY6bTa5RAGP67xK+Ou80
	bmMRkGBvoXCUELcjRy/6BGMPQ9gVBc0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-518-_MiIsrzpMrGN_JB78ZpXxA-1; Tue,
 16 Jul 2024 11:15:41 -0400
X-MC-Unique: _MiIsrzpMrGN_JB78ZpXxA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AA92519560AB;
	Tue, 16 Jul 2024 15:15:40 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5F15D300018F;
	Tue, 16 Jul 2024 15:15:40 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46GFFcvP2121807
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 16 Jul 2024 11:15:38 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46GFFccN2121806;
	Tue, 16 Jul 2024 11:15:38 -0400
Date: Tue, 16 Jul 2024 11:15:38 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 13/22] multipathd: resync map after setup_map in
 ev_remove_path
Message-ID: <ZpaOmhu2y-AoEZHB@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
 <20240713060506.2015463-14-bmarzins@redhat.com>
 <5b52909bfeca226b6713f0be1730a1f7026a67ad.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <5b52909bfeca226b6713f0be1730a1f7026a67ad.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Jul 15, 2024 at 06:32:22PM +0200, Martin Wilck wrote:
> On Sat, 2024-07-13 at 02:04 -0400, Benjamin Marzinski wrote:
> > In ev_remove_path() it was possible to exit after calling setup_map()
> > without resyncing the mpp state with the kernel. This meant that the
> > mpp state in multipathd might not match with the kernel state at all.
> > 
> > It's safe to exit before calling setup_map() if either wait_for_udev
> > or need_do_map is set. In both cases, setup_map() will later be
> > called,
> > either by a uevent or by the calling function.
> > 
> > Once setup_map() has been called, setup_multipath() and
> > sync_map_state()
> > are now always called, to make sure the mpp matches the kernel state.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  multipathd/main.c | 40 +++++++++++++++++++---------------------
> >  1 file changed, 19 insertions(+), 21 deletions(-)
> > 
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index 179fec24..3c84c2a0 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -1395,6 +1395,8 @@ ev_remove_path (struct path *pp, struct vectors
> > * vecs, int need_do_map)
> >  	 * avoid referring to the map of an orphaned path
> >  	 */
> >  	if ((mpp = pp->mpp)) {
> > +		char devt[BLK_DEV_SIZE];
> > +
> >  		/*
> >  		 * Mark the path as removed. In case of success, we
> >  		 * will delete it for good. Otherwise, it will be
> > deleted
> > @@ -1428,12 +1430,6 @@ ev_remove_path (struct path *pp, struct
> > vectors * vecs, int need_do_map)
> >  		    flush_map_nopaths(mpp, vecs))
> >  			goto out;
> >  
> > -		if (setup_map(mpp, &params, vecs)) {
> > -			condlog(0, "%s: failed to setup map for"
> > -				" removal of path %s", mpp->alias,
> > pp->dev);
> > -			goto fail;
> > -		}
> > -
> >  		if (mpp->wait_for_udev) {
> >  			mpp->wait_for_udev = 2;
> >  			retval = REMOVE_PATH_DELAY;
> > @@ -1444,33 +1440,35 @@ ev_remove_path (struct path *pp, struct
> > vectors * vecs, int need_do_map)
> >  			retval = REMOVE_PATH_DELAY;
> >  			goto out;
> >  		}
> > +
> > +		if (setup_map(mpp, &params, vecs)) {
> > +			condlog(0, "%s: failed to setup map for"
> > +				" removal of path %s", mpp->alias,
> > pp->dev);
> > +			goto fail;
> > +		}
> >  		/*
> >  		 * reload the map
> >  		 */
> >  		mpp->action = ACT_RELOAD;
> > +		strlcpy(devt, pp->dev_t, sizeof(devt));
> 
> Move this statement further down, directly before the call to
> setup_multipath(), perhaps? It's only for the condlog anyway.
> 

Sure.

> Except for that, LGTM.
> 
> Martin
> 
> 
> >  		if (domap(mpp, params, 1) == DOMAP_FAIL) {
> >  			condlog(0, "%s: failed in domap for "
> >  				"removal of path %s",
> >  				mpp->alias, pp->dev);
> >  			retval = REMOVE_PATH_FAILURE;
> > -		} else {
> > -			/*
> > -			 * update our state from kernel
> > -			 */
> > -			char devt[BLK_DEV_SIZE];
> > -
> > -			strlcpy(devt, pp->dev_t, sizeof(devt));
> > -
> > -			/* setup_multipath will free the path
> > -			 * regardless of whether it succeeds or
> > -			 * fails */
> > -			if (setup_multipath(vecs, mpp))
> > -				return REMOVE_PATH_MAP_ERROR;
> > -			sync_map_state(mpp);
> > +		}
> > +		/*
> > +		 * update mpp state from kernel even if domap
> > failed.
> > +		 * If the path was removed from the mpp,
> > setup_multipath will
> > +		 * free the path regardless of whether it succeeds
> > or fails
> > +		 */
> > +		if (setup_multipath(vecs, mpp))
> > +			return REMOVE_PATH_MAP_ERROR;
> > +		sync_map_state(mpp);
> >  
> > +		if (retval == REMOVE_PATH_SUCCESS)
> >  			condlog(2, "%s: path removed from map %s",
> >  				devt, mpp->alias);
> > -		}
> >  	} else {
> >  		/* mpp == NULL */
> >  		if ((i = find_slot(vecs->pathvec, (void *)pp)) != -
> > 1)


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C94A165FBB
	for <dm-devel@lists.linux.dev>; Wed, 24 Apr 2024 22:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713996924; cv=none; b=cROcojnT9Ihv+qDrSIGc9gX0Dz3ZJCIBP6zn9iTaglaMmQpqK2ROx7WPqzJrVrhbIxIa0+aYkX9OlAuoLHQ+1DtHtsbpU//tcr+1wUNYXtZADfq+cU8VWwRHefqfMhw/b7StPgangH/Tu6IGnJ8kgbeZiuJr5MyVc5F47RZwN6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713996924; c=relaxed/simple;
	bh=xpaqfNcvp4nNc4sXJYRKvT7befw6kIjdeYd49dZHndM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=njx446A1ZKpF+yecRFJ92PHRYSm8RAupY+Nbei8ru08KDuoEqVGqvRdOpo84ZgS6Q4LuP6rNZrB1q1bNwMDvel045FCqNyTiO8HGEvREdYrjMRCUZ6J4d23yn8steINmpBZKTlZ6GXm/dQcmKeBFlf9P1YD0nAfE8Cjj3pnePtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FSgeMTNz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FSgeMTNz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713996921;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eIS0mJfkKfRPB+EDf83ZdN2BdUArDa7KwE/moC2l8P8=;
	b=FSgeMTNz/j6/oEVbo45YzF/dZOgbIPahRwvPDEurqywtPi0iYVSzSN83ixecFKycV4TLKv
	jx7ad2rD/raOdcJx8DpEzLsNnd12MqqgAey+apYiIO3q8qpHUELX/gOFzKgwQi45lrmKV8
	vncLoE5z2bSd005fl5fHkwd7XnJJTmE=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-45-rxgIhF5vO8-t6K7C53nn4A-1; Wed,
 24 Apr 2024 18:15:17 -0400
X-MC-Unique: rxgIhF5vO8-t6K7C53nn4A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B6BA29AC029;
	Wed, 24 Apr 2024 22:15:17 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 73340C13FA3;
	Wed, 24 Apr 2024 22:15:17 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 43OMFHMg2109532
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 18:15:17 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 43OMFGTD2109531;
	Wed, 24 Apr 2024 18:15:16 -0400
Date: Wed, 24 Apr 2024 18:15:16 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 2/3] libmultipath: change flush_on_last_del to fix a
 multipathd hang
Message-ID: <ZimEdFQgfNfFSHOU@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240423222536.2096486-1-bmarzins@redhat.com>
 <20240423222536.2096486-3-bmarzins@redhat.com>
 <439b76a2cdc7d044d2588315663bcca3a21063e2.camel@suse.com>
 <ZilunDUSAH8jnBNT@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ZilunDUSAH8jnBNT@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Apr 24, 2024 at 04:42:04PM -0400, Benjamin Marzinski wrote:
> On Wed, Apr 24, 2024 at 06:34:35PM +0200, Martin Wilck wrote:
> > On Tue, 2024-04-23 at 18:25 -0400, Benjamin Marzinski wrote:

<snip>

> > > +
> > > +	/* It's not safe to do a non-deferred remove of a map that
> > > has
> > > +	 * "queue_if_no_path" set, since there could be outstanding
> > > IO which
> > > +	 * will cause multipathd to hang while attempting the remove
> > > */
> > > +	if (mpp->flush_on_last_del == FLUSH_NEVER &&
> > > +	    !do_deferred(deferred_remove) && is_queueing) {
> > > +		condlog(2, "%s: map is queueing, can't remove", mpp-
> > > >alias);
> > > +		return false;
> > > +	}
> > 
> > Just a thought: Why don't we just pretend that deferred_remove is on if
> > flush_on_last_del is set to "never"? Wouldn't that avoid our issues?
> > In the same context, why haven't we made deferred_remove the default
> > yet?
> 
> I'm not sure we want to change the default multipath behavior without a
> good reason.  Users don't expect that removing a multipath device can
> succeed, but the device will still be there.
> 
> Worse, I just tested and found out that my test will still hang
> multipathd with my new code if you have deferred_remove turned on.  This
> is because there is no opener of the kpartx device, so device-mapper
> tries to immediately remove it. Apparently, it's also not safe to
> trigger a deferred remove without disabling queueing.

Thinking about this a bit more, this actually makes deferred_remove a
lot less useful. For devices with no_path_retry set to something other
than fail, deferred_remove now only makes sense when paired with:

flush_on_last_del "always"

That will fail the IO of whatever has the multipath device open so it
can close the device, at which point the deferred remove will happen. So
it's not useless, but it won't make sure that currently queueing devices
eventually get closed.

If we really wanted to keep that behavior, when we disable queueing on a
device, we could check if there are no path devices and do the deffered
remove then. Like I mentioned in my last email, we could even attempt
non-deferred removes then. But unless a lot more people than I expect
are using deferred_remove and complain about it working worse, it's
probably best to just make it safe and less useful. 
 
> > > +	if (mpp->flush_on_last_del == FLUSH_UNUSED &&
> > > +	    !do_deferred(deferred_remove) &&
> > > +            (in_use = partmap_in_use(mpp->alias, NULL)) &&
> > > is_queueing) {
> > > +		condlog(2, "%s: map in use and queueing, can't
> > > remove",
> > > +			mpp->alias);
> > > +		return false;
> > > +	}
> > 
> > Same reasoning as above, why not just defer?
> > 
> > >  	/*
> > > -	 * flush_map will fail if the device is open
> > > +	 * This will flush FLUSH_NEVER devices and FLUSH_UNUSED
> > > devices
> > > +	 * that are in use, but only if this is not a deferred
> > > remove, and
> > 
> > "that are not in use" ?
> 
> This *will* disable queue_if_no_path on in-use devices. But like I said,
> only if, according to mulitpathd, the device is already set to
> queue_if_no_path.  This is just to make sure the mpp->features isn't out
> of date, since getting this wrong and hanging multipathd is a bad thing.
> Alternatively, I could call update_multipath_table() to make sure
> mpp->features is up to date. This way does less work, and if multipathd
> thinks that the device shouldn't be queueing, then it really shouldn't
> be queueing.

Oh, I see. My comment was correct, but my code wasn't.
 
> > > +	 * they are already marked as not queueing. That is just to
> > > make
> > > +	 * absolutely certain that they really are not queueing like
> > > they
> > > +	 * claim.
> > >  	 */
> > > -	if (mpp->flush_on_last_del == FLUSH_ENABLED) {
> > > -		condlog(2, "%s Last path deleted, disabling
> > > queueing",
> > > +	if (mpp->flush_on_last_del == FLUSH_ALWAYS ||
> > > +	    !do_deferred(deferred_remove) || !in_use) {
> > > +		condlog(is_queueing ? 2 : 3,
> > > +			"%s Last path deleted, disabling queueing",
> > >  			mpp->alias);
> > >  		mpp->retry_tick = 0;
> > >  		mpp->no_path_retry = NO_PATH_RETRY_FAIL;
> > > @@ -597,7 +627,7 @@ flush_map_nopaths(struct multipath *mpp, struct
> > > vectors *vecs) {
> > >  		mpp->stat_map_failures++;
> > >  		dm_queue_if_no_path(mpp, 0);
> > >  	}
> > > -	r = dm_flush_map_nopaths(mpp->alias, mpp->deferred_remove);
> > > +	r = dm_flush_map_nopaths(mpp->alias, deferred_remove);
> > 
> > AFAIU, this line should only be executed if either disabling queueing
> > above succeeded, or do_deferred(deferred_remove) is true.
> > This code doesn't guarantee that, or am I overlooking something?
> 
> Oops. Good catch.
>  
> > Regards,
> > Martin
> > 
> > 
> > >  	if (r != DM_FLUSH_OK) {
> > >  		if (r == DM_FLUSH_DEFERRED) {
> > >  			condlog(2, "%s: devmap deferred remove",
> > > mpp->alias);
> 


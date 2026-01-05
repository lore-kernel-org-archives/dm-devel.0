Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7383FFD
	for <dm-devel@lists.linux.dev>; Mon,  5 Jan 2026 23:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767655082; cv=none; b=opY9yo1TRVcuKufOK22AZUG7e87BNRs6YDEdlOdAQF3rKvnmpPwR3zwb61GAdIz5cV1fhOREjSr5I+Q15wEITC9ubnSlE3xuW8RBOVr8HHvDt5w25dKG0QhStxG+U9Nhg4vAqTxVHMrDbgPbRuCxPKwrBaV+N2O6SFOGHI8UyGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767655082; c=relaxed/simple;
	bh=yYv+mIj+piWjnXVrlFSs6Le8+Qrhe9/CNs3QOIVf98U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=t/s6aDY4AQYKz9AvmU5SMrprUjgTOACi1zU0z4fMd8B80e762nm3pGUHQkggxtOqQIdoZpr1YKs2ZlMSYPsJkhcVIPQ+c6y8er952FU1XxUyzClZkfXTiRgGeYcxaPhb9Tmvyxs3d+Tbq82qS2GWXM7rNG9CTpNnardWq7oWo6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F51Mkh1W; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F51Mkh1W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767655079;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SuNu3T3IO+4MwMKOVTkrT8f10yUKtq8PfxBXXStCFRg=;
	b=F51Mkh1WM+Iz+JinulGYFtuIGkxdozS/M1/+cMdgM9P/BqMIEOEDJWq/a3WEpiv8Uf56BM
	2Rl/RfP1dQh+MeFX3jYYAXXf01tODo08giYc2Og3XWOyDyVO8kQik0ht4hlrodTJKkVVip
	7uofNNotTzHCBQi+7jR38rd/siATQw4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-348-AoJps_0jO8ODZYcR_Logrw-1; Mon,
 05 Jan 2026 18:17:56 -0500
X-MC-Unique: AoJps_0jO8ODZYcR_Logrw-1
X-Mimecast-MFC-AGG-ID: AoJps_0jO8ODZYcR_Logrw_1767655075
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 00D9918002E4;
	Mon,  5 Jan 2026 23:17:55 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7FEF319560AB;
	Mon,  5 Jan 2026 23:17:54 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 605NHr8r2894517
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 5 Jan 2026 18:17:53 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 605NHrU22894516;
	Mon, 5 Jan 2026 18:17:53 -0500
Date: Mon, 5 Jan 2026 18:17:53 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Benjamin Marzinski <bmarzins@suse.com>
Subject: Re: [PATCH v2 14/26] multipathd: add_map_without_path(): orphan
 paths instead of freeing them
Message-ID: <aVxGoTt8zHbnmGXI@redhat.com>
References: <20251219144108.237928-1-mwilck@suse.com>
 <20251219144108.237928-15-mwilck@suse.com>
 <aUYkuzmyuntUhEvk@redhat.com>
 <f74331bcf74067f85a8836e014d322eccf2995ed.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <f74331bcf74067f85a8836e014d322eccf2995ed.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lGLvS_py_78vOrz6rDPJ6X0oAIEvKjSgT6HlAeuVrls_1767655075
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Jan 05, 2026 at 04:15:37PM +0100, Martin Wilck wrote:
> On Fri, 2025-12-19 at 23:23 -0500, Benjamin Marzinski wrote:
> > On Fri, Dec 19, 2025 at 03:40:56PM +0100, Martin Wilck wrote:
> > > If add_map_without_path() fails to set up the multipath data
> > > structures,
> > > don't free the paths associated with the map as
> > > cleanup_multipath_and_paths() would; just orphan the paths.
> > > update_pathvec_from_dm() will handle the paths and see if they
> > > need to be removed.
> > > 
> > > Suggested-by: Benjamin Marzinski <bmarzins@suse.com>
> > > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > > ---
> > >  multipathd/main.c | 12 +++++++-----
> > >  1 file changed, 7 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/multipathd/main.c b/multipathd/main.c
> > > index c03546b..7b522e8 100644
> > > --- a/multipathd/main.c
> > > +++ b/multipathd/main.c
> > > @@ -771,8 +771,8 @@ fail:
> > >  
> > >  static int add_map_without_path (struct vectors *vecs, const char
> > > *alias)
> > >  {
> > > -	struct multipath
> > > __attribute__((cleanup(cleanup_multipath_and_paths)))
> > > -		*mpp = alloc_multipath();
> > > +	struct multipath
> > > __attribute__((cleanup(cleanup_multipath))) *mpp =
> > > +		alloc_multipath();
> > >  	char __attribute__((cleanup(cleanup_charp))) *params =
> > > NULL;
> > >  	char __attribute__((cleanup(cleanup_charp))) *status =
> > > NULL;
> > >  	struct config *conf;
> > > @@ -802,11 +802,13 @@ static int add_map_without_path (struct
> > > vectors *vecs, const char *alias)
> > >  	mpp->mpe = find_mpe(conf->mptable, mpp->wwid);
> > >  	put_multipath_config(conf);
> > >  
> > > -	if ((rc = update_multipath_table__(mpp, vecs->pathvec, 0,
> > > params, status)) != DMP_OK)
> > > +	if (update_multipath_table__(mpp, vecs->pathvec, 0,
> > > params, status) != DMP_OK ||
> > > +	    !vector_alloc_slot(vecs->mpvec)) {
> > > +		orphan_paths(vecs->pathvec, mpp, "failed to add
> > > map");
> > >  		return DMP_ERR;
> > 
> > I'm not sure we should just call orphan_paths() after we call
> > update_multipath_table__(). If we hit a cancellation point in the
> > middle
> > of update_multipath_table__(), we want to fully orphan any paths that
> > got added to the device before we cancelled.  
> 
> Sorry, I don't understand.
> 
> The __attribute__((cleanup())) functions don't protect against thread
> cancellation. If we want to achieve what you describe, we must add a
> pthread_cleanup_push()/pop() pair around the update_multipath_table__()
> call.

I'm pretty sure they do run during cancellation after I added ca957f2a
("multipath-tools: Makefile.inc: compile with -fexceptions").
 
> But would that buy us anything? update_multipath_table__() only
> manipulates multipathd's internal data structures, which, if a
> cancellation happens, will almost immediately all be freed anyway. What
> harm would be done if these paths weren't orphaned in such a case? Yes,
> the some paths might now link to a non-existing struct multipath. I'd
> see your point if we accessed pp->mpp in the path-freeing code path,
> but we don't do this any more.

We check whether pp->mpp is set in lots of places in the code to decide
what to do with the paths. But you are correct that we don't ever call
add_map_without_path() from a thread that can be cancelled and have
multipathd continue running, and we aren't likely to do so.

> > Perhaps the easiest way to
> > solve this is to make cleanup_multipath_and_paths() loop through all
> > the
> > path in mpp->pg and orphan them before calling free_multipath().
> 
> Like I said above, that would have no effect in the case of
> cancellation.
> 
> I can add pthread_cleanup_push()/pop() pair if you insist, but so far I
> don't see the benefit.

Sure. I drop my objection.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> Regards
> Martin


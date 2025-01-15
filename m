Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCCF33DB
	for <dm-devel@lists.linux.dev>; Wed, 15 Jan 2025 16:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736959547; cv=none; b=uuANEFDcAdWXsPTb8XhZGR18HUCewWNW22vXZ5hGhTtxPsFfxSdESRmece98eLCuBYla2yR+f4XtWr+SDaWe7ahPxREoSQNBm2KoUPhEXCvXrOH1BfMatz0NOpUpsxgm/H3XxSBp985zSsLIPIUFeMBDsbaTN0s5DQKHBOB/VV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736959547; c=relaxed/simple;
	bh=jKYyhLaS5XHYqBlNZx8mQ7ayouhxgF1ksm8Dky7milc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=PdHRLdlMLYvuVIe5Td+KNdHFEljUTihzamgoptI5Wh/paNaYkWGixKgNIISW7lvWxukAKFzBYs9+pE7LrD24mQuDoTPohq+AaBArXH6MdMl9zXEi4+y1fhVToMI/gOvxpAO5URYXx9aCLU7UTowKAbZNlWfsOXaq6/qp6sc3lfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fcpotMpj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fcpotMpj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736959544;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YEWRBrQAtYlXkK8kaUkLugzkqfluOSj4tvOiL1jOwuk=;
	b=fcpotMpjz/upYZALpnqrREYejFrhfdPpMGEBmjLTI2nVsjAYtd5zf/OCCGrrsBU0ZQA0r8
	s5ZV++0DUoIAmV1hKrLEVi5BcCjvvoQKFM0dpnDijI1f5ccsfJHKdSj+krIGfXV6zGaucr
	JA4fJwre26R0e4CjKOtFnuhMGI1G1Ps=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-85-17NII2gNMCqlhpkbHUJFnQ-1; Wed,
 15 Jan 2025 11:45:39 -0500
X-MC-Unique: 17NII2gNMCqlhpkbHUJFnQ-1
X-Mimecast-MFC-AGG-ID: 17NII2gNMCqlhpkbHUJFnQ
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4DF6E195605F;
	Wed, 15 Jan 2025 16:45:38 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DE7CB195608A;
	Wed, 15 Jan 2025 16:45:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 50FGja3A2712846
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 11:45:36 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 50FGjZM82712845;
	Wed, 15 Jan 2025 11:45:35 -0500
Date: Wed, 15 Jan 2025 11:45:35 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH v2 03/14] multipathd: sync maps at end of checkerloop
Message-ID: <Z4fmL_jRQg8C-xFA@redhat.com>
References: <20241211225909.298770-1-mwilck@suse.com>
 <20241211225909.298770-4-mwilck@suse.com>
 <Z2Smet8-Smj8Oyj_@redhat.com>
 <5ae128660980dcc037e97a607668498408958638.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <5ae128660980dcc037e97a607668498408958638.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DVHFHTRtIUT1qqSiL0figgGaouzsqi9SsbxYxBpHbQY_1736959538
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Jan 14, 2025 at 10:36:06PM +0100, Martin Wilck wrote:
> On Thu, 2024-12-19 at 18:04 -0500, Benjamin Marzinski wrote:
> > On Wed, Dec 11, 2024 at 11:58:58PM +0100, Martin Wilck wrote:
> > > @@ -3032,11 +3026,13 @@ checkerloop (void *ap)
> > >  							    
> > > start_time.tv_sec);
> > >  			if (checker_state == CHECKER_FINISHED) {
> > >  				vector_foreach_slot(vecs->mpvec,
> > > mpp, i) {
> > > -					if ((update_mpp_prio(mpp)
> > > ||
> > > -					     (mpp->need_reload &&
> > > mpp->synced_count > 0)) &&
> > 
> > When you call reload_and_sync_map(), it will automatically resync the
> > map via setup_multipath() -> refresh_multipath() ->
> > update_multipath_strings().
> > 
> > This means that if for some reason multipathd and the kernel disagree
> > about a map, and reloading it doesn't fix the problem, you will
> > immediately set mpp->need_reload again. With the old mpp-
> > >synced_count
> > check, you only reload maps with need_reload() when a path is
> > checked.
> > Without this check, or a (mpp->checker_count > 0) check to replace
> > it,
> > you will keep reloading these maps every loop, roughly once a second.
> > I
> > would rather not do this.
> > 
> > If you want to make sure to immediately handle a need_reload that
> > wasn't
> > triggered by this call to reload_and_sync_map() which was because of
> > an
> > earlier need_reload, we could make need_reload have three states, to
> > distinguish between a reload we want done immediately, and one we
> > would
> > like to wait on because we just did a reload and it didn't fix the
> > problem. Then we could remember if need_reload was set before calling
> > reload_and_sync_map(), and if it was, and if it is still set after,
> > we
> > could switch it to the delayed version.
> > 
> > Or perhaps I'm just being paranoid here. 
> 
> As you probably know and as I recently verified, reloading the kernel
> from the checker loop will hardly ever fail except with -ENOMEM [1]. We
> can pass non-existing or failed devices to the kernel, it will happily
> accept them.
> 
> update_pathvec_from_dm() never adds any devices to the map, it just
> removes some. If need_reload is set, it means that it has removed
> either a path or an entire pathgroup. When the map is reloaded, it will
> only reference (a subset of) the devices that were already mapped. I
> see no way how this could fail unless either multipathd or the kernel
> are really badly malfunctioning, in which case we don't need to bother
> about reloading too frequently.
> 
> But *if* the reload succeeds, the set of devices in the kernel is
> guaranteed to be identical to the table that we've just used for
> reloading. So only way that another difference between kernel and
> multipath state could occur between the reload and
> update_pathvec_from_dm() running again is that another device has just
> diappeared from the system, in which case a quick reload would be a
> reasonable action. (Well I guess another possibility would be a 3rd
> party maliciously adding wrong path devices to the maps we maintain,
> but that's not something we can do much about).
> 
> If need_reload is indeed set again in this situation, I would indeed
> prefer to double-check this map quickly. As argued above, I strongly
> believe that such a situation will not persist. IMO a detected
> inconsistency between the kernel and multipathd is a very bad thing
> that we should try to fix rather sooner than later. It's at least as
> bad as a failed path, which we'll check every second, too.
> 
> Bottom line: I think re-checking this quickly is actually the right
> thing to do. Would you accept this if I add a warning in the
> "inconsistent" case, so that in the event that we actually run into a
> persistent discrepancy situation, we will notice?
> 

Sure. This is probably just my paranoia here, since I can't actually
come up with a concrete case where there would be a persistent
discrepancy. If it ever happens, it's almost definitely a bug in the
multipath code.

-Ben

> Regards,
> Martin
> 
> [1]
> https://lore.kernel.org/dm-devel/ee6fcbda31fd1f13969653782417fbed748f5bc7.camel@suse.com/
> 
> > -Ben
> > 
> > > -					   
> > > reload_and_sync_map(mpp, vecs) == 2)
> > > +					sync_mpp(vecs, mpp,
> > > ticks);
> > > +					if ((update_mpp_prio(mpp)
> > > || mpp->need_reload) &&
> > > +					   
> > > reload_and_sync_map(mpp, vecs) == 2) {
> > >  						/* multipath
> > > device deleted */
> > >  						i--;
> > > +						continue;
> > > +					}
> > >  				}
> > >  			}
> > >  			lock_cleanup_pop(vecs->lock);
> > > -- 
> > > 2.47.0
> > 


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468C92609CC
	for <dm-devel@lists.linux.dev>; Wed, 30 Apr 2025 15:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746026573; cv=none; b=TP+1ndZlOrh8TZqDl4Foh3TBBPHdevkzOPFwPMS5QfD+vszxAViZTlnX1Ju4vZ71ycvxybN+9QUs52TKLzSWgq01v/cgGTUJ7BOxbR7jojUAPpo/R4p1JCWtYqZwgWN25HDXXxXuHlUVBYcLC44fbx2/oFFgC3PjTP8mwcKbrbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746026573; c=relaxed/simple;
	bh=BPVcMl+0XG2TaNjdMLqZWpTQHxWuyt2urxr1JugwvK0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=AUilpzx8Y6y894mLCFw4H5KkgflG/Tbn9p3GRTAoQuVUNJOxBQbpG+yrIThK7USxP8E7LTbqyBEEri8+ylVGyzWqsB3hqsb3XbS5JxcLDWu1U1me2Fg7eajSQsINmxHeAuHUk9U4shDx6sbGBQcrVQX5k7N6D3LBUBHzdfVr66c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hI02F7A6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hI02F7A6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746026570;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ikdbF9jrnKwrug9bwRJi/HsiFB4vdCSfkjDc6jv9Vjw=;
	b=hI02F7A67g21re8+1pbR0LY2nMvAhr1pNa8h9Rxc9WoGCBTAhM31gzsLhzRMKZ9Nay3klF
	hkKUPyTD0s0eLy3YCKclLL8zjEP7YcncCYn4rICzIvceJ9HaK2uhFii8u4/+1/UU5C8QTU
	jYWX4ObjB+8yB+gereAag4dvqCsP00I=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-387-DYeZzsdrPgG6LArHulu8Bw-1; Wed,
 30 Apr 2025 11:22:46 -0400
X-MC-Unique: DYeZzsdrPgG6LArHulu8Bw-1
X-Mimecast-MFC-AGG-ID: DYeZzsdrPgG6LArHulu8Bw_1746026565
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 67AFD1956048;
	Wed, 30 Apr 2025 15:22:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0577319560A3;
	Wed, 30 Apr 2025 15:22:44 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 53UFMhnr1985006
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Apr 2025 11:22:43 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 53UFMh8P1985005;
	Wed, 30 Apr 2025 11:22:43 -0400
Date: Wed, 30 Apr 2025 11:22:43 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>,
        Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: Coding stye (was Re: [PATCH 1/2] libmutipath: handle blacklisted
 paths on map_discovery)
Message-ID: <aBJAQwhaIq2Seaob@redhat.com>
References: <20250428214514.1905327-1-bmarzins@redhat.com>
 <20250428214514.1905327-2-bmarzins@redhat.com>
 <d277b26e716775ef3778aa47c8a96ea24a551de7.camel@suse.com>
 <aBE2IX4re8qXv-GG@redhat.com>
 <00c8651c4f589c56b034e7bbe5eb9d59688a1c78.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <00c8651c4f589c56b034e7bbe5eb9d59688a1c78.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 1
X-Mimecast-MFC-PROC-ID: 2Md0nlkRs4KFdpFckLiPWXuUqq9tPLC_6XvkFgtKmUY_1746026565
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Apr 30, 2025 at 09:55:43AM +0200, Martin Wilck wrote:
> On Tue, 2025-04-29 at 16:27 -0400, Benjamin Marzinski wrote:
> > On Tue, Apr 29, 2025 at 09:59:40PM +0200, Martin Wilck wrote:
> > > On Mon, 2025-04-28 at 17:45 -0400, Benjamin Marzinski wrote:
> > > > If the multipath configuration is changed to blacklist existing
> > > > devices,
> > > > and multipathd is reloaded but the blacklisted multipaths device
> > > > can't
> > > > be removed, multipathd was marking the paths as INIT_PARTIAL,
> > > > causing
> > > > them to stay in the multipath device, at least until the
> > > > partial_retrigger_delay timeout elapsed. Instead, mark them as
> > > > INIT_REMOVED and set mpp->need_reload, so the device is reloaded
> > > > and
> > > > the
> > > > paths are removed. To make sure the blacklisted paths are deleted
> > > > when
> > > > the multipath device is removed in coalesce_maps(), set their pp-
> > > > >mpp
> > > > to point to map before removing it.
> > > > 
> > > > Fixes d9c61332 ("multipathd: trigger uevents for blacklisted
> > > > paths in
> > > > reconfigure")
> > > 
> > > The patch looks good to me, but I only vaguely understand why the
> > > bug
> > > is introduced in d9c61332. Are you positive that before d9c61332,
> > > the
> > > hang didn't occur?
> > 
> > Well, I'm pretty sure these blacklisted paths stopped getting deleted
> > during reconfigure by d9c61332. Before d9c61332, blacklisted paths
> > were
> > immediately deleted in update_pathvec_from_dm().
> 
> Right, thanks.
> 
> I've taken the liberty to fix the typo ("libmutipath") and make some
> minor coding style adjustments in my queue branch. You can inspect the
> result there.
> 
> The coding style stuff is work in progress, I've added a clang-format
> based workflow on my tip branch.
> 
> I'd like to avoid major reformatting of past code while enforcing
> consistent formatting for present and future submissions which is more-
> or-less in line with what we used to do "sub-conciously" during the
> last years. clang-format has a lot of options [1]. I'm still struggling
> to find style settings that match ours [2].
> 
> Let me know if you dislike this, or if you have suggestions for
> improving the settings.

I'm fine with your changes and with using clang-format in general. And I
do prefer just formatting our new changes, like you mentioned in your
tip commit, but if someone wants to make the case for a mass reformat,
I'm willing to consider it. 

-Ben

> 
> Regards
> Martin
> 
> [1] https://clang.llvm.org/docs/ClangFormatStyleOptions.html
> [2] https://github.com/openSUSE/multipath-tools/blob/refs/heads/tip/.clang-format
> 
> >  After this change
> > 
> > @@ -193,7 +196,8 @@ static void update_pathvec_from_dm(vector
> > pathvec, struct multipath *mpp,
> >  		rc = pathinfo(pp, conf,
> >  		             
> > DI_SYSFS|DI_WWID|DI_BLACKLIST|DI_NOFALLBACK|pathinfo_flags);
> >  		pthread_cleanup_pop(1);
> > -		if (rc != PATHINFO_OK) {
> > +		if (rc == PATHINFO_FAILED ||
> > +		    (rc == PATHINFO_SKIPPED && !map_discovery)) {
> >  		        condlog(1, "%s: error %d in pathinfo,
> > discarding path",
> >  		                pp->dev, rc);
> >  		        vector_del_slot(pgp->paths, j--);
> > 
> > they started hanging around, so that uevents could be generated for
> > them
> > by trigger_paths_udev_change(). However, since coalesce_paths() will
> > usually clear pp->mpp, they won't get removed when orphan_paths() is
> > later called by remove_maps() to remove the old maps. I admit I
> > didn't
> > test if the paths got removed before that commit, but the commit
> > message
> > says that they did.
> > 
> > -Ben
> > 
> > > 
> > > > 
> > > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > 
> > > Reviewed-by: Martin Wilck <mwilck@suse.com>


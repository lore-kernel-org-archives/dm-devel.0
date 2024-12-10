Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B7421126A
	for <dm-devel@lists.linux.dev>; Tue, 10 Dec 2024 22:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733870983; cv=none; b=rJ0RLWJAkqMMtnhfdQdkp+I9YzXk8z8KTFc5MSxgo2Tsc+yL3VnIXdiE4AvwNufMGp/6nh16f7HtNNNbpyfEeAtxAuoKZHkuLsahxUT1KOyttufydk+yUsfPq0528Xi9ghAh3mpoxuY6qCtpgeOugylW4cKKU9eUAFWCKS8RY4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733870983; c=relaxed/simple;
	bh=Q2CqeAOUckl9KkP5e/7/8FD6m8mSqUOaDGRjcB3TONo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=Tk9R0C6ut+SsZhXCV73Ek7hKcZx4tMRlWPuIIItNQkIbZmf7p8qqDiq7eHAphZV4RXfqFMiUmRL+zyRLZfLPHAGOjPf6SUoehGdMlBYKBWP/HDkqw/Jgser9nda2WgvEsgpEq06FzK0u2wt0T0jHJsTZvPLmrgAg/bi2PuvUhDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZTk31vtk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZTk31vtk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733870979;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rai+P/RdWH3B2SVb+UuFfGN351VJbUjM8Opp085kTW4=;
	b=ZTk31vtkMnq/ytvNQlc/M5jb7eqgUW2bmT1NVi/9pT6IY7faKsYvmoSDGpDEav0CIsHm2Y
	hYqGF8N5E78KXEJPUehgfTl7XYhMzB6K7dIHMoyp3+7sb3RryCzfyhmwv0WErOjjMib8Sp
	zfBETvIamrld9dKfGjdsh8Qypami4N0=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-643-WA3fa1xtPmaNoYiU8agwZQ-1; Tue,
 10 Dec 2024 17:49:38 -0500
X-MC-Unique: WA3fa1xtPmaNoYiU8agwZQ-1
X-Mimecast-MFC-AGG-ID: WA3fa1xtPmaNoYiU8agwZQ
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 409B3195608E;
	Tue, 10 Dec 2024 22:49:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AF7C619560A2;
	Tue, 10 Dec 2024 22:49:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4BAMnZSS1424601
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 10 Dec 2024 17:49:35 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4BAMnZvo1424600;
	Tue, 10 Dec 2024 17:49:35 -0500
Date: Tue, 10 Dec 2024 17:49:35 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH 03/13] multipathd: allow map removal in do_sync_mpp()
Message-ID: <Z1jFf_1kLqfWAfp-@redhat.com>
References: <20241206233617.382200-1-mwilck@suse.com>
 <20241206233617.382200-4-mwilck@suse.com>
 <Z1iQR-9hszoQOq-W@redhat.com>
 <9c2270f4bd6ac65e37e120d2e8c254c4fa3e2c61.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <9c2270f4bd6ac65e37e120d2e8c254c4fa3e2c61.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: na3mGCiC_1ktSvW83YEzHwzfPLgAdX1nKf_176XhUFg_1733870977
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Dec 10, 2024 at 10:05:14PM +0100, Martin Wilck wrote:
> On Tue, 2024-12-10 at 14:02 -0500, Benjamin Marzinski wrote:
> > On Sat, Dec 07, 2024 at 12:36:07AM +0100, Martin Wilck wrote:
> > > We previously didn't allow map removal inside the checker loop. But
> > > with the late updates to the checkerloop code, it should be safe to
> > > orphan
> > > paths and delete maps even in this situation. We remove such maps
> > > everywhere
> > > else in the code already, whenever refresh_multipath() or
> > > setup_multipath()
> > > is called.
> > 
> > I don't think that this is safe. It's possible that the multipath
> > device
> > has paths in the INIT_REMOVED or INIT_PARTIAL state. These will get
> > silently removed from the pathvec if we remove the map here. This
> > will
> > mess up our iteration through the pathvec in update_paths(). 
> 
> Hm. You're right. But that applies to the current code in 0.11.0 PR as
> well, because we'd call 
> 
>    do_sync_mpp()
>       update_multipath_strings() 
>          sync_paths()
>             check_removed_paths()
>                vector_del_slot(pathvec, i--);
> 
> Or am I missing something?

Nope. Your right. Nuts.
 
> It seems to me that the only safe way to handle this is to refrain from
> deleting paths from the pathvec anywhere deep in the call stack. Even
> if we can avoid this situation now by moving the sync towards the end
> of the checker loop, I believe that in the long run we need to fix
> these traps in our code, because it's just so easy to get this wrong.
> 
> I wonder if we need yet another path state, of if we could simply set
> these entries in the pathvec to NULL. That sounds crazy, but it might
> actually be doable. Not 0.11.0 material, though.

I think we could just not call check_removed_paths() in sync_paths(). We
would still orphan all the paths that were no longer part of the
multipath device, and set pp->mpp for all the paths that are part of the
device just like before, but we wouldn't delete the paths from
pathvec there. Instead we would call check_removed_paths() in
refresh_multipath(), so we did it after loads and in update_multipath.

I'm pretty sure that should be fine. If the device table changed and
removed a path so that we can free it, either we reloaded the device,
and we will call setup_multipath() after the reload, or something
external did, and multipathd will see an event for that and call
setup_multipath() via update_multipath().

Does that make sense?

> > Perhaps a
> > better idea would be to set mpp->sync_ticks to 0 if
> > update_multipath_strings() fails in do_sync_mpp(). This would force a
> > refresh by sync_mpp() at the start of the next loop in checkerloop(),
> > where it can safely remove the multipath device.
> 
> I like the idea of your other post to move the sync to the
> CHECKER_FINISHED state.
> 
> Thanks,
> Martin
> 


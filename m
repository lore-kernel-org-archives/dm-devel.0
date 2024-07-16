Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F146D54BD4
	for <dm-devel@lists.linux.dev>; Tue, 16 Jul 2024 15:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721142883; cv=none; b=Gn0IZNzO49rNu4TDDMTjmJyEHTSvtiLdvG5ybC/HupEdls03D5X0n4sIoSwvnbQG+BpRMbTDh/Q+K4RLT6Eq7cY6ew8ar7V0QY/E2m/H5LXtdt5bqVBtCzedppJGeV7emjJYyP/A9bjgB7vTaMwKCtZwgVGxJu9WCTP0SGWD0Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721142883; c=relaxed/simple;
	bh=3c0oSnMhvlEeyrZUnt9r/rBtlFqzjUF0hZmpXXCEYt0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=H0dYhOOwppgno1Xxvfy1VQoPFLkKsg0faNFXPWoUsjYvtqAWEhiUJNHrQqYpppoBo1z0ZffgMLS8Gbs0KFa60xjfzlChJk4LueKsyKTyfc6bUFp2VMEMC0RZ096t/h4CU+/bnLeNu+gL99s5qgzPiS4sleKDSt5+IuPvnG3i0Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b3JxXqee; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b3JxXqee"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721142881;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EvYAJKDqXwcQTqsXI8AV1j5/66ItQD698ERI2nA2Kt4=;
	b=b3JxXqeeIfouKyoPNaFzTRafooAZNBZI1aFiejTWNdUK6abO4gLWXcC90WfVJylrVUBjFm
	QXHWR2ohqpz4/mXMJz7VQ9QG/BIwOOmvKn5ZqEKlVyBBUgES4oTiYscFiCDnZef7SpMnzj
	Dgg4BlaXRWRV1aMf0mdF1yGB3wlR/Pc=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-150-W4tfAD20PtOpybJ5pR6jiA-1; Tue,
 16 Jul 2024 11:14:37 -0400
X-MC-Unique: W4tfAD20PtOpybJ5pR6jiA-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BCC491955D59;
	Tue, 16 Jul 2024 15:14:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 521D81955D44;
	Tue, 16 Jul 2024 15:14:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46GFEYvi2121782
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 16 Jul 2024 11:14:35 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46GFEYtX2121781;
	Tue, 16 Jul 2024 11:14:34 -0400
Date: Tue, 16 Jul 2024 11:14:34 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 12/22] multipathd: adjust when mpp is synced with the
 kernel
Message-ID: <ZpaOWqAbq0ibHsCg@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
 <20240713060506.2015463-13-bmarzins@redhat.com>
 <b29efd52f75d1ef802c1b7e015657ee25d02bec1.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <b29efd52f75d1ef802c1b7e015657ee25d02bec1.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Jul 15, 2024 at 06:23:53PM +0200, Martin Wilck wrote:
> On Sat, 2024-07-13 at 02:04 -0400, Benjamin Marzinski wrote:
> > Move the code to sync the mpp device state into a helper function and
> > add a counter to to make sure that the device is synced at least once
> > every max_checkint secs. This makes sure that multipath devices with
> > no
> > paths will still get synced with the kernel.  Also, if multiple paths
> > are checked in the same loop, the multipath device will only be
> > synced
> > with the kernel once, since every time the mpp is synced in any code
> > path, mpp->sync_tick is reset.
> > 
> > The code still syncs the mpp before updating the path state for two
> > main reasons.
> > 
> > 1. Sometimes multipathd leaves the mpp with a garbage state. Future
> >    patches will fix most of these cases, but the code intentially
> >    does not remove the mpp is resyncing fails while checking paths.
> >    But this does leave the mpp with a garbage state.
> > 
> > 2. The kernel chages the multipath state independently of multipathd.
> > If
> >    the kernel fails a path, a uevent will arrive shortly. But the
> > kernel
> >    doesn't provide any notification when it switches the active
> >    path group or if it ends up picking a different one than
> > multipathd
> >    selected. Multipathd needs to know the actual current pathgroup to
> >    know when it should be switching them.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/configure.c   |  1 +
> >  libmultipath/structs.h     |  2 ++
> >  libmultipath/structs_vec.c |  5 +++
> >  multipathd/main.c          | 64 +++++++++++++++++++++++++-----------
> > --
> >  4 files changed, 50 insertions(+), 22 deletions(-)
> > 
> > 
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index fbd253ca..179fec24 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c


> > @@ -2752,12 +2767,17 @@ checkerloop (void *ap)
> >  		while (checker_state != CHECKER_FINISHED) {
> >  			unsigned int paths_checked = 0, i;
> >  			struct timespec chk_start_time;
> > +			struct multipath *mpp;
> >  
> >  			pthread_cleanup_push(cleanup_lock, &vecs-
> > >lock);
> >  			lock(&vecs->lock);
> >  			pthread_testcancel();
> > +			vector_foreach_slot(vecs->mpvec, mpp, i)
> > +				mpp->is_checked = false;
> 
> Why is this not done inside the "if (checker_state == CHECKER_STARTING)
> code path?

Since we slept here, there was more time for something to change in a
way where we needed to resync the state. Also, like I mention in the
comments, there are places where we fail in some function that is
updating the mpp state and don't resync it with the kernel. I'm fairly
sure (but not totally certain) future patches catch all of these except
for failing to update the state in the checker function itself. (We've
never removed the multipath device for failing to resync its state in
the check_path(), unlike failures when responding to an event or after
reloading the device. This makes sense to me. Since we're doing these
resyncs in check_path() routinely, not because we think something has
changed, it seems reasonable to assume that nothing has changed if we
fail to resync).

Clearing is_checked here doesn't guarantee that we will resync the mpp.
Only that we will resync if we need to check one of its paths, after the
interruption. When we switch to checking paths by mpp later, this will
never happen, except in corner cases.

-Ben 

> Martin
> 
> 
> >  			get_monotonic_time(&chk_start_time);
> >  			if (checker_state == CHECKER_STARTING) {
> > +				vector_foreach_slot(vecs->mpvec,
> > mpp, i)
> > +					check_mpp(vecs, mpp, ticks);
> >  				vector_foreach_slot(vecs->pathvec,
> > pp, i)
> >  					pp->is_checked = false;
> >  				checker_state = CHECKER_RUNNING;


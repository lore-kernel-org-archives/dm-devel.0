Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2046358D1E
	for <dm-devel@lists.linux.dev>; Wed, 21 Jan 2026 15:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769010216; cv=none; b=lPmln73343ppu2GrejPIouG8ETRDmveVn79D79Wn4fEY+VQm/ky/qn1lhUl0WmrxP20ZGzct88K+nxgpfkALtCU2TBakiUJ6VaA05vEv7QWcd+fqC3iJu9kSbsOne6n+w5gBPFurw+dH3b8TmuOGaj7YGAggxq/VkEuuToXmH9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769010216; c=relaxed/simple;
	bh=KWaDwr7yAyX8+b6gU3d2GJd56CFFN32NPZDffy+0iBQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=Mt3mnCIhgeS42CX3mIIf01e4kV7ezSPusoQzIdqw7BE5mnUT6symRCBuf3Y2KVeNnN/9vKRi1L9b9+Y7/BKEjQC4M+WFStYRXOpFtjqC+Li2FfIyI6pws67tn6cOcZnsypCSPm9mp1mqqqaYAKWY554GzzqFXfisS1EwGy7kSM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RVzjoPr4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RVzjoPr4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769010213;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c3xdMdM1lGSlE5rhp62/iqSNuOWMwp1H85XQO/2FSq0=;
	b=RVzjoPr4sKvN928lshkWo7L3fa0uK+YF7+C4Shpudnzj1Ck2Smzz7NnfkOrsoQErIJoaiH
	JgXU2bI8m7SsbFXkQSGJL540I6io3ZVZ6IUBhB4NfrtFGiUaOleppGe1sssZKYB71thds8
	fFDMoNMgYrybTrReSFFLxIjdicUIeTo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-68-Vj2XlAzcNB6rCf05b1cSSA-1; Wed,
 21 Jan 2026 10:43:30 -0500
X-MC-Unique: Vj2XlAzcNB6rCf05b1cSSA-1
X-Mimecast-MFC-AGG-ID: Vj2XlAzcNB6rCf05b1cSSA_1769010209
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9283D18005B0;
	Wed, 21 Jan 2026 15:43:29 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 38A5A19560AB;
	Wed, 21 Jan 2026 15:43:29 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 60LFhSjA3932109
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 21 Jan 2026 10:43:28 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 60LFhRjL3932108;
	Wed, 21 Jan 2026 10:43:27 -0500
Date: Wed, 21 Jan 2026 10:43:27 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 2/4] multipathd: finish initalization of paths added
 while offline
Message-ID: <aXD0H0U0fz1EHmbj@redhat.com>
References: <20260121042315.3914707-1-bmarzins@redhat.com>
 <20260121042315.3914707-3-bmarzins@redhat.com>
 <0e7261c3a77b44bb7a0c948cd041c83837a5bd5e.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <0e7261c3a77b44bb7a0c948cd041c83837a5bd5e.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fV0VLY3hYOV7PghQsO89HXENyXgw0PAZFkTH3lP_eFw_1769010209
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Jan 21, 2026 at 01:41:35PM +0100, Martin Wilck wrote:
> Hi Ben,
> 
> On Tue, 2026-01-20 at 23:23 -0500, Benjamin Marzinski wrote:
> > If a path in a mulitpath device is offline while multipathd is
> > reconfigured, it will get added to the updated multipath device, just
> > like it was in the old multipath device. However the device will
> > still
> > be in the INIT_NEW state because it can't get initilized while
> > offline.
> > This is different than the INIT_PARTIAL state because the path was
> > discovered in path_discovery(). INIT_PARTIAL is for paths that
> > multipathd did not discover in path_discovery() or receive a uevent
> > for,
> > but are part of a multipath device that was added, and which should
> > receive a uevent shortly. There is no reason to expect a uevent for
> > these offline paths.
> > 
> > When the path comes back online, multipathd will run the checker and
> > prioritizer on it. The only two pathinfo checks that won't happen
> > are the DI_WWID and DI_IOCTL ones. Modify pathinfo() to make sure
> > that if DI_IOCTL was skipped for offline paths, it gets called the
> > next time pathinfo() is called after the fd can be opened. Also,
> > make sure that when one of these offline paths becomes usable, its
> > WWID is rechecked. With those changes, all the DI_ALL checks will
> > be accounted for, and the path can be marked INIT_OK.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> Great observation, thanks!
> 
> > ---
> >  libmultipath/discovery.c |  2 ++
> >  multipathd/main.c        | 52 +++++++++++++++++++++++++++++++++++---
> > --
> >  2 files changed, 48 insertions(+), 6 deletions(-)
> > 
> > diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> > index 0c5e5ca6..0efb8213 100644
> > --- a/libmultipath/discovery.c
> > +++ b/libmultipath/discovery.c
> > @@ -2585,6 +2585,8 @@ blank:
> >  	 * Recoverable error, for example faulty or offline path
> >  	 */
> >  	pp->chkrstate = pp->state = PATH_DOWN;
> > +	if (mask & DI_IOCTL && pp->ioctl_info ==
> > IOCTL_INFO_NOT_REQUESTED)
> > +		pp->ioctl_info = IOCTL_INFO_SKIPPED;
> >  	if (pp->initialized == INIT_NEW || pp->initialized ==
> > INIT_FAILED)
> >  		memset(pp->wwid, 0, WWID_SIZE);
> >  
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index 61e0ea34..2140e432 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -2572,6 +2572,26 @@ static int sync_mpp(struct vectors *vecs,
> > struct multipath *mpp, unsigned int ti
> >  	return do_sync_mpp(vecs, mpp);
> >  }
> >  
> > +/*
> > + * pp->wwid should never be empty when this function is called, but
> > if it
> > + * is, this function can set it.
> > + */
> > +static bool new_path_wwid_changed(struct path *pp, int state)
> > +{
> > +	char wwid[WWID_SIZE];
> > +
> > +	strcpy(wwid, pp->wwid);
> > +	if (get_uid(pp, state, pp->udev, 1) != 0) {
> > +		strcpy(pp->wwid, wwid);
> > +		return false;
> > +	}
> > +	if (strlen(wwid) && strcmp(wwid, pp->wwid) != 0) {
> > +		strcpy(pp->wwid, wwid);
> > +		return true;
> > +	}
> 
> It feels a bit odd to use strcpy() and strcmp() here. I am fine with
> doing that if the arguments are string constants, where it's
> immediately obvious while are obviously properly null-terminated, but
> this isn't the case here. I'd prefer using strlcpy() and strncmp(),
> even if we are both convinced that it's ok without the length check.

I'm fine with making that change. I assume that we can skip the
strnlen(), since we don't use that anywhere, and if we switch the
initial strcpy() to a strlcpy() it's pretty obvious that wwid must be
null terminated.
 
> > +	return false;
> > +}
> > +
> >  static int
> >  update_path_state (struct vectors * vecs, struct path * pp)
> >  {
> > @@ -2601,14 +2621,34 @@ update_path_state (struct vectors * vecs,
> > struct path * pp)
> >  		return CHECK_PATH_SKIPPED;
> >  	}
> >  
> > -	if (pp->recheck_wwid == RECHECK_WWID_ON &&
> > +	if ((pp->recheck_wwid == RECHECK_WWID_ON || pp->initialized
> > == INIT_NEW) &&
> 
> The readbility of this code would improve if you move the INIT_NEW vs.
> RECHECK_WWID_ON test into an inner conditional, like this:

Good point.

-Ben
 
> 
> 	if ((newstate == PATH_UP || newstate == PATH_GHOST) &&
> 	    ((pp->state != PATH_UP && pp->state != PATH_GHOST)) ||
> 	    pp->dmstate == PSTATE_FAILED) {
> 		bool wwid_changed;
> 
> 		if (pp->initialized == INIT_NEW) {
>                         ...
>                 } else ... ;
> 
> 	        if (wwid_changed) { ... };
>         }
> 
> Martin


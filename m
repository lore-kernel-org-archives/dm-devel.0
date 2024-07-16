Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA4012B72
	for <dm-devel@lists.linux.dev>; Tue, 16 Jul 2024 15:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144729; cv=none; b=VcVy7ArnFBps+FN6g36ZWOtOyDWPggWiLe1Bg3SMmSH4WM+V6K6WFOKPmvI4uLqvQAbxFP8ny19fPtUIj4vk5+Xdau4FFCsMzlLCo3bIkSEMoEg+OAtOYMNG7SoTVL/QipFIrVCuYBFDY/+3IqPCR2XRsILVdWQhbJiIC8nbPKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144729; c=relaxed/simple;
	bh=XMHfFkStXZfwMrBZ2QocyPdwZytmK0CzC3aB7/5A5z8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=l2xODgvr13pyc7sSF7E/Ww36qQ1qAvbUoDJIv5RyydPuLkB8K6LRuSYw0+IFx7AMjRF+lgWIoPVfxthSK+zrn0EWrBl/ZcDpiS9d+igv5HrqsOSN+YMvxr8PpPrz7qWWfVCnFApiWSjnhCIjHpcqfX+MCbfDaXrJOKj8LbE1fDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=faVqU0xH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="faVqU0xH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721144727;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+Eem0RqQob0Iat27HqmUKKyl4TgdMNF2hzxqBgxyWeY=;
	b=faVqU0xHT2THS4KOHeE9MDf9LDaWB5WYy1IUmAZkAfJDW1Bd80hBd8rLqHHgh5Yk2ouTzx
	SPcirWjFT/Vgd+D0fOoETtdwXyfSjw88CxPTbuYXSXxecCf3lm9/G/ytrZVmAaabQUQPZG
	4+nS7sW9fX+SuwoG/BgKzx54c8rjt2c=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-41-Mwe7lyQEOBWx8C6DdLJmjw-1; Tue,
 16 Jul 2024 11:45:23 -0400
X-MC-Unique: Mwe7lyQEOBWx8C6DdLJmjw-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DB0A81955D4B;
	Tue, 16 Jul 2024 15:45:22 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6A654195605A;
	Tue, 16 Jul 2024 15:45:22 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46GFjK3x2122562
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 16 Jul 2024 11:45:20 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46GFjKXC2122561;
	Tue, 16 Jul 2024 11:45:20 -0400
Date: Tue, 16 Jul 2024 11:45:20 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 17/22] multipathd: handle changed wwid when adding
 partial path
Message-ID: <ZpaVkLv9CMLdNbgb@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
 <20240713060506.2015463-18-bmarzins@redhat.com>
 <c1221783863ab8faf540e82620cabeca738c670c.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <c1221783863ab8faf540e82620cabeca738c670c.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Jul 15, 2024 at 09:40:36PM +0200, Martin Wilck wrote:
> On Sat, 2024-07-13 at 02:05 -0400, Benjamin Marzinski wrote:
> > If multipathd noticed that the WWID didn't match the device when
> > adding
> > a partial path, but removing it failed, multipathd wasn't disabling
> > the
> > path. Instead of calling handle_path_wwid_change(), which doesn't
> > make
> > much sense when multipathd is expecting a uevent, just manually
> > disable
> > the path if ev_remove_path() fails.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  multipathd/cli_handlers.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> > index 0643be15..5d8ba3a6 100644
> > --- a/multipathd/cli_handlers.c
> > +++ b/multipathd/cli_handlers.c
> > @@ -540,7 +540,11 @@ add_partial_path(struct path *pp, struct vectors
> > *vecs)
> >  	if (strlen(wwid) && strncmp(wwid, pp->wwid, WWID_SIZE) != 0)
> > {
> >  		condlog(0, "%s: path wwid changed from '%s' to '%s'.
> > removing",
> >  			pp->dev, wwid, pp->wwid);
> > -		ev_remove_path(pp, vecs, 1);
> > +		if (!(ev_remove_path(pp, vecs, 1) &
> > REMOVE_PATH_SUCCESS) &&
> > +		    pp->mpp) {
> > +			pp->dmstate = PSTATE_FAILED;
> > +			dm_fail_path(pp->mpp->alias, pp->dev_t);
> > +		}
> >  		udev_device_unref(udd);
> >  		return -1;
> >  	}
> 
> 
> Is this sufficient? Can we be certain that this path won't be
> reinstated by sync_map_state() later on? That's at least not
> immediately obvious. Perhaps we should orphan the path?

We can't orphan the path completely. That's why ev_remove_path() calls
set_path_removed(), which keeps track of the fact it's still in the mpp,
so that we can complete the removal once it is actually removed from the
multipath device. Otherwise multipathd could just add it to another
device, while it was still part of the old device.

But you are correct about sync_map_state(). Good catch. We usually never
need to worry about sync_map_state() restoring paths in INIT_REMOVED,
since they really have been removed. In this case we do.  We should
probably be setting pp->state to PATH_UNCHECKED in orphan_path() anyway,
which will keep sync_map_state() from restoring it. Since the path is
in INIT_REMOVED, check_path will never update it's state. But
sync_map_state() should also be ignoring paths in INIT_REMOVED. I vote
we do both.

-Ben

> 
> Martin


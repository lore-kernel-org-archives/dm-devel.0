Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E54837143
	for <dm-devel@lists.linux.dev>; Wed,  8 Nov 2023 22:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T3UWbjdo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699482256;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tdR3+yMVfdl8q/0n0Jgljo2yfrSUCoapJ448KxLKhgo=;
	b=T3UWbjdoQPWFKCerQUQZffNmvMs+NgERGK0uyRlwMSACpJxzVaKcBZ7qf47oc/MTs+TK/+
	pPGlFjcdNT6iJBWC8gxkoJF0iWiPntQ95lvWWBYZOY9uFRrIj8hIhlHmIbyLDmTx4cvZ9E
	YIroq+8d+ypdC1TJxDRimenotjrYWyg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-9-s7jcrGzlOvSM5Wn4IRhO1A-1; Wed, 08 Nov 2023 17:24:13 -0500
X-MC-Unique: s7jcrGzlOvSM5Wn4IRhO1A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5A9D0185A780;
	Wed,  8 Nov 2023 22:24:13 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (bmarzins-01.fast.rdu2.eng.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 547AE40C6EB9;
	Wed,  8 Nov 2023 22:24:13 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1) with ESMTPS id 3A8MODOC089963
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 8 Nov 2023 17:24:13 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1/Submit) id 3A8MOCvQ089962;
	Wed, 8 Nov 2023 17:24:12 -0500
Date: Wed, 8 Nov 2023 17:24:12 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>,
        "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 6/7] multipathd: Add auto_resize config option
Message-ID: <ZUwKjPr4UNdFTNF9@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231102221507.105371-1-bmarzins@redhat.com>
 <20231102221507.105371-7-bmarzins@redhat.com>
 <a79b2b7777bf811ae7410b594e7e9f37f4ab073a.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <a79b2b7777bf811ae7410b594e7e9f37f4ab073a.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Nov 08, 2023 at 06:07:35PM +0000, Martin Wilck wrote:
> On Thu, 2023-11-02 at 18:15 -0400, Benjamin Marzinski wrote:
> > This option gives multipathd the ability to automatically resize a
> > device when it detects that all of the path devices have changed. By
> > default it is set to never, and multipathd will continue to work like
> > it
> > always has, where a users must manually resize a multipath device.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/config.c         |  2 ++
> >  libmultipath/config.h         |  3 +++
> >  libmultipath/configure.c      |  1 +
> >  libmultipath/defaults.h       |  1 +
> >  libmultipath/dict.c           | 48
> > +++++++++++++++++++++++++++++++++++
> >  libmultipath/dict.h           |  1 +
> >  libmultipath/hwtable.c        |  1 +
> >  libmultipath/propsel.c        | 17 +++++++++++++
> >  libmultipath/propsel.h        |  1 +
> >  libmultipath/structs.h        |  8 ++++++
> >  multipath/multipath.conf.5.in | 16 ++++++++++++
> >  multipathd/main.c             | 24 +++++++++++++++++-
> >  12 files changed, 122 insertions(+), 1 deletion(-)
> > 
> > diff --git a/libmultipath/config.c b/libmultipath/config.c
> > index 9d90f512..e6024955 100644
> > --- a/libmultipath/config.c
> > +++ b/libmultipath/config.c
> > @@ -464,6 +464,7 @@ merge_hwe (struct hwentry * dst, struct hwentry *
> > src)
> >  	merge_num(ghost_delay);
> >  	merge_num(all_tg_pt);
> >  	merge_num(recheck_wwid);
> > +	merge_num(auto_resize);
> 
> Why make this a hardware-specific option? Isn't it sufficient to just
> set this in the defaults section? I can hardly imagine users wanting
> auto-resize for one array and not for another.
> 
> Other than that, looks good to me (one nit below).

Sure. I'll fix all these up.

-Ben
 
> Martin
> 
> 
> > diff --git a/multipath/multipath.conf.5.in
> > b/multipath/multipath.conf.5.in
> > index 41f3927e..c90383cf 100644
> > --- a/multipath/multipath.conf.5.in
> > +++ b/multipath/multipath.conf.5.in
> > @@ -1333,6 +1333,22 @@ The default is: \fBno\fR
> >  .
> >  .
> >  .TP
> > +.B auto_resize
> > +Controls when multipathd will automatically resize a multipath
> > device.  If set
> > +to \fInever\fR, multipath devices must always be manually resized by
> > either
> > +running \fBmultipathd resize map <name>\fR or \fRmultipath -r
> > <name>\fR.  If
> 
> I suggest not mentioning "multipath -r" here.
> 
> > +set to \fIgrow_only\fR, when multipathd detects that all of a
> > multipath
> > +device's paths have increased in size, it will automatically grow
> > the multipath
> > +device to the new size. If set to \fIgrow_shrink\fR, multipathd will
> > also
> > +automatically shrink the device once it detects all of its paths
> > have decreased
> > +in size.
> > +.RS
> > +.TP
> > +The default is: \fBnever\fR
> > +.RE
> > +.
> > +.
> > +.TP
> >  .B enable_foreign
> >  Enables or disables foreign libraries (see section
> >  .I FOREIGN MULTIPATH SUPPORT
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index 3b4c5b09..ac733491 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -1633,7 +1633,6 @@ uev_update_path (struct uevent *uev, struct
> > vectors * vecs)
> >  		ro = uevent_get_disk_ro(uev);
> >  		if (needs_ro_update(mpp, ro)) {
> >  			condlog(2, "%s: update path write_protect to
> > '%d' (uevent)", uev->kernel, ro);
> > -
> >  			if (mpp->wait_for_udev)
> >  				mpp->wait_for_udev = 2;
> >  			else {
> > @@ -1648,6 +1647,29 @@ uev_update_path (struct uevent *uev, struct
> > vectors * vecs)
> >  				}
> >  			}
> >  		}
> > +		if (mpp->auto_resize != AUTO_RESIZE_NEVER &&
> > +		    !mpp->wait_for_udev) {
> > +			struct pathgroup *pgp;
> > +			struct path *pp2;
> > +			unsigned int i, j;
> > +			unsigned long long orig_size = mpp->size;
> > +
> > +			if (!pp->size || pp->size == mpp->size ||
> > +                            (pp->size < mpp->size &&
> 
> There's a whitespace issue here (space indentation).
> 
> > +			     mpp->auto_resize ==
> > AUTO_RESIZE_GROW_ONLY))
> > +				goto out;
> > +
> > +			vector_foreach_slot(mpp->pg, pgp, i)
> > +				vector_foreach_slot (pgp->paths,
> > pp2, j)
> > +					if (pp2->size && pp2->size
> > != pp->size)
> > +						goto out;
> > +			retval = resize_map(mpp, pp->size, vecs);
> > +			if (retval == 2)
> > +				condlog(2, "%s: map removed during
> > resize", pp->dev);
> > +			else if (retval == 0)
> > +				condlog(2, "%s: resized map from
> > %llu to %llu",
> > +					mpp->alias, orig_size, pp-
> > >size);
> > +		}
> >  	}
> >  out:
> >  	lock_cleanup_pop(vecs->lock);


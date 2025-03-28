Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6EB2AEED
	for <dm-devel@lists.linux.dev>; Fri, 28 Mar 2025 16:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743179773; cv=none; b=pChYxaBNXkmvRYO205Uo6J9E3vTTkT0sFdzoW1iodpBkjVwznrRIHfdI83sIQpbYkGfDQequXl+hPNtGaQz/oBsyne1FMlfCessMYhVD59L7biiKNRozpHl1PuPRKkzy/ws0hqvRMq+lG4g6c2qKPnoQAq16BSdOcp44LsKMKeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743179773; c=relaxed/simple;
	bh=Nn/9UPUgZELuuArFTMYtUM93IDauycoJU4qc21zdWUo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=DSSOQCdxvYcQ3cGLHWJv0U0IgZEzJkWSUOv2R+V6Jn7JRZ16RofMJFxMBn/eYiCkgOLeau2xWoVri7Y4fbMbBvKqMmmM7FRxfoqAcufjCOmIpdFbXqj5mWOxrTm9jy93TBwum3VoWG72hYvKlc6YDqCOlFTntSurIMkZrEtPBRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W1N3WLTd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W1N3WLTd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743179768;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gc1/FHbfJL6ACWZkvlCHwoPB2sk05dRXdeVJmImRd1w=;
	b=W1N3WLTd2OU0qAv9Huzsn1vWGPzIrKjErWGR5RITu8Tt8suqZbT4SxFFAMquJcLWnw8snW
	YiW11cnnPQP0GFfR8vqaFrYmWyB6x0JehjKb7GzQpGq6vQtFzy+efNol7lAZIFt7Wpt6lx
	Yk/Q88BTuquqtTLVTLqqpt6telxv55Q=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-508-Sd8gyFQpOWmjyKnKEwqeEw-1; Fri,
 28 Mar 2025 12:36:06 -0400
X-MC-Unique: Sd8gyFQpOWmjyKnKEwqeEw-1
X-Mimecast-MFC-AGG-ID: Sd8gyFQpOWmjyKnKEwqeEw_1743179765
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 18E7E195E92A;
	Fri, 28 Mar 2025 16:36:05 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AF2441801751;
	Fri, 28 Mar 2025 16:36:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 52SGa3EC2693449
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 28 Mar 2025 12:36:03 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 52SGa3aN2693448;
	Fri, 28 Mar 2025 12:36:03 -0400
Date: Fri, 28 Mar 2025 12:36:03 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 2/3] multipathd: re-add paths skipped because they were
 offline
Message-ID: <Z-bP80uHCVjJs0-g@redhat.com>
References: <20250324205504.2523493-1-bmarzins@redhat.com>
 <20250324205504.2523493-3-bmarzins@redhat.com>
 <8f0c3fab83d329c22a2d1921356fe7c91966da73.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <8f0c3fab83d329c22a2d1921356fe7c91966da73.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fJkiBqYrkIfzMgWELvo-7yqiTNd2iAWIzQhVJcUCuBc_1743179765
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Mar 25, 2025 at 11:33:18PM +0100, Martin Wilck wrote:
> On Mon, 2025-03-24 at 16:55 -0400, Benjamin Marzinski wrote:
> > When a new device is added by the multipath command, multipathd may
> > know
> > of other paths that cannot be added to the device because they are
> > currently offline. Instead of ignoring these paths, multipathd will
> > now
> > re-add them when they come back online. To do this, it multipathd
> > needs
> > a new device initialized state, INIT_OFFLINE, to track devices that
> > were
> > in INIT_OK, but could not be added to an existing multipath device
> > because they were offline. These paths are handled along with the
> > other
> > uninitialized paths.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> This looks good in general, but I'm not certain about INIT_OFFLINE. The
> property "path was temporarily offline while we tried to add it to a
> map" is not logically related to path initialization, IMO. Also, we
> have plenty of (pp->initialized != INIT_xyz) conditionals in the code,
> and your patch touches only 2 of them. I find it difficult to rule out
> that some of them might be broken by the additional init state. Have
> you double-checked them all?

Yeah. I may have overlooked something, but I did look through them. I
just double-checked pathinfo(), since if that's called with DI_ALL and
succeeds, it will unconditionally set the path to INIT_OK.  There isn't
a case where that could happen to a path in INIT_OFFLINE, but it would
make sense to add a check there, just to make it obvious that this
shouldn't move the path from INIT_OFFLINE to INIT_OK. Even if DI_CHECKER
is set and pathinfo() discovers that the path has come back up, It's
easier to just wait for checkerloop to check the path, and handle adding
it the the multipath device there.

I should point out what this patch doesn't do, since that might clear up
some cases where you would think I need to handle offline paths. This
patch is only taking care of the case where a multipath device exists,
but multipathd won't start monitoring it because it can't reload the
table with the offline paths. It does not handle the case where offline
paths exist, and that keeps multipathd from creating a device in the
first place.

The easiest way for that to happen is if the device WWID is not in the
wwids file and find_multipaths is set to "on" or "smart", where a device
will get multipathed when a second path appears. In this case, you could
add a single path and fully initialize it, then have that path go
offline, and later add a second path. Multipathd would see that there
are two paths, and try to create a multipath device. However the
offline path would keep the device from being created. Since we
call pathinfo(DI_CHECKER) in adopt_paths(), multipathd should know
that the path is offline before it tries to create the device, so
we could create the device without any offline paths, and then set those
paths to INIT_OFFLINE, for later addition.

This case seemed less important to me than the one where we end up with
an untracked mlutipath device. This problem has always existed and it's
immediately obvious when it occurs (there's no multipath device), and
yet I've never gotten a bug report for it. This makes sense because it's
pretty hard to hit. Usually, the path will either not get initialized in
the first place because it's offline (in which case we won't attempt to
use it as part of a multipath device) or multipathd will create a
multipath device using it as soon as the path gets added, leaving a very
small window between when multipathd initializes the path and when
it creates the multipath device. The larger window for the path to
go offline only happens in the case where multipathd doesn't know
to create a multipath device right away.

The case with the untracked device is pretty much as hard to hit, and
has also always existed, but it's not obvious to the user that their
multipath device isn't being tracked by multipathd. That seems much
worse to me. I'm considering fixing the case where the device doesn't
get created at all, but that can happen in multiple places, so I think
it'll be a little messier. Also, I can't decide if multipathd should try
to create the device with all the paths first, and only ignore the
offline paths on retries, if the first create attempt fails, or if it
should always skip the offline paths, at least if if just checked their
state in adopt_paths(). Thoughts?

> 
> Maybe it would be better to store this property in a separate flag in
> struct path?

Sure. I can switch to that.

> 2 more remarks below.
> 
> Thanks
> Martin
> 
> > ---
> >  libmultipath/print.c       |  1 +
> >  libmultipath/structs.h     |  5 ++++
> >  libmultipath/structs_vec.c |  5 ++++
> >  multipathd/main.c          | 58
> > ++++++++++++++++++++++++++++++++++++--
> >  4 files changed, 67 insertions(+), 2 deletions(-)
> > 
> > diff --git a/libmultipath/print.c b/libmultipath/print.c
> > index 00c03ace..ed8adebe 100644
> > --- a/libmultipath/print.c
> > +++ b/libmultipath/print.c
> > @@ -572,6 +572,7 @@ static int snprint_initialized(struct strbuf
> > *buff, const struct path * pp)
> >  		[INIT_OK] = "ok",
> >  		[INIT_REMOVED] = "removed",
> >  		[INIT_PARTIAL] = "partial",
> > +		[INIT_OFFLINE] = "offline",
> >  	};
> >  	const char *str;
> >  
> > diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> > index 28de9a7f..8644407f 100644
> > --- a/libmultipath/structs.h
> > +++ b/libmultipath/structs.h
> > @@ -258,6 +258,11 @@ enum initialized_states {
> >  	 * change uevent is received.
> >  	 */
> >  	INIT_PARTIAL,
> > +	/*
> > +	 * INIT_OFFLINE: paths that should be part of an existing
> > multipath
> > +	 * device, but cannot be added because they are offline,
> > +	 */
> > +	INIT_OFFLINE,
> >  	INIT_LAST__,
> >  };
> >  
> > diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> > index f6407e12..f122d056 100644
> > --- a/libmultipath/structs_vec.c
> > +++ b/libmultipath/structs_vec.c
> > @@ -389,6 +389,9 @@ static void orphan_paths(vector pathvec, struct
> > multipath *mpp, const char *reas
> >  				free_path(pp);
> >  			} else
> >  				orphan_path(pp, reason);
> > +		} else if (pp->initialized == INIT_OFFLINE &&
> > +			   strncmp(mpp->wwid, pp->wwid, WWID_SIZE)
> > == 0) {
> > +			pp->initialized = INIT_OK;
> >  		}
> >  	}
> >  }
> > @@ -595,6 +598,8 @@ void sync_paths(struct multipath *mpp, vector
> > pathvec)
> >  		found = 0;
> >  		vector_foreach_slot(mpp->pg, pgp, j) {
> >  			if (find_slot(pgp->paths, (void *)pp) != -1)
> > {
> > +				if (pp->initialized == INIT_OFFLINE)
> > +					pp->initialized = INIT_OK;
> >  				found = 1;
> >  				break;
> >  			}
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index 7aaae773..ecad5a4f 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -644,11 +644,44 @@ pr_register_active_paths(struct multipath *mpp)
> >  	}
> >  }
> >  
> > +static void
> > +save_offline_paths(struct multipath *mpp, vector offline_paths)
> 
> const struct multipath *mpp ?

Sure.

> > +{
> > +	unsigned int i, j;
> > +	struct path *pp;
> > +	struct pathgroup *pgp;
> > +
> > +	vector_foreach_slot (mpp->pg, pgp, i)
> > +		vector_foreach_slot (pgp->paths, pp, j)
> > +			if (pp->initialized == INIT_OK &&
> > +			    pp->sysfs_state == PATH_DOWN)
> > +				store_path(offline_paths, pp);
> 
> You're not handling error from store_path here. I don't think you need
> to, but perhaps indicate this by adding a comment or calling
> (void)store_path(...).

Yeah. There's no real point in failing here if storing the path fails.
I can comment this.

> > +}
> > +
> > +static void
> > +handle_orphaned_offline_paths(vector offline_paths)
> > +{
> > +	unsigned int i;
> > +	struct path *pp;
> > +
> > +	vector_foreach_slot (offline_paths, pp, i)
> > +		if (pp->mpp == NULL)
> > +			pp->initialized = INIT_OFFLINE;
> > +}
> > +
> > +static void
> > +cleanup_reset_vec(struct vector_s **v)
> > +{
> > +	vector_reset(*v);
> > +}
> > +
> >  static int
> >  update_map (struct multipath *mpp, struct vectors *vecs, int
> > new_map)
> >  {
> >  	int retries = 3;
> >  	char *params __attribute__((cleanup(cleanup_charp))) = NULL;
> > +	struct vector_s offline_paths_vec = { .allocated = 0 };
> > +	vector offline_paths
> > __attribute__((cleanup(cleanup_reset_vec))) = &offline_paths_vec;
> >  
> >  retry:
> >  	condlog(4, "%s: updating new map", mpp->alias);
> > @@ -685,6 +718,9 @@ fail:
> >  		return 1;
> >  	}
> >  
> > +	if (new_map && retries < 0)
> > +		save_offline_paths(mpp, offline_paths);
> > +
> >  	if (setup_multipath(vecs, mpp))
> >  		return 1;
> >  
> > @@ -695,6 +731,9 @@ fail:
> >  	if (mpp->prflag == PRFLAG_SET)
> >  		pr_register_active_paths(mpp);
> >  
> > +	if (VECTOR_SIZE(offline_paths) != 0)
> > +		handle_orphaned_offline_paths(offline_paths);
> > +
> >  	if (retries < 0)
> >  		condlog(0, "%s: failed reload in new map update",
> > mpp->alias);
> >  	return 0;
> > @@ -2793,7 +2832,8 @@ check_uninitialized_path(struct path * pp,
> > unsigned int ticks)
> >  	struct config *conf;
> >  
> >  	if (pp->initialized != INIT_NEW && pp->initialized !=
> > INIT_FAILED &&
> > -	    pp->initialized != INIT_MISSING_UDEV)
> > +	    pp->initialized != INIT_MISSING_UDEV &&
> > +	    pp->initialized != INIT_OFFLINE)
> >  		return CHECK_PATH_SKIPPED;
> >  
> >  	if (pp->tick)
> > @@ -2849,7 +2889,8 @@ update_uninitialized_path(struct vectors *
> > vecs, struct path * pp)
> >  	struct config *conf;
> >  
> >  	if (pp->initialized != INIT_NEW && pp->initialized !=
> > INIT_FAILED &&
> > -	    pp->initialized != INIT_MISSING_UDEV)
> > +	    pp->initialized != INIT_MISSING_UDEV &&
> > +	    pp->initialized != INIT_OFFLINE)
> >  		return CHECK_PATH_SKIPPED;
> >  
> >  	newstate = get_new_state(pp);
> > @@ -2875,6 +2916,19 @@ update_uninitialized_path(struct vectors *
> > vecs, struct path * pp)
> >  			free_path(pp);
> >  			return CHECK_PATH_REMOVED;
> >  		}
> > +	} else if (pp->initialized == INIT_OFFLINE &&
> > +		   (newstate == PATH_UP || newstate == PATH_GHOST))
> > {
> > +		pp->initialized = INIT_OK;
> > +		if (pp->recheck_wwid == RECHECK_WWID_ON &&
> > +		    check_path_wwid_change(pp)) {
> > +			condlog(0, "%s: path wwid change detected.
> > Removing",
> > +				pp->dev);
> > +			return handle_path_wwid_change(pp, vecs)?
> > +					CHECK_PATH_REMOVED :
> > +					CHECK_PATH_SKIPPED;
> > +		}
> > +		ev_add_path(pp, vecs, 1);
> > +		pp->tick = 1;
> >  	}
> >  	return CHECK_PATH_CHECKED;
> >  }


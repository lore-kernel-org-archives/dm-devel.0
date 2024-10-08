Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CDD01E0E1F
	for <dm-devel@lists.linux.dev>; Tue,  8 Oct 2024 19:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728415036; cv=none; b=Wadu28oL8W5Viiy3vyjgxreYUUl5ZXhKFsHXdPQ2G73mt7Pr4ekTosBpBuOvLuUSbatbRiZUHpVFaJIFgJ00+dTRwkfQ/58PSXAp+gOLL7Af3n18v1QSYHxE7Pm7w/AkjLOlsWIgWyHgriGuOAII6WnT72WxjHqfKDR05kuEtjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728415036; c=relaxed/simple;
	bh=27lKZVxTPRfeTapcoZvxIg7ehHKKMn63fThsfNUGHVQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=q3JiwIFs+zjoSXthlSW/xoa1a9zJWKO6EHewVTiDVZI+zPW/M7zOboeTku7iSpZGO+RTxId33pageyReZdiM5QLO/AJGACgIbep/IFKH8yOCb46MbJoVe86vEAuoMjG1r7wsdZPzSd9yt6qtrnFmFzOdIoZt37p2oBc66TZotJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RLttOve7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RLttOve7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728415033;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HmSB4LRrQD2cdsMy/Kymm3CfsPEJ2nUa3dG77r8Qp5E=;
	b=RLttOve7UZKVkyma7do5S206RMT1tPQVCVzSv7IMuGyxGIyCPg1VqcWPZnPU5CEG2TyFph
	nPz+nK/YCWypGuef/MR4mgNDbYzFGtvS21kJRg3TxwIOObf1vpv/c5U4+iplzMUNXdTaTc
	2ttTpYT8sio+r27PU5JhfCpit94QomM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-520-pT3DwYKPP5q77r4T0VNAhQ-1; Tue,
 08 Oct 2024 15:17:10 -0400
X-MC-Unique: pT3DwYKPP5q77r4T0VNAhQ-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 21D7C1955D80;
	Tue,  8 Oct 2024 19:17:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CD146300018D;
	Tue,  8 Oct 2024 19:17:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 498JH7oC2369487
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 8 Oct 2024 15:17:07 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 498JH7cf2369486;
	Tue, 8 Oct 2024 15:17:07 -0400
Date: Tue, 8 Oct 2024 15:17:07 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH v2 14/22] multipathd: update priority once after updating
 all paths
Message-ID: <ZwWFMwUxI5zVf5Dm@redhat.com>
References: <20240912214947.783819-1-bmarzins@redhat.com>
 <20240912214947.783819-15-bmarzins@redhat.com>
 <be3a772cdd136269ddd0bb3287f522e7eeb1e6ba.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <be3a772cdd136269ddd0bb3287f522e7eeb1e6ba.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Oct 03, 2024 at 11:00:20PM +0200, Martin Wilck wrote:
> On Thu, 2024-09-12 at 17:49 -0400, Benjamin Marzinski wrote:
> > Instead of updating the path priorities and possibly reloading the
> > multipath device when each path is updated, wait till all paths
> > have been updated, and then go through the multipath devices updating
> > the priorities once, reloading if necessary.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/structs.h |   9 +++
> >  multipathd/main.c      | 169 ++++++++++++++++++++++++++-------------
> > --
> >  2 files changed, 118 insertions(+), 60 deletions(-)
> > 
> > diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> > index af8e31e9..1f531d30 100644
> > --- a/libmultipath/structs.h
> > +++ b/libmultipath/structs.h
> > @@ -318,6 +318,7 @@ enum check_path_states {
> >  	CHECK_PATH_UNCHECKED,
> >  	CHECK_PATH_STARTED,
> >  	CHECK_PATH_CHECKED,
> > +	CHECK_PATH_NEW_UP,
> >  	CHECK_PATH_SKIPPED,
> >  	CHECK_PATH_REMOVED,
> >  };
> > @@ -421,6 +422,13 @@ enum prflag_value {
> >  	PRFLAG_SET,
> >  };
> >  
> > +enum prio_update_type {
> > +	PRIO_UPDATE_NONE,
> > +	PRIO_UPDATE_NORMAL,
> > +	PRIO_UPDATE_NEW_PATH,
> > +	PRIO_UPDATE_MARGINAL,
> > +};
> > +
> >  struct multipath {
> >  	char wwid[WWID_SIZE];
> >  	char alias_old[WWID_SIZE];
> > @@ -464,6 +472,7 @@ struct multipath {
> >  	int queue_mode;
> >  	unsigned int sync_tick;
> >  	int synced_count;
> > +	enum prio_update_type prio_update;
> >  	uid_t uid;
> >  	gid_t gid;
> >  	mode_t mode;
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index 9519b6c5..3cda3c18 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -1996,15 +1996,13 @@ mpvec_garbage_collector (struct vectors *
> > vecs)
> >   * best pathgroup, and this is the first path in the pathgroup to
> > come back
> >   * up, then switch to this pathgroup */
> >  static int
> > -followover_should_failback(struct path * pp)
> > +do_followover_should_failback(struct path * pp)
> >  {
> >  	struct pathgroup * pgp;
> >  	struct path *pp1;
> >  	int i;
> >  
> > -	if (pp->mpp->pgfailback != -FAILBACK_FOLLOWOVER ||
> > -	    !pp->mpp->pg || !pp->pgindex ||
> > -	    pp->pgindex != pp->mpp->bestpg)
> > +	if (!pp->pgindex || pp->pgindex != pp->mpp->bestpg)
> >  		return 0;
> >  
> >  	pgp = VECTOR_SLOT(pp->mpp->pg, pp->pgindex - 1);
> > @@ -2017,6 +2015,26 @@ followover_should_failback(struct path * pp)
> >  	return 1;
> >  }
> >  
> > +static int
> > +followover_should_failback(struct multipath *mpp)
> > +{
> > +	struct path *pp;
> > +	struct pathgroup * pgp;
> > +	int i, j;
> > +
> > +	if (mpp->pgfailback != -FAILBACK_FOLLOWOVER || !mpp->pg)
> > +		return 0;
> > +
> > +	vector_foreach_slot (mpp->pg, pgp, i) {
> > +		vector_foreach_slot (pgp->paths, pp, j) {
> > +			if (pp->is_checked == CHECK_PATH_NEW_UP &&
> > +			    do_followover_should_failback(pp))
> > +				return 1;
> > +		}
> > +	}
> > +	return 0;
> > +}
> > +
> >  static void
> >  missing_uev_wait_tick(struct vectors *vecs)
> >  {
> > @@ -2132,41 +2150,53 @@ partial_retrigger_tick(vector pathvec)
> >  	}
> >  }
> >  
> > -static int update_prio(struct path *pp, int force_refresh_all)
> > +static bool update_prio(struct multipath *mpp, bool refresh_all)
> >  {
> >  	int oldpriority;
> > -	struct path *pp1;
> > +	struct path *pp;
> >  	struct pathgroup * pgp;
> > -	int i, j, changed = 0;
> > +	int i, j;
> > +	bool changed = false;
> > +	bool skipped_path = false;
> >  	struct config *conf;
> >  
> > -	oldpriority = pp->priority;
> > -	if (pp->state != PATH_DOWN) {
> > -		conf = get_multipath_config();
> > -		pthread_cleanup_push(put_multipath_config, conf);
> > -		pathinfo(pp, conf, DI_PRIO);
> > -		pthread_cleanup_pop(1);
> > +	vector_foreach_slot (mpp->pg, pgp, i) {
> > +		vector_foreach_slot (pgp->paths, pp, j) {
> > +			if (pp->state == PATH_DOWN)
> > +				continue;
> > +			if (!refresh_all &&
> > +			    pp->is_checked != CHECK_PATH_CHECKED) {
> > +				skipped_path = true;
> > +				continue;
> > +			}
> 
> Nit: My first thought here was that this would skip paths for which 
> pp->is_checked == CHECK_PATH_NEW_UP. Then I realized that if there was
> a new path up, refresh_all would be set, which is not immediately
> obvious. Can you add a comment?

Sure.

> 
> Martin


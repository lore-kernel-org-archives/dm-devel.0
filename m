Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A7356380
	for <dm-devel@lists.linux.dev>; Fri, 15 Dec 2023 23:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BBLcXM+i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702683786;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GAknxUk4pC4I6ujaPH+hliyZ86UIYQZRg3zJHLy7aFg=;
	b=BBLcXM+iz5WGnA/hdSqUtEvgyFOka/qK27+AyUmUYeWaQx36YemkiOmOBxd+7um28R9i6s
	EbFctMIQwkwZtunyD45Cd72V2Bpo3r2d8TcmyJN8nT+bmBe8B87psVu5kqpPfQgdLugLjt
	7urcX3fLzaubaLPOlqhe1G0MrOJRiCk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-248-d2uZr0aNMzyrOEv5uNmHUw-1; Fri, 15 Dec 2023 18:43:03 -0500
X-MC-Unique: d2uZr0aNMzyrOEv5uNmHUw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E36E85A589;
	Fri, 15 Dec 2023 23:43:03 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D4B640C6EB9;
	Fri, 15 Dec 2023 23:43:03 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 3BFNh35O676457
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 15 Dec 2023 18:43:03 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 3BFNh2uT676456;
	Fri, 15 Dec 2023 18:43:02 -0500
Date: Fri, 15 Dec 2023 18:43:02 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH v2 1/5] multipathd: Make sure to disable queueing if
 recovery has failed.
Message-ID: <ZXzkhhBclqwXXG8q@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231205235704.355125-1-bmarzins@redhat.com>
 <20231205235704.355125-2-bmarzins@redhat.com>
 <fe8e4e3239a6c991d965c525bf2c6148c9c21df5.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <fe8e4e3239a6c991d965c525bf2c6148c9c21df5.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Dec 14, 2023 at 04:11:32PM +0100, Martin Wilck wrote:
> On Tue, 2023-12-05 at 18:57 -0500, Benjamin Marzinski wrote:
> > If a multipath device has no_path_retry set to a number and has lost
> > all
> > paths, gone into recovery mode, and timed out, it will disable
> > queue_if_no_paths. After that, if one of those failed paths is
> > removed,
> > when the device is reloaded, queue_if_no_paths will be re-enabled. 
> > When
> > set_no_path_retry() is then called to update the queueing state, it
> > will
> > not disable queue_if_no_paths, since the device is still in the
> > recovery
> > state, so it believes no work needs to be done. The device will
> > remain
> > in the recovery state, with retry_ticks at 0, and queueing enabled,
> > even though there are no usable paths.
> > 
> > To fix this, in set_no_path_retry(), if no_path_retry is set to a
> > number
> > and the device is queueing but it is in recovery mode and out of
> > retries with no usable paths, manually disable queue_if_no_path.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/structs_vec.c | 23 ++++++++++++++++++++++-
> >  1 file changed, 22 insertions(+), 1 deletion(-)
> > 
> > diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> > index 0e8a46e7..9345b622 100644
> > --- a/libmultipath/structs_vec.c
> > +++ b/libmultipath/structs_vec.c
> > @@ -627,8 +627,18 @@ void set_no_path_retry(struct multipath *mpp)
> >  			    !mpp->in_recovery)
> >  				dm_queue_if_no_path(mpp->alias, 1);
> >  			leave_recovery_mode(mpp);
> > -		} else if (pathcount(mpp, PATH_PENDING) == 0)
> > +		} else if (pathcount(mpp, PATH_PENDING) == 0) {
> > +			/*
> > +			 * If in_recovery is set,
> > enter_recovery_mode does
> > +			 * nothing. If the device is already in
> > recovery
> > +			 * mode and has already timed out, manually
> > call
> > +			 * dm_queue_if_no_path to stop it from
> > queueing.
> > +			 */
> > +			if ((!mpp->features || is_queueing) &&
> > +			    mpp->in_recovery && mpp->retry_tick ==
> > 0)
> > +				dm_queue_if_no_path(mpp->alias, 0);
> 
> I don't understand why you put this statement in the pathcount(mpp,
> PATH_PENDING) == 0 clause. In 7278108 ("libmultipath: don't enter
> recovery mode with pending paths"), you argued correctly that recovery
> mode should not be *entered* with pending paths, but here we are in
> recovery mode already.

I see your point. But I think the only way this could happen is if you
added a new path to a multipath device that was already in recovery
mode. If the path checker didn't finish quickly enough during path
addition, the path will be in PATH_PENDING after the reload. The fact
that you are adding the path makes it seem more likely that the path is
working. In this case, it seems a little wrong to have a multipath
device that starts queueing on the reload, and then disables queueing,
only to reenable it again a second later when the pending path is
rechecked and is found to be up.  I think it's reasonable to wait for
the PENDING state to get resolved before you take any actions here. But
I don't really have strong feelings about this, so if you do, I'm fine
with changing it.
 
> Also, what do you think about the following? This way, we'd avoid
> enabling queueing temporarily when we reload the map.
> 
> diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
> index 3b37a92..3d85e6e 100644
> --- a/libmultipath/dmparser.c
> +++ b/libmultipath/dmparser.c
> @@ -60,9 +60,19 @@ int assemble_map(struct multipath *mp, char **params)
>         nr_priority_groups = VECTOR_SIZE(mp->pg);
>         initial_pg_nr = (nr_priority_groups ? mp->bestpg : 0);
>  
> -       if (mp->no_path_retry != NO_PATH_RETRY_UNDEF  &&
> -           mp->no_path_retry != NO_PATH_RETRY_FAIL) {
> +       switch (mp->no_path_retry) {
> +       case NO_PATH_RETRY_UNDEF:
> +       case NO_PATH_RETRY_FAIL:
> +               break;
> +       default:
> +               /* don't enable queueing if no_path_retry has timed out */
> +               if (mp->in_recovery && mp->retry_tick == 0 &&
> +                   count_active_paths(mp) == 0)
> +                       break;
> +               /* fallthrough */
> +       case NO_PATH_RETRY_QUEUE:
>                 add_feature(&mp->features, no_path_retry);
> +               break;
>         }
>         if (mp->retain_hwhandler == RETAIN_HWHANDLER_ON &&
>             get_linux_version_code() < KERNEL_VERSION(4, 3, 0))

This looks good.

-Ben
> 
> 
> Regards
> Martin


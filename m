Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD172C1AB
	for <dm-devel@lists.linux.dev>; Mon,  4 Dec 2023 20:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VtbnMjuO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701720052;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B1aZ5NG9gxAsyG92nea+6e9uIbbbsHU+6zNa+kdjt3M=;
	b=VtbnMjuOr1eqfrAOTCTsuVD6Jfw1IXQ8W3nQ2OmWqvvhMG6kOKbJ02Lg7rEV7F0DVxWbDb
	pL09FjTdouXuLMFzKFoYcwEGwaq32dMD7Mrh/x9HsyHg9p7SvQBvg/uqvBxQwfs6p/rRHT
	uD8+X9G9lUDhkM870gVrdAKQQqDcN0w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-647-yrLFWrxzOOG2_ly62IO3UQ-1; Mon, 04 Dec 2023 15:00:50 -0500
X-MC-Unique: yrLFWrxzOOG2_ly62IO3UQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 374BC80F831;
	Mon,  4 Dec 2023 20:00:50 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (unknown [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 16D01492BFC;
	Mon,  4 Dec 2023 20:00:50 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1) with ESMTPS id 3B4K0n0J343589
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 4 Dec 2023 15:00:49 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1/Submit) id 3B4K0nOS343588;
	Mon, 4 Dec 2023 15:00:49 -0500
Date: Mon, 4 Dec 2023 15:00:49 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH] multipathd: Make sure to disable queueing if recovery
 has failed.
Message-ID: <ZW4v8bZSDSypdv42@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231127215418.271708-1-bmarzins@redhat.com>
 <23fc863a947a0362e31e4cf685a4cb92f4e9178f.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <23fc863a947a0362e31e4cf685a4cb92f4e9178f.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Dec 04, 2023 at 03:38:03PM +0100, Martin Wilck wrote:
> On Mon, 2023-11-27 at 16:54 -0500, Benjamin Marzinski wrote:
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
> 
> Thanks, this makes sense. I am just wondering if this logic should
> be moved to enter_recovery_mode() / leave_recovery_mode() instead.
> That pair of functions is also called from
> update_queue_mode{add,del}_path(), where the same reasoning would
> apply, afaics. Am I overlooking something?

In general, I think it's safe to only do this in set_no_path_retry().
The functions that call update_queue_mode{add,del}_path() are:
fail_path()
reinstate_path()
update_multipath()
io_err_stat_handle_pathfail()

fail_path() and reinstate_path() will always call the
update_queue_mode_* function after calling set_no_path_retry(), so the
device will already be in the correct state. update_multipath() usually
will as well (except when it's called by a command line handler), and
further, it will only call update_queue_mode_del_path() when it is
actually failing a path, so the multipath device shouldn't already be
in recovery_mode. The same goes for io_err_stat_handle_pathfail().

Also we need to make sure that mpp->features is uptodate before doing
these checks, so that we know what the current queueing state is.
io_err_stat_handle_pathfail() doesn't update mpp->features before
calling update_queue_mode_del_path(), so it could end up doing the wrong
thing.

And set_no_path_retry() will be called (after updating mpp->features)
the next time the path checker completes for a path in the device, so
devices won't remain in a bad state long, no matter what.

What looking at this did make me realize is that cli_restore_queueing()
and cli_restore_all_queueing() don't update the device strings before
calling set_no_path_retry(). Thinking about this, it seems like they
should call update_multipath(vecs, mpp->alias, 1) instead, to trigger
the set_no_path_retry() call after updating mpp->features.

I'll send another patch to fix cli_restore_queueing() and
cli_restore_all_queueing(). If you think it's necessary, I can also send
one to make io_err_stat_handle_pathfail() call update_multipath() and
then move the code to manually change the queueing state to
enter_recovery_mode() and leave_recovery_mode(), instead of doing it in
set_no_path_retry().

-Ben

> 
> Regards
> Martin
> 
> > ---
> >  libmultipath/structs_vec.c | 12 +++++++++++-
> >  1 file changed, 11 insertions(+), 1 deletion(-)
> > 
> > diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> > index 0e8a46e7..3cb23c73 100644
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
> >  			enter_recovery_mode(mpp);
> > +		}
> >  		break;
> >  	}
> >  }


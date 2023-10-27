Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5850B3B78B
	for <dm-devel@lists.linux.dev>; Fri, 27 Oct 2023 18:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TmIBMau0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698432849;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WcbLdtBMVfNRRpPWNGfbzY59CACw/V1WnM+i2zakkNc=;
	b=TmIBMau0dUs192oKz9RBfMS8je1ATx3gVqgdo97qO1AcQHCVsy23fBXmjiqktAcj4oaWd4
	aYNTsTdf2lEZkYGJkNs/RJGhmheettVhFPCNGDRwRI+kgHhnvQxkdKQ9VAfsu9GdFVJXT/
	jwOY9MJIaXKis/aR4IHy67hhfklnAPM=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-480-TP7F57QGNsqXMlGuE8Q2ZQ-1; Fri,
 27 Oct 2023 14:54:04 -0400
X-MC-Unique: TP7F57QGNsqXMlGuE8Q2ZQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8689D3C1476E;
	Fri, 27 Oct 2023 18:54:04 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (bmarzins-01.fast.rdu2.eng.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 75043492BFC;
	Fri, 27 Oct 2023 18:54:04 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1) with ESMTPS id 39RIs41w049473
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 27 Oct 2023 14:54:04 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1/Submit) id 39RIs3JI049472;
	Fri, 27 Oct 2023 14:54:03 -0400
Date: Fri, 27 Oct 2023 14:54:03 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 02/14] libmultipath: directio: don't reset ct->running
 after io_cancel()
Message-ID: <ZTwHS4skemthKY9w@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231026174153.1133-1-mwilck@suse.com>
 <20231026174153.1133-3-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20231026174153.1133-3-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 26, 2023 at 07:41:41PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> io_cancel() never succeeds, and even if it did, io_getevents() must
> still be called to reclaim the IO resources from the kernel.
> Don't pretend the opposite by resetting ct->running, or freeing the
> memory, before io_getevents() has indicated that the request is finished.
> 
> In the test code, don't bother about the return value of __wrap_io_cancel().
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/checkers/directio.c | 14 ++++----------
>  tests/directio.c                 | 27 ++-------------------------
>  2 files changed, 6 insertions(+), 35 deletions(-)
> 
> diff --git a/libmultipath/checkers/directio.c b/libmultipath/checkers/directio.c
> index 25b2383..83ab29f 100644
> --- a/libmultipath/checkers/directio.c
> +++ b/libmultipath/checkers/directio.c
> @@ -232,15 +232,15 @@ void libcheck_free (struct checker * c)
>  		}
>  	}
>  
> -	if (ct->running &&
> -	    (ct->req->state != PATH_PENDING ||
> -	     io_cancel(ct->aio_grp->ioctx, &ct->req->io, &event) == 0))
> +	if (ct->running && ct->req->state != PATH_PENDING)
>  		ct->running = 0;
>  	if (!ct->running) {
>  		free(ct->req->buf);
>  		free(ct->req);
>  		ct->aio_grp->holders--;
>  	} else {
> +		/* Currently a no-op */
> +		io_cancel(ct->aio_grp->ioctx, &ct->req->io, &event);
>  		ct->req->state = PATH_REMOVED;
>  		list_add(&ct->req->node, &ct->aio_grp->orphans);
>  		check_orphaned_group(ct->aio_grp);
> @@ -351,13 +351,7 @@ check_state(int fd, struct directio_context *ct, int sync, int timeout_secs)
>  
>  		LOG(3, "abort check on timeout");
>  
> -		r = io_cancel(ct->aio_grp->ioctx, &ct->req->io, &event);
> -		/*
> -		 * Only reset ct->running if we really
> -		 * could abort the pending I/O
> -		 */
> -		if (!r)
> -			ct->running = 0;
> +		io_cancel(ct->aio_grp->ioctx, &ct->req->io, &event);
>  		rc = PATH_DOWN;
>  	} else {
>  		LOG(4, "async io pending");
> diff --git a/tests/directio.c b/tests/directio.c
> index db9643e..5201d21 100644
> --- a/tests/directio.c
> +++ b/tests/directio.c
> @@ -141,10 +141,9 @@ int __real_io_cancel(io_context_t ctx, struct iocb *iocb, struct io_event *evt);
>  int __wrap_io_cancel(io_context_t ctx, struct iocb *iocb, struct io_event *evt)
>  {
>  #ifdef DIO_TEST_DEV
> -	mock_type(int);
>  	return __real_io_cancel(ctx, iocb, evt);
>  #else
> -	return mock_type(int);
> +	return 0;
>  #endif
>  }
>  
> @@ -439,14 +438,8 @@ static void test_check_state_timeout(void **state)
>  	do_libcheck_init(&c, 4096, NULL);
>  	aio_grp = get_aio_grp(&c);
>  	return_io_getevents_none();
> -	will_return(__wrap_io_cancel, 0);
>  	do_check_state(&c, 1, 30, PATH_DOWN);
>  	check_aio_grp(aio_grp, 1, 0);
> -#ifdef DIO_TEST_DEV
> -	/* io_cancel will return negative value on timeout, so it happens again
> -	 * when freeing the checker */
> -	will_return(__wrap_io_cancel, 0);
> -#endif
>  	libcheck_free(&c);
>  	do_libcheck_reset(1);
>  }
> @@ -468,12 +461,8 @@ static void test_check_state_async_timeout(void **state)
>  	return_io_getevents_none();
>  	do_check_state(&c, 0, 3, PATH_PENDING);
>  	return_io_getevents_none();
> -	will_return(__wrap_io_cancel, 0);
>  	do_check_state(&c, 0, 3, PATH_DOWN);
>  	check_aio_grp(aio_grp, 1, 0);
> -#ifdef DIO_TEST_DEV
> -	will_return(__wrap_io_cancel, 0);
> -#endif
>  	libcheck_free(&c);
>  	do_libcheck_reset(1);
>  }
> @@ -501,13 +490,8 @@ static void test_free_with_pending(void **state)
>  	check_aio_grp(aio_grp, 2, 0);
>          libcheck_free(&c[0]);
>  	check_aio_grp(aio_grp, 1, 0);
> -        will_return(__wrap_io_cancel, 0);
>          libcheck_free(&c[1]);
> -#ifdef DIO_TEST_DEV
> -	check_aio_grp(aio_grp, 1, 1); /* real cancel doesn't remove request */
> -#else
> -        check_aio_grp(aio_grp, 0, 0);
> -#endif
> +	check_aio_grp(aio_grp, 1, 1); /* cancel doesn't remove request */
>          do_libcheck_reset(1);
>  }
>  
> @@ -533,7 +517,6 @@ static void test_orphaned_aio_group(void **state)
>  	assert_int_equal(i, 1);
>  	for (i = 0; i < AIO_GROUP_SIZE; i++) {
>  		assert_true(is_checker_running(&c[i]));
> -		will_return(__wrap_io_cancel, -1);
>  		if (i == AIO_GROUP_SIZE - 1) {
>  			/* remove the orphaned group and create a new one */
>  			will_return(__wrap_io_destroy, 0);
> @@ -559,12 +542,10 @@ static void test_timeout_cancel_failed(void **state)
>  		do_libcheck_init(&c[i], 4096, &reqs[i]);
>  	aio_grp = get_aio_grp(c);
>  	return_io_getevents_none();
> -	will_return(__wrap_io_cancel, -1);
>  	do_check_state(&c[0], 1, 30, PATH_DOWN);
>  	assert_true(is_checker_running(&c[0]));
>  	check_aio_grp(aio_grp, 2, 0);
>  	return_io_getevents_none();
> -	will_return(__wrap_io_cancel, -1);
>  	do_check_state(&c[0], 1, 30, PATH_DOWN);
>  	assert_true(is_checker_running(&c[0]));
>  	return_io_getevents_nr(NULL, 1, &reqs[0], &res[0]);
> @@ -600,7 +581,6 @@ static void test_async_timeout_cancel_failed(void **state)
>  	return_io_getevents_none();
>  	do_check_state(&c[1], 0, 2, PATH_PENDING);
>  	return_io_getevents_none();
> -	will_return(__wrap_io_cancel, -1);
>  	do_check_state(&c[0], 0, 2, PATH_DOWN);
>  #ifndef DIO_TEST_DEV
>  	/* can't pick which even gets returned on real devices */
> @@ -608,7 +588,6 @@ static void test_async_timeout_cancel_failed(void **state)
>  	do_check_state(&c[1], 0, 2, PATH_UP);
>  #endif
>  	return_io_getevents_none();
> -	will_return(__wrap_io_cancel, -1);
>  	do_check_state(&c[0], 0, 2, PATH_DOWN);
>  	assert_true(is_checker_running(&c[0]));
>  	return_io_getevents_nr(NULL, 2, reqs, res);
> @@ -637,7 +616,6 @@ static void test_orphan_checker_cleanup(void **state)
>  	aio_grp = get_aio_grp(c);
>  	return_io_getevents_none();
>  	do_check_state(&c[0], 0, 30, PATH_PENDING);
> -	will_return(__wrap_io_cancel, -1);
>  	check_aio_grp(aio_grp, 2, 0);
>  	libcheck_free(&c[0]);
>  	check_aio_grp(aio_grp, 2, 1);
> @@ -662,7 +640,6 @@ static void test_orphan_reset_cleanup(void **state)
>  	orphan_aio_grp = get_aio_grp(&c);
>  	return_io_getevents_none();
>  	do_check_state(&c, 0, 30, PATH_PENDING);
> -	will_return(__wrap_io_cancel, -1);
>  	check_aio_grp(orphan_aio_grp, 1, 0);
>  	libcheck_free(&c);
>  	check_aio_grp(orphan_aio_grp, 1, 1);
> -- 
> 2.42.0


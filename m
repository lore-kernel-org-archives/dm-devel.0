Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A9A266BC
	for <dm-devel@lists.linux.dev>; Wed, 25 Oct 2023 23:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AqIZLTbM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698275668;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9+l93Iym4F5sPJYkjav3Et0Y5rnzzHS94uzLHg8GQxU=;
	b=AqIZLTbMxhbpgeu7Me82xbuVwW3Dc3Kr8f1PEgAv7uqGeA4IPPHBByUZzVVP8Ehzn9Oz/y
	UT2leguz06toX6wMW5NIID5IB3wHhi1I0hiPuFnsboEesRXfFWrN3iZR/jVwlVxZcJY7lI
	CSiB3AuRAzi481A/YlTihi+1fSpfSxg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-490-X6BWeYmAPNOgDvnqMVxUpw-1; Wed, 25 Oct 2023 19:14:24 -0400
X-MC-Unique: X6BWeYmAPNOgDvnqMVxUpw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F382811E7E;
	Wed, 25 Oct 2023 23:14:23 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (bmarzins-01.fast.rdu2.eng.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 874B740C6F79;
	Wed, 25 Oct 2023 23:14:23 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1) with ESMTPS id 39PNENkc032123
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 25 Oct 2023 19:14:23 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1/Submit) id 39PNEN2F032122;
	Wed, 25 Oct 2023 19:14:23 -0400
Date: Wed, 25 Oct 2023 19:14:23 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Miao Guanqin <miaoguanqin@huawei.com>,
        Li Xiao Keng <lixiaokeng@huawei.com>
Subject: Re: [PATCH 2/6] libmultipath: directio: don't reset ct->running
 after io_cancel()
Message-ID: <ZTmhT0FSHv8rLzBv@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231024164937.14684-1-mwilck@suse.com>
 <20231024164937.14684-3-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20231024164937.14684-3-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 24, 2023 at 06:49:33PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> io_cancel() never succeeds, and even if it did, io_getevents() must
> still be called to reclaim the IO resources from the kernel.
> Don't pretend the opposite by resetting ct->running, or freeing the
> memory, before io_getevents() has indicated that the request is finished.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/checkers/directio.c | 13 ++-----------
>  tests/directio.c                 | 10 +---------
>  2 files changed, 3 insertions(+), 20 deletions(-)
> 
> diff --git a/libmultipath/checkers/directio.c b/libmultipath/checkers/directio.c
> index 25b2383..71ce4cb 100644
> --- a/libmultipath/checkers/directio.c
> +++ b/libmultipath/checkers/directio.c
> @@ -216,7 +216,6 @@ out:
>  void libcheck_free (struct checker * c)
>  {
>  	struct directio_context * ct = (struct directio_context *)c->context;
> -	struct io_event event;
>  	long flags;
>  
>  	if (!ct)
> @@ -232,9 +231,7 @@ void libcheck_free (struct checker * c)
>  		}
>  	}
>  
> -	if (ct->running &&
> -	    (ct->req->state != PATH_PENDING ||
> -	     io_cancel(ct->aio_grp->ioctx, &ct->req->io, &event) == 0))

Does io_cancel() do nothing? If does make the IO likely to end sooner,
even if it always returns failure, then we should probably still run it
when we have an outstanding request that we are going to orphan. We
should just move the io_cancel() to the else block, where we add the
request to the orphans list.

Otherwise, this looks good.
-Ben

> +	if (ct->running && ct->req->state != PATH_PENDING)
>  		ct->running = 0;
>  	if (!ct->running) {
>  		free(ct->req->buf);
> @@ -351,13 +348,7 @@ check_state(int fd, struct directio_context *ct, int sync, int timeout_secs)
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
> index db9643e..b340498 100644
> --- a/tests/directio.c
> +++ b/tests/directio.c
> @@ -501,13 +501,8 @@ static void test_free_with_pending(void **state)
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
> @@ -533,7 +528,6 @@ static void test_orphaned_aio_group(void **state)
>  	assert_int_equal(i, 1);
>  	for (i = 0; i < AIO_GROUP_SIZE; i++) {
>  		assert_true(is_checker_running(&c[i]));
> -		will_return(__wrap_io_cancel, -1);
>  		if (i == AIO_GROUP_SIZE - 1) {
>  			/* remove the orphaned group and create a new one */
>  			will_return(__wrap_io_destroy, 0);
> @@ -637,7 +631,6 @@ static void test_orphan_checker_cleanup(void **state)
>  	aio_grp = get_aio_grp(c);
>  	return_io_getevents_none();
>  	do_check_state(&c[0], 0, 30, PATH_PENDING);
> -	will_return(__wrap_io_cancel, -1);
>  	check_aio_grp(aio_grp, 2, 0);
>  	libcheck_free(&c[0]);
>  	check_aio_grp(aio_grp, 2, 1);
> @@ -662,7 +655,6 @@ static void test_orphan_reset_cleanup(void **state)
>  	orphan_aio_grp = get_aio_grp(&c);
>  	return_io_getevents_none();
>  	do_check_state(&c, 0, 30, PATH_PENDING);
> -	will_return(__wrap_io_cancel, -1);
>  	check_aio_grp(orphan_aio_grp, 1, 0);
>  	libcheck_free(&c);
>  	check_aio_grp(orphan_aio_grp, 1, 1);
> -- 
> 2.42.0


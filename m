Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A1E266BC
	for <dm-devel@lists.linux.dev>; Wed, 25 Oct 2023 23:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZILNlvJN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698276806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EHtA5MSAZIkKs/AEOj07EU4ZDqy94JNtpkW7L/gv8ik=;
	b=ZILNlvJNQuh6BcJBToU1R0GNWrVYyXqgi3u8AGymP9Pt7cUuuGWOW00Psaufm0FLKeMuPx
	CGBnSkMHSiLzqP0wQPZ7dfeWR4P2AO4/dgHqJRHkIQhOBZvFQVLEHml/F89acTD0g+rgQn
	BWxgFq+l9l4tx4kkRFqyUQvG+5kqS+8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-201-a1xxNSF-MGCyStwY7YXbmg-1; Wed,
 25 Oct 2023 19:33:24 -0400
X-MC-Unique: a1xxNSF-MGCyStwY7YXbmg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B058F28237C3;
	Wed, 25 Oct 2023 23:33:23 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (bmarzins-01.fast.rdu2.eng.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B743492BE8;
	Wed, 25 Oct 2023 23:33:23 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1) with ESMTPS id 39PNXNbe032240
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 25 Oct 2023 19:33:23 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1/Submit) id 39PNXNWZ032239;
	Wed, 25 Oct 2023 19:33:23 -0400
Date: Wed, 25 Oct 2023 19:33:23 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Miao Guanqin <miaoguanqin@huawei.com>,
        Li Xiao Keng <lixiaokeng@huawei.com>
Subject: Re: [PATCH 3/6] libmultipath: io_err_stat: don't free aio memory
 before completion
Message-ID: <ZTmlwx5VYxwexaVd@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231024164937.14684-1-mwilck@suse.com>
 <20231024164937.14684-4-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20231024164937.14684-4-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 24, 2023 at 06:49:34PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> It is wrong to assume that aio data structures can be reused or freed
> after io_cancel(). io_cancel() will almost always return -EINPROGRESS,
> anyway. Use the io_starttime field to indicate whether an io event
> has been completed by the kernel. Make sure no in-flight buffers are freed.

There's a minor issue I mention below, but the bigger issue I noticed
isn't related to your fix.  It's that, unless I'm missing something,
we're not using libaio correctly in this code.  We call io_setup() to
allow CONCUR_NR_EVENT concurrent requests. But we could have up to
CONCUR_NR_EVENT * number_of_delayed_paths concurrent requests. The
easiest fix is to create an ioctx per delayed path. However this would
mean calling io_destroy() after each round of testings, which could
potentially stall this thread.
 
> Fixes https://github.com/opensvc/multipath-tools/issues/73.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> Cc: Li Xiao Keng <lixiaokeng@huawei.com>
> Cc: Miao Guanqin <miaoguanqin@huawei.com>
> ---
>  libmultipath/io_err_stat.c | 26 ++++++++++++++++----------
>  1 file changed, 16 insertions(+), 10 deletions(-)
> 
> diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
> index dc1c252..c474c34 100644
> --- a/libmultipath/io_err_stat.c
> +++ b/libmultipath/io_err_stat.c
> @@ -111,10 +111,14 @@ static int init_each_dio_ctx(struct dio_ctx *ct, int blksize,
>  	return 0;
>  }
>  
> -static void deinit_each_dio_ctx(struct dio_ctx *ct)
> +static int deinit_each_dio_ctx(struct dio_ctx *ct)
>  {
> -	if (ct->buf)
> -		free(ct->buf);
> +	if (!ct->buf)
> +		return 0;
> +	if (ct->io_starttime.tv_sec != 0 || ct->io_starttime.tv_nsec != 0)
> +		return 1;
> +	free(ct->buf);
> +	return 0;
>  }
>  
>  static int setup_directio_ctx(struct io_err_stat_path *p)
> @@ -164,6 +168,7 @@ fail_close:
>  static void free_io_err_stat_path(struct io_err_stat_path *p)
>  {
>  	int i;
> +	int inflight = 0;
>  
>  	if (!p)
>  		return;
> @@ -173,8 +178,13 @@ static void free_io_err_stat_path(struct io_err_stat_path *p)
>  	cancel_inflight_io(p);

There's not much point in calling cancel_inflight_io() here, since since
we don't try to handle the done events afterwards, is there? If there
are unhandled ones, they will remain unhandled, and we will end up
leaking memory regardless of whether or not they're cancelled.

-Ben

>  	for (i = 0; i < CONCUR_NR_EVENT; i++)
> -		deinit_each_dio_ctx(p->dio_ctx_array + i);
> -	free(p->dio_ctx_array);
> +		inflight += deinit_each_dio_ctx(p->dio_ctx_array + i);
> +
> +	if (!inflight)
> +		free(p->dio_ctx_array);
> +	else
> +		io_err_stat_log(2, "%s: can't free aio space of %s, %d IOs in flight",
> +				__func__, p->devname, inflight);
>  
>  	if (p->fd > 0)
>  		close(p->fd);
> @@ -503,7 +513,7 @@ static int try_to_cancel_timeout_io(struct dio_ctx *ct, struct timespec *t,
>  	int		rc = PATH_UNCHECKED;
>  	int		r;
>  
> -	if (ct->io_starttime.tv_sec == 0)
> +	if (ct->io_starttime.tv_sec == 0 && ct->io_starttime.tv_nsec == 0)
>  		return rc;
>  	timespecsub(t, &ct->io_starttime, &difftime);
>  	if (difftime.tv_sec > IOTIMEOUT_SEC) {
> @@ -514,8 +524,6 @@ static int try_to_cancel_timeout_io(struct dio_ctx *ct, struct timespec *t,
>  		if (r)
>  			io_err_stat_log(5, "%s: io_cancel error %i",
>  					dev, errno);
> -		ct->io_starttime.tv_sec = 0;
> -		ct->io_starttime.tv_nsec = 0;
>  		rc = PATH_TIMEOUT;
>  	} else {
>  		rc = PATH_PENDING;
> @@ -559,8 +567,6 @@ static void cancel_inflight_io(struct io_err_stat_path *pp)
>  		if (r)
>  			io_err_stat_log(5, "%s: io_cancel error %d, %i",
>  					pp->devname, r, errno);
> -		ct->io_starttime.tv_sec = 0;
> -		ct->io_starttime.tv_nsec = 0;
>  	}
>  }
>  
> -- 
> 2.42.0


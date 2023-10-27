Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801DD3AC21
	for <dm-devel@lists.linux.dev>; Fri, 27 Oct 2023 18:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bjk7jZzo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698432968;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qRFeVqqzZbnGbWE70p+PdLFOc9bX+UPpkI5xBklaJkE=;
	b=bjk7jZzo/tV0WBtyeudrgWSthKlH70RD5JlclnIdrxHZPN+JRVG2d5MczqkR1Hdo17SMWm
	UAYmLkowgGyhDoK9L8YglAX/EfTTUbCNEX/KYjVOdKq8SghAb8H9keyFB1BwAEKyV3jhEF
	e7oYyuFQAxn/LOCeiWlcm9pXB/A8iKg=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-279-mE4YV2bmMKirjQkUOeL4eA-1; Fri,
 27 Oct 2023 14:55:52 -0400
X-MC-Unique: mE4YV2bmMKirjQkUOeL4eA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6EAB53816B4C;
	Fri, 27 Oct 2023 18:55:52 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (bmarzins-01.fast.rdu2.eng.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 659982026D4C;
	Fri, 27 Oct 2023 18:55:52 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1) with ESMTPS id 39RItqH7049500
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 27 Oct 2023 14:55:52 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1/Submit) id 39RItqeg049499;
	Fri, 27 Oct 2023 14:55:52 -0400
Date: Fri, 27 Oct 2023 14:55:52 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Li Xiao Keng <lixiaokeng@huawei.com>,
        Miao Guanqin <miaoguanqin@huawei.com>,
        Guan Junxiong <guanjunxiong@huawei.com>
Subject: Re: [PATCH v2 05/14] libmultipath: io_err_stat: call io_destroy()
 inside free_io_err_pathvec()
Message-ID: <ZTwHuLNj2AudCe3O@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231026174153.1133-1-mwilck@suse.com>
 <20231026174153.1133-6-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20231026174153.1133-6-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 26, 2023 at 07:41:44PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Memory used by aio iocbs must not be freed before either all iocbs
> have finished, or io_destroy() has been called (which will wait until
> all iocbs have finished).
> 
> Don't call cancel_inflight_io() from free_io_err_stat_path(). Rather,
> cancel directly from free_io_err_pathvec(). This way we make sure that
> we can't call io_cancel() with an already destroyed ioctx, and that
> we don't free memory of in-flight requests.
> 
> The other callers of free_io_err_stat_path() also don't need to call
> cancel_inflight_io(). In service_paths(), where free_io_err_stat_path()
> it is called for paths on which all IO has either finished or timed out,
> hanging requests will already have been cancelled in the
> try_to_cancel_timeout_io() code path (note that total_time is at least
> 2 * IO_TIMEOUT_SEC). In the failure case of enqueue_io_err_stat_by_path(), no
> IO has been submitted yet.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Li Xiao Keng <lixiaokeng@huawei.com>
> Cc: Miao Guanqin <miaoguanqin@huawei.com>
> Cc: Guan Junxiong <guanjunxiong@huawei.com>
> ---
>  libmultipath/io_err_stat.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
> index c474c34..3f32e32 100644
> --- a/libmultipath/io_err_stat.c
> +++ b/libmultipath/io_err_stat.c
> @@ -175,8 +175,6 @@ static void free_io_err_stat_path(struct io_err_stat_path *p)
>  	if (!p->dio_ctx_array)
>  		goto free_path;
>  
> -	cancel_inflight_io(p);
> -
>  	for (i = 0; i < CONCUR_NR_EVENT; i++)
>  		inflight += deinit_each_dio_ctx(p->dio_ctx_array + i);
>  
> @@ -221,6 +219,15 @@ static void free_io_err_pathvec(void)
>  	pthread_cleanup_push(cleanup_mutex, &io_err_pathvec_lock);
>  	if (!io_err_pathvec)
>  		goto out;
> +
> +	/* io_cancel() is a noop, but maybe in the future it won't be */
> +	vector_foreach_slot(io_err_pathvec, path, i) {
> +		if (path && path->dio_ctx_array)
> +			cancel_inflight_io(path);
> +	}
> +
> +	/* This blocks until all I/O is finished */
> +	io_destroy(ioctx);
>  	vector_foreach_slot(io_err_pathvec, path, i)
>  		free_io_err_stat_path(path);
>  	vector_free(io_err_pathvec);
> @@ -752,5 +759,4 @@ void stop_io_err_stat_thread(void)
>  
>  	pthread_join(io_err_stat_thr, NULL);
>  	free_io_err_pathvec();
> -	io_destroy(ioctx);
>  }
> -- 
> 2.42.0


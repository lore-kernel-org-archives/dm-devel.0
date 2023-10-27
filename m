Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9C0374C5
	for <dm-devel@lists.linux.dev>; Fri, 27 Oct 2023 18:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hiQtPijM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698432895;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y/KjekG30NYxvDWUXI+4G0QAbey0kOdKkyuI4PouNhk=;
	b=hiQtPijMpaDD8ZYJIRxFWEc26MiZSHDlVs+458+xsyv/qb0zuiWctDzhkXgQQinmVyXfCE
	dsuiPoLwMDlUxrncizVxWZPd8AZ4swna3OzAPMd3z238sT5SEKX4v59Owe4ExNTZ1zUqJy
	k0vO/VWF8rnzv8rMUMaKrvbQEUFmLiA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-380-dDSpsIXfMqSJcztliwpKzQ-1; Fri, 27 Oct 2023 14:54:53 -0400
X-MC-Unique: dDSpsIXfMqSJcztliwpKzQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6DF8D101A54C;
	Fri, 27 Oct 2023 18:54:53 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (bmarzins-01.fast.rdu2.eng.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 672F3492BFC;
	Fri, 27 Oct 2023 18:54:53 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1) with ESMTPS id 39RIsrSA049483
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 27 Oct 2023 14:54:53 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1/Submit) id 39RIsrUj049482;
	Fri, 27 Oct 2023 14:54:53 -0400
Date: Fri, 27 Oct 2023 14:54:53 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH v2 03/14] libmultipath: directio: fix error handling
Message-ID: <ZTwHfWZfs2LNkEaZ@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231026174153.1133-1-mwilck@suse.com>
 <20231026174153.1133-4-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20231026174153.1133-4-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 26, 2023 at 07:41:42PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> libaio uses a different error return convention than glibc. The error code is
> not returned in errno, but as the negated return value of the function.
> Adapt the directio checker code.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/checkers/directio.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/libmultipath/checkers/directio.c b/libmultipath/checkers/directio.c
> index 83ab29f..12b8be4 100644
> --- a/libmultipath/checkers/directio.c
> +++ b/libmultipath/checkers/directio.c
> @@ -70,6 +70,7 @@ static struct aio_group *
>  add_aio_group(void)
>  {
>  	struct aio_group *aio_grp;
> +	int rc;
>  
>  	aio_grp = malloc(sizeof(struct aio_group));
>  	if (!aio_grp)
> @@ -77,9 +78,9 @@ add_aio_group(void)
>  	memset(aio_grp, 0, sizeof(struct aio_group));
>  	INIT_LIST_HEAD(&aio_grp->orphans);
>  
> -	if (io_setup(AIO_GROUP_SIZE, &aio_grp->ioctx) != 0) {
> +	if ((rc = io_setup(AIO_GROUP_SIZE, &aio_grp->ioctx)) != 0) {
>  		LOG(1, "io_setup failed");
> -		if (errno == EAGAIN)
> +		if (rc == -EAGAIN)
>  			LOG(1, "global number of io events too small. Increase fs.aio-max-nr with sysctl");
>  		free(aio_grp);
>  		return NULL;
> @@ -259,7 +260,6 @@ get_events(struct aio_group *aio_grp, struct timespec *timeout)
>  	struct timespec *timep = timeout;
>  
>  	do {
> -		errno = 0;
>  		nr = io_getevents(aio_grp->ioctx, 1, 128, events, timep);
>  		got_events |= (nr > 0);
>  
> @@ -283,8 +283,7 @@ get_events(struct aio_group *aio_grp, struct timespec *timeout)
>  	} while (nr == 128); /* assume there are more events and try again */
>  
>  	if (nr < 0)
> -		LOG(4, "async io getevents returned %i (errno=%s)",
> -		    nr, strerror(errno));
> +		LOG(4, "async io getevents returned %s", strerror(-nr));
>  
>  	return got_events;
>  }
> @@ -320,8 +319,8 @@ check_state(int fd, struct directio_context *ct, int sync, int timeout_secs)
>  		io_prep_pread(&ct->req->io, fd, ct->req->buf,
>  			      ct->req->blksize, 0);
>  		ct->req->state = PATH_PENDING;
> -		if (io_submit(ct->aio_grp->ioctx, 1, ios) != 1) {
> -			LOG(3, "io_submit error %i", errno);
> +		if ((rc = io_submit(ct->aio_grp->ioctx, 1, ios)) != 1) {
> +			LOG(3, "io_submit error %i", -rc);
>  			return PATH_UNCHECKED;
>  		}
>  	}
> -- 
> 2.42.0


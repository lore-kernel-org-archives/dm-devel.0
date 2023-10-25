Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AAA3347CF
	for <dm-devel@lists.linux.dev>; Wed, 25 Oct 2023 23:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H2r8cuV0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698275436;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4FoLkBnziWBnUKGsjtAZ2fT4CtQYcTfXACY6e2+I0ag=;
	b=H2r8cuV0SCPRBh6UHrxyCJqAT0y65p8gQi6ijcrcQbyNKSSM33kEScUpgyjImQfJ/2Mo8v
	V5cEiCKvEU2/3K7ViNdpmakv87Fr6kpTlRth++35fM9sD7kCsennuJqCFK9UQSsfhfWnrt
	yK3yb3Xlv5/cXazIzazcXbPr4Jw77uc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-447-n68U0TR2O16PtEJLQh4rLg-1; Wed, 25 Oct 2023 19:10:33 -0400
X-MC-Unique: n68U0TR2O16PtEJLQh4rLg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B49AD185A782;
	Wed, 25 Oct 2023 23:10:32 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (bmarzins-01.fast.rdu2.eng.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7014A1C060AE;
	Wed, 25 Oct 2023 23:10:32 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1) with ESMTPS id 39PNAWPZ032102
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 25 Oct 2023 19:10:32 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1/Submit) id 39PNAV9i032101;
	Wed, 25 Oct 2023 19:10:31 -0400
Date: Wed, 25 Oct 2023 19:10:31 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Miao Guanqin <miaoguanqin@huawei.com>,
        Li Xiao Keng <lixiaokeng@huawei.com>
Subject: Re: [PATCH 1/6] libmultipath: reduce log level of directio messages
Message-ID: <ZTmgZ66vcint3fe9@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231024164937.14684-1-mwilck@suse.com>
 <20231024164937.14684-2-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20231024164937.14684-2-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 24, 2023 at 06:49:32PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> The directio checker logs too much at verbosity 3.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/checkers/directio.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/libmultipath/checkers/directio.c b/libmultipath/checkers/directio.c
> index 2f3ece0..25b2383 100644
> --- a/libmultipath/checkers/directio.c
> +++ b/libmultipath/checkers/directio.c
> @@ -266,7 +266,7 @@ get_events(struct aio_group *aio_grp, struct timespec *timeout)
>  		for (i = 0; i < nr; i++) {
>  			struct async_req *req = container_of(events[i].obj, struct async_req, io);
>  
> -			LOG(3, "io finished %lu/%lu", events[i].res,
> +			LOG(4, "io finished %lu/%lu", events[i].res,
>  			    events[i].res2);
>  
>  			/* got an orphaned request */
> @@ -283,7 +283,7 @@ get_events(struct aio_group *aio_grp, struct timespec *timeout)
>  	} while (nr == 128); /* assume there are more events and try again */
>  
>  	if (nr < 0)
> -		LOG(3, "async io getevents returned %i (errno=%s)",
> +		LOG(4, "async io getevents returned %i (errno=%s)",
>  		    nr, strerror(errno));
>  
>  	return got_events;
> @@ -315,7 +315,7 @@ check_state(int fd, struct directio_context *ct, int sync, int timeout_secs)
>  	} else {
>  		struct iocb *ios[1] = { &ct->req->io };
>  
> -		LOG(3, "starting new request");
> +		LOG(4, "starting new request");
>  		memset(&ct->req->io, 0, sizeof(struct iocb));
>  		io_prep_pread(&ct->req->io, fd, ct->req->buf,
>  			      ct->req->blksize, 0);
> @@ -360,7 +360,7 @@ check_state(int fd, struct directio_context *ct, int sync, int timeout_secs)
>  			ct->running = 0;
>  		rc = PATH_DOWN;
>  	} else {
> -		LOG(3, "async io pending");
> +		LOG(4, "async io pending");
>  		rc = PATH_PENDING;
>  	}
>  
> -- 
> 2.42.0


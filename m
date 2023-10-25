Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E51E381DC
	for <dm-devel@lists.linux.dev>; Wed, 25 Oct 2023 23:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IdHzIKX0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698277243;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vG2k+CC98dBPYD5hq9WUSUxs98edOBEktivx/KTpgWo=;
	b=IdHzIKX0PjeT7UimHvRxNL8bGgA7bp2jartMefWZpk27OFzlpLKKnvtT4y15lckLg9Oign
	rOXK9n2tknmAvQZp967+V9v0oAbZCyabdfOgTsVhEzTDZVJOpP4WU2SYgRQYDaaY9YKaO3
	k+HXiyfvVcC2xhP5FErlDc/boMcv++M=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-377-QZnDGS6gNBK1cQBgYrOTZQ-1; Wed,
 25 Oct 2023 19:40:37 -0400
X-MC-Unique: QZnDGS6gNBK1cQBgYrOTZQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7C8C51C0BB40;
	Wed, 25 Oct 2023 23:40:37 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (bmarzins-01.fast.rdu2.eng.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 75CBB2026D4C;
	Wed, 25 Oct 2023 23:40:37 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1) with ESMTPS id 39PNebhl032307
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 25 Oct 2023 19:40:37 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1/Submit) id 39PNebnP032306;
	Wed, 25 Oct 2023 19:40:37 -0400
Date: Wed, 25 Oct 2023 19:40:37 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Miao Guanqin <miaoguanqin@huawei.com>,
        Li Xiao Keng <lixiaokeng@huawei.com>
Subject: Re: [PATCH 4/6] libmultipath: io_err_stat: call io_destroy() before
 free_io_err_pathvec()
Message-ID: <ZTmndaVlQd/agcUv@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231024164937.14684-1-mwilck@suse.com>
 <20231024164937.14684-5-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20231024164937.14684-5-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 24, 2023 at 06:49:35PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/io_err_stat.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
> index c474c34..1982915 100644
> --- a/libmultipath/io_err_stat.c
> +++ b/libmultipath/io_err_stat.c
> @@ -751,6 +751,6 @@ void stop_io_err_stat_thread(void)
>  		pthread_cancel(io_err_stat_thr);
>  
>  	pthread_join(io_err_stat_thr, NULL);
> -	free_io_err_pathvec();
>  	io_destroy(ioctx);
> +	free_io_err_pathvec();

This looks to me like another reason why we don't want the
cancel_inflight_io() function in free_io_err_stat_path(). I don't think
it's valid to call io_cancel(), which cancel_inflight_io() does, after
you call io_destroy().

-Ben

>  }
> -- 
> 2.42.0


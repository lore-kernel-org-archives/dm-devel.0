Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D30638DCF
	for <dm-devel@lists.linux.dev>; Fri, 27 Oct 2023 18:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ApsLRDJo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698432984;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Qx7Q+WrwWEyiS65Sr+ZlBOxBNx96yodSL59tEI7deMU=;
	b=ApsLRDJouYVeuzmG+YsLnEnotVnBWUlJgcTF6IUHbOAJS1YESFnGuCuubnbSu9TpK3UUJU
	Ls1v6EBD7wsVnjMy3ewaj0+LeRvaE+jaQP/QktlA7L7gvO7PK6KelQl8uqS+hsTXL1En1j
	umjwFtVlzcLjBjUE9nA0ERAqkDfA1fA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-Rn-ONTEHNIGBQ2HVNRn5iQ-1; Fri, 27 Oct 2023 14:56:21 -0400
X-MC-Unique: Rn-ONTEHNIGBQ2HVNRn5iQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0AD6485C1A0;
	Fri, 27 Oct 2023 18:56:21 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (bmarzins-01.fast.rdu2.eng.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 02E931C060AE;
	Fri, 27 Oct 2023 18:56:21 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1) with ESMTPS id 39RIuKvF049511
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 27 Oct 2023 14:56:20 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1/Submit) id 39RIuKun049510;
	Fri, 27 Oct 2023 14:56:20 -0400
Date: Fri, 27 Oct 2023 14:56:20 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Li Xiao Keng <lixiaokeng@huawei.com>,
        Miao Guanqin <miaoguanqin@huawei.com>,
        Guan Junxiong <guanjunxiong@huawei.com>
Subject: Re: [PATCH v2 06/14] libmultipath: io_err_stat: use higher number of
 aio slots
Message-ID: <ZTwH1OqMAGeXhZ+Z@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231026174153.1133-1-mwilck@suse.com>
 <20231026174153.1133-7-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20231026174153.1133-7-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 26, 2023 at 07:41:45PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Currently the number of iocbs per path to test is the same as the
> total number of iocbs in the ioctx. This can easily cause iocb
> starvation, in particular if some IOs are hanging. In that case
> io_submit() will fail, and some paths under test will use much
> less IOs as intended, or in the worst case, none at all.
> 
> The total number of iocbs reserved in the kernel should be higher.
> With this patch, we will be able to run the marginal path test for
> at least NR_IOSTAT_PATHS=32 paths at the same time. This is not an upper
> limit, because kernel IOCBs can be reused between paths.
> 
> Increase the log levels of io_setup and io_submit to make it sure
> we catch problems with this approach.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Li Xiao Keng <lixiaokeng@huawei.com>
> Cc: Miao Guanqin <miaoguanqin@huawei.com>
> Cc: Guan Junxiong <guanjunxiong@huawei.com>
> ---
>  libmultipath/io_err_stat.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
> index 3f32e32..5749003 100644
> --- a/libmultipath/io_err_stat.c
> +++ b/libmultipath/io_err_stat.c
> @@ -38,6 +38,7 @@
>  #define TIMEOUT_NO_IO_NSEC		10000000 /*10ms = 10000000ns*/
>  #define FLAKY_PATHFAIL_THRESHOLD	2
>  #define CONCUR_NR_EVENT			32
> +#define NR_IOSTAT_PATHS			32
>  
>  #define PATH_IO_ERR_IN_CHECKING		-1
>  #define PATH_IO_ERR_WAITING_TO_CHECK	-2
> @@ -477,7 +478,7 @@ static int send_each_async_io(struct dio_ctx *ct, int fd, char *dev)
>  		get_monotonic_time(&ct->io_starttime);
>  		io_prep_pread(&ct->io, fd, ct->buf, ct->blksize, 0);
>  		if (io_submit(ioctx, 1, ios) != 1) {
> -			io_err_stat_log(5, "%s: io_submit error %i",
> +			io_err_stat_log(2, "%s: io_submit error %i",
>  					dev, errno);
>  			return rc;
>  		}
> @@ -703,8 +704,8 @@ int start_io_err_stat_thread(void *data)
>  	if (uatomic_read(&io_err_thread_running) == 1)
>  		return 0;
>  
> -	if (io_setup(CONCUR_NR_EVENT, &ioctx) != 0) {
> -		io_err_stat_log(4, "io_setup failed");
> +	if (io_setup(CONCUR_NR_EVENT * NR_IOSTAT_PATHS, &ioctx) != 0) {
> +		io_err_stat_log(1, "io_setup failed - increase /proc/sys/fs/aio-nr ?");
>  		return 1;
>  	}
>  
> -- 
> 2.42.0


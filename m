Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CFE318C2E
	for <dm-devel@lists.linux.dev>; Fri, 27 Oct 2023 19:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Nh9bbXz7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698433755;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vj3gg5FiZMYyAMBddamD8tpO5vdlszGXb8Q71twnfFI=;
	b=Nh9bbXz7kQe7/w5EpJOLxkSp9Qm6KXZOsB0/VNcdeSMQt/3ZgWK4znuW7KYzcXgzlhKHAC
	i4WLdQhuNuHIU44ktOPj3FJZC3N7zd+7kCkqlhji61ospQMIEy8dWvO0NVOTBfalCDNci9
	7+OKJp64yJVYfDOFsD1ihuXqCQ0IkNk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-12-JAvnRMN_OmuDfQ5id-iaEw-1; Fri, 27 Oct 2023 15:09:14 -0400
X-MC-Unique: JAvnRMN_OmuDfQ5id-iaEw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 12430862CA3;
	Fri, 27 Oct 2023 19:09:14 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (bmarzins-01.fast.rdu2.eng.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C8245027;
	Fri, 27 Oct 2023 19:09:14 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1) with ESMTPS id 39RJ9D43049614
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 27 Oct 2023 15:09:13 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1/Submit) id 39RJ9DsN049613;
	Fri, 27 Oct 2023 15:09:13 -0400
Date: Fri, 27 Oct 2023 15:09:13 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH v2 07/14] libmultipath: io_err_stat: fix error handling
Message-ID: <ZTwK2e59eDaKxxvX@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231026174153.1133-1-mwilck@suse.com>
 <20231026174153.1133-8-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20231026174153.1133-8-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 26, 2023 at 07:41:46PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> libaio uses a different error return convention than glibc. The error code is
> not returned in errno, but as the negated return value of the function.
> Adapt the error handling code in io_err_stat.c. Don't print an error message
> for failure of io_cancel(), which always returns -EINPRPOGRESS.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/io_err_stat.c | 36 ++++++++++++++++--------------------
>  1 file changed, 16 insertions(+), 20 deletions(-)
> 
> diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
> index 5749003..1c59445 100644
> --- a/libmultipath/io_err_stat.c
> +++ b/libmultipath/io_err_stat.c
> @@ -19,7 +19,6 @@
>  #include <sys/ioctl.h>
>  #include <linux/fs.h>
>  #include <libaio.h>
> -#include <errno.h>
>  #include <sys/mman.h>
>  #include <sys/select.h>
>  
> @@ -469,7 +468,7 @@ static void end_io_err_stat(struct io_err_stat_path *pp)
>  
>  static int send_each_async_io(struct dio_ctx *ct, int fd, char *dev)
>  {
> -	int rc = -1;
> +	int rc;
>  
>  	if (ct->io_starttime.tv_nsec == 0 &&
>  			ct->io_starttime.tv_sec == 0) {
> @@ -477,15 +476,15 @@ static int send_each_async_io(struct dio_ctx *ct, int fd, char *dev)
>  
>  		get_monotonic_time(&ct->io_starttime);
>  		io_prep_pread(&ct->io, fd, ct->buf, ct->blksize, 0);
> -		if (io_submit(ioctx, 1, ios) != 1) {
> -			io_err_stat_log(2, "%s: io_submit error %i",
> -					dev, errno);
> -			return rc;
> +		if ((rc = io_submit(ioctx, 1, ios)) != 1) {
> +			io_err_stat_log(2, "%s: io_submit error %s",
> +					dev, strerror(-rc));
> +			return -1;
>  		}
> -		rc = 0;
> +		return 0;
>  	}
>  
> -	return rc;
> +	return -1;
>  }
>  
>  static void send_batch_async_ios(struct io_err_stat_path *pp)
> @@ -530,8 +529,8 @@ static int try_to_cancel_timeout_io(struct dio_ctx *ct, struct timespec *t,
>  		io_err_stat_log(5, "%s: abort check on timeout", dev);
>  		r = io_cancel(ioctx, ios[0], &event);
>  		if (r)
> -			io_err_stat_log(5, "%s: io_cancel error %i",
> -					dev, errno);
> +			io_err_stat_log(5, "%s: io_cancel error %s",
> +					dev, strerror(-r));
>  		rc = PATH_TIMEOUT;
>  	} else {
>  		rc = PATH_PENDING;
> @@ -560,7 +559,7 @@ static void poll_async_io_timeout(void)
>  static void cancel_inflight_io(struct io_err_stat_path *pp)
>  {
>  	struct io_event event;
> -	int i, r;
> +	int i;
>  
>  	for (i = 0; i < CONCUR_NR_EVENT; i++) {
>  		struct dio_ctx *ct = pp->dio_ctx_array + i;
> @@ -571,10 +570,7 @@ static void cancel_inflight_io(struct io_err_stat_path *pp)
>  			continue;
>  		io_err_stat_log(5, "%s: abort infligh io",
>  				pp->devname);
> -		r = io_cancel(ioctx, ios[0], &event);
> -		if (r)
> -			io_err_stat_log(5, "%s: io_cancel error %d, %i",
> -					pp->devname, r, errno);
> +		io_cancel(ioctx, ios[0], &event);
>  	}
>  }
>  
> @@ -610,12 +606,11 @@ static void process_async_ios_event(int timeout_nsecs, char *dev)
>  	int		i, n;
>  	struct timespec	timeout = { .tv_nsec = timeout_nsecs };
>  
> -	errno = 0;
>  	pthread_testcancel();
>  	n = io_getevents(ioctx, 1L, CONCUR_NR_EVENT, events, &timeout);
>  	if (n < 0) {
> -		io_err_stat_log(3, "%s: async io events returned %d (errno=%s)",
> -				dev, n, strerror(errno));
> +		io_err_stat_log(3, "%s: io_getevents returned %s",
> +				dev, strerror(-n));
>  	} else {
>  		for (i = 0; i < n; i++)
>  			handle_async_io_done_event(&events[i]);
> @@ -704,8 +699,9 @@ int start_io_err_stat_thread(void *data)
>  	if (uatomic_read(&io_err_thread_running) == 1)
>  		return 0;
>  
> -	if (io_setup(CONCUR_NR_EVENT * NR_IOSTAT_PATHS, &ioctx) != 0) {
> -		io_err_stat_log(1, "io_setup failed - increase /proc/sys/fs/aio-nr ?");
> +	if ((ret = io_setup(NR_IOSTAT_PATHS * CONCUR_NR_EVENT, &ioctx)) != 0) {
> +		io_err_stat_log(1, "io_setup failed: %s, increase /proc/sys/fs/aio-nr ?",
> +				strerror(-ret));
>  		return 1;
>  	}
>  
> -- 
> 2.42.0


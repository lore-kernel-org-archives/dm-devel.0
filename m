Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5573242C3
	for <dm-devel@lists.linux.dev>; Mon, 24 Nov 2025 19:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764013171; cv=none; b=pLWHalcYTGhmILsrDxGj29wBcOyMr9iBfyQBIvk5Rv244j38mfgGefau8v2B46xCFrnD3HXp7QLf/8CGpPM8SKbY3Y7n/90oQ2XJ5T0yzYMHpEfAp7uxHjjg4PaAW3ek/fMM408TXqFnQLDitkqhsEhv93CytEh28PS9F8kra0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764013171; c=relaxed/simple;
	bh=C5pUezC1fDyepHaLEsHsAt4LFbtDSU8kfG6zlv4POQc=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=DOqfug0c0zxu4orTMQT+Kp6Dpii2N8FV++ByuCwLKiggyAQjI9c82XdRne7TZeiR0TVvYCIsJsZZGBtmxVjESPdEKi/KbiTr/ZB5BCUHnws8BPnlW+ktfT5Dwmvw7fClTivNd0IAyHEDyu9ZP1MTRmQKGjBGvhjsxIltbNgbCxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Dp3IIA7h; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dp3IIA7h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764013162;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ckWek2C+XbEZLNpGVgkpJw0Ke/hJFFUN3rnFvujc6Yc=;
	b=Dp3IIA7hYMpIZ32A67NC2JlTVEGqC61tu07OduGSV0Qdf78zCA0c4iKikBiJa1cz6DVbyM
	M8to6EI0E4/Hmxs9/fLKiJLjn6lYMigcuiuQ6pvs+8VKLsVDJWJNqdvcpKP7GFkBqtaWyS
	5aaA3o6xv0E/zi5CCgNjzDT2IT85KXQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-605--owpb5iQOpOnsFfEed4SEQ-1; Mon,
 24 Nov 2025 14:39:19 -0500
X-MC-Unique: -owpb5iQOpOnsFfEed4SEQ-1
X-Mimecast-MFC-AGG-ID: -owpb5iQOpOnsFfEed4SEQ_1764013158
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1065A19560B7;
	Mon, 24 Nov 2025 19:39:18 +0000 (UTC)
Received: from [10.44.33.72] (unknown [10.44.33.72])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 77C8B3003761;
	Mon, 24 Nov 2025 19:39:16 +0000 (UTC)
Date: Mon, 24 Nov 2025 20:39:11 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
cc: Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev, 
    Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH] dm-mpath: Simplify the setup_scsi_dh code
In-Reply-To: <20251121234952.1035078-1-bmarzins@redhat.com>
Message-ID: <a1235298-f466-56fe-e919-53c9929eab15@redhat.com>
References: <20251121234952.1035078-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tzvdEdhT8HXNoH8X6JEP6mNiNSq4UMjb23YdScC2hl8_1764013158
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Accepted for the upcoming merge window, thanks.

Mikulas


On Fri, 21 Nov 2025, Benjamin Marzinski wrote:

> There's no point to the MPATHF_RETAIN_ATTACHED_HW_HANDLER flag any more.
> The way setup_scsi_dh() worked, if that flag wasn't set, it would
> attempt to attach any passed in hardware handler. This would always fail
> if a different hardware handler was attached, which caused
> setup_scsi_dh() to rerun as if the flag was set. So the code would
> already retain any attached handler, because attaching a different one
> would always fail.
> 
> Also, the code had a bug. If attached_handler_name was NULL but there
> was a scsi device handler attached (because either
> scsi_dh_attached_handler_name failed() to allocate a name, a handler got
> attached after it was called) the code would loop endlessly.
> 
> Instead, ignore MPATHF_RETAIN_ATTACHED_HW_HANDLER, and always free the
> passed in handler if *attached_handler_name is set. This simplifies the
> code, and avoids the endless loop bug, while keeping the functionality
> the same.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  drivers/md/dm-mpath.c | 61 ++++++++++++++++---------------------------
>  1 file changed, 23 insertions(+), 38 deletions(-)
> 
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index 5dd90b2cdb9b..c18358271618 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -131,7 +131,7 @@ static void queue_if_no_path_timeout_work(struct timer_list *t);
>  #define MPATHF_QUEUE_IO 0			/* Must we queue all I/O? */
>  #define MPATHF_QUEUE_IF_NO_PATH 1		/* Queue I/O if last path fails? */
>  #define MPATHF_SAVED_QUEUE_IF_NO_PATH 2		/* Saved state during suspension */
> -#define MPATHF_RETAIN_ATTACHED_HW_HANDLER 3	/* If there's already a hw_handler present, don't change it. */
> +/* MPATHF_RETAIN_ATTACHED_HW_HANDLER no longer has any effect */
>  #define MPATHF_PG_INIT_DISABLED 4		/* pg_init is not currently allowed */
>  #define MPATHF_PG_INIT_REQUIRED 5		/* pg_init needs calling? */
>  #define MPATHF_PG_INIT_DELAY_RETRY 6		/* Delay pg_init retry? */
> @@ -237,16 +237,10 @@ static struct multipath *alloc_multipath(struct dm_target *ti)
>  
>  static int alloc_multipath_stage2(struct dm_target *ti, struct multipath *m)
>  {
> -	if (m->queue_mode == DM_TYPE_NONE) {
> +	if (m->queue_mode == DM_TYPE_NONE)
>  		m->queue_mode = DM_TYPE_REQUEST_BASED;
> -	} else if (m->queue_mode == DM_TYPE_BIO_BASED) {
> +	else if (m->queue_mode == DM_TYPE_BIO_BASED)
>  		INIT_WORK(&m->process_queued_bios, process_queued_bios);
> -		/*
> -		 * bio-based doesn't support any direct scsi_dh management;
> -		 * it just discovers if a scsi_dh is attached.
> -		 */
> -		set_bit(MPATHF_RETAIN_ATTACHED_HW_HANDLER, &m->flags);
> -	}
>  
>  	dm_table_set_type(ti->table, m->queue_mode);
>  
> @@ -887,36 +881,30 @@ static int setup_scsi_dh(struct block_device *bdev, struct multipath *m,
>  	struct request_queue *q = bdev_get_queue(bdev);
>  	int r;
>  
> -	if (mpath_double_check_test_bit(MPATHF_RETAIN_ATTACHED_HW_HANDLER, m)) {
> -retain:
> -		if (*attached_handler_name) {
> -			/*
> -			 * Clear any hw_handler_params associated with a
> -			 * handler that isn't already attached.
> -			 */
> -			if (m->hw_handler_name && strcmp(*attached_handler_name, m->hw_handler_name)) {
> -				kfree(m->hw_handler_params);
> -				m->hw_handler_params = NULL;
> -			}
> -
> -			/*
> -			 * Reset hw_handler_name to match the attached handler
> -			 *
> -			 * NB. This modifies the table line to show the actual
> -			 * handler instead of the original table passed in.
> -			 */
> -			kfree(m->hw_handler_name);
> -			m->hw_handler_name = *attached_handler_name;
> -			*attached_handler_name = NULL;
> +	if (*attached_handler_name) {
> +		/*
> +		 * Clear any hw_handler_params associated with a
> +		 * handler that isn't already attached.
> +		 */
> +		if (m->hw_handler_name && strcmp(*attached_handler_name,
> +						 m->hw_handler_name)) {
> +			kfree(m->hw_handler_params);
> +			m->hw_handler_params = NULL;
>  		}
> +
> +		/*
> +		 * Reset hw_handler_name to match the attached handler
> +		 *
> +		 * NB. This modifies the table line to show the actual
> +		 * handler instead of the original table passed in.
> +		 */
> +		kfree(m->hw_handler_name);
> +		m->hw_handler_name = *attached_handler_name;
> +		*attached_handler_name = NULL;
>  	}
>  
>  	if (m->hw_handler_name) {
>  		r = scsi_dh_attach(q, m->hw_handler_name);
> -		if (r == -EBUSY) {
> -			DMINFO("retaining handler on device %pg", bdev);
> -			goto retain;
> -		}
>  		if (r < 0) {
>  			*error = "error attaching hardware handler";
>  			return r;
> @@ -1138,7 +1126,7 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
>  		}
>  
>  		if (!strcasecmp(arg_name, "retain_attached_hw_handler")) {
> -			set_bit(MPATHF_RETAIN_ATTACHED_HW_HANDLER, &m->flags);
> +			/* no longer has any effect */
>  			continue;
>  		}
>  
> @@ -1823,7 +1811,6 @@ static void multipath_status(struct dm_target *ti, status_type_t type,
>  		DMEMIT("%u ", test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags) +
>  			      (m->pg_init_retries > 0) * 2 +
>  			      (m->pg_init_delay_msecs != DM_PG_INIT_DELAY_DEFAULT) * 2 +
> -			      test_bit(MPATHF_RETAIN_ATTACHED_HW_HANDLER, &m->flags) +
>  			      (m->queue_mode != DM_TYPE_REQUEST_BASED) * 2);
>  
>  		if (test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags))
> @@ -1832,8 +1819,6 @@ static void multipath_status(struct dm_target *ti, status_type_t type,
>  			DMEMIT("pg_init_retries %u ", m->pg_init_retries);
>  		if (m->pg_init_delay_msecs != DM_PG_INIT_DELAY_DEFAULT)
>  			DMEMIT("pg_init_delay_msecs %u ", m->pg_init_delay_msecs);
> -		if (test_bit(MPATHF_RETAIN_ATTACHED_HW_HANDLER, &m->flags))
> -			DMEMIT("retain_attached_hw_handler ");
>  		if (m->queue_mode != DM_TYPE_REQUEST_BASED) {
>  			switch (m->queue_mode) {
>  			case DM_TYPE_BIO_BASED:
> -- 
> 2.50.1
> 


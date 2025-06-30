Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0B2148850
	for <dm-devel@lists.linux.dev>; Mon, 30 Jun 2025 13:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751289608; cv=none; b=fTmZDKZly5SBzXncPh0y8A+5eyU7EeLQpWm10/Lkx4ZSu3XuFgn6sdrr37o/DhReCSp38Ghs4EtNdtaorcvBuCJAreuMiWcKd0knVnx+CGVI/2l8OVSBC3O3WCWi1/xSY5gJ845NQ6+e1vMYoEUUEh187MR31DCIwPzddD9S0GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751289608; c=relaxed/simple;
	bh=xBfaGbeMoyXSb9IrTJO9lpJcSM5VOKUYJPnyb2fDIbY=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=BT8zwFxi02blGxs03ZKB7/3MY5d+Wtn4m7cyMpQOLfonoxudnrqnXdWnHVLyYru2z32RNnJHfZnrpXmjGApFItnzeHSGL8LDBJrqgrzsOoH43f691qiVoICDq+n/dfLk68QDoMm6IwTjjjXb9amZaeDJcC6jJPuPVX6WC1tq/gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jD9Bk5HW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jD9Bk5HW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751289605;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mdUiPYD/SRv7xNhx4a3L3xYnFmEPomyCHB2Q3puCgVk=;
	b=jD9Bk5HWu519Zpdu84G1BRcmL02V3JXQ1g3vgXGKgao0ak3PPYt/wkX7SmBUMC0AS5XuXj
	fmMyh0rU0ZAUJ/GFJeLNZ1wjUWgJXpc+6iQLvwHYzADnuBYtgKmnUi78b+GeNAyJt138GC
	rQ6peJwiyaymrJpZqhX4lduy7rq7mA4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-646-cd5QBRTXPyiT33j4QJQ3DA-1; Mon,
 30 Jun 2025 09:20:04 -0400
X-MC-Unique: cd5QBRTXPyiT33j4QJQ3DA-1
X-Mimecast-MFC-AGG-ID: cd5QBRTXPyiT33j4QJQ3DA_1751289603
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0380618001D1;
	Mon, 30 Jun 2025 13:20:03 +0000 (UTC)
Received: from [10.22.80.10] (unknown [10.22.80.10])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7F0F719560B2;
	Mon, 30 Jun 2025 13:20:01 +0000 (UTC)
Date: Mon, 30 Jun 2025 15:19:55 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: Re: [PATCH] md: dm-ps-*: delete version strings
In-Reply-To: <20250625111918.219963-1-xose.vazquez@gmail.com>
Message-ID: <3480a823-c12a-81d4-5293-fc2052bf25bc@redhat.com>
References: <20250625111918.219963-1-xose.vazquez@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ZUf3fMq3CkDEj8j6bUiWd9D6sTDQHLpgflyZFGlbfSE_1751289603
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi

I think this isn't needed. The version doesn't do any harm.

Mikulas


On Wed, 25 Jun 2025, Xose Vazquez Perez wrote:

> Reminiscent of ancient times, when modules were developed outside the kernel.
> Pretty useless nowadays for code included in the official kernel repo, with constant
> changes and without updating the version number.
> 
> Cc: Alasdair Kergon <agk@redhat.com> (maintainer:DEVICE-MAPPER  (LVM))
> Cc: Mike Snitzer <snitzer@kernel.org> (maintainer:DEVICE-MAPPER  (LVM))
> Cc: Mikulas Patocka <mpatocka@redhat.com> (maintainer:DEVICE-MAPPER  (LVM))
> Cc: DM-DEVEL ML <dm-devel@lists.linux.dev> (open list:DEVICE-MAPPER  (LVM))
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
> BTW, MODULE_VERSION should be removed from the entire tree.
> ___
>  drivers/md/dm-ps-historical-service-time.c | 3 +--
>  drivers/md/dm-ps-queue-length.c            | 3 +--
>  drivers/md/dm-ps-round-robin.c             | 3 +--
>  drivers/md/dm-ps-service-time.c            | 3 +--
>  4 files changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/md/dm-ps-historical-service-time.c b/drivers/md/dm-ps-historical-service-time.c
> index b49e10d76d03..fa6198c0276b 100644
> --- a/drivers/md/dm-ps-historical-service-time.c
> +++ b/drivers/md/dm-ps-historical-service-time.c
> @@ -31,7 +31,6 @@
>  
>  #define DM_MSG_PREFIX	"multipath historical-service-time"
>  #define HST_MIN_IO 1
> -#define HST_VERSION "0.1.1"
>  
>  #define HST_FIXED_SHIFT 10  /* 10 bits of decimal precision */
>  #define HST_FIXED_MAX (ULLONG_MAX >> HST_FIXED_SHIFT)
> @@ -544,7 +543,7 @@ static int __init dm_hst_init(void)
>  	if (r < 0)
>  		DMERR("register failed %d", r);
>  
> -	DMINFO("version " HST_VERSION " loaded");
> +	DMINFO(" loaded");
>  
>  	return r;
>  }
> diff --git a/drivers/md/dm-ps-queue-length.c b/drivers/md/dm-ps-queue-length.c
> index e305f05ad1e5..31decbef9837 100644
> --- a/drivers/md/dm-ps-queue-length.c
> +++ b/drivers/md/dm-ps-queue-length.c
> @@ -25,7 +25,6 @@
>  
>  #define DM_MSG_PREFIX	"multipath queue-length"
>  #define QL_MIN_IO	1
> -#define QL_VERSION	"0.2.0"
>  
>  struct selector {
>  	struct list_head	valid_paths;
> @@ -263,7 +262,7 @@ static int __init dm_ql_init(void)
>  	if (r < 0)
>  		DMERR("register failed %d", r);
>  
> -	DMINFO("version " QL_VERSION " loaded");
> +	DMINFO(" loaded");
>  
>  	return r;
>  }
> diff --git a/drivers/md/dm-ps-round-robin.c b/drivers/md/dm-ps-round-robin.c
> index d1745b123dc1..67f7f5ec5428 100644
> --- a/drivers/md/dm-ps-round-robin.c
> +++ b/drivers/md/dm-ps-round-robin.c
> @@ -19,7 +19,6 @@
>  
>  #define DM_MSG_PREFIX "multipath round-robin"
>  #define RR_MIN_IO     1
> -#define RR_VERSION    "1.2.0"
>  
>  /*
>   *---------------------------------------------------------------
> @@ -223,7 +222,7 @@ static int __init dm_rr_init(void)
>  	if (r < 0)
>  		DMERR("register failed %d", r);
>  
> -	DMINFO("version " RR_VERSION " loaded");
> +	DMINFO(" loaded");
>  
>  	return r;
>  }
> diff --git a/drivers/md/dm-ps-service-time.c b/drivers/md/dm-ps-service-time.c
> index 969d31c40272..cbb0ac63bb7a 100644
> --- a/drivers/md/dm-ps-service-time.c
> +++ b/drivers/md/dm-ps-service-time.c
> @@ -20,7 +20,6 @@
>  #define ST_MAX_RELATIVE_THROUGHPUT	100
>  #define ST_MAX_RELATIVE_THROUGHPUT_SHIFT	7
>  #define ST_MAX_INFLIGHT_SIZE	((size_t)-1 >> ST_MAX_RELATIVE_THROUGHPUT_SHIFT)
> -#define ST_VERSION	"0.3.0"
>  
>  struct selector {
>  	struct list_head valid_paths;
> @@ -344,7 +343,7 @@ static int __init dm_st_init(void)
>  	if (r < 0)
>  		DMERR("register failed %d", r);
>  
> -	DMINFO("version " ST_VERSION " loaded");
> +	DMINFO(" loaded");
>  
>  	return r;
>  }
> -- 
> 2.50.0
> 


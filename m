Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942B72D0C6E
	for <dm-devel@lists.linux.dev>; Mon, 11 Aug 2025 11:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754911406; cv=none; b=Stt/GUgNoMxiuBzuTAq6N7LLM02cBy0/dPglgpn+dmUa7WyBsS0LQpqkw3VbEWMkY4/HE5dC2cD147LM7rDL3PCqQSYa6AL3SLMymyHY5h4eKdClS+WCkcX5BafTs5YMl27IXLfk8ptrFMOno22c003adSWXv8vxokv+rrnecps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754911406; c=relaxed/simple;
	bh=saSyiBiKHUdAFrzwGqARIPwScwfEjexv1g2OPJ41Yso=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=ruI4y64l1ZjfX3Hk0wXOl3WEn/A3T3ijQdQj+bsOIBBUWz/QVhZYQ5mUKnt/edQcqbIfumLgn1bWrQREnamPv1O4khwVGrqVmnFaxl2Ew370Zkfy0oaLStNMiP84UUZwc/Aio4hRBg+QX0UJ0L6llBVQhZQLtB0j2zaW8+xvc8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c4T5VzJJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c4T5VzJJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754911403;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8cVxwlL6VRYh0Ryi1DhCcEg8zhEUMzXPeQpCRJqaFwA=;
	b=c4T5VzJJgQRtyjCfVVilGSf4utvGFgDW3nFV4uaJamV2lrysMHsfUOyYcWNYE4GhcmwIW5
	a4NFeg3TItr/BYMpHH7HPY+L57MwjjV2+xJW9v/Bsr6HeZoOuKFJpfVK8uvyTrn+lp3JJp
	96yX0Mveea6pINcyQiT40BkmqZLZVtk=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-298-PhAoHrGeNXOvPpmSYkytyw-1; Mon,
 11 Aug 2025 07:23:20 -0400
X-MC-Unique: PhAoHrGeNXOvPpmSYkytyw-1
X-Mimecast-MFC-AGG-ID: PhAoHrGeNXOvPpmSYkytyw_1754911398
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6AC751955F28;
	Mon, 11 Aug 2025 11:23:18 +0000 (UTC)
Received: from [10.22.80.50] (unknown [10.22.80.50])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EEB5B1800447;
	Mon, 11 Aug 2025 11:23:16 +0000 (UTC)
Date: Mon, 11 Aug 2025 13:23:14 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Dmitry Antipov <dmantipov@yandex.ru>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    dm-devel@lists.linux.dev
Subject: Re: [PATCH] dm: ima: more strlen() drops
In-Reply-To: <20250805103541.490377-1-dmantipov@yandex.ru>
Message-ID: <bd85bff1-47ba-9762-6234-ea9934d1b6d9@redhat.com>
References: <20250805103541.490377-1-dmantipov@yandex.ru>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: a8TrZWBhtNzN1bgYNlS_h6eSMG5cJ_0cmhS9dm3f4_g_1754911398
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Applied, thanks.

(I also removed the "gfp_t flags" argument because its always GFP_KERNEL.

Mikulas



On Tue, 5 Aug 2025, Dmitry Antipov wrote:

> Following commit ebbd17695e9e ("dm: ima: avoid extra calls to
> strlen()"), convert 'dm_ima_alloc_and_copy_capacity_str()' to
> return the number of characters emitted by 'scnprintf()' and
> simplify the users accordingly. Compile tested only.
> 
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> ---
>  drivers/md/dm-ima.c | 40 ++++++++++++++++------------------------
>  1 file changed, 16 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/md/dm-ima.c b/drivers/md/dm-ima.c
> index 8b50c908c6f4..f5c0ecc7cb0b 100644
> --- a/drivers/md/dm-ima.c
> +++ b/drivers/md/dm-ima.c
> @@ -157,10 +157,8 @@ static int dm_ima_alloc_and_copy_capacity_str(struct mapped_device *md, char **c
>  	if (!(*capacity_str))
>  		return -ENOMEM;
>  
> -	scnprintf(*capacity_str, DM_IMA_DEVICE_BUF_LEN, "current_device_capacity=%llu;",
> -		  capacity);
> -
> -	return 0;
> +	return scnprintf(*capacity_str, DM_IMA_DEVICE_BUF_LEN, "current_device_capacity=%llu;",
> +			 capacity);
>  }
>  
>  /*
> @@ -371,18 +369,18 @@ void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap)
>  {
>  	char *device_table_data, *dev_name = NULL, *dev_uuid = NULL, *capacity_str = NULL;
>  	char active[] = "active_table_hash=";
> -	unsigned int active_len = strlen(active), capacity_len = 0;
> +	unsigned int active_len = strlen(active);
>  	unsigned int l = 0;
>  	bool noio = true;
>  	bool nodata = true;
> -	int r;
> +	int capacity_len;
>  
>  	device_table_data = dm_ima_alloc(DM_IMA_DEVICE_BUF_LEN, GFP_KERNEL, noio);
>  	if (!device_table_data)
>  		return;
>  
> -	r = dm_ima_alloc_and_copy_capacity_str(md, &capacity_str, noio);
> -	if (r)
> +	capacity_len = dm_ima_alloc_and_copy_capacity_str(md, &capacity_str, noio);
> +	if (capacity_len < 0)
>  		goto error;
>  
>  	memcpy(device_table_data + l, DM_IMA_VERSION_STR, md->ima.dm_version_str_len);
> @@ -445,8 +443,7 @@ void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap)
>  	}
>  
>  	if (nodata) {
> -		r = dm_ima_alloc_and_copy_name_uuid(md, &dev_name, &dev_uuid, noio);
> -		if (r)
> +		if (dm_ima_alloc_and_copy_name_uuid(md, &dev_name, &dev_uuid, noio))
>  			goto error;
>  
>  		l = scnprintf(device_table_data, DM_IMA_DEVICE_BUF_LEN,
> @@ -454,7 +451,6 @@ void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap)
>  			      DM_IMA_VERSION_STR, dev_name, dev_uuid);
>  	}
>  
> -	capacity_len = strlen(capacity_str);
>  	memcpy(device_table_data + l, capacity_str, capacity_len);
>  	l += capacity_len;
>  
> @@ -483,18 +479,17 @@ void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all)
>  	unsigned int device_active_len = strlen(device_active_str);
>  	unsigned int device_inactive_len = strlen(device_inactive_str);
>  	unsigned int remove_all_len = strlen(remove_all_str);
> -	unsigned int capacity_len = 0;
>  	unsigned int l = 0;
>  	bool noio = true;
>  	bool nodata = true;
> -	int r;
> +	int capacity_len;
>  
>  	device_table_data = dm_ima_alloc(DM_IMA_DEVICE_BUF_LEN*2, GFP_KERNEL, noio);
>  	if (!device_table_data)
>  		goto exit;
>  
> -	r = dm_ima_alloc_and_copy_capacity_str(md, &capacity_str, noio);
> -	if (r) {
> +	capacity_len = dm_ima_alloc_and_copy_capacity_str(md, &capacity_str, noio);
> +	if (capacity_len < 0) {
>  		kfree(device_table_data);
>  		goto exit;
>  	}
> @@ -570,7 +565,6 @@ void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all)
>  	memcpy(device_table_data + l, remove_all ? "y;" : "n;", 2);
>  	l += 2;
>  
> -	capacity_len = strlen(capacity_str);
>  	memcpy(device_table_data + l, capacity_str, capacity_len);
>  	l += capacity_len;
>  
> @@ -602,20 +596,20 @@ void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all)
>   */
>  void dm_ima_measure_on_table_clear(struct mapped_device *md, bool new_map)
>  {
> -	unsigned int l = 0, capacity_len = 0;
> +	unsigned int l = 0;
>  	char *device_table_data = NULL, *dev_name = NULL, *dev_uuid = NULL, *capacity_str = NULL;
>  	char inactive_str[] = "inactive_table_hash=";
>  	unsigned int inactive_len = strlen(inactive_str);
>  	bool noio = true;
>  	bool nodata = true;
> -	int r;
> +	int capacity_len;
>  
>  	device_table_data = dm_ima_alloc(DM_IMA_DEVICE_BUF_LEN, GFP_KERNEL, noio);
>  	if (!device_table_data)
>  		return;
>  
> -	r = dm_ima_alloc_and_copy_capacity_str(md, &capacity_str, noio);
> -	if (r)
> +	capacity_len = dm_ima_alloc_and_copy_capacity_str(md, &capacity_str, noio);
> +	if (capacity_len < 0)
>  		goto error1;
>  
>  	memcpy(device_table_data + l, DM_IMA_VERSION_STR, md->ima.dm_version_str_len);
> @@ -650,7 +644,6 @@ void dm_ima_measure_on_table_clear(struct mapped_device *md, bool new_map)
>  			      DM_IMA_VERSION_STR, dev_name, dev_uuid);
>  	}
>  
> -	capacity_len = strlen(capacity_str);
>  	memcpy(device_table_data + l, capacity_str, capacity_len);
>  	l += capacity_len;
>  
> @@ -703,7 +696,7 @@ void dm_ima_measure_on_device_rename(struct mapped_device *md)
>  	char *old_device_data = NULL, *new_device_data = NULL, *combined_device_data = NULL;
>  	char *new_dev_name = NULL, *new_dev_uuid = NULL, *capacity_str = NULL;
>  	bool noio = true;
> -	int r, len;
> +	int len;
>  
>  	if (dm_ima_alloc_and_copy_device_data(md, &new_device_data,
>  					      md->ima.active_table.num_targets, noio))
> @@ -716,8 +709,7 @@ void dm_ima_measure_on_device_rename(struct mapped_device *md)
>  	if (!combined_device_data)
>  		goto error;
>  
> -	r = dm_ima_alloc_and_copy_capacity_str(md, &capacity_str, noio);
> -	if (r)
> +	if (dm_ima_alloc_and_copy_capacity_str(md, &capacity_str, noio) < 0)
>  		goto error;
>  
>  	old_device_data = md->ima.active_table.device_metadata;
> -- 
> 2.50.1
> 


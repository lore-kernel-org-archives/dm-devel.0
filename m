Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F52C24B28
	for <dm-devel@lists.linux.dev>; Thu, 24 Oct 2024 14:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729778477; cv=none; b=Wi9u6yVoc6E8kOsQECVdIfVjo3IqYn+O9Ugnu3GQCMR7473eDX8ZVYZrkaKJ9m06Wn6njZUQ+ZPM4gWUiAuQKr5mLkXisSLc8KOwRMx7BDzCAOgHQC6rcKzN6V+5VhZqlP/4Jba1H+xkz3ciQGgsc7nwuPJqwfzBpKs1D5JZ9hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729778477; c=relaxed/simple;
	bh=unPcoLe5dU05goPTG31XI2fIT3hHVSg6LJ9esTS/Ck4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=XvZIwy1i1Ib17YkUDaRmGp22jIRebAUpRw77nbzXkgBcwp9UDdTgSK98ijy+I/PLh4gF5RoFonVOKLHtaU2GTnOtGq5tqLBau6wQ/kGzZ//5Q9gx9zQJsi0l65mUPXc4NmpI6Dh231C4AjnQGZVT1hu9dVJKjDw35TzCDl9Jiuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gaYUG+wu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gaYUG+wu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729778474;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QfO60MWuBouDwnHmSGuTVmqSkIOnj17RZgxXvFF2VSQ=;
	b=gaYUG+wuDG98r6O0qa8Wh9OWC+qhUwDNpRODUvYvJ5tZobCLz4ArzbZWs3RJmi2panbjuK
	bMvpgqarLMjmc93eapwoI+hjT4CDFjcouLwnFNuR8aOC8cN3IRQckVltui0mBqeYubQUwY
	PRWvrzMn1ywqfC378D9pLh91W2ozzYY=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-607-Ftwe3mQLNFiyB_xaTapMdA-1; Thu,
 24 Oct 2024 10:01:11 -0400
X-MC-Unique: Ftwe3mQLNFiyB_xaTapMdA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0609319560AD;
	Thu, 24 Oct 2024 14:01:10 +0000 (UTC)
Received: from [10.45.226.64] (unknown [10.45.226.64])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 48CA319560A2;
	Thu, 24 Oct 2024 14:01:08 +0000 (UTC)
Date: Thu, 24 Oct 2024 16:01:05 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Colin Ian King <colin.i.king@gmail.com>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] dm ioctl: rate limit a couple of ioctl based error
 messages
In-Reply-To: <20241024110431.1906858-1-colin.i.king@gmail.com>
Message-ID: <51915860-4a32-b563-c000-d64e1df6702d@redhat.com>
References: <20241024110431.1906858-1-colin.i.king@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Hi

I'd like to ask - have you experienced these errors? What was the process 
that triggered them? Was it some robot that tests syscalls with random 
parameters?

Mikulas


On Thu, 24 Oct 2024, Colin Ian King wrote:

> It is possible to spam the kernel log with a misbehaving user process that
> is passing incorrect dm ioctls to /dev/mapper/control. Use a rate limit
> on these error messages to reduce the noise.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  drivers/md/dm-ioctl.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> index f299ff393a6a..d42eac944eb5 100644
> --- a/drivers/md/dm-ioctl.c
> +++ b/drivers/md/dm-ioctl.c
> @@ -1912,7 +1912,7 @@ static int check_version(unsigned int cmd, struct dm_ioctl __user *user,
>  
>  	if ((kernel_params->version[0] != DM_VERSION_MAJOR) ||
>  	    (kernel_params->version[1] > DM_VERSION_MINOR)) {
> -		DMERR("ioctl interface mismatch: kernel(%u.%u.%u), user(%u.%u.%u), cmd(%d)",
> +		DMERR_LIMIT("ioctl interface mismatch: kernel(%u.%u.%u), user(%u.%u.%u), cmd(%d)",
>  		      DM_VERSION_MAJOR, DM_VERSION_MINOR,
>  		      DM_VERSION_PATCHLEVEL,
>  		      kernel_params->version[0],
> @@ -1961,7 +1961,7 @@ static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl *param_kern
>  
>  	if (unlikely(param_kernel->data_size < minimum_data_size) ||
>  	    unlikely(param_kernel->data_size > DM_MAX_TARGETS * DM_MAX_TARGET_PARAMS)) {
> -		DMERR("Invalid data size in the ioctl structure: %u",
> +		DMERR_LIMIT("Invalid data size in the ioctl structure: %u",
>  		      param_kernel->data_size);
>  		return -EINVAL;
>  	}
> -- 
> 2.39.5
> 


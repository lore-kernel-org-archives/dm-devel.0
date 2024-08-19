Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0DC158858
	for <dm-devel@lists.linux.dev>; Mon, 19 Aug 2024 20:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724099413; cv=none; b=XhqC6mOv6S9oxXMuJAuXJGw+SQn+bXmi8LsYcUNxbrgBj8zJarf5teX63LOn4TxJwz2i9q9Y6c8NUnqDZhAosRC5IiZAhFj5pE4nG3nWBnol753k7jbT0I/SEuP8NkSDzh63ZHrPBVVkLCn99PXjmpiZWY55hfuZQKLgixj4ufE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724099413; c=relaxed/simple;
	bh=dxZzgN8fHT7/E9MQmkwqnJhujKe+x7LyCDMQUazEia0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=INi8XLZ0WZOTtiwNzo2KikLNMBqcZ5dOt/SSTZQnQ8Ut1rPim7AYU62Wf7sDZUQopBX09zruhRJTcqQzg00FTc/HM7jUar7CqI470n4+N4SjBLlUzves6NgoaAVUlC1cOyK7vHdT8COUUyAH8uWNGfV0aeHO7hbE/jZ8qP6hDe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C48Re+ZK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C48Re+ZK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724099411;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hn+U0KRxu/hCj/TyTc49LIfB/amh5yN9k/2aiCsM7B4=;
	b=C48Re+ZKd7X8MoW733aE5W5ghCPlSa7j5ya8ZMVn8nlGZbPReW2J10w5jPVwSBVode++p7
	rzxTaL1T0StskDc4GOI+04ANZXIoyDp2KKYQZ1EBnrqRRWMF4/ZZFaAwWElhMmzIfLzrH+
	q1zcB3bbG58Ibr35KYBjN6aRD4Gjiz0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-440-z3TYU149PZ-d5vkRbPCspg-1; Mon,
 19 Aug 2024 16:30:07 -0400
X-MC-Unique: z3TYU149PZ-d5vkRbPCspg-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 05EC419560B4;
	Mon, 19 Aug 2024 20:30:06 +0000 (UTC)
Received: from [10.45.224.222] (unknown [10.45.224.222])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 431871956053;
	Mon, 19 Aug 2024 20:30:03 +0000 (UTC)
Date: Mon, 19 Aug 2024 22:29:58 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Piotr Zalewski <pZ010001011111@proton.me>
cc: agk@redhat.com, snitzer@kernel.org, corbet@lwn.net, 
    dm-devel@lists.linux.dev, linux-doc@vger.kernel.org, 
    linux-kernel@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH] Documentation: admin-guide/dm: Fix indentation bug
In-Reply-To: <20240819172401.77928-3-pZ010001011111@proton.me>
Message-ID: <ced0f91b-6db7-df23-3988-b687b8beefcc@redhat.com>
References: <20240819172401.77928-3-pZ010001011111@proton.me>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17



On Mon, 19 Aug 2024, Piotr Zalewski wrote:

> The following bug was found at `admin-guide/device-mapper/dm-crypt.rst`:
> ```
> admin-guide/device-mapper/dm-crypt.rst:167: ERROR: Unexpected indentation.
> ```
> Fix the indentation error.

Hi

This should be already fixed in v6.11-rc4.

Mikulas

> Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
> Signed-off-by: Piotr Zalewski <pZ010001011111@proton.me>
> ---
>  .../admin-guide/device-mapper/dm-crypt.rst     | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/admin-guide/device-mapper/dm-crypt.rst b/Documentation/admin-guide/device-mapper/dm-crypt.rst
> index e625830d335e..450c211534a9 100644
> --- a/Documentation/admin-guide/device-mapper/dm-crypt.rst
> +++ b/Documentation/admin-guide/device-mapper/dm-crypt.rst
> @@ -160,15 +160,15 @@ iv_large_sectors
>     The <iv_offset> must be multiple of <sector_size> (in 512 bytes units)
>     if this flag is specified.
>  
> -
> -Module parameters::
> -max_read_size
> -max_write_size
> -   Maximum size of read or write requests. When a request larger than this size
> -   is received, dm-crypt will split the request. The splitting improves
> -   concurrency (the split requests could be encrypted in parallel by multiple
> -   cores), but it also causes overhead. The user should tune these parameters to
> -   fit the actual workload. 
> +    Module parameters::
> +
> +        max_read_size
> +        max_write_size
> +           Maximum size of read or write requests. When a request larger than this size
> +           is received, dm-crypt will split the request. The splitting improves
> +           concurrency (the split requests could be encrypted in parallel by multiple
> +           cores), but it also causes overhead. The user should tune these parameters to
> +           fit the actual workload.
>  
>  
>  Example scripts
> -- 
> 2.46.0
> 
> 


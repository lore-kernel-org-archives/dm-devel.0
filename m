Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3127F1C8FC8
	for <dm-devel@lists.linux.dev>; Wed, 18 Sep 2024 16:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726677543; cv=none; b=MXNVNElSSPttetkLgxSS1c4jMPtkQOwUH5v8edhk5j67/7HcZ4gNUyTR2bhTjJMhrjrstdBeEfbCTutwhuNjlih9vveV7ar78VgSpK/vNvmAvLXPFlDYIDsOkmRKsV3WwEN9bX/68gkfLah5AiJ/ZBUizeVlt9wf9ARYw9F8y14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726677543; c=relaxed/simple;
	bh=Fj4rZQJQUIuU0wDhWXrLZzxjYeHI+c7sUIPayv9HwUc=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=JmtYvENCRhWpTmIUwvortd/Ltk2LhndeZlA56fHFazVGvGk+3jlgvVGSILkKphyffawD9Ibto1mubOTFugOXTpBeAClZVzY4qETYZhsCLo++4BkG124sHVRvjx0ODG69m0+w6emgfEgy2/z7TLTftw1dlZ5IeJaencYsmrQ7uhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SGmbLr74; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SGmbLr74"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726677541;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WA2tGkPSyN9kMCthLe0asjcZRulGUF3dg/RoXXIi6U4=;
	b=SGmbLr74Gmlp03ag8ivNS/jHhn5rY9qcwenTFPXUCQmn5sVz259vO2js4ZPPzCcBdussFz
	bGmChW0BtAkPEwk6WrL6do68O3DcQllmS1LWZ3VVMsm4P4GkH3ole4f6kxqz0AQyrn9qJ6
	fzZ9BVo6mVPFXu6d58dz3UCOwoLwtiI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-411-CSaE2cW9MSK95PewHkinYw-1; Wed,
 18 Sep 2024 12:38:54 -0400
X-MC-Unique: CSaE2cW9MSK95PewHkinYw-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3601A193EF44;
	Wed, 18 Sep 2024 16:38:49 +0000 (UTC)
Received: from [10.45.224.27] (unknown [10.45.224.27])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 417F83002087;
	Wed, 18 Sep 2024 16:38:46 +0000 (UTC)
Date: Wed, 18 Sep 2024 18:38:42 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Markus Elfring <Markus.Elfring@web.de>
cc: dm-devel@lists.linux.dev, kernel-janitors@vger.kernel.org, 
    Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Ondrej Kozina <okozina@redhat.com>, Waiman Long <longman@redhat.com>, 
    LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] dm-crypt: Use common error handling code in
 crypt_set_keyring_key()
In-Reply-To: <4b4379e6-e341-46da-a951-57b31edf3997@web.de>
Message-ID: <dbdb4828-4301-6756-fcc5-f94c0ffc3893@redhat.com>
References: <68ee5a00-888c-420f-a3a9-a556c19ee6eb@web.de> <4b4379e6-e341-46da-a951-57b31edf3997@web.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Both patches applied, thanks.

Mikulas


On Wed, 18 Sep 2024, Markus Elfring wrote:

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Wed, 18 Sep 2024 15:34:45 +0200
> 
> Add a jump target so that a bit of exception handling can be better reused
> at the end of this function implementation.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/md/dm-crypt.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index dae2fe3cb182..3d2247cfd42b 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -2614,8 +2614,8 @@ static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string
> 
>  	key = request_key(type, key_desc + 1, NULL);
>  	if (IS_ERR(key)) {
> -		kfree_sensitive(new_key_string);
> -		return PTR_ERR(key);
> +		ret = PTR_ERR(key);
> +		goto free_new_key_string;
>  	}
> 
>  	down_read(&key->sem);
> @@ -2623,23 +2623,23 @@ static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string
>  	ret = set_key(cc, key);
>  	up_read(&key->sem);
>  	key_put(key);
> -	if (ret < 0) {
> -		kfree_sensitive(new_key_string);
> -		return ret;
> -	}
> +	if (ret < 0)
> +		goto free_new_key_string;
> 
>  	/* clear the flag since following operations may invalidate previously valid key */
>  	clear_bit(DM_CRYPT_KEY_VALID, &cc->flags);
> 
>  	ret = crypt_setkey(cc);
> +	if (ret)
> +		goto free_new_key_string;
> 
> -	if (!ret) {
> -		set_bit(DM_CRYPT_KEY_VALID, &cc->flags);
> -		kfree_sensitive(cc->key_string);
> -		cc->key_string = new_key_string;
> -	} else
> -		kfree_sensitive(new_key_string);
> +	set_bit(DM_CRYPT_KEY_VALID, &cc->flags);
> +	kfree_sensitive(cc->key_string);
> +	cc->key_string = new_key_string;
> +	return 0;
> 
> +free_new_key_string:
> +	kfree_sensitive(new_key_string);
>  	return ret;
>  }
> 
> --
> 2.46.0
> 


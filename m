Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040A5194132
	for <dm-devel@lists.linux.dev>; Tue, 20 Aug 2024 15:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724169397; cv=none; b=tX0TU0VyloZfKW6uHPasDejI4gDwJ22b5Ia7K3PerqAhUhz/q1FM2eu6/AeJI/djQwwXAZC9DBMdcxW836YxcgkL1Xmok+33c57TM9L1U5PpDFibvyTjwTmY829bvUpjreag1HscxO80ERgonjiTSP3eIU8GdAkUr6QVLzmY3Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724169397; c=relaxed/simple;
	bh=Qva5+UXUYmHWOG2HRWEqsUfbZAKR1XQh8d0K7a81fAs=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=p4wEBwla3KYLXhwSDC8svhBRJ3PsqxXDbTKu86vit59N6Urb8p5bdzwUUe8PBzlypJCCpdUi+Fu3R7VksacwpARWH3izWaOip5WogENb7clOQ+Y9ivjFurMI6umgqxCeCGEXP5kCgLBxeGSHpzL27ywxp8tOj+U/LktvWb935Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HUvC/SKG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HUvC/SKG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724169393;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u0gli+bohzWPYwY7EeMzOqQfQ/TM582abbFLfRXH3iM=;
	b=HUvC/SKG8OX0YtPcol1PKcKgYtkT/zoc/YXuu3qLUM1Ur//B9xZ8zgFYGP7XGhbpEPHGn0
	I54wAcFcsI+/0TK47tor/ZdRS+W7Nugzeipl7Wzk65b7fP6R2jXmLTkb043YuGiqJPKjVV
	0G32MGayymz3vxBUsEc//6B+saCrWbk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-683-pQho3fLrMwWttLx1RQbnJw-1; Tue,
 20 Aug 2024 11:56:29 -0400
X-MC-Unique: pQho3fLrMwWttLx1RQbnJw-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2E5AB1955D4B;
	Tue, 20 Aug 2024 15:56:28 +0000 (UTC)
Received: from [10.45.224.222] (unknown [10.45.224.222])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E4CF119560AA;
	Tue, 20 Aug 2024 15:56:25 +0000 (UTC)
Date: Tue, 20 Aug 2024 17:56:22 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Ingo Franzki <ifranzki@linux.ibm.com>
cc: dm-devel@lists.linux.dev, agk@redhat.com, snitzer@kernel.org, 
    gmazyland@gmail.com
Subject: Re: [PATCH] dm-crypt: Allow to specify the integrity key size as
 option
In-Reply-To: <20240816112133.2100537-1-ifranzki@linux.ibm.com>
Message-ID: <d75574e8-a829-0f48-2a99-8d79b0fdfb00@redhat.com>
References: <20240816112133.2100537-1-ifranzki@linux.ibm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Fri, 16 Aug 2024, Ingo Franzki wrote:

> For the MAC based integrity operation, the integrity key size (i.e.
> key_mac_size) is currently set to the digest size of the used digest.
> 
> For wrapped key HMAC algorithms, the key size is independent of the
> cryptographic key size. So there is no known size of the mac key in
> such cases. The desired key size can optionally be specified as argument
> when the dm-crypt device is configured via 'integrity_key_size:%u'.
> If no integrity_key_size argument is specified, the mac key size
> is still set to the digest size, as before.
> 
> Increase version number to 1.28.0 so that support for the new
> argument can be detected by user space (i.e. cryptsetup).

Hi

I know you already discussed it with Milan. I'd like to ask, what's the 
reason for this patch? Milan said that you need it for mainframes - 
please, describe the specific configuration when this patch is needed.

Mikulas


> Signed-off-by: Ingo Franzki <ifranzki@linux.ibm.com>
> ---
>  Documentation/admin-guide/device-mapper/dm-crypt.rst |  4 ++++
>  drivers/md/dm-crypt.c                                | 11 +++++++++--
>  2 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/admin-guide/device-mapper/dm-crypt.rst b/Documentation/admin-guide/device-mapper/dm-crypt.rst
> index e625830d335e..636b47c582f0 100644
> --- a/Documentation/admin-guide/device-mapper/dm-crypt.rst
> +++ b/Documentation/admin-guide/device-mapper/dm-crypt.rst
> @@ -160,6 +160,10 @@ iv_large_sectors
>     The <iv_offset> must be multiple of <sector_size> (in 512 bytes units)
>     if this flag is specified.
>  
> +integrity_key_size:<bytes>
> +   Use an integrity key of <bytes> size instead of using an integrity key size
> +   of the digest size of the used HMAC algorithm.
> +
>  
>  Module parameters::
>  max_read_size
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 348b4b26c272..c4c706115870 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -2937,7 +2937,8 @@ static int crypt_ctr_auth_cipher(struct crypt_config *cc, char *cipher_api)
>  	if (IS_ERR(mac))
>  		return PTR_ERR(mac);
>  
> -	cc->key_mac_size = crypto_ahash_digestsize(mac);
> +	if (!cc->key_mac_size)
> +		cc->key_mac_size = crypto_ahash_digestsize(mac);
>  	crypto_free_ahash(mac);
>  
>  	cc->authenc_key = kmalloc(crypt_authenckey_size(cc), GFP_KERNEL);
> @@ -3219,6 +3220,12 @@ static int crypt_ctr_optional(struct dm_target *ti, unsigned int argc, char **ar
>  			cc->cipher_auth = kstrdup(sval, GFP_KERNEL);
>  			if (!cc->cipher_auth)
>  				return -ENOMEM;
> +		} else if (sscanf(opt_string, "integrity_key_size:%u", &val) == 1) {
> +			if (val == 0) {
> +				ti->error = "Invalid integrity_key_size argument";
> +				return -EINVAL;
> +			}
> +			cc->key_mac_size = val;
>  		} else if (sscanf(opt_string, "sector_size:%hu%c", &cc->sector_size, &dummy) == 1) {
>  			if (cc->sector_size < (1 << SECTOR_SHIFT) ||
>  			    cc->sector_size > 4096 ||
> @@ -3758,7 +3765,7 @@ static void crypt_io_hints(struct dm_target *ti, struct queue_limits *limits)
>  
>  static struct target_type crypt_target = {
>  	.name   = "crypt",
> -	.version = {1, 27, 0},
> +	.version = {1, 28, 0},
>  	.module = THIS_MODULE,
>  	.ctr    = crypt_ctr,
>  	.dtr    = crypt_dtr,
> -- 
> 2.43.0
> 


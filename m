Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA32F33120A
	for <dm-devel@lists.linux.dev>; Wed, 21 Jan 2026 16:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769014577; cv=none; b=Zc7/yFWIqJ9rMSnaUkxZdARbGdU2bxcoPZsCIzghAJWjLKsI8n8fZMUOd7ksvZreVpAsXV7reAhi1l5o7MI/nkDnnfXxaJIRfhP2SalLULUQCMmzyvQntnfYw9D88+DGYXjpB8Ad/lMMTDoTJhgmICzmVlOQW2GRJwP9DXEGeFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769014577; c=relaxed/simple;
	bh=QbFSLbS0p3qIcS47k40aQA0lw74csRfdvsPcRDagNxs=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=FeWpaGdJ17InvHKi87ZKcsRwIkM9NcF7RG6vWXWNNOCm/ElslNYZVftXMylwLyGKCV11Tw6iUgXSS0r5sBWbAc1CcGtsg+dSGdcoL64dLeqYOHW5kZ01DCOLR1vdujl9dTY8mQ7J5T/sew/TOH1toYJhnKx4F8/KuABiMGdhil0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NT4tanwM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NT4tanwM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769014573;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SfIoryN4r3K/P+AdLwI+iuhXmZi8rEtdExeXqFsR2vE=;
	b=NT4tanwMQB2GOx6D4k0L/ljRRWVlU/9eZYtvat+a0j7/anOhpidIdiv6FHXvz4qftmg4Ae
	4XN5LporQZ/+raxEWwuJ3lBgS6uhMGs2WIcYvuqH5z3FnvS8ANerREbKNgu11cxu8S/lwt
	EzuhCiCqFSnns/gWeMtUeMm4MHwiabo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-106-pMXHUk55N0GOstlZQz7UmQ-1; Wed,
 21 Jan 2026 11:56:09 -0500
X-MC-Unique: pMXHUk55N0GOstlZQz7UmQ-1
X-Mimecast-MFC-AGG-ID: pMXHUk55N0GOstlZQz7UmQ_1769014568
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3AE0518301CF;
	Wed, 21 Jan 2026 16:56:00 +0000 (UTC)
Received: from [10.44.34.158] (unknown [10.44.34.158])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2BE5519560AB;
	Wed, 21 Jan 2026 16:55:57 +0000 (UTC)
Date: Wed, 21 Jan 2026 17:55:55 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
cc: dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>, 
    Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dm: fix excessive blk-crypto operations for invalid
 keys
In-Reply-To: <20260117030236.96871-1-ebiggers@kernel.org>
Message-ID: <5cd121df-1f26-b484-f991-eeaaa33e767d@redhat.com>
References: <20260117030236.96871-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Accepted, thanks.

Mikulas


On Fri, 16 Jan 2026, Eric Biggers wrote:

> dm_exec_wrappedkey_op() passes through the derive_sw_secret, import_key,
> generate_key, and prepare_key blk-crypto operations to an underlying
> device.
> 
> Currently, it calls the operation on every underlying device until one
> returns success.
> 
> This logic is flawed when the operation is expected to fail, such as an
> invalid key being passed to derive_sw_secret.  That can happen if
> userspace passes an invalid key to the FS_IOC_ADD_ENCRYPTION_KEY ioctl.
> 
> When that happens on a device-mapper device that consists of many
> dm-linear targets, a lot of unnecessary key unwrapping requests get sent
> to the underlying key wrapping hardware.
> 
> Fix this by considering the first device only.  As already documented in
> the comment, it was already checked that all underlying devices support
> wrapped keys, so this should be fine.
> 
> Fixes: e93912786e50 ("dm: pass through operations on wrapped inline crypto keys")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  drivers/md/dm-table.c | 12 +++---------
>  1 file changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 0522cd700e0e..4b70872725d0 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -1235,13 +1235,10 @@ static int dm_wrappedkey_op_callback(struct dm_target *ti, struct dm_dev *dev,
>  	struct block_device *bdev = dev->bdev;
>  	struct blk_crypto_profile *profile =
>  		bdev_get_queue(bdev)->crypto_profile;
>  	int err = -EOPNOTSUPP;
>  
> -	if (!args->err)
> -		return 0;
> -
>  	switch (args->op) {
>  	case DERIVE_SW_SECRET:
>  		err = blk_crypto_derive_sw_secret(
>  					bdev,
>  					args->derive_sw_secret.eph_key,
> @@ -1264,13 +1261,11 @@ static int dm_wrappedkey_op_callback(struct dm_target *ti, struct dm_dev *dev,
>  					     args->prepare_key.lt_key_size,
>  					     args->prepare_key.eph_key);
>  		break;
>  	}
>  	args->err = err;
> -
> -	/* Try another device in case this fails. */
> -	return 0;
> +	return 1; /* No need to continue the iteration. */
>  }
>  
>  static int dm_exec_wrappedkey_op(struct blk_crypto_profile *profile,
>  				 struct dm_wrappedkey_op_args *args)
>  {
> @@ -1292,18 +1287,17 @@ static int dm_exec_wrappedkey_op(struct blk_crypto_profile *profile,
>  	 * implementations of wrapped inline crypto keys on a single system.
>  	 * It was already checked earlier that support for wrapped keys was
>  	 * declared on all underlying devices.  Thus, all the underlying devices
>  	 * should support all wrapped key operations and they should behave
>  	 * identically, i.e. work with the same keys.  So, just executing the
> -	 * operation on the first device on which it works suffices for now.
> +	 * operation on the first device suffices for now.
>  	 */
>  	for (i = 0; i < t->num_targets; i++) {
>  		ti = dm_table_get_target(t, i);
>  		if (!ti->type->iterate_devices)
>  			continue;
> -		ti->type->iterate_devices(ti, dm_wrappedkey_op_callback, args);
> -		if (!args->err)
> +		if (ti->type->iterate_devices(ti, dm_wrappedkey_op_callback, args) != 0)
>  			break;
>  	}
>  out:
>  	dm_put_live_table(md, srcu_idx);
>  	return args->err;
> 
> base-commit: fb8a6c18fb9a6561f7a15b58b272442b77a242dd
> -- 
> 2.52.0
> 


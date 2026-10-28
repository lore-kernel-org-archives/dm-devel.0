Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793163581;
	b=A9bozuAYY1rGuhKvNwzmNQ7zYFZzN5NjOo5n+FgZPQDaTQf4NR+mzIPY41UTHTIs8yCq
	 Klqu4UoRFUx/4I8viYN1C0xY7fY9/mr0Q7N/enLZiO6X6qLoYcBr8r+0ek61w+xpIjA6W
	 nj/7qCpAJnMJU98Tv3f9soqWlRuzAQWgXh7WNjXdsvpW0PFrcyO6NqAEzYsBzq2u1eHtF
	 +7HzZBn+0orint6lvqntKwSFmonpVl97UXHIo+ggxSv7ChTd1yojGN2k0WVuGgGB9HbfT
	 XZJxWsl7nt6HPvYREFuJJRzIKD8gk40EwW5SeBW+vSKyHPRYJZAj5o/aLvruGeq1zEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793163581;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:In-Reply-To:
	 X-Scanned-By:X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:
	 Content-Type:Content-Disposition;
	bh=8//9UdS2L4hf6P3q4d9kP+WN6X+gVmgNBaenMPmJ8yE=;
	b=UAPLWqpOcdCAJwwZ3TE/ZNjRcRDp1x9MFn8SfM2HbO1SXsOhn04UAN52KVHmvewsSc4h
	 zD1a+QAy4jzh5oVNa8KHvMDNg48FHMZHOHB53+bwyS7wPfrwVHJ+YKVqRAmZU3ejkUA3X
	 1HZj1g4X+vGc859CAoOvBBJVqVQxLRxffC+eDRDPWvAmKcsBEHy24xg4y+oWO/Vj6QJ9R
	 lBKj+R45PF0wOryQT809pt53wf4L1B8ZhmfUxI9K6952I+TWQmbjR8CnrDUDgVf2VMgJP
	 RUFAfipXl9PtQd+KAadYK3uoOadgvy1/cepMhYpTcQ2sWevBfWuovxRg7MMlBE/hmug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=G3hv1fiQ;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A69606A31E
	for <dm-devel@lists.linux.dev>; Wed, 28 Oct 2026 04:59:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A1A69606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=G3hv1fiQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793163579;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8//9UdS2L4hf6P3q4d9kP+WN6X+gVmgNBaenMPmJ8yE=;
	b=G3hv1fiQQeKk+qEYOmmnoio4aeLngfjmR50+a4CmOOzg/Xx1iNmoUj38lbD4FQkaQBT8tp
	HyT5Ep7SWrFqZkTJquBfPNqF61S9Pjtwjxpa8u68b33/4gUyk80A67gobIEl/V6B+BW9XM
	479mOJNx+wamqhFg1FyfSJp9j52DX70=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-376-sm4rEyDLOJ6Arwg0pI6MlA-1; Wed,
 28 Oct 2026 00:59:32 -0400
X-MC-Unique: sm4rEyDLOJ6Arwg0pI6MlA-1
X-Mimecast-MFC-AGG-ID: sm4rEyDLOJ6Arwg0pI6MlA_1793163570
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7E3FA1956050;
	Wed, 28 Oct 2026 04:59:30 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9A1C830001B9;
	Wed, 28 Oct 2026 04:59:29 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 69S4xSO4321085
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 28 Oct 2026 00:59:28 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 69S4xRwO321084;
	Wed, 28 Oct 2026 00:59:27 -0400
Date: Wed, 28 Oct 2026 00:59:27 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Rahul Rao <shreeramrahul94@gmail.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Joe Thornber <thornber@redhat.com>, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org,
        syzbot+83827f9a59abe148bff4@syzkaller.appspotmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] dm thin: prevent use-after-free when metadata and data
 devices alias
Message-ID: <auGBLzpQBLvds2vl@redhat.com>
References: <20261026110402.103622-1-shreeramrahul94@gmail.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <20261026110402.103622-1-shreeramrahul94@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: _uWwP7Y_G36IVRj6ROmI3WzybNv-_bF7_Xgjy3PyFYE_1793163570
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 26, 2026 at 04:34:02PM +0530, Rahul Rao wrote:
> pool_ctr() takes separate specification strings for the metadata and data
> devices. However, different strings (or format representations such as
> /dev/ram0 and 1:0) can resolve to the same underlying block device.
> 
> When the read_only feature is requested, the metadata device is opened
> read-only before the data device is opened read-write. If the devices
> alias, the second dm_get_device() call upgrades the existing device's
> mode. upgrade_mode() replaces the dm_dev and drops the old table device,
> leaving pool_ctr() with a stale metadata_dev pointer. The subsequent
> metadata_dev->bdev access triggers a KASAN use-after-free report.
> 
> Acquire the read-write data device first so that acquiring the metadata
> device cannot trigger this mode upgrade. Then reject matching block
> devices, including those specified through different names, and release
> the devices in reverse acquisition order on error.

What this patch fixes looks good to me, but there is still an issue
here. There is a similar problem in thin_ctr() if the pool and origin
device name strings are different but they alias. Unfortunately, this
style of fix doesn't work as well there. It is only a valid fix for a
thin-pool target because that is a DM_TARGET_SINGLETON. That means there
can't be another target that's part of the same table. This isn't the
case with the thin target. There can be other targets in the table, and
you can't force correct dm_get_device() ordering between them. Like
Mikulas said about a similar issue with dm-snapshot, this is probably
something that is better fixed in dm_get_device() than in its callers.

-Ben

> 
> Reported-by: syzbot+83827f9a59abe148bff4@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=83827f9a59abe148bff4
> Fixes: 991d9fa02da0 ("dm: add thin provisioning target")
> Cc: stable@vger.kernel.org
> Signed-off-by: Rahul Rao <shreeramrahul94@gmail.com>
> ---
>  drivers/md/dm-thin.c | 22 ++++++++++++++--------
>  1 file changed, 14 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> index 59392de7a477..52e47874048d 100644
> --- a/drivers/md/dm-thin.c
> +++ b/drivers/md/dm-thin.c
> @@ -3326,18 +3326,24 @@ static int pool_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  
>  	metadata_mode = BLK_OPEN_READ |
>  		((pf.mode == PM_READ_ONLY) ? 0 : BLK_OPEN_WRITE);
> -	r = dm_get_device(ti, argv[0], metadata_mode, &metadata_dev);
> +	r = dm_get_device(ti, argv[1], BLK_OPEN_READ | BLK_OPEN_WRITE, &data_dev);
>  	if (r) {
> -		ti->error = "Error opening metadata block device";
> +		ti->error = "Error getting data device";
>  		goto out_unlock;
>  	}
> -	warn_if_metadata_device_too_big(metadata_dev->bdev);
>  
> -	r = dm_get_device(ti, argv[1], BLK_OPEN_READ | BLK_OPEN_WRITE, &data_dev);
> +	r = dm_get_device(ti, argv[0], metadata_mode, &metadata_dev);
>  	if (r) {
> -		ti->error = "Error getting data device";
> -		goto out_metadata;
> +		ti->error = "Error opening metadata block device";
> +		goto out_data;
> +	}
> +
> +	if (metadata_dev->bdev == data_dev->bdev) {
> +		ti->error = "Metadata and data devices must be different";
> +		r = -EINVAL;
> +		goto out;
>  	}
> +	warn_if_metadata_device_too_big(metadata_dev->bdev);
>  
>  	if (kstrtoul(argv[2], 10, &block_size) || !block_size ||
>  	    block_size < DATA_DEV_BLOCK_SIZE_MIN_SECTORS ||
> @@ -3426,9 +3432,9 @@ static int pool_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  out_free_pt:
>  	kfree(pt);
>  out:
> -	dm_put_device(ti, data_dev);
> -out_metadata:
>  	dm_put_device(ti, metadata_dev);
> +out_data:
> +	dm_put_device(ti, data_dev);
>  out_unlock:
>  	mutex_unlock(&dm_thin_pool_table.mutex);
>  
> -- 
> 2.43.0


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F53F2F7EE6
	for <dm-devel@lists.linux.dev>; Mon, 21 Sep 2026 14:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790000189; cv=none; b=HiZnqWUJVVJCWZQheHO9wo/L0y010xUuYXq6poWi/gSCCU3QHFQUJkDKAeMLhuOkYXdlRcSbXbr5TiSYkqPKHhrzXSMBa44hbz6Mg+dfdUVLJULWmZBeiULl8stiBWeCXwKKE0wH84BW7owOh1Vg00QWF5iQUytJRpjs2DwN/nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790000189; c=relaxed/simple;
	bh=aLhhnuP9dq8Tk/mgcT9qT+9aYOSuvcvH9bNLx4gJMr8=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=QNCbuh6K494RIhGb9mffWcXuOHzltXq82lNBlZ2ykMv+L7XYdIb7S7oAi3oYN8mOPtE4zwAzG/XYEekIEhNzL7sfHJhaL6EN6wPXgn+zxiJV8usZeXBJhTpq/jUVmKGgpdihM6x1a89U6UKRHMCQrgdo3kR0120enWWSX9Dc36U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gq/E8NFa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gq/E8NFa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790000187;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V1nq6G0WiuHBJiMFE3WU1kHulyCOViVMS06shaIK9Z0=;
	b=gq/E8NFapnIK3yiKGsHfukw2rBs54RwxSJMInDqW5mCZq7mg4//VpakqwVNkdKKyOmbZ0d
	T2TD+8Lo5nw1d14tgXHEdHqKTvnqM07vpXsswjvdEHTTCIm9994ywWBzOnAq1AkDunRCI5
	8bxUfjCIJ6IjTounA+YV6kdq9J2EKNg=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-336-cVKy-zSvN6mPcHE7xxqbyQ-1; Mon,
 21 Sep 2026 10:16:25 -0400
X-MC-Unique: cVKy-zSvN6mPcHE7xxqbyQ-1
X-Mimecast-MFC-AGG-ID: cVKy-zSvN6mPcHE7xxqbyQ_1790000184
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7A842180A97D;
	Mon, 21 Sep 2026 14:16:24 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0FE28180029C;
	Mon, 21 Sep 2026 14:16:21 +0000 (UTC)
Date: Mon, 21 Sep 2026 16:16:19 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, linux-kernel@vger.kernel.org, 
    Peng Fan <peng.fan@nxp.com>, dm-devel@lists.linux.dev
Subject: Re: [Patch V2] dm: use assign_bit() where applicable
In-Reply-To: <20260921081009.278532-1-peng.fan@oss.nxp.com>
Message-ID: <23daf47a-1a1e-2a2d-1fc8-0e9a01183e0d@redhat.com>
References: <20260921081009.278532-1-peng.fan@oss.nxp.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: -NZDeMNVj3aT2BOYVeprDyWyhkm8rPSj78Cku0O__9I_1790000184
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Accepted, thanks.

Mikulas



On Mon, 21 Sep 2026, Peng Fan (OSS) wrote:

> From: Peng Fan <peng.fan@nxp.com>
> 
> Convert open-coded if/else with set_bit/clear_bit to the assign_bit API.
> 
> Done with Coccinelle semantic patch:
>     // set_bit -> clear_bit => assign_bit
> 
>     @@
>     expression cond, bit, addr;
>     @@
> 
>     -if (cond)
>     -        set_bit(bit, addr);
>     -else
>     -        clear_bit(bit, addr);
>     +assign_bit(bit, addr, cond);
> 
>     // clear_bit -> set_bit => assign_bit
> 
>     @@
>     expression cond, bit, addr;
>     @@
> 
>     -if (cond)
>     -        clear_bit(bit, addr);
>     -else
>     -        set_bit(bit, addr);
>     +assign_bit(bit, addr, !cond);
> 
> Signed-off-by: Peng Fan <peng.fan@nxp.com>
> ---
> 
> V2:
>  Separate device-mapper and mraid
>  https://lore.kernel.org/all/20260918141737.3023011-1-peng.fan@oss.nxp.com/
> 
>  drivers/md/dm-mpath.c                  | 5 +----
>  drivers/md/dm-zone.c                   | 6 ++----
>  drivers/md/persistent-data/dm-bitset.c | 5 +----
>  3 files changed, 4 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index 7cb7bb6233b6..ae9318f5f21b 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -1604,10 +1604,7 @@ static void pg_init_done(void *data, int errors)
>  		goto out;
>  
>  	if (test_bit(MPATHF_PG_INIT_REQUIRED, &m->flags)) {
> -		if (delay_retry)
> -			set_bit(MPATHF_PG_INIT_DELAY_RETRY, &m->flags);
> -		else
> -			clear_bit(MPATHF_PG_INIT_DELAY_RETRY, &m->flags);
> +		assign_bit(MPATHF_PG_INIT_DELAY_RETRY, &m->flags, delay_retry);
>  
>  		if (__pg_init_all_paths(m))
>  			goto out;
> diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
> index f29acf64429a..35916c6e490e 100644
> --- a/drivers/md/dm-zone.c
> +++ b/drivers/md/dm-zone.c
> @@ -447,10 +447,8 @@ void dm_finalize_zone_settings(struct dm_table *t, struct queue_limits *lim)
>  	struct mapped_device *md = t->md;
>  
>  	if (lim->features & BLK_FEAT_ZONED) {
> -		if (dm_table_supports_zone_append(t))
> -			clear_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
> -		else
> -			set_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
> +		assign_bit(DMF_EMULATE_ZONE_APPEND, &md->flags,
> +			   !dm_table_supports_zone_append(t));
>  	} else {
>  		clear_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
>  		md->disk->nr_zones = 0;
> diff --git a/drivers/md/persistent-data/dm-bitset.c b/drivers/md/persistent-data/dm-bitset.c
> index 00c0a3f186b7..6680f05c25ec 100644
> --- a/drivers/md/persistent-data/dm-bitset.c
> +++ b/drivers/md/persistent-data/dm-bitset.c
> @@ -59,10 +59,7 @@ static int pack_bits(uint32_t index, void *value, void *context)
>  		if (r)
>  			return r;
>  
> -		if (bv)
> -			set_bit(bit, (unsigned long *) &word);
> -		else
> -			clear_bit(bit, (unsigned long *) &word);
> +		assign_bit(bit, (unsigned long *)&word, bv);
>  	}
>  
>  	*((__le64 *) value) = cpu_to_le64(word);
> -- 
> 2.51.0
> 


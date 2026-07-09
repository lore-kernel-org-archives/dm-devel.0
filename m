Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926961FC0EA
	for <dm-devel@lists.linux.dev>; Thu,  9 Jul 2026 13:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783602783; cv=none; b=JIR6QHgru1FReGNG6EwvfAjPgmWXsQLT+ngO4X0VMleSx4ZJGZYbQjQrP7xQUYN1p5+BU546lqE3If9S+uDdcUYMMOclySwoL6NY/P8QWv3mgvubd/H+Oovxr0zVFnZVHW259A38hJ5CI3QJhvlX4pnayKiu5FEvkwng/87lDYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783602783; c=relaxed/simple;
	bh=aOH+9QdLe/v6xFoY6TModI2wDTrBbKpta9eljvmyWbg=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Cn2Witx5O2dBU2mb0Nq38fzrnV0dFZ7TLIzUXsJjn2QyRq5vhVlUAR4vEl6fD00YeC0aPomM2aHI5xL/vxk/0UdHSZQkBGQo63pjLZDk0ecbk7cluyNMGszSWNINPSXH7Ggm+WAEeXVDj3Y7ixnb//ozGc4K4z3NqdZDQyVj2nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AhZ5izTW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AhZ5izTW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783602779;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=us4PU3GjSyXEp0chMUwZ50iVae7ZrxysFLy5Il7KGl8=;
	b=AhZ5izTWkL4jLwvXZ+vH8xEtJdlgvxmxyL1bxwfCPF9qroyd+xe4oZM7ysu0zEtjsV6L+O
	GoGzXmhERUOlNOgSFyucfrfxqF9evmzQxWUsYbiSJIscCVUYSCPGxDBaNsdNx3O+tv95UR
	eycZR9HLgWpcWsUzrvjl2Jpw23mY/xM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-80-NaHZJpl-MO2drmBqNSkF9w-1; Thu,
 09 Jul 2026 09:12:52 -0400
X-MC-Unique: NaHZJpl-MO2drmBqNSkF9w-1
X-Mimecast-MFC-AGG-ID: NaHZJpl-MO2drmBqNSkF9w_1783602771
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 030711955F70;
	Thu,  9 Jul 2026 13:12:51 +0000 (UTC)
Received: from [10.44.32.225] (unknown [10.44.32.225])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7C6DB180035F;
	Thu,  9 Jul 2026 13:12:49 +0000 (UTC)
Date: Thu, 9 Jul 2026 15:12:45 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
cc: Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev, 
    Junrui Luo <moonafterrain@outlook.com>
Subject: Re: [PATCH] dm-log: fix a bitset_size overflow on 32bit machines
In-Reply-To: <20260703014339.1815538-1-bmarzins@redhat.com>
Message-ID: <b2620e1c-0a62-84fb-b9ed-073a0396275a@redhat.com>
References: <20260703014339.1815538-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HcWujm8oNNoT8Ddgr7zt0BIzerMI6fjtTdXkcPM0-Dw_1783602771
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Thu, 2 Jul 2026, Benjamin Marzinski wrote:

> Commit c20e36b7631d ("dm log: fix out-of-bounds write due to
> region_count overflow") made sure that region_count could fit in an
> unsigned int. But the bitmap memory isn't allocated based on
> region_count. It uses bitset_size (a size_t variable). The first step of
> calculating bitset_size is to set it to region_count, rounded up to a
> multiple of BITS_PER_LONG. If region_size is less than BITS_PER_LONG
> smaller than UINT_MAX, it will get rounded up to 2^32. On a 32bit
> architecture, this will make bitset_size wrap around to 0 and fail,
> despite region_count being valid.
> 
> Since bitset_size gets divided by 8, it can hold any valid region_count.
> It just needs a special case to handle the rollover. If it is 0, the
> value rolled over, and bitset size should be set to the number of bytes
> needed to hold 2^32 bits.
> 
> Fixes: c20e36b7631d ("dm log: fix out-of-bounds write due to region_count overflow")
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  drivers/md/dm-log.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
> index d316757a328b..77a0ee186aab 100644
> --- a/drivers/md/dm-log.c
> +++ b/drivers/md/dm-log.c
> @@ -425,6 +425,9 @@ static int create_log_context(struct dm_dirty_log *log, struct dm_target *ti,
>  	 */
>  	bitset_size = dm_round_up(region_count, BITS_PER_LONG);
>  	bitset_size >>= BYTE_SHIFT;
> +	/* Handle dm_round_up rollover on 32-bit systems */
> +	if (!bitset_size)
> +		bitset_size = 1 << (BITS_PER_LONG - BYTE_SHIFT);
>  
>  	lc->bitset_uint32_count = bitset_size / sizeof(*lc->clean_bits);
>  
> -- 
> 2.53.0

Hi

This triggers a warning on 64-bit systems, because 1 (32-bit int) will be 
shifted left by 61. I fixed it, no need to resend it.

Mikulas


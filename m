Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E3C329C7D
	for <dm-devel@lists.linux.dev>; Thu,  8 Jan 2026 20:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767904904; cv=none; b=LSBqhmcJ9IFhHuK+3VuMaum6KQMfuSwWvhuiGLQppChNnpRD2nteFxXpK7gH+DvC1dRzagMDEXRx+oFYx9tOTyj+5iaFxEKNE1aq3631NSOBjGacleIBCbcYgpgzD2uM0/tFeQ8chd+px32bDKBsoIALMFqT/OXw3IouYwK1D0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767904904; c=relaxed/simple;
	bh=NrvNdbNo5H9JDv3k/AeKN8XtWFy1TOcEu7QZK4H5L7o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=GzIqdBwvRGgTkGlZ7mtwnVhW9umHaYe1cWn1nCu62Dx54oG9zqsKoAb9tlbncKHTcE+Tfm284iOHsh4oXvU8FLDVE8auaQpo9EME0YSi/PQ85Esd5t36+mxi6kpfv/uQTsKXYsXT/kkoJqCREIzgpuQrPyL0ArmAxKJ7QLukyCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K9wb7N+3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K9wb7N+3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767904902;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gqt8EMChQB2sgLhnn9NuDW9qeiuE5GYBoEdiGkSx+eg=;
	b=K9wb7N+3kAjqU/ncdRv7ZKNi75DODGmoCVtnEc5K+dmk2Ggi2PfbfIVpFiGPgR8lW+6EDS
	zWXRkPn0CuAOpvC4QFVLBIO22RM8gXitWNeFl/PO5kAgpshJ7M47Ht2NaSdCWpg3R9DIHQ
	SiSLSr21hiSaFttBicwoAV59nvLDOGE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-583-SvCAGZmWNAatU-EzdJAVHg-1; Thu,
 08 Jan 2026 15:41:38 -0500
X-MC-Unique: SvCAGZmWNAatU-EzdJAVHg-1
X-Mimecast-MFC-AGG-ID: SvCAGZmWNAatU-EzdJAVHg_1767904897
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3F8F41955F44;
	Thu,  8 Jan 2026 20:41:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0931830002D2;
	Thu,  8 Jan 2026 20:41:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 608KfZ2S3079089
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 8 Jan 2026 15:41:35 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 608KfZRa3079088;
	Thu, 8 Jan 2026 15:41:35 -0500
Date: Thu, 8 Jan 2026 15:41:35 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH] dm: fix unlocked test for dm_suspended_md
Message-ID: <aWAWf7ays5fU4sj1@redhat.com>
References: <daf004a4-e171-8225-4d14-f0cfb3ce9b22@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <daf004a4-e171-8225-4d14-f0cfb3ce9b22@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7mUJT0-K25fHpTXzewJmAYdql8vdWLcHc-VkggmpzdM_1767904897
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 08, 2026 at 08:55:08PM +0100, Mikulas Patocka wrote:
> The function dm_blk_report_zones tests if the device is suspended with
> the "dm_suspended_md" call. However, this function is called without
> holding any locks, so the device may be suspended just after it.
> 
> Move the call to dm_suspended_md after dm_get_live_table, so that the
> device can't be suspended after the suspended state was tested.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Fixes: 37f53a2c60d0 ("dm: fix dm_blk_report_zones")

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> ---
>  drivers/md/dm-zone.c |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/drivers/md/dm-zone.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-zone.c	2026-01-06 15:55:41.000000000 +0100
> +++ linux-2.6/drivers/md/dm-zone.c	2026-01-06 22:55:36.000000000 +0100
> @@ -60,11 +60,13 @@ int dm_blk_report_zones(struct gendisk *
>  		 * Zone revalidation during __bind() is in progress, but this
>  		 * call is from a different process
>  		 */
> -		if (dm_suspended_md(md))
> -			return -EAGAIN;
> -
>  		map = dm_get_live_table(md, &srcu_idx);
>  		put_table = true;
> +
> +		if (dm_suspended_md(md)) {
> +			ret = -EAGAIN;
> +			goto do_put_table;
> +		}
>  	} else {
>  		/* Zone revalidation during __bind() */
>  		map = zone_revalidate_map;
> @@ -79,6 +81,7 @@ int dm_blk_report_zones(struct gendisk *
>  		ret = dm_blk_do_report_zones(md, map, nr_zones, &dm_args);
>  	}
>  
> +do_put_table:
>  	if (put_table)
>  		dm_put_live_table(md, srcu_idx);
>  


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49AD1534E4
	for <dm-devel@lists.linux.dev>; Wed,  5 Jun 2024 19:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717616877; cv=none; b=dSfOG6Adv0lHlY3/PXpKWSapTG6uyspVfmSjKQl78ociXnACiUumimFUb32WD7URMJ5SxYapxKTSDp+XicjxKG1CkhPXBOdOz/US98dJMCpLruU+cyypjOvjtzi+nrh4vxN1xf1snITZtdqLkCi8FWhM/HAmSOap7AhVLCUWTNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717616877; c=relaxed/simple;
	bh=9OKgBsV7RBSeayqdw0/fkMkvMxBwGmMeJOI2kkvm3JQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eTjJkwnxwAGCfMBf3IwbHHa52e0BkZOLatSDvQvnu7D/pmFEIXgX8t8h3KjVSnM3d0GMLHE6JIaG/Sd6ZpYMJjWMDM8w3CbaGF6IVsr9hp+affDvzL3J6ublRcBspBBE52Co12QoOfvCA8aXRY8Sl8+JG0VIx64TPFNzHZh1HbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TtjZdaE2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TtjZdaE2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717616874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IR6BXJd96FArYmP+akXbQdmnrU/B47deB/gC19fhAT4=;
	b=TtjZdaE2rv7hQQHC5jhNSCWMC6IV2pxmX10vH/Ij3mqrmoFVq9I0QLnip+O3Y/v71s1uOx
	87GLuV2W1Taq0nF1oUcLrLE9z7RcLrVsUWCgV/IvHuQ4TLO5JXCq8j0/9gVlTFee0VonGb
	g9ZHicnXsZK04xukYOsexa8HNZ6DzNk=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-156-NRS0oFk-NXC2t2CmnUv1aA-1; Wed,
 05 Jun 2024 15:47:51 -0400
X-MC-Unique: NRS0oFk-NXC2t2CmnUv1aA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 077D43C025B2;
	Wed,  5 Jun 2024 19:47:51 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B58F72023299;
	Wed,  5 Jun 2024 19:47:50 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 455JloDl617712
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 5 Jun 2024 15:47:50 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 455JlnpU617710;
	Wed, 5 Jun 2024 15:47:49 -0400
Date: Wed, 5 Jun 2024 15:47:49 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 2/3] dm: Improve zone resource limits handling
Message-ID: <ZmDA5fmZMNGM1oFl@redhat.com>
References: <20240605075144.153141-1-dlemoal@kernel.org>
 <20240605075144.153141-3-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240605075144.153141-3-dlemoal@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

On Wed, Jun 05, 2024 at 04:51:43PM +0900, Damien Le Moal wrote:
> +static int dm_device_count_zones(struct dm_dev *dev,
> +				 struct dm_device_zone_count *zc)
> +{
> +	int ret;
> +
> +	ret = blkdev_report_zones(dev->bdev, 0, UINT_MAX,
> +				  dm_device_count_zones_cb, zc);

Other than the nitpick that BLK_ALL_ZONES looks better than UINT_MAX
here, looks good.

-Ben


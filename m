Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4323C3BB21
	for <dm-devel@lists.linux.dev>; Wed,  1 May 2024 03:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714532847; cv=none; b=jMIYfX5hBwyPwYAyKv23GAf2XDUVfDCCLtR12ugyuJfhAj+qudZZ2UpnQLbGBETDhXqB/PiRlbpF/mPt3O+kTyRX0GPprP0c48GhsgXrEosBp2Vh0UormDmolBsywIuU+y6oPo/8lVInlTrQUPMVKL8fhb2l1ibjXX9bPfBYqP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714532847; c=relaxed/simple;
	bh=wSUc2FwTDfPPE6WP4CvvzO1/ZMAEYZ9j5bVuglWkl4w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QnoyAcPfSKSak94NauAduwx9oK7h0wudgxfDMhU3l6yO4FuUW1Z9C7bsGrBZlTn8b/NDJZ/TOzjLG45/72N3lILJL/UbrxFdoGUL2KI9M642vDoCLmoRRKSmVgvhr/iYhnJ3+yxVWEccA19W5CHoqf4XYgDn5UCO0IKg3AcTsaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PMZ5cQKJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PMZ5cQKJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714532844;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Sju1Ab7ZCysbObAJ/nrqrXkGolEBNJ+eeY6KCDXLgHs=;
	b=PMZ5cQKJqJ8pJDlX+sl+4toMc9z3aKYXEOh0C/Ut8GvEFZ3AvM/LfzHe3xDJRcAqO7A63t
	rZfuQpjliZ0cRssqqftIrQHKEvO71uHgCcY9aWogInCEHFdUio75NWxpCt4KpN5JEhrn/J
	pdtjKQtrDH7MUGYioxuHKIBLD24IxaQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-586-AFCjJW5APYaMUdWysAPCOA-1; Tue, 30 Apr 2024 23:07:22 -0400
X-MC-Unique: AFCjJW5APYaMUdWysAPCOA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3D1831011A14;
	Wed,  1 May 2024 03:07:21 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D73DA202450F;
	Wed,  1 May 2024 03:07:20 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 44137Kom2345106
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 30 Apr 2024 23:07:20 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 44137Kcx2345105;
	Tue, 30 Apr 2024 23:07:20 -0400
Date: Tue, 30 Apr 2024 23:07:20 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2 01/14] dm: Check that a zoned table leads to a valid
 mapped device
Message-ID: <ZjGx6EpCIx5QnmT5@redhat.com>
References: <20240501000935.100534-1-dlemoal@kernel.org>
 <20240501000935.100534-2-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240501000935.100534-2-dlemoal@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

On Wed, May 01, 2024 at 09:09:22AM +0900, Damien Le Moal wrote:
> +static int dm_check_zoned(struct mapped_device *md, struct dm_table *t)
> +{
> +	struct gendisk *disk = md->disk;
> +	unsigned int nr_conv_zones = 0;
> +	int ret;
> +
> +	/* Revalidate only if something changed. */
> +	md->zone_revalidate_map = t;
> +	ret = dm_blk_report_zones(disk, 0, UINT_MAX,
> +				  dm_check_zoned_cb, &nr_conv_zones);

Aside from not really understanding what that comment is getting at, it
looks good.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>


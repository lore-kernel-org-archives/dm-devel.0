Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2103168F8
	for <dm-devel@lists.linux.dev>; Thu,  8 Jan 2026 20:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767904927; cv=none; b=QlXnGUTQ8KmWDvS4zMiESPS2iz0sn2yeBPoo4nrOENsdEvE6SVr7NZGhXt4/qWyKdAm1oevmGno43wBagpVXoBeoOYwiayL6AZWjvDv6m39HN2zIVruSUyy8duAsAIDiLztTs60QSTRVWvXxyZQnqYLLiMLXK7v+fSgGAHg8AHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767904927; c=relaxed/simple;
	bh=5H6f017Vrku8rf6lWqSKkOzZq+fFSqbYREuNU8K4Amk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=nnjFVsT8d3QYzf+G13N+VKkKzJYpgWefQAMTKJcI0v+JEdM3pINp0BXTjbxn6fn5aSs+l0nqt+jEnSkrXvEB3EgiuQ1AeCF+lbM/lOg4TyYym0ZCcRffZQflNUL6fHPg1u7l6zY2bowh6U7UbgFyOQpV9iylIS5JMtaWTRPcISc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D3v9CuvP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D3v9CuvP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767904925;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+TInDJVtXPHmHuFrgRGzCIILKZlzXjxoVopT5U8YAL8=;
	b=D3v9CuvPY600d1O+tN3HvprYwqK/wh1H/IikI94HsOiXyLycHOadIVersVaNLfbywd6+fj
	JRSzVXGLU9uTxWOslmKFiitplSWkgNOO7U0lqYQqwqVai8FvIE1vSSStriJrdyFwmyv+u5
	DKl3x0m0KJXAMVRAH3YhTk34VDut4PU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-53-FOsF8pT3NqyiUk1LcWzFoQ-1; Thu,
 08 Jan 2026 15:42:03 -0500
X-MC-Unique: FOsF8pT3NqyiUk1LcWzFoQ-1
X-Mimecast-MFC-AGG-ID: FOsF8pT3NqyiUk1LcWzFoQ_1767904923
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E6CA318005AD;
	Thu,  8 Jan 2026 20:42:02 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B0E7718004D8;
	Thu,  8 Jan 2026 20:42:02 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 608Kg1QA3079112
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 8 Jan 2026 15:42:01 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 608Kg1PV3079111;
	Thu, 8 Jan 2026 15:42:01 -0500
Date: Thu, 8 Jan 2026 15:42:01 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH] dm: use READ_ONCE in dm_blk_report_zones
Message-ID: <aWAWmUhL_DyNtVd-@redhat.com>
References: <f99c02cf-8d0a-964d-c52b-a9a38c44ba73@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <f99c02cf-8d0a-964d-c52b-a9a38c44ba73@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cKA7rzLlon5rLCVXveoJMNQZlm2puWoI18_4BQP7TuE_1767904923
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 08, 2026 at 08:56:20PM +0100, Mikulas Patocka wrote:
> The functon dm_blk_report_zones reads md->zone_revalidate_map, however it
> may change while the function is running. Use READ_ONCE.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Fixes: 37f53a2c60d0 ("dm: fix dm_blk_report_zones")

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> 
> ---
>  drivers/md/dm-zone.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/drivers/md/dm-zone.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-zone.c	2026-01-06 22:57:00.000000000 +0100
> +++ linux-2.6/drivers/md/dm-zone.c	2026-01-06 22:57:00.000000000 +0100
> @@ -50,7 +50,7 @@ int dm_blk_report_zones(struct gendisk *
>  {
>  	struct mapped_device *md = disk->private_data;
>  	struct dm_table *map;
> -	struct dm_table *zone_revalidate_map = md->zone_revalidate_map;
> +	struct dm_table *zone_revalidate_map = READ_ONCE(md->zone_revalidate_map);
>  	int srcu_idx, ret = -EIO;
>  	bool put_table = false;
>  


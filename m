Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79FF113F452
	for <dm-devel@lists.linux.dev>; Thu, 28 Mar 2024 22:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711664382; cv=none; b=oOiiqFRK0pFcSKk94a6nhWK6OVYY4p/X2W5iWRMF9hlodkdKeYaZn1OkJzWoGJpLduulo/cwMRNljEJ2UUou6VO+fnoE36a1ENKFk/81E507NrriBl3Uqhq3FDEkDL2/ZLDZe7BY0+Zy4UZf83CEjUaX1P5mzCJqMpaxRtKQAqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711664382; c=relaxed/simple;
	bh=KNmyW5fEKd4KjDtcb2BedrvwQ/K9KSHvnnjPqGPoltY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WeXK9BXtqZ9v0tbIPEhFemCOMdG5EWVM1YZa3ryD9DA8pdRA6QgT7q3h0A7l2S2Zro8bRDLMw6FjiVJGLgQwy4mJ34u6dDyHjlBdhgdEMWKQfKa+BI96r7yTPj3NGx7Tv3PIJNGNB1LBIUjDjaxZ7KpAcGADRbDP8AdUnJl5laE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dFTVrvir; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dFTVrvir"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711664379;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=c0gVdAJady0w2m/mZdiSsjO56B184pXm5Ghe4hgiYIs=;
	b=dFTVrvirYFiNE8JqumieBzStPi1rP9FTfllic1xPEYO6UwxpmlLumr2YRDQJpjRDazdcxe
	9TuyqLhuGd/RVAfXohH0XJhauo5xnPyYLkw4LBNQt05deRTENjtMYZ9TvjzmF/QuJ5morl
	0kjAkWVL+TKE0LeDeqq3quXwBQxTwMU=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-552-Is6uAylFP6CykLsXkY2xAA-1; Thu,
 28 Mar 2024 18:19:34 -0400
X-MC-Unique: Is6uAylFP6CykLsXkY2xAA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 14395380213D;
	Thu, 28 Mar 2024 22:19:34 +0000 (UTC)
Received: from redhat.com (unknown [10.2.16.33])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 65AEC1C06690;
	Thu, 28 Mar 2024 22:19:31 +0000 (UTC)
Date: Thu, 28 Mar 2024 17:19:26 -0500
From: Eric Blake <eblake@redhat.com>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Alasdair Kergon <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev, 
	David Teigland <teigland@redhat.com>, Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Christoph Hellwig <hch@lst.de>, Joe Thornber <ejt@redhat.com>
Subject: Re: [RFC 5/9] selftests: block_seek_hole: add dm-zero test
Message-ID: <sr42hsk5rqu5siso6xwjlu5akfegl6glco3ug6pleawszgtfcb@h5pca4b3yqot>
References: <20240328203910.2370087-1-stefanha@redhat.com>
 <20240328203910.2370087-6-stefanha@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240328203910.2370087-6-stefanha@redhat.com>
User-Agent: NeoMutt/20240201
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

On Thu, Mar 28, 2024 at 04:39:06PM -0400, Stefan Hajnoczi wrote:
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>  .../selftests/block_seek_hole/Makefile        |  2 +-
>  .../testing/selftests/block_seek_hole/config  |  2 ++
>  .../selftests/block_seek_hole/dm_zero.sh      | 31 +++++++++++++++++++
>  3 files changed, 34 insertions(+), 1 deletion(-)
>  create mode 100755 tools/testing/selftests/block_seek_hole/dm_zero.sh
> 

> +++ b/tools/testing/selftests/block_seek_hole/dm_zero.sh
> @@ -0,0 +1,31 @@
> +#!/bin/sh
> +# SPDX-License-Identifier: GPL-2.0-only
> +#
> +# dm_zero.sh
> +#
> +# Test that dm-zero reports data because it does not have a custom
> +# SEEK_HOLE/SEEK_DATA implementation.

Why not?  Wouldn't it make more sense to have dm-zero report the
entire device as a hole (that is, an in-range SEEK_HOLE always returns
the same offset, while an in-range SEEK_DATA returns the device size)?

-- 
Eric Blake, Principal Software Engineer
Red Hat, Inc.
Virtualization:  qemu.org | libguestfs.org


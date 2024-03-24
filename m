Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F4514AA8
	for <dm-devel@lists.linux.dev>; Sun, 24 Mar 2024 08:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711267395; cv=none; b=GxU/MiwzO/SyoSF4m8o6IOVMgQkFPlDDVlZ1XGxT79bHPenCBJhZlSm/OFMCq8PZHyA3V0JjcHy2K6rYIB0ih5hJI/WpbKJnunT/qRS2d5+SP5HU0+IfswX69NZ0FDyLpDsg6hVFEKqWXe1tesK7FnlgzlXX4k3fyJg6UETzbII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711267395; c=relaxed/simple;
	bh=65S+d45kVYZvk0Qta65nEn3nPVBb4+ElYSARNub73tw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LHeZW5hj8Zg+IubjjxNI9GLbqwHuJTZ/VJrH9mdf5ZXn77bTQNsPxFlt1oQYEvW7Vfx6yT+VqIoITFTRcgqTrjtTxtuP1OkPZ6VEakS0N/sMir8DUF16HCb7uuN7vmJQoU0xXHGXXbNti/7JRQCfBOVAe6GQzhSv+kp1iN8jkWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W9DnCUec; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W9DnCUec"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711267392;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UkH7axQg1FEwje/Ll8aBk0BQmG+q/xLnYe921Xz2l0M=;
	b=W9DnCUec1Xqajhgn0RVybd/IHGYK81eA120GkFyIpv8/Ta4EbQLu6PBmzyjC/GTqH+yLZ2
	d+pMzl+B5pcF4RwdxJxM1VyLNIbVNJtzNqD+K1JtF4M56ZLFRNfzVSgIIUMTXah3Jsa02j
	SH2NJy5NSOwBBqSJlCnexmx1yGBrFJs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-412-ZCYTEYcEOii1TZxjTT-2YA-1; Sun, 24 Mar 2024 04:03:08 -0400
X-MC-Unique: ZCYTEYcEOii1TZxjTT-2YA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 61EF7185A781;
	Sun, 24 Mar 2024 08:03:08 +0000 (UTC)
Received: from fedora (unknown [10.72.116.114])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C05D5492BD3;
	Sun, 24 Mar 2024 08:03:04 +0000 (UTC)
Date: Sun, 24 Mar 2024 16:02:56 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Keith Busch <kbusch@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev
Subject: Re: block: fail unaligned bio from submit_bio_noacct()
Message-ID: <Zf/eMPDG2uotSg4M@fedora>
References: <20240321131634.1009972-1-ming.lei@redhat.com>
 <ZfxVqkniO-6jFFH5@redhat.com>
 <ea8a13c-ee40-47f9-a7be-17b84bd1f686@redhat.com>
 <ZfzoC/V07nExJ+0x@fedora>
 <ZfzvSguRii37MErS@kbusch-mbp>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfzvSguRii37MErS@kbusch-mbp>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

On Thu, Mar 21, 2024 at 08:39:06PM -0600, Keith Busch wrote:
> On Fri, Mar 22, 2024 at 10:08:11AM +0800, Ming Lei wrote:
> > On Thu, Mar 21, 2024 at 06:01:41PM +0100, Mikulas Patocka wrote:
> > > I would change it to
> > > 
> > > if (unlikely(((bi_iter.bi_sector | bio_sectors(bio)) & ((queue_logical_block_size(q) >> 9) - 1)) != 0))
> > > 	return false;
> > 
> > What if bio->bi_iter.bi_size isn't aligned with 512? The above check
> > can't find that at all.
> 
> Shouldn't that mean this check doesn't apply to REQ_OP_DRV_IN/OUT?

For REQ_OP_DRV_IN/OUT, only the real user IO command may need the check,
and others needn't this check, maybe they don't use .bi_sector or
.bi_size at all.

> Those ops don't necessarily imply any alignment requirements. It may not
> matter here since it looks like all existing users go through
> blk_execute_rq() instead of submit_bio(), but there are other checks for
> DRV_IN/OUT in this path, so I guess it is supposed to be supported?

This patch focuses on FS bio, and passthough request case is more
complicated, and we even don't have central entry for real user pt IO
request only.


Thanks, 
Ming


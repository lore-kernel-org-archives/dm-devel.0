Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F9739FFF
	for <dm-devel@lists.linux.dev>; Thu,  1 Feb 2024 03:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706757597; cv=none; b=G8Cw6ZAe21xrp0dpu7DQQtxsmQ2fZX+igKaG8o2J5qLQ1h/BuCxj2ddJaWALZ2uSSZeKOBEk74PfDJLdIy5rWu5a+OWWg5kA6L0WYMXV9CaHgb7Bm5xKivtVGsIwERXcRsedfTm4cJwt2QKYPRfGEphk3+Q0UB15Obe2QDScqZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706757597; c=relaxed/simple;
	bh=N/kDI3MMwRn1oChKObsmf2WneGASs3YI0E0pQZ4hUm4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZAhraq66F1uvsGd0RZ+YmUdlA7ObTj9KZsq/urz4QdEhwgfsVByXq/SKjtrF8wHgMNPOMPq0v9wkL3W0pKRohpnobNt2i7Zw7oFdypmTMbLdRaKfIV6A5YcvWSmdt4ttEb7OvLUadSokBTfUu/kT0sUJUkt6zK+vFvEYbdQiqtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GOe1bth3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GOe1bth3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706757594;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SeHzJIlUgZ6pm1Y2b2G0fW8/bhuUaKx5YlYxBPszXD0=;
	b=GOe1bth3WX/5u5WCL6e3drivYw9ZWr5pXibhHgdnhCh8fT9wM7fKEvfpIvwdKIObOloecQ
	vzJj2hoPw/s3h8/pQ8Wu8Uijc45mYCX9MSg4uW4af+9R+8mkkblvPrtVhRZ8lHYu/CVE7C
	V5EKjPvviIpuDYRYeTdSuBxlCt7drnM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-131-WsNvGNSgMdGVIOEtG4evOQ-1; Wed, 31 Jan 2024 22:19:49 -0500
X-MC-Unique: WsNvGNSgMdGVIOEtG4evOQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D7E4185A780;
	Thu,  1 Feb 2024 03:19:48 +0000 (UTC)
Received: from fedora (unknown [10.72.116.107])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A02532BA;
	Thu,  1 Feb 2024 03:19:42 +0000 (UTC)
Date: Thu, 1 Feb 2024 11:19:38 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Mike Snitzer <snitzer@kernel.org>
Cc: axboe@kernel.dk, hongyu.jin.cn@gmail.com, ebiggers@kernel.org,
	dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	Hongyu Jin <hongyu.jin@unisoc.com>,
	Yibin Ding <yibin.ding@unisoc.com>,
	Eric Biggers <ebiggers@google.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH v9 1/5] block: Fix where bio IO priority gets set
Message-ID: <ZbsNytjvvPLNNwx4@fedora>
References: <20240130202638.62600-1-snitzer@kernel.org>
 <20240130202638.62600-2-snitzer@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240130202638.62600-2-snitzer@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

On Tue, Jan 30, 2024 at 03:26:34PM -0500, Mike Snitzer wrote:
> From: Hongyu Jin <hongyu.jin@unisoc.com>
> 
> Commit 82b74cac2849 ("blk-ioprio: Convert from rqos policy to direct
> call") pushed setting bio I/O priority down into blk_mq_submit_bio()
> -- which is too low within block core's submit_bio() because it
> skips setting I/O priority for block drivers that implement
> fops->submit_bio() (e.g. DM, MD, etc).
> 
> Fix this by moving bio_set_ioprio() up from blk-mq.c to blk-core.c and
> call it from submit_bio().  This ensures all block drivers call
> bio_set_ioprio() during initial bio submission.
> 
> Fixes: a78418e6a04c ("block: Always initialize bio IO priority on submit")
> Co-developed-by: Yibin Ding <yibin.ding@unisoc.com>
> Signed-off-by: Yibin Ding <yibin.ding@unisoc.com>
> Signed-off-by: Hongyu Jin <hongyu.jin@unisoc.com>
> Reviewed-by: Eric Biggers <ebiggers@google.com>
> Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
> [snitzer: revised commit header]
> Signed-off-by: Mike Snitzer <snitzer@kernel.org>

Looks fine,

Reviewed-by: Ming Lei <ming.lei@redhat.com>


Thanks,
Ming


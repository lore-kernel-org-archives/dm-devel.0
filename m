Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D006F42E8F1
	for <dm-devel@lists.linux.dev>; Thu,  9 Jul 2026 16:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783613611; cv=none; b=jN6r40+fvvZyjx2qlQe4yMEeJYqrJ2780MUu7F5mPHeC4XXIqoxA427TaKr6Q8jObkCTwx/yRaD8aq2Oh/RdBe4uE7lK5c+XMGqtXu9nKzBJ7VyQzc/dUvZ2D9pQjjkRX8giAe/1ZaGbn0clPh3bNyQweL4uKTUXVU9gYdxkge8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783613611; c=relaxed/simple;
	bh=zbY2bSEaCu31T0WXTlUACKyoNXNWjDA105FQaP4TAkQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=ep6/4G0WTPzAxp2dL7+BJhYUxiNyUtd7P9qI1lDKCr2N43EjG9WehMGuuu305DoI8lS+XNNpEJi8PHGmWWC3Hq+wiMu0pk6oYm1O9zvsMHVpjIKO59fXzYaxfkZC0fonJ9pHL8N1yu4DVqc4WwpPaXtQYxYwG+PS+uZTzjw2q1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aRtJn6Za; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aRtJn6Za"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783613608;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iTviDvuDhSfVkGar73Qrb9ZQD1B5BTK09OmZSnwxUg4=;
	b=aRtJn6Za4NWR8fd4+DkezkRzok3sEmg1kUVhJgHMa18CXA01iocqV1RbjLBtaI3NI5INZT
	2fVxEjm2Rphph6kBVP3Xyj8VptwjNw/RgmD+BbvfJ1SUMxJLC7w96hZq86z4+e66bhEodm
	6zuO4L4/83KqQS3iEIspi8YMpbNFjTk=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-422-yCqKLsm-O0GVQmhzLl7HCA-1; Thu,
 09 Jul 2026 12:13:22 -0400
X-MC-Unique: yCqKLsm-O0GVQmhzLl7HCA-1
X-Mimecast-MFC-AGG-ID: yCqKLsm-O0GVQmhzLl7HCA_1783613601
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 99A601800BDF;
	Thu,  9 Jul 2026 16:13:20 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ADD9E3000C01;
	Thu,  9 Jul 2026 16:13:19 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 669GDHvF2055297
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 9 Jul 2026 12:13:17 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 669GDGCO2055294;
	Thu, 9 Jul 2026 12:13:16 -0400
Date: Thu, 9 Jul 2026 12:13:16 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mike Snitzer <snitzer@kernel.org>
Cc: Keith Busch <kbusch@kernel.org>, axboe@kernel.dk,
        Mikulas Patocka <mpatocka@redhat.com>, Keith Busch <kbusch@meta.com>,
        dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
        "Dr. David Alan Gilbert" <linux@treblig.org>,
        Vjaceslavs Klimovs <vklimovs@gmail.com>
Subject: Re: [PATCH 2/2] dm-raid1: don't fail the mirror for invalid I/O
 errors
Message-ID: <ak_InD1CX7GJXzJv@redhat.com>
References: <20260616150554.1686662-1-kbusch@meta.com>
 <ajFyuoMqnvQm738z@kbusch-mbp>
 <0bd687cf-82ac-eacf-844b-c179a52dc72c@redhat.com>
 <akwVkSnXtyl6rBdh@kbusch-mbp>
 <ak1XNlyFC34W47iP@kernel.org>
 <ak7cHXaWjVX6Uamj@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ak7cHXaWjVX6Uamj@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: P5_ZzxoTixMOu-qyrhrFNWOZYEUPMYFE0UZFepLgoVU_1783613601
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 08, 2026 at 07:24:14PM -0400, Benjamin Marzinski wrote:
> On Tue, Jul 07, 2026 at 03:44:54PM -0400, Mike Snitzer wrote:
> > On Mon, Jul 06, 2026 at 02:52:33PM -0600, Keith Busch wrote:
> > > On Wed, Jun 24, 2026 at 01:14:03PM +0200, Mikulas Patocka wrote:

> > So where does dm-raid1 and dm-crypt stand relative to these DIO memory
> > alignment changes?  Inferring they are pretty exposed.
> > 
> > > > BTW. I think that blk_path_error should also test for BLK_STS_INVAL and 
> > > > return false, otherwise, dm-multipath would be suffering from this bug 
> > > > too. Ben, could you test it?
> > > 
> > > Good point.
> > 
> > Would appreciate knowing if multipath exposed too.
> 
> I can't make it happen. I can reproduce this using dm-mirror, but when I
> try with dm-multipath, it fails with BLK_STS_INVAL before it ever makes
> it into the request layer.
> 
> blk_mq_submit_bio() -> __bio_split_to_limits() -> bio_split_rw() ->
> bio_split_rw_at() -> bio_split_io_at()
> 
> bio_split_io_at() checks the bio_vec alignment and fails with -EINVAL,
> causing the bio to get failed.

However, as a general issue, I don't believe it's impossible to have an
unaligned bio_vec that returns false for bio_may_need_split(), so that
the splitting code will never get run. But if this is already getting
fixed earlier in the bio code, then the point is kind of moot.

In reference to changing blk_path_error(), multipath should only be
passing down requests that are valid on any of its paths, so it seems
reasonable to make the case that BLK_STS_INVAL is not a path error. But
if we are going to be checking the bios early against multipath's
limits, then it seems like the only reason we would get a BLK_STS_INVAL
is that multipath's limits don't work with the underlying path's. That
would likely mean there was a limit stacking bug, and who knows whether
another path would work better.

-Ben
 
> > 
> > Thanks,
> > Mike


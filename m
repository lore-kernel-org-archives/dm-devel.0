Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B237284662
	for <dm-devel@lists.linux.dev>; Thu, 15 May 2025 10:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747303922; cv=none; b=ZpTNmEu+3/QuiV5cMxDODd7ZFw0A6Lz0xg5croelkW+fsxRJgiUySXwzMlbjXu9C1zhS2mg7JI8lqRoDbQwS8XkqQAyN8CCgbBxbaE/OLrkAzJg1k9TwbKY6swnZyjO1f4Nut3i7bppAlptRH5bt4/+sfkR2XL5DANYhQxHuKFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747303922; c=relaxed/simple;
	bh=3MZkfwBnqjkppTndA3TyrtUNZ72s3mnrYhtf/Y5Q3vg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EcuT+ukL0PIlQ2q3IzrHvMp8U0khzRXL94cf4RfLhqCvkcR6KsXrrgkfx3bnzyyNI//F7i5dHcbZKoJnxDxLAipyQ9FEyTYsnmx5rNDaJzcW42VMtyKo5OcnNbM+vY8F2geRpDfUcWmScvu9lBLXt7LvAHPB1TcXpSS/PBPJTzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NYYRs1nm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NYYRs1nm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747303918;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FXOA9ey0mc2YYVtY7dX6y6yx+zTsszpuFBN07DKCk1s=;
	b=NYYRs1nmvGjor1nQdM6qZn28Cf14em7z1nj5DbykyGOiPoTNJnKMw0pMLUDO8SLgWWyFHh
	ZwIpdwnsytr7pHocHz3G+blcKKOqMgH4TpwDRsKkCjOFVLgGlQyb8n40GXTkHBIgTj0W7w
	1pVwmSaejdhv6CXtoXz79xCzEEItCgg=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-59-q3avyBW_OEGTuZ0Vv5BpHw-1; Thu,
 15 May 2025 06:11:57 -0400
X-MC-Unique: q3avyBW_OEGTuZ0Vv5BpHw-1
X-Mimecast-MFC-AGG-ID: q3avyBW_OEGTuZ0Vv5BpHw_1747303916
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 92FB31956089;
	Thu, 15 May 2025 10:11:55 +0000 (UTC)
Received: from redhat.com (unknown [10.45.224.242])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7D9E11956094;
	Thu, 15 May 2025 10:11:52 +0000 (UTC)
Date: Thu, 15 May 2025 12:11:49 +0200
From: Kevin Wolf <kwolf@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev,
	hreitz@redhat.com, mpatocka@redhat.com, snitzer@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] dm mpath: Interface for explicit probing of active
 paths
Message-ID: <aCW95f8RGpLJZwSA@redhat.com>
References: <20250429165018.112999-1-kwolf@redhat.com>
 <47dd225b433b0df585a25084a2e793344eeda239.camel@suse.com>
 <aCIRUwt5BueQmlMZ@redhat.com>
 <d51d6f85b5728648fe9c584f9cb3acee12c4873f.camel@suse.com>
 <cc2ec011cf286cb5d119f2378ecbd7b818e46769.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cc2ec011cf286cb5d119f2378ecbd7b818e46769.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Am 14.05.2025 um 23:21 hat Martin Wilck geschrieben:
> On Tue, 2025-05-13 at 10:00 +0200, Martin Wilck wrote:
> > > If you think it does, is there another reason why you didn't try
> > > this
> > > before?
> > 
> > It didn't occur to me back then that we could fail paths without
> > retrying in the kernel.
> > 
> > Perhaps we could have the sg driver pass the blk_status_t (which is
> > available on the sg level) to device mapper somehow in the sg_io_hdr
> > structure? That way we could entirely avoid the layering violation
> > between SCSI and dm. Not sure if that would be acceptible to
> > Christoph,
> > as blk_status_t is supposed to be exclusive to the kernel. Can we
> > find
> > a way to make sure it's passed to DM, but not to user space?
> 
> I have to correct myself. I was confused by my old patches which
> contain special casing for SG_IO. The current upstream code does of
> course not support special-casing SG_IO in any way. device-mapper
> neither looks at the ioctl `cmd` value nor at any arguments, and has
> only the Unix error code to examine when the ioctl returns. The device
> mapper layer has access to *less* information than the user space
> process that issued the ioctl. Adding hooks to the sg driver wouldn't
> buy us anything in this situation.
> 
> If we can't change this, we can't fail paths in the SG_IO error code
> path, end of story.

Yes, as long as we can't look at the sg_io_hdr, there is no way to
figure out if we got a path error.

> With Kevin's patch 1/2 applied, it would in principle be feasible to
> special-case SG_IO, handle it in the dm-multipath, retrieve the
> blk_status_t somehow, and possibly initiate path failover. This way
> we'd at least keep the generic dm layer clean of SCSI specific code.
> But still, the end result would look very similar attempt from 2021 and
> would therefore lead us nowhere, probably.

Right, that was my impression, too.

The interfaces could be made look a bit different, and we could return
-EAGAIN to userspace instead of retrying immediately (not that it makes
sense to me, but if that were really the issue, fine with me), but the
core logic with copying the sg_io_hdr, calling sg_io() directly and then
inspecting the status and possibly failing paths would have to be pretty
much the same as you had.

> I'm still not too fond of DM_MPATH_PROBE_PATHS_CMD, but I can't offer a
> better solution at this time. If the side issues are fixed, it will be
> an improvement over the current upstream, situation where we can do no
> path failover at all.

Yes, I agree we should focus on improving what we have, rather than
trying to find another radically different approach that none of us have
thought of before.

> In the long term, we should evaluate alternatives. If my conjecture in
> my previous post is correct we need only PRIN/PROUT commands, there
> might be a better solution than scsi-block for our customers. Using
> regular block IO should actually also improved performance.

If you're talking about SG_IO in dm-mpath, then PRIN/PROUT commands are
actually the one thing that we don't need. libmpathpersist sends the
commands to the individual path devices, so dm-mpath will never see
those. It's mostly about getting the full results on the SCSI level for
normal I/O commands.

There has actually been a patch series on qemu-devel last year (that I
haven't found the time to review properly yet) that would add explicit
persistent reservation operations to QEMU's block layer that could then
be used with the emulated scsi-hd device. On the backend, it only
implemented it for iscsi, but I suppose we could implement it for
file-posix, too (using the same libmpathpersist code as for
passthrough). If that works, maybe at least some users can move away
from SCSI passthrough.

The thing that we need to make sure, though, is that the emulated status
we can expose to the guest is actually good enough. That Paolo said that
the problem with reservation conflicts was mostly because -EBADE wasn't
a thing yet gives me some hope that at least this wouldn't be a problem
any more today.

We would still lose other parts of the SCSI status, so I'm still a bit
cautious here with making a prediction for how many users could
eventually (I expect years) use the emulated device instead and how many
would keep using passthrough even in the long term.

Kevin


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD98A21C198
	for <dm-devel@lists.linux.dev>; Wed, 14 May 2025 16:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747239827; cv=none; b=N3vNU8l1YGIC9vZPaQv9+5G91ZH2G0lYHvUrjH0IPkulXFLFTepkiIop377nndHpow0uvEbRAcUgYsTbfG/YBiA2bIBmXQD3/QGnaDDuxTzDEGCqlxiYo0TtFovzRZJhf8B2XS/gB9EyUbi/bAY7wkqeEOmOb+P9O09JEvyWc5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747239827; c=relaxed/simple;
	bh=uLYLi5sPLzFsbuoX9uoR+EmNVUpFHJUk1wUc7bBfx5g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lfULbFIM/eQVPp0oJPMkGDXgI/6Q0BSH1/GNxOzbL5UyT7B62R7anUOu66Nug2s66/7FnSou4OZVTwh/hvhZKbDac5nacmgpPZJygIrEb/mhrV/x6h50jrI26L139kSHEdZ2w+a0SFPC2r25O8PmkvwyyEhbjkI2IgCgXdd+vWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aN91mwyu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aN91mwyu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747239824;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O/3Vrn9aMLQKAG/4WrELKX6B5u1E7rwwnaweJ9QsMPM=;
	b=aN91mwyuYN9ihQGA10fi6O1G0Nwqy3AwACjZVuLWsG8JfwumixAmGfXVhopAZ/Tl1+Rfri
	sqrDHqF0IlseSIXVW+f4Zs1vwX/l9lqqRwTNKku3D/IASVsp4hVfLOch5lUu6wxYW8aPqL
	/v8T78f5dPkQFRvKOfZdn4ZJwsLU8L8=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-338-Ot4MCk9uPoWoDdgWs2u_eA-1; Wed,
 14 May 2025 12:23:41 -0400
X-MC-Unique: Ot4MCk9uPoWoDdgWs2u_eA-1
X-Mimecast-MFC-AGG-ID: Ot4MCk9uPoWoDdgWs2u_eA_1747239820
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A21DE195609E;
	Wed, 14 May 2025 16:23:39 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2E8FD19560AD;
	Wed, 14 May 2025 16:23:38 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 54EGNbgU3731968
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 14 May 2025 12:23:37 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 54EGNa373731967;
	Wed, 14 May 2025 12:23:36 -0400
Date: Wed, 14 May 2025 12:23:36 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Kevin Wolf <kwolf@redhat.com>, Martin Wilck <mwilck@suse.com>,
        dm-devel@lists.linux.dev, hreitz@redhat.com, mpatocka@redhat.com,
        snitzer@kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH 0/2] dm mpath: Interface for explicit probing of active
 paths
Message-ID: <aCTDiHMuMncwdp_X@redhat.com>
References: <20250429165018.112999-1-kwolf@redhat.com>
 <47dd225b433b0df585a25084a2e793344eeda239.camel@suse.com>
 <aCIRUwt5BueQmlMZ@redhat.com>
 <aCLe5UT2kfzI96TQ@infradead.org>
 <aCMQ5S-gI6vZJxmq@redhat.com>
 <aCQiz88HksKg791Z@infradead.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCQiz88HksKg791Z@infradead.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Tue, May 13, 2025 at 09:57:51PM -0700, Christoph Hellwig wrote:
> On Tue, May 13, 2025 at 11:29:09AM +0200, Kevin Wolf wrote:
> > Am 13.05.2025 um 07:55 hat Christoph Hellwig geschrieben:
> > > On Mon, May 12, 2025 at 05:18:43PM +0200, Kevin Wolf wrote:
> > > > Yes, it's a bit unfortunate, but we have to work with what we have. QEMU
> > > > doesn't even necessarily know that it's dealing with a multipath device,
> > > > so it just has to blindly try the ioctl and see if it works.
> > > 
> > > Why is qemu even using SG_IO to start with?
> > 
> > How else would you do SCSI passthrough?
> > 
> > Ok, from your replies to Hannes I understand an implicit message, you
> > wouldn't. But I don't think that's really an answer, at least not for
> > all users.
> 
> SG_IO is fine and the only way for SCSI passthrough.  But doing
> SCSI passthrough through md-multipath just doesn't work.  SCSI isn't
> built for layering, and ALUA and it's vendor-specific variants and
> alternatives certainly isn't.  If you try that you're playing with
> fire and is not chance of ever moving properly.

Could you be a bit more specific. All multipath is doing here is
forwarding the ioctls to an underlying scsi device, and passing back up
the result. Admittedly, it doesn't always make sense to pass the ioctl
on from the multipath device to just one scsi device. Persistent
Reservations are perfect example of this, and that's why QEMU doesn't
use DMs ioctl passthrough code to handle them. Also, when you have ALUA
setups, not all the scsi devices are equal. But multipath isn't naievely
assuming that they are. It's only passing ioctls to the highest priority
activated paths, just like it does for IO, and multipath is in charge of
handling explicit alua devices. This hasn't proved to be problematic in
practice.

The reality of the situation is that customers have been using this for
a while, and the only issue that they run into is that multipath can't
tell when a SG_IO has failed due to a retryable error. Currently,
they're left with waiting for multipathd's preemptive path checking to
fail the path so they can retry down a new one. The purpose of this
patchset and Martin's previous one is to handle this problem. If there
are unavoidable critical problems that you see with this setup, it would
be really helpful to know what they are.

-Ben


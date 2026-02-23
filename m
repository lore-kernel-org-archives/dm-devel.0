Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B1B369220
	for <dm-devel@lists.linux.dev>; Mon, 23 Feb 2026 19:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771874756; cv=none; b=UjOEVOfGKIim7uzvGvhY2TJ2vKHBA37U8GAtwP8L5mBYKOyJ8xKNkXMO5QZ4fGhc+tK/cIPznah0HbYrRdSrbj85CFzcSEWVszGB6hBWqeCsqiJcrn9vtD/VSo9xfErFO74qo2GbBvlIuFVL7+NFkZaOXlv15+Z5VUozoYdvFUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771874756; c=relaxed/simple;
	bh=TIcO9ljU4PBOIVbKF9KYWuHRru4FGxP4xiYEeXxR5gc=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=HMAzvp3rD12RuZpiK3y53Wb9e/7qW3n+FAStDnIEAW6iu5JFTF939oMJ3eh5iN3d63A6FG5vKPDbC6cql1vUfRe3Ath0lXYxLnIMWNaoGG8bDWxmz9tos1Yx6W8MKJnKCO6xtO8pSLD6PjjkT+3dUnCHKNn0UJDLBOSHUyVXU3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ovebk2OD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ovebk2OD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771874754;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bFnhjaLqA7xLRmKdk8xfCHnT0CZOvr+DnwNRZ1dagcE=;
	b=Ovebk2ODK8NZYaFRIZVTsz8/ykKaL7LSUFOwg0/RbuPwkQUyKDAiInbVZamQocAXSBI8nf
	LoEFavXHzzY7reurj9+dcji7GyeZaBTCUzmXW56v+VhAa7uLzA1Mmim3qTs65hdTv4f4q7
	XKbhT+jov1iZBWOdZG4nv8acueYpMj0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-278-CX_1MFD0PBqBp6L1CjmUoQ-1; Mon,
 23 Feb 2026 14:25:49 -0500
X-MC-Unique: CX_1MFD0PBqBp6L1CjmUoQ-1
X-Mimecast-MFC-AGG-ID: CX_1MFD0PBqBp6L1CjmUoQ_1771874748
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3365A180034A;
	Mon, 23 Feb 2026 19:25:48 +0000 (UTC)
Received: from [10.44.34.95] (unknown [10.44.34.95])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1DA7530001BB;
	Mon, 23 Feb 2026 19:25:44 +0000 (UTC)
Date: Mon, 23 Feb 2026 20:25:38 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, 
    Michal Hocko <mhocko@suse.com>
cc: Christoph Hellwig <hch@infradead.org>, 
    "Uladzislau Rezki (Sony)" <urezki@gmail.com>, 
    SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
    zkabelac@redhat.com, Matthew Sakai <msakai@redhat.com>, linux-mm@kvack.org, 
    dm-devel@lists.linux.dev
Subject: Re: [PATCH] mm: allow __GFP_RETRY_MAYFAIL in vmalloc
In-Reply-To: <aZykWyxLy34o7PKr@fedora>
Message-ID: <32bd9bed-a939-69c4-696d-f7f9a5fe31d8@redhat.com>
References: <ff48283b-be21-7f9a-d616-e303a4a1ebe6@redhat.com> <aZykWyxLy34o7PKr@fedora>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dv2oD6mb35V9svBguv99i9cLZqlpJpHIrEUAXk-W4eg_1771874748
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Mon, 23 Feb 2026, Vishal Moola (Oracle) wrote:

> On Thu, Feb 12, 2026 at 05:33:30PM +0100, Mikulas Patocka wrote:
> > The commit 07003531e03c8 ("mm/vmalloc: warn on invalid vmalloc gfp
> > flags") breaks the device mapper VDO target. The VDO target calls vmalloc
> > with __GFP_RETRY_MAYFAIL and this flag is not in the mask of allowed
> > flags.
> > 
> > There is no reason why vmalloc couldn't support __GFP_RETRY_MAYFAIL, so 
> > let's add this flag to GFP_VMALLOC_SUPPORTED.
> 
> My only skepticism about this comes from the line in the
> vmalloc_node_range() doc: 
> "and %__GFP_RETRY_MAYFAIL are not supported."
> 
> I myself don't know why that may be. Could you elaborate on if/why the
> doc is wrong please?

This statement was added by Michal Hocko in the commit 
b7d90e7a5ea8d64e668d5685925900d33d3884d5. Michal, could you explain why do 
you think that __GFP_RETRY_MAYFAIL is not supported?

The VDO module needs to allocate large amounts of memory and it doesn't 
want to trigger the OOM killer (which would kill some innocent task and 
wouldn't solve the out of memory condition at all), so I think that 
__GFP_RETRY_MAYFAIL is appropriate.

Mikulas

> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
> > Fixes: 07003531e03c ("mm/vmalloc: warn on invalid vmalloc gfp flags")
> > Cc: stable@vger.kernel.org	# v6.19
> > 
> > ---
> >  mm/vmalloc.c |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > Index: linux-2.6/mm/vmalloc.c
> > ===================================================================
> > --- linux-2.6.orig/mm/vmalloc.c
> > +++ linux-2.6/mm/vmalloc.c
> > @@ -3928,6 +3928,7 @@ fail:
> >   */
> >  #define GFP_VMALLOC_SUPPORTED (GFP_KERNEL | GFP_ATOMIC | GFP_NOWAIT |\
> >  				__GFP_NOFAIL |  __GFP_ZERO | __GFP_NORETRY |\
> > +				__GFP_RETRY_MAYFAIL |\
> >  				GFP_NOFS | GFP_NOIO | GFP_KERNEL_ACCOUNT |\
> >  				GFP_USER | __GFP_NOLOCKDEP)
> >  
> > 
> 


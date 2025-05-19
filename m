Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04E4288C3A
	for <dm-devel@lists.linux.dev>; Mon, 19 May 2025 18:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747679081; cv=none; b=s0L/+oxGXcAaudz5vp3+egOAS5xOny5y6BZtOkUnQoM0VUFNG3S2vvurhfHd1IiK9W1dx+IOEYai58ZHXJP+wdQjT/6Ja+LvBuUpqhkaOx18+4LJ3TaL72UPIHxbwRcV7sftLqt9qs128nE11THcpoWjbgYVd7dGuVR0jOt+nz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747679081; c=relaxed/simple;
	bh=zODQJ+gfcrilN03WjGcUAu4boM+3PSv8QTSOVYptZ6g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QgtyIzkEqryDK2t9kJpxffsGv6kucLdoumHRlPcxCWxYNTLlQSipsQAdUxhPbwFaPjc7IVpyT8ZSyPqNdIaDo3D2cf6OVGpFhLd1Zv3Wiiw3Dv0eV2iweIqD9o9a5kEUQ8M8S69+/IdMOxLRJC6L7UI8m3x2vn++ye496/og5wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y6lvPNNq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y6lvPNNq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747679078;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DwZrRO5XdVcCnNCASbgARVUpoWm49PR/IxoUUvG62P0=;
	b=Y6lvPNNqXT1Fx89s70hAWv1zNHx3adR9Xt+XC5N5IsmV+9Gnk0AF3xQCtYnerhLDtjexQn
	uOzD7AmkDMZIKDC+Z2ZJkWfRmljJX6JEITucm/Lq4NvNkJ9usy9pukxaRReU/J0QHImNTf
	LVMLyEngqi93TiZPKNtlPbnCnD7pqPQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-115-4-T4n4L9NPyVBHyd4B2lQw-1; Mon,
 19 May 2025 14:24:37 -0400
X-MC-Unique: 4-T4n4L9NPyVBHyd4B2lQw-1
X-Mimecast-MFC-AGG-ID: 4-T4n4L9NPyVBHyd4B2lQw_1747679076
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E099F180036F;
	Mon, 19 May 2025 18:24:35 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4FE15180035C;
	Mon, 19 May 2025 18:24:35 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 54JIOX1o159136
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 19 May 2025 14:24:33 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 54JIOVOQ159135;
	Mon, 19 May 2025 14:24:31 -0400
Date: Mon, 19 May 2025 14:24:31 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Kevin Wolf <kwolf@redhat.com>, Martin Wilck <mwilck@suse.com>,
        dm-devel@lists.linux.dev, hreitz@redhat.com, mpatocka@redhat.com,
        snitzer@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] dm mpath: Interface for explicit probing of active
 paths
Message-ID: <aCt3X8CmPTMq6T5k@redhat.com>
References: <20250429165018.112999-1-kwolf@redhat.com>
 <47dd225b433b0df585a25084a2e793344eeda239.camel@suse.com>
 <aCIRUwt5BueQmlMZ@redhat.com>
 <d51d6f85b5728648fe9c584f9cb3acee12c4873f.camel@suse.com>
 <cc2ec011cf286cb5d119f2378ecbd7b818e46769.camel@suse.com>
 <aCW95f8RGpLJZwSA@redhat.com>
 <aCbUcdew393RZIkV@infradead.org>
 <aCdifWdCQCR3Nqb0@redhat.com>
 <aCrCYbvOJs44Kj5a@infradead.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCrCYbvOJs44Kj5a@infradead.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Sun, May 18, 2025 at 10:32:17PM -0700, Christoph Hellwig wrote:
> On Fri, May 16, 2025 at 12:06:21PM -0400, Benjamin Marzinski wrote:
> > I've run into SCSI arrays that always act like they were called with the
> > ALL_TG_PT flag set (or perhaps they were just configured that way, I
> > never could get a straight answer about that).
> 
> Hmm, that's pretty strange.
> 
> > libmpathpersist accepts
> > this flag, and only sends one registration per initiator & target device
> > when it's set, instead of one per initator & target port.
> 
> With "this flag" you mean ALL_TG_PT?

Yes.

> 
> > dm-multipath
> > currently doesn't have the knowledge necessary to figure out which
> > devices it needs to send reservations to, even if the kernel PR API
> > supported this.
> > 
> > But I supposed it could just send the registration normally down one
> > path and if that works, it could just ignore the existing key when it
> > sends the registration down all the other paths.
> 
> We could add support for a similar flag to the kernel PR API.  The
> problem is to figure out how to discover support for it.  What does
> the library do for that currently?
>

libmpathpersist knows which scsi path devices map to the same Initiator,
but different target ports. When ALL_TG_PT is set, it only sends one
registration command to each group, instead of sending one to each path
device (like when ALL_TG_TP isn't set). If it sent a registration to
every SCSI device on these arrays that act like ALL_TG_PT is always set,
it would get reservation conflicts when sending the command to devices
using ports after the first, since they would already have a registered
key. That's why I mentioned the posibility of using Register and
Ignore, which doesn't care if there's a key already registered.

I don't think it would take much work for the Kernel API to support
ALL_TG_PT, if the SCSI implementation just passed the flag down to the
device. The problem really only exists for things like dm-multipath,
that are composed of a number of different devices that all point to the
same underlying Target LUN. To handle this without relying on something
like Register and Ignore, It would need to be able to group all the
devices that come from the same initiator but different target ports
together, and only send a registration to one device per group. This
takes more SCSI specific knowledge than it currently has, or really
wants to have.

-Ben


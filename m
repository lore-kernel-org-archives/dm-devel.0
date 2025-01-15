Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3041D3BB54
	for <dm-devel@lists.linux.dev>; Wed, 15 Jan 2025 18:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736966910; cv=none; b=V+Rh9Mg3EnvQ8VLTKSiADy1qOTNbEYZmaQqClKLEtIh9ibi63Jc60qXvqcOWlC0DjogYEhvyUyjSP6zn8VB00oh6DN0x3EkaazgEN1sLaEvkQRjU14zdPK6M1B+xTz/zV8JN+8ECwDkJ76VFd5D/G5mz/a+XkX+5NRNj6IJR3Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736966910; c=relaxed/simple;
	bh=9lxpPuEmxPs08ykj7M8ShtzHIVY/1SnSJgVQldGaPk8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=MTb+wTQwNPrcBTiPb9wpWsR2LnVGdbPz2k/n+CrYrj/6l6+4e791sOBRCwbTFlcU/oq2XcIAGNvCb7vh5OJ/68zFD/UzXp5XjkLJ7d++cAQGItCIxF+Hois+rvh5nyF98wNQlh4lajy9YB0G7VnuMdVXJzabhkFm9qs2XNL6j04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YefiPBRh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YefiPBRh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736966907;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QqJ+d0YXnAV5ljM7iMY3vXI0KvUmW5mcTffBs8QKoH4=;
	b=YefiPBRhzUGGSrPZPLX7kHZx9ZV5sII45dpwW45MmO2GkSy1hxcT4CDKtvv01xEaLlOH+L
	Jhd5Plj1zOwWeFcgkOfrjDAh3ukkG7q97aOD6gxXhlRYmfC098vmSaf5NCXHIZDN1jy7cz
	i0BS5aF/7ms2YkfdUU6wF/gQ0r1ctkk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-661-XHlGDNJ8N668rUcxTmLejA-1; Wed,
 15 Jan 2025 13:48:24 -0500
X-MC-Unique: XHlGDNJ8N668rUcxTmLejA-1
X-Mimecast-MFC-AGG-ID: XHlGDNJ8N668rUcxTmLejA
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C735A1956058;
	Wed, 15 Jan 2025 18:48:22 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6CD2730001BE;
	Wed, 15 Jan 2025 18:48:22 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 50FImKpE2715781
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 13:48:20 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 50FImKIE2715780;
	Wed, 15 Jan 2025 13:48:20 -0500
Date: Wed, 15 Jan 2025 13:48:20 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH v2 04/14] multipathd: quickly re-sync if a map is
 inconsistent
Message-ID: <Z4gC9P2SCbIhy2gV@redhat.com>
References: <20241211225909.298770-1-mwilck@suse.com>
 <20241211225909.298770-5-mwilck@suse.com>
 <Z2SW3m9qq9ZBTLa7@redhat.com>
 <c640c8116e252d18fa89c4dfa6aa8ebb600e3c16.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <c640c8116e252d18fa89c4dfa6aa8ebb600e3c16.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5_t6IPbJSv7Flut2CkPX-TvwhEzH13nu1wE6uJPHajc_1736966903
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Jan 14, 2025 at 10:37:24PM +0100, Martin Wilck wrote:
> On Thu, 2024-12-19 at 16:57 -0500, Benjamin Marzinski wrote:
> > On Wed, Dec 11, 2024 at 11:58:59PM +0100, Martin Wilck wrote:
> > > After reading the kernel device-mapper table,
> > > update_pathvec_from_dm()
> > > sets the mpp->need_reload flag if an inconsistent state was found
> > > (often a
> > > path with wrong WWID). We expect reload_and_sync_map() to fix this
> > > situation.
> > > However, schedule a quick resync in this case, to be double-check
> > > that the
> > > inconsistency has been fixed.
> > 
> > I'm not too sure about this. My biggest worry with handling
> > mpp->need_reload in the checkerloop is what happens if for some
> > reason
> > multipathd and the kernel keep disagreeing on something. You would
> > just
> > keep reloading the device. That seems unlikely, so I've o.k. with
> > handling it here, but if that does happen, this would make it much
> > worse.  Instead of reloading every path check, you would reload every
> > loop.
> > 
> > If you do detect an inconsistent state, and trigger a reload, and the
> > state is still inconsistent after that, I would argue that yet
> > another
> > reload is more likely to remain inconsistent than it is to fix the
> > problem. So I would rather not speed it up.
> > 
> 
> Please see my reply to 03/14.

Fine. Since I can see situations where a cascade of device changes would
make an inconsistency appear immediately after a reload and I can't
actually come up with a case (excluding bugs and ENOMEM) where nothing
changed, and we reloaded to fix and inconsistency, but it still isn't
fixed, we should probably handle the case that we know can actually
happen. Warning on inconsistent states should be good enough, and I
think we already do that in update_pathvec_from_dm().

-Ben

> 
> Martin


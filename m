Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7876A1DACB4
	for <dm-devel@lists.linux.dev>; Tue, 26 Nov 2024 17:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732642920; cv=none; b=CrFx3xeObRvMc8Yyt9HL5LKzusqXG2KMcrBP4HeyRhb2f8I4k6HLrzkfNnbze5bcodl74hkpBI6xe3csXrFlfUDRUY8LaNL7rheJd+49UOzQlQRPQazK+lWrwVPNqtYr3nAQvwEMmKqd958jJGm2SD1ACcCUcUFCJAJyZg/X738=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732642920; c=relaxed/simple;
	bh=MNd2tHwP7UVXc0ZwauELvNhNYpJUGmDP6f5OmMRszTk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=nG6XOech4v1UVD3dtlKagIV80e9efFFChhchde8U3djRjrMZwznf0r9vl0+CRRZzmpQP2hBN79c7h+o6Saw3Myp2ZD/+BFer4PiU+ZKDIeaQETFBQ4kX8adyDMPC4GwDetxP4g5sfMv+xygJjeD0qkzmZ9kSKAGjCrcsY+GqTyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E1qoaMwY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E1qoaMwY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732642917;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4IpB50pOx/NDUdIkwqogAj89B6l0Wt6OChB4xlR2q9I=;
	b=E1qoaMwYHHKJnaZqlhXIA3wfNBk1j2j/vDoRABKmS6xNQmVs2fBT4jjnG1Z1/8w+0BaZue
	m5QgW8yFiwM642jW5ICFeEdzMuBdaBbwXd48CHkdJUIxXr4hJswZhUhh7xS15EKMLooOKP
	1EY7Q1MB1gjCES8acAuAaCwzKKQe7+I=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-671-AzClwcNXNveLidBvJD-zZQ-1; Tue,
 26 Nov 2024 12:41:53 -0500
X-MC-Unique: AzClwcNXNveLidBvJD-zZQ-1
X-Mimecast-MFC-AGG-ID: AzClwcNXNveLidBvJD-zZQ
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7384B19560BA;
	Tue, 26 Nov 2024 17:41:52 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DF5F91956054;
	Tue, 26 Nov 2024 17:41:51 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4AQHfokc854947
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 26 Nov 2024 12:41:50 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4AQHfoMe854946;
	Tue, 26 Nov 2024 12:41:50 -0500
Date: Tue, 26 Nov 2024 12:41:50 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH 1/3] libmultipath: fix handling of pp->pgindex
Message-ID: <Z0YIXi6kdt6zRULr@redhat.com>
References: <20241125143224.51934-1-mwilck@suse.com>
 <20241125143224.51934-2-mwilck@suse.com>
 <Z0TeksRGcJ9k4cqx@redhat.com>
 <98e94d1f52967129b50d25d61f9d400531fff1dd.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <98e94d1f52967129b50d25d61f9d400531fff1dd.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: eO7za0hjtulxRCx0FvOjnXUFYaHTI0L2DlxFgMri0e8_1732642912
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Nov 26, 2024 at 12:12:16PM +0100, Martin Wilck wrote:
> On Mon, 2024-11-25 at 15:31 -0500, Benjamin Marzinski wrote:
> > On Mon, Nov 25, 2024 at 03:32:22PM +0100, Martin Wilck wrote:
> > > pp->pgindex is set in disassemble_map() when a map is parsed.
> > > There are various possiblities for this index to become invalid.
> > > pp->pgindex is only used in enable_group() and
> > > followover_should_fallback(),
> > > and both callers take no action if it is 0, which is the right
> > > thing to do if we don't know the path's pathgroup.
> > > 
> > > Make sure pp->pgindex is reset to 0 in various places:
> > > - when it's orphaned,
> > > - before (re)grouping paths,
> > > - when we detect a bad mpp assignment in update_pathvec_from_dm().
> > > 
> > > The hunk in group_paths is mostly redundant with the hunk in
> > > free_pgvec(), but
> > > because we're looping over pg->paths in the former and over pg->pgp
> > > in
> > > the latter, I think it's better too play safe.
> > 
> > I'm not sure this will always fix issue #105. Perhaps I'm overlooking
> > the connection in the code and this just needs a more explicit
> > explanation to aid clueless reviewers, but here's what I don't get.
> > 
> > As far as I can see, the only change here that would effect the
> > reported
> > issue is the change to update_pathvec_from_dm(). While I totally
> > agree
> > that if you have a path that appears to be two multipath devices, you
> > can't trust pp->pgindex, I believe there's also another problem.
> > 
> > Say you have a multipath device with two path groups (pgp1 and pgp2)
> > each with one path (pp1 in pgp1 and pp2 in pgp2). In this case,
> > pp1->pgindex == 1 and pp2->pgindex == 2. If update_pathvec_from_dm()
> > discovers that pp1 is part of another multipath device, and removes
> > it,
> > that will mean that pgp1 is now empty, so update_pathvec_from_dm()
> > will
> > also remove that (at the delete_pg label).  But pp2->pgindex will
> > still
> > be set to 2 even though there's only one path group, so it will now
> > point off the end of the pgp list. Right?
> 
> Right, thanks for pointing this out. If we delete a pg, we need to
> invalidate all pgindex values for all paths in the map. We can't
> decrement them, because they must match kernel indices (see below).
> 
> > At any rate, updating pgindex seems finicky and perhaps we should
> > just
> > drop it. It's not that much work to scan the path groups for the path
> > in
> > enable_group() and since we're already reading through the path
> > groups
> > in followover_should_failback(), we can just refactor the code a
> > little
> > bit to avoid needing pgindex at all.
> 
> I had similar thoughts, but I was looking for a minimal fix for the
> 0.11.0 release. Probably dropping pgindex for good is the right thing
> to do, but is it 0.11.0 material?

I'd be fine with removing it, but it's your call. I have nothing against
your approach for 0.11.0 and then a more involved fix afterwards. 
 
> We'd still have the problem that enable_group() et al. need a pgindex
> value that matches the kernel configuration. We can only be sure that
> this index is correct if disassemble_map() has just set it. Any change
> we apply in multipathd's data structures won't match the kernel's view
> of the map.
> 
> This problem is subtle, AFAICS. It's related to the fact that if
> update_pathvec_from_dm() finds any inconsistencies, we *should* reload
> the map, possibly multiple times, until these inconsistencies have been
> resolved. But we can't do that in all code paths in which this function
> is called (or at least, we haven't been able to prove that we can
> without risking breakage).
> 
> I have vague ideas how this could be solved, but they would require a
> major code restructuring.

We could use mpp->need_reload to signal that pgindex was invalid. It
might still make sense to drop pgindex so we don't have to unset it
in cases like when a path is in two multipath devices. But if the
map needed reloading, we could just let the reload deal with adjusting
the path groups. The only problem is that we can set need_reload, but
not actually trigger that reload for a while. 

-Ben

> Regards,
> Martin


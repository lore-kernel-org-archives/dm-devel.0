Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F86116BE3A
	for <dm-devel@lists.linux.dev>; Tue, 21 Jan 2025 21:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737494173; cv=none; b=gug6bvOpx0gk1WTKPe7Nc8E3i6pqfArSlYBwIq90TaCkG+qx9I6M/9Rew9Wbl4Op6NIezVmJfgLZvNRPkZXEvBNYm6qd8sJ9pOBh7DtpyplMx1dZfjv/AOLU1TFPU46sSInrrSnUGk2bDKoZ706flxdRRkvRDvOchWtzpt7gCKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737494173; c=relaxed/simple;
	bh=pGuo85CjUIJ092bGXyKYDD7Fc5LjL+YBRbIeOl6fAJM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=HBiUWSty1Lfmrev3s+V7T8riRChDzk7p5a1S9xG1ZjnAs4gQQZtJIcWeSiegpdjFUqFeli8YfS7nMjxbIzTiedoHDVKH7wyIELwmBzGGo5p2uCAx/Dxi2ZGUGT6Hc9MPx3UdIUNqTpMurpczsMVq9KCAO5UTBptrQVNDIoE3Ui4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WKwvRgDj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WKwvRgDj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737494169;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MtcmqkLPKqOepBlkaG889+9Yx/VShb6hWr5xoLqHsbM=;
	b=WKwvRgDji4UYefaDlAkYhvo/NfV0VXFPdE2YP31KcKE0R99+ycUVO4vjJj7/gPs97Tg/9b
	0EAzqyDf1onFPQalWnRVR5+g62VbnZ9z9bDD+QxirhNj+pJWTmmRXrgnbdll/bUJ50SY9S
	Q06vd9Wm4ua+nFuUtm0vb+Z0C0I4GD0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-652-9VCSQq17Oda5Se7voJYk7w-1; Tue,
 21 Jan 2025 16:16:06 -0500
X-MC-Unique: 9VCSQq17Oda5Se7voJYk7w-1
X-Mimecast-MFC-AGG-ID: 9VCSQq17Oda5Se7voJYk7w
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7256B19560AF;
	Tue, 21 Jan 2025 21:16:05 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1F9B0195608A;
	Tue, 21 Jan 2025 21:16:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 50LLG3032971179
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 21 Jan 2025 16:16:03 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 50LLG3MZ2971178;
	Tue, 21 Jan 2025 16:16:03 -0500
Date: Tue, 21 Jan 2025 16:16:03 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH v3 15/15] multipathd: enable pathgroups in
 checker_finished()
Message-ID: <Z5AOk0sjCtfxDggL@redhat.com>
References: <20250117202738.126196-1-mwilck@suse.com>
 <20250117202738.126196-16-mwilck@suse.com>
 <Z47hizoQciL5Yp-E@redhat.com>
 <bd30c82ae259c15cfcb9b26985c3a6c139986822.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <bd30c82ae259c15cfcb9b26985c3a6c139986822.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5Xrnw6897TiPeuJjv0mGrW8n2MsVPYDXXJv_rTm9fNM_1737494165
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Jan 21, 2025 at 12:12:50PM +0100, Martin Wilck wrote:
> On Mon, 2025-01-20 at 18:51 -0500, Benjamin Marzinski wrote:
> > On Fri, Jan 17, 2025 at 09:27:38PM +0100, Martin Wilck wrote:
> 
> > Alternatively, we could make the check_finished() logic match the
> > update_path_state() logic exactly by just setting a flag in the
> > path's
> > pathgroup during enable_group() (and possibly not call
> > dm_enablegroup()
> > at all, 
> 
> That was my first thought, but it doesn't work, because we call  
> free_pgvec(mpp->pg, KEEP_PATHS) update_multipath_strings(), and
> reallocate the vector in disassemble_map. I guess we could change that,
> but it would be another intrusive patch set. Currently we just can't
> store any persistent properties in struct pathgroup.

Oh, yeah. nuts.

> > but I suppose that there could be a benefit to re-enabling the
> > group as soon as possible. I'm still kinda fuzzy on whether the
> > kernel's
> > own pathgroup re-enabling code makes all this redundant).
> 
> The kernel will even try "bypassed" PGs if it finds no other. But that
> means that e.g. the marginal pathgroup would be tried before disabled
> PGs [1]. In general, I don't think we can rely on the kernel in this
> respect.
>
> >  Then, in
> > enable_pathrgoups(), instead of checking each path, we just need to
> > check if pgp->need_reenable is set for the pathgroup().
> 
> As I said, as long as we discard the PGs, I guess we'll have to test
> the path flags. It's difficult to come up with a decent test case for
> this, in particular if checking for PATH_UP is not enough...
> 
> 
> > [...]
> > 
> > But perhaps the best answer is to just to say that this is a corner
> > case
> > where we skip a multipathd action that might be totally unnecessary.
> > And
> > even if it is a problem, it will be fixed if multipathd ever decides
> > that the kernel is using the wrong pathgroup and should switch, or
> > whenever the table gets reloaded. Maybe the whole patch is
> > unnecessary.
> 
> I'm going to submit a v4 that adds a test for the checker flags.

Seems reasonable.

> 
> Btw, I could only find one place in the kernel code where the kernel
> actively sets the "bypassed" flag, when the SCSI device handler returns
> SCSL_DH_DEV_TEMP_BUSY [2]. This seems rather questionable to me. First
> of all, this seems to assume that PGs are mapped to "controllers", i.e.
> something like "group_by_tpg", which isn't necessarily the case.
> Second, while the EMC device handler uses this error code in this way,
> in the ALUA handler it rather means a memory allocation failure, and
> the other device handlers don't support it at all.

Yeah, I really wish I knew how this was supposed to work. For the ALUA
devices, it's likely fine to clear bypassed when the device is in
PATH_UP. Either the hardware controller just ran into a temporary error,
and we should go back to using this pathgroup based on its priority, or
there is a persistent memory issue, it which case it likey doesn't
matter what we do, since the system has larger problems than using a
non-optimal pathgroup.

It's the EMC devices that seem like there should be a real right and
wrong way to do things. For instance, even though the code doesn't
currently clear bypassed for PATH_GHOST devices, that might be the right
thing to do.  Imagine if you tried to switch to a new pathgroup, but the
controller had some issue and so you bypassed it, and that issue was
later resolved.  In that case, you want to clear the bypassed flag. But
since you are using some other controller, the paths in the bypassed
pathgroup could well be in PATH_GHOST. This means that you are less
likely to pick that pathgroup in the future, so the bypass flag won't
get cleared. And multipathd won't do anything to fix this. So the
correct answer might be to just check for
pp->is_checked == CHECK_PATH_NEW_UP. But maybe not. I dunno.

> I think we can conclude that the kernel setting "bypassed" on a path
> group by itself is indeed a corner case, except for EMC Clariion, which
> is quite dated by now.
> 
> > Thoughts? I'm clearly thinking too much.
> > 
> 
> No, you are not. I strongly appreciate these comments.
> 
> Regards,
> Martin
> 
> [1] Unrelated wild thought: in view of the logic the kernel applies for
> "bypassed" PGs, it might actually make sense to use this flag for 
> marginal pathgroups. They would be tried if all else fails, which is
> more or less the behavior we want for them. What do you think?

Maybe, but I kind of doubt it. It will get cleared by the kernel if we
ever call switch_pathgroup(), but we could reset it. AFAICS the only
real "benefit" would be that regular bypassed pathgroups would get used
instead of marginal pathgroups. But if we're doing the right thing with
clearing the bypassed flag, then when a pathgroup is bypassed, it likely
can't be initialized (at least for the EMC handler). It might make more
sense to use a marginal pathgroup that can be initialized instead of a
regular pathgroup that quite possibly can't at all.

-Ben

> [2] https://elixir.bootlin.com/linux/v6.12.6/source/drivers/md/dm-mpath.c#L1564


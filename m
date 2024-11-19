Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AEEF1D2F43
	for <dm-devel@lists.linux.dev>; Tue, 19 Nov 2024 20:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732048418; cv=none; b=IbFZLexRe+25lGYLj5zKxFbsn6hkWAUg08/w61DtjLy7eE7Cko04hvH0O1Mku5H3EOOOpeYelC8GVBLd2Xx8AVKc7wCBditthVuf5VbYgepYHs8SQ2+p1hTgY/YrRNn4PIhAirbz/1Ui0fGE7csogcipf2g4EF7i46VEx6LMM1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732048418; c=relaxed/simple;
	bh=Dp7hq2TgMV1ZYGXkeMGjAIAyA8TemT1zeu0a+uk3msg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=cwzbojaOwJvJzM+VwOg5H3ofR+2sPXLi52DMAez566QUtUFDaoKsNLQYhOO1wDl37dyEWkDolCDhdgAYgFqJjl6TNb8GBQNkSpEvG6siu1rnr11YDT1YMSU5t6wnNV0cuOuRL2WsKnLv6B2f+4oiPaBhBnQAtjvbhaET2Jgl6ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cy6Mrhxi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cy6Mrhxi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732048413;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jvm9NpMixyBB05GtFbg7Krhi2dDpv6gvCYRlr03rGgE=;
	b=Cy6Mrhxi2mLnnXO5WqjMnYMPIPK8IAdU60sla7zfZ3fMHUv1URmdD8cK3RAZdJbqu2W4zY
	5A/4C9DAqRV+AflSIbkFzC12rFJjtZyOrjtj+UrdhELmRFAECwN3HBrNMYfPb4nNJGE5l5
	ofRPCd2szZnDccLGpqKYhYry74w5Mrk=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-322-MIIucefAPFepODLznY_FKw-1; Tue,
 19 Nov 2024 15:33:30 -0500
X-MC-Unique: MIIucefAPFepODLznY_FKw-1
X-Mimecast-MFC-AGG-ID: MIIucefAPFepODLznY_FKw
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E5F801977320;
	Tue, 19 Nov 2024 20:33:25 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 88D9330000DF;
	Tue, 19 Nov 2024 20:33:25 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4AJKXN7Q680139
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 19 Nov 2024 15:33:24 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4AJKXNmI680138;
	Tue, 19 Nov 2024 15:33:23 -0500
Date: Tue, 19 Nov 2024 15:33:23 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 1/6] libmultipath: signal device with no table in
 libmp_mapinfo
Message-ID: <Zzz2E-UC1m8rezOH@redhat.com>
References: <20241115232256.627933-1-bmarzins@redhat.com>
 <20241115232256.627933-2-bmarzins@redhat.com>
 <8f74ed950515b775def323b2d04fb5092ad615de.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <8f74ed950515b775def323b2d04fb5092ad615de.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PXayIDeCV0Q5vT1Fi2XxAC19BddvB08RhktmYTWeA38_1732048406
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 19, 2024 at 05:39:26PM +0100, Martin Wilck wrote:
> On Fri, 2024-11-15 at 18:22 -0500, Benjamin Marzinski wrote:
> > if libmp_mapinfo() is run on a device that has no active table,
> > it will now return with a new exit code, DMP_EMPTY, to signal this.
> > Currently all code paths treat this identically to DMP_NOT_FOUND.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> I just looked through the code again. I think with this change, we need
> to modify dm_flush_map__() and do_foreach_partmaps(). They should
> remove / act on empty maps. What do you think?

I'm not sure that we need to add extra code to handle the possiblity
that an empty device could appear at any time, since like I said,
this is a corner case that I've never actually seen in the wild. So if
a device was previously a valid multipath device, I don't think we need
to worry about the possibility that it suddenly became empty. 

But I can see the value in running something like

# multipath -F

and having it clean up any empty multipath devices. As for
do_foreach_partmaps(), are you thinking about cleaning up empty
partition devices or non-empty partition devices on top of empty
multipath devices?

Non-empty partition devices on top of empty multipath devices would
imply that a multipath device was valid at one point, and then became
empty, which I don't see an easy way of happening.

The problem with empty partition devices is that partition devices are
created by kpartx completely asynchronously to us. That empty partition
device could be in the process of being created.

So I'm not against checking for DMP_EMPTY in dm_flush_map__() and
removing the empty device if its opencount is 0. But I'd rather not
try messing with partmaps. Do you have a specific case you are worried
about?

> Also, we can skip the call to is_mpath_part_uuid() in
> do_foreach_partmaps() after my "make MAPINFO_CHECK_UUID work with
> partitions" patch. I can submit a patch myself, but as you're at
> already, maybe you want to do that?

Yep. I can do that.

-Ben

> Martin


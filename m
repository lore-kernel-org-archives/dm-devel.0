Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C479C1BBBC1
	for <dm-devel@lists.linux.dev>; Wed, 20 Nov 2024 21:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732139980; cv=none; b=TXV2Yt0CE6Anm26ji+PnX851nUurZFFZcLg9AtBAUiLC48ssqBKsBvaQ/+LlGiyqsX3TtEjHOqDIkUrrLtmIAbx/pOvSHK6pq0841Fcvo0Cd+zo6FrYvxClj/gQMW59Vhm3l/naCWJgXAcUb1Kuv/WSKH0WxHE0CpMUDyIiT150=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732139980; c=relaxed/simple;
	bh=e0WojztjTfu8yc6opPMjYGOZlg0v+86PPXoRCnvE2y8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=iBn15iP5JwsV1d++HDfKWLBTbKDP1xjm+qfGr9u2dHmtnAZdy9sSITiK5udrSbizIldD1nMA3+XL5Zdg17eQnXQTBcyJHGLlBL51u6lFpMtIfpmpcoCH+Igwp6UUPna9f3mQOuGlrnUQ7ea5uPyK80N0/mkyAlxzBKbWa6VVT1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dttyzTCC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dttyzTCC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732139977;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Km0QPoPhdIUXRqanJmW9dVRB7Smo2LpUFzetePWdyRw=;
	b=dttyzTCCLMfdnkGgE61oBxea204qYh61L/2tsRQ8g2OgAxoMCWPA5kFqjfcOcXYEdvroFh
	49dCPsserTHsLYS21aaLbkILNEcxbuIN7g5XdPwbJXUhyqbNUent7fouuY3oKuHZNaewO0
	xzxT1KbXFfbU/+4VRrEma2bfgauoay4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-434-0FtbMGLEOqui3u6piPhcjg-1; Wed,
 20 Nov 2024 16:59:36 -0500
X-MC-Unique: 0FtbMGLEOqui3u6piPhcjg-1
X-Mimecast-MFC-AGG-ID: 0FtbMGLEOqui3u6piPhcjg
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3F76F1956088;
	Wed, 20 Nov 2024 21:59:35 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8714F1955F40;
	Wed, 20 Nov 2024 21:59:34 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4AKLxXQU698295
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 20 Nov 2024 16:59:33 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4AKLxWwb698294;
	Wed, 20 Nov 2024 16:59:32 -0500
Date: Wed, 20 Nov 2024 16:59:32 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 1/6] libmultipath: signal device with no table in
 libmp_mapinfo
Message-ID: <Zz5bxCZfCDsgMtOm@redhat.com>
References: <20241115232256.627933-1-bmarzins@redhat.com>
 <20241115232256.627933-2-bmarzins@redhat.com>
 <8f74ed950515b775def323b2d04fb5092ad615de.camel@suse.com>
 <Zzz2E-UC1m8rezOH@redhat.com>
 <b74031fd331a5825b45d4c44a5567cc7d5d96bbf.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <b74031fd331a5825b45d4c44a5567cc7d5d96bbf.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jk4o8UHoI9AsGdm-kzCa8FBAjO3b7Rtm96hnC9_D7x0_1732139975
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 20, 2024 at 09:49:17AM +0100, Martin Wilck wrote:
> On Tue, 2024-11-19 at 15:33 -0500, Benjamin Marzinski wrote:
> > On Tue, Nov 19, 2024 at 05:39:26PM +0100, Martin Wilck wrote:
> > > On Fri, 2024-11-15 at 18:22 -0500, Benjamin Marzinski wrote:
> > > > if libmp_mapinfo() is run on a device that has no active table,
> > > > it will now return with a new exit code, DMP_EMPTY, to signal
> > > > this.
> > > > Currently all code paths treat this identically to DMP_NOT_FOUND.
> > > > 
> > > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > 
> > > I just looked through the code again. I think with this change, we
> > > need
> > > to modify dm_flush_map__() and do_foreach_partmaps(). They should
> > > remove / act on empty maps. What do you think?
> > 
> > I'm not sure that we need to add extra code to handle the possiblity
> > that an empty device could appear at any time, since like I said,
> > this is a corner case that I've never actually seen in the wild. So
> > if
> > a device was previously a valid multipath device, I don't think we
> > need
> > to worry about the possibility that it suddenly became empty. 
> > 
> > But I can see the value in running something like
> > 
> > # multipath -F
> > 
> > and having it clean up any empty multipath devices. As for
> > do_foreach_partmaps(), are you thinking about cleaning up empty
> > partition devices or non-empty partition devices on top of empty
> > multipath devices?
> > 
> > Non-empty partition devices on top of empty multipath devices would
> > imply that a multipath device was valid at one point, and then became
> > empty, which I don't see an easy way of happening.
> > 
> > The problem with empty partition devices is that partition devices
> > are
> > created by kpartx completely asynchronously to us. That empty
> > partition
> > device could be in the process of being created.
> 
> Right, but multipathd is in the process of deleting the map. If there's
> actually a race and kpartx finishes creating the partition map,
> multipathd will fail to remove the multipath map. The likely outcome
> will be a multipath map with just one partition device. If multipathd
> comes first, kpartx will fail, but there's a good chance that
> multipathd will succeed in flushing the multipath map, so we'll end up
> with a consistent state.
> 
> If kpartx had run a little earlier and had finished setting up the map,
> multipathd would have removed it, and if kpartx had run a little later,
> it would have failed because of a missing target.
> 

If we make do_foreach_partmaps() remove empty partition maps, it has
keep the is_mpath_part_uuid() call. Otherwise we would remove any empty
partition device, including ones that aren't for this multipath device,
which breaks your argument above.

> > So I'm not against checking for DMP_EMPTY in dm_flush_map__() and
> > removing the empty device if its opencount is 0. But I'd rather not
> > try messing with partmaps. Do you have a specific case you are
> > worried
> > about?
> 
> >From the argument above, I'd say that flushing empty partition maps is
> the right thing to do, for consistency reasons.
> 
> But now I may be overlooking something.

How would you feel about adding a parameter to do_foreach_partmaps() to
say whether or not it should remove empty partmaps (or possibly just
checking if the partmap_func is remove_partmaps).  Your argument makes
sense when you are removing a device. But what about functions like
dm_cancel_remove_partmaps() and dm_rename_partmaps()? I'm not sure that
these should automatically empty (a possibly being created) partition
devices.

-Ben
 
> Martin


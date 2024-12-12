Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142FD2080D9
	for <dm-devel@lists.linux.dev>; Thu, 12 Dec 2024 17:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025850; cv=none; b=K5Kna/JZf+wOfeXgqwe6o24GPhbbkRFLlrWhppdfteuhq4yAgd+YPDtYU6qo5ghY+V+Z42GKB81QBD1ydmxAy8xtHOZqYacqKjb4YqUE8jFEa3OyRLox0zCuuvTMWcf2jEBatQhP2VjDHSHjNMidEpk+95YrkbYKGna/89fxOYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025850; c=relaxed/simple;
	bh=6uLHudWOyr5SNXJ6LJ7GSiOkTJcFcmVWvEX+gPf4itU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=KkRQIriczDLGV2QtkwAY5LP0jNzHMYbUj7ZMy5CxRR5IgIW/Eh/u+DvXNuZnBRQltVpHkqV+JHHzFNQYCIhn2EK1Zeg9bvXzIN9XX8ZN7bSF5uWFJvGaJNCdynDGszKCDE4CQVdCwTeKxbOHiqTo9qxcdaY26Z7cS9kiQXouPdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VIvxVgqd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VIvxVgqd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734025847;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tZbwbyUxbNUH4aANajkuk3IvSfmIaK2fwhdVbWlBTCc=;
	b=VIvxVgqdVHRAnTtvHQYhBsAKGwcWAFpHMsKoGh9OI42EmTJTQa/X+eeUUAm8Cwjz/cpwlN
	2F6ce6wkL6F7rkfTLBLpUA85Y86rafGLcorUW0RrqeYV+1jiG+RgTkoffQbs09JslZYj6B
	t+NWmnNcNEZ/HFDEhVrsOV6oHhc4uuo=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-221-f0Z58Y9RN5iaIEZ2ACgvrw-1; Thu,
 12 Dec 2024 12:50:44 -0500
X-MC-Unique: f0Z58Y9RN5iaIEZ2ACgvrw-1
X-Mimecast-MFC-AGG-ID: f0Z58Y9RN5iaIEZ2ACgvrw
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9B1C2195609D;
	Thu, 12 Dec 2024 17:50:43 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 563E11953951;
	Thu, 12 Dec 2024 17:50:43 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4BCHog251489834
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 12 Dec 2024 12:50:42 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4BCHog1D1489833;
	Thu, 12 Dec 2024 12:50:42 -0500
Date: Thu, 12 Dec 2024 12:50:41 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH 03/13] multipathd: allow map removal in do_sync_mpp()
Message-ID: <Z1sicdU64iwB9r5X@redhat.com>
References: <20241206233617.382200-1-mwilck@suse.com>
 <20241206233617.382200-4-mwilck@suse.com>
 <Z1jPMVejcI61qP9z@redhat.com>
 <ee6fcbda31fd1f13969653782417fbed748f5bc7.camel@suse.com>
 <Z1nHUk8o3_qqPwED@redhat.com>
 <30fccbf041abd3af27f0228b51df431a2ca8438a.camel@suse.com>
 <422fff82ad35293d9406ec07820ddad5b122d1f6.camel@suse.com>
 <Z1sZh1WLCucwL61e@redhat.com>
 <2920c30528493029653ab01c2cdd56d5b0736a28.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <2920c30528493029653ab01c2cdd56d5b0736a28.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LGYeJUrGC6BFrKLtSZNiPaSb2gWvUo-_ytXOxfGcdac_1734025843
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 12, 2024 at 06:18:40PM +0100, Martin Wilck wrote:
> On Thu, 2024-12-12 at 12:12 -0500, Benjamin Marzinski wrote:
> > On Wed, Dec 11, 2024 at 09:33:40PM +0100, Martin Wilck wrote:
> > > On Wed, 2024-12-11 at 21:20 +0100, Martin Wilck wrote:
> > > > On Wed, 2024-12-11 at 12:09 -0500, Benjamin Marzinski wrote:
> > > > 
> > > > 
> > > > > I'm not actually worried about the kernel so much as
> > > > > libdevmapper.
> > > > > It
> > > > > is
> > > > > not designed for multi-threaded processes, and that has bitten
> > > > > us
> > > > > in
> > > > > the
> > > > > past. For intance, it's why we don't delete devices in
> > > > > dmevent_loop()
> > > > > on
> > > > > libdevmapper errors. dm_get_events() just waits and retries if
> > > > > getting
> > > > > the device list fails, and for each device, it calls
> > > > > dm_is_mpath
> > > > > and
> > > > > will only delete a device on DM_IS_MPATH_NO, which is what I
> > > > > suggested
> > > > > for the cleanup function.
> > > > > 
> > > > > I'm pretty sure we've handled all of the known issues here,
> > > > > with
> > > > > fixes
> > > > > like:
> > > > > 02d4bf07 ("libmultipath: protect racy libdevmapper calls with a
> > > > > mutex")
> > > > > 34e01d2f ("multipath-tools: don't call dm_lib_release() any
> > > > > more")
> > > > > 
> > > > > I'd rather not risk having missed some issue that could cause a
> > > > > temporary error in a function that we call every couple of
> > > > > seconds
> > > > > (almost always unnecessarily).
> > > > 
> > > > Ok, getting it. I thought that an error in DM_TABLE_STATUS must
> > > > almost
> > > > neccessarily mean -ENXIO (from the kernel pov), which would mean
> > > > that
> > > > some external entity removed the device, and that we should act
> > > > as if
> > > > someone had used the "remove map" CLI command. But I didn't think
> > > > about
> > > > libdevmapper.
> > > 
> > > But will libdevmapper return ENXIO if it's somehow interally
> > > confused?
> > > I don't think so. I believe that if we see this error code,
> > > removing
> > > the map is the right thing to do.
> > 
> > I don't think that shouldn't ever happen.
> > 
> > https://github.com/lvmteam/lvm2/blob/928b8e9c6eaf871b3405b91c64eac5ea854f2572/device_mapper/ioctl/libdm-iface.c#L2100
> > 
> > If libdevmapper gets an ENXIO from the kernel, it ends up setting
> > dmi.exists to 0 instead of returning the error.
> 
> I meant the kernel ioctl return code. Sorry for being unclear.
> 
> >From the the point of view of libmultipath, it doesn't matter.
> libmp_mapinfo tests for ENXIO and dmi.exists, and returns DMP_NOT_FOUND
> in both cases.

Sure, that makes sense then. If libdevmapper told us the device doesn't
exist, we can safely remove it.

-Ben
 
> Martin


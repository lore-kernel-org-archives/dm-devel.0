Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794256011;
	b=Sdd7a09z12FGB68tpYiE02u+qAbXYJj0VyeDb3AFARkKimVhFkw5Un1qx2PO56P5Daq+
	 pLdqkGWYQHVyNq67ekGlygn+crCCjVJSHK8/0mCIYdruC+zAUx55S4LhLDyGmIL/aPacN
	 bBLLQhD6TtEinValmVVSFD1b0NZEyr2yOuV8OXQHFjV++zfuHRLUNh0iLibmW4gUiQnQs
	 yivtavaIiewW+Wuf4wbpnEYrRsS3TjaRFcU3sXjuEbYQMea7rsZjZ8ysXvVvZiJwqFAzG
	 OXdYQHMqshDHGm2GkiTMgVyu6spiNUs50o6YovtwJwTIeiO57ajEy8MzniC9UofPEwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794256011;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:In-Reply-To:
	 X-Scanned-By:X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:
	 X-Mimecast-Originator:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding;
	bh=H1o7jHwTVVO5BTPL3ZrIZP8MfuOrmB3FWMYgHctmdS0=;
	b=QuB+fmvIV2LMEHoWFKlyiiEcPcCeyQrfRvHTcKXfuRLHGD4LYuHLSEAuJ2Cb0OG+8rWi
	 IFrPVoi3p1qAImemAC54gNYO6xjChm66DBJcxt6ZUvL+kFGgHRhNdCZd6dZn0KLvGDhzF
	 XH86+mxmIZf5Lze3lnaIFZFPLnDzLoUY/18Eg9gN4mA7KDNuz971pBkap2QEjohc3u1EP
	 o5uuYgk5pYGgY2FckH7iSdiz+U6CjYPGt/cVWBkozbGPYPWoIlXWGuDQG/O04K2CxM8T5
	 nlmer0zbGxydAhErHsmDfxITK2Gj1nWo6AA1v5ll67jQlqC1LqtJF6dTSFs9YC0WXgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b="FqF/ZszJ";
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3A8606A321
	for <dm-devel@lists.linux.dev>; Mon,  9 Nov 2026 20:26:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF3A8606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=FqF/ZszJ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794256009;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H1o7jHwTVVO5BTPL3ZrIZP8MfuOrmB3FWMYgHctmdS0=;
	b=FqF/ZszJZi8AQSQEFmL46PDKbKzeKyP8cxRfXu1aEySj5jRIrpg7b8b9AkVmzSv/mQ0tS8
	MWcUzB5Mr386TOSJjqGrET96g9cv2C2yIIeJT41Cq4wOnRTt/8D2IeeFSjyq14trT52yBd
	knjLYLgqtxemPnFwoEyD1RADCMdmEZA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-543-Ss9VaqTJPVmkDrebfkVqlQ-1; Mon,
 09 Nov 2026 15:26:48 -0500
X-MC-Unique: Ss9VaqTJPVmkDrebfkVqlQ-1
X-Mimecast-MFC-AGG-ID: Ss9VaqTJPVmkDrebfkVqlQ_1794256007
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E6AE51955F17;
	Mon,  9 Nov 2026 20:26:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7ABA91956087;
	Mon,  9 Nov 2026 20:26:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6A9KQj2w607393
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 9 Nov 2026 15:26:45 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6A9KQgaM607380;
	Mon, 9 Nov 2026 15:26:42 -0500
Date: Mon, 9 Nov 2026 15:26:42 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Cc: Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev,
        Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH v2 1/1] multipathd: verify udev WWIDs with the device
 before moving paths
Message-ID: <avIsgj9mjV1DU-M_@redhat.com>
References: <20261029235241.97614-1-brian@purestorage.com>
 <20261029235241.97614-2-brian@purestorage.com>
 <auTdZn84HV8DjGZ0@redhat.com>
 <f9a399429d9c7ac2e4079e7cd89ae7c304ee3b24.camel@suse.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <f9a399429d9c7ac2e4079e7cd89ae7c304ee3b24.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: CuDLLeqyT8VcLDYSqUl967MgnUqzngaEIYTSNlzAQxA_1794256007
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Nov 06, 2026 at 11:19:25PM +0100, Martin Wilck wrote:
> On Fri, 2026-10-30 at 14:09 -0400, Benjamin Marzinski wrote:
> > On Thu, Oct 29, 2026 at 04:52:41PM -0700, Brian Bunker wrote:
> > > multipathd takes a path's WWID from udev. When a change uevent
> > > reports
> > > a different WWID, uev_update_path() removes the path from its map
> > > and
> > > re-adds it through uev_add_path(), which places it in whatever map
> > > owns
> > > the new WWID. Nothing checks the new value against the device
> > > itself;
> > > recheck_wwid only covers paths coming back up in the checker and
> > > "multipathd add path". If udev reports the wrong WWID, or the
> > > uevent is
> > > stale by the time it is processed, the path goes into the map of a
> > > different LUN and I/O for one LUN is silently sent to another.
> > > 
> > > Use SG_IO to read VPD page 0x83 from the device in two places, for
> > > paths where can_recheck_wwid() is true:
> > > 
> > > - In uev_update_path(), if the device still reports the cached
> > > WWID,
> > >   ignore the udev value and leave the path where it is.
> > > 
> > > - In ev_add_path(), when a path is being re-added because its udev
> > >   data was missing or changed, refuse to add it if the device
> > > doesn't
> > >   confirm its WWID. The path is orphaned, its WWID is cleared and
> > > it
> > >   is marked INIT_MISSING_UDEV, so the checker retriggers udev
> > > (bounded
> > >   by retrigger_tries) and the path is re-added from fresh data.
> > > 
> > > To tell re-adds from ordinary adds, turn the need_do_map argument
> > > of
> > > uev_add_path() and ev_add_path() into enum path_add_mode, with a
> > > new
> > > PATH_ADD_REINIT value that behaves like PATH_ADD_MAP and also
> > > requests
> > > the WWID check. Ordinary adds are unchanged and never read the WWID
> > > from the device.
> > > 
> > > If the SG_IO read fails, behavior is unchanged.
> > > 
> > > Split the SG_IO read out of check_path_wwid_change() into
> > > get_sgio_wwid() so all the checks share it.
> > > 
> > > Signed-off-by: Brian Bunker <brian@purestorage.com>
> > Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> You will need convince me that this doesn't do more harm than good. 
> We can't just use udev in one place and other methods elsewhere.

I get your concern, but we already do this when recheck_wwid is set.
Perhaps we could also gate this with that config option.
 
> I am open for a general redesign that uses sysfs for retrieving
> WWIDs, rather than udev. But using SG_IO seems wrong to me in general,
> because it can hang. If anything, we'd need to make this configurable,
> and we'd then need to use SG_IO consistently throughout the code (and
> SG_IO has significant disadvantages, as already mentioned). Also, SG_IO
> works for SCSI only. That may be a minor issue these days, because
> almost all disks handled by dm-multipath are SCSI disks, but at least
> formally we still support other block devices like NVMe and DASD.
> 
> Unfortunately there's already a zoo of options for WWID detection which
> has grown over time.
> 
> > About how likely this is: we hit it because a test tool was opening
> > and closing the sd devices read-write many times a second, and with
> > udev's "watch" rule every close generates a change uevent that runs
> > scsi_id against the device. 
> 
> I wouldn't call this a valid test. It's a deliberate abuse of udev
> functionality. If you do this, you need to disable udev's watch
> functionality, which is merely a convenience for users anyway. It's
> questionable if it's a useful feature on production servers in general.
> 
> Thinking about it, I wonder if we should simply set "nowatch" for
> multipath members by default. AFAIU that would avoid the issue Brian
> encountered, at least in this test scenario.

I can't think of anything wrong with disabling that off the top of my
head. Nothing should be directly opening these devices read-write once
they are part of a multipath device.

-Ben
 
> Regards
> Martin
> 
> -- 
> Dr. Martin Wilck <mwilck@suse.com>
> SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 Nürnberg,
> Germany
> Geschäftsführer: Stefan Gaiser, Jochen Jaser, Abhinav Puri (HRB
> 36809,AG Nürnberg)


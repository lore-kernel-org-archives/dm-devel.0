Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D7B393
	for <dm-devel@lists.linux.dev>; Fri,  9 Feb 2024 00:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707438652; cv=none; b=eSvZI0cVgfV8+CdHMHa7XwnrT4olYyrJdtrq43cbh3WpcvA5iHrk0iJNFQECU4j/bxvoLuQGf850ee/4JHkMpt6XT8UwFnUMjUSdmrFXqXO4UmjVBE30d342iCx8olie/DJ61oql3BDtwEjoYWN1MPJo3BVKKbWeiDXTHkxeoKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707438652; c=relaxed/simple;
	bh=KmUGrXoONTDHLs9Cy14FlciJu5n2XTRQ0YjeoQNAFOc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=QdhUYrhcyMThtvXu391dv6iy5rzpbFEKWfmTO3BSkc+JnQMJ4DBgh+7MZ+2qemt7cxGgUUvZDBo4GpOCbSZbPqSeV8hZSIlWIecO6mtE0c07wGBRwzncbhBOaZcwnP3hNqkben8+RoiMtayBvGbSVNWZ0A317CaZ2PI9mmboFhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N4o1NWZO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N4o1NWZO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707438649;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SSb6zviJpQ/IGw5G7DClWzoH7eoz33BIwAur+hok1jk=;
	b=N4o1NWZOOj4ZnnwQ57Vxj9yO7+OWuULSTaBm0lekEaSoig3O6BGyDba6DeC6xhwMgqka3Z
	ffoMzbWGLnU2sn0aJNr0+oshSCeqmABXYvwvRs5Sj3WZN+sTIRJM50WV1xyyWZ0Mz5o2hr
	nR6DppD36IwTbWbcC9wBieWexoc+J7U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-539-X-NS3YlqOnu0DiWibjXYbw-1; Thu, 08 Feb 2024 19:30:46 -0500
X-MC-Unique: X-NS3YlqOnu0DiWibjXYbw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B44583B828;
	Fri,  9 Feb 2024 00:30:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6E15B2166B31;
	Fri,  9 Feb 2024 00:30:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 4190Ukmx338357
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 8 Feb 2024 19:30:46 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 4190UjOe338356;
	Thu, 8 Feb 2024 19:30:45 -0500
Date: Thu, 8 Feb 2024 19:30:45 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Zdenek Kabelac <zkabelac@redhat.com>, Peter Rajnoha <prajnoha@redhat.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, linux-lvm@lists.linux.dev
Subject: Re: [PATCH 1/6] 11-dm-mpath.rules: don't import properties that are
 already set
Message-ID: <ZcVyNWizAbRC0OAd@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240205124638.17877-1-mwilck@suse.com>
 <20240205124638.17877-2-mwilck@suse.com>
 <ZcFIwjEhKAVijIQb@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
 <db27d762e517489df2828f1c530f3125f4b7f1aa.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <db27d762e517489df2828f1c530f3125f4b7f1aa.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Feb 06, 2024 at 11:50:46AM +0100, Martin Wilck wrote:
> On Mon, 2024-02-05 at 15:44 -0500, Benjamin Marzinski wrote:
> > On Mon, Feb 05, 2024 at 01:46:33PM +0100, Martin Wilck wrote:
> > > DM_UDEV_DISABLE_OTHER_RULES_FLAG and DM_NOSCAN may be already set
> > > from previous rules, e.g. if the device is suspended. Make sure
> > > we don't overwrite them.
> > > 
> > > DM_DISABLE_OTHER_RULES_FLAG_OLD and MPATH_DEVICE_READY are only
> > > used in this file, and not used in the scan_import code path.
> > > 
> > > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > > ---
> > >  multipath/11-dm-mpath.rules | 15 +++++++++++----
> > >  1 file changed, 11 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/multipath/11-dm-mpath.rules b/multipath/11-dm-
> > > mpath.rules
> > > index c339f52..2c4d006 100644
> > > --- a/multipath/11-dm-mpath.rules
> > > +++ b/multipath/11-dm-mpath.rules
> > > @@ -2,12 +2,19 @@ ACTION!="add|change", GOTO="mpath_end"
> > >  ENV{DM_UDEV_RULES_VSN}!="?*", GOTO="mpath_end"
> > >  ENV{DM_UUID}!="mpath-?*", GOTO="mpath_end"
> > >  
> > > -IMPORT{db}="DM_DISABLE_OTHER_RULES_FLAG_OLD"
> > > -IMPORT{db}="MPATH_DEVICE_READY"
> > > -
> > >  # If this uevent didn't come from dm, don't try to update the
> > >  # device state
> > > -ENV{DM_COOKIE}!="?*", ENV{DM_ACTION}!="PATH_*",
> > > IMPORT{db}="DM_UDEV_DISABLE_OTHER_RULES_FLAG",
> > > IMPORT{db}="DM_NOSCAN", GOTO="scan_import"
> > > +ENV{DM_COOKIE}=="?*", GOTO="check_ready"
> > > +ENV{DM_ACTION}=="PATH_*", GOTO="check_ready"
> > > +
> > > +ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}!="?*",
> > > IMPORT{db}="DM_UDEV_DISABLE_OTHER_RULES_FLAG"
> > > +ENV{DM_NOSCAN}!="?*", IMPORT{db}="DM_NOSCAN"
> > > +GOTO="scan_import"
> > > +
> > 
> > If we do this, don't we forget the values for
> > DM_DISABLE_OTHER_RULES_FLAG_OLD and MPATH_DEVICE_READY whenever we
> > get a
> > non-dm uevent? If we skip importing them for a uevent, they're
> > dropped
> > from the database, which means that on the next dm-originated uevent
> > we
> > won't be able to get the old values. right?
> 
> Right, I didn't consider that. It makes sense for MPATH_DEVICE_READY.
> 
> However, while at it, I wonder about our rationale for saving
> DM_UDEV_DISABLE_OTHER_RULES_FLAG in DM_DISABLE_OTHER_RULES_FLAG_OLD.
> 
> In 10-dm.rules, DM_DISABLE_OTHER_RULES_FLAG changes its value only
>  - in DM_UDEV_PRIMARY_SOURCE_FLAG=1 events, according to the value of
> DM_SUSPENDED
>  - for DISK_RO=1 events (switches the flag on) 
> 
> (11-dm-lvm.rules has some additional logic that doesn't matter for
> multipath).
> 
> For all other events, the flag is restored from the udev db in 10-
> dm.rules. Ignoring DISK_RO, it always has the value that DM_SUSPENDED
> had in the last DM_UDEV_PRIMARY_SOURCE_FLAG=1 (aka map reload) event.
> 
> The logic in 11-dm-mpath.rules adds a check for unusable arrays
> on top, setting DM_DISABLE_OTHER_RULES_FLAG if MPATH_DEVICE_READY
> switches from 1 to 0. In this case we save the previous value in
> DM_DISABLE_OTHER_RULES_FLAG_OLD, and restore it from there in a later
> event if MPATH_DEVICE_READY switches back from 0 to 1.
> 
> IMO the following can happen:
> 
>  1. an event arrives while DM_SUSPENDED=1, causing 
> DM_DISABLE_OTHER_RULES_FLAG=1 to be set
>  2. 11-dm-mpath.rules sees no paths and saves
> DM_DISABLE_OTHER_RULES_FLAG=1 to DM_DISABLE_OTHER_RULES_FLAG_OLD
>  3. an event arrives after the device has resumed, DM_SUSPENDED and
> DM_DISABLE_OTHER_RULES_FLAG are cleared in 10-dm.rules
>  4. 11-dm-mpath.rules sees MPATH_DEVICE_READY=1 and restores
> DM_DISABLE_OTHER_RULES_FLAG, setting it to 1
> 
> ... and this would be wrong, no?
> 
> It seems to me that we should not save DM_DISABLE_OTHER_RULES_FLAG_OLD
> between uevents. We must set DM_DISABLE_OTHER_RULES_FLAG=1 to avoid
> upper layer probing if there are no paths, but I suppose we should
> restore the previous value after udev rule execution, e.g. in 99-dm-
> mpath.rules:
> 
> ENV{DM_DISABLE_OTHER_RULES_FLAG_OLD}=="?*", \
>    ENV{DM_DISABLE_OTHER_RULES_FLAG}=$env{DM_DISABLE_OTHER_RULES_FLAG_OLD}, \
>    ENV{DM_DISABLE_OTHER_RULES_FLAG_OLD}=""
> 
> Am I confusing stuff here?

Nope. That makes a lot of sense.
 
> Unfortunately, testing of my patch series has shown that it's an
> improvement, but it isn't sufficient for completely avoiding races
> between multipathd and udev. DM_SUSPENDED=1 can be avoided, but it's
> still possible that the device gets suspended after the udev rules test
> for supended state and before they run kpartx, blkid, pvscan, or other
> similar commands.
> 
> I am quite clueless about this right now, and would be grateful for
> ideas. Re-implementing LOCK_EX locking would be a possibility for
> systemd >= 250, as noted in the cover letter of the series. But for
> systemd <= 249, I don't see good options. We can't use LOCK_EX, because
> when we release the lock, we have no means to know whether or not a
> race with udev occurred (iow, whether udev tried to access the device
> while we held the lock, failed, and dropped the event). Thus we'd need
> to assume that this was the case, and force a reload after each reload,
> which is obvious nonsense. We also have no means to know whether the
> full set of rules has ever been run by udev for the device at hand,
> because we don't know the set of rules that follow after 11-dm-
> mpath.rules.

multipathd already refuses to reload newly created devices before it
sees the creation uevents to try to avoid this.  I assume that the
problem you are seeing is on the coldplug after the pivot root, where
the devices already exist, or am I confused here.  I wonder if we can do
something similar where we would ideally delay all device reloads until
after the coldplug.  The problem is figuring out when it's finished.

-Ben

> Thanks,
> Martin


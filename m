Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794513524;
	b=QeHMtiShXHv5hUpRqEqHj/FBMHDLuVY4eg4pIIEt/sv5j803Q7lFgQTgkcQemVC/Up9o
	 mR8fPyCtxbSYT034S+jGrWOhZbEpYa+iwHxPl3OiOlJ6yhJCkSPvErL/myfUszFmczC2j
	 x9dDu/Q3NTWCUpviOd5iGJLq8njU9WetIGe1e6pEa3Z/Vmi938vbCu83M08gHktNoiDVT
	 Jhy+rSZKoWimtf9Y82Gt3EwCCN1prQWmh/iZa3JHfKnExeQRNH+WCvebDacHEF1i+TxT+
	 81zVvGyAUg/n15tNvLsB5XiO5RPatZiiiXp8XIdqG9zp23OpKMTPtzTqgWm6YtlNFnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794513524;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:In-Reply-To:
	 X-Scanned-By:X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:
	 X-Mimecast-Originator:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding;
	bh=QjIHwhXHU6bysDdQc2f1+s6VZ9ZxhEx3cd5SuWedFg0=;
	b=j5UshWbTvtxrJ7NuNHQ9EIC78bjZSC7Pf+nWy8Caj32MjpYx/3pyAav5kxEvLCfYfyKG
	 K3A/ELIfJ4S6De3rcRvDoS89ppISFPK60eY0P6ZNlCiRdkYtdpyJcEgS697OJzIGBT0YP
	 YVmPeJzF2/bMbeCDXMgMd2XCXzW4CbxWaQxtagdtKLE8lxsKDNzkRRkd7V3vxgZL4TEF1
	 eOxWjihFW1WZlW6fEXEZBI3Y4Tomyi4LVdpWxGaLFaldcZSOXpmJVF5Y0XuOkuVBz7d//
	 8ZcX3IwTwohIMlB/Wg8CKDmJmxjFXCEj9VaxWjHHxN6P/nwv7vwuMLYK5s7Lm4lq+TQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ARbD1sQ9;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0FA2606A31C
	for <dm-devel@lists.linux.dev>; Thu, 12 Nov 2026 19:58:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C0FA2606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ARbD1sQ9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794513522;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QjIHwhXHU6bysDdQc2f1+s6VZ9ZxhEx3cd5SuWedFg0=;
	b=ARbD1sQ9PTz+Lo/yhJI6GocjkEN8055DEPkmKCS/THx83tnqQ/4ddgZoBz49Im8nLEtyAQ
	AaUBA0evyiA9fPvsnnxJpvR96spMdEymVubA2ApsAZgJGZ7KpBoKiDNK/cGypCSc9OQ38R
	q9xpFXslpaY9YEYrD1I/iaM5NZp6T08=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-364-_YjLSjthMgyw36JD8cyh_w-1; Thu,
 12 Nov 2026 14:58:37 -0500
X-MC-Unique: _YjLSjthMgyw36JD8cyh_w-1
X-Mimecast-MFC-AGG-ID: _YjLSjthMgyw36JD8cyh_w_1794513515
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8B7141800378;
	Thu, 12 Nov 2026 19:58:35 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0E8B41956086;
	Thu, 12 Nov 2026 19:58:34 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6ACJwXNi1713531
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 12 Nov 2026 14:58:33 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6ACJwXkl1713530;
	Thu, 12 Nov 2026 14:58:33 -0500
Date: Thu, 12 Nov 2026 14:58:33 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Cc: Brian Bunker <brian@purestorage.com>, Hannes Reinecke <hare@suse.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: udev / multipath-tools: WWID determination with SG_IO vs. sysfs
Message-ID: <avYaaRagjQOdhnyj@redhat.com>
References: <20261109185556.27139-1-brian@purestorage.com>
 <214d18ebabeca8318352dfa5456bc5b37cdefdeb.camel@suse.com>
 <20261111174259.41911-1-brian@purestorage.com>
 <cad66f75079fe0a89150e304d753527f140c67d9.camel@suse.com>
 <20261111230535.12947-1-brian@purestorage.com>
 <83f73b9cb1506eb80220759e3e0aae18648f80c4.camel@suse.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <83f73b9cb1506eb80220759e3e0aae18648f80c4.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2r3yu94Ih4q65e7qjBK8tzXOMxTczx1b-5Vtu7UuJy8_1794513515
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Nov 12, 2026 at 08:00:58PM +0100, Martin Wilck wrote:
> Brian, Ben, Hannes,
> 
> Following up the discussion on Brian's latest patch, I've researched a
> bit into the SG_IO vs. sysfs topic. I wondered why, under RHEL and
> other distributions, where scsi_id is being used for device
> identification, udev rules hanging in SCSI device ID determination
> doesn't seem to be an issue, whereas SUSE has switched to sg_inq --
> inhex --raw on sysfs files more than 10 years ago for precisely that
> reason.
> 
> # About SG_IO blocking in udev rules:
> 
> SUSE switched from scsi_id to sg_inq in 2014, before releasing SLE12.
> We got reports about udev rules hanging in device detection, but
> AFAICS, only for USB devices. Actually, for those, it seems that the
> hanging syscall was not the SG_IO ioctl itself, but the initial open()
> on the device node (we have no evidence about the reasons; it's likely
> that device probing was stuck in the kernel because of misbehaving
> cheap USB hardware).
> 
> The reason that these hangs in udev rules have been seen under
> (open)SUSE and apparently not on RHEL or other distros is rather
> trivial: In 60-persistent-storage.rules, scsi_id is only called if
> ID_SERIAL is not set yet [1]. For those USB devices that SUSE has seen
> trouble with, ID_SERIAL would be set by usb_id, and thus scsi_id is
> never invoked; therfore no hang. OTOH, 55-scsi-sg3_id.rules calls
> sg_inq unconditionally [2], which may cause hangs with badly behaving
> USB devices. To fix that, SUSE switched from SG_IO to reading sysfs
> files a while after it had switched to sg_inq.
> 
> So far I haven't found evidence for a hanging sg_inq on hardware that
> actually matters for multipath. That doesn't mean that it can't happen,
> network-based I/O can always suffer from timeouts or delays, of course,
> we have observed it quite a few times. But if this was a frequent
> issue, I would expect it to get noticed by users.
> 
> @Ben, have you ever observed SG_IO ioctls blocking in scsi_id in udev
> rules?

Over the years I've seen occassional issues where udev workers time out.
Unfortunately, they are either from something obviously wrong (which
hasn't been getting the device ID, IIRC), or there usually isn't enough
data to determine why, and they can't be reproduced.
 
> @Hannes, am I overlooking something? Do you recall cases of hanging
> sg_inq processes on devices other than USB?
> 
> # About SG_IO blocking in multipathd:
> 
> Broken USB devices are not an issue for multipathd. W have ignored USB
> devices since 0.6.0, 51957eb ("Skip USB devices during discovery").
> Since 0.8.5, 5bd2645 ("libmultipath: Allow discovery of USB devices"),
> they can be re-enabled, but I suppose that that's not a frequently used
> feature.
> 
> We mostly avoid ioctls for paths that are down or otherwise unusable in
> multipathd, except for the checker, where we use threads. Still, even
> if the checker has seen a path in UP state, it can happen that SG_IO
> would stall when retrieving the priority. There is sporadic evidence
> that this has happened, but not much (surprisingly few, actually, and
> most reports that I could find are quite old already).
> 
> I am not aware of any cases where the recheck_wwid code had caused
> hanging ioctls.

I know some users have turned this on, if they have problems fixing
something that is remapping their LUNs without making sure that they
aren't in use. I don't have a good handle on how many users that is, but
I'm pretty sure it's not a large number. I have never heard of it
causing problems though.
 
> Brian's patch would add more such ioctls and thus increase the
> likelihood of observing a stall. To be observed.
> 

This is true, and unlike the existing recheck_wwids use and the
prioritizer, it won't be called right after the path checker determined
a path to be up. We do also do SG_IO ioctls in pathinfo when DI_IOCTL is
set (when we're adding a path, reconfiguring multipath, or initializing
a partial path). In that case we do check if the path is up according to
sysfs first, but we don't call the checker.

-Ben

> 
> # About sysfs data being stale:
> 
> The kernel will update the VPD pages when a UNIT ATTENTION with
> ASC/ASCQ 3f/03 occurs ("INQURIY data has changed"; since kernel v4.6).
> Normally, the VPD page update happens synchronously before the uevent
> is sent to user space. Therefore reading the sysfs attribute from the
> udev rule is guaranteed (almost, see below) to return the data that was
> current right after the UA had been processed (the uevent is sent from
> a kernel thread, thus a small delay is possible). 
> 
> However, it is possible that the update of the VPD data is skipped
> because the device is not running, or the queue is quiesced. In this
> case, the sysfs VPD data would also be stale (but later SG_IO would be
> likely to fail as well).
> 
> It is also possible that the VPD data changes between establishing the
> UA and calling scsi_id or sg_inq, but the probability should be rather
> low.
> 
> Similar considerations hold for "add" events; for a device just added,
> I'd expect the VPD data to be correct with very high likelihood,
> especially if it is in "running" state.
> 
> The kernel does *not* rescan devices on receiving a UA with ASC/ASCQ
> 3f/0e ("REPORT LUNS data has changed"). AFAIU, it isn't well defined
> what condition a given storage array actually establishes when a LUN
> mapping changes. 3f/03 and 3f/0e are both possible, as is 29/xx "Power
> on or device reset occured". 3f/0e may actually be received on a
> different LUN than the one that had actually changed.
> 
> So, of 3f/0e or 29/xx occurs, the VPD data may be stale. And of course
> also if the LUN mapping changes without any event occuring, as
> discussed in the past in the context of the "recheck_wwid" option. Only
> actively writing to the "rescan" sysfs attribute would fix this.
> 
> Thinking about this, it might make sense to switch from sysfs to SG_IO
> in udev rules if we observe a 3f/0e or 29/xx UA.
> 
> @Hannes, what do you think?
> 
> IIRC we've discussed handling UA events in multipathd before, but
> nobody has started working on it so far. If we do, we'd need to handle
> all 3 kinds of events.
> 
> Regards & sorry for the long post,
> Martin
> 
> 
> [1] https://github.com/systemd/systemd/blob/6ec3ff3f41b7569d96a475a11db716f5feb35a6f/rules.d/60-persistent-storage.rules.in#L75
> [2] https://github.com/doug-gilbert/sg3_utils/blob/8799caa3741b2b1640970747aeb84f17dbbaad86/scripts/55-scsi-sg3_id.rules#L67
> 
> -- 
> Dr. Martin Wilck <mwilck@suse.com>
> SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 Nürnberg,
> Germany
> Geschäftsführer: Stefan Gaiser, Jochen Jaser, Abhinav Puri (HRB
> 36809,AG Nürnberg)


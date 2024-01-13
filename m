Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD69EA5F
	for <dm-devel@lists.linux.dev>; Sat, 13 Jan 2024 00:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SW3/MiOF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705107123;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=RP5Qx/Fv+d3tYcTnHCB6OQPwZY0wUxEr6j//78wYYRc=;
	b=SW3/MiOFwP0gjisaw7FxpEXjGiPFR5o2By7ycpvWj6ucNvOUy5Il8uDvYYWw8zrvjLU2Oj
	tjHKxOVmV9y05klMaJQJp1BHU4k/fBJA7/ea5XkyOYxssJEofHla5vhzpXN+Zudu30CNXo
	RrcjNEDwA0bz93qm4ThplK7d357Oev8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-67-tseq755cMCmwhBJGIKpthA-1; Fri,
 12 Jan 2024 19:52:00 -0500
X-MC-Unique: tseq755cMCmwhBJGIKpthA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D49EC3806707;
	Sat, 13 Jan 2024 00:51:59 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C6A0640C6EB9;
	Sat, 13 Jan 2024 00:51:59 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 40D0pxbC036334
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 12 Jan 2024 19:51:59 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 40D0pxN8036333;
	Fri, 12 Jan 2024 19:51:59 -0500
Date: Fri, 12 Jan 2024 19:51:59 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Subject: Multipath bootup failure
Message-ID: <ZaHer1amGhviRscA@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Booting a machine with a multipathed kpartx root device fails for me
using the fedora rawhide multipath packages, which are based on the
0.9.7 release. Using LVM on top works. The issue is that when the root
device is directly on a partition, dracut finds it on one of the path
devices, and starts using that. If multipathd isn't running when the
uevent for that path device is processed, it won't be claimed by
multipath (starting in 0.9.7), since there is no multipathd.socket in
the initramfs and no systemd_service_enabled().  Afterwards, multipathd
creates a multipath device on top of the device, claims it, and removes
the partitions. If this happens while dracut is attempting to mount the
root device, the boot fails. In practice, it usually failed for me.

Reverting 6fad1464 ("libmpathutil: remove systemd_service_enabled()")
resolves the problem. When I tried to add 

Before=dracut-pre-mount.service

to dracut's version of multipathd.service instead, it works over 95% of
the time, but it still occasionally fails. The issue is that even though
multipathd will creates the multipath device before before signaling
that it has started up, meaning that dracut won't start working towards
mounting the root device until after the multipath device exists, dracut
won't know to not use the underlying device partition until it processes
the uevents that get triggered by multipathd creating the device. And it
won't be able to use the kpartx device until in processes the uevents
that get triggered by kpartx running when processing the multipath
device uevents. Depending on how quickly dracut processes these events
relative to the rest of the bootup work, it can still hang. I've tested
adding

Before=systemd-udev-trigger.service

to multipathd.sevice with no failures so far.  This requires fixing
multipathd-configure.service, so that there aren't any dependency
conflicts, but that should happen anyway.  I need to talk to the CoreOS
people who added this, but I think the only necessary dependency for
multipathd-configure.service to come after is

After=dracut-cmdline.service

With this, I think that multipathd should always be running before
device uevents get processed, but perhaps it needs to be before
systemd-udevd.service instead.

If it's not possible to guarantee that multipathd has started before we
process uevents so that we always claim the path devices as soon as they
appear, then to close this race window, we need to either wait after
multipathd starts for all the uevents to settle (and I don't think we
want to get back into the business of relying on udev-settle), or to go
back to some method of making multipath able to claim devices before
multipathd starts. 

Or we do something more clever. Thoughts?

-Ben


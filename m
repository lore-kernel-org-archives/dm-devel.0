Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9681799F
	for <dm-devel@lists.linux.dev>; Mon, 15 Jan 2024 15:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AvoNaJoH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705333632;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ReHse0+QXFse8YEma/gT4ORT/bIoVA8lQSlXEsfWhGY=;
	b=AvoNaJoH0c0GCkEijEb5pkkV1RFemAv4d7z99pa/r1zOP3FDi657g+dzJ/CKA5Vcbrddbn
	H0/Cw5uFxHjOqyVWj8o1eMa6Y2rg8xZy8gIWWWsTLBxolEHxj9xg5VOoRJz4WLfVjwC3XK
	3DdPSGD55HdLTTOs4Q2eZ0kNbRM/S8M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-65-pBud4atqOOO38Y8ZTmiTCg-1; Mon, 15 Jan 2024 10:47:09 -0500
X-MC-Unique: pBud4atqOOO38Y8ZTmiTCg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 72BD085A5AA;
	Mon, 15 Jan 2024 15:47:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 648FB2026D6F;
	Mon, 15 Jan 2024 15:47:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 40FFl9UM002180
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 15 Jan 2024 10:47:09 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 40FFl9LW002179;
	Mon, 15 Jan 2024 10:47:09 -0500
Date: Mon, 15 Jan 2024 10:47:09 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: Multipath bootup failure
Message-ID: <ZaVTfW9XnPDU95AT@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <ZaHer1amGhviRscA@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
 <78376127ecf7f0dfa0a7097c52952ecc841d18a0.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <78376127ecf7f0dfa0a7097c52952ecc841d18a0.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Jan 15, 2024 at 01:06:56PM +0100, Martin Wilck wrote:
> > I've tested adding
> > 
> > Before=systemd-udev-trigger.service
> > 
> > to multipathd.sevice with no failures so far.  This requires fixing
> > multipathd-configure.service, so that there aren't any dependency
> > conflicts, but that should happen anyway.  I need to talk to the
> > CoreOS
> > people who added this, but I think the only necessary dependency for
> > multipathd-configure.service to come after is
> 
> Disclaimer: I have no experience with multipathd-configure.service.

This is from the CoreOS team, and I've never really understood their
need for it outside of setting up a new system.

> > 
> > After=dracut-cmdline.service
> > 
> > With this, I think that multipathd should always be running before
> > device uevents get processed, but perhaps it needs to be before
> > systemd-udevd.service instead.
> 
> Yes indeed. I thought this was already the case with the "recent"
> changes made to dracut's multipath module:
> 
> 297525c fix(multipath): remove dependency on multipathd.socket
> 6246da4 fix(multipathd.service): drop dependencies on iscsi and iscsid
> a247d2b fix(multipathd.service): adapt to upstream multipath-tools unit file
> 371b338 fix(multipathd.service): remove dependency on systemd-udev-settle
> 
> Basically multipathd.service should have (almost) no "After="
> dependencies, making it start very early during boot, and definitely
> before systemd-udev-trigger.service. Actually, it should start up after
> systemd-udev-socket.service, but before systemd-udevd.service. This way
> we'd ensure that we don't miss any uevents.
> 
> I don't quite understand why this wasn't the case for you. Was it
> caused by multipathd.configure.service and its dependencies?

Yeah, to get it that early I do needed to change the
multipathd-configure.service dependencies to something sensible.

> (Note also my pending dracut PR
> https://github.com/dracutdevs/dracut/pull/2563#issuecomment-1823525208
> where I'm trying to get rid of the dracut-specific multipathd.service
> file).
> 
> > If it's not possible to guarantee that multipathd has started before
> > we
> > process uevents so that we always claim the path devices as soon as
> > they
> > appear, then to close this race window, we need to either wait after
> > multipathd starts for all the uevents to settle (and I don't think we
> > want to get back into the business of relying on udev-settle), or to
> > go
> > back to some method of making multipath able to claim devices before
> > multipathd starts. 
> 
> I don't think this will be necessary. We just need to get the
> dependencies right. Your example shows, though, that it might be
> sufficient to just add another service (here I suspect multipathd-
> configure.service) to mess up the deps. We can consider adding an
> explicit
> 
> Before=systemd-udevd.service
> 
> to our unit file. This way it'd be guaranteed that we start up before
> udevd, and if some other unit got it wrong, systemd should report a
> dependency cycle.
> 

Yep, I was planning on posting a fix to change this, once I have a
discussion with the CoreOS people about changing
multipathd-configure.service.

-Ben
 
> Regards
> Martin
> 


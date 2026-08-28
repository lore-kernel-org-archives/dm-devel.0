Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECEF37E5F5
	for <dm-devel@lists.linux.dev>; Fri, 28 Aug 2026 18:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787940016; cv=none; b=LwE4LaAa2gReYUqcR2CTof82vNhyU6GG9Kg0OrqYNlEBL2WECbrheWUYdM1QHHdoDIBKo6Mg4Gt8d6l4TKvrd54B9Opw+No2d8FuELNxi4v7n36g95/8TWftDUHl0LPICdtMSmXUb2x6ziaaMYws0+NX/LyllIWNGfJqTdeulZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787940016; c=relaxed/simple;
	bh=NCCQuyULkSmoZYRgLjztGekCXwdQAZnlqG9/I60Bxe0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=BUofTgDPRA1bscl8YUFK4dI79ny63xtiA6WYW9i5SzepS6SrFtfM6hq9UkYRNyQMpz9yit6rwpDOjSwO96ywS6E9dYH+V02SoSLxG2Z4ULTAONZU69Jv/EpLZkTI9QsLdAwOkZudwqPXBEYWZTRXJEbcntO7uYITVWXT1RarY14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J8EwaId/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J8EwaId/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787940013;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ut1Vibgh1GBrnU+jW87QuDZPHrdYo/AxaPtztmgD26E=;
	b=J8EwaId/DbOvXvuH3NiWBQI7Y+Q3B+9Xf/wC6RzYUjHAm8Ohj/JgA0EWdNQn/UaYhDjOfb
	38/xvVezi7tXUOzBPghFGffTb1HhFHqHP97WYRbCMjpJldM0tM9W7N89BcuC4UeVFEOwXi
	2Zzx8cdYQh12BNyxwNezivX4amRxInY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-198-1VAn0HwOO8uRvx3KQ-uHBw-1; Fri,
 28 Aug 2026 14:00:11 -0400
X-MC-Unique: 1VAn0HwOO8uRvx3KQ-uHBw-1
X-Mimecast-MFC-AGG-ID: 1VAn0HwOO8uRvx3KQ-uHBw_1787940010
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 96DB0190A379;
	Fri, 28 Aug 2026 18:00:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4CCE21955F05;
	Fri, 28 Aug 2026 18:00:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 67SI09i74037569
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 28 Aug 2026 14:00:09 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 67SI05vL4037352;
	Fri, 28 Aug 2026 14:00:05 -0400
Date: Fri, 28 Aug 2026 14:00:05 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Cc: Antonio Alvarez Feijoo <antonio.feijoo@suse.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCH] multipath.rules.in: fix race in unit
 cancel-multipath-wait-$kernel
Message-ID: <apHMpfHQ5zivcVAB@redhat.com>
References: <20260828092548.34637-1-antonio.feijoo@suse.com>
 <a709459222a440dc7f821796b1a98ebaeb44572b.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <a709459222a440dc7f821796b1a98ebaeb44572b.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GDgHg1GeEZOy8ZAfyXxoFjGi3PT0wao6XhhYpMg_u_Q_1787940010
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Aug 28, 2026 at 03:57:38PM +0200, Martin Wilck wrote:
> @Ben and others, I wasn't certain about this at first. Below is my flow
> of thoughts from the SUSE bugzilla, through which I came to think that
> it's correct. But this is quite subtle, so please give it some own
> thoughts ;-)
> 
> Martin
> 
> IIUC, if the "Conflicts" is removed, the timer unit will continue
> running through the switch root phase, and will be taken up by systemd
> through serialization 

But like Antonio said, isolate will stop the timer, since it's not a
dependency of initrd-switch-root.target, right? I'm a little fuzzy on
exactly how all the units get stopped, and you might be right that a
udev rule could run and trigger a timer after the isolate could catch
it. But I think you are right that this would be harmless if it could
occur.

-Ben

> 
> [*] upstream dracut version history related to multipathd.socket:
> 
> 247d2b ("fix(multipathd.service): adapt to upstream multipath-tools
> unit file") (dracut 056) added socket dep to the multipathd.service
> unit file.
> 02e646f ("fix(multipath): install multipathd.socket") (dracut 058) made
> sure the socket unit file was installed.
> 297525c ("fix(multipath): remove dependency on multipathd.socket")
> (dracut 060) removed both
> 
> 5e87b68 ("refactor(multipath): remove custom multipathd.service")
> (dracut 107) removed the .service file.
> 
> > ---
> >  multipath/multipath.rules.in | 14 ++++++++++++--
> >  1 file changed, 12 insertions(+), 2 deletions(-)
> > 
> > diff --git a/multipath/multipath.rules.in
> > b/multipath/multipath.rules.in
> > index 2ac1972f..7b605dd4 100644
> > --- a/multipath/multipath.rules.in
> > +++ b/multipath/multipath.rules.in
> > @@ -68,8 +68,18 @@ ENV{.SAVED_FM_WAIT_UNTIL}=="?*",
> > GOTO="pretend_mpath"
> >  # the --on-active timeout.
> >  #
> >  # We must trigger an "add" event because LVM2 will only act on
> > those.
> > -
> > -RUN+="@SYSDIR_BIN@/systemd-run --unit=cancel-multipath-wait-$kernel
> > --description 'cancel waiting for multipath siblings of $kernel' --
> > no-block --timer-property DefaultDependencies=no --timer-property
> > Conflicts=shutdown.target --timer-property Before=shutdown.target --
> > timer-property Conflicts=initrd-cleanup.service --timer-property
> > Before=initrd-cleanup.service --timer-property AccuracySec=500ms --
> > property DefaultDependencies=no --property Conflicts=shutdown.target
> > --property Before=shutdown.target --property Conflicts=initrd-
> > cleanup.service --property Before=initrd-cleanup.service --on-
> > active=$env{FIND_MULTIPATHS_WAIT_UNTIL} @SYSDIR_BIN@/udevadm trigger
> > --action=add $sys$devpath"
> > +#
> > +# These units are ordered Before=initrd-cleanup.service so that a
> > trigger that
> > +# is already in flight completes before the initrd switches root.
> > They must
> > +# *not* use Conflicts=initrd-cleanup.service: unlike
> > shutdown.target, whose
> > +# jobs are enqueued irreversibly, initrd-cleanup.service/start is a
> > plain job
> > +# enqueued by initrd-parse-etc.service via OnSuccess=. Starting a
> > unit that
> > +# conflicts with it therefore cancels that job instead of failing to
> > start,
> > +# and OnSuccess= is never retried, so the initrd would hang forever
> > with an
> > +# empty job queue. Stopping these units before switch-root is
> > already
> > +# guaranteed by the isolate to initrd-switch-root.target.
> > +
> > +RUN+="@SYSDIR_BIN@/systemd-run --unit=cancel-multipath-wait-$kernel
> > --description 'cancel waiting for multipath siblings of $kernel' --
> > no-block --timer-property DefaultDependencies=no --timer-property
> > Conflicts=shutdown.target --timer-property Before=shutdown.target --
> > timer-property Before=initrd-cleanup.service --timer-property
> > AccuracySec=500ms --property DefaultDependencies=no --property
> > Conflicts=shutdown.target --property Before=shutdown.target --
> > property Before=initrd-cleanup.service --on-
> > active=$env{FIND_MULTIPATHS_WAIT_UNTIL} @SYSDIR_BIN@/udevadm trigger
> > --action=add $sys$devpath"
> >  
> >  LABEL="pretend_mpath"
> >  ENV{DM_MULTIPATH_DEVICE_PATH}="1"
> 
> -- 
> Dr. Martin Wilck <mwilck@suse.com>
> SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 Nürnberg,
> Germany
> Geschäftsführer: Jochen Jaser, Andrew McDonald (HRB 36809,AG Nürnberg)


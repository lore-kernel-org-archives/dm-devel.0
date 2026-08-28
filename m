Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E1057C9F
	for <dm-devel@lists.linux.dev>; Fri, 28 Aug 2026 13:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787925471; cv=none; b=b4YRmRlcvfSnaVlXLkZehDbJj/z/OVaPYUaa7t/dZAcOdxFA1S9i2Mp8HnhFmcCNCcUdD/6NKEbGg0x/Q8TGxGqZ29iekyL39nWo/d8sn+fh8eqN1jHJfHfQb8BNPDxC3t9h3Tu+WwPJaIcwClR2KCz3ivMtCZIoE6PbBrt+odg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787925471; c=relaxed/simple;
	bh=cZKIJQR23E6FMjFTPorIv1MTFX1HJ4stJK/b0dg3Bys=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LCpuiXaUQNn9RqKff4nGks9DmM9kQQtJ5EVh3HezOgyO6q8LMpq/wqvonOEXMtp94vG9RF+kfOi46MXfSpeP2L/0P7iusW/E386sUoKHYhZwdSWLUAkPaOPWYgGlt0WGimN6mFo754jRbUQsVeIOXbSlnDgS1IeNYviIy4Hs4J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=TWR/o2UM; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=sDQKdFnA; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="TWR/o2UM";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="sDQKdFnA"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B953021AEA;
	Fri, 28 Aug 2026 13:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787925463; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cZKIJQR23E6FMjFTPorIv1MTFX1HJ4stJK/b0dg3Bys=;
	b=TWR/o2UMnAHN4d6CTWqyb15/CnLN0uGfGjAgnQjcbFNXWUdDCrdp/hS1/L+SdrfQyTKnBz
	+X4QqKVgXuXyOKyLlVoj+RYMM0VSdyC6MgzBCLqRcNVma6h+MLB+eOmEVo+NU/GKXq2nOD
	IJL/iWVm9GSgVMrIBOZU1exQp1ZYmdQ=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787925459; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cZKIJQR23E6FMjFTPorIv1MTFX1HJ4stJK/b0dg3Bys=;
	b=sDQKdFnAYUDuT4zXs6xEZR2hVtc2C0ki94rXuuu5CdMovgYviZhwydYZTcdfQKUf/XmmQk
	HOnO5WPaG5MIXSwwnpmSygJxOBgeILvcm73YTNDM2EJCpY9U6mznmoJiBPKFuhNKFIkUiK
	Nh+wkv5sUPjoldOjwJ2qxuT16QMZANA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 87B2A13674;
	Fri, 28 Aug 2026 13:57:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cgoBINOTkWqzDAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Fri, 28 Aug 2026 13:57:39 +0000
Message-ID: <a709459222a440dc7f821796b1a98ebaeb44572b.camel@suse.com>
Subject: Re: [PATCH] multipath.rules.in: fix race in unit
 cancel-multipath-wait-$kernel
From: Martin Wilck <mwilck@suse.com>
To: Antonio Alvarez Feijoo <antonio.feijoo@suse.com>, 
	dm-devel@lists.linux.dev
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 28 Aug 2026 15:57:38 +0200
In-Reply-To: <20260828092548.34637-1-antonio.feijoo@suse.com>
References: <20260828092548.34637-1-antonio.feijoo@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Score: -7.30
X-Spam-Level: 
X-Spamd-Result: default: False [-7.30 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUBJECT_HAS_CURRENCY(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.992];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:email]
X-Spam-Flag: NO

On Fri, 2026-08-28 at 11:25 +0200, Antonio Alvarez Feijoo wrote:
> The transient unit cancel-multipath-wait-$kernel creates a timer and
> service with "Conflicts=3Dinitrd-cleanup.service":
>=20
> - sda: /usr/lib/udev/rules.d/56-multipath.rules ...
> =C2=A0=C2=A0=C2=A0 --on-active=3D1.000000 ...
> - sda: ... 'Running timer as unit: cancel-multipath-wait-sda.timer'
> - sda: ... 'Will run service as unit:
> =C2=A0=C2=A0=C2=A0 cancel-multipath-wait-sda.service'
>=20
> This introduces a race not always reproducible: there is a 1 second
> window where this transient unit can start after
> initrd-cleanup.service/start is enqueued but is still held back. When
> that happens, starting cancel-multipath-wait-$kernel.service pulls in
> a stop job for initrd-cleanup.service and the queued start job is
> cancelled, the initrd is left with an empty job queue and hangs
> forever, before switch-root:
>=20
> - initrd-parse-etc.service: Triggering OnSuccess=3D dependencies.
> - initrd-cleanup.service: Installed new job
> =C2=A0=C2=A0=C2=A0 initrd-cleanup.service/start as 115
> - initrd-cleanup.service: starting held back, waiting for:
> =C2=A0=C2=A0=C2=A0 dracut-pre-pivot.service
> - initrd-cleanup.service: Job 115 initrd-cleanup.service/start
> =C2=A0=C2=A0=C2=A0 finished, result=3Dcanceled
> - initrd-cleanup.service: Installed new job
> =C2=A0=C2=A0=C2=A0 initrd-cleanup.service/stop as 133
> - initrd-cleanup.service: Job 133 initrd-cleanup.service/stop
> =C2=A0=C2=A0=C2=A0 finished, result=3Ddone
>=20
> "Conflicts=3D" is symmetric: if a unit has a "Conflicts=3D" requirement
> on a set of other units, then starting it will stop all of them and
> starting any of them will stop it. This is safe against
> shutdown.target, whose jobs are enqueued irreversibly: a unit
> starting during shutdown fails to start rather than cancelling the
> shutdown. It is not safe against initrd-cleanup.service, whose start
> job is an ordinary job enqueued by initrd-parse-etc.service via
> "OnSuccess=3D".
>=20
> Ordering "Before=3Dinitrd-cleanup.service" is enough and is not
> destructive: a trigger already in flight completes before cleanup
> runs, and a unit with no job does not delay it. Tearing the
> transient units down before switch-root is already handled by the
> isolate to initrd-switch-root.target, which stops everything that
> is not "IgnoreOnIsolate=3Dyes".
>=20
> Signed-off-by: Antonio Alvarez Feijoo <antonio.feijoo@suse.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

@Ben and others, I wasn't certain about this at first. Below is my flow
of thoughts from the SUSE bugzilla, through which I came to think that
it's correct. But this is quite subtle, so please give it some own
thoughts ;-)

Martin

The general idea of the "cancel" timer is this:

1. uevent for a block device arrives, the WWID is yet unknown to
multipath
2. multipathd sees the event and temporarily sets SYSTEMD_READY=3D0,
avoiding other subsystems like MD or LVM grabbing it, and waiting for
potential other paths to appear
3. udev starts the transient timer unit
3a. some other path to the same volume appears, and the timer is
cancelled (we are not discussing this case here)
4. when the timer expires, it starts "udevadm trigger"
5. the kernel generates a new uevent for the same block device
6. while handling the uevent, "multipath -u" is run.=20
7. realizes that the wait for other paths has timed out, and remove
SYSTEMD_READY, opening it for other layers to grab.

There's a race window between 4 and 6 which systemd cannot handle.
systemd does not "know" that a uevent has been triggered, so even if 3)
or 4) happen before the start of initrd-cleanup.service, 5, 6, 7 may
happen afterwards.

In earlier versions of multipathd and dracut "multipath -u" would
attempt to start multipathd.service via socket activation
(multipathd.socket), which would then stop initrd-cleanup.service, as
it Conflicts: it. Since 0.9.8, multipathd.socket is disabled by
default, and we haven't included it in the initrd any more for a while,
too [*].

It's important to understand that the "cancel" timer+service are just a
safeguard for the case that no new uevent for the device in question
occurs. If we're in the initrd, we can be sure that every uevent is
going to be replayed in the udev coldplug phase.=20

We still need to start the transient timer in the initrd for handling
the case that the device in question is needed for the root file
system, and is not multipathed. But when initrd-cleanup.service is
started, the root device has been discovered already, and we don't need
to bother about the "cancel" timer and service. It doesn't matter if
they run or not.

In the worst case, Antonio's patch will cause these units to be started
after initrd-cleanup.service is started, which may cause an extra "add"
uevent for the block device in question. But that shouldn't be a
problem because such an event is going to be replayed after switching
root, anyway.

IIUC, if the "Conflicts" is removed, the timer unit will continue
running through the switch root phase, and will be taken up by systemd
through serialization=20

[*] upstream dracut version history related to multipathd.socket:

247d2b ("fix(multipathd.service): adapt to upstream multipath-tools
unit file") (dracut 056) added socket dep to the multipathd.service
unit file.
02e646f ("fix(multipath): install multipathd.socket") (dracut 058) made
sure the socket unit file was installed.
297525c ("fix(multipath): remove dependency on multipathd.socket")
(dracut 060) removed both

5e87b68 ("refactor(multipath): remove custom multipathd.service")
(dracut 107) removed the .service file.

> ---
> =C2=A0multipath/multipath.rules.in | 14 ++++++++++++--
> =C2=A01 file changed, 12 insertions(+), 2 deletions(-)
>=20
> diff --git a/multipath/multipath.rules.in
> b/multipath/multipath.rules.in
> index 2ac1972f..7b605dd4 100644
> --- a/multipath/multipath.rules.in
> +++ b/multipath/multipath.rules.in
> @@ -68,8 +68,18 @@ ENV{.SAVED_FM_WAIT_UNTIL}=3D=3D"?*",
> GOTO=3D"pretend_mpath"
> =C2=A0# the --on-active timeout.
> =C2=A0#
> =C2=A0# We must trigger an "add" event because LVM2 will only act on
> those.
> -
> -RUN+=3D"@SYSDIR_BIN@/systemd-run --unit=3Dcancel-multipath-wait-$kernel
> --description 'cancel waiting for multipath siblings of $kernel' --
> no-block --timer-property DefaultDependencies=3Dno --timer-property
> Conflicts=3Dshutdown.target --timer-property Before=3Dshutdown.target --
> timer-property Conflicts=3Dinitrd-cleanup.service --timer-property
> Before=3Dinitrd-cleanup.service --timer-property AccuracySec=3D500ms --
> property DefaultDependencies=3Dno --property Conflicts=3Dshutdown.target
> --property Before=3Dshutdown.target --property Conflicts=3Dinitrd-
> cleanup.service --property Before=3Dinitrd-cleanup.service --on-
> active=3D$env{FIND_MULTIPATHS_WAIT_UNTIL} @SYSDIR_BIN@/udevadm trigger
> --action=3Dadd $sys$devpath"
> +#
> +# These units are ordered Before=3Dinitrd-cleanup.service so that a
> trigger that
> +# is already in flight completes before the initrd switches root.
> They must
> +# *not* use Conflicts=3Dinitrd-cleanup.service: unlike
> shutdown.target, whose
> +# jobs are enqueued irreversibly, initrd-cleanup.service/start is a
> plain job
> +# enqueued by initrd-parse-etc.service via OnSuccess=3D. Starting a
> unit that
> +# conflicts with it therefore cancels that job instead of failing to
> start,
> +# and OnSuccess=3D is never retried, so the initrd would hang forever
> with an
> +# empty job queue. Stopping these units before switch-root is
> already
> +# guaranteed by the isolate to initrd-switch-root.target.
> +
> +RUN+=3D"@SYSDIR_BIN@/systemd-run --unit=3Dcancel-multipath-wait-$kernel
> --description 'cancel waiting for multipath siblings of $kernel' --
> no-block --timer-property DefaultDependencies=3Dno --timer-property
> Conflicts=3Dshutdown.target --timer-property Before=3Dshutdown.target --
> timer-property Before=3Dinitrd-cleanup.service --timer-property
> AccuracySec=3D500ms --property DefaultDependencies=3Dno --property
> Conflicts=3Dshutdown.target --property Before=3Dshutdown.target --
> property Before=3Dinitrd-cleanup.service --on-
> active=3D$env{FIND_MULTIPATHS_WAIT_UNTIL} @SYSDIR_BIN@/udevadm trigger
> --action=3Dadd $sys$devpath"
> =C2=A0
> =C2=A0LABEL=3D"pretend_mpath"
> =C2=A0ENV{DM_MULTIPATH_DEVICE_PATH}=3D"1"

--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Jochen Jaser, Andrew McDonald (HRB 36809,AG N=C3=
=BCrnberg)

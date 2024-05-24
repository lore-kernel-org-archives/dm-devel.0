Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B39A86262
	for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 14:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716560838; cv=none; b=AU27PLH8KlupTnE+Kh0rYBw2DZu92U4Utu6RQSm7WFzgYBE4YqmQH/irIEUH0iSsrBkXfiSO39z2W+yz6Qt1qp1qS5jVPkvgudmaJGWlPD+RYFMQTIIrGBOreAYsJ30PWBRFUt7HsaBzPW+/I0h2fLRfy3pwZdlueivijujSolg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716560838; c=relaxed/simple;
	bh=Lv0D5+AzrgOlZEJ+AQp34s69LuP0rDSt0KPqzJZLcq0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=u4KWu8et65txgOUyvYZbkhIYxjI34gdChyyJo0LawgFYzy+V6NiDDSTXzFvgVP2mhQwd6HEbVIERx4yEcsiPTP05PyMc1G4SOl+l4lxFEfCJMY7ojJgtUlEMdQsDMR3vbU1KipHTnJ0An2lFYhXplM1sH4Ddt4noZmqyaU20BDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HFtLf2wo; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HFtLf2wo"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-52742fdd363so2775059e87.1
        for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 07:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1716560834; x=1717165634; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bAxBEwh+ck8oP+r+emCq97zE9UiIp5eAcH9UC4Cg42k=;
        b=HFtLf2woqO/PD3V0wCbGasuLA5bjZVbkBWHelOuxQ6AkNoRopJMMDOdBenpzyz/r4L
         EYoP/lKvkzXOC9Md+HBXpp8sPHRTwp51JpXkm7treZf7ad5ZYK51OeO9zT1JBa0+76V+
         LJCWJbjnnFo2fqBOgBsI1LcZucyolmxtdnYG9U9jD4EnmX8tGVAtGpT3aecG1wKpdhHR
         k9Fj2CNGVuTBTyQBH0Q7rjC54FWOyBd/gNLzdDHn572EjeX3atosYNO+W4C7tCGHFt1n
         b3q7fo05Z12yGiiUIMPcrgE1MnpDhyOYQqunR5kOX+Im45aMwTvpgaAAe0Nls3zCzCTv
         wZQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716560834; x=1717165634;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bAxBEwh+ck8oP+r+emCq97zE9UiIp5eAcH9UC4Cg42k=;
        b=K/p2lAuoKt7hpf8QvE4IW2nS2lBzSM911+AN+sgYCn1VWt717EwWwQqOjhsXfL3Vv1
         56Rx34tbotueTP2fMYqfj6b3XsTEi3bLpTY5aIoj/OLeIhUgqsLJ96/AWIa/zF7s48YH
         CGK+W6YXMOeN52zEV8eFuW0nyllwi5PI5GazfC6iubU9r0/D9KXXn4MyTt1oopLj77J7
         s8HNs0yXWgZrwH6hDRrP8kXqVD7IZO6DS5AbxguM+jpV9fH/jWy0dAoi1abwwn3vlCtj
         UBHk4c9AE6eqenYn8CaCa1KrXw8UgmyObtL46Pj0xgsDlAmgcMwxsCDJhPxLgguemvzF
         IoSQ==
X-Gm-Message-State: AOJu0YypIJnhjrTVkAPZmA7vUGICYms8aQyk6R0+f12tObISrQczsRbB
	ul2eSqKfAVlGSPNDjHccRNp57ZrAHQsz6C3Q4NxAUe+u0YUR3xaBdA+iBxghAmU=
X-Google-Smtp-Source: AGHT+IFs8eNVOth5IHetrkfUkZ6nlv8y8jNo03pLQ1gjIDkVxZPOYz4YB94xCBb0/fYzgAxAFbFh6A==
X-Received: by 2002:a05:6512:142:b0:51d:15ef:dc10 with SMTP id 2adb3069b0e04-5296528eb2bmr1363598e87.41.1716560833596;
        Fri, 24 May 2024 07:27:13 -0700 (PDT)
Received: from ?IPv6:2003:de:371a:a400:e6fd:936f:426b:4ff8? (p200300de371aa400e6fd936f426b4ff8.dip0.t-ipconnect.de. [2003:de:371a:a400:e6fd:936f:426b:4ff8])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57852388fa9sm1808005a12.25.2024.05.24.07.27.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 07:27:13 -0700 (PDT)
Message-ID: <06dd6590e3fa951137967111af67657fb753694c.camel@suse.com>
Subject: Re: [PATCH 7/7] multipath-tools man pages: Add format wildcard
 descriptions
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>, Nitin Yewale
	 <nyewale@redhat.com>
Date: Fri, 24 May 2024 16:27:12 +0200
In-Reply-To: <20240513173646.94424-8-bmarzins@redhat.com>
References: <20240513173646.94424-1-bmarzins@redhat.com>
	 <20240513173646.94424-8-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2024-05-13 at 13:36 -0400, Benjamin Marzinski wrote:
> Suggested-by: Nitin Yewale <nyewale@redhat.com>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Thanks. This is useful, but I have a few additional suggestions below.

Martin

> ---
> =C2=A0multipathd/multipathd.8.in | 211
> ++++++++++++++++++++++++++++++++++++-
> =C2=A01 file changed, 207 insertions(+), 4 deletions(-)
>=20
> diff --git a/multipathd/multipathd.8.in b/multipathd/multipathd.8.in
> index 32976052..ff150f3d 100644
> --- a/multipathd/multipathd.8.in
> +++ b/multipathd/multipathd.8.in
> @@ -117,7 +117,7 @@ Show the paths that multipathd is monitoring, and
> their state.
> =C2=A0.B list|show paths [raw] format $format
> =C2=A0Show the paths that multipathd is monitoring, using a format string
> with path
> =C2=A0format wildcards. Adding \fIraw\fR will remove the headers and
> alignment
> -padding from the ouput.
> +padding from the output. See "Path format wildcards" below.
> =C2=A0.
> =C2=A0.TP
> =C2=A0.B list|show path $path
> @@ -131,7 +131,8 @@ Show the multipath devices that the multipathd is
> monitoring.
> =C2=A0.B list|show maps|multipaths [raw] format $format
> =C2=A0Show the status of all multipath devices that the multipathd is
> monitoring,
> =C2=A0using a format string with multipath format wildcards. Adding
> \fIraw\fR will
> -remove the headers and alignment padding from the output.
> +remove the headers and alignment padding from the output. See
> "Multipath
> +format wildcards" below.
> =C2=A0.
> =C2=A0.TP
> =C2=A0.B list|show maps|multipaths status
> @@ -162,7 +163,7 @@ Show topology of a single multipath device
> specified by $map, for example
> =C2=A0.B list|show map|multipath $map [raw] format $format.
> =C2=A0Show the status of multipath device $map, using a format string wit=
h
> multipath
> =C2=A0format wildcards. Adding \fIraw\fR will remove the headers and
> alignment
> -padding from the output.
> +padding from the output. See "Multipath format wildcards" below.
> =C2=A0.
> =C2=A0.TP
> =C2=A0.B list|show map|multipath $map json
> @@ -170,7 +171,8 @@ Show information about multipath device $map in
> JSON format.
> =C2=A0.
> =C2=A0.TP
> =C2=A0.B list|show wildcards
> -Show the format wildcards used in interactive commands taking
> $format.
> +Show the format wildcards used in interactive commands taking
> $format. See
> +"Format Wildcards" below.
> =C2=A0.
> =C2=A0.TP
> =C2=A0.B list|show config
> @@ -367,6 +369,207 @@ Stop multipathd.
> =C2=A0.
> =C2=A0.
> =C2=A0.\" ---------------------------------------------------------------=
-
> ------------
> +.SH "Format Wildcards"
> +.\" ----------------------------------------------------------------
> ------------
> +.
> +Multipathd commands that take a $format option require a format
> string. This
> +string controls how a device is printed and should include format
> wildcards.
> +When the devices are printed, these wildcards will be replaced by
> the
> +appropriate device information. The following wildcards are
> supported.
> +.TP
> +.B Multipath format wildcards
> +.RS
> +.TP 12

I can see that you're using the same ordering as in print.c. Perhaps we
should use alphabetical ordering in the man page? Or do you think it
makes more sense to group the wildcards semantically?

Alternatively,=20

> +.B %n
> +The device name.
> +.TP
> +.B %w
> +The device WWID (uuid).
> +.TP
> +.B %d
> +The device sysfs name (dm-<minor_nr>).
> +.TP
> +.B %F
> +The device \fBfailback\fR setting. For deferred failbacks, it will
> either
> +print the configured time if a deferred failback is not in progress,
> or
> +it will show the current progress of a deferred failback.

If you agree to amend 3/7, please don't forget to change this, too.

> +.TP
> +.B %Q
> +The device \fBno_path_retry\fR setting. If no_path_retry is set to a
> +number of retires, it will either print the configured number of

             ^ typo

> checker
> +retries if the device is not in recovery mode, the number of seconds
> until
> +queueing is disabled if the device is queueing in recovery mode, or
> \fIoff\fR
> +if the device has disabled queueing.
> +.TP
> +.B %N
> +The number of active paths for the device.
> +.TP
> +.B %r
> +The device write-protect setting, either \fIro\fR or \fIrw\fR.
> +.TP
> +.B %t
> +The device-mapper state of the device, either \fIsuspend\fR or
> \fIactive\fR.

"suspend" has been chosen to avoid  field overflow, but it sounds
weird.

\fIsuspend\fR if the device is suspended, and \fIactive\fR otherwise ?

> +.TP
> +.B %S
> +The device size.

Explain our "K", "M", "G", "T", "P" suffixes here?

> +.TP
> +.B %f
> +The device table features string.

Suggestion: 'The "features" string of the device-mapper table in the
kernel.'

> +.TP
> +.B %x
> +The number of times the device has entered a state where it will
> fail IO.
> +This is an alias for the \fB%4\fR wildcard.
> +This value can be reset with the '\fIreset map $map stats\fR'
> command.
> +.TP
> +.B %h
> +The device table hardware handler string.
> +.TP
> +.B %A
> +The last action multipathd took on the device. This wildcard is for
> debugging
> +use, as understanding its meaning requires looking at the code.
> +.TP
> +.B %0
> +The number of times a path in the device has failed.
> +This value can be reset with the '\fIreset map $map stats\fR'
> command.
> +.TP
> +.B %1
> +The number of times multipathd has initiated a pathgroup switch for
> the device.
> +This value can be reset with the '\fIreset map $map stats\fR'
> command.
> +.TP
> +.B %2
> +The number of times multipathd has loaded a new table for the
> device.
> +This value can be reset with the '\fIreset map $map stats\fR'
> command.
> +.TP
> +.B %3
> +The approximate number of seconds that multipathd has spent queueing
> with
> +no usable paths. This value can be reset with the '\fIreset map $map
> stats\fR'
> +command.
> +.TP
> +.B %4
> +The number of times the device has entered a state where it will
> fail IO.
> +This is an alias for the \fB%x\fR wildcard.
> +This value can be reset with the '\fIreset map $map stats\fR'
> command.
> +.TP
> +.B %s
> +The vendor/product string for the device.
> +.TP
> +.B %v
> +The array vendor string for the device.
> +.TP
> +.B %p
> +The array product string for the device.
> +.TP
> +.B %e
> +The array firmware revision string for the device.
> +.TP
> +.B %G
> +The foreign library used for the device, or \fB--\fR for native
> device-mapper
> +multipath devices.

Cross-ref to multipath.conf(5) here for an explanation of "foreign"?

> +.TP
> +.B %g
> +Data from vendor specific vpd pages for the device, if any.

"Currently multipathd supports VPD page 0xc0 f=C3=BCr HPE 3PAR / Primera /
Alletra storage arrays."

> +.TP
> +.B %k
> +The actual max_sectors_kb setting for the device (which may be
> different from
> +the configured one).
> +.RE
> +.
> +.
> +.TP
> +.B Path format wildcards
> +.RS
> +.TP 12
> +.B %w
> +The device WWID (uuid).
> +.TP
> +.B %i
> +The device Host:Channel:Id:Lun

"for SCSI devices" (maybe explain what the data means for NVMe).

> +.TP
> +.B %d
> +The device sysfs name.
> +.TP
> +.B %D
> +The device major:minor
> +.TP
> +.B %t
> +The device-mapper state of the device, either \fIactive\fR or
> \fIfailed\fR.
> +.TP
> +.B %o
> +Whether the device is \fIoffline\fR or \fIrunning\fR.

'This shows "offline" if the device's "state" attribute in sysfs
is "offline" (for SCSI) or "dead" (for NMVe). For all other sysfs
states, it shows "running".'

> +.TP
> +.B %T
> +The multipathd path checker state of the device.

Should we list or explain the different states here?

> +.TP
> +.B %s
> +The vendor/product/revision string for the device.
> +.TP
> +.B %c
> +The device's path checker name.

"The name of the device's path checking algorithm"?

> +.TP
> +.B %C
> +The progress towards the next path checker run on the device.

'... in seconds'

> +.TP
> +.B %p
> +The device priority.

> +.TP
> +.B %S
> +The device size.

Format? See above

> +.TP
> +.B %z
> +The device serial number.
> +.TP
> +.B %M
> +The device marginal state, either \fImarginal\fR or \fInormal\fR.
> +.TP
> +.B %m
> +The multipath device that this device is a path of.
> +.TP
> +.B %N
> +The host World Wide Node Name (WWNN) of the device.

... if any
> +.TP
> +.B %n
> +The target World Wide Node Name (WWNN) of the device.

... if any

> +.TP
> +.B %R
> +The host World Wide Port Name (WWPN) of the device.

... if any
> +.TP
> +.B %r
> +The target World Wide Port Name (WWPN) of the device.

... if any

> +.TP
> +.B %a
> +The host adapter name for the device (only SCSI devices).
> +.TP
> +.B %G
> +The foreign library used for the device, or \fB--\fR for paths of
> native
> +device-mapper multipath devices.

See above

> +.TP
> +.B %g
> +Data from vendor specific vpd pages for the device, if any.

See above

> +.TP
> +.B %0
> +The number of times this device has failed.
> +.TP
> +.B %P
> +The device protocol. This output can be used for \fIprotocol\fR
> blacklist
> +entries.

I wouldn't mention the blacklist here. Rather, add a cross-ref to
multipath.conf(5).

> +.TP
> +.B %I
> +The device initialization state. Devices that have been fully
> initialized
> +are shown as \fIok\fR.
> +.TP
> +.B %L
> +The device SCSI LUN ID in hexadecimal format

'This is only meaningful for SCSI devices' ?

> +.TP
> +.B %A
> +The ALUA Target Port Group ID for the device, if applicable.
> +.TP
> +.B %k
> +The actual max_sectors_kb setting for the device (which may be
> different than
> +the configured one).
> +.RE
> +.
> +.
> +.\" ----------------------------------------------------------------
> ------------
> =C2=A0.SH "SYSTEMD INTEGRATION"
> =C2=A0.\" ---------------------------------------------------------------=
-
> ------------
> =C2=A0.


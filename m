Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6927D3FB
	for <dm-devel@lists.linux.dev>; Wed, 29 May 2024 15:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716995730; cv=none; b=ZRqdB/eURxzXqzA3PRZ/CTfz/92sSwJFd8GYAZI0uVZujZm35dTa8SCbqDUT9vxAKD52fIokZP3RqdghyYUOXWAn1+xDAV/fhh6/XtNZn0P25ZVai7dV2ANoJNE7QgxDqXWPZPIaJgHzLl6i3gR1H9xSnPfokHzJNZMxQm/k87o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716995730; c=relaxed/simple;
	bh=MAuOJLPKvmYak+TatpmrUXh22Kg3ycwAHQ+zt8WDJnU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=QaBUWzDLvjjB5cOjD7AF1rPHCTcfFTFjepCATpk9NNraFbtvsa/90BKijC00A/WV7mxXLbcqxkehnjzJoxdQu/nLi2itpcHYOmQe7+d36KDL0CcSW0/6qJyrfyoUUJfVZJqe6wfUW3kJ9+MYTwMI3FwOvZYAtn0cdPPzjEIVYjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D26oAoTe; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D26oAoTe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716995727;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3zc1weHQ56LqncLi4ZPfHyRRu6IREp1qvvfLDYICQTs=;
	b=D26oAoTeEWgzMn53Lex1SZExAf7mAmGd+KBvUqNlrPGfzZWg5/08ktZUvDUM8RfwUzu890
	oSoxiQSAnTxkqwvFl3RxDW30dZ5Aj8k6RaYpAHcgDP6/IFCf1gW0pQmZy3GZrA+X4bBYIi
	yaEB2E5n0HhUJGez6E3ifNvaoLfAM9g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-scuyrp6TPyWOtlSQ76fFaQ-1; Wed, 29 May 2024 11:15:24 -0400
X-MC-Unique: scuyrp6TPyWOtlSQ76fFaQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F343C8058D1;
	Wed, 29 May 2024 15:15:23 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E6D5A2026D68;
	Wed, 29 May 2024 15:15:23 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 44TFFNGN359520
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 29 May 2024 11:15:23 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 44TFFNrk359519;
	Wed, 29 May 2024 11:15:23 -0400
Date: Wed, 29 May 2024 11:15:23 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>,
        Nitin Yewale <nyewale@redhat.com>
Subject: Re: [PATCH 7/7] multipath-tools man pages: Add format wildcard
 descriptions
Message-ID: <ZldGi_fezOSdBwdk@redhat.com>
References: <20240513173646.94424-1-bmarzins@redhat.com>
 <20240513173646.94424-8-bmarzins@redhat.com>
 <06dd6590e3fa951137967111af67657fb753694c.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <06dd6590e3fa951137967111af67657fb753694c.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, May 24, 2024 at 04:27:12PM +0200, Martin Wilck wrote:
> On Mon, 2024-05-13 at 13:36 -0400, Benjamin Marzinski wrote:
> > Suggested-by: Nitin Yewale <nyewale@redhat.com>
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> Thanks. This is useful, but I have a few additional suggestions below.

They seem reasonable. I'll update this.

-Ben

> 
> Martin
> 
> > ---
> >  multipathd/multipathd.8.in | 211
> > ++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 207 insertions(+), 4 deletions(-)
> > 
> > diff --git a/multipathd/multipathd.8.in b/multipathd/multipathd.8.in
> > index 32976052..ff150f3d 100644
> > --- a/multipathd/multipathd.8.in
> > +++ b/multipathd/multipathd.8.in
> > @@ -117,7 +117,7 @@ Show the paths that multipathd is monitoring, and
> > their state.
> >  .B list|show paths [raw] format $format
> >  Show the paths that multipathd is monitoring, using a format string
> > with path
> >  format wildcards. Adding \fIraw\fR will remove the headers and
> > alignment
> > -padding from the ouput.
> > +padding from the output. See "Path format wildcards" below.
> >  .
> >  .TP
> >  .B list|show path $path
> > @@ -131,7 +131,8 @@ Show the multipath devices that the multipathd is
> > monitoring.
> >  .B list|show maps|multipaths [raw] format $format
> >  Show the status of all multipath devices that the multipathd is
> > monitoring,
> >  using a format string with multipath format wildcards. Adding
> > \fIraw\fR will
> > -remove the headers and alignment padding from the output.
> > +remove the headers and alignment padding from the output. See
> > "Multipath
> > +format wildcards" below.
> >  .
> >  .TP
> >  .B list|show maps|multipaths status
> > @@ -162,7 +163,7 @@ Show topology of a single multipath device
> > specified by $map, for example
> >  .B list|show map|multipath $map [raw] format $format.
> >  Show the status of multipath device $map, using a format string with
> > multipath
> >  format wildcards. Adding \fIraw\fR will remove the headers and
> > alignment
> > -padding from the output.
> > +padding from the output. See "Multipath format wildcards" below.
> >  .
> >  .TP
> >  .B list|show map|multipath $map json
> > @@ -170,7 +171,8 @@ Show information about multipath device $map in
> > JSON format.
> >  .
> >  .TP
> >  .B list|show wildcards
> > -Show the format wildcards used in interactive commands taking
> > $format.
> > +Show the format wildcards used in interactive commands taking
> > $format. See
> > +"Format Wildcards" below.
> >  .
> >  .TP
> >  .B list|show config
> > @@ -367,6 +369,207 @@ Stop multipathd.
> >  .
> >  .
> >  .\" ----------------------------------------------------------------
> > ------------
> > +.SH "Format Wildcards"
> > +.\" ----------------------------------------------------------------
> > ------------
> > +.
> > +Multipathd commands that take a $format option require a format
> > string. This
> > +string controls how a device is printed and should include format
> > wildcards.
> > +When the devices are printed, these wildcards will be replaced by
> > the
> > +appropriate device information. The following wildcards are
> > supported.
> > +.TP
> > +.B Multipath format wildcards
> > +.RS
> > +.TP 12
> 
> I can see that you're using the same ordering as in print.c. Perhaps we
> should use alphabetical ordering in the man page? Or do you think it
> makes more sense to group the wildcards semantically?
> 
> Alternatively, 
> 
> > +.B %n
> > +The device name.
> > +.TP
> > +.B %w
> > +The device WWID (uuid).
> > +.TP
> > +.B %d
> > +The device sysfs name (dm-<minor_nr>).
> > +.TP
> > +.B %F
> > +The device \fBfailback\fR setting. For deferred failbacks, it will
> > either
> > +print the configured time if a deferred failback is not in progress,
> > or
> > +it will show the current progress of a deferred failback.
> 
> If you agree to amend 3/7, please don't forget to change this, too.
> 
> > +.TP
> > +.B %Q
> > +The device \fBno_path_retry\fR setting. If no_path_retry is set to a
> > +number of retires, it will either print the configured number of
> 
>              ^ typo
> 
> > checker
> > +retries if the device is not in recovery mode, the number of seconds
> > until
> > +queueing is disabled if the device is queueing in recovery mode, or
> > \fIoff\fR
> > +if the device has disabled queueing.
> > +.TP
> > +.B %N
> > +The number of active paths for the device.
> > +.TP
> > +.B %r
> > +The device write-protect setting, either \fIro\fR or \fIrw\fR.
> > +.TP
> > +.B %t
> > +The device-mapper state of the device, either \fIsuspend\fR or
> > \fIactive\fR.
> 
> "suspend" has been chosen to avoid  field overflow, but it sounds
> weird.
> 
> \fIsuspend\fR if the device is suspended, and \fIactive\fR otherwise ?
> 
> > +.TP
> > +.B %S
> > +The device size.
> 
> Explain our "K", "M", "G", "T", "P" suffixes here?
> 
> > +.TP
> > +.B %f
> > +The device table features string.
> 
> Suggestion: 'The "features" string of the device-mapper table in the
> kernel.'
> 
> > +.TP
> > +.B %x
> > +The number of times the device has entered a state where it will
> > fail IO.
> > +This is an alias for the \fB%4\fR wildcard.
> > +This value can be reset with the '\fIreset map $map stats\fR'
> > command.
> > +.TP
> > +.B %h
> > +The device table hardware handler string.
> > +.TP
> > +.B %A
> > +The last action multipathd took on the device. This wildcard is for
> > debugging
> > +use, as understanding its meaning requires looking at the code.
> > +.TP
> > +.B %0
> > +The number of times a path in the device has failed.
> > +This value can be reset with the '\fIreset map $map stats\fR'
> > command.
> > +.TP
> > +.B %1
> > +The number of times multipathd has initiated a pathgroup switch for
> > the device.
> > +This value can be reset with the '\fIreset map $map stats\fR'
> > command.
> > +.TP
> > +.B %2
> > +The number of times multipathd has loaded a new table for the
> > device.
> > +This value can be reset with the '\fIreset map $map stats\fR'
> > command.
> > +.TP
> > +.B %3
> > +The approximate number of seconds that multipathd has spent queueing
> > with
> > +no usable paths. This value can be reset with the '\fIreset map $map
> > stats\fR'
> > +command.
> > +.TP
> > +.B %4
> > +The number of times the device has entered a state where it will
> > fail IO.
> > +This is an alias for the \fB%x\fR wildcard.
> > +This value can be reset with the '\fIreset map $map stats\fR'
> > command.
> > +.TP
> > +.B %s
> > +The vendor/product string for the device.
> > +.TP
> > +.B %v
> > +The array vendor string for the device.
> > +.TP
> > +.B %p
> > +The array product string for the device.
> > +.TP
> > +.B %e
> > +The array firmware revision string for the device.
> > +.TP
> > +.B %G
> > +The foreign library used for the device, or \fB--\fR for native
> > device-mapper
> > +multipath devices.
> 
> Cross-ref to multipath.conf(5) here for an explanation of "foreign"?
> 
> > +.TP
> > +.B %g
> > +Data from vendor specific vpd pages for the device, if any.
> 
> "Currently multipathd supports VPD page 0xc0 für HPE 3PAR / Primera /
> Alletra storage arrays."
> 
> > +.TP
> > +.B %k
> > +The actual max_sectors_kb setting for the device (which may be
> > different from
> > +the configured one).
> > +.RE
> > +.
> > +.
> > +.TP
> > +.B Path format wildcards
> > +.RS
> > +.TP 12
> > +.B %w
> > +The device WWID (uuid).
> > +.TP
> > +.B %i
> > +The device Host:Channel:Id:Lun
> 
> "for SCSI devices" (maybe explain what the data means for NVMe).
> 
> > +.TP
> > +.B %d
> > +The device sysfs name.
> > +.TP
> > +.B %D
> > +The device major:minor
> > +.TP
> > +.B %t
> > +The device-mapper state of the device, either \fIactive\fR or
> > \fIfailed\fR.
> > +.TP
> > +.B %o
> > +Whether the device is \fIoffline\fR or \fIrunning\fR.
> 
> 'This shows "offline" if the device's "state" attribute in sysfs
> is "offline" (for SCSI) or "dead" (for NMVe). For all other sysfs
> states, it shows "running".'
> 
> > +.TP
> > +.B %T
> > +The multipathd path checker state of the device.
> 
> Should we list or explain the different states here?
> 
> > +.TP
> > +.B %s
> > +The vendor/product/revision string for the device.
> > +.TP
> > +.B %c
> > +The device's path checker name.
> 
> "The name of the device's path checking algorithm"?
> 
> > +.TP
> > +.B %C
> > +The progress towards the next path checker run on the device.
> 
> '... in seconds'
> 
> > +.TP
> > +.B %p
> > +The device priority.
> 
> > +.TP
> > +.B %S
> > +The device size.
> 
> Format? See above
> 
> > +.TP
> > +.B %z
> > +The device serial number.
> > +.TP
> > +.B %M
> > +The device marginal state, either \fImarginal\fR or \fInormal\fR.
> > +.TP
> > +.B %m
> > +The multipath device that this device is a path of.
> > +.TP
> > +.B %N
> > +The host World Wide Node Name (WWNN) of the device.
> 
> ... if any
> > +.TP
> > +.B %n
> > +The target World Wide Node Name (WWNN) of the device.
> 
> ... if any
> 
> > +.TP
> > +.B %R
> > +The host World Wide Port Name (WWPN) of the device.
> 
> ... if any
> > +.TP
> > +.B %r
> > +The target World Wide Port Name (WWPN) of the device.
> 
> ... if any
> 
> > +.TP
> > +.B %a
> > +The host adapter name for the device (only SCSI devices).
> > +.TP
> > +.B %G
> > +The foreign library used for the device, or \fB--\fR for paths of
> > native
> > +device-mapper multipath devices.
> 
> See above
> 
> > +.TP
> > +.B %g
> > +Data from vendor specific vpd pages for the device, if any.
> 
> See above
> 
> > +.TP
> > +.B %0
> > +The number of times this device has failed.
> > +.TP
> > +.B %P
> > +The device protocol. This output can be used for \fIprotocol\fR
> > blacklist
> > +entries.
> 
> I wouldn't mention the blacklist here. Rather, add a cross-ref to
> multipath.conf(5).
> 
> > +.TP
> > +.B %I
> > +The device initialization state. Devices that have been fully
> > initialized
> > +are shown as \fIok\fR.
> > +.TP
> > +.B %L
> > +The device SCSI LUN ID in hexadecimal format
> 
> 'This is only meaningful for SCSI devices' ?
> 
> > +.TP
> > +.B %A
> > +The ALUA Target Port Group ID for the device, if applicable.
> > +.TP
> > +.B %k
> > +The actual max_sectors_kb setting for the device (which may be
> > different than
> > +the configured one).
> > +.RE
> > +.
> > +.
> > +.\" ----------------------------------------------------------------
> > ------------
> >  .SH "SYSTEMD INTEGRATION"
> >  .\" ----------------------------------------------------------------
> > ------------
> >  .


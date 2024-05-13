Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D412741C69
	for <dm-devel@lists.linux.dev>; Mon, 13 May 2024 19:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715627643; cv=none; b=JBeBTzZfs7FlOleAkft4g1VBMMkqBoJFa4trSUqHlLaHcSAG+m+HAH9dRP02GncuUxi1a0nIyPSmHf6fbXimfmFcsFCWv/oY6PkZQIEQ+UClJDFFQa5eTeivmaW48mWZ2GL/aCRCuNGtA6RBmIlnqM5zyA++rUv7ysTMmWf9CTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715627643; c=relaxed/simple;
	bh=J8uHjjAiHf2v7kkLFF3v0eG+HLiB5rZ+l5q8xgUXxI0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=O6lncKhYIix/1ZprA5hYfq65su7tQcL86eqhp7D2YW9NGoz+QahV0Os5+MEoizzg1vz8etZ5SxIHfWq2B9nEJjMCZx3HsVVEkQ6XT5SivnGC2SHVN4bUomi/OUewGndyTMR+49QKRv2mFF67ZKYjMrwPfSMKvt9K0083nPOVLwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NCb/xbPx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NCb/xbPx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715627640;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ulk0A5cR5wltU2X6ZvqKuKUvVxnP7aS9atl7TIBPUxg=;
	b=NCb/xbPx4HkBhM0JLN6vcd/wETK3zJz0eZh+ReIabXrH1XyskfVx+h9CEnJ2oNPaziHpEs
	lWe/Iy3oxXHZz6PWuCh+4GeLHO9lwkTxoyAUeE1nDdghjbgMJkvu4xwOm0GDM44ySnTMmb
	lJR1MSR7GFhPDsyfh+RaJmQgYbP4Zn8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-680-HtSmvD6DNyuST6acjxQWZQ-1; Mon,
 13 May 2024 15:11:08 -0400
X-MC-Unique: HtSmvD6DNyuST6acjxQWZQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 02F1229AB403;
	Mon, 13 May 2024 19:11:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EC83B3C27;
	Mon, 13 May 2024 19:11:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 44DJB7DS095617
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 13 May 2024 15:11:07 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 44DJB73C095616;
	Mon, 13 May 2024 15:11:07 -0400
Date: Mon, 13 May 2024 15:11:07 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>,
        Nitin Yewale <nyewale@redhat.com>
Subject: Re: [PATCH 7/7] multipath-tools man pages: Add format wildcard
 descriptions
Message-ID: <ZkJlywJBcXQku0a8@redhat.com>
References: <20240513173646.94424-1-bmarzins@redhat.com>
 <20240513173646.94424-8-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240513173646.94424-8-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 13, 2024 at 01:36:46PM -0400, Benjamin Marzinski wrote:
> Suggested-by: Nitin Yewale <nyewale@redhat.com>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Oops. I forgot to update the man page date. Martin, either I can send a
new patch or you can feel free to update the date when you apply this
one, whichever you'd prefer.

-Ben


> ---
>  multipathd/multipathd.8.in | 211 ++++++++++++++++++++++++++++++++++++-
>  1 file changed, 207 insertions(+), 4 deletions(-)
> 
> diff --git a/multipathd/multipathd.8.in b/multipathd/multipathd.8.in
> index 32976052..ff150f3d 100644
> --- a/multipathd/multipathd.8.in
> +++ b/multipathd/multipathd.8.in
> @@ -117,7 +117,7 @@ Show the paths that multipathd is monitoring, and their state.
>  .B list|show paths [raw] format $format
>  Show the paths that multipathd is monitoring, using a format string with path
>  format wildcards. Adding \fIraw\fR will remove the headers and alignment
> -padding from the ouput.
> +padding from the output. See "Path format wildcards" below.
>  .
>  .TP
>  .B list|show path $path
> @@ -131,7 +131,8 @@ Show the multipath devices that the multipathd is monitoring.
>  .B list|show maps|multipaths [raw] format $format
>  Show the status of all multipath devices that the multipathd is monitoring,
>  using a format string with multipath format wildcards. Adding \fIraw\fR will
> -remove the headers and alignment padding from the output.
> +remove the headers and alignment padding from the output. See "Multipath
> +format wildcards" below.
>  .
>  .TP
>  .B list|show maps|multipaths status
> @@ -162,7 +163,7 @@ Show topology of a single multipath device specified by $map, for example
>  .B list|show map|multipath $map [raw] format $format.
>  Show the status of multipath device $map, using a format string with multipath
>  format wildcards. Adding \fIraw\fR will remove the headers and alignment
> -padding from the output.
> +padding from the output. See "Multipath format wildcards" below.
>  .
>  .TP
>  .B list|show map|multipath $map json
> @@ -170,7 +171,8 @@ Show information about multipath device $map in JSON format.
>  .
>  .TP
>  .B list|show wildcards
> -Show the format wildcards used in interactive commands taking $format.
> +Show the format wildcards used in interactive commands taking $format. See
> +"Format Wildcards" below.
>  .
>  .TP
>  .B list|show config
> @@ -367,6 +369,207 @@ Stop multipathd.
>  .
>  .
>  .\" ----------------------------------------------------------------------------
> +.SH "Format Wildcards"
> +.\" ----------------------------------------------------------------------------
> +.
> +Multipathd commands that take a $format option require a format string. This
> +string controls how a device is printed and should include format wildcards.
> +When the devices are printed, these wildcards will be replaced by the
> +appropriate device information. The following wildcards are supported.
> +.TP
> +.B Multipath format wildcards
> +.RS
> +.TP 12
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
> +The device \fBfailback\fR setting. For deferred failbacks, it will either
> +print the configured time if a deferred failback is not in progress, or
> +it will show the current progress of a deferred failback.
> +.TP
> +.B %Q
> +The device \fBno_path_retry\fR setting. If no_path_retry is set to a
> +number of retires, it will either print the configured number of checker
> +retries if the device is not in recovery mode, the number of seconds until
> +queueing is disabled if the device is queueing in recovery mode, or \fIoff\fR
> +if the device has disabled queueing.
> +.TP
> +.B %N
> +The number of active paths for the device.
> +.TP
> +.B %r
> +The device write-protect setting, either \fIro\fR or \fIrw\fR.
> +.TP
> +.B %t
> +The device-mapper state of the device, either \fIsuspend\fR or \fIactive\fR.
> +.TP
> +.B %S
> +The device size.
> +.TP
> +.B %f
> +The device table features string.
> +.TP
> +.B %x
> +The number of times the device has entered a state where it will fail IO.
> +This is an alias for the \fB%4\fR wildcard.
> +This value can be reset with the '\fIreset map $map stats\fR' command.
> +.TP
> +.B %h
> +The device table hardware handler string.
> +.TP
> +.B %A
> +The last action multipathd took on the device. This wildcard is for debugging
> +use, as understanding its meaning requires looking at the code.
> +.TP
> +.B %0
> +The number of times a path in the device has failed.
> +This value can be reset with the '\fIreset map $map stats\fR' command.
> +.TP
> +.B %1
> +The number of times multipathd has initiated a pathgroup switch for the device.
> +This value can be reset with the '\fIreset map $map stats\fR' command.
> +.TP
> +.B %2
> +The number of times multipathd has loaded a new table for the device.
> +This value can be reset with the '\fIreset map $map stats\fR' command.
> +.TP
> +.B %3
> +The approximate number of seconds that multipathd has spent queueing with
> +no usable paths. This value can be reset with the '\fIreset map $map stats\fR'
> +command.
> +.TP
> +.B %4
> +The number of times the device has entered a state where it will fail IO.
> +This is an alias for the \fB%x\fR wildcard.
> +This value can be reset with the '\fIreset map $map stats\fR' command.
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
> +The foreign library used for the device, or \fB--\fR for native device-mapper
> +multipath devices.
> +.TP
> +.B %g
> +Data from vendor specific vpd pages for the device, if any.
> +.TP
> +.B %k
> +The actual max_sectors_kb setting for the device (which may be different from
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
> +.TP
> +.B %d
> +The device sysfs name.
> +.TP
> +.B %D
> +The device major:minor
> +.TP
> +.B %t
> +The device-mapper state of the device, either \fIactive\fR or \fIfailed\fR.
> +.TP
> +.B %o
> +Whether the device is \fIoffline\fR or \fIrunning\fR.
> +.TP
> +.B %T
> +The multipathd path checker state of the device.
> +.TP
> +.B %s
> +The vendor/product/revision string for the device.
> +.TP
> +.B %c
> +The device's path checker name.
> +.TP
> +.B %C
> +The progress towards the next path checker run on the device.
> +.TP
> +.B %p
> +The device priority.
> +.TP
> +.B %S
> +The device size.
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
> +.TP
> +.B %n
> +The target World Wide Node Name (WWNN) of the device.
> +.TP
> +.B %R
> +The host World Wide Port Name (WWPN) of the device.
> +.TP
> +.B %r
> +The target World Wide Port Name (WWPN) of the device.
> +.TP
> +.B %a
> +The host adapter name for the device (only SCSI devices).
> +.TP
> +.B %G
> +The foreign library used for the device, or \fB--\fR for paths of native
> +device-mapper multipath devices.
> +.TP
> +.B %g
> +Data from vendor specific vpd pages for the device, if any.
> +.TP
> +.B %0
> +The number of times this device has failed.
> +.TP
> +.B %P
> +The device protocol. This output can be used for \fIprotocol\fR blacklist
> +entries.
> +.TP
> +.B %I
> +The device initialization state. Devices that have been fully initialized
> +are shown as \fIok\fR.
> +.TP
> +.B %L
> +The device SCSI LUN ID in hexadecimal format
> +.TP
> +.B %A
> +The ALUA Target Port Group ID for the device, if applicable.
> +.TP
> +.B %k
> +The actual max_sectors_kb setting for the device (which may be different than
> +the configured one).
> +.RE
> +.
> +.
> +.\" ----------------------------------------------------------------------------
>  .SH "SYSTEMD INTEGRATION"
>  .\" ----------------------------------------------------------------------------
>  .
> -- 
> 2.45.0
> 


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091CB2D058
	for <dm-devel@lists.linux.dev>; Mon, 13 May 2024 17:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715621814; cv=none; b=Da9wlrXr8YdOg+o7rXj3trIss0c+bNOOEiuf+8yty8XkN+Dh+YE/xmoUsSC8Mn9JycJ7Y+3/g7zTNpI/zJ7hA10Wbu1ahbKqjzg4M0RBPvdeq0qRWZbLOPzq8j8X/1vrMLjbYbu2bEit08TV4QdFR/rGY7o6yZpVxqUhX94i4g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715621814; c=relaxed/simple;
	bh=QQrJAwm15f3jXW0J+jQ75Uwljj2DPtmT7hvtpJT3eKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kUhTn4i9QwW8GG3b7Oz6bBlUaY8okmPnfgxWxfGvMbqysT4Q8mZ5FIGdDVT9g7lLarGJ9pli/BhocTm7RTPQv2gL3CeJ9MalTCOVZHY7AoLketOEeROHSwG360pOg1JJRIsVqk0tkTX7sMlHRqEsJqOfafYXb6+CBpE/bUhj9K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q1A65SQ7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q1A65SQ7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715621811;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l1dS2HujO1J4f+UTaB+Go3TPIaorbbi8ZZEVLw0wQ6U=;
	b=Q1A65SQ7Kt6qjk1PDSo+4VO07dlVfjDcQvdIInKxm/QxMUOtDxTmDAFd+E70dYkN6Q16O2
	C9j8PGUXbnEu/ZkZE/OMiziBMkz38N9+oQh/7bI3Ypzh9i75xd24Id+1Rb5oc68SG6Izaj
	NvgSHYTJ04LLkKXNc3wYoCauwEov7k0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-369-0Z0v5kNSPXyXE0WhP9jX2Q-1; Mon, 13 May 2024 13:36:48 -0400
X-MC-Unique: 0Z0v5kNSPXyXE0WhP9jX2Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 517688016E9;
	Mon, 13 May 2024 17:36:48 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4533D400F390;
	Mon, 13 May 2024 17:36:48 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 44DHamMv094468
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 13 May 2024 13:36:48 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 44DHamOF094467;
	Mon, 13 May 2024 13:36:48 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>,
        Nitin Yewale <nyewale@redhat.com>
Subject: [PATCH 7/7] multipath-tools man pages: Add format wildcard descriptions
Date: Mon, 13 May 2024 13:36:46 -0400
Message-ID: <20240513173646.94424-8-bmarzins@redhat.com>
In-Reply-To: <20240513173646.94424-1-bmarzins@redhat.com>
References: <20240513173646.94424-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Suggested-by: Nitin Yewale <nyewale@redhat.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/multipathd.8.in | 211 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 207 insertions(+), 4 deletions(-)

diff --git a/multipathd/multipathd.8.in b/multipathd/multipathd.8.in
index 32976052..ff150f3d 100644
--- a/multipathd/multipathd.8.in
+++ b/multipathd/multipathd.8.in
@@ -117,7 +117,7 @@ Show the paths that multipathd is monitoring, and their state.
 .B list|show paths [raw] format $format
 Show the paths that multipathd is monitoring, using a format string with path
 format wildcards. Adding \fIraw\fR will remove the headers and alignment
-padding from the ouput.
+padding from the output. See "Path format wildcards" below.
 .
 .TP
 .B list|show path $path
@@ -131,7 +131,8 @@ Show the multipath devices that the multipathd is monitoring.
 .B list|show maps|multipaths [raw] format $format
 Show the status of all multipath devices that the multipathd is monitoring,
 using a format string with multipath format wildcards. Adding \fIraw\fR will
-remove the headers and alignment padding from the output.
+remove the headers and alignment padding from the output. See "Multipath
+format wildcards" below.
 .
 .TP
 .B list|show maps|multipaths status
@@ -162,7 +163,7 @@ Show topology of a single multipath device specified by $map, for example
 .B list|show map|multipath $map [raw] format $format.
 Show the status of multipath device $map, using a format string with multipath
 format wildcards. Adding \fIraw\fR will remove the headers and alignment
-padding from the output.
+padding from the output. See "Multipath format wildcards" below.
 .
 .TP
 .B list|show map|multipath $map json
@@ -170,7 +171,8 @@ Show information about multipath device $map in JSON format.
 .
 .TP
 .B list|show wildcards
-Show the format wildcards used in interactive commands taking $format.
+Show the format wildcards used in interactive commands taking $format. See
+"Format Wildcards" below.
 .
 .TP
 .B list|show config
@@ -367,6 +369,207 @@ Stop multipathd.
 .
 .
 .\" ----------------------------------------------------------------------------
+.SH "Format Wildcards"
+.\" ----------------------------------------------------------------------------
+.
+Multipathd commands that take a $format option require a format string. This
+string controls how a device is printed and should include format wildcards.
+When the devices are printed, these wildcards will be replaced by the
+appropriate device information. The following wildcards are supported.
+.TP
+.B Multipath format wildcards
+.RS
+.TP 12
+.B %n
+The device name.
+.TP
+.B %w
+The device WWID (uuid).
+.TP
+.B %d
+The device sysfs name (dm-<minor_nr>).
+.TP
+.B %F
+The device \fBfailback\fR setting. For deferred failbacks, it will either
+print the configured time if a deferred failback is not in progress, or
+it will show the current progress of a deferred failback.
+.TP
+.B %Q
+The device \fBno_path_retry\fR setting. If no_path_retry is set to a
+number of retires, it will either print the configured number of checker
+retries if the device is not in recovery mode, the number of seconds until
+queueing is disabled if the device is queueing in recovery mode, or \fIoff\fR
+if the device has disabled queueing.
+.TP
+.B %N
+The number of active paths for the device.
+.TP
+.B %r
+The device write-protect setting, either \fIro\fR or \fIrw\fR.
+.TP
+.B %t
+The device-mapper state of the device, either \fIsuspend\fR or \fIactive\fR.
+.TP
+.B %S
+The device size.
+.TP
+.B %f
+The device table features string.
+.TP
+.B %x
+The number of times the device has entered a state where it will fail IO.
+This is an alias for the \fB%4\fR wildcard.
+This value can be reset with the '\fIreset map $map stats\fR' command.
+.TP
+.B %h
+The device table hardware handler string.
+.TP
+.B %A
+The last action multipathd took on the device. This wildcard is for debugging
+use, as understanding its meaning requires looking at the code.
+.TP
+.B %0
+The number of times a path in the device has failed.
+This value can be reset with the '\fIreset map $map stats\fR' command.
+.TP
+.B %1
+The number of times multipathd has initiated a pathgroup switch for the device.
+This value can be reset with the '\fIreset map $map stats\fR' command.
+.TP
+.B %2
+The number of times multipathd has loaded a new table for the device.
+This value can be reset with the '\fIreset map $map stats\fR' command.
+.TP
+.B %3
+The approximate number of seconds that multipathd has spent queueing with
+no usable paths. This value can be reset with the '\fIreset map $map stats\fR'
+command.
+.TP
+.B %4
+The number of times the device has entered a state where it will fail IO.
+This is an alias for the \fB%x\fR wildcard.
+This value can be reset with the '\fIreset map $map stats\fR' command.
+.TP
+.B %s
+The vendor/product string for the device.
+.TP
+.B %v
+The array vendor string for the device.
+.TP
+.B %p
+The array product string for the device.
+.TP
+.B %e
+The array firmware revision string for the device.
+.TP
+.B %G
+The foreign library used for the device, or \fB--\fR for native device-mapper
+multipath devices.
+.TP
+.B %g
+Data from vendor specific vpd pages for the device, if any.
+.TP
+.B %k
+The actual max_sectors_kb setting for the device (which may be different from
+the configured one).
+.RE
+.
+.
+.TP
+.B Path format wildcards
+.RS
+.TP 12
+.B %w
+The device WWID (uuid).
+.TP
+.B %i
+The device Host:Channel:Id:Lun
+.TP
+.B %d
+The device sysfs name.
+.TP
+.B %D
+The device major:minor
+.TP
+.B %t
+The device-mapper state of the device, either \fIactive\fR or \fIfailed\fR.
+.TP
+.B %o
+Whether the device is \fIoffline\fR or \fIrunning\fR.
+.TP
+.B %T
+The multipathd path checker state of the device.
+.TP
+.B %s
+The vendor/product/revision string for the device.
+.TP
+.B %c
+The device's path checker name.
+.TP
+.B %C
+The progress towards the next path checker run on the device.
+.TP
+.B %p
+The device priority.
+.TP
+.B %S
+The device size.
+.TP
+.B %z
+The device serial number.
+.TP
+.B %M
+The device marginal state, either \fImarginal\fR or \fInormal\fR.
+.TP
+.B %m
+The multipath device that this device is a path of.
+.TP
+.B %N
+The host World Wide Node Name (WWNN) of the device.
+.TP
+.B %n
+The target World Wide Node Name (WWNN) of the device.
+.TP
+.B %R
+The host World Wide Port Name (WWPN) of the device.
+.TP
+.B %r
+The target World Wide Port Name (WWPN) of the device.
+.TP
+.B %a
+The host adapter name for the device (only SCSI devices).
+.TP
+.B %G
+The foreign library used for the device, or \fB--\fR for paths of native
+device-mapper multipath devices.
+.TP
+.B %g
+Data from vendor specific vpd pages for the device, if any.
+.TP
+.B %0
+The number of times this device has failed.
+.TP
+.B %P
+The device protocol. This output can be used for \fIprotocol\fR blacklist
+entries.
+.TP
+.B %I
+The device initialization state. Devices that have been fully initialized
+are shown as \fIok\fR.
+.TP
+.B %L
+The device SCSI LUN ID in hexadecimal format
+.TP
+.B %A
+The ALUA Target Port Group ID for the device, if applicable.
+.TP
+.B %k
+The actual max_sectors_kb setting for the device (which may be different than
+the configured one).
+.RE
+.
+.
+.\" ----------------------------------------------------------------------------
 .SH "SYSTEMD INTEGRATION"
 .\" ----------------------------------------------------------------------------
 .
-- 
2.45.0


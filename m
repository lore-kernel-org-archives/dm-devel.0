Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1335544C8F
	for <dm-devel@lists.linux.dev>; Thu, 30 May 2024 16:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717088110; cv=none; b=aEiJ/ZCZIW3tPT2l8W2lnEKupTI8JUWLarsH6EEK7UkCSyisZ4PT1yEgoVz8f/PlLaBt/sTbNbqrePQ7N39wpFY3LQdlJeoLWgHBoicmFjsEfSB7mtqQ7hS22f9sHNaABnN2def6EB/bI8cgGlWCaIUYwz8wBkIwV2O//p+PUcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717088110; c=relaxed/simple;
	bh=Uny8hd+0tKMyalmkqIs+eAqgwtZF3mIl9Enr1Dl+Lao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JFpKWNPLf2f5rjA9ZVnC5AlIBuoGMmeiTrM8l0t7cMa0cI0C3WOxGsJrTX5trofNtIZCByH6SVWPRYSjbbZGzjmRZEcKIF4Y/HpdgNy09EP8e/dQlpE5qX5WiAYsgKmg50C9y/sZc2ZYWNso6YeNezJsUOCmdFf5h8nh6Bm1Qiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YuqCmSTG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YuqCmSTG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717088107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nK9PSwSlfUG9CqLMe8hBM1IlGxlbch8UFhFBJ7we/Ik=;
	b=YuqCmSTGLjcf0Zpe1m0mmiTJAPKdpIRXc/lliUKL/p94OUWGuDne8gtoZW5dede8RcN5gV
	V4UNRseHJgB6lRJcvk7n1eM+PN8mdLxHVJnmIV19mYkrcIvwx2G+oycknHUXKMlBwZZZFJ
	nVuDykiSTRXSVDuE1d7r8bZv36Tl5+c=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-607-pxHLPNJlPbmXI_5r1Sp95Q-1; Thu,
 30 May 2024 12:55:03 -0400
X-MC-Unique: pxHLPNJlPbmXI_5r1Sp95Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 17BDE1C0512A;
	Thu, 30 May 2024 16:55:03 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 10C49492BC6;
	Thu, 30 May 2024 16:55:03 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 44UGt2is397053
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 30 May 2024 12:55:02 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 44UGt2pm397052;
	Thu, 30 May 2024 12:55:02 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>,
        Nitin Yewale <nyewale@redhat.com>
Subject: [PATCH v2 7/7] multipath-tools man pages: Add format wildcard descriptions
Date: Thu, 30 May 2024 12:55:00 -0400
Message-ID: <20240530165500.397009-8-bmarzins@redhat.com>
In-Reply-To: <20240530165500.397009-1-bmarzins@redhat.com>
References: <20240530165500.397009-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Suggested-by: Nitin Yewale <nyewale@redhat.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/multipathd.8.in | 260 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 255 insertions(+), 5 deletions(-)

diff --git a/multipathd/multipathd.8.in b/multipathd/multipathd.8.in
index 32976052..4bcf0572 100644
--- a/multipathd/multipathd.8.in
+++ b/multipathd/multipathd.8.in
@@ -6,7 +6,7 @@
 .\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
 .
-.TH MULTIPATHD 8 2023-12-19 Linux
+.TH MULTIPATHD 8 2024-05-29 Linux
 .
 .
 .\" ----------------------------------------------------------------------------
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
@@ -367,6 +369,254 @@ Stop multipathd.
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
+include the configured time if a deferred failback is not in progress, or
+it will show the current progress of a deferred failback in seconds.
+.TP
+.B %Q
+The device \fBno_path_retry\fR setting. If no_path_retry is set to a
+number of retries, it will either print the configured number of checker
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
+The state of the device in device-mapper. \fIsuspend\fR if the devices is
+suspended, and \fIactive\fR otherwise.
+.TP
+.B %S
+The device size, using the suffixes \fBK\fR, \fBM\fR, \fBG\fR, \fBT\fR,
+and \fBP\fR, to stand for kilobytes, megabytes, gigabytes, terabytes,
+and petabytes, respectively.
+.TP
+.B %f
+The "features" string of the device-mapper table in the kernel.
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
+multipath devices. See "FOREIGN MULTIPATH SUPPORT" in
+.BR @CONFIGFILE@ (5).
+.TP
+.B %g
+Data from vendor specific vpd pages for the device, if any. Currently
+multipathd supports VPD page 0xc0 for HPE 3PAR / Primera / Alletra storage
+arrays.
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
+The device Host:Channel:Id:Lun for SCSI devices. The device "Controller Instance
+Number":"Controller ID":"Namespace Instance Number":"Namespace ID" for NVMe
+devices. The Controller and Namespace Instance Numbers match the NVMe device
+name: "nvme<Controller_Instance_Number>n<Namespace_Instance_Number>"
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
+The offline state of the device. This shows "offline" if the device's "state"
+attribute in sysfs is "offline" (for SCSI) or "dead" (for NMVe). For all other
+sysfs states, it shows "running".
+.TP
+.B %T
+The multipathd path checker state of the device. The possible states are:
+.RS
+.TP 12
+.I ready
+The device is ready to handle IO.
+.TP
+.I faulty
+The device is unusable.
+.TP
+.I shaky
+The device is not able to handle IO but can still be accesed to check the
+priority.
+.TP
+.I ghost
+The device is in stand-by state.
+.TP
+.I i/o pending
+The checker is in the process of determining the device state.
+.TP
+.I i/o timeout
+The path checker has timed out, failing the device.
+.TP
+.I delayed
+The device appears usable, but it being delayed for marginal path checking.
+.TP
+.I undef
+The device either is not part of a multipath device, or its path checker has
+not yet run.
+.PP
+.RE
+.TP
+.B %s
+The vendor/product/revision string for the device.
+.TP
+.B %c
+The name of the device's path checking algorithm
+.TP
+.B %C
+The progress towards the next path checker run on the device in seconds.
+.TP
+.B %p
+The device priority.
+.TP
+.B %S
+The device size, using the suffixes \fBK\fR, \fBM\fR, \fBG\fR, \fBT\fR,
+and \fBP\fR, to stand for kilobytes, megabytes, gigabytes, terabytes,
+and petabytes, respectively.
+.TP
+.B %z
+The device serial number.
+.TP
+.B %M
+The device marginal state, either \fImarginal\fR or \fInormal\fR.
+.TP
+.B %m
+The multipath device that this device is a path of, or \fI[orphan]\fR if
+it is not part of any multipath device.
+.TP
+.B %N
+The host World Wide Node Name (WWNN) of the device, if any.
+.TP
+.B %n
+The target World Wide Node Name (WWNN) of the device, if any.
+.TP
+.B %R
+The host World Wide Port Name (WWPN) of the device, if any.
+.TP
+.B %r
+The target World Wide Port Name (WWPN) of the device, if any.
+.TP
+.B %a
+The host adapter name for the device (only SCSI devices).
+.TP
+.B %G
+The foreign library used for the device, or \fB--\fR for native device-mapper
+multipath devices. See "FOREIGN MULTIPATH SUPPORT" in
+.BR @CONFIGFILE@ (5).
+.TP
+.B %g
+Data from vendor specific vpd pages for the device, if any. Currently
+multipathd supports VPD page 0xc0 for HPE 3PAR / Primera / Alletra storage
+arrays.
+.TP
+.B %0
+The number of times this device has failed.
+.TP
+.B %P
+The device protocol. See
+.BR @CONFIGFILE@ (5).
+.TP
+.B %I
+The device initialization state. Devices that have been fully initialized
+are shown as \fIok\fR.
+.TP
+.B %L
+The device SCSI LUN ID in hexadecimal format. This is only meaningful for
+SCSI devices.
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


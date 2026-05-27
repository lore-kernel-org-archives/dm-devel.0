Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6663B27D3
	for <dm-devel@lists.linux.dev>; Wed, 27 May 2026 20:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779913310; cv=none; b=FeU0otPSNAFkGgWkPvZ7H1K0XSduViFQ9At6RoVcXhGr+sMZ/78ybI8VNCgoGrg6ri7hVtJu1GXRe0Jsy0OFHds+Q6rcC7PD+K3g5VEVSk3kozHHlrVGnLgGiIrUxAO+0KL/rOF7QOxn8Qo26cl+ke4m2bOEjlu8n2Bteivs6mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779913310; c=relaxed/simple;
	bh=Dk9mixcHZKNHutXafgnHV2UcQIJSWeO/Q6IUuGCjYPE=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=DAGnFDp2k8NHCzRN3Y6bymhI09HG+TW4R8bRklVMtsHu8b6KCeFuybz1tJnr27bRJqp1w3nJQmX0S5sKDyu+gh9SqIfnjCCqMGuXuWHFdM7XNBg9eg8M+KEhgfxBm9s9F6opiI/crz3OIV+EPYpjE2grBbPdWEM/IWK0eSBk8Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eXQNVA5m; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eXQNVA5m"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4493cf2f982so1218882f8f.2
        for <dm-devel@lists.linux.dev>; Wed, 27 May 2026 13:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779913307; x=1780518107; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mnjkvWjoizbRXQFF+arZQbGcSJwXPC+66jmCE4DRV2w=;
        b=eXQNVA5mRU2Rf5/Ew812vEiXZCauOjMQltFfy4sJZNLBMLk6Hi9iJu9u6tHoYjj5zi
         GcNSvbftawY3/GZsDK7B3lM8vr5i+CmWG9iBMBfQHZWF8Y5UFVWkO2dvDGne4MxA1xIJ
         Y7deAb9+uFdWzup/LdwgLP88mlNgP/6qm6SxIfM93BAuua1fKw4f08ImrQ7y8VIsozI+
         QgmRo8qV5LlkczlrTmZKti8/8+7qAK8PMdVHSf0ijTRJpHBDMJnBoIjlYOX6i1x8PPaG
         HDnT30lKJaOgmrl/u9GxHBiQJnMg7enqgZp2ioIZZo1diWzCRjVL19sefta+1S6c0fMV
         +lHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779913307; x=1780518107;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mnjkvWjoizbRXQFF+arZQbGcSJwXPC+66jmCE4DRV2w=;
        b=Ov6VJ3URrOcjHZ409A8P2RISCkYqPCqL8UWjAicqYQO5LGikRXSqu7r8sQwL/NYnpy
         AwGH0nbk8MyCM2bkh9Rk6VvPpJiF3R/yMjXml5wOMpMlDRkNTP7obcilLRZ1/a1+b92H
         ujdDy0LVx5pf/UAU7be3DwN2rArkZSLd8R1TtGdDdOwOMh4hSxrMfNOU0Paqdzgcuidg
         hC73qLhxo4zZAXVg4OTGLvokzOfCdxkCVum3PIRQm0/jdZZA4tMPVvl6qF1Hd3d5fi8B
         iUiev5771Ql1P8GbqzSV2NL8bXurmoKXH2lvnXLp2AERpUI96rI+TfuPlIj0kuTO21PI
         p5qg==
X-Forwarded-Encrypted: i=1; AFNElJ8E7XAIxDJdYXax6xV5qaXmBq3QUsNK9caounCHEQR51IWHNLvFsnWpzsDTHsuBCeXJfAu4b5J2jQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwxVjiSOrPjPNhs1HrPmB9q6xwpEXCyTaMNRtadAMmkAbSdu/Vh
	h05yDI5WAu7e6IWKE3Acb9XOHPawAWHMXhbwFUCgMjkMmGfgPE/sO8A=
X-Gm-Gg: Acq92OFnh5mBcWX1Zm8kfORinKOjGN4q9v2NXLQYiarbEbWSAYOZDtr9MBh0l2Gwo2R
	/VGIuD4A4w/3Qcvn2MIvquSg9PqQg/zZTqwIUFT2itigybxjc3osJfz9WOv2etwV//wKAEEQDVX
	+uoMTBMWBV0RE5fPXSdgav0UZxgzO4MZcfl1tQnpdvkez2iBxUnm87A1EpIB5K1WCLzPeJmlYGC
	mT5X3JIMw5JjeYrMiEFC3EyYSiw1VkluJHEIRlnEbURkZp7abEBrPdqk0NYVs0MuD/nGb67KBC3
	P+BaXGemOtmWfarRxIvOYKcNKf2T6ftXWFB1lEGYkpvDKrWctHLPZTmDqBPANLgq2+/1wHqiK6x
	A+DhShOdt8sAq8nWsdcEACkRrrMKn5MKl3RX+qaqPU8JBPHaQ4OFvKI7OXVUzh5PMwXurv452JY
	+s2R6JiyyY/gwqrfIhL9ccn31i+xAGRSXARQLH8PdfK2KxRbKl0FKXkS22IWmaN3RYZ9dU/cE=
X-Received: by 2002:a05:600c:a47:b0:48d:1021:e5d1 with SMTP id 5b1f17b1804b1-4908ceefbedmr913555e9.3.1779913306557;
        Wed, 27 May 2026 13:21:46 -0700 (PDT)
Received: from localhost (32.red-80-39-29.staticip.rima-tde.net. [80.39.29.32])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45edb5c2323sm8649536f8f.34.2026.05.27.13.21.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2026 13:21:45 -0700 (PDT)
Message-ID: <6c638f23-da7a-4ba2-9355-3314bd945383@gmail.com>
Date: Wed, 27 May 2026 22:21:45 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 1/2] multipath-tools: fix mandoc errors in man pages
To: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 DM_DEVEL-ML <dm-devel@lists.linux.dev>
References: <20251010092211.57426-1-xose.vazquez@gmail.com>
 <0580f369a7102ae07aaa2c23fd4bd9165cbafd35.camel@suse.com>
 <a2923472-331c-43ea-9ba2-f7208b9869c9@gmail.com>
 <6db4511afaef029f99590d818ba410cc7db9293c.camel@suse.com>
Content-Language: en-US, en-GB, es-ES
In-Reply-To: <6db4511afaef029f99590d818ba410cc7db9293c.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/10/25 3:05 PM, Martin Wilck wrote:

When you have a moment, could you give this patch a try?
Thanks.

> On Fri, 2025-10-10 at 14:37 +0200, Xose Vazquez Perez wrote:
>> On 10/10/25 1:20 PM, Martin Wilck wrote:
>>
>>> I believe our man pages have more serious issues; for example, we
>>> use
>>> so deep indentation in multipath.conf.5 that the page is hardly
>>> readable on narrow terminals.
>>
>> I do not think so:
>>
>> export LC_ALL=en_US.UTF-8 MANROFFSEQ="" MANWIDTH=80
>> man ./multipath/multipath.conf.5.in
>>
>> It is displayed correctly, except for these three lines:
> 
> Yes it's "correct". But it's very hard to read. Lots of empty space on
> the left and narrow text column on the right.
> 
> Martin

Maybe this can help.

 From 1ba649e12314aa69952658cd80230ca13f48f974 Mon Sep 17 00:00:00 2001
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Date: Wed, 15 Oct 2025 23:55:46 +0200
Subject: [PATCH] alleviate the indent in multipath.conf.5.in
X-Patchwork-Bot: notify

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
  multipath/multipath.conf.5.in | 56 +++++++++++++++++------------------
  1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
index 3c9ae097..3dc7c65b 100644
--- a/multipath/multipath.conf.5.in
+++ b/multipath/multipath.conf.5.in
@@ -103,7 +103,7 @@ matches, standard regular expression syntax using the special characters "^" and
  .LP
  .
  The following \fIsection\fP keywords are recognized:
-.TP 17
+.TP
  .B defaults
  This section defines default values for attributes which are used
  whenever no values are given in the appropriate device or multipath
@@ -142,7 +142,7 @@ device-specific settings for all devices.
  The \fIdefaults\fR section recognizes the following keywords:
  .
  .
-.TP 17
+.TP
  .B verbosity
  Default verbosity. Higher values increase the verbosity level. Valid
  levels are between 0 and 6.
@@ -195,7 +195,7 @@ The default is: \fBno\fR
  The default path selector algorithm to use; they are offered by the
  kernel multipath target:
  .RS
-.TP 12
+.TP
  .I "round-robin 0"
  Choose the path for the next bunch of I/O by looping through every path in the
  path group, sending \fBthe same number of I/O requests\fR to each path. Some
@@ -224,7 +224,7 @@ The default is: \fBservice-time 0\fR
  (Hardware-dependent) The default path grouping policy to apply to unspecified
  multipaths. Possible values are:
  .RS
-.TP 12
+.TP
  .I failover
  One path per priority group.
  .TP
@@ -334,7 +334,7 @@ of this path. Higher number have a higher priority.
  \fI"none"\fR is a valid value. Currently the following path priority routines
  are implemented:
  .RS
-.TP 12
+.TP
  .I const
  Return a constant priority of \fI1\fR.
  .TP
@@ -409,12 +409,12 @@ NetAPP E/EF Series, where it is \fBalua\fR). If \fBdetect_prio\fR is
  Arguments to pass to to the prio function. This only applies to certain
  prioritizers:
  .RS
-.TP 12
+.TP
  .I weighted
  Needs a value of the form
  \fI"<hbtl|devname|serial|wwn> <regex1> <prio1> <regex2> <prio2> ..."\fR
  .RS
-.TP 8
+.TP
  .I hbtl
  Regex can be of SCSI H:B:T:L format. For example: 1:0:.:. , *:0:0:.
  .TP
@@ -431,11 +431,11 @@ Regex can be of the form \fI"host_wwnn:host_wwpn:target_wwnn:target_wwpn"\fR
  these values can be looked up through sysfs or by running \fImultipathd show paths format
  "%N:%R:%n:%r"\fR. For example: 0x200100e08ba0aea0:0x210100e08ba0aea0:.*:.* , .*:.*:iqn.2009-10.com.redhat.msp.lab.ask-06:.*
  .RE
-.TP 12
+.TP
  .I path_latency
  Needs a value of the form "io_num=\fI<20>\fR base_num=\fI<10>\fR"
  .RS
-.TP 8
+.TP
  .I io_num
  The number of read IOs sent to the current path continuously, used to calculate the average path latency.
  Valid Values: Integer, [20, 200].
@@ -446,7 +446,7 @@ Double-precision floating-point, [1.1, 10]. And Max average latency value is 100
  For example: If base_num=10, the paths will be grouped in priority groups with path latency <=1us, (1us, 10us],
  (10us, 100us], (100us, 1ms], (1ms, 10ms], (10ms, 100ms], (100ms, 1s], (1s, 10s], (10s, 100s], >100s.
  .RE
-.TP 12
+.TP
  .I alua
  If \fIexclusive_pref_bit\fR is set, paths with the \fIpreferred path\fR bit
  set will always be in their own path group.
@@ -457,17 +457,17 @@ set will always be in their own path group.
  .TP
  .I datacore
  .RS
-.TP 8
+.TP
  .I preferredsds
  (Mandatory) The preferred "SDS name".
  .TP
  .I timeout
  (Optional) The timeout for the INQUIRY, in ms.
  .RE
-.TP 12
+.TP
  .I iet
  .RS
-.TP 8
+.TP
  .I preferredip=...
  (Mandatory) Th preferred IP address, in dotted decimal notation, for iSCSI targets.
  .RE
@@ -482,7 +482,7 @@ Specify any device-mapper features to be used. Syntax is \fInum list\fR
  where \fInum\fR is the number, between 0 and 8, of features in \fIlist\fR.
  Possible values for the feature list are:
  .RS
-.TP 12
+.TP
  .I queue_if_no_path
  (Deprecated, superseded by \fIno_path_retry\fR) Queue I/O if no path is active.
  Identical to the \fIno_path_retry\fR with \fIqueue\fR value. If both this
@@ -521,7 +521,7 @@ to respond. The asynchronous checkers (\fItur\fR and \fIdirectio\fR) will not
  pause multipathd. Instead, multipathd will check for a response once per
  second, until \fIchecker_timeout\fR seconds have elapsed. Possible values are:
  .RS
-.TP 12
+.TP
  .I readsector0
  (Deprecated) Read the first sector of the device. This checker is being
  deprecated, please use \fItur\fR or \fIdirectio\fR instead.
@@ -575,7 +575,7 @@ Tell multipathd how to manage path group failback.
  To select \fIimmediate\fR or a \fIvalue\fR, it's mandatory that the device
  has support for a working prioritizer.
  .RS
-.TP 12
+.TP
  .I immediate
  Immediately failback to the highest priority pathgroup that contains
  active paths.
@@ -650,7 +650,7 @@ The default is: \fBuniform\fR
  .B no_path_retry
  Specify what to do when all paths are down. Possible values are:
  .RS
-.TP 12
+.TP
  .I value > 0
  Number of retries until disable I/O queueing.
  .TP
@@ -1192,7 +1192,7 @@ blocked from further processing by higher layers - such as LVM - if and only
  if it\'s considered a valid multipath device path), and b) when multipathd
  detects a new device. The following values are possible:
  .RS
-.TP 10
+.TP
  .I strict
  Both multipath and multipathd treat only such devices as multipath devices
  which have been part of a multipath map previously, and which are therefore
@@ -1444,7 +1444,7 @@ by multipath-tools.
  .
  The following keywords are recognized in both sections. The defaults are empty
  unless explicitly stated.
-.TP 17
+.TP
  .B devnode
  Regular expression matching the device nodes to be excluded/included.
  .RS
@@ -1534,7 +1534,7 @@ from later entries take precedence.
  .
  .
  The \fImultipath\fR subsection recognizes the following attributes:
-.TP 17
+.TP
  .B wwid
  (Mandatory) World Wide Identifier. Detected multipath maps are matched against this attribute.
  Note that, unlike the \fIwwid\fR attribute in the \fIblacklist\fR section,
@@ -1553,7 +1553,7 @@ section:
  .sp 1
  .PD .1v
  .RS
-.TP 18
+.TP
  .B path_grouping_policy
  .TP
  .B path_selector
@@ -1614,7 +1614,7 @@ section:
  .SH "devices section"
  .\" ----------------------------------------------------------------------------
  .
-.TP 4
+.TP
  .B Important:
  The built-in hardware device table of
  .I multipath-tools
@@ -1650,7 +1650,7 @@ for all devices in the system.
  .LP
  .
  The \fIdevice\fR subsection recognizes the following attributes:
-.TP 17
+.TP
  .B vendor
  (Mandatory) Regular expression to match the vendor name.
  .RS
@@ -1693,7 +1693,7 @@ and \fImultipathd show paths format\fR commands. Currently only the
  The hardware handler to use for this device type.
  The following hardware handler are implemented:
  .RS
-.TP 12
+.TP
  .I 1 emc
  (Hardware-dependent)
  Hardware handler for DGC class arrays as CLARiiON CX/AX and EMC VNX families
@@ -1734,7 +1734,7 @@ section:
  .sp 1
  .PD .1v
  .RS
-.TP 18
+.TP
  .B path_grouping_policy
  .TP
  .B uid_attribute
@@ -1816,7 +1816,7 @@ the values are taken from the \fIdevices\fR or \fIdefaults\fR sections:
  .sp 1
  .PD .1v
  .RS
-.TP 18
+.TP
  .B path_grouping_policy
  .TP
  .B uid_attribute
@@ -1934,7 +1934,7 @@ which paths belong to the same device. Each path presenting the same
  WWID is assumed to point to the same device.
  .LP
  The WWID is generated by four methods (in the order of preference):
-.TP 17
+.TP
  .B uid_attrs
  The WWID is derived from udev attributes by matching the device node name; cf
  \fIuid_attrs\fR above.
@@ -1974,7 +1974,7 @@ pathgroups will not be used until all other pathgroups have been tried. At the
  time when the path would normally be reinstated, it will be returned to its
  normal pathgroup. The logic of determining \(dqshaky\(dq condition, as well as
  the logic when to reinstate, differs between the three methods.
-.TP 8
+.TP
  .B \(dqdelay_checks\(dq failure tracking
  (Deprecated) This method is \fBdeprecated\fR and mapped to the \(dqsan_path_err\(dq method.
  See the \fIdelay_watch_checks\fR and \fIdelay_wait_checks\fR options above
-- 
2.51.0



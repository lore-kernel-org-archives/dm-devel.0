Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B533254B4
	for <dm-devel@lists.linux.dev>; Wed, 15 Oct 2025 22:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760565634; cv=none; b=Vaxyl0rA1Aq2zNk2zqNVe/Plu4tZxH7oOVMfabYEFGUbPtQXgtFEWraYYXL1Xh77eDms5cJ3KKrvSsvwxDLiTh8Pa8ps1cQ8ZjuSZJGP7xOeCmvh8wktLNYgRH0v4EuBZGO8PP1mJ7RLm8ayNLKOpWBzxRgJYuJUgOKr5LSxbi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760565634; c=relaxed/simple;
	bh=jo1GEYCfVfXrf5QsHdFxaIAoJgSXo40+QMEQP+ScF1g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TX5yPX7kCHh8HeqYHy8ea4bMJkk4RO05tcM7ThC67DyFB7xJSjVaYk9PNX083RkVa1OO67/Dy1j3oeYMk/4ct39eEE2kELCTAdy9cGDYYSf8710BxQeirFOGIb5vHH9SUSdYQ3FaNCdIiB+4Of1S01SyMaJqhnobZ0+19UCAgSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lReCFM8h; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lReCFM8h"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4710dc94cf0so66575e9.1
        for <dm-devel@lists.linux.dev>; Wed, 15 Oct 2025 15:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760565631; x=1761170431; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=paydnzRcEhnPck8TRYyH8bkbXLMxgOZdbIbB6chJVms=;
        b=lReCFM8hGfAJgfed4HCo09A+6NnDD53iLMdRgI9wNhZ5EIZfL1G1HtCz4DrFmLg9iE
         +KXiIL2r3avpFiwkfDmpk9vlp0tzlK7I6XNlzo/Wsloo2pKTuaxr8h8UwoNCdtnO+CM+
         f7VRIe/LBNUtsm7p3f0v4B2NW79S7+5AleL6wdw+aWa3ClThodUs5T47DTZBEQB2o+PB
         8G0tVdmAnG2KgPZRm5zxbLKZJLXy6C8v5ebyytri1Bwfkfp5OPtgS6yEmroMIJxCVayH
         TUeui/MF5XZkOKDcsjwoDFQg7UkcNf+TiMDF7oOqW37PTjGouLA7ZsOptKCrLp3a3ypJ
         ZxVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760565631; x=1761170431;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=paydnzRcEhnPck8TRYyH8bkbXLMxgOZdbIbB6chJVms=;
        b=lpUk76NLVr/5q1k/yX3zwHNkhfBl6rxzz1bmoRLsc/57um/pwf0YOO3yc3vt1vp72k
         OBlyW2OFWAwxTxDlylckB6vIRhk3RhhdpeQebBQuGGPbagP77jT6VSfGd5zFNZQlHg5c
         rvHr3t6eUBIv/mTweL8xr8Aec5bN/BIZKYH/kfcPy80Kuecbhv8ef0WqwYsunC1mM1lF
         bmVC5QnKEtFpvi3lmg3Re3AvK4W5HBA+grKxS7fBFW4f17bxfYowKkoyl5FEisPVUBMZ
         vNY//mL7K4Myc+aoVApb4xWCa4TXADpz1sSWrWoVSk/+fTAb5NoZJv5QN5hM2f3brxy6
         a+5w==
X-Forwarded-Encrypted: i=1; AJvYcCU/GxFpwcNxEZrNUpXNO0umeEb78D193ZP/wQ09FVA6zeiQr+4r0/SD7drWEzEr2HFUkfXcSiOOCg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxr3oqPVhNcFcv/AFMlp/5Vp/FCg99WMFzIfSOogcuQu3dxBCEo
	UB7T5BKW3unAKnYS9S/0jetZWlMYhjxIxhOJ8NLHATnRaqEb6jC0QTg=
X-Gm-Gg: ASbGncvf7onvS7oAQTt2DFnOnw3r/yx5Z00QC5toC/cnEhgLYl5rOm2XzIkEEuct6Wr
	dNOvLRg0KNntZ+ZkqxWKC3vLKS6r+aOnx7yInkmNSMzwuSwhVKB0Z3Kqx8+Fgtk4cl9pji9+y6l
	xFFaVCLbbKOByGnUznFNd0fdwJbOs1lkaCSpgucbS0e3ZZZSpm2hjqSvPa/+pSqWM7aCLGjCV/I
	IX+LJSiN9DXn2xW6esKIw4oGZnMvvlDUGBauJPriXxReYPX/pSbRVqPM6Z0a5UQjOUjFSQXgCyX
	Qmog8V/iQlA8OjaQquiMzqHE4hRnp8cEpm3At0k5H3z/0Odq5kKTYyfj5wc1vnjWuTfjTHe8lMO
	rV9i+IHagTIBlHtAC2tjr3hypoLrbOwrm7JehG/ame6ZzuNEmkg2tzImoXpFX+v40itmb8828C2
	pIiZQ/8iVT/95WlVMUBvOnYq4JgTtBBl2aPQW+1feBIHxN
X-Google-Smtp-Source: AGHT+IFrRdPgHdsdl4nsBVNPWMcz9so3HN88rQwQGKjdKXI0FQDG4OHxQFdSIQitwX2WUO5wAQ9q3g==
X-Received: by 2002:a05:6000:18a4:b0:3e9:559c:13f6 with SMTP id ffacd0b85a97d-42666aca3b5mr10858369f8f.2.1760565630387;
        Wed, 15 Oct 2025 15:00:30 -0700 (PDT)
Received: from localhost (120.red-80-39-141.dynamicip.rima-tde.net. [80.39.141.120])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426f2f72e18sm9905026f8f.0.2025.10.15.15.00.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Oct 2025 15:00:29 -0700 (PDT)
Message-ID: <ce44ad7b-ba6d-4710-a751-413259c75a88@gmail.com>
Date: Thu, 16 Oct 2025 00:00:29 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
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
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <6db4511afaef029f99590d818ba410cc7db9293c.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/10/25 3:05 PM, Martin Wilck wrote:
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



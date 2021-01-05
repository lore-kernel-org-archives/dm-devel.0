Return-Path: <SRS0=jKmk=GI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9E42C433DB
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jan 2021 04:00:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4615222583
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jan 2021 04:00:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4615222583
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1609819239;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=T3Oc6jTltRjSlA5X8znE9IIGPwFAvgTP0v1gz6HtCDc=;
	b=ZZOUc+TYnMYnsMAm6+M2rVna4acekxOAvP6cSc6Ih6DCkK6RV/1jD3qiCGan9p3nsOMHJU
	38e9fEUYJo+v2kqBvBW0xJ7spbzJDvlgH1v2pQr1mNe6KF4T1Q3vUD1CCqdDpC76b26lM0
	8rOQVsAxYwwiYZg6uGlnduST07wgR+A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424--MjTd4wkNgOAAbOjijnaYg-1; Mon, 04 Jan 2021 23:00:37 -0500
X-MC-Unique: -MjTd4wkNgOAAbOjijnaYg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 849321005E48;
	Tue,  5 Jan 2021 04:00:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 61B6F1A7D9;
	Tue,  5 Jan 2021 04:00:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3758F1809C9F;
	Tue,  5 Jan 2021 04:00:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 105407sn008488 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 4 Jan 2021 23:00:07 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 44C7760C64; Tue,  5 Jan 2021 04:00:07 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9070560BE5;
	Tue,  5 Jan 2021 03:59:59 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1053xw2X018352; 
	Mon, 4 Jan 2021 21:59:58 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1053xvVG018351;
	Mon, 4 Jan 2021 21:59:57 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Mon,  4 Jan 2021 21:59:55 -0600
Message-Id: <1609819195-18306-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1609819195-18306-1-git-send-email-bmarzins@redhat.com>
References: <1609819195-18306-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH 2/2] multipath.conf.5: Improve checker_timeout
	description
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

I was asked to explain how checker_timeout works for checkers like
directio, that don't issue scsi commands with an explicit timeout.
Also, undeprecate the directio checker.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath/multipath.conf.5 | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index ea66a01e..8ef3a747 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -472,8 +472,12 @@ The default is: \fB<unset>\fR
 .
 .TP
 .B path_checker
-The default method used to determine the paths state. Possible values
-are:
+The default method used to determine the path's state. The synchronous
+checkers (all except \fItur\fR and \fIdirectio\fR) will cause multipathd to
+pause most activity, waiting up to \fIchecker_timeout\fR seconds for the path
+to respond. The asynchronous checkers (\fItur\fR and \fIdirectio\fR) will not
+pause multipathd. Instead, multipathd will check for a response once per
+second, until \fIchecker_timeout\fR seconds have elapsed. Possible values are:
 .RS
 .TP 12
 .I readsector0
@@ -499,10 +503,8 @@ Check the path state for LSI/Engenio/NetApp RDAC class as NetApp SANtricity E/EF
 Series, and OEM arrays from IBM DELL SGI STK and SUN.
 .TP
 .I directio
-(Deprecated) Read the first sector with direct I/O. If you have a large number
-of paths, or many AIO users on a system, you may need to use sysctl to
-increase fs.aio-max-nr. This checker is being deprecated, it could cause
-spurious path failures under high load. Please use \fItur\fR instead.
+Read the first sector with direct I/O. This checker could cause spurious path
+failures under high load. Increasing \fIchecker_timeout\fR can help with this.
 .TP
 .I cciss_tur
 (Hardware-dependent)
@@ -639,8 +641,10 @@ The default is: \fBno\fR
 .
 .TP
 .B checker_timeout
-Specify the timeout to use for path checkers and prioritizers that issue SCSI
-commands with an explicit timeout, in seconds.
+Specify the timeout to use for path checkers and prioritizers, in seconds.
+Only prioritizers that issue scsi commands use checker_timeout.  If a path
+does not respond to the checker command after \fIchecker_timeout\fR
+seconds have elapsed, it is considered down.
 .RS
 .TP
 The default is: in \fB/sys/block/sd<x>/device/timeout\fR
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


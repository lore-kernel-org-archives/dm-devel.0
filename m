Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09D57CD37A9
	for <dm-devel@archiver.kernel.org>; Fri, 15 Sep 2023 20:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694809351;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=3BGUnHjjbHT+axFqya2K1IDBEtiP/bt/xoTtNhaAzwo=;
	b=d34A7INB68psNBFYVedOv2JQPko0iTWLeGiBXDg4CJwHHoXor+nG1rFpNaYV4TLLA/A+DR
	2fCaEbBNInHwbqFsa1DRHdfMG0XMbd0FdaXU2VYu1b1s7wipMiLvfEg5jv+lkYDXIw/9YU
	X4sZ1dWT+IBjHEjI0sq6vvEIN1VSrII=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-634-_jqBnnhDOsGbuDts9bZuNg-1; Fri, 15 Sep 2023 16:22:28 -0400
X-MC-Unique: _jqBnnhDOsGbuDts9bZuNg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A711F101AA70;
	Fri, 15 Sep 2023 20:22:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3499D409AFC8;
	Fri, 15 Sep 2023 20:22:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CB8D5194658C;
	Fri, 15 Sep 2023 20:22:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 22CDE1946588
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Sep 2023 20:22:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 05DF41D094; Fri, 15 Sep 2023 20:22:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F29521D093
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 20:22:13 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D192B81D891
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 20:22:13 +0000 (UTC)
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com
 [209.85.128.43]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-116-1aYveWjfNZ-h1s2XBppOjw-1; Fri, 15 Sep 2023 16:22:11 -0400
X-MC-Unique: 1aYveWjfNZ-h1s2XBppOjw-1
Received: by mail-wm1-f43.google.com with SMTP id
 5b1f17b1804b1-401b393ddd2so29202345e9.0; 
 Fri, 15 Sep 2023 13:22:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1694809330; x=1695414130;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=07KHYTMYNNddb8pGR9QzuRovuVl7rs/SyS3+NuVair0=;
 b=LOGOuIcs7+/sl/wQn8bODcRx6+s3eRZRgB5zF6oohvQXsbgllJHZoc/SMhMvL2dkm7
 2bv8tRhJ4TsIIT1KjRsTc+4p2bn//t8plcXUThIx2YhjuZMPhIkEK73J2uDfyO/T7J6S
 OqyWy5iRYVjjxLy+GxSoyRKMtst0ltJUVke4HBPbfZV6n/o8t23hWpSL8Pl5WPEpWay2
 lXb49NaV8Jzc7nS8m9fqHN9Chx4mHS/3K4vWniV9DreQkgMGtdLuda0JFFrjhMV3334X
 xzHM4W1GXAdAl+/sU7uUoIlWLm+LN4WE1te08YkxVV0q6K5a9YKSBw1hthGcJKenzPev
 1ylw==
X-Gm-Message-State: AOJu0YwHaaNQ/Np56nAcudYwUs5jXkM9U/s4c4+oF4AIvf7PCHcUquU7
 oivMlDt+TJIxdUxkw+T+Gg==
X-Google-Smtp-Source: AGHT+IElnOkipfSJAo4rMXRfcKNpMYFCD/ZCH51SfTqgB+TMTvNMCrX9keeYqLnJBS1GQHDXLgIAcw==
X-Received: by 2002:adf:ea0b:0:b0:314:15b7:20a5 with SMTP id
 q11-20020adfea0b000000b0031415b720a5mr2438124wrm.54.1694809329918; 
 Fri, 15 Sep 2023 13:22:09 -0700 (PDT)
Received: from localhost (24.red-81-44-202.dynamicip.rima-tde.net.
 [81.44.202.24]) by smtp.gmail.com with ESMTPSA id
 c13-20020a5d4ccd000000b0030fd03e3d25sm5227971wrt.75.2023.09.15.13.22.08
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 15 Sep 2023 13:22:08 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Fri, 15 Sep 2023 22:22:06 +0200
Message-ID: <20230915202206.8321-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [PATCH] multipath-tools: fix spelling
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>,
 DM-DEVEL ML <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 README.md                     | 4 ++--
 multipath/multipath.conf.5.in | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/README.md b/README.md
index 679e55bf..524c9fb1 100644
--- a/README.md
+++ b/README.md
@@ -92,7 +92,7 @@ The following variables can be passed to the `make` command line:
    The default is `$(prefix)/$(LIB)/multipath`, where `$(LIB)` is `lib64` on
    systems that have `/lib64`, and `lib` otherwise.
  * `configfile="/some/path`": The path to the main configuration file.
-    The defalt is `$(etc_prefix)/etc/multipath.conf`.
+    The default is `$(etc_prefix)/etc/multipath.conf`.
  * `configdir="/some/path"` : directory to search for additional configuration files.
     This used to be the run-time option `config_dir` in earlier versions.
 	The default is `$(etc_prefix)/etc/multipath/conf.d`.
@@ -141,7 +141,7 @@ The following variables can be passed to the `make` command line:
    found on the build system, and `/lib` otherwise.
    
 The options `configdir`, `plugindir`, `configfile`, and `statedir` above can
-be used for setting indvidual paths where the `prefix` variables don't provide
+be used for setting individual paths where the `prefix` variables don't provide
 sufficient control. See `Makefile.inc` for even more fine-grained control.
 
 [^systemd]: Some systemd installations use separate `prefix` and `rootprefix`. 
diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
index d320a88f..226d0019 100644
--- a/multipath/multipath.conf.5.in
+++ b/multipath/multipath.conf.5.in
@@ -36,7 +36,7 @@ Files ending in \fI.conf\fR in this directory are read
 in alphabetical order, after reading \fI@CONFIGFILE@\fR.
 They use the same syntax as \fI@CONFIGFILE@\fR itself,
 and support all sections and keywords. If a keyword occurs in the same section
-in multiple files, the last occurence will take precedence over all others.
+in multiple files, the last occurrence will take precedence over all others.
 .
 .
 .\" ----------------------------------------------------------------------------
-- 
2.41.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


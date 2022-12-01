Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6ABEC4321E
	for <dm-devel@archiver.kernel.org>; Thu,  1 Dec 2022 01:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669857901;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=q9ARdSrF2w06TOw25ZDuySu3A1UWN9UkX6dCtzGfnBM=;
	b=PDBQMj9h97vWezyGBkkRrMpI9CTo7OZgU9xrIMjpzqiVKGLsXfG7qEFzhspicN0V6RRS99
	c1nc8zgaAviFAnUT6DfqqcW+7OxEnlR3rvEGtvrHT/b9NcZDDhzkTZAMQGRQrtVh7eLBLQ
	FXn7pvBeHErKPXK12fMYvsEkMvkjM34=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-163-kWUt_h8uPemJt7ekARfsoQ-1; Wed, 30 Nov 2022 20:24:58 -0500
X-MC-Unique: kWUt_h8uPemJt7ekARfsoQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9D9AE3C02B81;
	Thu,  1 Dec 2022 01:24:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5643F1731B;
	Thu,  1 Dec 2022 01:24:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 04AD319465A0;
	Thu,  1 Dec 2022 01:24:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id ACB3D1946586
 for <dm-devel@listman.corp.redhat.com>; Thu,  1 Dec 2022 01:24:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 589DF2024CC0; Thu,  1 Dec 2022 01:24:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 511112024CBE
 for <dm-devel@redhat.com>; Thu,  1 Dec 2022 01:24:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3280A811E81
 for <dm-devel@redhat.com>; Thu,  1 Dec 2022 01:24:53 +0000 (UTC)
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com
 [209.85.221.54]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-446-dWNNSajrPZu7qeAaTii8aw-1; Wed, 30 Nov 2022 20:24:49 -0500
X-MC-Unique: dWNNSajrPZu7qeAaTii8aw-1
Received: by mail-wr1-f54.google.com with SMTP id f18so360659wrj.5;
 Wed, 30 Nov 2022 17:24:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=Zx2ykg8fVSFuyMX2xtL/Y+L9REIHhkOG+0e2pfx9x38=;
 b=ey5nNZitNSbNI3+3QtFHzsHb2XaKnBUtPEono3+dKIWE+M2Vueh5bE761i2siw7Fcc
 Gza7XtZJCoZEhvUmj0G4egLV5cDsQdHwCahbCAgjyu/CEVXIkZGCM9PqQkYPQLGYcLWz
 Q4Pgf722j8cK+1iab2H5PaW1jy/GPJRODR0jbOCWmZfWAj2EtZfoYOyRrgTH4RieSHGW
 WB59KKz14ZbDBl8DdEPlYbiV+gBDyXGeLQwH88/CPK140Zw6N7u3HCgD4sC2QVNH1ETP
 cho/aXF7UXdyFl5ozk83+hV3qpsZdDbCraY7wEmASz20ygKxUpRfiyXPSHYYa+G5oVp0
 emiQ==
X-Gm-Message-State: ANoB5pkOyS7hOScBC2NoqrVeGpgSApEt1Xgr+MeXtUzqp+JC4ANQi8p5
 +eNbc3SmpKeJLe2s14IKAg==
X-Google-Smtp-Source: AA0mqf5noI5QS1Za1gvBygwbwfFckIBidc8vg9fBjP9Esy/Gb5YNp8e+U5bk/z8i+CsKXRPfLVhO1w==
X-Received: by 2002:a5d:6206:0:b0:241:e3b8:e1a5 with SMTP id
 y6-20020a5d6206000000b00241e3b8e1a5mr27396451wru.651.1669857886741; 
 Wed, 30 Nov 2022 17:24:46 -0800 (PST)
Received: from localhost (230.red-81-44-152.dynamicip.rima-tde.net.
 [81.44.152.230]) by smtp.gmail.com with ESMTPSA id
 n14-20020a05600c4f8e00b003c6f3f6675bsm8048766wmq.26.2022.11.30.17.24.46
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 30 Nov 2022 17:24:46 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Thu,  1 Dec 2022 02:24:45 +0100
Message-Id: <20221201012445.18649-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH v2] multipath-tools: multipath.conf man page
 housekeeping
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Mark deprecated options as (Deprecated), and standardize the description
Document pg_timeout
Default value of "features" is "0"
directio is also an alternative to readsector0

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
v2: revert wrong FPIN info

---
 multipath/multipath.conf.5 | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 3967db9b..bd7d7788 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -178,7 +178,7 @@ The default is: \fBno\fR
 .
 .TP
 .B multipath_dir
-This option is not supported any more. The value is ignored.
+(Deprecated) This option is not supported any more, and the value is ignored.
 .
 .
 .TP
@@ -238,6 +238,11 @@ The default is: \fBfailover\fR
 .
 .
 .TP
+.B pg_timeout
+(Deprecated) This option is not supported any more, and the value is ignored.
+.
+.
+.TP
 .B uid_attrs
 .
 Setting this option activates \fBmerging uevents\fR by WWID, which may improve
@@ -279,7 +284,7 @@ The default is: \fBID_WWN\fR, for NVMe devices
 .
 .TP
 .B getuid_callout
-This option is not supported any more. The value is ignored.
+(Deprecated) This option is not supported any more, and the value is ignored.
 .
 .
 .TP
@@ -463,7 +468,7 @@ cannot be changed. \fInvme:tcp\fR paths are only supported in multipath
 devices with queue_mode set to \fIbio\fR. multipath will automatically
 set this when creating a device with \fInvme:tcp\fR paths.
 .TP
-The default is: \fB<unset>\fR
+The default is: \fB0\fR
 .RE
 .
 .
@@ -479,7 +484,7 @@ second, until \fIchecker_timeout\fR seconds have elapsed. Possible values are:
 .TP 12
 .I readsector0
 (Deprecated) Read the first sector of the device. This checker is being
-deprecated, please use \fItur\fR instead.
+deprecated, please use \fItur\fR or \fIdirectio\fR instead.
 .TP
 .I tur
 Issue a \fITEST UNIT READY\fR command to the device.
@@ -551,7 +556,7 @@ The default is: \fBmanual\fR
 .
 .
 .TP
-.B  rr_min_io
+.B rr_min_io
 Number of I/O requests to route to a path before switching to the next in the
 same path group. This is only for \fIBlock I/O\fR(BIO) based multipath and
 only apply to \fIround-robin\fR path_selector.
@@ -735,7 +740,7 @@ The default is: \fB<unset>\fR
 .
 .TP
 .B bindings_file
-This option is deprecated, and will be removed in a future release.
+(Deprecated) This option is deprecated, and will be removed in a future release.
 The full pathname of the binding file to be used when the user_friendly_names
 option is set.
 .RS
@@ -746,7 +751,7 @@ The default is: \fB/etc/multipath/bindings\fR
 .
 .TP
 .B wwids_file
-This option is deprecated, and will be removed in a future release.
+(Deprecated) This option is deprecated, and will be removed in a future release.
 The full pathname of the WWIDs file, which is used by multipath to keep track
 of the WWIDs for LUNs it has created multipath devices on in the past.
 .RS
@@ -757,7 +762,7 @@ The default is: \fB/etc/multipath/wwids\fR
 .
 .TP
 .B prkeys_file
-This option is deprecated, and will be removed in a future release.
+(Deprecated) This option is deprecated, and will be removed in a future release.
 The full pathname of the prkeys file, which is used by multipathd to keep
 track of the persistent reservation key used for a specific WWID, when
 \fIreservation_key\fR is set to \fBfile\fR.
@@ -929,7 +934,7 @@ The default is: \fB<unset>\fR
 .
 .TP
 .B config_dir
-This option is not supported any more. The value is ignored.
+(Deprecated) This option is not supported any more, and the value is ignored.
 .
 .
 .TP
@@ -1042,7 +1047,7 @@ The default is: \fBno\fR
 .
 .TP
 .B delay_watch_checks
-This option is \fBdeprecated\fR, and mapped to \fIsan_path_err_forget_rate\fR.
+(Deprecated) This option is \fBdeprecated\fR, and mapped to \fIsan_path_err_forget_rate\fR.
 If this is set to a value greater than 0 and no \fIsan_path_err\fR options
 are set, \fIsan_path_err_forget_rate\fR will be set to the value of
 \fIdelay_watch_checks\fR and \fIsan_path_err_threshold\fR will be set to 1.
@@ -1056,7 +1061,7 @@ The default is: \fBno\fR
 .
 .TP
 .B delay_wait_checks
-This option is \fBdeprecated\fR, and mapped to \fIsan_path_err_recovery_time\fR.
+(Deprecated) This option is \fBdeprecated\fR, and mapped to \fIsan_path_err_recovery_time\fR.
 If this is set to a value greater than 0 and no \fIsan_path_err\fR options
 are set, \fIsan_path_err_recovery_time\fR will be set to the value of
 \fIdelay_wait_checks\fR times \fImax_polling_interval\fR. This will give
@@ -1223,8 +1228,7 @@ The default is: \fBno\fR
 .
 .TP
 .B disable_changed_wwids
-This option is deprecated and ignored. If the WWID of a path suddenly changes,
-multipathd handles it as if it was removed and then added again.
+(Deprecated) This option is not supported any more, and the value is ignored.
 .RE
 .
 .
@@ -1845,7 +1849,7 @@ normal pathgroup. The logic of determining \(dqshaky\(dq condition, as well as
 the logic when to reinstate, differs between the three methods.
 .TP 8
 .B \(dqdelay_checks\(dq failure tracking
-This method is \fBdeprecated\fR and mapped to the \(dqsan_path_err\(dq method.
+(Deprecated) This method is \fBdeprecated\fR and mapped to the \(dqsan_path_err\(dq method.
 See the \fIdelay_watch_checks\fR and \fIdelay_wait_checks\fR options above
 for more information.
 
-- 
2.38.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


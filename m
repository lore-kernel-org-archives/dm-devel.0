Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 419B6C4332F
	for <dm-devel@archiver.kernel.org>; Fri,  2 Dec 2022 17:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670002408;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zujZfzWSGWFaDTQ3O87/+aeIs3Wm6BR3OPw85gVP9GY=;
	b=R7HkKppyX/yRl7bCysT4cDzzWagH76vkJksZseKYWd7E80Vu+M6JrI+E7qoY+Cne+gkfMQ
	uX3SgLLNHZlyrr0Fx7ltsBhRWFDM6zegP/MTqtn6yIxZDAqAmfKpvpiUowzSOFgWFYrQI6
	4WrYhZFr2k7Jqqtv3i69v4FGs8WUxpE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-488-Pvt__EzXOlSqniHZwIb_Qg-1; Fri, 02 Dec 2022 12:33:26 -0500
X-MC-Unique: Pvt__EzXOlSqniHZwIb_Qg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 200D82A59563;
	Fri,  2 Dec 2022 17:33:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0F8672166B2A;
	Fri,  2 Dec 2022 17:33:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E0799194658F;
	Fri,  2 Dec 2022 17:33:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4875D1946587
 for <dm-devel@listman.corp.redhat.com>; Fri,  2 Dec 2022 17:33:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2A06163AE0; Fri,  2 Dec 2022 17:33:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 21C4B6352D
 for <dm-devel@redhat.com>; Fri,  2 Dec 2022 17:33:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 01D71800159
 for <dm-devel@redhat.com>; Fri,  2 Dec 2022 17:33:18 +0000 (UTC)
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com
 [209.85.128.49]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-581-NlB_FVHmMpWD_VVkVoJpnw-1; Fri, 02 Dec 2022 12:33:16 -0500
X-MC-Unique: NlB_FVHmMpWD_VVkVoJpnw-1
Received: by mail-wm1-f49.google.com with SMTP id m19so4029231wms.5;
 Fri, 02 Dec 2022 09:33:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=ZP/ZxM4Mhd2JIoYZ4kQ7gAvqgPHyzp0zj23TQrv8Bdo=;
 b=a/3eXTncq1JFtrl6pflOJl9lt7l8pckw3/ttqAlwtMRsql1g3M5S6Ocs27MOiLkYMC
 Ks/KSTa1v59EhIr28cqFhFytxdtXyYKph7TjxiMgTh07Te+zxsv8dMzsxr1oKMPNVS+v
 sXq7HpFCcEQOGYP8ZYjCsilLSUFe8Ljc/2DZYFAS4qowgcx0suXMc6njOiZHzfPfBf9x
 O1otikxyuJFTs6GShzWBCF9liJILtq1AQFwYz3CwkKiHX1mW+K0BC+LnTq/ZHIoPf2gD
 RHKsy0dQQgl536F+ge1xysaNIirlQA9ThGAyhGhhLtsTcSmsYZg5kRhJsOGpVaStCdcq
 Ropw==
X-Gm-Message-State: ANoB5pnNbbi9J/+2YdPTwuOOxBCGyc2GF4wo1rkBhGQMToBFCoTHM3IG
 eRQO5axXaTfe2fNnoPFHUw==
X-Google-Smtp-Source: AA0mqf7vmyycA5thg/My4AyD/ZX8O6q57ikn/vP98YRONSOtJgQmCfC5tGcwh1lULN7eYha/IZQTRg==
X-Received: by 2002:a05:600c:1907:b0:3cf:7981:9a7 with SMTP id
 j7-20020a05600c190700b003cf798109a7mr52635401wmq.87.1670002394668; 
 Fri, 02 Dec 2022 09:33:14 -0800 (PST)
Received: from localhost (28.red-88-28-18.dynamicip.rima-tde.net.
 [88.28.18.28]) by smtp.gmail.com with ESMTPSA id
 q14-20020adfdfce000000b00241cbb7f15csm7605207wrn.106.2022.12.02.09.33.14
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 02 Dec 2022 09:33:14 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Fri,  2 Dec 2022 18:33:13 +0100
Message-Id: <20221202173313.5225-1-xose.vazquez@gmail.com>
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
Subject: [dm-devel] [PATCH v2] multipath.conf(5): improve documentation of
 dev_loss_tmo
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

The statement that the default is 600 is wrong in most cases.
Improve the description of the default and the dependency of this
parameter on other parameters.

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
v2: unchanged text, just move "default value" to bottom

---
 multipath/multipath.conf.5 | 39 ++++++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 12 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index bd7d7788..76a6fb35 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -707,18 +707,33 @@ The default is: \fB5\fR
 .
 .TP
 .B dev_loss_tmo
-Specify the number of seconds the SCSI layer will wait after a problem has
-been detected on a FC remote port before removing it from the system. This
-can be set to "infinity" which sets it to the max value of 2147483647
-seconds, or 68 years. It will be automatically adjusted to the overall
-retry interval \fIno_path_retry\fR * \fIpolling_interval\fR
-if a number of retries is given with \fIno_path_retry\fR and the
-overall retry interval is longer than the specified \fIdev_loss_tmo\fR value.
-The Linux kernel will cap this value to \fI600\fR if \fIfast_io_fail_tmo\fR
-is not set. See KNOWN ISSUES.
-.RS
-.TP
-The default is: \fB600\fR
+Specify the number of seconds the SCSI layer will wait after a connection loss has
+been detected on a remote port before removing it from the system. This
+can be set to "infinity", which effectively means 136 years (2^32-1 seconds).
+This parameter is only applied to Fibre Channel and SAS devices.
+.RS
+.LP
+The value of \fIdev_loss_tmo\fR is restricted by other settings.
+If \fIfast_io_fail_tmo\fR is set to a positive value, \fBmultipathd\fR
+will make sure that the value of \fIdev_loss_tmo\fR is larger than
+\fIno_path_retry\fR * \fIpolling_interval\fR.
+If \fIfast_io_fail_tmo\fR is not set, the kernel limits the \fIdev_loss_tmo\fR
+value to 600 seconds.
+In this case, the user has to make sure that \fIno_path_retry\fR is smaller
+than \fIdev_loss_tmo / polling_interval\fR. In particular,
+\fIno_path_retry\fR must not be set to \(dq\fIqueue\fR\(dq. See KNOWN ISSUES.
+.LP
+When path devices reappear after a connection loss, it is much easier for
+the kernel to simply reactivate an inactive device than to re-add
+a previously deleted one. It is therefore recommended to set
+\fIdev_loss_tmo\fR to a large value within the restrictions mentioned above.
+.LP
+Fibre Channel and SAS devices have hardware-dependent defaults, which are left
+unchanged if \fIdev_loss_tmo\fR is not specified. For a few storage arrays,
+the multipath-tools built-in settings override the default. Run \fImultipath -T\fR
+to see the settings for your device.
+.TP
+The default is: \fB<hardware dependent>\fR
 .RE
 .
 .
-- 
2.38.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


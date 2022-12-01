Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7017BC43217
	for <dm-devel@archiver.kernel.org>; Thu,  1 Dec 2022 10:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669890801;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LNI32I06pp/b77UItWjQpOqKmGNCuA4K1nJaadU+6Xw=;
	b=cykDX7xcKmM8whHFCnCJN/mHzKW+n9Y1MEfEIhQM3+4RsDWxK3QXfUWIyEP8a7BroYNyYU
	xp5uDtZ/6thX8j21yzI6CkjSvKjDXxAbKTcN8oPzFkXF3MjwISJ/prpDZqzWJnkfusHhZF
	/vWEbtRNeIC+NnZBRCZEh2cQaJagkCY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-211-ZdJ4gSMeOzSNMYyd1jWqlw-1; Thu, 01 Dec 2022 05:33:18 -0500
X-MC-Unique: ZdJ4gSMeOzSNMYyd1jWqlw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1C82385A5B6;
	Thu,  1 Dec 2022 10:33:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 05BDF2024CC5;
	Thu,  1 Dec 2022 10:33:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CD04C19465A8;
	Thu,  1 Dec 2022 10:33:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 531F019465A0
 for <dm-devel@listman.corp.redhat.com>; Thu,  1 Dec 2022 10:33:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 38A6240C6EC4; Thu,  1 Dec 2022 10:33:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3134B40C6F73
 for <dm-devel@redhat.com>; Thu,  1 Dec 2022 10:33:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1677D1C09B62
 for <dm-devel@redhat.com>; Thu,  1 Dec 2022 10:33:14 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-267-3vSOtt9bP4SFdapF8XOIMQ-1; Thu,
 01 Dec 2022 05:33:12 -0500
X-MC-Unique: 3vSOtt9bP4SFdapF8XOIMQ-1
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 2FCD31FD68;
 Thu,  1 Dec 2022 10:33:11 +0000 (UTC)
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id F181A13503;
 Thu,  1 Dec 2022 10:33:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap1.suse-dmz.suse.de with ESMTPSA id kFxhOeaCiGN5MAAAGKfGzw
 (envelope-from <mwilck@suse.com>); Thu, 01 Dec 2022 10:33:10 +0000
From: mwilck@suse.com
To: Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Thu,  1 Dec 2022 11:32:38 +0100
Message-Id: <20221201103238.2601-2-mwilck@suse.com>
In-Reply-To: <20221201103238.2601-1-mwilck@suse.com>
References: <20221201103238.2601-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH 2/2] multipath.conf(5): improve documentation of
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
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>,
 Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

The statement that the default is 600 is wrong in most cases.
Improve the description of the default and the dependency of this
parameter on other parameters.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 37 +++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 41a0112..fc7434c 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -707,21 +707,34 @@ The default is: \fB5\fR
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
+Specify the number of seconds the SCSI layer will wait after a connection loss has
+been detected on a remote port before removing it from the system. This
+can be set to "infinity", which effectively means 136 years (2^32-1 seconds).
+This parameter is only applied to Fibre Channel and SAS devices.
 .RS
-.TP
-The default is: \fB600\fR
+.LP
+The value of \fIdev_loss_tmo\fR is restricted by other settings.
+If \fIfast_io_fail_tmo\fR is set to a positive value,
+.B multipathd
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
+The default is: \fBhardware dependent\fR. Fibre Channel and SAS devices have
+hardware-dependent defaults, which are left unchanged if \fIdev_loss_tmo\fR is
+not specified. For a few storage arrays, the multipath-tools built-in settings
+override the default. Run \fImultipath -T\fR to see the settings for your device.
 .RE
 .
-.
 .TP
 .B eh_deadline
 Specify the maximum number of seconds the SCSI layer will spend doing error
-- 
2.38.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


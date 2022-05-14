Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74D2CC433EF
	for <dm-devel@archiver.kernel.org>; Sat, 14 May 2022 23:02:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-5iOOSIHWPd2ExTGbLn0MaQ-1; Sat, 14 May 2022 19:02:07 -0400
X-MC-Unique: 5iOOSIHWPd2ExTGbLn0MaQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7678C801210;
	Sat, 14 May 2022 23:02:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D54BF40D2820;
	Sat, 14 May 2022 23:02:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8ED87194704E;
	Sat, 14 May 2022 23:02:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 72CF41947040
 for <dm-devel@listman.corp.redhat.com>; Sat, 14 May 2022 23:02:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3ED0540D2822; Sat, 14 May 2022 23:02:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3A19340D2820
 for <dm-devel@redhat.com>; Sat, 14 May 2022 23:02:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0F91D1C04B76
 for <dm-devel@redhat.com>; Sat, 14 May 2022 23:02:01 +0000 (UTC)
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com
 [209.85.221.44]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-25-A5_DD01UP_evIX3SOvTxlA-1; Sat, 14 May 2022 19:01:59 -0400
X-MC-Unique: A5_DD01UP_evIX3SOvTxlA-1
Received: by mail-wr1-f44.google.com with SMTP id i5so15900423wrc.13;
 Sat, 14 May 2022 16:01:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=kJAc/DrKegqabgbDL6r4SdFBXYULb2nqHrbnunioEnc=;
 b=69D+lrXmbg8XyFp4TkrnB4rq4Bgpktu8bx+tqfO7T1/XWX2wtGqq7Si+jHzKmRXsJ6
 9dzRkyw3ytZL1NPCT8Pd3+JPXRrUqGN5xmIotCTb01V7hiXZh0UV6e2KdVTotL9AupO1
 moLNjNCCnvdpFPcShc7IRV7WjQ03KpYP4sN4D8J4fwwVc0vq9yxp6aiBPoNDuftuPAw7
 oaeeG5Q6p0toGMcc2Q2Ys49GeLir3CYzupR4eBts9vtKrBk02v2RZTjP7mTFPDl4S8y4
 GLFUjcn3nPbpe1JaILp9QjL958Lb5CxhcCcN+8fc1D2hhvwdxHPZ3mzNPDrolBCUpBnO
 dORw==
X-Gm-Message-State: AOAM531iuwUY0G9gWQU1gG5pXW6vvHHqxaIu82ehQ6+vbvn5fkqYnuih
 USV7WoueeVIXit+JbZC0UA==
X-Google-Smtp-Source: ABdhPJyhbRv0XzdxF4V6ngWibeDS4V7I80FBckP/EL8Qf/0mqxlfRRtFUgogq1234Z2dXJu69UsJyw==
X-Received: by 2002:a05:6000:1f91:b0:20c:54e5:fbbb with SMTP id
 bw17-20020a0560001f9100b0020c54e5fbbbmr8874445wrb.557.1652569317832; 
 Sat, 14 May 2022 16:01:57 -0700 (PDT)
Received: from localhost (50.red-81-44-142.dynamicip.rima-tde.net.
 [81.44.142.50]) by smtp.gmail.com with ESMTPSA id
 w5-20020adfe045000000b0020c5253d8f5sm5694423wrh.65.2022.05.14.16.01.57
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 14 May 2022 16:01:57 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Sun, 15 May 2022 01:01:40 +0200
Message-Id: <20220514230148.139675-2-xose.vazquez@gmail.com>
In-Reply-To: <20220514230148.139675-1-xose.vazquez@gmail.com>
References: <20220514230148.139675-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [PATCH 1/9] multipath-tools: fix misspellings
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
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>,
 DM-DEVEL ML <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 README.md                       | 2 +-
 libmultipath/checkers/rdac.c    | 2 +-
 libmultipath/prioritizers/iet.c | 2 +-
 multipath/multipath.conf.5      | 2 +-
 tests/directio.c                | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/README.md b/README.md
index d67888d9..f06f8cea 100644
--- a/README.md
+++ b/README.md
@@ -80,7 +80,7 @@ The following variables can be passed to the `make` command line:
 	The default is `/etc/multipath/conf.d`.
  * `ENABLE_LIBDMMP=0`: disable building libdmmp
  * `ENABLE_DMEVENTS_POLL=0`: disable support for the device-mapper event
-   polling API. For use with pre-5.0 kernels that don't supprt dmevent polling
+   polling API. For use with pre-5.0 kernels that don't support dmevent polling
    (but even if you don't use this option, multipath-tools will work with
    these kernels).
  * `SCSI_DH_MODULES_PRELOAD="(list)"`: specify a space-separated list of SCSI
diff --git a/libmultipath/checkers/rdac.c b/libmultipath/checkers/rdac.c
index d924a9f7..f7aaa30a 100644
--- a/libmultipath/checkers/rdac.c
+++ b/libmultipath/checkers/rdac.c
@@ -96,7 +96,7 @@ int libcheck_init (struct checker * c)
 		goto out;
 	}
 
-	/* get the changeble values */
+	/* get the changeable values */
 	cmd[2] = 0xA + (CHANGEABLE_PAGE_CODE_VALUES << 6);
 	io_hdr.dxferp = &changeable;
 	memset(&changeable, 0, sizeof(struct control_mode_page));
diff --git a/libmultipath/prioritizers/iet.c b/libmultipath/prioritizers/iet.c
index e98773cf..167a46b0 100644
--- a/libmultipath/prioritizers/iet.c
+++ b/libmultipath/prioritizers/iet.c
@@ -31,7 +31,7 @@
 // name: find_regex
 // @param string: string you want to search into
 // @param regex: the pattern used
-// @return result: string finded in string with regex, "none" if none
+// @return result: string found in string with regex, "none" if none
 char *find_regex(char * string, char * regex)
 {
 	int err;
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index fe838e38..d57c810b 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -1759,7 +1759,7 @@ The protocol string of the path device. The possible values are \fIscsi:fcp\fR,
 \fIscsi:spi\fR, \fIscsi:ssa\fR, \fIscsi:sbp\fR, \fIscsi:srp\fR,
 \fIscsi:iscsi\fR, \fIscsi:sas\fR, \fIscsi:adt\fR, \fIscsi:ata\fR,
 \fIscsi:unspec\fR, \fIccw\fR, \fIcciss\fR, \fInvme\fR, and \fIundef\fR. This is
-\fBnot\fR a regular expression. the path device protcol string must match
+\fBnot\fR a regular expression. the path device protocol string must match
 exactly. The protocol that a path is using can be viewed by running
 \fBmultipathd show paths format "%d %P"\fR
 .LP
diff --git a/tests/directio.c b/tests/directio.c
index 9f7d3883..20ccc47a 100644
--- a/tests/directio.c
+++ b/tests/directio.c
@@ -693,7 +693,7 @@ static void test_check_state_blksize(void **state)
 	do_libcheck_reset(1);
 }
 
-/* test async checkers pending and getting resovled by another checker
+/* test async checkers pending and getting resolved by another checker
  * as well as the loops for getting multiple events */
 static void test_check_state_async(void **state)
 {
-- 
2.36.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


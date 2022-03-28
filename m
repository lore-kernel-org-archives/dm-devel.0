Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBD7EC433FE
	for <dm-devel@archiver.kernel.org>; Tue, 29 Mar 2022 05:32:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-A76jjYdjOwKIOX5H7AKCcA-1; Tue, 29 Mar 2022 01:32:07 -0400
X-MC-Unique: A76jjYdjOwKIOX5H7AKCcA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5FAE4100BAAC;
	Tue, 29 Mar 2022 05:32:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C51C8141DC28;
	Tue, 29 Mar 2022 05:32:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D14D8193F6E1;
	Tue, 29 Mar 2022 05:32:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 90F8A1947BBE
 for <dm-devel@listman.corp.redhat.com>; Mon, 28 Mar 2022 11:18:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 74FACC15D4F; Mon, 28 Mar 2022 11:18:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 71697C15D40
 for <dm-devel@redhat.com>; Mon, 28 Mar 2022 11:18:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 568B9811E76
 for <dm-devel@redhat.com>; Mon, 28 Mar 2022 11:18:27 +0000 (UTC)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com
 [209.85.167.43]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-297-XXebSoSqMNqd-cqy53PxLg-1; Mon, 28 Mar 2022 07:18:25 -0400
X-MC-Unique: XXebSoSqMNqd-cqy53PxLg-1
Received: by mail-lf1-f43.google.com with SMTP id bu29so24193206lfb.0
 for <dm-devel@redhat.com>; Mon, 28 Mar 2022 04:18:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:from:to:date:message-id:in-reply-to
 :references:user-agent:mime-version:content-transfer-encoding;
 bh=Mr3I0zTOmgfpQLSBDag6X3RkoBkoQu16gRVM9S+AEJk=;
 b=7PaH01feeOr/CBBKy1ryEZ9LMgpgxBn2hvWVoWkgKq82XSffDJ0YzymwIvyF6AkgHw
 TFwyDp0OUuXDHBGZy3fI7XPyvxuU4nFoTFlEsned5vs01YIhjc7rIn+FcvhCTsfnA0ks
 qM5evQrr4Y7l7ssKaihRDm9cWFM8er7Bk+WogflgetF1/EXksVoHWHlrZJLYsVi3mTvF
 79ZmbSUbmNVjy3UcXrDK5mgegWKiS3lqdD0jANTwoMOLSUBAItTo2drH8SZXNcH2xFLD
 zJaxzo/wLQEpxjG+uAAUrUUykQDcZC5xnLAzuaSsAQ9p3SFWV3v2iLSCRZos/OxJ4VFz
 efPw==
X-Gm-Message-State: AOAM533f9x63DwggHMDqV8nZzUs2TADYQKj+3xIP4zb5qthgckDsohDG
 eQBVuQbdhHAkh2b9GLteiC62GcDzet9Y3PRI
X-Google-Smtp-Source: ABdhPJyEoLfTVx81uIbeqr52bd0IdNg687n+trzkDyCfYVD8GcWwCIe94C+hoM3YaYIuscSMh9fFmA==
X-Received: by 2002:a19:654c:0:b0:448:2649:1169 with SMTP id
 c12-20020a19654c000000b0044826491169mr19369641lfj.555.1648466303868; 
 Mon, 28 Mar 2022 04:18:23 -0700 (PDT)
Received: from [127.0.1.1] ([2.92.192.17]) by smtp.gmail.com with ESMTPSA id
 j15-20020a056512108f00b0044a3cc8769dsm1603648lfg.123.2022.03.28.04.18.23
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 28 Mar 2022 04:18:23 -0700 (PDT)
From: Kirill Tkhai <kirill.tkhai@openvz.org>
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, song@kernel.org, 
 linux-kernel@vger.kernel.org, khorenko@virtuozzo.com,
 kirill.tkhai@openvz.org
Date: Mon, 28 Mar 2022 14:18:22 +0300
Message-ID: <164846630280.251310.15762330533681496392.stgit@pro>
In-Reply-To: <164846619932.251310.3668540533992131988.stgit@pro>
References: <164846619932.251310.3668540533992131988.stgit@pro>
User-Agent: StGit/1.5
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mailman-Approved-At: Tue, 29 Mar 2022 05:32:01 +0000
Subject: [dm-devel] [PATCH 1/4] dm: Export dm_complete_request()
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This function is required for dm-qcow2 driver going in next patches.
The driver transforms block requests into file operations on underlining
file in QCOW2 format (like loop but over QCOW2 instead of RAW file).
We need to have a possibility to complete a request after corresponding
file operations are finished.

Signed-off-by: Kirill Tkhai <kirill.tkhai@openvz.org>
---
 drivers/md/dm-rq.c |    3 ++-
 drivers/md/dm-rq.h |    2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 579ab6183d4d..1b9a633efe37 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -275,7 +275,7 @@ static void dm_softirq_done(struct request *rq)
  * Complete the clone and the original request with the error status
  * through softirq context.
  */
-static void dm_complete_request(struct request *rq, blk_status_t error)
+void dm_complete_request(struct request *rq, blk_status_t error)
 {
 	struct dm_rq_target_io *tio = tio_from_request(rq);
 
@@ -283,6 +283,7 @@ static void dm_complete_request(struct request *rq, blk_status_t error)
 	if (likely(!blk_should_fake_timeout(rq->q)))
 		blk_mq_complete_request(rq);
 }
+EXPORT_SYMBOL(dm_complete_request);
 
 /*
  * Complete the not-mapped clone and the original request with the error status
diff --git a/drivers/md/dm-rq.h b/drivers/md/dm-rq.h
index 1eea0da641db..56156738d1b4 100644
--- a/drivers/md/dm-rq.h
+++ b/drivers/md/dm-rq.h
@@ -44,4 +44,6 @@ ssize_t dm_attr_rq_based_seq_io_merge_deadline_show(struct mapped_device *md, ch
 ssize_t dm_attr_rq_based_seq_io_merge_deadline_store(struct mapped_device *md,
 						     const char *buf, size_t count);
 
+void dm_complete_request(struct request *rq, blk_status_t error);
+
 #endif


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


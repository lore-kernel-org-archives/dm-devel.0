Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CF45C74A5B
	for <dm-devel@archiver.kernel.org>; Thu, 23 Mar 2023 08:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679559614;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=fkHm5ZGnQO/BRR+FiUs7woVFW2V0G5Ukve+fnZ5mZjU=;
	b=EYsBVM+VbDotDgWbi6U0ky77mMET8WV0kt/qWTNoET4xfRy2T8q+xAZmvVJSfr36aLZCPp
	ut76a+aNhGKLRS+285cKwN2WiFVpto2u5vdEQNcB1dwYsgY//QZDGVaEErvtsqC2hOPHYE
	MmAlAnMQWBuJE7Mmb0cHviQHTCwDPLI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-39-5fQNFQubPUS69wwh0Fv48Q-1; Thu, 23 Mar 2023 04:20:11 -0400
X-MC-Unique: 5fQNFQubPUS69wwh0Fv48Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1154129ABA1C;
	Thu, 23 Mar 2023 08:20:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B6D82483EC4;
	Thu, 23 Mar 2023 08:20:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9B9851946589;
	Thu, 23 Mar 2023 08:20:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4C4A61946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 23 Mar 2023 08:20:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2F602C15BAD; Thu, 23 Mar 2023 08:20:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 25C2EC15BA0
 for <dm-devel@redhat.com>; Thu, 23 Mar 2023 08:20:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 52DDD85C06A
 for <dm-devel@redhat.com>; Thu, 23 Mar 2023 08:20:06 +0000 (UTC)
Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-339-2uoCbVrgMh6fbrOUnGzLYw-1; Thu,
 23 Mar 2023 04:20:03 -0400
X-MC-Unique: 2uoCbVrgMh6fbrOUnGzLYw-1
From: Sam James <sam@gentoo.org>
To: christophe.varoqui@opensvc.com,
	dm-devel@redhat.com
Date: Thu, 23 Mar 2023 08:12:56 +0000
Message-Id: <20230323081256.904460-1-sam@gentoo.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH] tests: fix quoting of CFLAGS in Makefile
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
Cc: mwilck@suse.com, Sam James <sam@gentoo.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gentoo.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Otherwise, when CFLAGS/CPPFLAGS have multiple entries (like "-O2 -pipe"), we
get an error:
```
make[1]: Entering directory '/var/tmp/portage/sys-fs/multipath-tools-0.9.4/work/multipath-tools-0.9.4/tests'
/bin/sh: line 1: -pipe: command not found
make[1]: *** [Makefile:115: libmultipath.so.0] Error 127
make[1]: *** Waiting for unfinished jobs....
```

Signed-off-by: Sam James <sam@gentoo.org>
---
 tests/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/Makefile b/tests/Makefile
index 1648ab9d..83edc2f0 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -112,7 +112,7 @@ dep_clean:
 # Pass the original values of CFLAGS etc. to the sub-make, which will include
 # Makefile.in again. Otherwise, the flags would be added twice.
 libmultipath.so.0: $(multipathdir)/libmultipath.so.0
-	@CFLAGS=$(ORIG_CFLAGS) CPPFLAGS=$(ORIG_CPPFLAGS) LDFLAGS=$(ORIG_LDFLAGS) \
+	@CFLAGS="$(ORIG_CFLAGS)" CPPFLAGS="$(ORIG_CPPFLAGS)" LDFLAGS="$(ORIG_LDFLAGS)" \
 	$(MAKE) -C $(multipathdir) configdir=$(TESTDIR)/conf.d plugindir=$(TESTDIR)/lib test-lib
 
 # COLON will get expanded during second expansion below
-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


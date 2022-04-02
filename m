Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED85DC433F5
	for <dm-devel@archiver.kernel.org>; Sat,  2 Apr 2022 16:26:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-554-3prg2KseM3SkPnkuj0FBFg-1; Sat, 02 Apr 2022 12:26:08 -0400
X-MC-Unique: 3prg2KseM3SkPnkuj0FBFg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DE7FA29AA389;
	Sat,  2 Apr 2022 16:26:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 71BA2416392;
	Sat,  2 Apr 2022 16:26:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3541C1940360;
	Sat,  2 Apr 2022 16:26:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F1E8A194035F
 for <dm-devel@listman.corp.redhat.com>; Sat,  2 Apr 2022 16:26:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8145D2167D98; Sat,  2 Apr 2022 16:26:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7C7D82167D74
 for <dm-devel@redhat.com>; Sat,  2 Apr 2022 16:25:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 691443841D20
 for <dm-devel@redhat.com>; Sat,  2 Apr 2022 16:25:59 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-192-mQ4_MdlWPaGTFJN0iDxusw-1; Sat, 02 Apr 2022 12:25:57 -0400
X-MC-Unique: mQ4_MdlWPaGTFJN0iDxusw-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 28E4BB80A72;
 Sat,  2 Apr 2022 16:25:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4395CC340EC;
 Sat,  2 Apr 2022 16:25:54 +0000 (UTC)
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	shraash@google.com
Date: Sat,  2 Apr 2022 12:25:52 -0400
Message-Id: <20220402162552.2145431-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: [dm-devel] Patch "dm crypt: fix get_key_size compiler warning if
 !CONFIG_KEYS" has been added to the 5.10-stable tree
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This is a note to let you know that I've just added the patch titled

    dm crypt: fix get_key_size compiler warning if !CONFIG_KEYS

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-crypt-fix-get_key_size-compiler-warning-if-config.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 386277fc8a2d1ee583d1230bc48f4dd9952ea666
Author: Aashish Sharma <shraash@google.com>
Date:   Fri Feb 11 12:15:38 2022 +0000

    dm crypt: fix get_key_size compiler warning if !CONFIG_KEYS
    
    [ Upstream commit 6fc51504388c1a1a53db8faafe9fff78fccc7c87 ]
    
    Explicitly convert unsigned int in the right of the conditional
    expression to int to match the left side operand and the return type,
    fixing the following compiler warning:
    
    drivers/md/dm-crypt.c:2593:43: warning: signed and unsigned
    type in conditional expression [-Wsign-compare]
    
    Fixes: c538f6ec9f56 ("dm crypt: add ability to use keys from the kernel key retention service")
    Signed-off-by: Aashish Sharma <shraash@google.com>
    Signed-off-by: Mike Snitzer <snitzer@redhat.com>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 2aa4acd33af3..b9677f701b6a 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2561,7 +2561,7 @@ static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string
 
 static int get_key_size(char **key_string)
 {
-	return (*key_string[0] == ':') ? -EINVAL : strlen(*key_string) >> 1;
+	return (*key_string[0] == ':') ? -EINVAL : (int)(strlen(*key_string) >> 1);
 }
 
 #endif /* CONFIG_KEYS */

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


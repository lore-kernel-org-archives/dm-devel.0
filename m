Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E24FFC433EF
	for <dm-devel@archiver.kernel.org>; Sat,  2 Apr 2022 16:00:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-642-s4bZxLXmPE6ENntPw3pIZA-1; Sat, 02 Apr 2022 12:00:10 -0400
X-MC-Unique: s4bZxLXmPE6ENntPw3pIZA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 64AF32A59560;
	Sat,  2 Apr 2022 16:00:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E2C4940D3F60;
	Sat,  2 Apr 2022 16:00:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 399821940360;
	Sat,  2 Apr 2022 16:00:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C78B6194035F
 for <dm-devel@listman.corp.redhat.com>; Sat,  2 Apr 2022 16:00:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 51CE441638A; Sat,  2 Apr 2022 16:00:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4E0F8416389
 for <dm-devel@redhat.com>; Sat,  2 Apr 2022 16:00:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3524E8002BF
 for <dm-devel@redhat.com>; Sat,  2 Apr 2022 16:00:04 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-D5KGNdf2PCOLU2Bz3h4BlQ-1; Sat, 02 Apr 2022 12:00:02 -0400
X-MC-Unique: D5KGNdf2PCOLU2Bz3h4BlQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 5919E616D3;
 Sat,  2 Apr 2022 16:00:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3258BC340EC;
 Sat,  2 Apr 2022 16:00:00 +0000 (UTC)
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	shraash@google.com
Date: Sat,  2 Apr 2022 11:59:58 -0400
Message-Id: <20220402155958.2126663-1-sashal@kernel.org>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: [dm-devel] Patch "dm crypt: fix get_key_size compiler warning if
 !CONFIG_KEYS" has been added to the 5.15-stable tree
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This is a note to let you know that I've just added the patch titled

    dm crypt: fix get_key_size compiler warning if !CONFIG_KEYS

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-crypt-fix-get_key_size-compiler-warning-if-config.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 6954134a6c27ec27652e6ceebf039425a6cae70a
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
index 916b7da16de2..154139bf7d22 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2579,7 +2579,7 @@ static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string
 
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


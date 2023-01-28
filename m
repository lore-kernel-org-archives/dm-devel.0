Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D38AC54EAA
	for <dm-devel@archiver.kernel.org>; Mon, 30 Jan 2023 07:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675062180;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6y2f7qVnmjfGPp9hLkMqNOwcmyFNzs5nK6JltpIvMlU=;
	b=clpm8Ba5Pv3aQmnTiePmf1DX4e8qWcLw8lzeP4j5pqHdmqR7YqXPethKnLbCWOFoONGauJ
	ptgyAcBgi9knE210lCmaQ37qINgb+DPen1p5DyEH5l9tpfiXHSMCfbcwCxU0N8hs6pok7I
	UCzRUf1oPhzNOW3Z1xYXgpIeSBNXWLM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-381-YWJCqHX0NzC2h7SI7nvw1A-1; Mon, 30 Jan 2023 02:02:56 -0500
X-MC-Unique: YWJCqHX0NzC2h7SI7nvw1A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 841C485A5B1;
	Mon, 30 Jan 2023 07:02:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F3344C15BAD;
	Mon, 30 Jan 2023 07:02:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3F9631946588;
	Mon, 30 Jan 2023 07:02:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 742D51946587
 for <dm-devel@listman.corp.redhat.com>; Sat, 28 Jan 2023 15:50:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 64BB91121315; Sat, 28 Jan 2023 15:50:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5D5871121314
 for <dm-devel@redhat.com>; Sat, 28 Jan 2023 15:50:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 422F7800B30
 for <dm-devel@redhat.com>; Sat, 28 Jan 2023 15:50:40 +0000 (UTC)
Received: from smtp.smtpout.orange.fr (smtp-14.smtpout.orange.fr
 [80.12.242.14]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 us-mta-207-XKMGJiSeMZq4EGUnhKnSbQ-1; Sat, 28 Jan 2023 10:50:38 -0500
X-MC-Unique: XKMGJiSeMZq4EGUnhKnSbQ-1
Received: from pop-os.home ([86.243.2.178]) by smtp.orange.fr with ESMTPA
 id LnM9phWDqeUnHLnM9p9nzv; Sat, 28 Jan 2023 16:43:06 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 28 Jan 2023 16:43:06 +0100
X-ME-IP: 86.243.2.178
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com
Date: Sat, 28 Jan 2023 16:43:00 +0100
Message-Id: <c3d25e24503d9e625cf46e9fb4ee55f10bfdd398.1674920529.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Mon, 30 Jan 2023 07:02:37 +0000
Subject: [dm-devel] [PATCH] dm-crypt: Slightly simplify
 crypt_set_keyring_key()
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
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
 kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Use strchr() instead of strpbrk() when there is only 1 element in the set
of characters to look for.
This potentially saves a few cycles.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
On my machine, the diff of the .s file shows that the generated code is
the same:

-- drivers/md/dm-crypt.old.s	2023-01-28 16:28:08.968026902 +0100
++ drivers/md/dm-crypt.s	2023-01-28 16:28:32.056027335 +0100
@@ -17950,7 +17950,7 @@
 	call	__sanitizer_cov_trace_const_cmp1	#
 	testb	%bl, %bl	# _56
 	jne	.L928	#,
-# drivers/md/dm-crypt.c:2490: 	key_desc = strpbrk(key_string, ":");
+# drivers/md/dm-crypt.c:2490: 	key_desc = strchr(key_string, ':');
 	call	__sanitizer_cov_trace_pc	#
 	movl	$58, %esi	#,
 	movq	%r12, %rdi	# key_string,

This is done thanks to fold_builtin_strpbrk() in gcc which already
transforms such patterns.
(https://github.com/gcc-mirror/gcc/blob/master/gcc/builtins.cc#L10238)
---
 drivers/md/dm-crypt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 2653516bcdef..b9c41fd42e8a 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2487,7 +2487,7 @@ static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string
 	}
 
 	/* look for next ':' separating key_type from key_description */
-	key_desc = strpbrk(key_string, ":");
+	key_desc = strchr(key_string, ':');
 	if (!key_desc || key_desc == key_string || !strlen(key_desc + 1))
 		return -EINVAL;
 
-- 
2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


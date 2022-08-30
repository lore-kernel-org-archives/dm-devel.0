Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0833ECAAD1
	for <dm-devel@archiver.kernel.org>; Wed, 31 Aug 2022 16:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661962169;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=wyxGbdZ6ossLkXOBr7oALIYJqUO6cViqstL3oZHX8jM=;
	b=e1XbJXVEUZBU7yqCygog9v/a65H4exKK5FApqVgUMnXxUORo46LlT6peqNig7WZ2YIbkiD
	J4iJ9Kbt8OdZ8B/V13QgEJWeCdfHC0k5GykmKY3RxtuOs4MPllUeDi439GhtR2RUjRoaEH
	uy1XBgcjrqgks1mUB1x+590Iia1cWVM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-131-miMpd3ViMG6HWnOjB4LoVg-1; Wed, 31 Aug 2022 12:09:26 -0400
X-MC-Unique: miMpd3ViMG6HWnOjB4LoVg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EFEC538173D6;
	Wed, 31 Aug 2022 16:09:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CF5C22166B26;
	Wed, 31 Aug 2022 16:09:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 999191946A5E;
	Wed, 31 Aug 2022 16:09:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D36921946A40
 for <dm-devel@listman.corp.redhat.com>; Tue, 30 Aug 2022 15:37:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B7063492C3B; Tue, 30 Aug 2022 15:37:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B39B1401473
 for <dm-devel@redhat.com>; Tue, 30 Aug 2022 15:37:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9CB9F85A58B
 for <dm-devel@redhat.com>; Tue, 30 Aug 2022 15:37:18 +0000 (UTC)
Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.154.221.58]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-119-rImb28H_N-WYjY4ZjC6Zhw-1; Tue, 30 Aug 2022 11:37:16 -0400
X-MC-Unique: rImb28H_N-WYjY4ZjC6Zhw-1
X-QQ-mid: bizesmtp70t1661873633t77pc55n
Received: from localhost.localdomain ( [182.148.13.26])
 by bizesmtp.qq.com (ESMTP) with 
 id ; Tue, 30 Aug 2022 23:33:52 +0800 (CST)
X-QQ-SSF: 01000000002000D0E000B00A0000000
X-QQ-FEAT: clvrxl8qrW5NfTa6nDrmlsgYdEBTLnYi+F+F82Xvu2S8KhQU4rjrlODVQOa4u
 6Aa3el1z8IqH1FdPwOfr3VpKtznPYY7nbN8/WMxpQOql35GhzFd0RqQTr7a5a6ptzH3EI85
 0CjGKq1TZAk+Re2IjEu62PBh7S37kUO0CepEIdI363gg+3aqV8wa5ZrIGBZdtn6SW21M1YM
 BOcvJvxU/ks4WFft0w7iMSkutVA5Nxwn7LzPSO2gjughqUgISumebv8siHUZuFTPHilR7Xp
 fDMpP+4nueCmnqK9fLrd7D/8Ldu8u10upYsnvmy7HZw6C/wlhsgaG75qoSF1HhxsNRLk50w
 FmJhyPpEdrAjOyJ2xhZZH2XYj0P9e3Icy2BasSXcwcC9bEVEz80wdLHLaGx+g==
X-QQ-GoodBg: 0
From: Jilin Yuan <yuanjilin@cdjrlc.com>
To: agk@redhat.com,
	snitzer@kernel.org
Date: Tue, 30 Aug 2022 23:33:45 +0800
Message-Id: <20220830153345.18687-1-yuanjilin@cdjrlc.com>
MIME-Version: 1.0
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mailman-Approved-At: Wed, 31 Aug 2022 15:48:15 +0000
Subject: [dm-devel] [PATCH] md: fix repeated words in comments
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
Cc: dm-devel@redhat.com, Jilin Yuan <yuanjilin@cdjrlc.com>,
 linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Delete the redundant word 'that'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/md/dm-raid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index c640be453313..e448fd45a914 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2529,7 +2529,7 @@ static int analyse_superblocks(struct dm_target *ti, struct raid_set *rs)
 		 * of the "sync" directive.
 		 *
 		 * With reshaping capability added, we must ensure that
-		 * that the "sync" directive is disallowed during the reshape.
+		 * the "sync" directive is disallowed during the reshape.
 		 */
 		if (test_bit(__CTR_FLAG_SYNC, &rs->ctr_flags))
 			continue;
-- 
2.36.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


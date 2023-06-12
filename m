Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77D6AC77B7A
	for <dm-devel@archiver.kernel.org>; Tue, 13 Jun 2023 12:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686658680;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=cCTdwj6y38bMbpYMbG1ex/0lVY16hH6gfogZ8kq+7vg=;
	b=aZ5dy5TMMPrSB5w9k6ZEK5fCcqaYCdTpZNTxLGGd19rA1lcNdT53AgS/xJ+OYtWoeHz2Fk
	lW8vZZ/9ZXsQemba1BD8pBPm2aqe/9+0XGtlPFrLG7e+6j0f6t5IuctStzGqay/Sx7zkWq
	LJ4b6fFmo7b5/0rixuIT8/cmcxqvPwQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-ilWCMzEtOaejl_ugq7JssQ-1; Tue, 13 Jun 2023 08:17:58 -0400
X-MC-Unique: ilWCMzEtOaejl_ugq7JssQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 857D5858F18;
	Tue, 13 Jun 2023 12:17:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6B8CC202F356;
	Tue, 13 Jun 2023 12:17:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9FE2C19451C2;
	Tue, 13 Jun 2023 12:17:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1B8E7194658C
 for <dm-devel@listman.corp.redhat.com>; Mon, 12 Jun 2023 21:48:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BB5E340C20F6; Mon, 12 Jun 2023 21:48:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B460440C20F5
 for <dm-devel@redhat.com>; Mon, 12 Jun 2023 21:48:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 96C9B3C11C6B
 for <dm-devel@redhat.com>; Mon, 12 Jun 2023 21:48:58 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-8-K1WzX5OhO6-fuPz2d1HiWQ-1; Mon, 12 Jun 2023 17:48:56 -0400
X-MC-Unique: K1WzX5OhO6-fuPz2d1HiWQ-1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="386559454"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; d="scan'208";a="386559454"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
 by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 12 Jun 2023 14:47:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="714538602"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; d="scan'208";a="714538602"
Received: from black.fi.intel.com ([10.237.72.28])
 by fmsmga007.fm.intel.com with ESMTP; 12 Jun 2023 14:47:43 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
 id 390A5357; Tue, 13 Jun 2023 00:47:51 +0300 (EEST)
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Mike Snitzer <snitzer@kernel.org>, Heinz Mauelshagen <heinzm@redhat.com>,
 dm-devel@redhat.com, linux-kernel@vger.kernel.org
Date: Tue, 13 Jun 2023 00:47:51 +0300
Message-Id: <20230612214751.9662-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Tue, 13 Jun 2023 12:17:46 +0000
Subject: [dm-devel] [PATCH v1 1/1] dm integrity: Use %*ph for printing
 hexdump of a small buffer
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
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.intel.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The kernel already has a helper to print a hexdump of a small
buffer via pointer extension. Use that instead of open coded
variant.

In long term it helps to kill pr_cont() or at least narrow down
its use.

Note, the format is slightly changed, i.e. the colon is not printed
before the buffer dump and the trailing space is always printed.
These are not a problem since it's a debug message. Also the IV dump
is limited by 64 bytes which seems fine.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/md/dm-integrity.c | 23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 63ec502fcb12..e5b9a6bab3dd 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -342,24 +342,8 @@ static struct kmem_cache *journal_io_cache;
 #define JOURNAL_IO_MEMPOOL	32
 
 #ifdef DEBUG_PRINT
-#define DEBUG_print(x, ...)	printk(KERN_DEBUG x, ##__VA_ARGS__)
-static void __DEBUG_bytes(__u8 *bytes, size_t len, const char *msg, ...)
-{
-	va_list args;
-
-	va_start(args, msg);
-	vprintk(msg, args);
-	va_end(args);
-	if (len)
-		pr_cont(":");
-	while (len) {
-		pr_cont(" %02x", *bytes);
-		bytes++;
-		len--;
-	}
-	pr_cont("\n");
-}
-#define DEBUG_bytes(bytes, len, msg, ...)	__DEBUG_bytes(bytes, len, KERN_DEBUG msg, ##__VA_ARGS__)
+#define DEBUG_print(x, ...)			printk(KERN_DEBUG x, ##__VA_ARGS__)
+#define DEBUG_bytes(bytes, len, msg, ...)	printk(KERN_DEBUG msg " %*ph\n", ##__VA_ARGS__, len, bytes)
 #else
 #define DEBUG_print(x, ...)			do { } while (0)
 #define DEBUG_bytes(bytes, len, msg, ...)	do { } while (0)
@@ -3781,8 +3765,9 @@ static int create_journal(struct dm_integrity_c *ic, char **error)
 		goto bad;
 	}
 	if (ic->journal_crypt_alg.alg_string) {
-		unsigned int ivsize, blocksize;
 		struct journal_completion comp;
+		unsigned int blocksize;
+		int ivsize;
 
 		comp.ic = ic;
 		ic->journal_crypt = crypto_alloc_skcipher(ic->journal_crypt_alg.alg_string, 0, CRYPTO_ALG_ALLOCATES_MEMORY);
-- 
2.40.0.1.gaa8946217a0b

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


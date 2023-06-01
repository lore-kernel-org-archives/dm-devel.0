Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 939AEC77B7E
	for <dm-devel@archiver.kernel.org>; Thu,  1 Jun 2023 08:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685609276;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=nPluHQGOOFjR+JIH8c902tWadf7/L4fT4I80kTBGgBI=;
	b=O0rh8+KSkyF8rXg1qKvz989deKctODStWJdA30papY/8qXyhy/e7HnZETgV53lPeR+IlOm
	NqfcHGCkpHsttjy6Zc2ugcc+1BrWEBvK2v34UZ1Zk21taWLMWfI7m3UZ7d9dMQ9w9l2Igh
	7da3HhYc8WjWm4mqo8TeVST7d/QPghk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-249-FHt6J89fOtKtrtEFWtexZw-1; Thu, 01 Jun 2023 04:47:52 -0400
X-MC-Unique: FHt6J89fOtKtrtEFWtexZw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A666A8039B6;
	Thu,  1 Jun 2023 08:47:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0C86F2166B25;
	Thu,  1 Jun 2023 08:47:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AE290194E11D;
	Thu,  1 Jun 2023 08:47:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9322E194E11C
 for <dm-devel@listman.corp.redhat.com>; Thu,  1 Jun 2023 08:47:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 656BD40C6CD8; Thu,  1 Jun 2023 08:47:47 +0000 (UTC)
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (unknown
 [10.67.24.65])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1904840C6EC4;
 Thu,  1 Jun 2023 08:47:47 +0000 (UTC)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
 by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
 id 1q4dyB-00Fb2R-Cb; Thu, 01 Jun 2023 16:47:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation);
 Thu, 01 Jun 2023 16:47:43 +0800
Date: Thu, 1 Jun 2023 16:47:43 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com
Message-ID: <ZHhbL+SbWRnTW4b7@gondor.apana.org.au>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] dm crypt: Avoid using MAX_CIPHER_BLOCKSIZE
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
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gondor.apana.org.au
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

MAX_CIPHER_BLOCKSIZE is an internal implementation detail and should
not be relied on by users of the Crypto API.

Instead of storing the IV on the stack, allocate it together with
the crypto request.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/md/dm-crypt.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 40cb1719ae4d..0e7e443dde11 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -31,10 +31,10 @@
 #include <asm/unaligned.h>
 #include <crypto/hash.h>
 #include <crypto/md5.h>
-#include <crypto/algapi.h>
 #include <crypto/skcipher.h>
 #include <crypto/aead.h>
 #include <crypto/authenc.h>
+#include <crypto/utils.h>
 #include <linux/rtnetlink.h> /* for struct rtattr and RTA macros only */
 #include <linux/key-type.h>
 #include <keys/user-type.h>
@@ -743,16 +743,23 @@ static int crypt_iv_eboiv_ctr(struct crypt_config *cc, struct dm_target *ti,
 static int crypt_iv_eboiv_gen(struct crypt_config *cc, u8 *iv,
 			    struct dm_crypt_request *dmreq)
 {
-	u8 buf[MAX_CIPHER_BLOCKSIZE] __aligned(__alignof__(__le64));
+	struct crypto_skcipher *tfm = any_tfm(cc);
 	struct skcipher_request *req;
 	struct scatterlist src, dst;
 	DECLARE_CRYPTO_WAIT(wait);
+	unsigned int reqsize;
 	int err;
+	u8 *buf;
 
-	req = skcipher_request_alloc(any_tfm(cc), GFP_NOIO);
+	reqsize = ALIGN(crypto_skcipher_reqsize(tfm), __alignof__(__le64));
+
+	req = kmalloc(reqsize + cc->iv_size, GFP_NOIO);
 	if (!req)
 		return -ENOMEM;
 
+	skcipher_request_set_tfm(req, tfm);
+
+	buf = (u8 *)req + reqsize;
 	memset(buf, 0, cc->iv_size);
 	*(__le64 *)buf = cpu_to_le64(dmreq->iv_sector * cc->sector_size);
 
@@ -761,7 +768,7 @@ static int crypt_iv_eboiv_gen(struct crypt_config *cc, u8 *iv,
 	skcipher_request_set_crypt(req, &src, &dst, cc->iv_size, buf);
 	skcipher_request_set_callback(req, 0, crypto_req_done, &wait);
 	err = crypto_wait_req(crypto_skcipher_encrypt(req), &wait);
-	skcipher_request_free(req);
+	kfree_sensitive(req);
 
 	return err;
 }
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


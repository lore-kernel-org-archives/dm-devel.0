Return-Path: <SRS0=ZA/Q=MS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8429FC4320A
	for <dm-devel@archiver.kernel.org>; Mon, 26 Jul 2021 07:08:21 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 93D9A60720
	for <dm-devel@archiver.kernel.org>; Mon, 26 Jul 2021 07:08:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 93D9A60720
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-577-fhu1A7b9NZecNbAQdGPonQ-1; Mon, 26 Jul 2021 03:08:16 -0400
X-MC-Unique: fhu1A7b9NZecNbAQdGPonQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 360A510060E2;
	Mon, 26 Jul 2021 07:08:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4C0255C1D0;
	Mon, 26 Jul 2021 07:08:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C29C44BB7C;
	Mon, 26 Jul 2021 07:08:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16M9boQr019458 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 22 Jul 2021 05:37:50 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 7E6212028671; Thu, 22 Jul 2021 09:37:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 79F7320BDB31
	for <dm-devel@redhat.com>; Thu, 22 Jul 2021 09:37:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B775101A529
	for <dm-devel@redhat.com>; Thu, 22 Jul 2021 09:37:47 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de
	[85.220.165.71]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-559-TtCDbPAvPzqF_HEdES5Xjw-1; Thu, 22 Jul 2021 05:37:45 -0400
X-MC-Unique: TtCDbPAvPzqF_HEdES5Xjw-1
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
	by metis.ext.pengutronix.de with esmtps
	(TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
	(envelope-from <afa@pengutronix.de>)
	id 1m6UqF-0001NO-DL; Thu, 22 Jul 2021 11:18:07 +0200
Received: from afa by dude.hi.pengutronix.de with local (Exim 4.92)
	(envelope-from <afa@pengutronix.de>)
	id 1m6UqC-0001D1-HE; Thu, 22 Jul 2021 11:18:04 +0200
From: Ahmad Fatoum <a.fatoum@pengutronix.de>
To: David Howells <dhowells@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	dm-devel@redhat.com, Song Liu <song@kernel.org>,
	Richard Weinberger <richard@nod.at>, Jonathan Corbet <corbet@lwn.net>
Date: Thu, 22 Jul 2021 11:18:02 +0200
Message-Id: <f5891611f329583baef32089c8b322850d81166a.1626945419.git-series.a.fatoum@pengutronix.de>
In-Reply-To: <cover.b2fdd70b830d12853b12a12e32ceb0c8162c1346.1626945419.git-series.a.fatoum@pengutronix.de>
References: <cover.b2fdd70b830d12853b12a12e32ceb0c8162c1346.1626945419.git-series.a.fatoum@pengutronix.de>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: afa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de);
	SAEximRunCond expanded to false
X-PTX-Original-Recipient: dm-devel@redhat.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 26 Jul 2021 03:08:04 -0400
Cc: Ahmad Fatoum <a.fatoum@pengutronix.de>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
	linux-mtd@lists.infradead.org, kernel@pengutronix.de,
	linux-integrity@vger.kernel.org
Subject: [dm-devel] [RFC PATCH v1 4/4] ubifs: auth: consult encrypted and
	trusted keys if no logon key was found
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Currently, UBIFS auth_key can only be a logon key: This is a user key
that's provided to the kernel in plaintext and that then remains within
the kernel. Linux also supports trusted and encrypted keys, which have
stronger guarantees: They are only exposed to userspace in encrypted
form and, in the case of trusted keys, can be directly rooted to a trust
source like a TPM chip.

Add support for auth_key to be either a logon, encrypted or trusted key.
At mount time, the keyring will be searched for a key with the supplied
name in that order.

Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
---
To: David Howells <dhowells@redhat.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
To: James Morris <jmorris@namei.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
To: Alasdair Kergon <agk@redhat.com>
To: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
To: Song Liu <song@kernel.org>
To: Richard Weinberger <richard@nod.at>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-raid@vger.kernel.org
Cc: keyrings@vger.kernel.org
Cc: linux-mtd@lists.infradead.org
Cc: linux-security-module@vger.kernel.org
Cc: linux-integrity@vger.kernel.org
---
 Documentation/filesystems/ubifs.rst |  2 +-
 fs/ubifs/auth.c                     | 19 ++++++++++++-------
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/Documentation/filesystems/ubifs.rst b/Documentation/filesystems/ubifs.rst
index e6ee99762534..12d08458b3d7 100644
--- a/Documentation/filesystems/ubifs.rst
+++ b/Documentation/filesystems/ubifs.rst
@@ -101,7 +101,7 @@ compr=zlib              override default compressor and set it to "zlib"
 auth_key=		specify the key used for authenticating the filesystem.
 			Passing this option makes authentication mandatory.
 			The passed key must be present in the kernel keyring
-			and must be of type 'logon'
+			and must be of type 'logon', 'encrypted' or 'trusted'.
 auth_hash_name=		The hash algorithm used for authentication. Used for
 			both hashing and for creating HMACs. Typical values
 			include "sha256" or "sha512"
diff --git a/fs/ubifs/auth.c b/fs/ubifs/auth.c
index 6a0b8d858d81..af8e9eb58a60 100644
--- a/fs/ubifs/auth.c
+++ b/fs/ubifs/auth.c
@@ -14,6 +14,8 @@
 #include <crypto/hash.h>
 #include <crypto/algapi.h>
 #include <keys/user-type.h>
+#include <keys/trusted-type.h>
+#include <keys/encrypted-type.h>
 #include <keys/asymmetric-type.h>
 
 #include "ubifs.h"
@@ -256,9 +258,10 @@ out_destroy:
 int ubifs_init_authentication(struct ubifs_info *c)
 {
 	struct key *keyring_key;
-	const struct user_key_payload *ukp;
 	int err;
+	unsigned int len;
 	char hmac_name[CRYPTO_MAX_ALG_NAME];
+	const void *key_material;
 
 	if (!c->auth_hash_name) {
 		ubifs_err(c, "authentication hash name needed with authentication");
@@ -277,6 +280,10 @@ int ubifs_init_authentication(struct ubifs_info *c)
 		 c->auth_hash_name);
 
 	keyring_key = request_key(&key_type_logon, c->auth_key_name, NULL);
+	if (IS_ERR(keyring_key) && IS_REACHABLE(CONFIG_ENCRYPTED_KEYS))
+		keyring_key = request_key(&key_type_encrypted, c->auth_key_name, NULL);
+	if (IS_ERR(keyring_key) && IS_REACHABLE(CONFIG_TRUSTED_KEYS))
+		keyring_key = request_key(&key_type_trusted, c->auth_key_name, NULL);
 
 	if (IS_ERR(keyring_key)) {
 		ubifs_err(c, "Failed to request key: %ld",
@@ -286,12 +293,10 @@ int ubifs_init_authentication(struct ubifs_info *c)
 
 	down_read(&keyring_key->sem);
 
-	ukp = user_key_payload_locked(keyring_key);
-	if (!ukp) {
-		/* key was revoked before we acquired its semaphore */
-		err = -EKEYREVOKED;
+	key_material = key_extract_material(keyring_key, &len);
+	err = PTR_ERR_OR_ZERO(key_material);
+	if (err < 0)
 		goto out;
-	}
 
 	c->hash_tfm = crypto_alloc_shash(c->auth_hash_name, 0, 0);
 	if (IS_ERR(c->hash_tfm)) {
@@ -324,7 +329,7 @@ int ubifs_init_authentication(struct ubifs_info *c)
 		goto out_free_hmac;
 	}
 
-	err = crypto_shash_setkey(c->hmac_tfm, ukp->data, ukp->datalen);
+	err = crypto_shash_setkey(c->hmac_tfm, key_material, len);
 	if (err)
 		goto out_free_hmac;
 
-- 
git-series 0.9.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


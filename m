Return-Path: <SRS0=ZA/Q=MS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E5EAC4338F
	for <dm-devel@archiver.kernel.org>; Mon, 26 Jul 2021 07:08:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7225260F44
	for <dm-devel@archiver.kernel.org>; Mon, 26 Jul 2021 07:08:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7225260F44
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-lACrlVAsPX6WCFAHi_TAmw-1; Mon, 26 Jul 2021 03:08:36 -0400
X-MC-Unique: lACrlVAsPX6WCFAHi_TAmw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A5C0187D546;
	Mon, 26 Jul 2021 07:08:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 800F969324;
	Mon, 26 Jul 2021 07:08:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 539654A7C9;
	Mon, 26 Jul 2021 07:08:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16M9bsLx019469 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 22 Jul 2021 05:37:55 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CDE8D10378E; Thu, 22 Jul 2021 09:37:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C8BED1037B9
	for <dm-devel@redhat.com>; Thu, 22 Jul 2021 09:37:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 18D3E80378A
	for <dm-devel@redhat.com>; Thu, 22 Jul 2021 09:37:51 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de
	[85.220.165.71]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-431-gQHxGGw4M52KQ-ZMHdra9A-1; Thu, 22 Jul 2021 05:37:49 -0400
X-MC-Unique: gQHxGGw4M52KQ-ZMHdra9A-1
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
	by metis.ext.pengutronix.de with esmtps
	(TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
	(envelope-from <afa@pengutronix.de>)
	id 1m6UqE-0001NL-VW; Thu, 22 Jul 2021 11:18:06 +0200
Received: from afa by dude.hi.pengutronix.de with local (Exim 4.92)
	(envelope-from <afa@pengutronix.de>)
	id 1m6UqC-0001Cm-EB; Thu, 22 Jul 2021 11:18:04 +0200
From: Ahmad Fatoum <a.fatoum@pengutronix.de>
To: David Howells <dhowells@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	dm-devel@redhat.com, Song Liu <song@kernel.org>,
	Richard Weinberger <richard@nod.at>
Date: Thu, 22 Jul 2021 11:17:59 +0200
Message-Id: <d3ae98bb8d00c2be4529694630132bdcabf383c0.1626945419.git-series.a.fatoum@pengutronix.de>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 26 Jul 2021 03:08:04 -0400
Cc: Ahmad Fatoum <a.fatoum@pengutronix.de>, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
	linux-mtd@lists.infradead.org, kernel@pengutronix.de,
	linux-integrity@vger.kernel.org
Subject: [dm-devel] [RFC PATCH v1 1/4] keys: introduce key_extract_material
	helper
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

While keys of differing type have a common struct key definition, there is
no common scheme to the payload and key material extraction differs.

For kernel functionality that supports different key types,
this means duplicated code for key material extraction and because key type
is discriminated by a pointer to a global, users need to replicate
reachability checks as well, so builtin code doesn't depend on a key
type symbol offered by a module.

Make this easier by adding a common helper with initial support for
user, logon, encrypted and trusted keys. The code is taken from
dm-crypt, which is migrated to use the helper in a later commit.

The implementation must be partially in a header to support configurations
where the key type symbol is defined in a module, but key support in general
is built-in.

Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
---
I am not sure whether the chosen header and source file are the best
places for this. This could be made header-only too if that's preferred.

To: David Howells <dhowells@redhat.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
To: James Morris <jmorris@namei.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
To: Alasdair Kergon <agk@redhat.com>
To: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
To: Song Liu <song@kernel.org>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org
Cc: keyrings@vger.kernel.org
Cc: linux-mtd@lists.infradead.org
Cc: linux-security-module@vger.kernel.org
Cc: linux-integrity@vger.kernel.org
---
 include/linux/key.h | 45 +++++++++++++++++++++++++++++++++++++++++++++
 security/keys/key.c | 40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 85 insertions(+)

diff --git a/include/linux/key.h b/include/linux/key.h
index 7febc4881363..916612f5b313 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -20,6 +20,8 @@
 #include <linux/assoc_array.h>
 #include <linux/refcount.h>
 #include <linux/time64.h>
+#include <linux/err.h>
+#include <linux/kconfig.h>
 
 #ifdef __KERNEL__
 #include <linux/uidgid.h>
@@ -487,6 +489,48 @@ extern void key_fsuid_changed(struct cred *new_cred);
 extern void key_fsgid_changed(struct cred *new_cred);
 extern void key_init(void);
 
+/*
+ * internal use, so key core code need not link against
+ * all supported key types
+ * */
+enum __key_type {
+	KEY_TYPE_UNKNOWN, KEY_TYPE_USER, KEY_TYPE_ENCRYPTED, KEY_TYPE_TRUSTED
+};
+
+const void *__key_extract_material(const struct key *key, enum __key_type type,
+				   unsigned int *len);
+
+/**
+ * key_extract_material - Extract decrypted data out of a key
+ * @key: a logon, user, encrypted or trusted key
+ * @len: pointer to variable to store key size into
+ *
+ * Extract decrypted data out of supported key types
+ *
+ * Returns a pointer to the key material if successfull or an error
+ * pointer if key type is not compiled in, the buffer is too
+ * small or the key was revoked.
+ */
+static inline const void *key_extract_material(const struct key *key,
+					       unsigned int *len)
+{
+	extern struct key_type key_type_user;
+	extern struct key_type key_type_logon;
+	extern struct key_type key_type_encrypted;
+	extern struct key_type key_type_trusted;
+	enum __key_type type = KEY_TYPE_UNKNOWN;
+	const struct key_type *t = key->type;
+
+	if (t == &key_type_logon || t == &key_type_user)
+		type = KEY_TYPE_USER;
+	else if (IS_REACHABLE(CONFIG_ENCRYPTED_KEYS) && t == &key_type_encrypted)
+		type = KEY_TYPE_ENCRYPTED;
+	else if (IS_REACHABLE(CONFIG_TRUSTED_KEYS) && t == &key_type_trusted)
+		type = KEY_TYPE_TRUSTED;
+
+	return __key_extract_material(key, type, len);
+}
+
 #else /* CONFIG_KEYS */
 
 #define key_validate(k)			0
@@ -504,6 +548,7 @@ extern void key_init(void);
 #define key_init()			do { } while(0)
 #define key_free_user_ns(ns)		do { } while(0)
 #define key_remove_domain(d)		do { } while(0)
+#define key_extract_material(k, l)	ERR_PTR(-EINVAL)
 
 #endif /* CONFIG_KEYS */
 #endif /* __KERNEL__ */
diff --git a/security/keys/key.c b/security/keys/key.c
index c45afdd1dfbb..69cd1cb8c413 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -15,6 +15,9 @@
 #include <linux/random.h>
 #include <linux/ima.h>
 #include <linux/err.h>
+#include <keys/user-type.h>
+#include <keys/encrypted-type.h>
+#include <keys/trusted-type.h>
 #include "internal.h"
 
 struct kmem_cache *key_jar;
@@ -1140,6 +1143,43 @@ int generic_key_instantiate(struct key *key, struct key_preparsed_payload *prep)
 }
 EXPORT_SYMBOL(generic_key_instantiate);
 
+const void *__key_extract_material(const struct key *key,
+				   enum __key_type type, unsigned int *len)
+{
+	const struct encrypted_key_payload *ekp;
+	const struct trusted_key_payload *tkp;
+	const struct user_key_payload *ukp;
+
+	switch (type) {
+	case KEY_TYPE_USER:
+		ukp = user_key_payload_locked(key);
+		if (!ukp)
+			break;
+
+		*len = ukp->datalen;
+		return ukp->data;
+	case KEY_TYPE_ENCRYPTED:
+		ekp = key->payload.data[0];
+		if (!ekp)
+			break;
+
+		*len = ekp->decrypted_datalen;
+		return ekp->decrypted_data;
+	case KEY_TYPE_TRUSTED:
+		tkp = key->payload.data[0];
+		if (!tkp)
+			break;
+
+		*len = tkp->key_len;
+		return tkp->key;
+	default:
+		return ERR_PTR(-EINVAL);
+	}
+
+	return ERR_PTR(-EKEYREVOKED);
+}
+EXPORT_SYMBOL(__key_extract_material);
+
 /**
  * register_key_type - Register a type of key.
  * @ktype: The new key type.
-- 
git-series 0.9.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


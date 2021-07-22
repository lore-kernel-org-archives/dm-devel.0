Return-Path: <SRS0=ZA/Q=MS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B1C3C4338F
	for <dm-devel@archiver.kernel.org>; Mon, 26 Jul 2021 07:08:44 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AF25960720
	for <dm-devel@archiver.kernel.org>; Mon, 26 Jul 2021 07:08:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AF25960720
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-516-a1esJBRGOaGB6CFwumiIWw-1; Mon, 26 Jul 2021 03:08:41 -0400
X-MC-Unique: a1esJBRGOaGB6CFwumiIWw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 00A2B100670C;
	Mon, 26 Jul 2021 07:08:37 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D404419C59;
	Mon, 26 Jul 2021 07:08:36 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A8C684A7CB;
	Mon, 26 Jul 2021 07:08:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16M9c2OJ019506 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 22 Jul 2021 05:38:03 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id BF25C10378E; Thu, 22 Jul 2021 09:38:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BA4E01037B9
	for <dm-devel@redhat.com>; Thu, 22 Jul 2021 09:38:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A04ED185A79C
	for <dm-devel@redhat.com>; Thu, 22 Jul 2021 09:38:02 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de
	[85.220.165.71]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-597-UM_-hEIHPhifMBlfjVp6ZQ-1; Thu, 22 Jul 2021 05:38:00 -0400
X-MC-Unique: UM_-hEIHPhifMBlfjVp6ZQ-1
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
	by metis.ext.pengutronix.de with esmtps
	(TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
	(envelope-from <afa@pengutronix.de>)
	id 1m6UqE-0001NM-VX; Thu, 22 Jul 2021 11:18:06 +0200
Received: from afa by dude.hi.pengutronix.de with local (Exim 4.92)
	(envelope-from <afa@pengutronix.de>)
	id 1m6UqC-0001Cr-FA; Thu, 22 Jul 2021 11:18:04 +0200
From: Ahmad Fatoum <a.fatoum@pengutronix.de>
To: David Howells <dhowells@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	dm-devel@redhat.com, Song Liu <song@kernel.org>,
	Richard Weinberger <richard@nod.at>
Date: Thu, 22 Jul 2021 11:18:00 +0200
Message-Id: <7ac4a9ae0a3c2dfdf41611f3fe78fe63a6e57b94.1626945419.git-series.a.fatoum@pengutronix.de>
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
Subject: [dm-devel] [RFC PATCH v1 2/4] dm: crypt: use new
	key_extract_material helper
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

There is a common function now to extract key material out of a few
different key types, which includes all types currently supported by
dm-crypt. Make use of it.

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
Cc: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org
Cc: keyrings@vger.kernel.org
Cc: linux-mtd@lists.infradead.org
Cc: linux-security-module@vger.kernel.org
Cc: linux-integrity@vger.kernel.org
---
 drivers/md/dm-crypt.c | 65 ++++++--------------------------------------
 1 file changed, 9 insertions(+), 56 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 50f4cbd600d5..576d6b7ce231 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2421,61 +2421,14 @@ static bool contains_whitespace(const char *str)
 	return false;
 }
 
-static int set_key_user(struct crypt_config *cc, struct key *key)
-{
-	const struct user_key_payload *ukp;
-
-	ukp = user_key_payload_locked(key);
-	if (!ukp)
-		return -EKEYREVOKED;
-
-	if (cc->key_size != ukp->datalen)
-		return -EINVAL;
-
-	memcpy(cc->key, ukp->data, cc->key_size);
-
-	return 0;
-}
-
-static int set_key_encrypted(struct crypt_config *cc, struct key *key)
-{
-	const struct encrypted_key_payload *ekp;
-
-	ekp = key->payload.data[0];
-	if (!ekp)
-		return -EKEYREVOKED;
-
-	if (cc->key_size != ekp->decrypted_datalen)
-		return -EINVAL;
-
-	memcpy(cc->key, ekp->decrypted_data, cc->key_size);
-
-	return 0;
-}
-
-static int set_key_trusted(struct crypt_config *cc, struct key *key)
-{
-	const struct trusted_key_payload *tkp;
-
-	tkp = key->payload.data[0];
-	if (!tkp)
-		return -EKEYREVOKED;
-
-	if (cc->key_size != tkp->key_len)
-		return -EINVAL;
-
-	memcpy(cc->key, tkp->key, cc->key_size);
-
-	return 0;
-}
-
 static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string)
 {
 	char *new_key_string, *key_desc;
 	int ret;
+	unsigned int len;
 	struct key_type *type;
 	struct key *key;
-	int (*set_key)(struct crypt_config *cc, struct key *key);
+	const void *key_material;
 
 	/*
 	 * Reject key_string with whitespace. dm core currently lacks code for
@@ -2493,18 +2446,14 @@ static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string
 
 	if (!strncmp(key_string, "logon:", key_desc - key_string + 1)) {
 		type = &key_type_logon;
-		set_key = set_key_user;
 	} else if (!strncmp(key_string, "user:", key_desc - key_string + 1)) {
 		type = &key_type_user;
-		set_key = set_key_user;
 	} else if (IS_ENABLED(CONFIG_ENCRYPTED_KEYS) &&
 		   !strncmp(key_string, "encrypted:", key_desc - key_string + 1)) {
 		type = &key_type_encrypted;
-		set_key = set_key_encrypted;
 	} else if (IS_ENABLED(CONFIG_TRUSTED_KEYS) &&
 	           !strncmp(key_string, "trusted:", key_desc - key_string + 1)) {
 		type = &key_type_trusted;
-		set_key = set_key_trusted;
 	} else {
 		return -EINVAL;
 	}
@@ -2521,14 +2470,18 @@ static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string
 
 	down_read(&key->sem);
 
-	ret = set_key(cc, key);
-	if (ret < 0) {
+	key_material = key_extract_material(key, &len);
+	if (!IS_ERR(key_material) && len != cc->key_size)
+		key_material = ERR_PTR(-EINVAL);
+	if (IS_ERR(key_material)) {
 		up_read(&key->sem);
 		key_put(key);
 		kfree_sensitive(new_key_string);
-		return ret;
+		return PTR_ERR(key_material);
 	}
 
+	memcpy(cc->key, key_material, len);
+
 	up_read(&key->sem);
 	key_put(key);
 
-- 
git-series 0.9.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


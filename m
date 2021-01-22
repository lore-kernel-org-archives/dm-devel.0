Return-Path: <SRS0=voF8=GZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1ECEC433E0
	for <dm-devel@archiver.kernel.org>; Fri, 22 Jan 2021 08:51:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D0C95238D7
	for <dm-devel@archiver.kernel.org>; Fri, 22 Jan 2021 08:51:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D0C95238D7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-07qCVRlYO_Km1YfZk0748g-1; Fri, 22 Jan 2021 03:51:34 -0500
X-MC-Unique: 07qCVRlYO_Km1YfZk0748g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A5F5800D55;
	Fri, 22 Jan 2021 08:51:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 76986709AC;
	Fri, 22 Jan 2021 08:51:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3E1694A7C7;
	Fri, 22 Jan 2021 08:51:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10M8jcEd016169 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 22 Jan 2021 03:45:39 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D671A1031F22; Fri, 22 Jan 2021 08:45:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D274F101F0D0
	for <dm-devel@redhat.com>; Fri, 22 Jan 2021 08:45:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5C8E2101A53F
	for <dm-devel@redhat.com>; Fri, 22 Jan 2021 08:45:36 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de
	[85.220.165.71]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-355-eZkjzmujM_SrDLi_WVy2gQ-1; Fri, 22 Jan 2021 03:45:33 -0500
X-MC-Unique: eZkjzmujM_SrDLi_WVy2gQ-1
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
	by metis.ext.pengutronix.de with esmtps
	(TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
	(envelope-from <afa@pengutronix.de>)
	id 1l2s2c-0005xf-A2; Fri, 22 Jan 2021 09:43:38 +0100
Received: from afa by dude.hi.pengutronix.de with local (Exim 4.92)
	(envelope-from <afa@pengutronix.de>)
	id 1l2s2b-0006GM-Kx; Fri, 22 Jan 2021 09:43:37 +0100
From: Ahmad Fatoum <a.fatoum@pengutronix.de>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	dm-devel@redhat.com
Date: Fri, 22 Jan 2021 09:43:20 +0100
Message-Id: <20210122084321.24012-1-a.fatoum@pengutronix.de>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 22 Jan 2021 03:51:25 -0500
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Arnd Bergmann <arnd@arndb.de>, kernel@pengutronix.de,
	linux-kernel@vger.kernel.org
Subject: [dm-devel] [PATCH 1/2] dm crypt: replaced #if defined with
	IS_ENABLED
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

IS_ENABLED(CONFIG_ENCRYPTED_KEYS) is true whether the option is built-in
or a module, so use it instead of #if defined checking for each
separately.

The other #if was to avoid a static function defined, but unused
warning. As we now always build the callsite when the function
is defined, we can remove that first #if guard.

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
---
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
---
 drivers/md/dm-crypt.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 8c874710f0bc..7eeb9248eda5 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2436,7 +2436,6 @@ static int set_key_user(struct crypt_config *cc, struct key *key)
 	return 0;
 }
 
-#if defined(CONFIG_ENCRYPTED_KEYS) || defined(CONFIG_ENCRYPTED_KEYS_MODULE)
 static int set_key_encrypted(struct crypt_config *cc, struct key *key)
 {
 	const struct encrypted_key_payload *ekp;
@@ -2452,7 +2451,6 @@ static int set_key_encrypted(struct crypt_config *cc, struct key *key)
 
 	return 0;
 }
-#endif /* CONFIG_ENCRYPTED_KEYS */
 
 static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string)
 {
@@ -2482,11 +2480,10 @@ static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string
 	} else if (!strncmp(key_string, "user:", key_desc - key_string + 1)) {
 		type = &key_type_user;
 		set_key = set_key_user;
-#if defined(CONFIG_ENCRYPTED_KEYS) || defined(CONFIG_ENCRYPTED_KEYS_MODULE)
-	} else if (!strncmp(key_string, "encrypted:", key_desc - key_string + 1)) {
+	} else if (IS_ENABLED(CONFIG_ENCRYPTED_KEYS) &&
+		   !strncmp(key_string, "encrypted:", key_desc - key_string + 1)) {
 		type = &key_type_encrypted;
 		set_key = set_key_encrypted;
-#endif
 	} else {
 		return -EINVAL;
 	}
-- 
2.30.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


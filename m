Return-Path: <SRS0=ZA/Q=MS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F32E7C4338F
	for <dm-devel@archiver.kernel.org>; Mon, 26 Jul 2021 07:08:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F2F2760F42
	for <dm-devel@archiver.kernel.org>; Mon, 26 Jul 2021 07:08:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F2F2760F42
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-YMmzE2inPgGSaEen6yrYfw-1; Mon, 26 Jul 2021 03:08:15 -0400
X-MC-Unique: YMmzE2inPgGSaEen6yrYfw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0AAF5DF8A0;
	Mon, 26 Jul 2021 07:08:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4EB1B5D6A1;
	Mon, 26 Jul 2021 07:08:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 54907180BAB0;
	Mon, 26 Jul 2021 07:08:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16M9c3PM019512 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 22 Jul 2021 05:38:03 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 89A4510CB260; Thu, 22 Jul 2021 09:38:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8406910CB265
	for <dm-devel@redhat.com>; Thu, 22 Jul 2021 09:37:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE8968007D3
	for <dm-devel@redhat.com>; Thu, 22 Jul 2021 09:37:58 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de
	[85.220.165.71]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-159-LcWHO0kwMQiAc6-KpFOXsw-1; Thu, 22 Jul 2021 05:37:57 -0400
X-MC-Unique: LcWHO0kwMQiAc6-KpFOXsw-1
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
	by metis.ext.pengutronix.de with esmtps
	(TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
	(envelope-from <afa@pengutronix.de>)
	id 1m6UqE-0001NN-VX; Thu, 22 Jul 2021 11:18:06 +0200
Received: from afa by dude.hi.pengutronix.de with local (Exim 4.92)
	(envelope-from <afa@pengutronix.de>)
	id 1m6UqC-0001Cw-GC; Thu, 22 Jul 2021 11:18:04 +0200
From: Ahmad Fatoum <a.fatoum@pengutronix.de>
To: David Howells <dhowells@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	dm-devel@redhat.com, Song Liu <song@kernel.org>,
	Richard Weinberger <richard@nod.at>
Date: Thu, 22 Jul 2021 11:18:01 +0200
Message-Id: <a7d493c678d5836577b0dc703e5f0adaa457a7f0.1626945419.git-series.a.fatoum@pengutronix.de>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 26 Jul 2021 03:08:04 -0400
Cc: Ahmad Fatoum <a.fatoum@pengutronix.de>, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
	linux-mtd@lists.infradead.org, kernel@pengutronix.de,
	linux-integrity@vger.kernel.org
Subject: [dm-devel] [RFC PATCH v1 3/4] ubifs: auth: remove never hit key
	type error check
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

key_request accepts a key type as its first argument. If it returns a
valid pointer, it should always have this same requested key type.

Indeed other request_key users surveyed such as dm-crypt, ecryptfs
and fscrypt v1 also don't check the key type. Therefore drop the
apparently unneeded check.

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
 fs/ubifs/auth.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/ubifs/auth.c b/fs/ubifs/auth.c
index e564d5ff8781..6a0b8d858d81 100644
--- a/fs/ubifs/auth.c
+++ b/fs/ubifs/auth.c
@@ -286,12 +286,6 @@ int ubifs_init_authentication(struct ubifs_info *c)
 
 	down_read(&keyring_key->sem);
 
-	if (keyring_key->type != &key_type_logon) {
-		ubifs_err(c, "key type must be logon");
-		err = -ENOKEY;
-		goto out;
-	}
-
 	ukp = user_key_payload_locked(keyring_key);
 	if (!ukp) {
 		/* key was revoked before we acquired its semaphore */
-- 
git-series 0.9.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


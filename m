Return-Path: <SRS0=ZA/Q=MS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB3F1C4320A
	for <dm-devel@archiver.kernel.org>; Mon, 26 Jul 2021 07:08:44 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3F69560F45
	for <dm-devel@archiver.kernel.org>; Mon, 26 Jul 2021 07:08:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3F69560F45
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-LFmpeY62N9Oaxc-F89R-ww-1; Mon, 26 Jul 2021 03:08:41 -0400
X-MC-Unique: LFmpeY62N9Oaxc-F89R-ww-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F3BE887D547;
	Mon, 26 Jul 2021 07:08:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DABD26E6E1;
	Mon, 26 Jul 2021 07:08:34 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B08FD4A7CA;
	Mon, 26 Jul 2021 07:08:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16M9btH8019488 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 22 Jul 2021 05:37:55 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3B7D3202877F; Thu, 22 Jul 2021 09:37:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 376492028782
	for <dm-devel@redhat.com>; Thu, 22 Jul 2021 09:37:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 208541071CE2
	for <dm-devel@redhat.com>; Thu, 22 Jul 2021 09:37:55 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de
	[85.220.165.71]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-509-DuG83CMFNlOl0yksZifScw-1; Thu, 22 Jul 2021 05:37:53 -0400
X-MC-Unique: DuG83CMFNlOl0yksZifScw-1
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
	by metis.ext.pengutronix.de with esmtps
	(TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
	(envelope-from <afa@pengutronix.de>)
	id 1m6UqE-0001NK-VX; Thu, 22 Jul 2021 11:18:06 +0200
Received: from afa by dude.hi.pengutronix.de with local (Exim 4.92)
	(envelope-from <afa@pengutronix.de>)
	id 1m6UqC-0001Ch-DB; Thu, 22 Jul 2021 11:18:04 +0200
From: Ahmad Fatoum <a.fatoum@pengutronix.de>
To: David Howells <dhowells@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	dm-devel@redhat.com, Song Liu <song@kernel.org>,
	Richard Weinberger <richard@nod.at>
Date: Thu, 22 Jul 2021 11:17:58 +0200
Message-Id: <cover.b2fdd70b830d12853b12a12e32ceb0c8162c1346.1626945419.git-series.a.fatoum@pengutronix.de>
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
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
	linux-mtd@lists.infradead.org, kernel@pengutronix.de,
	linux-integrity@vger.kernel.org
Subject: [dm-devel] [RFC PATCH v1 0/4] keys: introduce key_extract_material
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
user, logon, encrypted and trusted keys.

This series contains two example of its use: dm-crypt uses it to reduce
boilerplate and ubifs authentication uses it to gain support for trusted
and encrypted keys alongside the already supported logon keys.

Looking forward to your feedback,
Ahmad

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
Cc: linux-integrity@vger.kernel.org
Cc: keyrings@vger.kernel.org
Cc: linux-mtd@lists.infradead.org
Cc: linux-security-module@vger.kernel.org

Ahmad Fatoum (4):
  keys: introduce key_extract_material helper
  dm: crypt: use new key_extract_material helper
  ubifs: auth: remove never hit key type error check
  ubifs: auth: consult encrypted and trusted keys if no logon key was found

 Documentation/filesystems/ubifs.rst |  2 +-
 drivers/md/dm-crypt.c               | 65 ++++--------------------------
 fs/ubifs/auth.c                     | 25 +++++-------
 include/linux/key.h                 | 45 +++++++++++++++++++++-
 security/keys/key.c                 | 40 ++++++++++++++++++-
 5 files changed, 107 insertions(+), 70 deletions(-)

base-commit: 2734d6c1b1a089fb593ef6a23d4b70903526fe0c
-- 
git-series 0.9.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


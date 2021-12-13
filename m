Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BA2EC43219
	for <dm-devel@archiver.kernel.org>; Mon, 13 Dec 2021 22:34:08 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-280-2uKoeixzOVaRdVpfARvnmg-1; Mon, 13 Dec 2021 17:34:05 -0500
X-MC-Unique: 2uKoeixzOVaRdVpfARvnmg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E4612801AAB;
	Mon, 13 Dec 2021 22:34:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BBA801972E;
	Mon, 13 Dec 2021 22:33:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DA4A34BB7C;
	Mon, 13 Dec 2021 22:33:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BDMXs2b027768 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 13 Dec 2021 17:33:54 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 71DD0202E4A3; Mon, 13 Dec 2021 22:33:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6AD2C2026D46
	for <dm-devel@redhat.com>; Mon, 13 Dec 2021 22:33:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1DBED8022F1
	for <dm-devel@redhat.com>; Mon, 13 Dec 2021 22:33:49 +0000 (UTC)
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com
	[209.85.210.170]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-194-DsIy_eUJP1CWx3TQyrC9dQ-1; Mon, 13 Dec 2021 17:33:42 -0500
X-MC-Unique: DsIy_eUJP1CWx3TQyrC9dQ-1
Received: by mail-pf1-f170.google.com with SMTP id r130so16252275pfc.1
	for <dm-devel@redhat.com>; Mon, 13 Dec 2021 14:33:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references:mime-version:content-transfer-encoding;
	bh=YgyvWs4tutxnDqYTDwetVnj46UWWmfeOWxYILXaAup0=;
	b=u6p0mpd3TNJcaHneVr4K3N0eSLgz7Xkno8ZAo6TtJMyeqW4K7ayGP7V1h1w652nTmA
	lhZlMOM4jcZ8w2oleyEeGB/ziqShYEZrxEHAXeZNHz9kBOes4dwVVFVNqE66/OL1EZ5S
	eahExzn09zQzM0zvCyVfXtkyoeImRV8w67jyO81Kj0ALyVIhq4Z4O1/aT3BcG2Gh5m/m
	0V/k9B6s+w/w4B8XYKFIEwgV3RAn7G5Bfc37vAY0G/BU25A5IlDFyjvgHLADiAbYYexM
	kjd3QhhtMIe9R0K3djWfmXMDs8jJI1dvjSgeRrzkBVy2DGo5DtSkbDk806CM2c+eqIHa
	AvaA==
X-Gm-Message-State: AOAM533uEFZH7xmD8V1iDXZq6FTmmEJLErxw9+ATlpDFJ2OGFLCTNu96
	57t74ACR1TYnmhT9WZcc6g4VZu6wtmm1MA==
X-Google-Smtp-Source: ABdhPJxfs3G9SgBQOpvzNbbUSr07IB+8a2RoV0KOBCY/VV1CteSYlQSlFhfsGXdWAr8ufph1XIWCaA==
X-Received: by 2002:a63:62c6:: with SMTP id w189mr999201pgb.343.1639434821587; 
	Mon, 13 Dec 2021 14:33:41 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
	by smtp.gmail.com with ESMTPSA id
	z14sm14106178pfh.60.2021.12.13.14.33.38
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Mon, 13 Dec 2021 14:33:40 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: linux-hardening@vger.kernel.org
Date: Mon, 13 Dec 2021 14:33:25 -0800
Message-Id: <20211213223331.135412-12-keescook@chromium.org>
In-Reply-To: <20211213223331.135412-1-keescook@chromium.org>
References: <20211213223331.135412-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1663; h=from:subject;
	bh=Rw8elaX7lzkqZjVeNdewcjpE1pz4Up9kM2UagQ4QfoI=;
	b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBht8o5l4H+ZB5qLvrKCuFHRRdblpiRo+kyACzvwRjU
	NJG7MUGJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYbfKOQAKCRCJcvTf3G3AJqt0D/
	442RCWEfLc/vdJO62YkZXZbB86UYpqLs4jsfmJVAEkx1bNVEloZiAif7Bt2t0ZojDaapmU1VefQTo7
	Nw8zpBk0JkOinnr7PMRoZFA+4ML3GD26IoHkkdmlHmazoirzWVZ3a0RWyjcvCzTcP2ui9K5q0alwjD
	E4lxTnUnuQD12YR4FgxJz5UR5WmfJT5cd4WTsMoxrSunwkZNA+D0OXTMq706Ppu4IEVAZ74udYWRHB
	dhhLIp1ijQnkGMm9KeGcSo7sOlPRFB5/43T5jOoB9GoEtHQzdbzFxY+0bSP1yXaUBrUOfih2VmW0Qb
	kalL/o7vrD84bAzd920phPCmSWnpHQlBvDSB7u5XYNp6Zs0EnRYIJV2z+g1o0zceEaNrVbhsjq1Loi
	Hv+9VoUrujn/5n5FHRvrUPgdnkf+HnvVKxc+8rnXSqdMsJoTXU7yz/doAH2x93ac2mLbiVRxA2rvQo
	GoFGSJ4zQeFfGlCSKOeQo17UKOZsAA5YF41J8GR54McDg3k3EetgUanJlz04P/YER31qTj7Hu1zClU
	btgXZRyAgJM0pkdxgfIlUnxeOtXqWGujlwnrUJbdXq+7mI8xxY66kN7E0EHcsVFzCFnUd0jduTxh5S
	ASm+fSppb3CWwxajeVgI9wPDZj68zHa20Mo3ugrQOBPXoL2jeZidn2EqzDBA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp;
	fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
	Kees Cook <keescook@chromium.org>,
	Alasdair Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [dm-devel] [PATCH 11/17] dm integrity: Use struct_group() to zero
	struct journal_sector
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

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memset(), avoid intentionally writing across
neighboring fields.

Add struct_group() to mark region of struct journal_sector that should be
initialized to zero.

Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/md/dm-integrity.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 6319deccbe09..163c94ca4e5c 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -121,8 +121,10 @@ struct journal_entry {
 #define JOURNAL_MAC_SIZE		(JOURNAL_MAC_PER_SECTOR * JOURNAL_BLOCK_SECTORS)
 
 struct journal_sector {
-	__u8 entries[JOURNAL_SECTOR_DATA - JOURNAL_MAC_PER_SECTOR];
-	__u8 mac[JOURNAL_MAC_PER_SECTOR];
+	struct_group(sectors,
+		__u8 entries[JOURNAL_SECTOR_DATA - JOURNAL_MAC_PER_SECTOR];
+		__u8 mac[JOURNAL_MAC_PER_SECTOR];
+	);
 	commit_id_t commit_id;
 };
 
@@ -2870,7 +2872,8 @@ static void init_journal(struct dm_integrity_c *ic, unsigned start_section,
 		wraparound_section(ic, &i);
 		for (j = 0; j < ic->journal_section_sectors; j++) {
 			struct journal_sector *js = access_journal(ic, i, j);
-			memset(&js->entries, 0, JOURNAL_SECTOR_DATA);
+			BUILD_BUG_ON(sizeof(js->sectors) != JOURNAL_SECTOR_DATA);
+			memset(&js->sectors, 0, sizeof(js->sectors));
 			js->commit_id = dm_integrity_commit_id(ic, i, j, commit_seq);
 		}
 		for (j = 0; j < ic->journal_section_entries; j++) {
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


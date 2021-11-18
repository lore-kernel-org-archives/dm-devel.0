Return-Path: <SRS0=dXIA=QF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06975C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 20:37:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9642861037
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 20:37:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9642861037
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-550-9WQV445XNX2kZjWGaRQ2fw-1; Thu, 18 Nov 2021 15:37:00 -0500
X-MC-Unique: 9WQV445XNX2kZjWGaRQ2fw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 95E6B18125D5;
	Thu, 18 Nov 2021 20:36:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6BD54100EA05;
	Thu, 18 Nov 2021 20:36:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 404124A703;
	Thu, 18 Nov 2021 20:36:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AIKanRg016633 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Nov 2021 15:36:49 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0CBAA51DD; Thu, 18 Nov 2021 20:36:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 079AD51DC
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 20:36:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2C6B9811E76
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 20:36:46 +0000 (UTC)
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com
	[209.85.210.181]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-410-wAMJZxD_Mq68mfB64FdU5g-1; Thu, 18 Nov 2021 15:36:44 -0500
X-MC-Unique: wAMJZxD_Mq68mfB64FdU5g-1
Received: by mail-pf1-f181.google.com with SMTP id n85so7191048pfd.10
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 12:36:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=1P1IVsOV4eoi9h8VVG0W3l3nv1to2b9fsVwdeB/1IV0=;
	b=qa/0uLWHJ21gl+vrUh1grT2PUO32qxuyn739lWC0S+njqxvFBZdLWNKFoAZWK/msOR
	izJWJj/SOtWtmOX1YmBFwFlxey89uCe3XL4jNe05VIdufsCw72Y68ec6DCMQFc6bvodS
	fkf9ZKXcptdtSzfpN+iDtSMPEVQhWKmqWzwcdDJ9M0gdFGh8I12euviREd9aM3HTw67j
	sr9f2uam/jPbtW6BqRzSv3HZZfTIvz0BWlF3ByukKddJhgXymFXMGCVYVQ4Lo/Uwpr5E
	igkqx4tyWsaF/kOJEetQQoS0zWq7vTbuaVbT5cXx0KmDAjj+hl324+BdKlSXYXHjxDan
	1xTg==
X-Gm-Message-State: AOAM5304TcMFSq7Q/yNJT5B7QMoreZUR1tKKA3eEU1DglE8E2nQZ6IBm
	NVDA+RIcBA46vSUEVcKNJbIJbQ==
X-Google-Smtp-Source: ABdhPJx1PH3y3dE/DIYW2gw2KrkrLlgBWpuT41Q8G2aCVm7V4ETphnEr76qWFLI2NdrftFNHjpCBRA==
X-Received: by 2002:a63:e216:: with SMTP id q22mr13302659pgh.3.1637267802207; 
	Thu, 18 Nov 2021 12:36:42 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
	by smtp.gmail.com with ESMTPSA id d9sm7177789pjs.2.2021.11.18.12.36.41
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 18 Nov 2021 12:36:41 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: Alasdair Kergon <agk@redhat.com>
Date: Thu, 18 Nov 2021 12:36:40 -0800
Message-Id: <20211118203640.1288585-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1561; h=from:subject;
	bh=uXt5rNLQK/+BGfgY+/0jxuDI0+majyoEH4AYy0/HEDA=;
	b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhlrlXhAwJnh6qzFr/hBevLetAK90Djl1nlk7eJu89
	EwRtAbaJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYZa5VwAKCRCJcvTf3G3AJlZuD/
	93cSna6doQ+jybq9Xil1PjrHssaJTkfcyQskeukUC9phbJym57uJK7TxVu3nfT3aYuBX29jiRcS6Gx
	mXu3VoOCukFyuNI1APYwhsdti5kZia/z6i+2MvlmiISfwTkUTdpvcplLXwSHnWeVTxPGkiK9sMDTf+
	2faBizMacRLwlmqfJUdPnN5Dr9JbyiwAFC+TJ93lGrtWXq9UDrR3okl6vFKMT662AD47jV8qFMimyW
	+3Ue45vPThhY0F4TCtCrrQRhGnChqyJQF0FWs+Sb4JnwXN3L3dqpF+9/+bOMlxjQ+A46h+nPm6x6Yv
	o7ybTYRSOKnxKh8r+iKNhRIZwrbu7Z5RKPxzPR1/G6wH0uGOM6mem/bI55KrqM14lPbR0LFdDBv67l
	zHoThoTesPcmeMY9/mkQqZk1CLmNzuT6q++UiCtGiA6scWPLtgXqo8RTHmISh9fT+NCCMaszqqY53H
	2m2HyvrU3/lYOfgDxVkBcw/iCDcnVcdASzU0KMmeJw8dGFzu2Fc0po0hJSHYoHy6nF6JYYuByhPyp0
	X+VSsMBiIuCIOOeVg46DXEp2VaHkL1/DjgCYQEjTe+NVU3bfB6/c9FkTyd/vzwyu10TMZNp1u49ijH
	BLEijZDKf1e4J2W0D9CydNOtpfllzMsjDyOOkgpwP9PIxR0X2Vyc7+5W8hIA==
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, linux-hardening@vger.kernel.org,
	Kees Cook <keescook@chromium.org>,
	Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org
Subject: [dm-devel] [PATCH] dm integrity: Use struct_group() to zero struct
	journal_sector
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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


Return-Path: <SRS0=iWw/=NJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0932C432BE
	for <dm-devel@archiver.kernel.org>; Wed, 18 Aug 2021 06:25:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5004060FA0
	for <dm-devel@archiver.kernel.org>; Wed, 18 Aug 2021 06:25:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5004060FA0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-GX5dbq6BOZeTKFAYAOGMjA-1; Wed, 18 Aug 2021 02:25:32 -0400
X-MC-Unique: GX5dbq6BOZeTKFAYAOGMjA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E8F9C107ACF5;
	Wed, 18 Aug 2021 06:25:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 91D55620DE;
	Wed, 18 Aug 2021 06:25:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 387194BB7C;
	Wed, 18 Aug 2021 06:25:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17I6OLpq018786 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 18 Aug 2021 02:24:21 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1791110130EE; Wed, 18 Aug 2021 06:24:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 11A571013243
	for <dm-devel@redhat.com>; Wed, 18 Aug 2021 06:24:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0BFB6106655B
	for <dm-devel@redhat.com>; Wed, 18 Aug 2021 06:24:17 +0000 (UTC)
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com
	[209.85.210.177]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-488-KabtAEoMNcCmOrhG52FOaQ-1; Wed, 18 Aug 2021 02:24:14 -0400
X-MC-Unique: KabtAEoMNcCmOrhG52FOaQ-1
Received: by mail-pf1-f177.google.com with SMTP id j187so1101251pfg.4
	for <dm-devel@redhat.com>; Tue, 17 Aug 2021 23:24:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references:mime-version:content-transfer-encoding;
	bh=8+A9B+piI2a1pz1tZAhljlWwZX3AUujJJLfFoqwX48c=;
	b=coHlpmxA/Ko5LqRgQnKLVdLbRq06kLNkQn21pOapkPUDeR7VoGPcYt+/MrnD9Wv1pB
	rXBVxhdt9tGmpxlv5dgKC3Vv6if2L15rnaTPJBOgfiCedLANY+0j5mY3p3fmDKou36k7
	4JFKWefNB4y9PjsMuS2F8LPlbYOnqenveGmk6eaxBm9YIL9hC30yZRns63KJ2jZda1vP
	6UN97PNrJsolXJTo88JeB7Npj74FTri5BphhqS++7ALE6x41rPYRGR1QXeCBsi9b9gi5
	5bXw8Y35z4IwULPk2HVa61NzZ3rfy5ZCjrsP9/eN8go19OJCbgLXpJBcr8ut/0xQXtnj
	PvcQ==
X-Gm-Message-State: AOAM533OkmXOFr2q/F144DRxrCsJaSevcFy2AtNB4smXgzF53QPstZTn
	OUUcOqPgswDky+R3yi/yMZIZzQ==
X-Google-Smtp-Source: ABdhPJxCPUoUEoBjNrtfl0W88T/NpydxEyxEPAEFUx/gyRjyJ4MO5rFkm2cPoNcf30Dno8o0XcPo0w==
X-Received: by 2002:a05:6a00:134e:b0:3e1:1ed:80ff with SMTP id
	k14-20020a056a00134e00b003e101ed80ffmr7575503pfu.34.1629267853688;
	Tue, 17 Aug 2021 23:24:13 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
	by smtp.gmail.com with ESMTPSA id
	p24sm4878901pff.161.2021.08.17.23.24.12
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 17 Aug 2021 23:24:12 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Date: Tue, 17 Aug 2021 23:05:24 -0700
Message-Id: <20210818060533.3569517-55-keescook@chromium.org>
In-Reply-To: <20210818060533.3569517-1-keescook@chromium.org>
References: <20210818060533.3569517-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1663; h=from:subject;
	bh=RPEjx0xOcNjHRBM+3EZ1vHtaj+TxiBoxNq+cj1Ac9bE=;
	b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhHKMqKJz2SoJYeKtBFLmX4tcR3DHJFXvBbKzH4heh
	kSEkuyiJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYRyjKgAKCRCJcvTf3G3AJuKGD/
	4n4SpuomtIZ+g22QufnnrQNKHA98zIHUxCFyPUWlldkaYq1yjxANA7kCeWzhMyhnDbNsMcPnBz0u8w
	gTumF2NUeGQx1DWnIYpoWchHj0biXBVmJ627d0qH4ZPJV0xVoCra7OxBNu9MzddxWpF6sdPcwkm6G6
	KRyO9F4M4JhZ6wIx91tgVghgSzl5twheIhtA3njJ073Q8wNaDnBzfs/l9Ut/AzjfupZu1x3ki+jwpu
	WmD6nfcKbq0Iek6wuIdRHun0EOL5PBZd4fWR1bJEQePLiZZr/WzyrJktCcPBtbfNoxoh3Zd/RDOYxC
	Phqtb9d6KbfQDNPiqFq8A/FFx6Omeamuzt6AZrvZOtupVwaAqZxmTGL+T1t6dJrUD1sjtKDjGoNOLi
	7dn6c/08XUE+My/kdCiaqMIMLvnXKeruIHQhrlJ6zoMYvFZ06D7/j39GezPIeXXaEJGwuF4EXX7UYn
	QzJ8yJKQqHgf3AnzSklDq7S2QgMQbMBg1H2HY21GsA89Wb8lyNm0RvImBjKDi+T7HWHtu01K2er3t2
	O4+fb9meXQjoQXeBGEZ9RShjhKkgK9BaIxyiqfANsALqrrzQxMSMbRLvnALSRrEOGtrHi3ZBCAsQ/F
	uBwH2rx2bGKY/138CbdayzcXJ/PERuBisG0LhMFqbUDxYwVopHT1lxsnBtzA==
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: Kees Cook <keescook@chromium.org>, Mike Snitzer <snitzer@redhat.com>,
	linux-kbuild@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-staging@lists.linux.dev, linux-wireless@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	dri-devel@lists.freedesktop.org, linux-block@vger.kernel.org,
	clang-built-linux@googlegroups.com, dm-devel@redhat.com,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	linux-hardening@vger.kernel.org, netdev@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, Alasdair Kergon <agk@redhat.com>
Subject: [dm-devel] [PATCH v2 54/63] dm integrity: Use struct_group() to
	zero struct journal_sector
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
index 40f8116c8e44..59deea0dd305 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -119,8 +119,10 @@ struct journal_entry {
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
 
@@ -2856,7 +2858,8 @@ static void init_journal(struct dm_integrity_c *ic, unsigned start_section,
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


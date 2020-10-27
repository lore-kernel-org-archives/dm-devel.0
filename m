Return-Path: <SRS0=TXmu=EC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1599C55178
	for <dm-devel@archiver.kernel.org>; Tue, 27 Oct 2020 22:46:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 622A02070E
	for <dm-devel@archiver.kernel.org>; Tue, 27 Oct 2020 22:46:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 622A02070E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-o2srgC-KPB25WIYmo4ly0w-1; Tue, 27 Oct 2020 18:46:16 -0400
X-MC-Unique: o2srgC-KPB25WIYmo4ly0w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 04F7E57205;
	Tue, 27 Oct 2020 22:46:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 85F3C2C31E;
	Tue, 27 Oct 2020 22:46:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CB38E181A872;
	Tue, 27 Oct 2020 22:46:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09RMk3T2008989 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 27 Oct 2020 18:46:03 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6EFF51016D85; Tue, 27 Oct 2020 22:46:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6ACEB1134CD6
	for <dm-devel@redhat.com>; Tue, 27 Oct 2020 22:46:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9236E185A794
	for <dm-devel@redhat.com>; Tue, 27 Oct 2020 22:46:01 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-181-VC9WNx3BM3OU64FmI9RYew-1;
	Tue, 27 Oct 2020 18:45:56 -0400
X-MC-Unique: VC9WNx3BM3OU64FmI9RYew-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 4CE20B2A7;
	Tue, 27 Oct 2020 22:45:55 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>
Date: Tue, 27 Oct 2020 23:45:35 +0100
Message-Id: <20201027224536.11662-5-mwilck@suse.com>
In-Reply-To: <20201027224536.11662-1-mwilck@suse.com>
References: <20201027224536.11662-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09RMk3T2008989
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>,
	Leonardo Arena <rnalrd@alpinelinux.org>
Subject: [dm-devel] [PATCH 4/5] libmultipath tests: fix strerror()
	difference between musl and glibc
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

If an error occurs with errno=0, strerror() on musl returns a different
string than "Success". Make sure the test doesn't fail for that reason.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/alias.c    | 2 +-
 tests/test-log.c | 5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/tests/alias.c b/tests/alias.c
index 5624138..7fda679 100644
--- a/tests/alias.c
+++ b/tests/alias.c
@@ -712,7 +712,7 @@ static void al_write_err(void **state)
 	will_return(__wrap_write, strlen(ln) - 1);
 	expect_value(__wrap_ftruncate, length, offset);
 	will_return(__wrap_ftruncate, 0);
-	expect_condlog(0, "Cannot write binding to bindings file : Success\n");
+	expect_condlog(0, "Cannot write binding to bindings file :");
 
 	alias = allocate_binding(0, "WWIDa", 1, "MPATH");
 	assert_ptr_equal(alias, NULL);
diff --git a/tests/test-log.c b/tests/test-log.c
index 051491e..1c901cb 100644
--- a/tests/test-log.c
+++ b/tests/test-log.c
@@ -2,6 +2,7 @@
 #include <stddef.h>
 #include <stdarg.h>
 #include <stdio.h>
+#include <string.h>
 #include <cmocka.h>
 #include "log.h"
 #include "test-log.h"
@@ -11,12 +12,14 @@ void __wrap_dlog (int sink, int prio, const char * fmt, ...)
 {
 	char buff[MAX_MSG_SIZE];
 	va_list ap;
+	char *expected;
 
 	check_expected(prio);
 	va_start(ap, fmt);
 	vsnprintf(buff, MAX_MSG_SIZE, fmt, ap);
 	va_end(ap);
-	assert_string_equal(buff, mock_ptr_type(char *));
+	expected = mock_ptr_type(char *);
+	assert_memory_equal(buff, expected, strlen(expected));
 }
 
 void expect_condlog(int prio, char *string)
-- 
2.29.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


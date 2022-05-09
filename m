Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D3BDC433F5
	for <dm-devel@archiver.kernel.org>; Mon,  9 May 2022 15:21:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-115-0bTzlaWzPXKps8Bg0QPNdg-1; Mon, 09 May 2022 11:21:46 -0400
X-MC-Unique: 0bTzlaWzPXKps8Bg0QPNdg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 48ECA811E90;
	Mon,  9 May 2022 15:21:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5156040CF8FF;
	Mon,  9 May 2022 15:21:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 11DF61947051;
	Mon,  9 May 2022 15:21:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E3A7A1947040
 for <dm-devel@listman.corp.redhat.com>; Mon,  9 May 2022 15:21:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BFF162166B49; Mon,  9 May 2022 15:21:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BC2D12166B4C
 for <dm-devel@redhat.com>; Mon,  9 May 2022 15:21:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4ABF18015BA
 for <dm-devel@redhat.com>; Mon,  9 May 2022 15:21:33 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-503-w6Sosol-MZeEL1w5-kzRVg-1; Mon, 09 May 2022 11:21:31 -0400
X-MC-Unique: w6Sosol-MZeEL1w5-kzRVg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 2E2F321A6A;
 Mon,  9 May 2022 15:21:30 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EEE46132C0;
 Mon,  9 May 2022 15:21:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id Oo+3OHkxeWLQGAAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 09 May 2022 15:21:29 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 =?UTF-8?q?Martin=20Li=C5=A1ka?= <mliska@suse.cz>
Date: Mon,  9 May 2022 17:21:27 +0200
Message-Id: <20220509152127.7257-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: [dm-devel] [PATCH] multipath-tools: Makefile.inc: add test for
 -D_FORTIFY_SOURCE=3
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

6186645 ("Fix possibility to redefine -D_FORTIFY_SOURCE macro.")
does not work as-is, because OPTFLAGS can't be used to override CPPFLAGS.
Instead, add a test for support of -D_FORTIFY_SOURCE=3, and use it
automatically if supported. The test uses similar logic as e.g.
https://sourceware.org/git/?p=elfutils.git;a=commit;h=29859f2e79ef3c650ee9712cae990c6a7f787a7d

This test works in environments with glibc 2.33 or newer. On older distributions,
-D_FORTIFY_SOURCE=3 does not cause an error, and will thus be used. In this
case, it has the same effect as -D_FORTIFY_SOURCE=2. On alpine Linux (musl
libc), -D_FORTIFY_SOURCE=3 generates an error.

Fixes: 6186645 ("Fix possibility to redefine -D_FORTIFY_SOURCE macro.")
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 Makefile.inc | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/Makefile.inc b/Makefile.inc
index cef7a06..b915c06 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -117,6 +117,20 @@ TEST_CC_OPTION = $(shell \
 		echo "$(2)"; \
 	fi)
 
+# "make" on some distros will fail on explicit '#' or '\#' in the program text below
+__HASH__ := \#
+# Check if _DFORTIFY_SOURCE=3 is supported.
+# On some distros (e.g. Debian Buster) it will be falsely reported as supported
+# but it doesn't seem to make a difference wrt the compilation result.
+FORTIFY_OPT := $(shell \
+	if /bin/echo -e '$(__HASH__)include <string.h>\nint main(void) { return 0; }' | \
+		$(CC) -o /dev/null -c -O2 -Werror -D_FORTIFY_SOURCE=3 -xc - 2>/dev/null; \
+	then \
+		echo "-D_FORTIFY_SOURCE=3"; \
+	else \
+		echo "-D_FORTIFY_SOURCE=2"; \
+	fi)
+
 STACKPROT := $(call TEST_CC_OPTION,-fstack-protector-strong,-fstack-protector)
 ERROR_DISCARDED_QUALIFIERS := $(call TEST_CC_OPTION,-Werror=discarded-qualifiers,)
 WNOCLOBBERED := $(call TEST_CC_OPTION,-Wno-clobbered -Wno-error=clobbered,)
@@ -126,7 +140,7 @@ OPTFLAGS	:= -O2 -g $(STACKPROT) --param=ssp-buffer-size=4
 WARNFLAGS	:= -Werror -Wall -Wextra -Wformat=2 $(WFORMATOVERFLOW) -Werror=implicit-int \
 		  -Werror=implicit-function-declaration -Werror=format-security \
 		  $(WNOCLOBBERED) -Werror=cast-qual $(ERROR_DISCARDED_QUALIFIERS)
-CPPFLAGS	:= -D_FORTIFY_SOURCE=2
+CPPFLAGS	:= $(FORTIFY_OPT)
 CFLAGS		:= --std=gnu99 $(CFLAGS) $(OPTFLAGS) $(WARNFLAGS) -pipe \
 		   -DBIN_DIR=\"$(bindir)\" -DMULTIPATH_DIR=\"$(plugindir)\" -DRUN_DIR=\"${RUN}\" \
 		   -DCONFIG_DIR=\"$(configdir)\" -DEXTRAVERSION=\"$(EXTRAVERSION)\" -MMD -MP
-- 
2.36.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


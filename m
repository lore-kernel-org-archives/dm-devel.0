Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 236B2C43219
	for <dm-devel@archiver.kernel.org>; Mon, 11 Apr 2022 06:19:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-164-6ObLQCO_N9KP1Spiv3Oeiw-1; Mon, 11 Apr 2022 02:19:27 -0400
X-MC-Unique: 6ObLQCO_N9KP1Spiv3Oeiw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C58422A2AD54;
	Mon, 11 Apr 2022 06:19:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B3A3AC202C8;
	Mon, 11 Apr 2022 06:19:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 76EB419451F2;
	Mon, 11 Apr 2022 06:19:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 512CD19451F3
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Apr 2022 07:52:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 21AEB404385A; Wed,  6 Apr 2022 07:52:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1DF8540470CC
 for <dm-devel@redhat.com>; Wed,  6 Apr 2022 07:52:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 06A193C23FA2
 for <dm-devel@redhat.com>; Wed,  6 Apr 2022 07:52:29 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-574-57Xb4o1UOZm94Gm3qdy7Wg-1; Wed, 06 Apr 2022 03:52:27 -0400
X-MC-Unique: 57Xb4o1UOZm94Gm3qdy7Wg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id B5A511F7AD;
 Wed,  6 Apr 2022 07:46:15 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9D35E13A8E;
 Wed,  6 Apr 2022 07:46:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id LoBIJUdFTWJRVAAAMHmgww
 (envelope-from <mliska@suse.cz>); Wed, 06 Apr 2022 07:46:15 +0000
Message-ID: <84bb9ebc-80fd-08a8-c326-c28cfedc8d81@suse.cz>
Date: Wed, 6 Apr 2022 09:46:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
From: =?UTF-8?Q?Martin_Li=c5=a1ka?= <mliska@suse.cz>
To: dm-devel@redhat.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mailman-Approved-At: Mon, 11 Apr 2022 06:19:21 +0000
Subject: [dm-devel] [PATCH] Fix possibility to redefine -D_FORTIFY_SOURCE
 macro.
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

As explained here:
https://github.com/opensvc/multipath-tools/issues/29

using -Wp,-D_FORTIFY_SOURCE cannot be redefined with
-U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=3.
---
  Makefile.inc | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile.inc b/Makefile.inc
index d24da43e..cc170a2e 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -123,7 +123,7 @@ OPTFLAGS	:= -O2 -g $(STACKPROT) --param=ssp-buffer-size=4
  WARNFLAGS	:= -Werror -Wall -Wextra -Wformat=2 $(WFORMATOVERFLOW) -Werror=implicit-int \
  		  -Werror=implicit-function-declaration -Werror=format-security \
  		  $(WNOCLOBBERED) -Werror=cast-qual $(ERROR_DISCARDED_QUALIFIERS)
-CPPFLAGS	:= -Wp,-D_FORTIFY_SOURCE=2
+CPPFLAGS	:= -D_FORTIFY_SOURCE=2
  CFLAGS		:= --std=gnu99 $(CFLAGS) $(OPTFLAGS) $(WARNFLAGS) -pipe \
  		   -DBIN_DIR=\"$(bindir)\" -DLIB_STRING=\"${LIB}\" -DRUN_DIR=\"${RUN}\" \
  		   -MMD -MP
-- 
2.35.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


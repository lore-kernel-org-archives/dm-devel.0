Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42A1AC32793
	for <dm-devel@archiver.kernel.org>; Mon, 22 Aug 2022 20:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661200921;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=WsxmgyX+H6VI0gd5Fm6gm8sHP13J62r+xb5SyYnOTUQ=;
	b=Tz98BEJBsR8G2cAWlMCl4+/k+yhUh4Af856XPE5DARNcBsGxHRJA/G/VyQ0h3Tp6ysIdTI
	twb3liVXIQMN42xhE7pxcs5ccMWld5qS9IfdYWqrqw4Qj2AGGWoFL3DepE1ajzoFPnSodk
	xrXLRpOW7in6E4qbDI5NTqJS6HzHLmg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-22-xVsAXhomPkOD0IuQ1o1ZRQ-1; Mon, 22 Aug 2022 16:41:57 -0400
X-MC-Unique: xVsAXhomPkOD0IuQ1o1ZRQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AC2E23C16191;
	Mon, 22 Aug 2022 20:41:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9A3001121315;
	Mon, 22 Aug 2022 20:41:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8284B1946A63;
	Mon, 22 Aug 2022 20:41:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 169F21946A40
 for <dm-devel@listman.corp.redhat.com>; Mon, 22 Aug 2022 20:41:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F10464010D42; Mon, 22 Aug 2022 20:41:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EDB6B40C141D
 for <dm-devel@redhat.com>; Mon, 22 Aug 2022 20:41:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D55213C16187
 for <dm-devel@redhat.com>; Mon, 22 Aug 2022 20:41:52 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-373-5uFIHnYFO0uipUgvKDSQZQ-1; Mon,
 22 Aug 2022 16:41:51 -0400
X-MC-Unique: 5uFIHnYFO0uipUgvKDSQZQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id E9B2520337;
 Mon, 22 Aug 2022 20:41:49 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AD58113523;
 Mon, 22 Aug 2022 20:41:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id GAXEKA3qA2MOAwAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 22 Aug 2022 20:41:49 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 22 Aug 2022 22:41:13 +0200
Message-Id: <20220822204119.20719-6-mwilck@suse.com>
In-Reply-To: <20220822204119.20719-1-mwilck@suse.com>
References: <20220822204119.20719-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [PATCH v2 05/11] multipath-tools: Makefile: fix
 dependencies for "install" target
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
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>,
 Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

subdir.install targets should depend on subdir targets.
This is cleaner than just having "install" depend on "all".

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 82e0ea3..ffca586 100644
--- a/Makefile
+++ b/Makefile
@@ -84,7 +84,7 @@ libmultipath/checkers.install \
 $(BUILDDIRS.clean):
 	$(MAKE) -C ${@:.clean=} clean
 
-$(BUILDDIRS:=.install):
+$(BUILDDIRS:=.install): $(BUILDDIRS)
 	$(MAKE) -C ${@:.install=} install
 
 $(BUILDDIRS:=.uninstall):
@@ -93,7 +93,7 @@ $(BUILDDIRS:=.uninstall):
 clean: $(BUILDDIRS.clean)
 	rm -rf abi abi.tar.gz abi-test compile_commands.json
 
-install: all $(BUILDDIRS:=.install)
+install: $(BUILDDIRS:=.install)
 uninstall: $(BUILDDIRS:=.uninstall)
 
 test-progs:	all
-- 
2.37.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


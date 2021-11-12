Return-Path: <SRS0=25Tj=P7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18AFDC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 12 Nov 2021 21:06:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9B93461078
	for <dm-devel@archiver.kernel.org>; Fri, 12 Nov 2021 21:06:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9B93461078
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-10-y3BF4PhbMj-oXyvRqNPtaQ-1; Fri, 12 Nov 2021 16:06:22 -0500
X-MC-Unique: y3BF4PhbMj-oXyvRqNPtaQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DBD1E1927801;
	Fri, 12 Nov 2021 21:06:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D06B794A1;
	Fri, 12 Nov 2021 21:06:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 93FD94A703;
	Fri, 12 Nov 2021 21:06:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ACL6ENR016420 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 12 Nov 2021 16:06:14 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5915D112131B; Fri, 12 Nov 2021 21:06:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 547161121319
	for <dm-devel@redhat.com>; Fri, 12 Nov 2021 21:06:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 853E885A5B5
	for <dm-devel@redhat.com>; Fri, 12 Nov 2021 21:06:13 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-226-2adREm5UPeyG81Gj9Bgzdw-1; Fri, 12 Nov 2021 16:06:09 -0500
X-MC-Unique: 2adREm5UPeyG81Gj9Bgzdw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 358802199D;
	Fri, 12 Nov 2021 21:06:08 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id ECEA813CCC;
	Fri, 12 Nov 2021 21:06:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id kOOVNz/XjmGyXwAAMHmgww
	(envelope-from <mwilck@suse.com>); Fri, 12 Nov 2021 21:06:07 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 12 Nov 2021 22:05:51 +0100
Message-Id: <20211112210551.12744-3-mwilck@suse.com>
In-Reply-To: <20211112210551.12744-1-mwilck@suse.com>
References: <20211112210551.12744-1-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ACL6ENR016420
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 3/3] multipath-tools: support generating
	compile_commands.json
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

This file is necessary to run clangd as helper for an IDE, e.g.
with emacs lsp-mode.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 .gitignore | 1 +
 Makefile   | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/.gitignore b/.gitignore
index 5dbac39..8e09f95 100644
--- a/.gitignore
+++ b/.gitignore
@@ -17,6 +17,7 @@ mpathpersist/mpathpersist
 abi.tar.gz
 abi
 abi-test
+compile_commands.json
 .nfs*
 *.swp
 *.patch
diff --git a/Makefile b/Makefile
index 1cec777..82e0ea3 100644
--- a/Makefile
+++ b/Makefile
@@ -66,6 +66,12 @@ abi-test:	abi reference-abi $(wildcard abi/*.abi)
 	fi; \
 	[ $$err -eq 0 ]
 
+# Create compile_commands.json, useful for using clangd with an IDE
+# Requires bear (https://github.com/rizsotto/Bear)
+compile_commands.json: Makefile Makefile.inc $(BUILDDIRS:=/Makefile)
+	$(MAKE) clean
+	bear -- $(MAKE)
+
 libmultipath libdmmp: libmpathcmd
 libmpathpersist libmpathvalid multipath multipathd: libmultipath
 libmultipath/prioritizers libmultipath/checkers libmultipath/foreign: libmultipath
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


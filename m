Return-Path: <SRS0=25Tj=P7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18B2AC433FE
	for <dm-devel@archiver.kernel.org>; Fri, 12 Nov 2021 21:06:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9B84061076
	for <dm-devel@archiver.kernel.org>; Fri, 12 Nov 2021 21:06:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9B84061076
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-7hO-Kg4wNBaA9vZE6dvuHA-1; Fri, 12 Nov 2021 16:06:23 -0500
X-MC-Unique: 7hO-Kg4wNBaA9vZE6dvuHA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 895E9BAF84;
	Fri, 12 Nov 2021 21:06:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4805C5DEFB;
	Fri, 12 Nov 2021 21:06:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9B3A5181A1CF;
	Fri, 12 Nov 2021 21:06:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ACL6EgR016421 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 12 Nov 2021 16:06:14 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 59315112131E; Fri, 12 Nov 2021 21:06:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 546CE1121318
	for <dm-devel@redhat.com>; Fri, 12 Nov 2021 21:06:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 603861066681
	for <dm-devel@redhat.com>; Fri, 12 Nov 2021 21:06:11 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-220-Y_wQVMJ1N9yXofFOh2j71Q-1; Fri, 12 Nov 2021 16:06:09 -0500
X-MC-Unique: Y_wQVMJ1N9yXofFOh2j71Q-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DD062218B8;
	Fri, 12 Nov 2021 21:06:07 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A1AA913CCC;
	Fri, 12 Nov 2021 21:06:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id YGAzJT/XjmGyXwAAMHmgww
	(envelope-from <mwilck@suse.com>); Fri, 12 Nov 2021 21:06:07 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 12 Nov 2021 22:05:50 +0100
Message-Id: <20211112210551.12744-2-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ACL6EgR016421
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 2/3] multipath-tools: add github workflow to save
	and check ABI
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

This adds a workflow that saves the ABI of libmultipath and the
other libraries, and optionally tests it against a known-good state,
which is taken from the configurable ABI_BRANCH. If the ABI differs,
the workflow fails, and the abidiff output is saved in GH actions
as artifact "abi-test".

To configure the reference branch, set the repository secret ABI_BRANCH to the
name of the branch that contains the ABI reference. The default is "master".

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 .github/workflows/abi.yaml | 54 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)
 create mode 100644 .github/workflows/abi.yaml

diff --git a/.github/workflows/abi.yaml b/.github/workflows/abi.yaml
new file mode 100644
index 0000000..53f10d4
--- /dev/null
+++ b/.github/workflows/abi.yaml
@@ -0,0 +1,54 @@
+name: check-abi
+on:
+  - push
+  - pull_request
+env:
+  ABI_BRANCH: ${{ secrets.ABI_BRANCH }}
+
+jobs:
+  save-and-test-ABI:
+    runs-on: ubuntu-20.04
+    steps:
+      - name: set ABI branch
+        if: ${{ env.ABI_BRANCH == '' }}
+        run: echo "ABI_BRANCH=master" >> $GITHUB_ENV
+      - name: checkout
+        uses: actions/checkout@v2
+      - name: get reference ABI
+        id: reference
+        continue-on-error: true
+        uses: dawidd6/action-download-artifact@v2
+        with:
+          workflow: abi.yaml
+          branch: ${{ env.ABI_BRANCH }}
+          name: abi
+          path: reference-abi
+      - name: update
+        run: sudo apt-get update
+      - name: dependencies
+        run: >
+          sudo apt-get install --yes gcc
+          gcc make pkg-config abigail-tools
+          libdevmapper-dev libreadline-dev libaio-dev libsystemd-dev
+          libudev-dev libjson-c-dev liburcu-dev libcmocka-dev
+      - name: create ABI
+        run: make -O -j$(grep -c ^processor /proc/cpuinfo) abi.tar.gz
+      - name: save ABI
+        uses: actions/upload-artifact@v1
+        with:
+          name: abi
+          path: abi
+      - name: compare ABI against reference
+        id: compare
+        continue-on-error: true
+        if: ${{ steps.reference.outcome == 'success' }}
+        run: make abi-test
+      - name: save differences
+        if: ${{ steps.compare.outcome == 'failure' }}
+        uses: actions/upload-artifact@v1
+        with:
+          name: abi-test
+          path: abi-test
+      - name: fail
+        if: ${{ steps.compare.outcome == 'failure' }}
+        run: false
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


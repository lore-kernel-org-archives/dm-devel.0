Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53054C433FE
	for <dm-devel@archiver.kernel.org>; Wed,  1 Dec 2021 12:37:22 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-393-tfLzRO4DNVyDPngP63kqfw-1; Wed, 01 Dec 2021 07:37:17 -0500
X-MC-Unique: tfLzRO4DNVyDPngP63kqfw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EBD9E86A067;
	Wed,  1 Dec 2021 12:37:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7292D100AE22;
	Wed,  1 Dec 2021 12:37:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B5C1E1809C8A;
	Wed,  1 Dec 2021 12:37:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B1Cb8uQ008657 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 1 Dec 2021 07:37:08 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2B9681402406; Wed,  1 Dec 2021 12:37:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 27A441402400
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 12:37:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0F2F7802813
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 12:37:08 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-570-Z1SBp7iLPfen3_UxADvlSg-1; Wed, 01 Dec 2021 07:37:06 -0500
X-MC-Unique: Z1SBp7iLPfen3_UxADvlSg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0B27521155;
	Wed,  1 Dec 2021 12:37:05 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C748713FF5;
	Wed,  1 Dec 2021 12:37:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id gHXCLnBsp2GGKAAAMHmgww
	(envelope-from <mwilck@suse.com>); Wed, 01 Dec 2021 12:37:04 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed,  1 Dec 2021 13:36:30 +0100
Message-Id: <20211201123650.16240-2-mwilck@suse.com>
In-Reply-To: <20211201123650.16240-1-mwilck@suse.com>
References: <20211201123650.16240-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B1Cb8uQ008657
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 01/21] multipath tools: github workflows: add
	coverity workflow
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

From: Martin Wilck <mwilck@suse.com>

Add a workflow that triggers a coverity static analysis scan.
For now, this will only be done on a special branch called "coverity".
Pushing to that branch will trigger the workflow.

For this to work, 3 secrets need to be set in the Github repository:

COVERITY_SCAN_EMAIL: the email address for coverity/synopsis account
COVERITY_SCAN_TOKEN: the coverity / synopsis access token
COVERITY_SCAN_PROJECT: the coverity project, e.g. mwilck/multipath-tools

The workflow succeeds if upload of the coverity results was successful.
The analysis result will be emailed to the given address.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 .github/workflows/coverity.yaml | 51 +++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)
 create mode 100644 .github/workflows/coverity.yaml

diff --git a/.github/workflows/coverity.yaml b/.github/workflows/coverity.yaml
new file mode 100644
index 0000000..a8b56d4
--- /dev/null
+++ b/.github/workflows/coverity.yaml
@@ -0,0 +1,51 @@
+name: coverity
+on:
+  push:
+    branches:
+      - coverity
+
+jobs:
+  upload-coverity-scan:
+    runs-on: ubuntu-20.04
+    steps:
+      - name: checkout
+        uses: actions/checkout@v2
+      - name: dependencies
+        run: >
+          sudo apt-get install --yes
+          gcc make pkg-config
+          libdevmapper-dev libreadline-dev libaio-dev libsystemd-dev
+          libudev-dev libjson-c-dev liburcu-dev libcmocka-dev
+      - name: download coverity
+        run: >
+          curl -o cov-analysis-linux64.tar.gz
+          --form token="$COV_TOKEN"
+          --form project="$COV_PROJECT"
+          https://scan.coverity.com/download/cxx/linux64
+        env:
+          COV_TOKEN: ${{ secrets.COVERITY_SCAN_TOKEN }}
+          COV_PROJECT:  ${{ secrets.COVERITY_SCAN_PROJECT }}
+      - name: unpack coverity
+        run: |
+          mkdir -p coverity
+          tar xfz cov-analysis-linux64.tar.gz --strip 1 -C coverity
+      - name: build with cov-build
+        run: >
+          PATH="$PWD/coverity/bin:$PATH"
+          cov-build --dir cov-int make -O -j"$(grep -c ^processor /proc/cpuinfo)"
+      - name: pack results
+        run: tar cfz multipath-tools.tgz cov-int
+      - name: submit results
+        run: >
+          curl
+          --form token="$COV_TOKEN"
+          --form email="$COV_EMAIL"
+          --form file="@multipath-tools.tgz"
+          --form version="${{ github.ref_name }}"
+          --form description="$(git describe --tags --match "0.*")"
+          --form project="$COV_PROJECT"
+          https://scan.coverity.com/builds
+        env:
+          COV_TOKEN: ${{ secrets.COVERITY_SCAN_TOKEN }}
+          COV_PROJECT:  ${{ secrets.COVERITY_SCAN_PROJECT }}
+          COV_EMAIL: ${{ secrets.COVERITY_SCAN_EMAIL }}
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


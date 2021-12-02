Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ACCFC433EF
	for <dm-devel@archiver.kernel.org>; Thu,  2 Dec 2021 16:08:55 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-488-PLw08FdAPVCQojelc59zwA-1; Thu, 02 Dec 2021 11:08:50 -0500
X-MC-Unique: PLw08FdAPVCQojelc59zwA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 089AD196633D;
	Thu,  2 Dec 2021 16:08:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BE9686F950;
	Thu,  2 Dec 2021 16:08:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 889041809CB7;
	Thu,  2 Dec 2021 16:08:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B2G7aT4006838 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 2 Dec 2021 11:07:36 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 80AFF492CA3; Thu,  2 Dec 2021 16:07:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7CC9D492C38
	for <dm-devel@redhat.com>; Thu,  2 Dec 2021 16:07:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 647FB181E065
	for <dm-devel@redhat.com>; Thu,  2 Dec 2021 16:07:36 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-192-qzMf7eS4NQKBnjzFb-8nIQ-1; Thu, 02 Dec 2021 11:07:32 -0500
X-MC-Unique: qzMf7eS4NQKBnjzFb-8nIQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4B66C218A8;
	Thu,  2 Dec 2021 16:07:31 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1016A13E82;
	Thu,  2 Dec 2021 16:07:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id cAHOAUPvqGGnEgAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 02 Dec 2021 16:07:31 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu,  2 Dec 2021 17:06:46 +0100
Message-Id: <20211202160652.4576-7-mwilck@suse.com>
In-Reply-To: <20211202160652.4576-1-mwilck@suse.com>
References: <20211202160652.4576-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B2G7aT4006838
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 05/11] multipath tools: github workflows: add
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
2.34.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


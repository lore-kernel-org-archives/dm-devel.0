Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D567C433EF
	for <dm-devel@archiver.kernel.org>; Thu,  2 Dec 2021 16:08:01 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-270-7A5W9jerN0SSuNDTb8yCqw-1; Thu, 02 Dec 2021 11:07:57 -0500
X-MC-Unique: 7A5W9jerN0SSuNDTb8yCqw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 388DC1966320;
	Thu,  2 Dec 2021 16:07:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 167315F4E9;
	Thu,  2 Dec 2021 16:07:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DBD2C1809C89;
	Thu,  2 Dec 2021 16:07:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B2G7aLI006832 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 2 Dec 2021 11:07:36 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1E9BD4047279; Thu,  2 Dec 2021 16:07:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1AB5F4047272
	for <dm-devel@redhat.com>; Thu,  2 Dec 2021 16:07:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F1F54800141
	for <dm-devel@redhat.com>; Thu,  2 Dec 2021 16:07:35 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-517-qa8clCY0MEy07Y7jmTuwZw-1; Thu, 02 Dec 2021 11:07:32 -0500
X-MC-Unique: qa8clCY0MEy07Y7jmTuwZw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 010B2218A4;
	Thu,  2 Dec 2021 16:07:31 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BCF9F13E82;
	Thu,  2 Dec 2021 16:07:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id gGAWLELvqGGnEgAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 02 Dec 2021 16:07:30 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu,  2 Dec 2021 17:06:45 +0100
Message-Id: <20211202160652.4576-6-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B2G7aLI006832
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 04/11] multipath-tools: github workflows: rebuild
	containers for rolling distros
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

For Debian "sid" and alpine, using a pre-built container makes
no sense if this container is rebuilt only once every few months.
Rebuild these containers during the test. Also, add Fedora rawhide,
which is likely to ship the latest compilers.

Wrt stable distributions, replace fedora-34 with fedora-35 and add
Debian 11 (bullseye).

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 .github/workflows/native.yaml | 62 +++++++++++++++++++++++++++++++++--
 1 file changed, 60 insertions(+), 2 deletions(-)

diff --git a/.github/workflows/native.yaml b/.github/workflows/native.yaml
index 2bb1886..19c9e29 100644
--- a/.github/workflows/native.yaml
+++ b/.github/workflows/native.yaml
@@ -8,15 +8,17 @@ on:
   pull_request:
 
 jobs:
-  build-and-test:
+  stable:
     runs-on: ubuntu-20.04
     strategy:
       matrix:
-        os: [buster, jessie, sid, alpine, fedora-34]
+        os: [buster, jessie, bullseye, fedora-35]
         arch: ['', '-i386']
         exclude:
           - os: fedora-34
             arch: '-i386'
+          - os: fedora-35
+            arch: '-i386'
     container: mwilck/multipath-build-${{ matrix.os }}${{ matrix.arch }}
     steps:
       - name: checkout
@@ -30,3 +32,59 @@ jobs:
           CC: clang
         run: make test
 
+  rolling:
+    runs-on: ubuntu-20.04
+    strategy:
+      matrix:
+        os: ['debian:sid', 'alpine', 'fedora:rawhide']
+        arch: ['amd64', 'i386']
+        exclude:
+          - os: 'fedora:rawhide'
+            arch: 'i386'
+    container: ${{ matrix.arch }}/${{ matrix.os }}
+    steps:
+      - name: update
+        if: ${{ matrix.os == 'debian:sid' }}
+        run: apt-get update
+      - name: dependencies-debian
+        if: ${{ matrix.os == 'debian:sid' }}
+        run: >
+          apt-get install --yes -o APT::Immediate-Configure=0
+          gcc clang make pkg-config
+          libdevmapper-dev
+          libreadline-dev
+          libaio-dev
+          libudev-dev
+          libjson-c-dev
+          liburcu-dev
+          libcmocka-dev
+      - name: dependencies-alpine
+        if: ${{ matrix.os == 'alpine' }}
+        run: >
+          apk add make gcc clang cmocka
+          musl-dev lvm2-dev libaio-dev readline-dev ncurses-dev eudev-dev
+          userspace-rcu-dev json-c-dev cmocka-dev
+      - name: dependencies-fedora
+        if: ${{ matrix.os == 'fedora:rawhide' }}
+        run: >
+          dnf install -y
+          make clang gcc pkgconfig
+          libaio-devel
+          device-mapper-devel
+          libselinux-devel
+          libsepol-devel
+          readline-devel
+          ncurses-devel
+          userspace-rcu-devel
+          json-c-devel
+          libcmocka-devel
+      - name: checkout
+        uses: actions/checkout@v1
+      - name: build and test
+        run: make test
+      - name: clean
+        run: make clean
+      - name: clang
+        env:
+          CC: clang
+        run: make test
-- 
2.34.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


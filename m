Return-Path: <SRS0=sRxI=IY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01CE2C433E0
	for <dm-devel@archiver.kernel.org>; Fri, 26 Mar 2021 21:30:32 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 950E661A24
	for <dm-devel@archiver.kernel.org>; Fri, 26 Mar 2021 21:30:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 950E661A24
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-584-D7fwEk0fNLqkxU4jdiAhWQ-1; Fri, 26 Mar 2021 17:30:28 -0400
X-MC-Unique: D7fwEk0fNLqkxU4jdiAhWQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 60D6B83DC24;
	Fri, 26 Mar 2021 21:30:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4327789D09;
	Fri, 26 Mar 2021 21:30:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 13753180B450;
	Fri, 26 Mar 2021 21:30:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12QLU9JU001696 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 26 Mar 2021 17:30:09 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8767D1037AD; Fri, 26 Mar 2021 21:30:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 813491037AF
	for <dm-devel@redhat.com>; Fri, 26 Mar 2021 21:30:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B66E1803AFD
	for <dm-devel@redhat.com>; Fri, 26 Mar 2021 21:30:05 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-333-yzXyH4T1N6idkiSP-CYanQ-1;
	Fri, 26 Mar 2021 17:30:01 -0400
X-MC-Unique: yzXyH4T1N6idkiSP-CYanQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 9BE06ADDD;
	Fri, 26 Mar 2021 21:29:59 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 26 Mar 2021 22:29:40 +0100
Message-Id: <20210326212944.3136-4-mwilck@suse.com>
In-Reply-To: <20210326212944.3136-1-mwilck@suse.com>
References: <20210326212944.3136-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12QLU9JU001696
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 3/7] github workflows: add containerized /
	multi-arch tests
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Until now, our CI only tested builds on Ubuntu, the default github
runner. This commit adds containerized build/test workflows, which can cover a
much larger range of distributions and environments.

I've distinguished "native" runs, where the architecture is compatible with
the architecture of the runners (assumed to be x86_64), and "foreign" runs
with different architectures. The former can run "make test" just like in
any ordinary environment. To run tests in "foreign arch" environments,
I use qemu-user for runtime emulation. That's done with the help of the
"multiarch/qemu-user-static" container. Runtime containers for testing need
to have the qemu-user-static binary (compiled for x86_64) for their target
architecture built in. In theory, we could do the same thing for build
containers too, but it would be grossly inefficient. Instead, I've focused
on Debian environments for the foreign architectures, relying on Debian's
nice multiarch / cross-compilation features. Compilation is run in a dedicated
cross-build container, and only the test runs are carried out in the emulation.

The set of tests currently includes:

native:
 - Debian Jessie, x86_64/i386 (gcc 4.9, clang 3.5, glibc 2.19)
 - Debian Buster, x86_64/i386 (gcc 8.3, clang 7.0, glibc 2.28)
 - Debian Sid, x86_64/i386 (gcc 10.2, clang 11.0, glibc 2.31)
 - Alpine, x86_64/i386 (gcc 10.2, clang 10.0, musl libc 1.2)
 - Fedora 34, x86_64 (gcc 11.0, clang 12.0, glibc 2.33)

foreign:
 - Debian Buster, ppc64le/aarch64/s390x

This covers a rather broad range of compiler and C library versions and
should be fine for some time to come.

Note: In theory, it would be possible to just fetch base containers
via github actions, and install the dependencies as part of the build
procedure. But that would be quite resource-intensive and slow. Therefore
I've decided to use pre-built containers. The current container setup
fetches containers from my docker hub repository. The containers there
(multipath-build-$os-$arch and multipath-run-$os-$arch) come from my
"build-multipath" repository (https://github.com/mwilck/build-multipath),
and are created via github actions, too. The upload of the built container
images to docker hub requires the use of tokens and secrets.

I'd considered adding these container definitions and workflows to the
multipath-tools repository. We'd just need to create reasonable rules
for running the respective workflows. I expect these container images
to remain relatively stable; it makes no sense to rebuild the images
for every multipath-tools commit.

Tell me if you want this in the multipath-tools repo, and if you're ok
with hosting the images in my docker hub repo.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 .github/workflows/build-and-unittest.yaml |  4 +-
 .github/workflows/foreign.yaml            | 65 +++++++++++++++++++++++
 .github/workflows/native.yaml             | 31 +++++++++++
 3 files changed, 99 insertions(+), 1 deletion(-)
 create mode 100644 .github/workflows/foreign.yaml
 create mode 100644 .github/workflows/native.yaml

diff --git a/.github/workflows/build-and-unittest.yaml b/.github/workflows/build-and-unittest.yaml
index 4173576..bf37b13 100644
--- a/.github/workflows/build-and-unittest.yaml
+++ b/.github/workflows/build-and-unittest.yaml
@@ -1,5 +1,7 @@
 name: basic-build-and-ci
-on:   [push]
+on:
+  push:
+    branches: [master queue tip]
 jobs:
   bionic:
     runs-on: ubuntu-18.04
diff --git a/.github/workflows/foreign.yaml b/.github/workflows/foreign.yaml
new file mode 100644
index 0000000..505a777
--- /dev/null
+++ b/.github/workflows/foreign.yaml
@@ -0,0 +1,65 @@
+name: compile and unit test on foreign arch
+on:
+  push:
+    branches:
+      - master
+      - queue
+      - tip
+
+jobs:
+
+  build:
+    runs-on: ubuntu-20.04
+    strategy:
+      matrix:
+        os: [buster]
+        arch: ['ppc64le', 'aarch64', 's390x']
+    container: mwilck/multipath-build-${{ matrix.os }}-${{ matrix.arch }}
+    steps:
+      - name: checkout
+        uses: actions/checkout@v1
+      - name: build and test
+        if: ${{ matrix.arch == '' || matrix.arch == '-i386' }}
+        run: make test
+      - name: build
+        if: ${{ matrix.arch != '' && matrix.arch != '-i386' }}
+        run: make test-progs
+      - name: archive
+        if: ${{ matrix.arch != '' && matrix.arch != '-i386' }}
+        run: >
+          tar cfv binaries.tar
+          Makefile*
+          libmpathcmd/*.so* libmultipath/*.so*
+          tests/lib tests/*-test tests/Makefile tests/*.so*
+      - uses: actions/upload-artifact@v1
+        if: ${{ matrix.arch != '' && matrix.arch != '-i386' }}
+        with:
+          name: multipath-${{ matrix.os }}-${{ matrix.arch }}
+          path: binaries.tar
+
+  test:
+    runs-on: ubuntu-20.04
+    needs: build
+    strategy:
+      matrix:
+        os: [buster]
+        arch: ['ppc64le', 'aarch64', 's390x']
+    steps:
+      - name: get binaries
+        uses: actions/download-artifact@v1
+        with:
+          name: multipath-${{ matrix.os }}-${{ matrix.arch }}
+      - name: unpack
+        run: tar xfv multipath-${{ matrix.os }}-${{ matrix.arch }}/binaries.tar
+      - name: enable foreign arch
+        run: sudo docker run --rm --privileged multiarch/qemu-user-static:register --reset
+      - name: run tests
+        # Github actions doesn't support referencing docker images with
+        # context variables. Workaround: use mosteo-actions/docker-run action
+        # See https://github.community/t/expressions-in-docker-uri/16271
+        uses: mosteo-actions/docker-run@v1
+        with:
+          image: mwilck/multipath-run-${{ matrix.os }}-${{ matrix.arch }}
+          # The runner is an image that has "make" as entrypoint
+          # So run "make -C tests" here
+          command: -C tests
diff --git a/.github/workflows/native.yaml b/.github/workflows/native.yaml
new file mode 100644
index 0000000..abd39a0
--- /dev/null
+++ b/.github/workflows/native.yaml
@@ -0,0 +1,31 @@
+name: compile and unit test on native arch
+on:
+  push:
+    branches:
+      - master
+      - queue
+      - tip
+
+jobs:
+  build-and-test:
+    runs-on: ubuntu-20.04
+    strategy:
+      matrix:
+        os: [buster, jessie, sid, alpine, fedora-34]
+        arch: ['', '-i386']
+        exclude:
+          - os: fedora-34
+            arch: '-i386'
+    container: mwilck/multipath-build-${{ matrix.os }}${{ matrix.arch }}
+    steps:
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
+
-- 
2.30.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

